Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF831C43217
	for <kvmarm@archiver.kernel.org>; Fri, 18 Nov 2022 02:29:53 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 27A1E4B754;
	Thu, 17 Nov 2022 21:29:53 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Zjg21el4ev66; Thu, 17 Nov 2022 21:29:51 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 16AC84B802;
	Thu, 17 Nov 2022 21:29:51 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D05C24B754
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Nov 2022 21:29:50 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id n-BwR0YcojIM for <kvmarm@lists.cs.columbia.edu>;
 Thu, 17 Nov 2022 21:29:46 -0500 (EST)
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 49A684B69D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Nov 2022 21:29:46 -0500 (EST)
Received: from dggpemm500023.china.huawei.com (unknown [172.30.72.57])
 by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4ND126472Wz15Mbg;
 Fri, 18 Nov 2022 10:29:18 +0800 (CST)
Received: from [10.174.187.128] (10.174.187.128) by
 dggpemm500023.china.huawei.com (7.185.36.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 18 Nov 2022 10:29:41 +0800
Subject: Re: disabling halt polling broken? (was Re: [PATCH 00/14] KVM:
 Halt-polling fixes, cleanups and a new stat)
To: David Matlack <dmatlack@google.com>
References: <20210925005528.1145584-1-seanjc@google.com>
 <03f2f5ab-e809-2ba5-bd98-3393c3b843d2@de.ibm.com>
 <YVHcY6y1GmvGJnMg@google.com>
 <f37ab68c-61ce-b6fb-7a49-831bacfc7424@redhat.com>
 <43e42f5c-9d9f-9e8b-3a61-9a053a818250@de.ibm.com>
 <CABgObfYtS6wiQe=BhF3t5usr7J6q4PWE4=rwZMMukfC9wT_6fA@mail.gmail.com>
 <YVIAdVxc+q2UWB+J@google.com>
 <32810c89-44c6-6780-9d05-e49f6b897b6e@huawei.com>
 <Y3UboELxugwDJkIG@google.com>
From: "wangyanan (Y)" <wangyanan55@huawei.com>
Message-ID: <e124456c-0691-460b-c471-00ac1d7b0254@huawei.com>
Date: Fri, 18 Nov 2022 10:29:40 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <Y3UboELxugwDJkIG@google.com>
Content-Language: en-US
X-Originating-IP: [10.174.187.128]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500023.china.huawei.com (7.185.36.83)
X-CFilter-Loop: Reflected
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm <kvm@vger.kernel.org>,
 David Hildenbrand <david@redhat.com>,
 "open list:MIPS" <linux-mips@vger.kernel.org>,
 Paul Mackerras <paulus@ozlabs.org>, Claudio Imbrenda <imbrenda@linux.ibm.com>,
 KVM ARM <kvmarm@lists.cs.columbia.edu>, Janosch Frank <frankja@linux.ibm.com>,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>, wangyuan38@huawei.com,
 Jon Cargille <jcargill@google.com>, kvm-ppc <kvm-ppc@vger.kernel.org>,
 linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
 Jim Mattson <jmattson@google.com>, Cornelia Huck <cohuck@redhat.com>,
 "Kernel Mailing List, Linux" <linux-kernel@vger.kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu



On 2022/11/17 1:19, David Matlack wrote:
> On Tue, Nov 15, 2022 at 11:28:56AM +0800, wangyanan (Y) wrote:
>> Hi Sean, Paolo,
>>
>> I recently also notice the behavior change of param halt_poll_ns.
>> Now it loses the ability to:
>> 1) dynamically disable halt polling for all the running VMs
>> by `echo 0 > /sys`
>> 2) dynamically adjust the halt polling interval for all the
>> running VMs by `echo * > /sys`
>>
>> While in our cases, we usually use above two abilities, and
>> KVM_CAP_HALT_POLL is not used yet.
> I think the right path forward is to make KVM_CAP_HALT_POLL a pure
> override of halt_poll_ns, and restore the pre-existing behavior of
> halt_poll_ns whenever KVM_CAP_HALT_POLL is not used. e.g. see the patch
> below.
Agree with this.
kvm.halt_poll_ns serves like a legacy method to control halt polling
globally. Once KVM_CAP_HALT_POLL is used for a VM, it should
hold 100% responsibility to control on the VM, including disabling
the polling. This strategy helps to keep the two mechanisms
decoupled.
> That will fix issues (1) and (2) above for any VM not using
> KVM_CAP_HALT_POLL. If a VM is using KVM_CAP_HALT_POLL, it will ignore
> all changes to halt_poll_ns. If we truly need a mechanism for admins to
> disable halt-polling on VMs using KVM_CAP_HALT_POLL, we can introduce a
> separate module parameter for that. But IMO, any setup that is
> sophisticated enough to use KVM_CAP_HALT_POLL should also be able to use
> KVM_CAP_HALT_POLL to disable halt polling.
>
> If everyone is happy with this approach I can test and send a real patch
> to the mailing list.
>
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index e6e66c5e56f2..253ad055b6ad 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -788,6 +788,7 @@ struct kvm {
>   	struct srcu_struct srcu;
>   	struct srcu_struct irq_srcu;
>   	pid_t userspace_pid;
> +	bool override_halt_poll_ns;
>   	unsigned int max_halt_poll_ns;
>   	u32 dirty_ring_size;
>   	bool vm_bugged;
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 43bbe4fde078..479d0d0da0b5 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1198,8 +1198,6 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
>   			goto out_err_no_arch_destroy_vm;
>   	}
>   
> -	kvm->max_halt_poll_ns = halt_poll_ns;
> -
>   	r = kvm_arch_init_vm(kvm, type);
>   	if (r)
>   		goto out_err_no_arch_destroy_vm;
> @@ -3371,7 +3369,7 @@ void kvm_sigset_deactivate(struct kvm_vcpu *vcpu)
>   	sigemptyset(&current->real_blocked);
>   }
>   
> -static void grow_halt_poll_ns(struct kvm_vcpu *vcpu)
> +static void grow_halt_poll_ns(struct kvm_vcpu *vcpu, unsigned int max)
>   {
>   	unsigned int old, val, grow, grow_start;
>   
> @@ -3385,8 +3383,8 @@ static void grow_halt_poll_ns(struct kvm_vcpu *vcpu)
>   	if (val < grow_start)
>   		val = grow_start;
>   
> -	if (val > vcpu->kvm->max_halt_poll_ns)
> -		val = vcpu->kvm->max_halt_poll_ns;
> +	if (val > max)
> +		val = max;
>   
>   	vcpu->halt_poll_ns = val;
>   out:
> @@ -3501,10 +3499,17 @@ void kvm_vcpu_halt(struct kvm_vcpu *vcpu)
>   {
>   	bool halt_poll_allowed = !kvm_arch_no_poll(vcpu);
>   	bool do_halt_poll = halt_poll_allowed && vcpu->halt_poll_ns;
> +	unsigned int max_halt_poll_ns;
>   	ktime_t start, cur, poll_end;
> +	struct kvm *kvm = vcpu->kvm;
>   	bool waited = false;
>   	u64 halt_ns;
>   
> +	if (kvm->override_halt_poll_ns)
> +		max_halt_poll_ns = kvm->max_halt_poll_ns;
> +	else
> +		max_halt_poll_ns = READ_ONCE(halt_poll_ns);
> +
>   	start = cur = poll_end = ktime_get();
>   	if (do_halt_poll) {
>   		ktime_t stop = ktime_add_ns(start, vcpu->halt_poll_ns);
> @@ -3545,17 +3550,16 @@ void kvm_vcpu_halt(struct kvm_vcpu *vcpu)
>   	if (halt_poll_allowed) {
>   		if (!vcpu_valid_wakeup(vcpu)) {
>   			shrink_halt_poll_ns(vcpu);
> -		} else if (vcpu->kvm->max_halt_poll_ns) {
> +		} else if (max_halt_poll_ns) {
>   			if (halt_ns <= vcpu->halt_poll_ns)
>   				;
>   			/* we had a long block, shrink polling */
> -			else if (vcpu->halt_poll_ns &&
> -				 halt_ns > vcpu->kvm->max_halt_poll_ns)
> +			else if (vcpu->halt_poll_ns && halt_ns > max_halt_poll_ns)
>   				shrink_halt_poll_ns(vcpu);
>   			/* we had a short halt and our poll time is too small */
> -			else if (vcpu->halt_poll_ns < vcpu->kvm->max_halt_poll_ns &&
> -				 halt_ns < vcpu->kvm->max_halt_poll_ns)
> -				grow_halt_poll_ns(vcpu);
> +			else if (vcpu->halt_poll_ns < max_halt_poll_ns &&
> +				 halt_ns < max_halt_poll_ns)
> +				grow_halt_poll_ns(vcpu, max_halt_poll_ns);
>   		} else {
>   			vcpu->halt_poll_ns = 0;
>   		}
> @@ -4588,6 +4592,7 @@ static int kvm_vm_ioctl_enable_cap_generic(struct kvm *kvm,
>   		if (cap->flags || cap->args[0] != (unsigned int)cap->args[0])
>   			return -EINVAL;
>   
> +		kvm->override_halt_poll_ns = true;
>   		kvm->max_halt_poll_ns = cap->args[0];
>   		return 0;
>   	}
Looks sensible to me overall.
I will look at the RFC series, thanks for your quick response.

Yanan
.
>> On 2021/9/28 1:33, Sean Christopherson wrote:
>>> On Mon, Sep 27, 2021, Paolo Bonzini wrote:
>>>> On Mon, Sep 27, 2021 at 5:17 PM Christian Borntraeger
>>>> <borntraeger@de.ibm.com> wrote:
>>>>>> So I think there are two possibilities that makes sense:
>>>>>>
>>>>>> * track what is using KVM_CAP_HALT_POLL, and make writes to halt_poll_ns follow that
>>>>> what about using halt_poll_ns for those VMs that did not uses KVM_CAP_HALT_POLL and the private number for those that did.
>>>> Yes, that's what I meant.  David pointed out that doesn't allow you to
>>>> disable halt polling altogether, but for that you can always ask each
>>>> VM's userspace one by one, or just not use KVM_CAP_HALT_POLL. (Also, I
>>>> don't know about Google's usecase, but mine was actually more about
>>>> using KVM_CAP_HALT_POLL to *disable* halt polling on some VMs!).
>>> I kinda like the idea if special-casing halt_poll_ns=0, e.g. for testing or
>>> in-the-field mitigation if halt-polling is broken.  It'd be trivial to support, e.g.
>> Do we have any plan to repost the diff as a fix?
>> I would be very nice that this issue can be solved.
>>
>> Besides, I think we may need some Doc for users to describe
>> how halt_poll_ns works with KVM_CAP_HALT_POLL, like
>> "Documentation/virt/guest-halt-polling.rst".
>>> @@ -3304,19 +3304,23 @@ void kvm_vcpu_halt(struct kvm_vcpu *vcpu)
>>>                   update_halt_poll_stats(vcpu, start, poll_end, !waited);
>>>
>>>           if (halt_poll_allowed) {
>>> +               max_halt_poll_ns = vcpu->kvm->max_halt_poll_ns;
>>> +               if (!max_halt_poll_ns || !halt_poll_ns)  <------ squish the max if halt_poll_ns==0
>>> +                       max_halt_poll_ns = halt_poll_ns;
>>> +
>> Does this mean that KVM_CAP_HALT_POLL will not be able to
>> disable halt polling for a VM individually when halt_poll_ns !=0?
>>>                   if (!vcpu_valid_wakeup(vcpu)) {
>>>                           shrink_halt_poll_ns(vcpu);
>>> -               } else if (vcpu->kvm->max_halt_poll_ns) {
>>> +               } else if (max_halt_poll_ns) {
>>>                           if (halt_ns <= vcpu->halt_poll_ns)
>>>                                   ;
>>>                           /* we had a long block, shrink polling */
>>>                           else if (vcpu->halt_poll_ns &&
>>> -                                halt_ns > vcpu->kvm->max_halt_poll_ns)
>>> +                                halt_ns > max_halt_poll_ns)
>>>                                   shrink_halt_poll_ns(vcpu);
>>>                           /* we had a short halt and our poll time is too small */
>>> -                       else if (vcpu->halt_poll_ns < vcpu->kvm->max_halt_poll_ns &&
>>> -                                halt_ns < vcpu->kvm->max_halt_poll_ns)
>>> -                               grow_halt_poll_ns(vcpu);
>>> +                       else if (vcpu->halt_poll_ns < max_halt_poll_ns &&
>>> +                                halt_ns < max_halt_poll_ns)
>>> +                               grow_halt_poll_ns(vcpu, max_halt_poll_ns);
>>>                   } else {
>>>                           vcpu->halt_poll_ns = 0;
>>>                   }
>>> _______________________________________________
>>> kvmarm mailing list
>>> kvmarm@lists.cs.columbia.edu
>>> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
>>> .
>> Thanks,
>> Yanan
> .

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
