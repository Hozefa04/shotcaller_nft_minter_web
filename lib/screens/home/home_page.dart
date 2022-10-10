import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_strings.dart';
import '../../utils/app_styles.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_loader.dart';
import '../../widgets/custom_text_field.dart';
import 'bloc/home_bloc.dart';

final TextEditingController nameController = TextEditingController();
final TextEditingController descriptionController = TextEditingController();
final TextEditingController amountController = TextEditingController();

String dropDownValue = 'Base';

var types = [
  'Base',
  'Rare',
  'Epic',
  'Legendary',
];

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: MintPageContent(),
    );
  }
}

class MintPageContent extends StatelessWidget {
  const MintPageContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: ResponsiveBuilder(builder: (context, sizingInformation) {
        if (sizingInformation.deviceScreenType == DeviceScreenType.desktop) {
          return const DesktopView();
        }
        if (sizingInformation.deviceScreenType == DeviceScreenType.mobile ||
            sizingInformation.deviceScreenType == DeviceScreenType.tablet) {
          return const MobileView();
        }
        return const MobileView();
      }),
    );
  }
}

class DesktopView extends StatelessWidget {
  const DesktopView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const MintText(),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              ImageView(),
              SizedBox(width: 42),
              Divider(),
              SizedBox(width: 42),
              SizedBox(
                width: 450,
                child: SingleChildScrollView(child: TextInputColumn()),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class MobileView extends StatelessWidget {
  const MobileView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const MintText(size: 22),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                ImageView(),
                SizedBox(
                  width: 450,
                  child: TextInputColumn(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class TextInputColumn extends StatelessWidget {
  const TextInputColumn({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: const [
        NameInput(),
        SizedBox(height: 22),
        DescriptionInput(),
        SizedBox(height: 22),
        AmountInput(),
        SizedBox(height: 22),
        TypeInput(),
        SizedBox(height: 22),
        ImageInput(),
        MetadataInput(),
        MintStateText(),
        MintButton(),
        SizedBox(height: 32),
      ],
    );
  }
}

class ImageView extends StatefulWidget {
  const ImageView({
    Key? key,
  }) : super(key: key);

  @override
  State<ImageView> createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  bool isSet = false;
  late Uint8List imgBytes;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 350,
      height: MediaQuery.of(context).size.height * 0.6,
      child: Center(
        child: BlocConsumer<HomeBloc, HomeState>(
          listener: (context, state) async {
            if (state is ImageStored) {
              imgBytes = state.image.bytes!;
              setState(() {
                isSet = true;
              });
            }
          },
          builder: (context, state) {
            if (isSet) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.primaryColor),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.memory(
                    imgBytes,
                    width: 250,
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            }
            return Container(
              width: 250,
              height: 250,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.appFontColor,
                ),
              ),
              child: Center(
                child: Text(
                  AppStrings.imagePlaceholder,
                  style: AppStyles.smallTextStyleBold,
                  textAlign: TextAlign.center,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class Divider extends StatelessWidget {
  const Divider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 4,
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}

class NameInput extends StatelessWidget {
  const NameInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      hintText: AppStrings.tokenNameText,
      controller: nameController,
    );
  }
}

class DescriptionInput extends StatelessWidget {
  const DescriptionInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      hintText: AppStrings.descriptionText,
      minLines: 3,
      maxLines: 5,
      controller: descriptionController,
    );
  }
}

class AmountInput extends StatelessWidget {
  const AmountInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      hintText: AppStrings.amountText,
      controller: amountController,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly
      ],
    );
  }
}

class TypeInput extends StatefulWidget {
  const TypeInput({Key? key}) : super(key: key);

  @override
  State<TypeInput> createState() => _TypeInputState();
}

class _TypeInputState extends State<TypeInput> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            AppStrings.typeText,
            style: AppStyles.smallTextStyleBold,
          ),
          DropdownButton(
            onChanged: (item) {
              setState(() {
                dropDownValue = item.toString();
              });
            },
            items: types.map((item) {
              return DropdownMenuItem(child: Text(item), value: item);
            }).toList(),
            value: dropDownValue,
            style: AppStyles.smallTextStyleBold,
            dropdownColor: AppColors.whiteColor,
          ),
        ],
      ),
    );
  }
}

