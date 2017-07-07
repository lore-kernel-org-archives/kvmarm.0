From: wanghaibin <wanghaibin.wang@huawei.com>
Subject: Re: [PATCH 1/4] kvm: arm/arm64: vgic-v2: Add GICH_APR accessors for
 GICv2
Date: Fri, 7 Jul 2017 16:37:18 +0800
Message-ID: <595F483E.9080001@huawei.com>
References: <1499253809-17584-1-git-send-email-wanghaibin.wang@huawei.com>
 <1499253809-17584-2-git-send-email-wanghaibin.wang@huawei.com>
 <33bd7cd2-b49e-187b-b2fc-d020ff35aeb6@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E59CC40CE6
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Jul 2017 04:37:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BOGnRWVoEdyE for <kvmarm@lists.cs.columbia.edu>;
 Fri,  7 Jul 2017 04:37:19 -0400 (EDT)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 797F340CE0
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Jul 2017 04:37:14 -0400 (EDT)
In-Reply-To: <33bd7cd2-b49e-187b-b2fc-d020ff35aeb6@arm.com>
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

On 2017/7/7 0:13, Marc Zyngier wrote:

> On 05/07/17 12:23, wanghaibin wrote:
>> For GICv2, there are at most 5 priority bits are implemented in
>> GICH_LR<n>.Priority, so we only need to be concerned with GICH_APR0.
>> The other GICH_APRn access can be treated as raz/wi.
> 
> What is this "other" GICH_APRn?
> 
>>
>> Attention: This patch is untest!
>>
>> Signed-off-by: wanghaibin <wanghaibin.wang@huawei.com>
>> ---
>>  virt/kvm/arm/vgic/vgic-v2.c | 21 +++++++++++++++++++++
>>  virt/kvm/arm/vgic/vgic.h    |  2 ++
>>  2 files changed, 23 insertions(+)
>>
>> diff --git a/virt/kvm/arm/vgic/vgic-v2.c b/virt/kvm/arm/vgic/vgic-v2.c
>> index e4187e5..11d3b73 100644
>> --- a/virt/kvm/arm/vgic/vgic-v2.c
>> +++ b/virt/kvm/arm/vgic/vgic-v2.c
>> @@ -172,6 +172,27 @@ void vgic_v2_clear_lr(struct kvm_vcpu *vcpu, int lr)
>>  	vcpu->arch.vgic_cpu.vgic_v2.vgic_lr[lr] = 0;
>>  }
>>  
>> +void vgic_v2_set_apr(struct kvm_vcpu *vcpu, u32 idx, u32 val)
>> +{
>> +	struct vgic_v2_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v2;
>> +
>> +	if (idx == 0)
>> +		cpu_if->vgic_apr = val;
>> +	else
>> +		WARN_ON(val);
> 
> If treated as WI, why do you WARN here? Also, given that there is only
> one register for the active priorities, I don't really see the point in
> having this "idx" parameter.
> 

About idx parameter, the patch3 will reply.

About WARN_ON, GICv2 on GICv2, we just show 5 priority bits currently.
If uaccess set apr[1/2/3] with non-zero value, there must be something wrong,  here take a warning.

Of course, this can be deleted.

Thanks.

>> +}
>> +
>> +u32 vgic_v2_get_apr(struct kvm_vcpu *vcpu, u32 idx)
>> +{
>> +	struct vgic_v2_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v2;
>> +
>> +	if (idx == 0)
>> +		return cpu_if->vgic_apr;
>> +	else
>> +		return 0;
>> +}
>> +
>> +
> 
> Extra whitespace.


will fix.

Thanks.

> 
>>  void vgic_v2_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcrp)
>>  {
>>  	struct vgic_v2_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v2;
>> diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
>> index bba7fa2..8791b9a 100644
>> --- a/virt/kvm/arm/vgic/vgic.h
>> +++ b/virt/kvm/arm/vgic/vgic.h
>> @@ -155,6 +155,8 @@ int vgic_v2_dist_uaccess(struct kvm_vcpu *vcpu, bool is_write,
>>  			 int offset, u32 *val);
>>  int vgic_v2_cpuif_uaccess(struct kvm_vcpu *vcpu, bool is_write,
>>  			  int offset, u32 *val);
>> +void vgic_v2_set_apr(struct kvm_vcpu *vcpu, u32 idx, u32 val);
>> +u32 vgic_v2_get_apr(struct kvm_vcpu *vcpu, u32 idx);
>>  void vgic_v2_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
>>  void vgic_v2_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
>>  void vgic_v2_enable(struct kvm_vcpu *vcpu);
>>
> 
> Thanks,
> 
> 	M.
