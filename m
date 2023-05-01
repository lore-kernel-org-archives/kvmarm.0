Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F7E420F8
	for <kvmarm@lists.linux.dev>; Mon,  1 May 2023 12:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1682945338;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PWad9w4sdvrJZTVU5kOVCYkO3f9hEPYY7626pqbBzYk=;
	b=LFAGvrAOtD8kECyvrrNFveQPoy3C6KtmD14llUX9MBHgN8h++opOIcRNNy2NF41hKlJByA
	V6GLc5UCRFrZ595SrAWihzpbsiIqmH4B9sloxokeD7EfSKhqEyr6glyMLyIH0b3jNYNagu
	l1cMneekg+RrdJwnLD52c7KwITtc4gM=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-149-7lHtJ1nxNlKrwiE5e2dUow-1; Mon, 01 May 2023 08:48:57 -0400
X-MC-Unique: 7lHtJ1nxNlKrwiE5e2dUow-1
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-64110c31dabso465257b3a.1
        for <kvmarm@lists.linux.dev>; Mon, 01 May 2023 05:48:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682945336; x=1685537336;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PWad9w4sdvrJZTVU5kOVCYkO3f9hEPYY7626pqbBzYk=;
        b=FricbjdNrFzgLWP1bD7xHJOmdMHqlP9wq9GIzEvHBy22FyMgfzo4CKHM+86JchmCoj
         kCnbSRGRy2kiRpwOcdcObE7ojJGvPwdjf6Bp6BOHlqi2B0X5PKx65+H/kh3NFcmGKBVJ
         RoNA4W4rI39a2JNWnhSc0VEDt9s5Y4V5/7tL8fXSXqgMVd0RwFdHK9xwREGlv8cFdj7s
         Q0RMFhqNRcH6L2HnnMrR+3Q1Pg+wmu261CNfoFu5CTuErQ0T9pUsxS7DH1nIRsINQpJf
         dnVCa+UCCMD7E/w0sJS40vwhd8YztT1xoQnovJZH0eGrj2nMyZJEyiMwLlf1MiPUF+Ao
         u/Ig==
X-Gm-Message-State: AC+VfDwwOmTJeqKHYR+vEDg7oisW9CdVX9XIlK+YoheOt5ZVwuwlThs8
	wkxsTTrsm1hBPEzDOsOr9grcCAt9vWPrZSiHjhod+VVBnpP5SlQjR6yUuf+rteoKh6m+OG13Kro
	bsjQifSZ7ttm0GMBJ
X-Received: by 2002:a05:6a00:1a0f:b0:63d:3a18:49fd with SMTP id g15-20020a056a001a0f00b0063d3a1849fdmr16231023pfv.2.1682945335786;
        Mon, 01 May 2023 05:48:55 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7R+XW5yARMhCaNUz3uZ8bssisrRfx/1EEjNh9s5GOPg9cqVC6Y6nxghRp3CFktVri7o4ur4A==
X-Received: by 2002:a05:6a00:1a0f:b0:63d:3a18:49fd with SMTP id g15-20020a056a001a0f00b0063d3a1849fdmr16231011pfv.2.1682945335443;
        Mon, 01 May 2023 05:48:55 -0700 (PDT)
Received: from [10.66.61.39] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id t1-20020a62d141000000b0063b8ce0e860sm19801872pfl.21.2023.05.01.05.48.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 May 2023 05:48:55 -0700 (PDT)
Message-ID: <bd151928-c94b-73aa-dbd9-289e4213db7a@redhat.com>
Date: Mon, 1 May 2023 20:48:51 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [kvm-unit-tests PATCH v5 29/29] arm64: Add an efi/run script
To: Nikos Nikoleris <nikos.nikoleris@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev, andrew.jones@linux.dev
Cc: pbonzini@redhat.com, alexandru.elisei@arm.com, ricarkol@google.com
References: <20230428120405.3770496-1-nikos.nikoleris@arm.com>
 <20230428120405.3770496-30-nikos.nikoleris@arm.com>
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20230428120405.3770496-30-nikos.nikoleris@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Currently, it seems not support:

