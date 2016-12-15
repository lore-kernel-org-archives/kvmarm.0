From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: Re: [PATCH 2/2] KVM: arm/arm64: vgic-v2: Add the missing resetting
 LRs at boot time
Date: Thu, 15 Dec 2016 17:09:13 +0800
Message-ID: <58525DB9.40806@huawei.com>
References: <1481006504-25460-1-git-send-email-zhaoshenglong@huawei.com>
 <1481006504-25460-3-git-send-email-zhaoshenglong@huawei.com>
 <7f920e65-a82c-e05d-1d19-8b71e06ac770@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3C2C5402EC
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Dec 2016 04:09:20 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id G547TC0ryALU for <kvmarm@lists.cs.columbia.edu>;
 Thu, 15 Dec 2016 04:09:17 -0500 (EST)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [58.251.152.64])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3AD77402A5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Dec 2016 04:09:13 -0500 (EST)
In-Reply-To: <7f920e65-a82c-e05d-1d19-8b71e06ac770@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,

On 2016/12/6 19:39, Marc Zyngier wrote:
> On 06/12/16 06:41, Shannon Zhao wrote:
>> From: Shannon Zhao <shannon.zhao@linaro.org>
>>
>> This is the corresponding part of commit d6400d7(KVM: arm/arm64:
>> vgic-v2: Reset LRs at boot time) which is missed for new-vgic.
>>
>> Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
>> ---
>>  virt/kvm/arm/vgic/vgic-v2.c | 11 +++++++++++
>>  1 file changed, 11 insertions(+)
>>
>> diff --git a/virt/kvm/arm/vgic/vgic-v2.c b/virt/kvm/arm/vgic/vgic-v2.c
>> index 9bab867..c636a19 100644
>> --- a/virt/kvm/arm/vgic/vgic-v2.c
>> +++ b/virt/kvm/arm/vgic/vgic-v2.c
>> @@ -300,6 +300,15 @@ int vgic_v2_map_resources(struct kvm *kvm)
>>  
>>  DEFINE_STATIC_KEY_FALSE(vgic_v2_cpuif_trap);
>>  
>> +static void vgic_cpu_init_lrs(void *params)
>> +{
>> +	int i;
>> +
>> +	for (i = 0; i < kvm_vgic_global_state.nr_lr; i++)
>> +		writel_relaxed(0, kvm_vgic_global_state.vctrl_base +
>> +				  GICH_LR0 + (i * 4));
>> +}
Since this function will use kvm_vgic_global_state which is initialized
by kvm_vgic_hyp_init, if we call it in cpu_hyp_reinit/cpu_init_hyp_mode,
the kvm_vgic_global_state is not initialized for now. Is that fine to
move kvm_vgic_hyp_init to the first place in init_subsystems?

Thanks,
-- 
Shannon
