From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v5 09/23] KVM: arm/arm64: Keep GICv2 HYP VAs in
 kvm_vgic_global_state
Date: Tue, 13 Mar 2018 11:40:13 +0000
Message-ID: <0a583b26-c012-6ff6-780b-7b12af17eebd@arm.com>
References: <20180301155538.26860-1-marc.zyngier@arm.com>
 <20180301155538.26860-10-marc.zyngier@arm.com>
 <2dd9e07b-1fa7-72da-c10d-c4621294a886@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <2dd9e07b-1fa7-72da-c10d-c4621294a886@arm.com>
Content-Language: en-GB
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Suzuki K Poulose <Suzuki.Poulose@arm.com>, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 13/03/18 09:35, Suzuki K Poulose wrote:
> On 01/03/18 15:55, Marc Zyngier wrote:
>> As we're about to change the way we map devices at HYP, we need
>> to move away from kern_hyp_va on an IO address.
>>
>> One way of achieving this is to store the VAs in kvm_vgic_global_state,
>> and use that directly from the HYP code. This requires a small change
>> to create_hyp_io_mappings so that it can also return a HYP VA.
>>
>> We take this opportunity to nuke the vctrl_base field in the emulated
>> distributor, as it is not used anymore.
>>
>> Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>   arch/arm/include/asm/kvm_mmu.h   |  3 ++-
>>   arch/arm64/include/asm/kvm_mmu.h |  3 ++-
>>   include/kvm/arm_vgic.h           | 12 ++++++------
>>   virt/kvm/arm/hyp/vgic-v2-sr.c    | 10 +++-------
>>   virt/kvm/arm/mmu.c               | 20 +++++++++++++++-----
>>   virt/kvm/arm/vgic/vgic-init.c    |  6 ------
>>   virt/kvm/arm/vgic/vgic-v2.c      | 13 +++++++------
>>   7 files changed, 35 insertions(+), 32 deletions(-)
>>
> 
> ...
> 
>> diff --git a/virt/kvm/arm/vgic/vgic-v2.c b/virt/kvm/arm/vgic/vgic-v2.c
>> index 21f963f9780e..38406825e663 100644
>> --- a/virt/kvm/arm/vgic/vgic-v2.c
>> +++ b/virt/kvm/arm/vgic/vgic-v2.c
>> @@ -364,7 +364,8 @@ int vgic_v2_probe(const struct gic_kvm_info *info)
>>   
>>   		ret = create_hyp_io_mappings(info->vcpu.start,
>>   					     resource_size(&info->vcpu),
>> -					     &kvm_vgic_global_state.vcpu_base_va);
>> +					     &kvm_vgic_global_state.vcpu_base_va,
>> +					     &kvm_vgic_global_state.vcpu_hyp_va);
>>   		if (ret) {
>>   			kvm_err("Cannot map GICV into hyp\n");
>>   			goto out;
>> @@ -375,7 +376,8 @@ int vgic_v2_probe(const struct gic_kvm_info *info)
>>   
>>   	ret = create_hyp_io_mappings(info->vctrl.start,
>>   				     resource_size(&info->vctrl),
>> -				     &kvm_vgic_global_state.vctrl_base);
>> +				     &kvm_vgic_global_state.vctrl_base,
>> +				     &kvm_vgic_global_state.vctrl_hyp);
> 
> Now that we have the hyp VA, does it make sense to unmap the hyp VA, just
> like we unmap the kernel io mapping if we fail to register the device ?
Unfortunately, we don't have such facility to unmap a single range yet.
All we can do is to teardown the whole HYP VA space, which is probably
what is happening when returning an error.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
