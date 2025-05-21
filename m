Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BE9422C322
	for <kvmarm@lists.linux.dev>; Wed, 21 May 2025 05:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747807135; cv=none; b=V2KTQm9BFnXy+hJentbOgd/Y2oL8wF2y7Qp/wkE0oKHK6LahWramcz3+2AawlcwAbeSIqW7l1+3JCxo6/jetpQEqO/zxpQA2Wcjm3rHYV+hDghp2eI4K7QAvG+YsTjiic6snb6655Dd8dA9Phk8dt4UGWxlErLahtBaLkhHVlA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747807135; c=relaxed/simple;
	bh=uIcXVV4gQllryuPUgzM3DOLQXxB+juTPfFfghG+6HI8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uf45AF1MbPRuYcfCpag0GgKQa6LXvdoqqkYmaVUecrksl8w7uzQ0lXTToHdY+D9GmDOY+nLLZtnb4MzPXSdv/eRxCV39PBDTgRU60LD0Ot2oqM/k4fkth/hoevQsLFATIKMXwPios8IOA+OuFQVlFQQnqa3KbRRVJ2vau+oVMzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bbVb5lxh; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bbVb5lxh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747807133;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3nX0mf0Fkt78o6JfyiUPx6n9zrKuc9Cy4bOKokl+4+0=;
	b=bbVb5lxhfzMtFuEpiak/mAXBs/jqetHwtuBcD+FxFtOzJlwHY93qvz8AwewZUOr8UvOJup
	/XImNIi88Fp5rn+9aO0a4/Lu7LxWy+GtEBGKEt7wwe/CxhIUYgo6W8Gn86xj3foP4/wkF/
	LAbcmAQazeUlTqMwNLtS0mdPr+wEdPw=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-30-yIvdE5UsMvWUU2qSs0jKkw-1; Wed, 21 May 2025 01:58:51 -0400
X-MC-Unique: yIvdE5UsMvWUU2qSs0jKkw-1
X-Mimecast-MFC-AGG-ID: yIvdE5UsMvWUU2qSs0jKkw_1747807131
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-73bfc657aefso4800987b3a.1
        for <kvmarm@lists.linux.dev>; Tue, 20 May 2025 22:58:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747807131; x=1748411931;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3nX0mf0Fkt78o6JfyiUPx6n9zrKuc9Cy4bOKokl+4+0=;
        b=Pl59JJbcyjlnrYMbjmfWy/zcS8Ilm6Q70lQq95Tl/S2VLM5Xtlgg6gcYUfrZbG1PBV
         2/+/3l/TLilf86oZrc/6akATAt7hQ5aD26IaxHUzqSLgXoOaUkwf0pJGQ2w39wxFx6wV
         jmN4zPWn3lmsxaIaCd3kUh5WMLAZr2DAtiCE3PpMA7gSjnYJqxe6PH7j95Xoo+p95RWM
         uvQDM31WWE5CZALgTRmNhFb1VOcMTI2NRNjpEWQHnZ/gEVq9Tq6IdjfoserrVQKoViiw
         kri+LqbkLcwtMMHvujdHq39Qpw9hVneC6fhkqRqyB2OKRtwrFrkD9/RQsY13vqfqiSic
         VRMg==
X-Forwarded-Encrypted: i=1; AJvYcCXTW81Ai3v6pL11WEhC+FAGcHKbdTzQ6+BmH66paBi6dmoOGFDAuv7UzFHw4E7fPj5xQ2f9RXY=@lists.linux.dev
X-Gm-Message-State: AOJu0YxBd+esGH1wZqYE0KVyemYclLo8Z1nW3G2wOSoetn7I3l0EXTCU
	Y6vi+ru/g17L4lllpn6PbVuiJ7gxX6KRbvDZ5++6uwNg5mGJ6ItNBQyhM0+Q366JVgzyjTgzwsO
	8/p1PxamY5kW/a856xMl6BzSBcPxIPQ+gxuQ3AsVgYYall5lOwEeSlerZng==
X-Gm-Gg: ASbGnctB5WJKNGVRTLqC2Ohl5icIPBRqQ3U/YOCjhW/BBGLW5vqd5tau9rO5FJBNFM9
	r69xwENJLi2fo1HnqRhNVmaoTkhFjOCaKPgnrt5Qma4CES/X/F2Ge4tQWncPvXjd3a0+YxuzBlu
	L7d7aXywFqw4U4DCFmOoVMYrLMLwPL08XBLTrLvYshH7GeFHg+BrozAtv5QV4fuujuf/JBxl+J1
	7Srra49rsEYba8t2TQpvui1VMnMni3RhLbUNmFJUE+7wfDOcRciuTFcSBLjNkKEWF7gYw1yWs5U
	R7nH7WfEwfA9wJQ=