class ImageInput extends StatelessWidget {
  const ImageInput({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is ImageStored) {
          return Column(
            children: [
              CustomTextField(
                hintText: state.image.name,
                readOnly: true,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                onTap: () {
                  BlocProvider.of<HomeBloc>(context).add(const StoreImage());
                },
              ),
              const SizedBox(height: 32),
            ],
          );
        }
        if (state is MetadataStored || state is ImageUploaded) {
          return Container();
        }
        return Column(
          children: [
            CustomTextField(
              hintText: AppStrings.imageText,
              readOnly: true,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              onTap: () {
                BlocProvider.of<HomeBloc>(context).add(const StoreImage());
              },
            ),
            const SizedBox(height: 32),
          ],
        );
      },
    );
  }
}

class MetadataInput extends StatelessWidget {
  const MetadataInput({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is MetadataStored) {
          return Column(
            children: [
              CustomTextField(
                hintText: state.fileName,
                readOnly: true,
                onTap: () {
                  BlocProvider.of<HomeBloc>(context).add(
                    const StoreMetadata(),
                  );
                },
              ),
              const SizedBox(height: 32),
            ],
          );
        }
        if (state is ImageUploaded) {
          return Column(
            children: [
              CustomTextField(
                hintText: AppStrings.metaText,
                readOnly: true,
                onTap: () {
                  BlocProvider.of<HomeBloc>(context).add(
                    const StoreMetadata(),
                  );
                },
              ),
              const SizedBox(height: 32),
            ],
          );
        }
        return Container();
      },
    );
  }
}

class MintText extends StatelessWidget {
  final double size;
  const MintText({Key? key, this.size = 32}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 42),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              AppStrings.appLogo,
              width: 50,
              height: 50,
            ),
          ),
          const SizedBox(width: 22),
          Text(
            AppStrings.mintText,
            style: AppStyles.headingStyleBold.copyWith(
              fontSize: size,
            ),
          ),
        ],
      ),
    );
  }
}

class MintButton extends StatelessWidget {
  const MintButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is ImageUploading ||
            state is CreatingMetadata ||
            state is MetadataCreated ||
            state is MetadataUploading) {
          return Container();
        }
        if (state is ImageUploaded || state is MetadataStored) {
          return CustomButton(
            text: AppStrings.mintButton,
            onPressed: () {
              BlocProvider.of<HomeBloc>(context).add(
                UploadMetadata(amountController.text),
              );
            },
          );
        }
        return CustomButton(
          text: AppStrings.imageButton,
          onPressed: () {
            BlocProvider.of<HomeBloc>(context).add(
              UploadImage(
                nameController.text,
                descriptionController.text,
                dropDownValue,
                amountController.text,
              ),
            );
          },
        );
      },
    );
  }
}

class MintStateText extends StatelessWidget {
  const MintStateText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is MintComplete ||
            state is ImageError ||
            state is MetadataError ||
            state is MintError) {
          nameController.clear();
          descriptionController.clear();
        }
      },
      builder: (context, state) {
        if (state is ImageUploading) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppStrings.uploadingImage,
                style: AppStyles.smallTextStyleBold,
              ),
              const SizedBox(width: 8),
              const CustomLoader(size: 22),
            ],
          );
        }
        if (state is MetadataUploading) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppStrings.uploadingMetadata,
                style: AppStyles.smallTextStyleBold,
              ),
              const SizedBox(width: 8),
              const CustomLoader(size: 22),
            ],
          );
        }
        if (state is MintComplete) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppStrings.mintFlowComplete,
                style: AppStyles.smallTextStyleBold,
              ),
              const SizedBox(height: 32),
            ],
          );
        }
        if (state is ImageError) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppStrings.imageError,
                style: AppStyles.errorText,
              ),
              const SizedBox(height: 32),
            ],
          );
        }
        if (state is CreatingMetadata) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppStrings.creatingMeta,
                style: AppStyles.smallTextStyleBold,
              ),
              const SizedBox(width: 8),
              const CustomLoader(size: 22),
            ],
          );
        }
        if (state is MetadataCreated) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppStrings.minting,
                style: AppStyles.smallTextStyleBold,
              ),
              const SizedBox(width: 8),
              const CustomLoader(size: 22),
            ],
          );
        }
        if (state is MetadataError) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppStrings.metaError,
                style: AppStyles.errorText,
              ),
              const SizedBox(height: 32),
            ],
          );
        }
        if (state is MintError) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppStrings.mintError,
                style: AppStyles.errorText,
              ),
              const SizedBox(height: 32),
            ],
          );
        }
        return Container();
      },
    );
  }
}