./run_test.sh -j8

Since different test will write the startup.nsh to the same directory, 
which will make something wrong.

But that's fine right now. We can improve it later.

On 4/28/23 20:04, Nikos Nikoleris wrote:
> This change adds a efi/run script inspired by the one in x86. This
> script will setup a folder with the test compiled as an EFI app and a
> startup.nsh script. The script launches QEMU providing an image with
> EDKII and the path to the folder with the test which is executed
> automatically.
> 
> For example:
> 
> $> ./arm/efi/run ./arm/selftest.efi -append "setup smp=2 mem=256" -smp 2 -m 256
> 
> Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
> Reviewed-by: Ricardo Koller <ricarkol@google.com>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>

> ---
>   scripts/runtime.bash | 13 +++++++---
>   arm/efi/run          | 61 ++++++++++++++++++++++++++++++++++++++++++++
>   arm/run              | 14 +++++++---
>   arm/Makefile.common  |  1 +
>   arm/dummy.c          | 12 +++++++++
>   5 files changed, 94 insertions(+), 7 deletions(-)
>   create mode 100755 arm/efi/run
>   create mode 100644 arm/dummy.c
> 
> diff --git a/scripts/runtime.bash b/scripts/runtime.bash
> index 07b62b0e..785a7b62 100644
> --- a/scripts/runtime.bash
> +++ b/scripts/runtime.bash
> @@ -130,11 +130,18 @@ function run()
>           done
>       fi
>   
> -    last_line=$(premature_failure > >(tail -1)) && {
> +    log=$(premature_failure) && {
>           skip=true
> -        if [ "${CONFIG_EFI}" == "y" ] && [[ "${last_line}" =~ "Dummy Hello World!" ]]; then
> -            skip=false
> +        if [ "${CONFIG_EFI}" == "y" ]; then
> +            if [ "$ARCH" == "x86_64" ] &&
> +               [[ "$(tail -1 <<<"$log")" =~ "Dummy Hello World!" ]]; then
> +                   skip=false
> +            elif [ "$ARCH" == "arm64" ] &&
> +               [[ "$(tail -2 <<<"$log" | head -1)" =~ "Dummy Hello World!" ]]; then
> +                   skip=false
> +            fi
>           fi
> +
>           if [ ${skip} == true ]; then
>               print_result "SKIP" $testname "" "$last_line"
>               return 77
> diff --git a/arm/efi/run b/arm/efi/run
> new file mode 100755
> index 00000000..dfff717a
> --- /dev/null
> +++ b/arm/efi/run
> @@ -0,0 +1,61 @@
> +#!/bin/bash
> +
> +set -e
> +
> +if [ $# -eq 0 ]; then
> +	echo "Usage $0 TEST_CASE [QEMU_ARGS]"
> +	exit 2
> +fi
> +
> +if [ ! -f config.mak ]; then
> +	echo "run './configure --enable-efi && make' first. See ./configure -h"
> +	exit 2
> +fi
> +source config.mak
> +source scripts/arch-run.bash
> +source scripts/common.bash
> +
> +: "${EFI_SRC:=$(realpath "$(dirname "$0")/../")}"
> +: "${EFI_UEFI:=/usr/share/qemu-efi-aarch64/QEMU_EFI.fd}"
> +: "${EFI_TEST:=efi-tests}"
> +: "${EFI_CASE:=$(basename $1 .efi)}"
> +
> +if [ ! -f "$EFI_UEFI" ]; then
> +	echo "UEFI firmware not found: $EFI_UEFI"
> +	echo "Please install the UEFI firmware to this path"
> +	echo "Or specify the correct path with the env variable EFI_UEFI"
> +	exit 2
> +fi
> +
> +# Remove the TEST_CASE from $@
> +shift 1
> +
> +# Fish out the arguments for the test, they should be the next string
> +# after the "-append" option
> +qemu_args=()
> +cmd_args=()
> +while (( "$#" )); do
> +	if [ "$1" = "-append" ]; then
> +		cmd_args=$2
> +		shift 2
> +	else
> +		qemu_args+=("$1")
> +		shift 1
> +	fi
> +done
> +
> +if [ "$EFI_CASE" = "_NO_FILE_4Uhere_" ]; then
> +	EFI_CASE=dummy
> +fi
> +
> +: "${EFI_CASE_DIR:="$EFI_TEST/$EFI_CASE"}"
> +mkdir -p "$EFI_CASE_DIR"
> +
> +cp "$EFI_SRC/$EFI_CASE.efi" "$EFI_TEST/$EFI_CASE/"
> +echo "@echo -off" > "$EFI_TEST/$EFI_CASE/startup.nsh"
> +echo "$EFI_CASE.efi" "${cmd_args[@]}" >> "$EFI_TEST/$EFI_CASE/startup.nsh"
> +
> +EFI_RUN=y $TEST_DIR/run \
> +       -bios "$EFI_UEFI" \
> +       -drive file.dir="$EFI_TEST/$EFI_CASE/",file.driver=vvfat,file.rw=on,format=raw,if=virtio \
> +       "${qemu_args[@]}"
> diff --git a/arm/run b/arm/run
> index c6f25b8c..de520c11 100755
> --- a/arm/run
> +++ b/arm/run
> @@ -64,8 +64,10 @@ if ! $qemu $M -chardev '?' | grep -q testdev; then
>   	exit 2
>   fi
>   
> -chr_testdev='-device virtio-serial-device'
> -chr_testdev+=' -device virtconsole,chardev=ctd -chardev testdev,id=ctd'
> +if [ "$EFI_RUN" != "y" ]; then
> +	chr_testdev='-device virtio-serial-device'
> +	chr_testdev+=' -device virtconsole,chardev=ctd -chardev testdev,id=ctd'
> +fi
>   
>   pci_testdev=
>   if $qemu $M -device '?' | grep -q pci-testdev; then
> @@ -74,7 +76,11 @@ fi
>   
>   A="-accel $ACCEL"
>   command="$qemu -nodefaults $M $A -cpu $processor $chr_testdev $pci_testdev"
> -command+=" -display none -serial stdio -kernel"
> +command+=" -display none -serial stdio"
>   command="$(migration_cmd) $(timeout_cmd) $command"
>   
> -run_qemu $command "$@"
> +if [ "$EFI_RUN" = "y" ]; then
> +	ENVIRON_DEFAULT=n run_qemu_status $command "$@"
> +else
> +	run_qemu $command -kernel "$@"
> +fi
> diff --git a/arm/Makefile.common b/arm/Makefile.common
> index a133309d..d60cf8cd 100644
> --- a/arm/Makefile.common
> +++ b/arm/Makefile.common
> @@ -12,6 +12,7 @@ tests-common += $(TEST_DIR)/gic.$(exe)
>   tests-common += $(TEST_DIR)/psci.$(exe)
>   tests-common += $(TEST_DIR)/sieve.$(exe)
>   tests-common += $(TEST_DIR)/pl031.$(exe)
> +tests-common += $(TEST_DIR)/dummy.$(exe)
>   
>   tests-all = $(tests-common) $(tests)
>   all: directories $(tests-all)
> diff --git a/arm/dummy.c b/arm/dummy.c
> new file mode 100644
> index 00000000..7033bb7c
> --- /dev/null
> +++ b/arm/dummy.c
> @@ -0,0 +1,12 @@
> +#include "libcflat.h"
> +
> +int main(int argc, char **argv)
> +{
> +	/*
> +	 * scripts/runtime.bash uses this test as a canary to determine if the
> +	 * basic setup is functional.  Print a magic string to let runtime.bash
> +	 * know that all is well.
> +	 */
> +	printf("Dummy Hello World!");
> +	return 0;
> +}

-- 
Shaoqin

