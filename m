From: wanghaibin <wanghaibin.wang@huawei.com>
Subject: Re: [PATCH 2/4] kvm: arm/arm64: vgic-v3: add ICH_AP[01]Rn accessors
 for GICv3
Date: Fri, 7 Jul 2017 17:22:33 +0800
Message-ID: <595F52D9.40200@huawei.com>
References: <1499253809-17584-1-git-send-email-wanghaibin.wang@huawei.com>
 <1499253809-17584-3-git-send-email-wanghaibin.wang@huawei.com>
 <e6d0fddb-dc66-f356-786b-1dc6563695d5@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D8D2640D25
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Jul 2017 05:22:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id c8zEXcO9WlQp for <kvmarm@lists.cs.columbia.edu>;
 Fri,  7 Jul 2017 05:22:36 -0400 (EDT)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 83A1040CE0
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Jul 2017 05:22:34 -0400 (EDT)
In-Reply-To: <e6d0fddb-dc66-f356-786b-1dc6563695d5@arm.com>
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
Cc: cdall@linaro.org, kvmarm@lists.cs.columbia.edu, wu.wubin@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

On 2017/7/7 0:18, Marc Zyngier wrote:

> On 05/07/17 12:23, wanghaibin wrote:
>> Compared to GICv2 hardware, GICv3 support ICH_AP[01]Rn for Group [01]
>> interrupts.
> 
> This doesn't describe what the patch is trying to achieve.


Will fix.

> 
>>
>> Signed-off-by: wanghaibin <wanghaibin.wang@huawei.com>
>> ---
>>  virt/kvm/arm/vgic/vgic-v3.c | 20 ++++++++++++++++++++
>>  virt/kvm/arm/vgic/vgic.h    |  2 ++
>>  2 files changed, 22 insertions(+)
>>
>> diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
>> index 030248e..361da71 100644
>> --- a/virt/kvm/arm/vgic/vgic-v3.c
>> +++ b/virt/kvm/arm/vgic/vgic-v3.c
>> @@ -156,6 +156,26 @@ void vgic_v3_clear_lr(struct kvm_vcpu *vcpu, int lr)
>>  	vcpu->arch.vgic_cpu.vgic_v3.vgic_lr[lr] = 0;
>>  }
>>  
>> +void vgic_v3_set_apr(struct kvm_vcpu *vcpu, u8 apr, u32 idx, u32 val)
> 
> The "apr" parameter is actually the group number, and should be exposed
> as such.
>


Will fix.


>> +{
>> +	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
>> +
>> +	if (apr)
>> +		cpu_if->vgic_ap1r[idx] = val;
>> +	else
>> +		cpu_if->vgic_ap0r[idx] = val;
> 
> How do you guarantee that you're not accessing outside of this GIC's
> preemption capability?
> 


Only GICC_APRn mmio uaccess for vGICv2 and ICC_APRn uaccess sysreg uaccess will calculate
and pass the idx parameter to here, and these action can guarantee the idx only can be set 0,1,2,3.

Thanks.


>> +}
>> +
>> +u32 vgic_v3_get_apr(struct kvm_vcpu *vcpu, u8 apr, u32 idx)
>> +{
>> +	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
>> +
>> +	if (apr)
>> +		return cpu_if->vgic_ap1r[idx];
>> +	else
>> +		return cpu_if->vgic_ap0r[idx];
>> +}
>> +
>>  void vgic_v3_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcrp)
>>  {
>>  	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
>> diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
>> index 8791b9a..91d66ec 100644
>> --- a/virt/kvm/arm/vgic/vgic.h
>> +++ b/virt/kvm/arm/vgic/vgic.h
>> @@ -181,6 +181,8 @@ static inline void vgic_get_irq_kref(struct vgic_irq *irq)
>>  void vgic_v3_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr);
>>  void vgic_v3_clear_lr(struct kvm_vcpu *vcpu, int lr);
>>  void vgic_v3_set_underflow(struct kvm_vcpu *vcpu);
>> +void vgic_v3_set_apr(struct kvm_vcpu *vcpu, u8 apr, u32 idx, u32 val);
>> +u32 vgic_v3_get_apr(struct kvm_vcpu *vcpu, u8 apr, u32 idx);
>>  void vgic_v3_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
>>  void vgic_v3_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
>>  void vgic_v3_enable(struct kvm_vcpu *vcpu);
>>
> 
> Thanks,
> 
> 	M.
