Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 860694BD0FD;
	Fri,  2 Oct 2026 15:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790954954; cv=none; b=GQxYW7uhLKFylPROOgppgGbpepKkHD+eh9q1b9UYOoW8tKQk2b92iJxFCXKqbvjr9GkfNFesoswszBj7ilewO5dazYrzIzWKowKI6QXo6aNWns99N837Z6Q1ik/+olcD5/aid5BxSZbmdUmHy0aaT8DYp6NF4+WZ3ve1Qomg1sU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790954954; c=relaxed/simple;
	bh=P4f1hv785d621ll4HEeJjnSeVQYSEnQeNsJSJrh9rSw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=M4R8Ju2CwPAypE4PMFjFjRE8haeQ6qM8YAAqR93ZhHxNxUq+1fE/SNX8ubHhUEgb3XsQXvxQplshhgTrNMszqna/dyQnu7QU68MMv7/u3bU49PhM+Tc9hU/sc4+OjhkrBrZkthbAyUrDGWh6yFrcHAXoDak+yJPHE8UaqG1+b7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=p8E8vMpM; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="p8E8vMpM"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A4DF0143D;
	Fri,  2 Oct 2026 08:29:08 -0700 (PDT)
Received: from [10.57.8.170] (unknown [10.57.8.170])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 279BE3F85F;
	Fri,  2 Oct 2026 08:29:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790954952; bh=P4f1hv785d621ll4HEeJjnSeVQYSEnQeNsJSJrh9rSw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=p8E8vMpMtKBWVnygtBY4CCJt+MHMHuQj+M7U9zx+9Pgy3DFcV8HBcxW9kxS/N/00J
	 XhEBuSPy1e7h4vteMl/XfZe//p0e5hbbJ3qzJoOHabnne1Sh49Qvv+nypCIzoo1Ach
	 9Du30zeEXLKrw1yW4XTxxKDrFWrNKDsec4rnAzbg=
Message-ID: <38a5b5d5-d39a-4fa2-8de5-ccc1d92aaff1@arm.com>
Date: Fri, 2 Oct 2026 16:29:05 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v22 07/10] kernel: hibernate: Add an arch hook for
 preventing hiberation
Content-Language: en-GB
To: Catalin Marinas <catalin.marinas@arm.com>,
 "Rafael J. Wysocki" <rafael@kernel.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, maz@kernel.org,
 will@kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, steven.price@arm.com,
 aneesh.kumar@kernel.org, oupton@kernel.org, gshan@redhat.com,
 joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
 linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
 sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
 WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com,
 sudeep.holla@arm.com, jonathan.cameron@oss.qualcomm.com,
 Len Brown <lenb@kernel.org>, Pavel Machek <pavel@kernel.org>,
 linux-pm@vger.kernel.org, Sudeep Holla <sudeep.holla@kernel.org>
References: <20261002061507.1600269-1-suzuki.poulose@arm.com>
 <20261002061507.1600269-8-suzuki.poulose@arm.com> <ar-PiBQGye4_hQa6@arm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <ar-PiBQGye4_hQa6@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 02/10/2026 12:03, Catalin Marinas wrote:
> On Fri, Oct 02, 2026 at 07:15:03AM +0100, Suzuki K Poulose wrote:
>> Add a hook to allow arch code disable hibernation. On arm64, with an RMM active,
>> there could be pages that are delegated to the "Realm" security state. Any
>> access to them are fatal (e.g., hibernate save image or restoring an image to
>> a delegated page). pKVM host also has its restrictions on enabling hibernation.
>>
>> Add a weak arch hook to let the architectures have a say.
>>
>> Cc: "Rafael J. Wysocki" <rafael@kernel.org>
>> Cc: Len Brown <lenb@kernel.org>
>> Cc: Pavel Machek <pavel@kernel.org>
>> Cc: linux-pm@vger.kernel.org
>> Cc: Sudeep Holla <sudeep.holla@kernel.org>
>> Suggested-by: Catalin Marinas <catalin.marinas@arm.com>
>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> 
> Nit: the subject prefix for kernel/power/ usually is
> 
> 	PM: hibernate: ....
> 
> I can fix it locally, no need to respin (and probably the wrap the long
> lines in the commit log, we tend to keep them shorter).
> 

Ack, I will take care of that in the future.


>> ---
>>   include/linux/suspend.h  | 1 +
>>   kernel/power/hibernate.c | 8 +++++++-
>>   2 files changed, 8 insertions(+), 1 deletion(-)
>>
>> diff --git a/include/linux/suspend.h b/include/linux/suspend.h
>> index b02876f1ae38a..a3815027773c5 100644
>> --- a/include/linux/suspend.h
>> +++ b/include/linux/suspend.h
>> @@ -401,6 +401,7 @@ int hibernate_quiet_exec(int (*func)(void *data), void *data);
>>   int hibernate_resume_nonboot_cpu_disable(void);
>>   int arch_hibernation_header_save(void *addr, unsigned int max_size);
>>   int arch_hibernation_header_restore(void *addr);
>> +bool arch_hibernation_available(void);
>>   
>>   #else /* CONFIG_HIBERNATION */
>>   static inline void register_nosave_region(unsigned long b, unsigned long e) {}
>> diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
>> index d2479c69d71a4..9d9d53828542f 100644
>> --- a/kernel/power/hibernate.c
>> +++ b/kernel/power/hibernate.c
>> @@ -106,11 +106,17 @@ bool hibernation_in_progress(void)
>>   	return !atomic_read(&hibernate_atomic);
>>   }
>>   
>> +__weak bool arch_hibernation_available(void)
>> +{
>> +	return true;
>> +}
>> +
>>   bool hibernation_available(void)
>>   {
>>   	return nohibernate == 0 &&
>>   		!security_locked_down(LOCKDOWN_HIBERNATION) &&
>> -		!secretmem_active() && !cxl_mem_active();
>> +		!secretmem_active() && !cxl_mem_active() &&
>> +		arch_hibernation_available();
> 
> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> 
> Raphael, any objection to this patch going in through the arm64 tree? It
> matches the style of other __weak functions in this file.

Thanks Catalin

Suzuki

> 
> Thanks.
> 