X-Received: by 2002:a05:6a00:99b:b0:73f:f623:55f8 with SMTP id d2e1a72fcca58-742a9776958mr24169523b3a.5.1747807130768;
        Tue, 20 May 2025 22:58:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGz7QgFo322mqLeqRIQ+QKAfXrUPzgO5kq17+j1FtzB/COn8u/dv5TrNOSm4BX2L/XT0g/pCw==
X-Received: by 2002:a05:6a00:99b:b0:73f:f623:55f8 with SMTP id d2e1a72fcca58-742a9776958mr24169482b3a.5.1747807130253;
        Tue, 20 May 2025 22:58:50 -0700 (PDT)
Received: from [10.72.116.61] ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-742a970c882sm9260119b3a.55.2025.05.20.22.58.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 May 2025 22:58:49 -0700 (PDT)
Message-ID: <590d9058-7afc-45c7-ac81-68c109dfdad5@redhat.com>
Date: Wed, 21 May 2025 13:58:39 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v3 12/16] scripts: Detect kvmtool failure
 in premature_failure()
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
 <20250507151256.167769-13-alexandru.elisei@arm.com>
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20250507151256.167769-13-alexandru.elisei@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Ixoig1T8fdZOQunFRL_xpHZjPNY-1EkRcvas6ApGL0M_1747807131
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 5/7/25 11:12 PM, Alexandru Elisei wrote:
> kvm-unit-tests assumes that if the VMM is able to get to where it tries to
> load the kernel, then the VMM and the configuration parameters will also
> work for running the test. All of this is done in premature_failure().
> 
> Teach premature_failure() about the kvmtool's error message when it fails
> to load the dummy kernel.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>

Reviewed-by: Shaoqin Huang <shahuang@redhat.com>

> ---
>   scripts/runtime.bash |  8 +++-----
>   scripts/vmm.bash     | 23 +++++++++++++++++++++++
>   2 files changed, 26 insertions(+), 5 deletions(-)
> 
> diff --git a/scripts/runtime.bash b/scripts/runtime.bash
> index 86d8a2cd8528..01ec8eae2bba 100644
> --- a/scripts/runtime.bash
> +++ b/scripts/runtime.bash
> @@ -1,3 +1,5 @@
> +source scripts/vmm.bash
> +
>   : "${RUNTIME_arch_run?}"
>   : "${MAX_SMP:=$(getconf _NPROCESSORS_ONLN)}"
>   : "${TIMEOUT:=90s}"
> @@ -19,11 +21,7 @@ premature_failure()
>   
>       log="$(eval "$(get_cmdline _NO_FILE_4Uhere_)" 2>&1)"
>   
> -    echo "$log" | grep "_NO_FILE_4Uhere_" |
> -        grep -q -e "[Cc]ould not \(load\|open\) kernel" \
> -                -e "error loading" \
> -                -e "failed to load" &&
> -        return 1
> +    ${vmm_opts[$TARGET:parse_premature_failure]} "$log" || return 1
>   
>       RUNTIME_log_stderr <<< "$log"
>   
> diff --git a/scripts/vmm.bash b/scripts/vmm.bash
> index d24a4c4b8713..a1d50ed51981 100644
> --- a/scripts/vmm.bash
> +++ b/scripts/vmm.bash
> @@ -93,6 +93,27 @@ kvmtool_fixup_return_code()
>   	echo $ret
>   }
>   
> +function qemu_parse_premature_failure()
> +{
> +	local log="$@"
> +
> +	echo "$log" | grep "_NO_FILE_4Uhere_" |
> +		grep -q -e "[Cc]ould not \(load\|open\) kernel" \
> +			-e "error loading" \
> +			-e "failed to load" &&
> +		return 1
> +	return 0
> +}
> +
> +function kvmtool_parse_premature_failure()
> +{
> +	local log="$@"
> +
> +	echo "$log" | grep "Fatal: Unable to open kernel _NO_FILE_4Uhere_" &&
> +		return 1
> +	return 0
> +}
> +
>   declare -A vmm_opts=(
>   	[qemu:nr_cpus]='-smp'
>   	[qemu:kernel]='-kernel'
> @@ -100,6 +121,7 @@ declare -A vmm_opts=(
>   	[qemu:initrd]='-initrd'
>   	[qemu:default_opts]=''
>   	[qemu:fixup_return_code]=qemu_fixup_return_code
> +	[qemu:parse_premature_failure]=qemu_parse_premature_failure
>   
>   	[kvmtool:nr_cpus]='--cpus'
>   	[kvmtool:kernel]='--kernel'
> @@ -107,6 +129,7 @@ declare -A vmm_opts=(
>   	[kvmtool:initrd]='--initrd'
>   	[kvmtool:default_opts]="$KVMTOOL_DEFAULT_OPTS"
>   	[kvmtool:fixup_return_code]=kvmtool_fixup_return_code
> +	[kvmtool:parse_premature_failure]=kvmtool_parse_premature_failure
>   )
>   
>   function check_vmm_supported()

-- 
Shaoqin

