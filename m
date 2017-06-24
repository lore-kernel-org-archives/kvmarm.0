From: gengdongjiu <gengdongjiu@huawei.com>
Subject: Re: [PATCH v2] KVM: arm/arm64: Signal SIGBUS when stage2 discovers
 hwpoison memory
Date: Sat, 24 Jun 2017 16:23:52 +0800
Message-ID: <9fa76f8d-c360-9fcc-29f6-4bef6fbf85c2@huawei.com>
References: <20170524163250.29281-1-james.morse@arm.com>
 <3dbafd74-57f2-e724-ace2-0f84abb57e59@huawei.com> <594A4205.70201@arm.com>
 <3a02e425-5782-dad4-efda-fdc5df73dcf7@huawei.com> <594A6A45.60909@arm.com>
 <ae7a4ac0-d38a-d6fe-2138-c21da23607c6@huawei.com> <594CE185.60902@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <594CE185.60902@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: James Morse <james.morse@arm.com>
Cc: wuquanming <wuquanming@huawei.com>, Marc Zyngier <marc.zyngier@arm.com>, Achin Gupta <Achin.Gupta@arm.com>, Punit Agrawal <punit.agrawal@arm.com>, Tyler Baicar <tbaicar@codeaurora.org>, Huangshaoyu <huangshaoyu@huawei.com>, linux-arm-kernel@lists.infradead.org, huhuajun <huhuajun@huawei.com>, kvmarm@lists.cs.columbia.edu, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi James,
  sorry for the late response.

On 2017/6/23 17:38, James Morse wrote:
> Hi gengdongjiu,
> 
> I've spotted where we are disagreeing: there are two bits in the ESR relevant to
> external aborts. I've been treating them the same.
Ok.

> 
> It looks like KVM is testing the wrong bit.
I agree with you the KVM should not test this bit, because it is IMPLEMENTATION DEFINED classification.
from this patch history, it is made by Marc. do know whether it has some special reason to make this patch.

commit 4055710baca8cb067b059a635cf851eb86410a83
Author: Marc Zyngier <marc.zyngier@arm.com>
Date:   Tue Sep 6 14:02:15 2016 +0100

    arm/arm64: KVM: Inject virtual abort when guest exits on external abort

    If we spot a data abort bearing the ESR_EL2.EA bit set, we know that
    this is an external abort, and that should be punished by the injection
    of an abort.

    Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
    Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>

diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
index 344755d..60e0c1a 100644
--- a/arch/arm/kvm/mmu.c
+++ b/arch/arm/kvm/mmu.c
@@ -1432,6 +1432,11 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu, struct kvm_run *run)
        int ret, idx;

        is_iabt = kvm_vcpu_trap_is_iabt(vcpu);
+       if (unlikely(!is_iabt && kvm_vcpu_dabt_isextabt(vcpu))) {
+               kvm_inject_vabt(vcpu);
+               return 1;
+       }
+
        fault_ipa = kvm_vcpu_get_fault_ipa(vcpu);

        trace_kvm_guest_fault(*vcpu_pc(vcpu), kvm_vcpu_get_hsr(vcpu)

> 
> 
> On 22/06/17 07:47, gengdongjiu wrote:
>> On 2017/6/21 20:44, James Morse wrote:
>>> I think we are looking at different parts of the code, here is what I see should
>>> happen:
>>>
>>> For a Synchronous External Abort the ESR {D,I}FSC bits will be in the range that
>>> indicates an external abort. For a data:external-abort kvm_handle_guest_abort()
>>> will matches this with kvm_vcpu_dabt_isextabt() and makes no further attempt to
>>> handle the fault.
>> The kvm_vcpu_dabt_isextabt() will check the ESR EA bit[9]
>> The EA bit [9] is "IMPLEMENTATION DEFINED", so whether match with the kvm_vcpu_dabt_isextabt() depend on the CPU design.
>> In my platform the EA bit is zero for the RAS Synchronous External Abort, so will not matches the kvm_vcpu_dabt_isextabt(), so the code will continue handle the fault.
>>
>>
>> static inline bool kvm_vcpu_dabt_isextabt(struct kvm_vcpu *vcpu)
>> {
>> 	return kvm_vcpu_get_hsr(vcpu) & HSR_DABT_EA;
>> }
>>
>> EA, bit [9]
>> 	External Abort. As described in the Architecture Reference Manual. Provides an IMPLEMENTATION
>> 	DEFINED classification of the external abort.
> 
> (and here you pointed it out, sorry I missed it).
> 
> This bit 9 isn't the same as the {I,D}FSC bit 4, which is also always set for an
> external abort.
 yes, they are two different bits

> 
> 
>> DFSC, bits [5:0], when synchronous external Data Abort
>> 	Data Fault Status Code. The possible values of this field are:
>> 	0b010000 Synchronous External Abort on memory access.
>> 	0b0101xx Synchronous External Abort on translation table walk or hardware update of translation
>> 	table. DFSC[1:0] encode the level.
>> 	Further values are described in the Architecture Reference Manual. The Parity Error codes are not
>> 	used and reserved in the RAS extension.
>> IFSC, bits [5:0], when synchronous external Instruction Abort
>> 	Instruction Fault Status Code. The possible values of this field are:
>> 	0b010000 Synchronous External Abort on memory access.
>> 	0b0101xx Synchronous External Abort on translation table walk or hardware update of translation
>> 	table. IFSC[1:0] encode the level.
>> 	Further values are described in the Architecture Reference Manual. The Parity Error codes are not
>> 	used and reserved in the RAS extension.
> 
> 
> So the v8 ARM-ARM has two ways of indicating an external abort, KVM tests bit 9.
> The v7 ARM-ARm has a '{D,I}FSR.ExT' bit, which I think is equivalent. Its
> described as:
>> An implementation can use the DFSR.ExT and IFSR.ExT bits to provide more
>> information about external aborts.
> 
> This is what the v8 version must mean with its
>> External abort type. This bit can provide an IMPLEMENTATION DEFINED
>> classification of External aborts.
> 
> Which I read as IMP-DEF classification 'as external', as opposed to your reading
> as an extra IMP-DEF classification for external aborts.
OK.
> 
> It looks like an implementation could use this to mean 'how external'. For RAS
> an implementation could use it to separate external aborts handled first by
> firmware, from those generated directly by the CPU.
  for the armv8.0 CPU which does not have RAS feature, also use the EA bit, so may not directly use it separate whether external aborts should be handled first by
  firmware

> 
> So which bits should Linux test? Bit 9 has some extra IMP-DEF meaning, so Linux
> should never look at it, which means KVM has a bug handling these.
  what do you want Linux to test? to test the type of error? check the {I,D}FSC should be OK.

> I will send a patch, are you able to review and test it?
  sure, it is no problem.

> 
> 
> Thanks!
> 
> James
> 
> .
> 
