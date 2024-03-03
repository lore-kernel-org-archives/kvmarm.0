Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB8B479DC5
	for <kvmarm@lists.linux.dev>; Sun,  3 Mar 2024 21:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709502225; cv=none; b=Wv+VA1+AZAxvHvkgu+23J26bUB9tEc6aKzSQ1P396xMDxiDaM15voOFaj9tgcqHupL67T4oKYEbU+0FPSwtJcGAlG/KTqmFQ0rG7Cfpu5toijjrwYN4QvAgYYeKbPi0Lrnbhi/dXWr5QVDwFSjiYRJAwRt3RFGZc0MMYM2npr/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709502225; c=relaxed/simple;
	bh=smWne3q/miUfPVR5/Z7nrSYrc/AfQoRWPkhZJwJPP1A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MGo5hXZF5Qj/8qRjJQCTcOS1c6m+hpIZjt3XjOKxU58GbLF+jWhDZOepQz7JYOVsk0Bo5xqb+J7imUgb9q8B8UacDVj1hyd4MUlHkCvzcmwIPFf7R1X41RHDLHa/ieIHqxfR6xJdQq1NSOqHDk5BjVsjymkuwX2VLWYaPlHM268=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 931331FB;
	Sun,  3 Mar 2024 13:44:13 -0800 (PST)
Received: from [10.57.69.149] (unknown [10.57.69.149])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 114823F73F;
	Sun,  3 Mar 2024 13:43:34 -0800 (PST)
Message-ID: <bd7b96f8-79f5-481b-864b-c6bd6f196814@arm.com>
Date: Sun, 3 Mar 2024 21:43:13 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v2 01/18] runtime: Update MAX_SMP probe
Content-Language: en-GB
To: Andrew Jones <andrew.jones@linux.dev>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: alexandru.elisei@arm.com, eric.auger@redhat.com, shahuang@redhat.com,
 pbonzini@redhat.com, thuth@redhat.com
References: <20240227192109.487402-20-andrew.jones@linux.dev>
 <20240227192109.487402-21-andrew.jones@linux.dev>
From: Nikos Nikoleris <nikos.nikoleris@arm.com>
In-Reply-To: <20240227192109.487402-21-andrew.jones@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 27/02/2024 19:21, Andrew Jones wrote:
> Arm's MAX_SMP probing must have stopped working at some point due to
> QEMU's error message changing, but nobody noticed. Also, the probing
> should work for at least x86 now too, so the comment isn't correct
> anymore either. We could probably just delete this probe thing, but
> in case it could still serve some purpose we can also keep it, but
> updated for later QEMU, and only enabled when a new run_tests.sh
> command line option is provided.
> 
> Signed-off-by: Andrew Jones <andrew.jones@linux.dev>

Reviewed-by: Nikos Nikoleris <nikos.nikoleris@arm.com>

FWIW, probe_maxsmp doesn't have the expected outcome on MacOS. Not sure 
why, but on my MBP (M1 Pro), HVF supports up to 64 vCPUs and machine 
'virt-8.2' supports up to 512. Probably, this is another argument why 
this should be optional.

Thanks,

Nikos

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
