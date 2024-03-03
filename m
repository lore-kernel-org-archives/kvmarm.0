Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81AF467A0D
	for <kvmarm@lists.linux.dev>; Sun,  3 Mar 2024 22:07:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709503625; cv=none; b=XXOph1cboghL8eyQGd3Z0IdykGYz3yPyYpJtuaymdNdkVZeCMpMUox5sFpDnoxxkeOl0R0FwzBXS0wh2409EAf2sIywkdF3nZ5MUqnpRrRaN99ZULMdzN7XRuG0g8cmfXLIA8hv6h0IXbXJywcWzPj5B+67/lVmnxLS0OkDMpVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709503625; c=relaxed/simple;
	bh=aFDATYBibbY7MOHkR8SdUE9K1bFvFBOnGWCAWUjtznY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JyaqF7zbW8yGws7Kddrkr1WNVeUGk6BGjL1Je/hpv/6CjE16kVH2o0gY1XGqTMWaUKkT9+BmHI70zKyEOG5J/OHCWxuzwdpj1KeqYx4XsCzfoornP9BcYTIqtLZnwFU+ldkF+M1wka8lVuZnQ8vVU//j8nz4d34+fduoFmL8bCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BA4901FB;
	Sun,  3 Mar 2024 14:07:38 -0800 (PST)
Received: from [10.57.69.149] (unknown [10.57.69.149])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8407D3F73F;
	Sun,  3 Mar 2024 14:07:00 -0800 (PST)
Message-ID: <a8b67479-59d8-4f84-89df-11892cace501@arm.com>
Date: Sun, 3 Mar 2024 22:06:59 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v2 04/18] arm64: efi: Make running tests on
 EFI can be parallel
Content-Language: en-GB
To: Andrew Jones <andrew.jones@linux.dev>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: alexandru.elisei@arm.com, eric.auger@redhat.com, shahuang@redhat.com,
 pbonzini@redhat.com, thuth@redhat.com
References: <20240227192109.487402-20-andrew.jones@linux.dev>
 <20240227192109.487402-24-andrew.jones@linux.dev>
From: Nikos Nikoleris <nikos.nikoleris@arm.com>
In-Reply-To: <20240227192109.487402-24-andrew.jones@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 27/02/2024 19:21, Andrew Jones wrote:
> From: Shaoqin Huang <shahuang@redhat.com>
> 
> Currently running tests on EFI in parallel can cause part of tests to
> fail, this is because arm/efi/run script use the EFI_CASE to create the
> subdir under the efi-tests, and the EFI_CASE is the filename of the
> test, when running tests in parallel, the multiple tests exist in the
> same filename will execute at the same time, which will use the same
> directory and write the test specific things into it, this cause
> chaotic and make some tests fail.
> 
> For example, if we running the pmu-sw-incr and pmu-chained-counters
> and other pmu tests on EFI at the same time, the EFI_CASE will be pmu.
> So they will write their $cmd_args to the $EFI/TEST/pmu/startup.nsh
> at the same time, which will corrupt the startup.nsh file.
> 
> And we can get the log which outputs:
> 
> * pmu-sw-incr.log:
>    - ABORT: pmu: Unknown sub-test 'pmu-mem-acce'
> * pmu-chained-counters.log
>    - ABORT: pmu: Unknown sub-test 'pmu-mem-access-reliab'
> 
> And the efi-tests/pmu/startup.nsh:
> 
> @echo -off
> setvar fdtfile -guid 97ef3e03-7329-4a6a-b9ba-6c1fdcc5f823 -rt =L"dtb"
> pmu.efi pmu-mem-access-reliability
> setvar fdtfile -guid 97ef3e03-7329-4a6a-b9ba-6c1fdcc5f823 -rt =L"dtb"
> pmu.efi pmu-chained-sw-incr
> 
> As you can see, when multiple tests write to the same startup.nsh file,
> it causes the issue.
> 
> To Fix this issue, use the testname instead of the filename to create
> the subdir under the efi-tests. We use the EFI_TESTNAME to replace the
> EFI_CASE in script. Since every testname is specific, now the tests
> can be run parallel. It also considers when user directly use the
> arm/efi/run to run test, in this case, still use the filename.
> 
> Besides, replace multiple $EFI_TEST/$EFI_CASE to the $EFI_CASE_DIR, this
> makes the script looks more clean and we don'e need to replace many
> EFI_CASE to EFI_TESTNAME.
> 
> Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
> Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
> Signed-off-by: Andrew Jones <andrew.jones@linux.dev>

