From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v2] KVM: arm/arm64: Signal SIGBUS when stage2 discovers
 hwpoison memory
Date: Fri, 23 Jun 2017 10:38:13 +0100
Message-ID: <594CE185.60902@arm.com>
References: <20170524163250.29281-1-james.morse@arm.com>
 <3dbafd74-57f2-e724-ace2-0f84abb57e59@huawei.com> <594A4205.70201@arm.com>
 <3a02e425-5782-dad4-efda-fdc5df73dcf7@huawei.com> <594A6A45.60909@arm.com>
 <ae7a4ac0-d38a-d6fe-2138-c21da23607c6@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AFFC14095A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Jun 2017 05:34:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nCaUGctOdKSC for <kvmarm@lists.cs.columbia.edu>;
 Fri, 23 Jun 2017 05:34:31 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4139140430
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Jun 2017 05:34:31 -0400 (EDT)
In-Reply-To: <ae7a4ac0-d38a-d6fe-2138-c21da23607c6@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: gengdongjiu <gengdongjiu@huawei.com>
Cc: wuquanming <wuquanming@huawei.com>, Marc Zyngier <marc.zyngier@arm.com>, Achin Gupta <Achin.Gupta@arm.com>, Punit Agrawal <punit.agrawal@arm.com>, Tyler Baicar <tbaicar@codeaurora.org>, Huangshaoyu <huangshaoyu@huawei.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi gengdongjiu,

I've spotted where we are disagreeing: there are two bits in the ESR relevant to
external aborts. I've been treating them the same.

It looks like KVM is testing the wrong bit.


On 22/06/17 07:47, gengdongjiu wrote:
> On 2017/6/21 20:44, James Morse wrote:
>> I think we are looking at different parts of the code, here is what I see should
>> happen:
>>
>> For a Synchronous External Abort the ESR {D,I}FSC bits will be in the range that
>> indicates an external abort. For a data:external-abort kvm_handle_guest_abort()
>> will matches this with kvm_vcpu_dabt_isextabt() and makes no further attempt to
>> handle the fault.
> The kvm_vcpu_dabt_isextabt() will check the ESR EA bit[9]
> The EA bit [9] is "IMPLEMENTATION DEFINED", so whether match with the kvm_vcpu_dabt_isextabt() depend on the CPU design.
> In my platform the EA bit is zero for the RAS Synchronous External Abort, so will not matches the kvm_vcpu_dabt_isextabt(), so the code will continue handle the fault.
> 
> 
> static inline bool kvm_vcpu_dabt_isextabt(struct kvm_vcpu *vcpu)
> {
> 	return kvm_vcpu_get_hsr(vcpu) & HSR_DABT_EA;
> }
> 
> EA, bit [9]
> 	External Abort. As described in the Architecture Reference Manual. Provides an IMPLEMENTATION
> 	DEFINED classification of the external abort.

(and here you pointed it out, sorry I missed it).

This bit 9 isn't the same as the {I,D}FSC bit 4, which is also always set for an
external abort.


> DFSC, bits [5:0], when synchronous external Data Abort
> 	Data Fault Status Code. The possible values of this field are:
> 	0b010000 Synchronous External Abort on memory access.
> 	0b0101xx Synchronous External Abort on translation table walk or hardware update of translation
> 	table. DFSC[1:0] encode the level.
> 	Further values are described in the Architecture Reference Manual. The Parity Error codes are not
> 	used and reserved in the RAS extension.
> IFSC, bits [5:0], when synchronous external Instruction Abort
> 	Instruction Fault Status Code. The possible values of this field are:
> 	0b010000 Synchronous External Abort on memory access.
> 	0b0101xx Synchronous External Abort on translation table walk or hardware update of translation
> 	table. IFSC[1:0] encode the level.
> 	Further values are described in the Architecture Reference Manual. The Parity Error codes are not
> 	used and reserved in the RAS extension.


So the v8 ARM-ARM has two ways of indicating an external abort, KVM tests bit 9.
The v7 ARM-ARm has a '{D,I}FSR.ExT' bit, which I think is equivalent. Its
described as:
> An implementation can use the DFSR.ExT and IFSR.ExT bits to provide more
> information about external aborts.

This is what the v8 version must mean with its
> External abort type. This bit can provide an IMPLEMENTATION DEFINED
> classification of External aborts.

Which I read as IMP-DEF classification 'as external', as opposed to your reading
as an extra IMP-DEF classification for external aborts.

It looks like an implementation could use this to mean 'how external'. For RAS
an implementation could use it to separate external aborts handled first by
firmware, from those generated directly by the CPU.

So which bits should Linux test? Bit 9 has some extra IMP-DEF meaning, so Linux
should never look at it, which means KVM has a bug handling these.
I will send a patch, are you able to review and test it?


Thanks!

James
