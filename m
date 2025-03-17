Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D7E88634E
	for <kvmarm@lists.linux.dev>; Mon, 17 Mar 2025 08:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742201619; cv=none; b=F49vKUa0znpwvbxTKYr96XH+vXi+IdBHgxs0FL0P+zTWHIpF16+dPP6fHSpDsIQPFJZ5C9nluk52YbrO6XUVwdcf2wHzTZhLyro2XI51VGWA+qv5d+i2h1Lqarigzn5cRrSDUNa4qSELIvCJP3sAJqx3BOM8q687wVwWcxp8g3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742201619; c=relaxed/simple;
	bh=aq2spCsdG3P3lfElF89LUbXKEryZhClx9wsvSo0M+Hk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mBGH6CjrpOkGyyqC6P3soUF6kq4+JaTpkJsCkTUdmQ45lw/+myPSnxwsQw8RPEHa6tSoPDn7VAynDzu3knxNRJDd3VgZp6E2ED7fWQryGRhguQY54f357fL1xknNBdRg6s+CGJkOBoiheKOqrNh2YxXldM8gsTeB/n+9zUr0S98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ovjl4ZGz; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ovjl4ZGz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742201616;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8Z0UeEMmq83xCl69Q71PKJopRqUbkXECgaGSxsoBFy8=;
	b=Ovjl4ZGzTzvcdLTJFhEuHTpFC3A/hMUdAOjSvYdnNdm4HOCyjqQZCl1OKx3LjABSP4ubFF
	YZTk1Yp6DCdOMiFmcj4aFvrbxulfwnvQa06Ane1adcMJROkGvRkujkHcWA7yTcOhMCFACz
	Hr3NUJ7EKpZQDb7+Fll8Bt7Nsg85OkQ=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-674-ruoBCMWHNjqH8wh3MDqyBw-1; Mon, 17 Mar 2025 04:53:18 -0400
X-MC-Unique: ruoBCMWHNjqH8wh3MDqyBw-1
X-Mimecast-MFC-AGG-ID: ruoBCMWHNjqH8wh3MDqyBw_1742201597
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-85b34bd03c4so614463139f.3
        for <kvmarm@lists.linux.dev>; Mon, 17 Mar 2025 01:53:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742201597; x=1742806397;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8Z0UeEMmq83xCl69Q71PKJopRqUbkXECgaGSxsoBFy8=;
        b=GtWzSAghvQT7PibXs6dl5MdCJajKzhAf61zivkClw3vHShZLIKznwT8nSfgyCJ42BG
         3M06RzmaoojOdb4rPOq1VOEmwrUel33g32ROgHTPlacwKlnhuFOAvQvqqchffL0Hpm3b
         JiPc8RSV+YER//eUmnXlwip0tcz+cL7RAJ/dUSZJXPrMmbgdUlxFvDD24nDt3l03V83N
         fduXMK9/bRuMa26ptwGA/4NvbcbFjfFNd7wwvFwe/XCuM6nThDCEtHOF7c3XaXbcH4MP
         uY6duDPr2gb1SpFcoTD+ZKCBVeqMuQf1NVWk7C3KBWzcH7bQMvzq92xA0tPQm9rIvdDR
         0bxQ==
X-Gm-Message-State: AOJu0Yx7mDvNbhAu3sL3xa+1FbKLLI1SocPrzPCzzfpA811xnVIRY1uo
	lZRIVFn5uDITWtfGKiUEEaPCOUEn6nGTCexmx6SfpWIuFlYNzWC4bCSGAB3lccuQMsEUOvL8GX7
	8Y8RsllRZVrvpKueYyVdH595jUvVSpWAgQ/I07QnUkdeEUdDGH81qiQ==
X-Gm-Gg: ASbGnctUIA4jk3ch4xYZzOUcbUU67Gozh8D8b2oZ7aiyRY237v9HfStnZCIJbS/Zxtu
	HIrOO3e03TEs4Rnib51ABvd1YY1Qm9V/c2yVP8yoG7mpFhQsWeR0gt32mqh28zOab5/j8iF/DSZ
	zFPBJzmVoX+SoVBspUIXXmZdzABH1n0H6qLF62v/wGn5aqXvan+Q8SpbrKuFChZvlRd4Y/XpdEE
	Sz0Me88HjG/owktv2+/6FJUaX2K3UIi+8s57rw6BLR7DlWchJt4Lr/kZEomXcgZ2mR9smbsV6fZ
	dT1n98bGpUyUTMYv8B3+3UlWgBBaja6vGKThXcXTVxyalHXX10YvtvV15I/Qcy4=