Reviewed-by: Nikos Nikoleris <nikos.nikoleris@arm.com>

> ---
>   arm/efi/run | 16 +++++++++-------
>   1 file changed, 9 insertions(+), 7 deletions(-)
> 
> diff --git a/arm/efi/run b/arm/efi/run
> index e629abde5273..8b6512520026 100755
> --- a/arm/efi/run
> +++ b/arm/efi/run
> @@ -25,6 +25,8 @@ fi
>   : "${EFI_UEFI:=$DEFAULT_UEFI}"
>   : "${EFI_TEST:=efi-tests}"
>   : "${EFI_CASE:=$(basename $1 .efi)}"
> +: "${EFI_TESTNAME:=$TESTNAME}"
> +: "${EFI_TESTNAME:=$EFI_CASE}"
>   : "${EFI_VAR_GUID:=97ef3e03-7329-4a6a-b9ba-6c1fdcc5f823}"
>   
>   [ "$EFI_USE_ACPI" = "y" ] || EFI_USE_DTB=y
> @@ -63,20 +65,20 @@ if [ "$EFI_CASE" = "_NO_FILE_4Uhere_" ]; then
>   	exit
>   fi
>   
> -: "${EFI_CASE_DIR:="$EFI_TEST/$EFI_CASE"}"
> +: "${EFI_CASE_DIR:="$EFI_TEST/$EFI_TESTNAME"}"
>   mkdir -p "$EFI_CASE_DIR"
>   
> -cp "$EFI_SRC/$EFI_CASE.efi" "$EFI_TEST/$EFI_CASE/"
> -echo "@echo -off" > "$EFI_TEST/$EFI_CASE/startup.nsh"
> +cp "$EFI_SRC/$EFI_CASE.efi" "$EFI_CASE_DIR/"
> +echo "@echo -off" > "$EFI_CASE_DIR/startup.nsh"
>   if [ "$EFI_USE_DTB" = "y" ]; then
>   	qemu_args+=(-machine acpi=off)
>   	FDT_BASENAME="dtb"
> -	$(EFI_RUN=y $TEST_DIR/run -machine dumpdtb="$EFI_TEST/$EFI_CASE/$FDT_BASENAME" "${qemu_args[@]}")
> -	echo "setvar fdtfile -guid $EFI_VAR_GUID -rt =L\"$FDT_BASENAME\""  >> "$EFI_TEST/$EFI_CASE/startup.nsh"
> +	$(EFI_RUN=y $TEST_DIR/run -machine dumpdtb="$EFI_CASE_DIR/$FDT_BASENAME" "${qemu_args[@]}")
> +	echo "setvar fdtfile -guid $EFI_VAR_GUID -rt =L\"$FDT_BASENAME\""  >> "$EFI_CASE_DIR/startup.nsh"
>   fi
> -echo "$EFI_CASE.efi" "${cmd_args[@]}" >> "$EFI_TEST/$EFI_CASE/startup.nsh"
> +echo "$EFI_CASE.efi" "${cmd_args[@]}" >> "$EFI_CASE_DIR/startup.nsh"
>   
>   EFI_RUN=y $TEST_DIR/run \
>          -bios "$EFI_UEFI" \
> -       -drive file.dir="$EFI_TEST/$EFI_CASE/",file.driver=vvfat,file.rw=on,format=raw,if=virtio \
> +       -drive file.dir="$EFI_CASE_DIR/",file.driver=vvfat,file.rw=on,format=raw,if=virtio \
>          "${qemu_args[@]}"
