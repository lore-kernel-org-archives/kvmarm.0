Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7739D22FAC3
	for <kvmarm@lists.linux.dev>; Wed, 21 May 2025 06:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747808454; cv=none; b=OreS6Y8qQDtMurbAWM6tmauQD/TAfNe05ijQxx6UA/en+UFG0DbJsn2Ky2B9UidhbG6tYFqU6LHhmEasHtD9v4ydGujQhtH3bg2AnmCREeDl43HJzymCVGQTXvXY0OyIWD4sJs9FmVfHB/81E431784fiW3NoLa8R0sR+gNJyqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747808454; c=relaxed/simple;
	bh=YHL1BO9Yw2qVuykoMrFywasyGMLqP7T8KUotdskXsco=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ynki9MZVMj9+OwWC2CI7ie0FE8j0JNyvNnoTBtUYMOuB7chYrboEPjVKz7OIJSM182xoiiHzZwRan0IvwGqTGjdTRGx87uUQnjmybermbdjXio+1Vm+zW2tTwPCyG/BstiHgaIyZ3kvsZU0Jc0u9Ep9Mpb2kX4Ntp8oh1BH/nyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=C/Bbax8J; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="C/Bbax8J"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747808451;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=27vdWwqXm6Qw7dfKd1dwnOUfre6U0zDeEbDFMcZZEZY=;
	b=C/Bbax8J2SScAhiRRr4YtJi5E/O/z0bcDu2cdom9dSxE1UF0ZOceBAkLmizMnCM5cIs+Tv
	0GfF1NxlmpiPuqy+sPxpINy/75+rXT85PL6LAT03VKGjzHS7mfn8AYosCrmkTNZZwr/w6x
	8YN1cDp2wp5laJr6Hxo1h99JFygffdM=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-19-stc8MNE1Mr6JRbIuQNIhbQ-1; Wed, 21 May 2025 02:20:49 -0400
X-MC-Unique: stc8MNE1Mr6JRbIuQNIhbQ-1
X-Mimecast-MFC-AGG-ID: stc8MNE1Mr6JRbIuQNIhbQ_1747808448
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-30ed6bd1b4cso4724002a91.0
        for <kvmarm@lists.linux.dev>; Tue, 20 May 2025 23:20:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747808448; x=1748413248;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=27vdWwqXm6Qw7dfKd1dwnOUfre6U0zDeEbDFMcZZEZY=;
        b=JsJlEikx8ewH1/rXye4ktaGqCkdE4t1qZpXumOSX1bdHzD3k6tDMf5Xr/gDidrJVLT
         c5ZoMYUbsjDY2pEvt5g9YUQl0/CJfRqrFx2mECIPuC/ZpkW8ruBX2FG5TqqlaB2HFji8
         qFm7Pmne+YW6sbGZ4n9Eh0JYDI82OkiXC1ph0BYb4eoZa0/ylp94HpJ1A5ZKlar94/E5
         Vh+q6Q8ctZY6g/NviVH0kl97D6qw5b4VlUWGGR8VxQv1W790RD5PtNtLcESD7aiGgSUG
         vChrVAEIVEvHfyQN5OFN7xh1uEayIWxwia4BYR7W097cWEYiGk4Yox3taTG8ok195Kgv
         6gCg==
X-Forwarded-Encrypted: i=1; AJvYcCWRBCTWoQOHjW5LhTzkOdkjGuVhqZ7OOkdoa3tRjMBZhzdGW0CSp3RakjkmtDmYsJkjB/o0ujA=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx6eiA4VJ9+1y1cEEgxhkmJ8ZAe25sP1699m4qvvuMR+vkNknTr
	Eocg7TZot+3fJ+LLY4a8fjl/tbDT8e06U/TavYTorb1bDaH9dL1tMuCje0ID60wsSJBw1rT3ZUM
	KB3q5vNJpaj85AtnrpuBogz7PpNu/3J8SpV7CpaKjyXZcphTpkAXH8FdYDg==
X-Gm-Gg: ASbGnctlGpy0bApZ7zZMwD8tf9TfSe/Hk5PIWAcskPyKpDfWlzGVxAEIJRaMztSW+9Z
	i4w0qWx04euZMONq3r/AnlDoPGYM/nrxhlK8yiXRHGJo/Xs/prL7X7iIPVTmAY3+Nt/rN9AYIhe
	HzfSO0oYt1TCZoHYb7/6c54JiTLg3+q43w2vjj/yKllNi0Mpuo1x8EGMEmJT07pvFsHg/IbhZYo
	gAUOxqu3Grp6/Y+r/jZxVjLYFczS56IX4Qv0eNeJ0dUZlVKB/Xy3955D9IS/ZXZe4q9+8QkKOJt
	EHuRu/5V3QYznxg=
X-Received: by 2002:a17:90b:35ca:b0:2fe:baa3:b8bc with SMTP id 98e67ed59e1d1-30e832258eamr23096817a91.23.1747808447862;
        Tue, 20 May 2025 23:20:47 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGCcJqZvem5ZOsw0GUieRAaMuIKN6FQwGBBKSGgLmmfZRpS0KvtQJGPwRUgMl3I4UcNRsWE9Q==
X-Received: by 2002:a17:90b:35ca:b0:2fe:baa3:b8bc with SMTP id 98e67ed59e1d1-30e832258eamr23096785a91.23.1747808447373;
        Tue, 20 May 2025 23:20:47 -0700 (PDT)
