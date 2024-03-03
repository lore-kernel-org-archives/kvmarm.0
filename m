Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B9261CA8F
	for <kvmarm@lists.linux.dev>; Sun,  3 Mar 2024 21:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709502647; cv=none; b=R9fhfX0sh5jZ3EGgn1I/zu7iMugRiAxfZ4cZXBvAXJaVVGcZeNOSyaB/FXFPRpJfO+PZnOnUWBRpdvTkPCOpjHHbJbFdR35tr+rS8Mn27LRT1tToywJRFL1B34ZMDUElJjmrIZBfTIsyl5e+Z+0WxJl9QsOei4f5gJOO6BinOeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709502647; c=relaxed/simple;
	bh=HS+oah7zz1X4UBuMxGTCh8tcmd1A9IK2XAK4zv7mYqQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pSCaYd21ZHK+R5ReoIN/RRJyh4tuwOYtDvycJYkwAXe+FBGr/yMazR6ACIr1vH/K/WjES1WhLBjobr506g+OGQHG5uAORPQUc1d0SSxOJ4f5L2lyi3YlF3VC/2RtzXCwd1O42KjNHPXEUQ/2jmJlM+zEXw10ghaYtaC3VJPj23s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 588A61FB;
	Sun,  3 Mar 2024 13:51:22 -0800 (PST)
Received: from [10.57.69.149] (unknown [10.57.69.149])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 334C83F73F;
	Sun,  3 Mar 2024 13:50:44 -0800 (PST)
Message-ID: <b806b4d8-f7d7-4d65-8ef5-3abfe07b87b6@arm.com>
Date: Sun, 3 Mar 2024 21:50:42 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v2 02/18] runtime: Add yet another 'no
 kernel' error message
Content-Language: en-GB
To: Andrew Jones <andrew.jones@linux.dev>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: alexandru.elisei@arm.com, eric.auger@redhat.com, shahuang@redhat.com,
 pbonzini@redhat.com, thuth@redhat.com
References: <20240227192109.487402-20-andrew.jones@linux.dev>
 <20240227192109.487402-22-andrew.jones@linux.dev>
From: Nikos Nikoleris <nikos.nikoleris@arm.com>
In-Reply-To: <20240227192109.487402-22-andrew.jones@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 27/02/2024 19:21, Andrew Jones wrote:
> When booting an Arm machine with the -bios command line option we
> get yet another error message from QEMU when using _NO_FILE_4Uhere_
> to probe command line support. Add it to the check in
> premature_failure()
> 
> Signed-off-by: Andrew Jones <andrew.jones@linux.dev>

Reviewed-by: Nikos Nikoleris <nikos.nikoleris@arm.com>

> ---
>   scripts/runtime.bash | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/scripts/runtime.bash b/scripts/runtime.bash
> index f2e43bb1ed60..255e756f2cb2 100644
> --- a/scripts/runtime.bash
> +++ b/scripts/runtime.bash
> @@ -18,7 +18,7 @@ premature_failure()
>       local log="$(eval "$(get_cmdline _NO_FILE_4Uhere_)" 2>&1)"
>   
>       echo "$log" | grep "_NO_FILE_4Uhere_" |
> -        grep -q -e "could not \(load\|open\) kernel" -e "error loading" &&
> +        grep -q -e "could not \(load\|open\) kernel" -e "error loading" -e "failed to load" &&
>           return 1
>   
>       RUNTIME_log_stderr <<< "$log"
