Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBB8E22FAC3
	for <kvmarm@lists.linux.dev>; Wed, 21 May 2025 06:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747807385; cv=none; b=IejZFEskJizrGlZCtyk75jvU8IjE0J96BdK22jPj/cm6GZgN1iuFB8UyVxwUwIHeZiAvW1thmMOaZ/ykLGIQBdMqSaymA7PfpqNYZ32AnCgq9nTd99ucLdibifB0fIKyStWZD+Lh1QLMz7KxkO+HZKZhqVtRGq74SK4C7E3IIZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747807385; c=relaxed/simple;
	bh=cTFLET0mXVLedaG6A7OEmnIZXr74rqMVNe8GNHLCJJ0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EjaMwjjd7iNr4bNF+VckEn2+K5inyXEjhBsM8AD+MLUNkDqQd6QZ+xxkfk1BoRqNtwSbPRyuVs2rY/cK92xrnm5Lz2XjOOQ3ruWSMoLemoH2Phvys6tcAkyLqdULU4KLMluWgCUPY4ZUyxSztwZJ32MFlGLyDufnqMMwWDRu/ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=A7V5o52C; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="A7V5o52C"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747807382;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Luzvl9YYiKKkKv2ZrlEtI5HQQUPGehqlA/R1MmkzXtU=;
	b=A7V5o52Cl9ryx/8WS3bHeBGxGnrrmzepfGJCdEKikv1ZwZN5bnShW6YPKQd3NUCdhW8j4p
	ZXlVkDRnOm4sifCojO9/5RCKcZWZfnDIPiMdAwk3tVcWM3ualaiWoLw1fIcXJOMqtSybUD
	m37VaBETR9hoq2gJDM6LIHi35k/yDwc=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-445-6vHntNVeM9mEjkaN-t3ztw-1; Wed, 21 May 2025 02:03:01 -0400
X-MC-Unique: 6vHntNVeM9mEjkaN-t3ztw-1
X-Mimecast-MFC-AGG-ID: 6vHntNVeM9mEjkaN-t3ztw_1747807380
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-742b8c0eaf0so2211614b3a.2
        for <kvmarm@lists.linux.dev>; Tue, 20 May 2025 23:03:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747807380; x=1748412180;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Luzvl9YYiKKkKv2ZrlEtI5HQQUPGehqlA/R1MmkzXtU=;
        b=PyRbGl02KU36QDb6xG+KCi25ce1vx6fs1Q48G6k4JGP0G8omy0eo+1xJoHIxdp4TKB
         WqeqYo2bCfWbMFvfqORQ9iTjGkjyqTdF5YNOZa5CEwlSNFl7KgDFeuhUuyotUbDP/0A2
         ydACXelQDfbbLiD/v1rptBg/OphydCcM9CEmF5PdYIsm3ubsTqXHtnFdP3pxCEZMenuk
         oJobsGGJPE/4pDBTIwUrVpXNyxqe83UZHiNdvxdf9746sM4nsllZ2ysYw0kH6xnef/ih
         THnSOVNi1HBMRRS68pF0QrVTinBx98GRIOtVO+p8FFQtcreyPhW6ndyTzjkxMlXpGJOa
         zfrQ==
X-Forwarded-Encrypted: i=1; AJvYcCVuL/9j4Z58dE/IF1O1WVRg+OnEubSLJcHtd7gC22Jogtow1LBuCn76mX6wNBRlYeS7Zb0bdTI=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyf2u2OkwsJEc+VNtZBrL4PLARLxS48FWZS69hmUulfjeGg0uat
	dsEMSzqqD5MVP7Cg8ePVEJEAiQXij5jwd2ZQGHzUfAEvO39SLkJ+gK1Zu1OgvT52tDCw5rRfGmi
	hpHzZUjrglNjmRqGHv06HrEt22GFaqbpj7eRZvaiB5+3aV7lDh92coOmi5Q==
X-Gm-Gg: ASbGncs2M38UB/0/05VljLmoV7VFnuUha2HXELCWFoXzrGc7oKOWgvTdlMzfcAq0xQ6
	Dm4s8InV1x0I1eFPA2RMGWHUqe9UVeV7UNhspLprUW95IUa+fxAfe2SUWG4u85SO+6wBnXhFCuQ
	AtAJfKYbns2sc1UhYdrbr/81bqLIttP1G4+kV4Tq0+xfc8y2dklYP9n8RyWUzb6RmHI0xJLG3pP
	Xe63EolJgRXSYs9h35X+tQ1cO2dXbA4iEiZrsHONSGCnI0vjWVBmumZd8S9q4vcEeWawm8e2eaL
	q+HbAu3/uy9nogc=
X-Received: by 2002:a05:6a00:1788:b0:736:5544:7ad7 with SMTP id d2e1a72fcca58-742a97eb5b9mr28757188b3a.14.1747807379855;
        Tue, 20 May 2025 23:02:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEkzCM7/Ctb9gNAgNxzZrfSW/B0q8J+JojRSlwDFqY3yzQr38av5VTKAulIBRs6Cj/pJdZcvA==
X-Received: by 2002:a05:6a00:1788:b0:736:5544:7ad7 with SMTP id d2e1a72fcca58-742a97eb5b9mr28757152b3a.14.1747807379436;
        Tue, 20 May 2025 23:02:59 -0700 (PDT)
