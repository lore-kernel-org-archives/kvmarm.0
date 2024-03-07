Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45B5C5672
	for <kvmarm@lists.linux.dev>; Thu,  7 Mar 2024 02:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709778556; cv=none; b=uIvkXiDCNIUkj2IvVH069oA4IxH90vbo4DnA+lhQ8nnvxPfUZFZaeYJS3AQfv6O5104yAXX7uJrNmKJvFDaCpsaF4Uqz8bVfbwNCarLmwy4H1r05cdnnW1vWAp6BvknbZXthP1L9Fk4IAnR1343s5D4Fxjalz/ERp7lZedc1p4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709778556; c=relaxed/simple;
	bh=coZg3CFF05t9sz7AF4xhD7nZ+00dSkiiGeyWmvwCd1w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gJaWWel1rfYjGWg6bw3GB7rxTn5TDffqXwEe0BbEGiqWyW0SkGqVFWgTAAy2rZvajVek58SnO1vvs/ZzB/ebsBbKZPGxJfWSh5WqxyZNSa2K/wNy9ppDClAbB5HJiwOBw0aoZzVcsnaKzvi8zQsMkaC1k87HBfdTfTiYUDcA1Mg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bcnkC8OG; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bcnkC8OG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709778553;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LPvh/jCT7caBWdZhb9Pskoj0b6p6SKQ25K+6dPHyzTg=;
	b=bcnkC8OGhNVZRij/bRdQnoCt/S1XxcX+JJVo8WtZzJKyEiBM90Ob10KjDJOTcGTdtqcfUs
	bwzNQhscUB7LKxLqe+nDpueBb2Viwpc3jZQ2wv9Ezj0Q705Of5E1AEGsG8dkvtddCWPZ3C
	UPhl3aQb02GLtYoKhPW6uRW/gRtm7sE=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-388-cZzzUckuOeeH2K9jsm3-ow-1; Wed, 06 Mar 2024 21:29:11 -0500
X-MC-Unique: cZzzUckuOeeH2K9jsm3-ow-1
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-5cf53f904f9so124188a12.1
        for <kvmarm@lists.linux.dev>; Wed, 06 Mar 2024 18:29:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709778550; x=1710383350;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LPvh/jCT7caBWdZhb9Pskoj0b6p6SKQ25K+6dPHyzTg=;
        b=LpK57c8uM3oa+iKWmbviBf+LAXFCvJr138Z1NQkZtfSpasa3w5Qn7lTrz76uZ8MO8A
         e3pkMXVbcQGQPADw6Y0i6rO7FmmTAszUA5w67n4umr/6ecXUMIdzJ5EkjkiiXazRhpVk
         l06cmOxkzZ47c8WpX5p1XqSjJMEWcf7Iqs0fpXfyjQ1IAW+lVtjYAzULuSrGCNLrnj9/
         z1kxkGztM7GxiemJbKrQ4rRgAe52gCBn3trBD1kwvdJKRNLfpJ2eaNzZoH4aTVNizu7s
         bksuUyTC3dPUvYgV3d6daGeK3HgNsi3D4bcbvH/HpW4M6UUqELlx3WO6QvxeIUMJeR+1
         pwgQ==
X-Forwarded-Encrypted: i=1; AJvYcCXQ3pwZrAu3b7gez+guNokBvjT1IfgJIdtwRh6+6Wy7KPJ4p4IGUQStKAPmODZvvsfLZzuNTUECO5A5TPigDDD9OlV5JFq8
X-Gm-Message-State: AOJu0Yxjm/JuWB27sLWlnPmhXQ6pym7O6+uPsyDI9eLbGwjKZQW1ChzB
	iWerSfK6gE7cHZE0niYFjSnNTwHb0cWSfbNi7Lun0wGjgs9h/BMfMou5eSZCmMmbBmSFUBa966M
	m1g95Ujm3LuELSjFcNN1bNsCD/gsEdRYo1z0E0Rsf2qhvq6hL5ul9Aw==
X-Received: by 2002:a17:902:7c17:b0:1d9:607d:8a26 with SMTP id x23-20020a1709027c1700b001d9607d8a26mr5330204pll.6.1709778550300;
        Wed, 06 Mar 2024 18:29:10 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGTkgJGIb4gjT6DgEXSzYd76fOXqgDeKxXxxWXNf0TRRldpwwc/uxpzx2vKm25SmQGjQbehzw==
