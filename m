Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFBDA3D9DBF;
	Thu, 30 Jul 2026 08:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785401261; cv=none; b=Bqhf7YEeujTD9ObPjstL0SzBpVTgKIxKW4hnyglAwMTFjl844H3oxzOl5uSo7W9CZgqUaq2Fs/xjPKYJqDmaC7oY1u5U+USl7ghEOFnbjzPbKCOW2sMtmvctUJ+mhFJ2Cjr8UV+uJvU5idoCb1ZL+21LeoplcI8Z344vpLwDuzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785401261; c=relaxed/simple;
	bh=NF6CVCP5rayLeYmCb+Hp0tt9lxGmXGx3Nh0bLF2qWW8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=soz7EWscJt+7vgmsPnmQeNhGrtiJnE2l30QJp0L83CBHpMyQR6ngu/akKVlExFL7XaL4LszM4itRtYzxq6V7T9Iw+lTrNU37D1QdTla2BjaeUcMi0qXCYVE30GZKdTYmH/KPQq4azUkNUhFNKiEwu29MNNUufsOo3z7gCmxLpFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=NMM3xcMr; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="NMM3xcMr"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 724871684;
	Thu, 30 Jul 2026 01:47:32 -0700 (PDT)
Received: from [10.1.25.28] (e122027.cambridge.arm.com [10.1.25.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A35EB3F86F;
	Thu, 30 Jul 2026 01:47:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785401256; bh=NF6CVCP5rayLeYmCb+Hp0tt9lxGmXGx3Nh0bLF2qWW8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=NMM3xcMrCXMylVU2uhyif9apu4tRv1/ulSUa/4zzwefu3iFuYmiuRcKu7MhYHiM32
	 ZkosZs53h6NRg2uC9iLjfIVMIB6z5hwLNZnGWjHeZFxltOJyj8DwE2Fy/JjiQ5lESn
	 00/eg9A9lnuMK9v+ThlYH6jXj3zB9IjsldgYRMqs=
Message-ID: <56f2ae6a-a45b-4ef4-8503-5f095a834b09@arm.com>
Date: Thu, 30 Jul 2026 09:47:27 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 13/37] KVM: arm64: CCA: Support timers in realm RECs
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 James Morse <james.morse@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>,
 Vishal Annapurve <vannapurve@google.com>, WeiLin.Chang@arm.com,
 Lorenzo Pieralisi <lpieralisi@kernel.org>
References: <20260715142841.80544-1-steven.price@arm.com>
 <20260715142841.80544-14-steven.price@arm.com> <861pcoeqk5.wl-maz@kernel.org>
 <dff2eee7-09cf-4f85-8dec-c7c243f3ba0f@arm.com> <86qzkmcbaq.wl-maz@kernel.org>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <86qzkmcbaq.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 29/07/2026 11:58, Marc Zyngier wrote:
> On Wed, 29 Jul 2026 11:47:03 +0100,
> Steven Price <steven.price@arm.com> wrote:
>>
>> On 27/07/2026 10:21, Marc Zyngier wrote:
>>> On Wed, 15 Jul 2026 15:28:15 +0100,
>>> Steven Price <steven.price@arm.com> wrote:
>>>>
>>>> The RMM keeps track of the timer while the realm REC is running, but on
>>>> exit to the normal world KVM is responsible for handling the timers.
>>>>
>>>> A later patch adds the support for propagating the timer values from the
>>>> exit data structure and calling kvm_realm_timers_update().
>>>>
>>>> Signed-off-by: Steven Price <steven.price@arm.com>
>>>> ---
>>>> Changes since v14:
>>>>  * Special case in kvm_timer_vcpu_load()/kvm_timer_vcpu_put() the timer
>>>>    handling.
>>>> Changes since v12:
>>>>  * Adapt to upstream changes.
>>>> Changes since v11:
>>>>  * Drop the kvm_is_realm() check from timer_set_offset(). We already
>>>>    ensure that the offset is 0 when calling the function.
>>>> Changes since v10:
>>>>  * KVM_CAP_COUNTER_OFFSET is now already hidden by a previous patch.
>>>> Changes since v9:
>>>>  * No need to move the call to kvm_timer_unblocking() in
>>>>    kvm_timer_vcpu_load().
>>>> Changes since v7:
>>>>  * Hide KVM_CAP_COUNTER_OFFSET for realm guests.
>>>> ---
>>>>  arch/arm64/kvm/arch_timer.c  | 38 +++++++++++++++++++++++++++++++++---
>>>>  include/kvm/arm_arch_timer.h |  2 ++
>>>>  2 files changed, 37 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
>>>> index 4155fe89b58a..fdd68f1f5b7b 100644
>>>> --- a/arch/arm64/kvm/arch_timer.c
>>>> +++ b/arch/arm64/kvm/arch_timer.c
>>>> @@ -482,6 +482,20 @@ static void kvm_timer_update_irq(struct kvm_vcpu *vcpu, bool new_level,
>>>>  			    timer_ctx);
>>>>  }
>>>>  
>>>> +void kvm_realm_timers_update(struct kvm_vcpu *vcpu)
>>>> +{
>>>> +	struct arch_timer_cpu *arch_timer = &vcpu->arch.timer_cpu;
>>>> +	int i;
>>>> +
>>>> +	for (i = 0; i < NR_KVM_EL0_TIMERS; i++) {
>>>> +		struct arch_timer_context *timer = &arch_timer->timers[i];
>>>> +		bool status = timer_get_ctl(timer) & ARCH_TIMER_CTRL_IT_STAT;
>>>> +		bool level = kvm_timer_enabled(timer) && status;
>>>> +
>>>> +		kvm_timer_update_irq(vcpu, level, timer);
>>>> +	}
>>>> +}
>>>> +
>>>
>>> Why do we need this? What is so special about CCA that it cannot use
>>> the existing timer flow?
>>
>> CCA is a little special because the timer context is owned by the RMM
>> while the realm is executing. It's the RMM which actually loads/saves
>> the timer registers not KVM.
>>
>> The RMM returns some of the timer state on every exit, and the host is
>> responsible for updating the interrupt status (as the host controls the
>> GIC emulation).
> 
> But KVM relies on the timers being live when the vcpu is loaded. So
> the first port of call should be for CCA to adapt to KVM, and not the
> other way around.
> 
> You can always make sure that the timers are in the registers at the
> point where you reach the KVM code.

Indeed if you'd prefer that I can modify the code to load the timer
state into the registers in the Linux CCA code before reaching the
generic KVM code. It's a little weird from an overall point of view (the
RMM saves the state into memory, and then Linux reloads it just to save
it again), but I don't see any implementation issues.

But a quick go at implementing this does indeed seem to save us a bit of
code, so I'll include this in the next posting.

Thanks,
Steve

