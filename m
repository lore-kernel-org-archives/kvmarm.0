Received: from www3579.sakura.ne.jp (www3579.sakura.ne.jp [49.212.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 040394A02
	for <kvmarm@lists.linux.dev>; Mon, 20 Apr 2026 07:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.212.243.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776669467; cv=none; b=csY6TxHMgBKpLK9XpsqIf8EPnKIezXy834ieu8U/t/he/7B6/BZ5cuoZ9eKHnk2rkdq6VmwJ36frd8rItEw1YSu+YdqdmCsDpan/OVLmwZLJ2HZQOGDy3uZXeK5V6wD7PYWPGgTF2r9MUWbtzFrAHFmLU7FGbljkRc8E9cKeGrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776669467; c=relaxed/simple;
	bh=h7cVXMLbrvTvY+A6EhWUyavAlncNfGx/ABBI3U9Y1VU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VPVWoROnzNhz6LG5mK+wtV5WcIx4uK/zp/sjCR50GNNYysi8FpeBkAiu4kzx5OaTi99XGMgCld2BF4LxNZUeUoc/mDnSp78j4jmVu5xi2pMtfi4Z8JUSGrjYmFx1l6yVKT65v2wWy3XQTzAeRFI74q9qyGuZHT5CCHOuig6IxTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp; dkim=fail (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b=APXUqz2j reason="key not found in DNS"; arc=none smtp.client-ip=49.212.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b="APXUqz2j"
Received: from [133.11.54.205] (h205.csg.ci.i.u-tokyo.ac.jp [133.11.54.205])
	(authenticated bits=0)
	by www3579.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 63K7H3FD094475
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Mon, 20 Apr 2026 16:17:03 +0900 (JST)
	(envelope-from odaki@rsg.ci.i.u-tokyo.ac.jp)
DKIM-Signature: a=rsa-sha256; bh=0Vf/ig+2VJ+qKyawl6wvubkKzkh75f9RwRdOhQAcrwI=;
        c=relaxed/relaxed; d=rsg.ci.i.u-tokyo.ac.jp;
        h=From:Message-ID:To:Subject:Date;
        s=rs20250326; t=1776669423; v=1;
        b=APXUqz2jiH7GGh4C/kSSbquiyIjX0IN59+Fnp3fr3PwncA0Y2oLV20pYlcaK8kwj
         crJEWRowgPUz3uPtEc0GdxcNuPoS+Y6JcJHTsoVZSwsCdUQroPb9PAnFolqEzPVq
         1L4gGQx+oOjniadg5MlGy7YS/zz6eLKcidbwWNxbAiLFzDAxUkTm26Z4+O55FKoW
         EjRCpoRmCmRY8k+EkBSLvQQvdVnrbA7HKsgZYSZdYviCl7q0+xkuOpU02uWdnvPS
         pSs+HffGl+YEDz7vbOzPpG+roOp+g15+iJKBt6m4TLMv4o52MK8ENMco4hJbQ0Ws
         nsNU8L6hbqYUvs+5y5Lvew==
Message-ID: <2ffd2759-e299-4b3d-9f04-d2ab14d92465@rsg.ci.i.u-tokyo.ac.jp>
Date: Mon, 20 Apr 2026 16:17:03 +0900
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
 <483e5cf2-a54c-4781-ac6d-49f5bc7128ba@rsg.ci.i.u-tokyo.ac.jp>
 <86se8q15eo.wl-maz@kernel.org>
Content-Language: en-US
From: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
In-Reply-To: <86se8q15eo.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2026/04/20 16:01, Marc Zyngier wrote:
> On Mon, 20 Apr 2026 07:21:45 +0100,
> Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp> wrote:
>>
>> On 2026/04/19 23:34, Marc Zyngier wrote:
>>> On Sat, 18 Apr 2026 09:14:24 +0100,
>>> Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp> wrote:
>>>>
>>>> Convert the list of PMUs to a RCU-protected list that has primitives to
>>>> avoid read-side contention.
>>>>
>>>> Signed-off-by: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
>>>> ---
>>>>    arch/arm64/kvm/pmu-emul.c | 14 ++++++--------
>>>>    1 file changed, 6 insertions(+), 8 deletions(-)
>>>>
>>>> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
>>>> index 59ec96e09321..ef5140bbfe28 100644
>>>> --- a/arch/arm64/kvm/pmu-emul.c
>>>> +++ b/arch/arm64/kvm/pmu-emul.c
>>>> @@ -7,9 +7,9 @@
>>>>    #include <linux/cpu.h>
>>>>    #include <linux/kvm.h>
>>>>    #include <linux/kvm_host.h>
>>>> -#include <linux/list.h>
>>>>    #include <linux/perf_event.h>
>>>>    #include <linux/perf/arm_pmu.h>
>>>> +#include <linux/rculist.h>
>>>>    #include <linux/uaccess.h>
>>>>    #include <asm/kvm_emulate.h>
>>>>    #include <kvm/arm_pmu.h>
>>>> @@ -26,7 +26,6 @@ static bool kvm_pmu_counter_is_enabled(struct kvm_pmc *pmc);
>>>>      bool kvm_supports_guest_pmuv3(void)
>>>>    {
>>>> -	guard(mutex)(&arm_pmus_lock);
>>>>    	return !list_empty(&arm_pmus);
>>>
>>> Please read include/linux/rculist.h and the discussion about the
>>> interaction of list_empty() with RCU-protected lists. How about using
>>> list_first_or_null_rcu() for peace of mind?
>>
>> list_first_or_null_rcu() is useful to replace a sequence of
>> list_empty() and list_first_entry() that is protected by a lock, but
>> this function instead requires the invariant that nobody deletes an
>> element from the list, and list_first_or_null_rcu() does not allow
>> removing the requirement.
>>
>> The header file says:
>>> Where are list_empty_rcu() and list_first_entry_rcu()?
>>>
>>> They do not exist because they would lead to subtle race conditions:
>>>
>>> if (!list_empty_rcu(mylist)) {
>>> 	struct foo *bar = list_first_entry_rcu(mylist, struct foo,
>>> 					       list_member);
>>> 	do_something(bar);
>>> }
>>>
>>> The list might be non-empty when list_empty_rcu() checks it, but it
>>> might have become empty by the time that list_first_entry_rcu()
>>> rereads the ->next pointer, which would result in a SEGV.
>>>
>>> When not using RCU, it is OK for list_first_entry() to re-read that
>>> pointer because both functions should be protected by some lock that
>>> blocks writers.
>>>
>>> When using RCU, list_empty() uses READ_ONCE() to fetch the
>>> RCU-protected ->next pointer and then compares it to the address of
>>> the  list head.  However, it neither dereferences this pointer nor
>>> provides  this pointer to its caller.  Thus, READ_ONCE() suffices
>>> (that is,  rcu_dereference() is not needed), which means that
>>> list_empty() can be used anywhere you would want to use
>>> list_empty_rcu().  Just don't expect anything useful to happen if you
>>> do a subsequent lockless call to list_first_entry_rcu()!!!
>>>
>>> See list_first_or_null_rcu for an alternative.
>>
>> However, kvm_supports_guest_pmuv3() locked a mutex when calling
>> list_empty() and unlocked it immediately after that, instead of
>> re-reading list_first_entry(). This construct inherently had a race
>> condition with code that deletes an element; when the caller of
>> kvm_supports_guest_pmuv3() decides to enable guest PMUv3, the host PMU
>> may have been gone. But it was still safe because no one deletes an
>> element.
>>
>> The same logic also applies when using RCU. As the comment says, we
>> can use list_empty() instead of the hypothetical list_empty_rcu()
>> macro because we don't expect it to magically enable something like
>> list_first_entry_rcu(). This function instead keep relying on the fact
>> that no one deletes an element of the list.
> 
> And that's exactly the sort of thing I am trying to plan for. *Should*
> we introduce a way to remove PMUs from the list, this predicate
> becomes unsafe.

Perhaps so. In regards to this series, I'd rather like to keep it out of 
scope as the requirement is not new.

> 
> So I want at least a comment explaining this to the unsuspecting
> reader, as this is rather subtle.

I agree. I had to put some effort to understand the previous 
mutex-protected implementation and to design the new RCU-protected one. 
I'll add one with the next version.

Regards,
Akihiko Odaki
