Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 091502054F6
	for <kvmarm@lists.linux.dev>; Thu, 27 Mar 2025 08:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743063959; cv=none; b=hts+PhV4tPM/pg13pbw60pzZN8uEZlRgSFG7ALHHU06RmI7blsYJqhOxoQopQ6wfQQh2PWcwn4FX48B73QrkYAuoMt5SOiYAJbrPiIIUuJVt2lOjLTXJA3XU6eYEY0nKfbdSMQxtKL2nKng+8Y8oBc5qdVM9WcybkK8941W0XFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743063959; c=relaxed/simple;
	bh=u7j5oFuljpMg/DAbe79m2B6lL56FiQSytDN1lTtwevg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HvwYEQbGxJ34DTHU7n85WIsWGxnnCTnXcixxGHf3jHBHBk6d+rnjAbhIFbOuqFV4+uaxA9H4O0x9NADMTveKcaClln5QPDlZhInwn0GGQ+Gm6iz4LCxwEn+IsF5Yl5tuoIrBte5+ZN3YzBi9XRL0k0PgTBAIRy5XZ//ogj4LdJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=k0OWUjXy; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="k0OWUjXy"
Date: Thu, 27 Mar 2025 09:25:42 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1743063944;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NEt0aiytcktruPAw6HXBqRFKUOE4nJxqyXPJB1e/qLA=;
	b=k0OWUjXyssoB8n/xGrlSbPBbPiM9eAyalAfD9ZbQETMOqsbjcwqDHzKpTDW1kV2F+kZBIf
	gBEaWL/EXxvIM20UTXiBogTvLRN17NnSZ7oHseSS9cx0vho/pseSKoLWBQ+GOJ+2zulMs/
	bJfxjCBIcS3QbagiFYnO/EKtjlrYRGc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc: alexandru.elisei@arm.com, eric.auger@redhat.com, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	vladimir.murzin@arm.com
Subject: Re: [kvm-unit-tests PATCH v3 4/5] configure: Add --qemu-cpu option
Message-ID: <20250327-96bca62a41b4bb0aa44303d4@orel>
References: <20250325160031.2390504-3-jean-philippe@linaro.org>
 <20250325160031.2390504-7-jean-philippe@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250325160031.2390504-7-jean-philippe@linaro.org>
X-Migadu-Flow: FLOW_OUT