Received: from [10.72.116.61] ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30f365b2d8fsm2847557a91.7.2025.05.20.23.20.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 May 2025 23:20:46 -0700 (PDT)
Message-ID: <5b284638-2082-4d85-9e4d-4514ee15e193@redhat.com>
Date: Wed, 21 May 2025 14:20:37 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v3 16/16] scripts: Enable kvmtool
To: Alexandru Elisei <alexandru.elisei@arm.com>, andrew.jones@linux.dev,
 eric.auger@redhat.com, lvivier@redhat.com, thuth@redhat.com,
 frankja@linux.ibm.com, imbrenda@linux.ibm.com, nrb@linux.ibm.com,
 david@redhat.com, pbonzini@redhat.com
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
 linux-s390@vger.kernel.org, will@kernel.org, julien.thierry.kdev@gmail.com,
 maz@kernel.org, oliver.upton@linux.dev, suzuki.poulose@arm.com,
 yuzenghui@huawei.com, joey.gouly@arm.com, andre.przywara@arm.com
References: <20250507151256.167769-1-alexandru.elisei@arm.com>
 <20250507151256.167769-17-alexandru.elisei@arm.com>
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20250507151256.167769-17-alexandru.elisei@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: pogmOFn6nbn4T-RcPLekpdkDFUCPDF6QAjuJKW7ZSFA_1747808448
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 5/7/25 11:12 PM, Alexandru Elisei wrote:
> Everything is in place to run the tests using kvmtool:
> 
> $ ./configure --target=kvmtool
> $ make clean && make
> $ KVMTOOL=<path/to/kvmtool> ./run_tests.sh
> 
> so enable it, and remove ERRATA_FORCE=y when configuring for kvmtool,
> because the runner will generate and pass the correct environment to
> kvmtool.
> 
> Missing is support for EFI tests. That's because distros don't ship a

Missing should be Nothing?

> EDK2 binary compiled for kvmtool, and on top of that kvm-unit-tests as
> an EFI app hasn't been tested to work with kvmtool.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>

Reviewed-by: Shaoqin Huang <shahuang@redhat.com>

> ---
>   README.md        | 18 +++++++++++++++++-
>   arm/efi/run      |  5 +++++
>   configure        |  1 -
>   scripts/vmm.bash |  2 +-
>   4 files changed, 23 insertions(+), 3 deletions(-)
> 
> diff --git a/README.md b/README.md
> index be07dc28a094..723ce04cd978 100644
> --- a/README.md
> +++ b/README.md
> @@ -65,6 +65,9 @@ or:
>   
>   to run them all.
>   
> +All tests can be run using QEMU. On arm and arm64, tests can also be run using
> +kvmtool.
> +
>   By default the runner script searches for a suitable QEMU binary in the system.
>   To select a specific QEMU binary though, specify the QEMU=path/to/binary
>   environment variable:
> @@ -78,12 +81,25 @@ ACCEL=name environment variable:
>   
>   For running tests that involve migration from one QEMU instance to another
>   you also need to have the "ncat" binary (from the nmap.org project) installed,
> -otherwise the related tests will be skipped.
> +otherwise the related tests will be skipped. kvmtool does not support migration.
> +
> +As for running a test with kvmtool, please configure kvm-unit-tests accordingly
> +first:
> +
> +   ./configure --arch=arm64 --target=kvmtool
> +
> +then run the test(s) like with QEMU above.
> +
> +To select a kvmtool binary, specify the KVMTOOL=path/to/binary environment
> +variable. kvmtool supports only kvm as the accelerator.
>   
>   ## Running the tests with UEFI
>   
>   Check [x86/efi/README.md](./x86/efi/README.md).
>   
> +On arm and arm64, this is only supported with QEMU; kvmtool cannot run the
> +tests under UEFI.
> +
>   # Tests configuration file
>   
>   The test case may need specific runtime configurations, for
> diff --git a/arm/efi/run b/arm/efi/run
> index 53d71297cc52..0843725ec360 100755
> --- a/arm/efi/run
> +++ b/arm/efi/run
> @@ -15,6 +15,11 @@ source scripts/vmm.bash
>   
>   check_vmm_supported
>   
> +if [[ $TARGET = "kvmtool" ]]; then
> +	echo "kvmtool does not support EFI tests."
> +	exit 2
> +fi
> +
>   if [ -f /usr/share/qemu-efi-aarch64/QEMU_EFI.fd ]; then
>   	DEFAULT_UEFI=/usr/share/qemu-efi-aarch64/QEMU_EFI.fd
>   elif [ -f /usr/share/edk2/aarch64/QEMU_EFI.silent.fd ]; then
> diff --git a/configure b/configure
> index 8c4400db42bc..d5f9995172f8 100755
> --- a/configure
> +++ b/configure
> @@ -392,7 +392,6 @@ elif [ "$arch" = "arm" ] || [ "$arch" = "arm64" ]; then
>           : "${uart_early_addr:=0x9000000}"
>       elif [ "$target" = "kvmtool" ]; then
>           : "${uart_early_addr:=0x1000000}"
> -        errata_force=1
>       else
>           echo "--target must be one of 'qemu' or 'kvmtool'!"
>           usage
> diff --git a/scripts/vmm.bash b/scripts/vmm.bash
> index ef9819f4132c..4ae60c37a6e8 100644
> --- a/scripts/vmm.bash
> +++ b/scripts/vmm.bash
> @@ -159,7 +159,7 @@ declare -A vmm_opts=(
>   function check_vmm_supported()
>   {
>   	case "$TARGET" in
> -	qemu)
> +	qemu | kvmtool)
>   		return 0
>   		;;
>   	*)

-- 
Shaoqin

