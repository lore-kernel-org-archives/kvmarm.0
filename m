Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1820C12E4F
	for <kvmarm@lists.linux.dev>; Mon,  4 Mar 2024 07:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709536605; cv=none; b=Cg245u2ACfGp+Mjnt1bizirDChKBgnyRUMC6ukNPdsncsk6mh8oMoQ/V4jHnojYZgXBU36+Ro49BFp3XvqCsgQCE0KHjltO6y/8Lfn5dR3R6P3fTI8SxIRsFR101y0/ZPRr75HiDb9xMxfBFBaYaOC05FkjXfFTitlgXCFOhCa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709536605; c=relaxed/simple;
	bh=Qp8xqtlTmdS+IJXRfCm0vQBVFQ7hk/BUNqZEC2tfvGA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AWsXTJRvqTJeqEO/vU7LCFaR26qo5/ARj5Ffrms9JcE91nPA7G4Aww6/6kArfMfG70ua23MuerxAmVlgaJF5vy0iOfPW7z9sL8Mbw1WRz+tCQnlBXqHsGlT0yDXeuRSZkZAs1Z/vEGlBSIUtcmoiY59AZmzjN/aCReQikrEbxAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 077C11FB;
	Sun,  3 Mar 2024 23:17:19 -0800 (PST)
Received: from [192.168.5.30] (unknown [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3B0EB3F762;
	Sun,  3 Mar 2024 23:16:40 -0800 (PST)
Message-ID: <cc5b6d4c-e347-45c4-9174-80f98cc35e37@arm.com>
Date: Mon, 4 Mar 2024 07:16:38 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v2 05/18] arm64: efi: Remove redundant dtb
 generation
Content-Language: en-GB
To: Andrew Jones <andrew.jones@linux.dev>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: alexandru.elisei@arm.com, eric.auger@redhat.com, shahuang@redhat.com,
 pbonzini@redhat.com, thuth@redhat.com
References: <20240227192109.487402-20-andrew.jones@linux.dev>
 <20240227192109.487402-25-andrew.jones@linux.dev>
From: Nikos Nikoleris <nikos.nikoleris@arm.com>
In-Reply-To: <20240227192109.487402-25-andrew.jones@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 27/02/2024 19:21, Andrew Jones wrote:
> When a line in bash is written as
> 
>   $(some-line)
> 
> Then 'some-line' will be evaluated and then whatever some-line outputs
> will be evaluated. The dtb is getting generated twice since the line
> that should generate it is within $() and the output of that is the
> command itself (since arm/run outputs its command), so the command
> gets executed again. Remove the $() to just execute dtb generation
> once.

My bad, don't know what I was thinking.

> 
> While mucking with arm/efi/run tidy it a bit by by removing the unused
> sourcing of common.bash and the unnecessary 'set -e' (we check for and
> propagate errors ourselves). Finally, make one reorganization change
> and some whitespace fixes.
> 
> Fixes: 2607d2d6946a ("arm64: Add an efi/run script")
> Fixes: 2e080dafec2a ("arm64: Use the provided fdt when booting through EFI")
> Signed-off-by: Andrew Jones <andrew.jones@linux.dev>

Reviewed-by: Nikos Nikoleris <nikos.nikoleris@arm.com>

Thanks,

Nikos

> ---
>   arm/efi/run | 14 +++++---------
>   1 file changed, 5 insertions(+), 9 deletions(-)
> 
> diff --git a/arm/efi/run b/arm/efi/run
> index 8b6512520026..e45cecfa3265 100755
> --- a/arm/efi/run
> +++ b/arm/efi/run
> @@ -1,7 +1,5 @@
>   #!/bin/bash
>   
> -set -e
> -
>   if [ $# -eq 0 ]; then
>   	echo "Usage $0 TEST_CASE [QEMU_ARGS]"
>   	exit 2
> @@ -13,7 +11,6 @@ if [ ! -f config.mak ]; then
>   fi
>   source config.mak
>   source scripts/arch-run.bash
> -source scripts/common.bash
>   
>   if [ -f /usr/share/qemu-efi-aarch64/QEMU_EFI.fd ]; then
>   	DEFAULT_UEFI=/usr/share/qemu-efi-aarch64/QEMU_EFI.fd
> @@ -27,6 +24,7 @@ fi
>   : "${EFI_CASE:=$(basename $1 .efi)}"
>   : "${EFI_TESTNAME:=$TESTNAME}"
>   : "${EFI_TESTNAME:=$EFI_CASE}"
> +: "${EFI_CASE_DIR:="$EFI_TEST/$EFI_TESTNAME"}"
>   : "${EFI_VAR_GUID:=97ef3e03-7329-4a6a-b9ba-6c1fdcc5f823}"
>   
>   [ "$EFI_USE_ACPI" = "y" ] || EFI_USE_DTB=y
> @@ -65,20 +63,18 @@ if [ "$EFI_CASE" = "_NO_FILE_4Uhere_" ]; then
>   	exit
>   fi
>   
> -: "${EFI_CASE_DIR:="$EFI_TEST/$EFI_TESTNAME"}"
>   mkdir -p "$EFI_CASE_DIR"
> -
>   cp "$EFI_SRC/$EFI_CASE.efi" "$EFI_CASE_DIR/"
>   echo "@echo -off" > "$EFI_CASE_DIR/startup.nsh"
>   if [ "$EFI_USE_DTB" = "y" ]; then
>   	qemu_args+=(-machine acpi=off)
>   	FDT_BASENAME="dtb"
> -	$(EFI_RUN=y $TEST_DIR/run -machine dumpdtb="$EFI_CASE_DIR/$FDT_BASENAME" "${qemu_args[@]}")
> +	EFI_RUN=y $TEST_DIR/run -machine dumpdtb="$EFI_CASE_DIR/$FDT_BASENAME" "${qemu_args[@]}"
>   	echo "setvar fdtfile -guid $EFI_VAR_GUID -rt =L\"$FDT_BASENAME\""  >> "$EFI_CASE_DIR/startup.nsh"
>   fi
>   echo "$EFI_CASE.efi" "${cmd_args[@]}" >> "$EFI_CASE_DIR/startup.nsh"
>   
>   EFI_RUN=y $TEST_DIR/run \
> -       -bios "$EFI_UEFI" \
> -       -drive file.dir="$EFI_CASE_DIR/",file.driver=vvfat,file.rw=on,format=raw,if=virtio \
> -       "${qemu_args[@]}"
> +	-bios "$EFI_UEFI" \
> +	-drive file.dir="$EFI_CASE_DIR/",file.driver=vvfat,file.rw=on,format=raw,if=virtio \
> +	"${qemu_args[@]}"