On Tue, Mar 25, 2025 at 04:00:32PM +0000, Jean-Philippe Brucker wrote:
> Add the --qemu-cpu option to let users set the CPU type to run on.
> At the moment --processor allows to set both GCC -mcpu flag and QEMU
> -cpu. On Arm we'd like to pass `-cpu max` to QEMU in order to enable all
> the TCG features by default, and it could also be nice to let users
> modify the CPU capabilities by setting extra -cpu options.  Since GCC
> -mcpu doesn't accept "max" or "host", separate the compiler and QEMU
> arguments.
> 
> `--processor` is now exclusively for compiler options, as indicated by
> its documentation ("processor to compile for"). So use $QEMU_CPU on
> RISC-V as well.
> 
> Suggested-by: Andrew Jones <andrew.jones@linux.dev>
> Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
> ---
>  scripts/mkstandalone.sh |  3 ++-
>  arm/run                 | 15 +++++++++------
>  riscv/run               |  8 ++++----
>  configure               | 24 ++++++++++++++++++++++++
>  4 files changed, 39 insertions(+), 11 deletions(-)
> 
> diff --git a/scripts/mkstandalone.sh b/scripts/mkstandalone.sh
> index 2318a85f..9b4f983d 100755
> --- a/scripts/mkstandalone.sh
> +++ b/scripts/mkstandalone.sh
> @@ -42,7 +42,8 @@ generate_test ()
>  
>  	config_export ARCH
>  	config_export ARCH_NAME
> -	config_export PROCESSOR
> +	config_export QEMU_CPU
> +	config_export DEFAULT_QEMU_CPU
>  
>  	echo "echo BUILD_HEAD=$(cat build-head)"
>  
> diff --git a/arm/run b/arm/run
> index efdd44ce..4675398f 100755
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
> @@ -37,12 +37,15 @@ if [ "$ACCEL" = "kvm" ]; then
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
> +	else
> +		qemu_cpu="$DEFAULT_QEMU_CPU"
>  	fi
>  fi
>  
> @@ -71,7 +74,7 @@ if $qemu $M -device '?' | grep -q pci-testdev; then
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
> index b4875ef3..b79145a5 100755
> --- a/configure
> +++ b/configure
> @@ -23,6 +23,21 @@ function get_default_processor()
>      esac
>  }
>  
> +# Return the default CPU type to run on
> +function get_default_qemu_cpu()
> +{
> +    local arch="$1"
> +
> +    case "$arch" in
> +    "arm")
> +        echo "cortex-a15"
> +        ;;
> +    "arm64")
> +        echo "cortex-a57"
> +        ;;
> +    esac
> +}
> +
>  srcdir=$(cd "$(dirname "$0")"; pwd)
>  prefix=/usr/local
>  cc=gcc
> @@ -52,6 +67,7 @@ earlycon=
>  console=
>  efi=
>  efi_direct=
> +qemu_cpu=
>  
>  # Enable -Werror by default for git repositories only (i.e. developer builds)
>  if [ -e "$srcdir"/.git ]; then
> @@ -70,6 +86,9 @@ usage() {
>  	    --arch=ARCH            architecture to compile for ($arch). ARCH can be one of:
>  	                           arm, arm64, i386, ppc64, riscv32, riscv64, s390x, x86_64
>  	    --processor=PROCESSOR  processor to compile for ($processor)
> +	    --qemu-cpu=CPU         the CPU model to run on. If left unset, the run script
> +	                           selects the best value based on the host system and the
> +	                           test configuration.

I'm starting to think we should name this '--target-cpu'. We already have
'--target' which allows us to change the target to kvmtool and we may
support other emulators/vmms someday. riscv kvmtool is already gaining
support for different cpu types[1] and other vmms we add may have that
support as well. There's no reason to add a separate configure command
line option for each.

So let's rename QEMU_CPU to TARGET_CPU, but keep DEFAULT_QEMU_CPU as it
is, since that's qemu specific. run scripts will need to check TARGET
is "qemu" to decide if it should use DEFAULT_QEMU_CPU when TARGET_CPU
isn't set. Since TARGET is currently arm-only we can drop the riscv
changes from this patch. I can do them with a follow-on series.

[1] https://lore.kernel.org/all/20250326065644.73765-1-apatel@ventanamicro.com/

Thanks,
drew

>  	    --target=TARGET        target platform that the tests will be running on (qemu or
>  	                           kvmtool, default is qemu) (arm/arm64 only)
>  	    --cross-prefix=PREFIX  cross compiler prefix
> @@ -146,6 +165,9 @@ while [[ $optno -le $argc ]]; do
>          --processor)
>  	    processor="$arg"
>  	    ;;
> +	--qemu-cpu)
> +	    qemu_cpu="$arg"
> +	    ;;
>  	--target)
>  	    target="$arg"
>  	    ;;
> @@ -471,6 +493,8 @@ ARCH=$arch
>  ARCH_NAME=$arch_name
>  ARCH_LIBDIR=$arch_libdir
>  PROCESSOR=$processor
> +QEMU_CPU=$qemu_cpu
> +DEFAULT_QEMU_CPU=$(get_default_qemu_cpu $arch)
>  CC=$cc
>  CFLAGS=$cflags
>  LD=$cross_prefix$ld
> -- 
> 2.49.0
> 
> 
> -- 
> kvm-riscv mailing list
> kvm-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kvm-riscv
