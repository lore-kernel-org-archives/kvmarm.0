Received: from www3579.sakura.ne.jp (www3579.sakura.ne.jp [49.212.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61950381AFF
	for <kvmarm@lists.linux.dev>; Mon, 20 Apr 2026 06:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.212.243.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776666141; cv=none; b=U7CyGd17RUStLo4eSREmg3Wn4zMPM5QOgDAgtkqQhwZoM67ONrLi5wl0hg3CLQruJFDyF3R9ZCkpLZKw2YXCB/50kFcpqq5/+lgeN88r+dHv0gbL2r+j0wmOSy+Lz2RHgJyWrFKsKINH/fQDrH1Y1tqVEctFhhd+bvHCqcCXzxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776666141; c=relaxed/simple;
	bh=4gcTz+8sS8b31hqBB1wlc7iFgF0lAJ8qLJYbhTEXAjU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DWA+RyUD2CmRdrzU8vwZBIFVTo6eMPfDa3oQis0gqdYWADhWTIzDTTHiU/xXl3wY0tMgMYlAwpCWreIRpBtJLCIyMLX0omEbL1dUavE85sWIX5/5ZKMgl8GEf3i67pTfbdnGw9sbVJ0KFBoqVgEfJL8/oBxbRdRyHlGAkiFCqHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp; dkim=fail (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b=Fab4JszZ reason="key not found in DNS"; arc=none smtp.client-ip=49.212.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b="Fab4JszZ"
Received: from [133.11.54.205] (h205.csg.ci.i.u-tokyo.ac.jp [133.11.54.205])
	(authenticated bits=0)
	by www3579.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 63K6Lj2B066789
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Mon, 20 Apr 2026 15:21:46 +0900 (JST)
	(envelope-from odaki@rsg.ci.i.u-tokyo.ac.jp)
DKIM-Signature: a=rsa-sha256; bh=FJ5CdXSzLkVwwaN2gkjigUMa98BbQG4sZbq6fGjnjvg=;
        c=relaxed/relaxed; d=rsg.ci.i.u-tokyo.ac.jp;
        h=From:Message-ID:To:Subject:Date;
        s=rs20250326; t=1776666106; v=1;
        b=Fab4JszZTcVq1Wcnn3GPi67jiAAuyi0vN2G2vLUb9wiEHaXeyWOJkP8k6OKIG/Bc
         MSLW8jYjzMErRS7+BPGAzAQj37qGFNtOApRCwgTMTfkhtKcrAVGud92dlFVeUf3M
         waOVb7QFgWsztepP+AjxR8oCG+yuABP9noUYDjyPUIuNlXuFXLU2Ufakz/L5MeEi
         5dnVj6poWbruKOBnHfQR3bWRS5xFuBh/fEVbPRwR3kCe8bA9K93Cc1OFqoB6KHfI
         fT64THxfBFME0MahSZA486qwy7PBjndEm7kgZ+ygWf59mGkv/qAIE7bYBie4RBIi
         J84VxqyKbF5pYOy69uV7tg==
Message-ID: <483e5cf2-a54c-4781-ac6d-49f5bc7128ba@rsg.ci.i.u-tokyo.ac.jp>
Date: Mon, 20 Apr 2026 15:21:45 +0900
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 2/4] KVM: arm64: PMU: Protect the list of PMUs with RCU
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu
 <yuzenghui@huawei.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Kees Cook <kees@kernel.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
        Shuah Khan <shuah@kernel.org>, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org, devel@daynix.com, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org
References: <20260418-hybrid-v7-0-2bf39ad009bf@rsg.ci.i.u-tokyo.ac.jp>
 <20260418-hybrid-v7-2-2bf39ad009bf@rsg.ci.i.u-tokyo.ac.jp>
 <87mryzauib.wl-maz@kernel.org>
Content-Language: en-US
From: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
In-Reply-To: <87mryzauib.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2026/04/19 23:34, Marc Zyngier wrote:
> On Sat, 18 Apr 2026 09:14:24 +0100,
> Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp> wrote:
>>
>> Convert the list of PMUs to a RCU-protected list that has primitives to
>> avoid read-side contention.
>>
>> Signed-off-by: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
>> ---
>>   arch/arm64/kvm/pmu-emul.c | 14 ++++++--------
>>   1 file changed, 6 insertions(+), 8 deletions(-)
>>
>> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
>> index 59ec96e09321..ef5140bbfe28 100644
>> --- a/arch/arm64/kvm/pmu-emul.c
>> +++ b/arch/arm64/kvm/pmu-emul.c
>> @@ -7,9 +7,9 @@
>>   #include <linux/cpu.h>
>>   #include <linux/kvm.h>
>>   #include <linux/kvm_host.h>
>> -#include <linux/list.h>
>>   #include <linux/perf_event.h>
>>   #include <linux/perf/arm_pmu.h>
>> +#include <linux/rculist.h>
>>   #include <linux/uaccess.h>
>>   #include <asm/kvm_emulate.h>
>>   #include <kvm/arm_pmu.h>
>> @@ -26,7 +26,6 @@ static bool kvm_pmu_counter_is_enabled(struct kvm_pmc *pmc);
>>   
>>   bool kvm_supports_guest_pmuv3(void)
>>   {
>> -	guard(mutex)(&arm_pmus_lock);
>>   	return !list_empty(&arm_pmus);
> 
> Please read include/linux/rculist.h and the discussion about the
> interaction of list_empty() with RCU-protected lists. How about using
> list_first_or_null_rcu() for peace of mind?

list_first_or_null_rcu() is useful to replace a sequence of list_empty() 
and list_first_entry() that is protected by a lock, but this function 
instead requires the invariant that nobody deletes an element from the 
list, and list_first_or_null_rcu() does not allow removing the requirement.

The header file says:
 > Where are list_empty_rcu() and list_first_entry_rcu()?
 >
 > They do not exist because they would lead to subtle race conditions:
 >
 > if (!list_empty_rcu(mylist)) {
 >	struct foo *bar = list_first_entry_rcu(mylist, struct foo,
 >					       list_member);
 >	do_something(bar);
 > }
 >
 > The list might be non-empty when list_empty_rcu() checks it, but it
 > might have become empty by the time that list_first_entry_rcu()
 > rereads the ->next pointer, which would result in a SEGV.
 >
 > When not using RCU, it is OK for list_first_entry() to re-read that
 > pointer because both functions should be protected by some lock that
 > blocks writers.
 >
 > When using RCU, list_empty() uses READ_ONCE() to fetch the
 > RCU-protected ->next pointer and then compares it to the address of
 > the  list head.  However, it neither dereferences this pointer nor
 > provides  this pointer to its caller.  Thus, READ_ONCE() suffices
 > (that is,  rcu_dereference() is not needed), which means that
 > list_empty() can be used anywhere you would want to use
 > list_empty_rcu().  Just don't expect anything useful to happen if you
 > do a subsequent lockless call to list_first_entry_rcu()!!!
 >
 > See list_first_or_null_rcu for an alternative.

However, kvm_supports_guest_pmuv3() locked a mutex when calling 
list_empty() and unlocked it immediately after that, instead of 
re-reading list_first_entry(). This construct inherently had a race 
condition with code that deletes an element; when the caller of 
kvm_supports_guest_pmuv3() decides to enable guest PMUv3, the host PMU 
may have been gone. But it was still safe because no one deletes an element.

The same logic also applies when using RCU. As the comment says, we can 
use list_empty() instead of the hypothetical list_empty_rcu() macro 
because we don't expect it to magically enable something like 
list_first_entry_rcu(). This function instead keep relying on the fact 
that no one deletes an element of the list.

Regards,
Akihiko Odaki
