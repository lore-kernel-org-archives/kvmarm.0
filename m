From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 11/17] arm64: KVM: vgic-v2: Only wipe LRs on vcpu exit
Date: Thu, 3 Mar 2016 15:58:08 +0000
Message-ID: <56D85F10.1030602@arm.com>
References: <1455727249-24752-1-git-send-email-marc.zyngier@arm.com>
 <1455727249-24752-12-git-send-email-marc.zyngier@arm.com>
 <20160302230819.GE9634@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20160302230819.GE9634@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Andrew Jones <drjones@redhat.com>, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 02/03/16 23:08, Christoffer Dall wrote:
> On Wed, Feb 17, 2016 at 04:40:43PM +0000, Marc Zyngier wrote:
>> So far, we're always writing all possible LRs, setting the empty
>> ones with a zero value. This is obvious doing a low of work for
> 
> s/low/lot/
> 
>> nothing, and we're better off clearing those we've actually
>> dirtied on the exit path (it is very rare to inject more than one
>> interrupt at a time anyway).
>>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>  arch/arm64/kvm/hyp/vgic-v2-sr.c | 10 +++++-----
>>  1 file changed, 5 insertions(+), 5 deletions(-)
>>
>> diff --git a/arch/arm64/kvm/hyp/vgic-v2-sr.c b/arch/arm64/kvm/hyp/vgic-v2-sr.c
>> index 3dbbc6b..e53f131 100644
>> --- a/arch/arm64/kvm/hyp/vgic-v2-sr.c
>> +++ b/arch/arm64/kvm/hyp/vgic-v2-sr.c
>> @@ -101,6 +101,7 @@ static void __hyp_text save_lrs(struct kvm_vcpu *vcpu, void __iomem *base)
>>  		}
>>  
>>  		cpu_if->vgic_lr[i] = readl_relaxed(base + GICH_LR0 + (i * 4));
>> +		writel_relaxed(0, base + GICH_LR0 + (i * 4));
>>  	}
>>  }
>>  
>> @@ -158,12 +159,11 @@ void __hyp_text __vgic_v2_restore_state(struct kvm_vcpu *vcpu)
>>  		writel_relaxed(cpu_if->vgic_hcr, base + GICH_HCR);
>>  		writel_relaxed(cpu_if->vgic_apr, base + GICH_APR);
>>  		for (i = 0; i < nr_lr; i++) {
>> -			u32 val = 0;
>> -
>> -			if (live_lrs & (1UL << i))
>> -				val = cpu_if->vgic_lr[i];
>> +			if (!(live_lrs & (1UL << i)))
>> +				continue;
> 
> how can we be sure that the LRs are clear when we launch our first VM on
> a given physical CPU?  Don't we need to flush the LRs during VGIC init
> time?
> 
>>  
>> -			writel_relaxed(val, base + GICH_LR0 + (i * 4));
>> +			writel_relaxed(cpu_if->vgic_lr[i],
>> +				       base + GICH_LR0 + (i * 4));
>>  		}
>>  	}
>>  
>> -- 
>> 2.1.4
>>
> 
> otherwie LGTM.

So how about this, just before this patch (I'll obviously do something similar for GICv3):

>From d9a80c4c406450190a68abee302c7d9a0034c62a Mon Sep 17 00:00:00 2001
From: Marc Zyngier <marc.zyngier@arm.com>
Date: Thu, 3 Mar 2016 15:43:58 +0000
Subject: [PATCH] KVM: arm/arm64: vgic-v2: Reset LRs at boot time

In order to let make the GICv2 code more lazy in the way it
accesses the LRs, it is necessary to start with a clean slate.

Let's reset the LRs on each CPU when the vgic is probed.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic-v2.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/virt/kvm/arm/vgic-v2.c b/virt/kvm/arm/vgic-v2.c
index ff02f08..67ec334 100644
--- a/virt/kvm/arm/vgic-v2.c
+++ b/virt/kvm/arm/vgic-v2.c
@@ -176,6 +176,15 @@ static const struct vgic_ops vgic_v2_ops = {
 
 static struct vgic_params vgic_v2_params;
 
+static void vgic_cpu_init_lrs(void *params)
+{
+	struct vgic_params *vgic = params;
+	int i;
+
+	for (i = 0; i < vgic->nr_lr; i++)
+		writel_relaxed(0, vgic->vctrl_base + GICH_LR0 + (i * 4));
+}
+
 /**
  * vgic_v2_probe - probe for a GICv2 compatible interrupt controller in DT
  * @node:	pointer to the DT node
@@ -257,6 +266,9 @@ int vgic_v2_probe(struct device_node *vgic_node,
 
 	vgic->type = VGIC_V2;
 	vgic->max_gic_vcpus = VGIC_V2_MAX_CPUS;
+
+	on_each_cpu(vgic_cpu_init_lrs, vgic, 1);
+
 	*ops = &vgic_v2_ops;
 	*params = vgic;
 	goto out;


Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
