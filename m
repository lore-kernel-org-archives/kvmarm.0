From: gengdongjiu <gengdongjiu@huawei.com>
Subject: Re: [PATCH v2] KVM: arm/arm64: Fix external abort type matching
Date: Sat, 28 Oct 2017 13:22:36 +0800
Message-ID: <756c3914-232a-4cb7-d614-a96146185c99@huawei.com>
References: <0184EA26B2509940AA629AE1405DD7F2016E999C@DGGEMA503-MBS.china.huawei.com>
 <86a80ca1in.fsf@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 23CAC40EA6
 for <kvmarm@lists.cs.columbia.edu>; Sat, 28 Oct 2017 01:25:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SBATJYMBjZGB for <kvmarm@lists.cs.columbia.edu>;
 Sat, 28 Oct 2017 01:25:22 -0400 (EDT)
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3B129405F9
 for <kvmarm@lists.cs.columbia.edu>; Sat, 28 Oct 2017 01:25:20 -0400 (EDT)
In-Reply-To: <86a80ca1in.fsf@arm.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: "catalin.marinas@arm.com" <catalin.marinas@arm.com>, "tbaicar@codeaurora.org" <tbaicar@codeaurora.org>, "will.deacon@arm.com" <will.deacon@arm.com>, "linux@armlinux.org.uk" <linux@armlinux.org.uk>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu


On 2017/10/28 2:28, Marc Zyngier wrote:
>> kvm_vcpu_trap_get_fault_type() will clear the low two bits to zero. So
>> I use FSC_SEA_TTW represent "Synchronous external abort on translation
>> table walk"
> I understand that, and I certainly not keen on adding another "fault
> type" for this.
 Ok,  thanks.

> 
>> As we can see the Translation fault type "FSC_FAULT", which does not
>> define the "FSC_FAULT0" "FSC_FAULT1" "FSC_FAULT2" "FSC_FAULT3".
>> Because the fault type " FSC_FAULT " include the four cases. 
> Indeed, and I'm still not convinced this is the best thing we have in
> the code.
Ok, thanks.


> 
>> static inline u8 kvm_vcpu_trap_get_fault(const struct kvm_vcpu *vcpu)
>> {
>> 	return kvm_vcpu_get_hsr(vcpu) & 0x3f;
>> }
> Here you go. This should give you a pretty good idea of how to provide a
> proper fix.
OK, got it, thanks

> 
> Thanks,