X-Received: by 2002:a05:6602:2cd6:b0:85b:4d28:2aa9 with SMTP id ca18e2360f4ac-85dc4792a8dmr1487055539f.4.1742201597317;
        Mon, 17 Mar 2025 01:53:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFhvA6uoxE9FkDt+/PrcVIKJmkPlXjaFVJVOpZAvngURmdObKJVrgiM4GTTPXD1x6LoFTwjrg==
X-Received: by 2002:a05:6602:2cd6:b0:85b:4d28:2aa9 with SMTP id ca18e2360f4ac-85dc4792a8dmr1487053639f.4.1742201597020;
        Mon, 17 Mar 2025 01:53:17 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f2638147c9sm2161677173.112.2025.03.17.01.53.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Mar 2025 01:53:16 -0700 (PDT)
Message-ID: <4ab33998-4d16-4ecb-aa76-3919afcbf2d7@redhat.com>
Date: Mon, 17 Mar 2025 09:53:12 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 4/5] configure: Add --qemu-cpu option
To: Jean-Philippe Brucker <jean-philippe@linaro.org>, andrew.jones@linux.dev,
 alexandru.elisei@arm.com
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
 kvm-riscv@lists.infradead.org, vladimir.murzin@arm.com
References: <20250314154904.3946484-2-jean-philippe@linaro.org>
 <20250314154904.3946484-6-jean-philippe@linaro.org>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20250314154904.3946484-6-jean-philippe@linaro.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: seHPxkzeThrXczxiX1kQyedX-l1QyyBwQKdXyUI6M-A_1742201597
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Jean-Philippe,