Received: from [10.72.116.61] ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-742a9829b87sm8888368b3a.114.2025.05.20.23.02.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 May 2025 23:02:58 -0700 (PDT)
Message-ID: <3b33d060-895a-4f4b-a067-66164a29f8b4@redhat.com>
Date: Wed, 21 May 2025 14:02:45 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v3 13/16] scripts: Do not probe for maximum
 number of VCPUs when using kvmtool
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
 <20250507151256.167769-14-alexandru.elisei@arm.com>
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20250507151256.167769-14-alexandru.elisei@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: R50u1fLfSf5aB3jdzqReyPvtCVJjbsqnwWF0mKjD2Kk_1747807380
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 5/7/25 11:12 PM, Alexandru Elisei wrote:
> The --probe-maxsmp parameter updates MAX_SMP with the maximum number of
> VCPUs that the host supports. Qemu will exit with an error when creating a
> virtual machine if the number of VCPUs is exceeded.
> 
> kvmtool behaves differently: it will automatically limit the number of
> VCPUs to the what KVM supports, which is exactly what --probe-maxsmp wants
> to achieve. When doing --probe-maxsmp with kvmtool, print a message
> explaining why it's redundant and don't do anything else.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>

Reviewed-by: Shaoqin Huang <shahuang@redhat.com>

> ---
>   run_tests.sh         |  3 ++-
>   scripts/runtime.bash | 16 ----------------
>   scripts/vmm.bash     | 24 ++++++++++++++++++++++++
>   3 files changed, 26 insertions(+), 17 deletions(-)
> 
> diff --git a/run_tests.sh b/run_tests.sh
> index 150a06a91064..a69c3665b7a4 100755
> --- a/run_tests.sh
> +++ b/run_tests.sh
> @@ -10,6 +10,7 @@ if [ ! -f config.mak ]; then
>   fi
>   source config.mak
>   source scripts/common.bash
> +source scripts/vmm.bash
>   
>   function usage()
>   {
> @@ -90,7 +91,7 @@ while [ $# -gt 0 ]; do
>               list_tests="yes"
>               ;;
>           --probe-maxsmp)
> -            probe_maxsmp
> +            ${vmm_opts[$TARGET:probe_maxsmp]}
>               ;;
>           --)
>               ;;
> diff --git a/scripts/runtime.bash b/scripts/runtime.bash
> index 01ec8eae2bba..a802686c511d 100644
> --- a/scripts/runtime.bash
> +++ b/scripts/runtime.bash
> @@ -209,19 +209,3 @@ function run()
>   
>       return $ret
>   }
> -
> -#
> -# Probe for MAX_SMP, in case it's less than the number of host cpus.
> -#
> -function probe_maxsmp()
> -{
> -	local smp
> -
> -	if smp=$($RUNTIME_arch_run _NO_FILE_4Uhere_ -smp $MAX_SMP |& grep 'SMP CPUs'); then
> -		smp=${smp##* }
> -		smp=${smp/\(}
> -		smp=${smp/\)}
> -		echo "Restricting MAX_SMP from ($MAX_SMP) to the max supported ($smp)" >&2
> -		MAX_SMP=$smp
> -	fi
> -}
> diff --git a/scripts/vmm.bash b/scripts/vmm.bash
> index a1d50ed51981..ef9819f4132c 100644
> --- a/scripts/vmm.bash
> +++ b/scripts/vmm.bash
> @@ -105,6 +105,22 @@ function qemu_parse_premature_failure()
>   	return 0
>   }
>   
> +#
> +# Probe for MAX_SMP, in case it's less than the number of host cpus.
> +#
> +function qemu_probe_maxsmp()
> +{
> +	local smp
> +
> +	if smp=$($RUNTIME_arch_run _NO_FILE_4Uhere_ -smp $MAX_SMP |& grep 'SMP CPUs'); then
> +		smp=${smp##* }
> +		smp=${smp/\(}
> +		smp=${smp/\)}
> +		echo "Restricting MAX_SMP from ($MAX_SMP) to the max supported ($smp)" >&2
> +		MAX_SMP=$smp
> +	fi
> +}
> +
>   function kvmtool_parse_premature_failure()
>   {
>   	local log="$@"
> @@ -114,6 +130,12 @@ function kvmtool_parse_premature_failure()
>   	return 0
>   }
>   
> +function kvmtool_probe_maxsmp()
> +{
> +	echo "kvmtool automatically limits the number of VCPUs to maximum supported"
> +	echo "The 'smp' test parameter won't be modified"
> +}
> +
>   declare -A vmm_opts=(
>   	[qemu:nr_cpus]='-smp'
>   	[qemu:kernel]='-kernel'
> @@ -122,6 +144,7 @@ declare -A vmm_opts=(
>   	[qemu:default_opts]=''
>   	[qemu:fixup_return_code]=qemu_fixup_return_code
>   	[qemu:parse_premature_failure]=qemu_parse_premature_failure
> +	[qemu:probe_maxsmp]=qemu_probe_maxsmp
>   
>   	[kvmtool:nr_cpus]='--cpus'
>   	[kvmtool:kernel]='--kernel'
> @@ -130,6 +153,7 @@ declare -A vmm_opts=(
>   	[kvmtool:default_opts]="$KVMTOOL_DEFAULT_OPTS"
>   	[kvmtool:fixup_return_code]=kvmtool_fixup_return_code
>   	[kvmtool:parse_premature_failure]=kvmtool_parse_premature_failure
> +	[kvmtool:probe_maxsmp]=kvmtool_probe_maxsmp
>   )
>   
>   function check_vmm_supported()

-- 
Shaoqin