X-Received: by 2002:a17:902:7c17:b0:1d9:607d:8a26 with SMTP id x23-20020a1709027c1700b001d9607d8a26mr5330184pll.6.1709778549823;
        Wed, 06 Mar 2024 18:29:09 -0800 (PST)
Received: from [10.66.61.39] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id l4-20020a170902f68400b001dcbffec642sm13237671plg.133.2024.03.06.18.29.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Mar 2024 18:29:09 -0800 (PST)
Message-ID: <5e0d6fc7-ddba-40b6-9eca-1a76f0d639ef@redhat.com>
Date: Thu, 7 Mar 2024 10:29:04 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v3 01/18] runtime: Update MAX_SMP probe
To: Andrew Jones <andrew.jones@linux.dev>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: alexandru.elisei@arm.com, eric.auger@redhat.com, nikos.nikoleris@arm.com,
 pbonzini@redhat.com, thuth@redhat.com
References: <20240305164623.379149-20-andrew.jones@linux.dev>
 <20240305164623.379149-21-andrew.jones@linux.dev>
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20240305164623.379149-21-andrew.jones@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 3/6/24 00:46, Andrew Jones wrote:
> Arm's MAX_SMP probing must have stopped working at some point due to
> QEMU's error message changing, but nobody noticed. Also, the probing
> should work for at least x86 now too, so the comment isn't correct
> anymore either. We could probably just delete this probe thing, but
> in case it could still serve some purpose we can also keep it, but
> updated for later QEMU, and only enabled when a new run_tests.sh
> command line option is provided.
>  > Reviewed-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
> Signed-off-by: Andrew Jones <andrew.jones@linux.dev>

Reviewed-by: Shaoqin Huang <shahuang@redhat.com>

> ---
>   run_tests.sh         |  5 ++++-
>   scripts/runtime.bash | 19 ++++++++++---------
>   2 files changed, 14 insertions(+), 10 deletions(-)
> 
> diff --git a/run_tests.sh b/run_tests.sh
> index abb0ab773362..bb3024ff95b1 100755
> --- a/run_tests.sh
> +++ b/run_tests.sh
> @@ -44,7 +44,7 @@ fi
>   
>   only_tests=""
>   list_tests=""
> -args=$(getopt -u -o ag:htj:vl -l all,group:,help,tap13,parallel:,verbose,list -- $*)
> +args=$(getopt -u -o ag:htj:vl -l all,group:,help,tap13,parallel:,verbose,list,probe-maxsmp -- $*)
>   [ $? -ne 0 ] && exit 2;
>   set -- $args;
>   while [ $# -gt 0 ]; do
> @@ -78,6 +78,9 @@ while [ $# -gt 0 ]; do
>           -l | --list)
>               list_tests="yes"
>               ;;
> +        --probe-maxsmp)
> +            probe_maxsmp
> +            ;;
>           --)
>               ;;
>           *)
> diff --git a/scripts/runtime.bash b/scripts/runtime.bash
> index c73fb0240d12..f2e43bb1ed60 100644
> --- a/scripts/runtime.bash
> +++ b/scripts/runtime.bash
> @@ -200,12 +200,13 @@ function run()
>   #
>   # Probe for MAX_SMP, in case it's less than the number of host cpus.
>   #
> -# This probing currently only works for ARM, as x86 bails on another
> -# error first, so this check is only run for ARM and ARM64. The
> -# parameter expansion takes the last number from the QEMU error
> -# message, which gives the allowable MAX_SMP.
> -if [[ $ARCH == 'arm' || $ARCH == 'arm64' ]] &&
> -   smp=$($RUNTIME_arch_run _NO_FILE_4Uhere_ -smp $MAX_SMP |& grep 'exceeds max CPUs'); then
> -	smp=${smp##*(}
> -	MAX_SMP=${smp:0:-1}
> -fi
> +function probe_maxsmp()
> +{
> +	local smp
> +
> +	if smp=$($RUNTIME_arch_run _NO_FILE_4Uhere_ -smp $MAX_SMP |& grep 'Invalid SMP CPUs'); then
> +		smp=${smp##* }
> +		echo "Restricting MAX_SMP from ($MAX_SMP) to the max supported ($smp)" >&2
> +		MAX_SMP=$smp
> +	fi
> +}

-- 
Shaoqin