On 3/14/25 4:49 PM, Jean-Philippe Brucker wrote:
> Add the --qemu-cpu option to let users set the CPU type to run on.
> At the moment --processor allows to set both GCC -mcpu flag and QEMU
> -cpu. On Arm we'd like to pass `-cpu max` to QEMU in order to enable all
> the TCG features by default, and it could also be nice to let users
> modify the CPU capabilities by setting extra -cpu options.
> Since GCC -mcpu doesn't accept "max" or "host", separate the compiler
> and QEMU arguments.
>
> `--processor` is now exclusively for compiler options, as indicated by
> its documentation ("processor to compile for"). So use $QEMU_CPU on
> RISC-V as well.
>
> Suggested-by: Andrew Jones <andrew.jones@linux.dev>
> Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
> ---
>  scripts/mkstandalone.sh |  2 +-
>  arm/run                 | 17 +++++++++++------
>  riscv/run               |  8 ++++----
>  configure               |  7 +++++++
>  4 files changed, 23 insertions(+), 11 deletions(-)
>
> diff --git a/scripts/mkstandalone.sh b/scripts/mkstandalone.sh
> index 2318a85f..6b5f725d 100755
> --- a/scripts/mkstandalone.sh
> +++ b/scripts/mkstandalone.sh
> @@ -42,7 +42,7 @@ generate_test ()
>  
>  	config_export ARCH
>  	config_export ARCH_NAME
> -	config_export PROCESSOR
> +	config_export QEMU_CPU
>  
>  	echo "echo BUILD_HEAD=$(cat build-head)"
>  
> diff --git a/arm/run b/arm/run
> index efdd44ce..561bafab 100755
> --- a/arm/run
> +++ b/arm/run
> @@ -8,7 +8,7 @@ if [ -z "$KUT_STANDALONE" ]; then
>  	source config.mak
>  	source scripts/arch-run.bash
>  fi
> -processor="$PROCESSOR"
> +qemu_cpu="$QEMU_CPU"
>  
>  if [ "$QEMU" ] && [ -z "$ACCEL" ] &&
>     [ "$HOST" = "aarch64" ] && [ "$ARCH" = "arm" ] &&
> @@ -37,12 +37,17 @@ if [ "$ACCEL" = "kvm" ]; then
>  	fi
>  fi
>  
> -if [ "$ACCEL" = "kvm" ] || [ "$ACCEL" = "hvf" ]; then
> -	if [ "$HOST" = "aarch64" ] || [ "$HOST" = "arm" ]; then
> -		processor="host"
> +if [ -z "$qemu_cpu" ]; then
> +	if ( [ "$ACCEL" = "kvm" ] || [ "$ACCEL" = "hvf" ] ) &&
> +	   ( [ "$HOST" = "aarch64" ] || [ "$HOST" = "arm" ] ); then
> +		qemu_cpu="host"
>  		if [ "$ARCH" = "arm" ] && [ "$HOST" = "aarch64" ]; then
> -			processor+=",aarch64=off"
> +			qemu_cpu+=",aarch64=off"
>  		fi
> +	elif [ "$ARCH" = "arm64" ]; then
> +		qemu_cpu="cortex-a57"
> +	else
> +		qemu_cpu="cortex-a15"
>  	fi
>  fi
>  
> @@ -71,7 +76,7 @@ if $qemu $M -device '?' | grep -q pci-testdev; then
>  fi
>  
>  A="-accel $ACCEL$ACCEL_PROPS"
> -command="$qemu -nodefaults $M $A -cpu $processor $chr_testdev $pci_testdev"
> +command="$qemu -nodefaults $M $A -cpu $qemu_cpu $chr_testdev $pci_testdev"
>  command+=" -display none -serial stdio"
>  command="$(migration_cmd) $(timeout_cmd) $command"
>  
> diff --git a/riscv/run b/riscv/run
> index e2f5a922..02fcf0c0 100755
> --- a/riscv/run
> +++ b/riscv/run
> @@ -11,12 +11,12 @@ fi
>  
>  # Allow user overrides of some config.mak variables
>  mach=$MACHINE_OVERRIDE
> -processor=$PROCESSOR_OVERRIDE
> +qemu_cpu=$QEMU_CPU_OVERRIDE
>  firmware=$FIRMWARE_OVERRIDE
>  
> -[ "$PROCESSOR" = "$ARCH" ] && PROCESSOR="max"
> +[ -z "$QEMU_CPU" ] && QEMU_CPU="max"
>  : "${mach:=virt}"
> -: "${processor:=$PROCESSOR}"
> +: "${qemu_cpu:=$QEMU_CPU}"
>  : "${firmware:=$FIRMWARE}"
>  [ "$firmware" ] && firmware="-bios $firmware"
>  
> @@ -32,7 +32,7 @@ fi
>  mach="-machine $mach"
>  
>  command="$qemu -nodefaults -nographic -serial mon:stdio"
> -command+=" $mach $acc $firmware -cpu $processor "
> +command+=" $mach $acc $firmware -cpu $qemu_cpu "
>  command="$(migration_cmd) $(timeout_cmd) $command"
>  
>  if [ "$UEFI_SHELL_RUN" = "y" ]; then
> diff --git a/configure b/configure
> index 5306bad3..d25bd23e 100755
> --- a/configure
> +++ b/configure
> @@ -52,6 +52,7 @@ page_size=
>  earlycon=
>  efi=
>  efi_direct=
> +qemu_cpu=
>  
>  # Enable -Werror by default for git repositories only (i.e. developer builds)
>  if [ -e "$srcdir"/.git ]; then
> @@ -69,6 +70,8 @@ usage() {
>  	    --arch=ARCH            architecture to compile for ($arch). ARCH can be one of:
>  	                           arm, arm64, i386, ppc64, riscv32, riscv64, s390x, x86_64
>  	    --processor=PROCESSOR  processor to compile for ($processor)
> +	    --qemu-cpu=CPU         the CPU model to run on. The default depends on
> +	                           the configuration, usually it is "host" or "max".
nit: I would remove 'usually it is "host" or "max"'. I don't see any
consistency check between qemu_cpu and processor in case it is
explicitly set? Do we care? Eric

>  	    --target=TARGET        target platform that the tests will be running on (qemu or
>  	                           kvmtool, default is qemu) (arm/arm64 only)
>  	    --cross-prefix=PREFIX  cross compiler prefix
> @@ -142,6 +145,9 @@ while [[ $optno -le $argc ]]; do
>          --processor)
>  	    processor="$arg"
>  	    ;;
> +	--qemu-cpu)
> +	    qemu_cpu="$arg"
> +	    ;;
>  	--target)
>  	    target="$arg"
>  	    ;;
> @@ -464,6 +470,7 @@ ARCH=$arch
>  ARCH_NAME=$arch_name
>  ARCH_LIBDIR=$arch_libdir
>  PROCESSOR=$processor
> +QEMU_CPU=$qemu_cpu
>  CC=$cc
>  CFLAGS=$cflags
>  LD=$cross_prefix$ld

Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric


