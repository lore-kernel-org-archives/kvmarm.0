Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21ACC3128D9;
	Thu, 23 Jul 2026 14:47:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784818030; cv=none; b=bb4yAtQqGDiQMOODnveTj0+9S4mN0wLrbMwm9bDBASl+YiqJBNgBiEwmhMMtyvIaAqcNdOUJY1OAgr/FiOA841M4vJCA0R/7Yj8djaxxY8/ohFdfRvNAtgi9r7ATIIWSBbs0U2WlQkDdjKIVlS93wczm58AfAdwpr7yoDWU2Ybk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784818030; c=relaxed/simple;
	bh=6Th78kG6gwLHh+IRkhYaCODZh+oGtao36ZDP9dLMl3Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EiYROh89n7C997uTKYbqwM+5MxgOOmyO9Pjv3AiE9k/KotsibTmd9EPvGMWlcClMB8P3Vl3dojBfGYs7WiJallf/WoZuKz2YrK7EG1/m/cvgm3BbbNn43QIr52Zd77fXmflZMtmVl3SzR8tCogXPHIJtQpzYSVYy/BTAAMXWW8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=LxFG8WRR; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="LxFG8WRR"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D49B01477;
	Thu, 23 Jul 2026 07:47:01 -0700 (PDT)
Received: from [10.1.25.28] (e122027.cambridge.arm.com [10.1.25.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B40FC3F59E;
	Thu, 23 Jul 2026 07:47:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784818026; bh=6Th78kG6gwLHh+IRkhYaCODZh+oGtao36ZDP9dLMl3Y=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=LxFG8WRRK7c9iE7bu37AjLxt1a2HZyFcz184U5VNfybyqKKs4NJEuApklUjnLfzdO
	 Abo+IkO4lwS7PIRGBwYDDYCIp0Q/0dVX6cc2WGgGTWfp8AQriPZBtjYyNvWg0bqpzA
	 7KTe8igVy3yHQmAEl8oR5DcTVjve1JJmeqaINrr4=
Message-ID: <1cd3327c-1eab-4022-9ab1-625ca8641e81@arm.com>
Date: Thu, 23 Jul 2026 15:46:58 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 12/37] KVM: arm64: CCA: Support the VGIC in realms
To: Kohei Enju <enju.kohei@fujitsu.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
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
 <20260715142841.80544-13-steven.price@arm.com>
 <amB-opawGgF6jNHB@FCCLS0092175.localdomain>
 <b71e81ee-372c-4963-a1f7-bd301aee89cb@arm.com>
 <amG3KHE4Tdd_Nvuz@FCCLS0092175.localdomain>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <amG3KHE4Tdd_Nvuz@FCCLS0092175.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 23/07/2026 07:56, Kohei Enju wrote:
> On 07/22 14:31, Steven Price wrote:
>> On 22/07/2026 09:27, Kohei Enju wrote:
>>> On 07/15 15:28, Steven Price wrote:
>>>> The RMM provides emulation of a VGIC to the realm guest. With RMM v2.0
>>>> the registers are passed in the system registers so this works similar
>>>> to a normal guest, but kvm_arch_vcpu_put() need reordering to early out,
>>>> and realm guests don't support GICv2 even if the host does.
>>>>
>>>> Signed-off-by: Steven Price <steven.price@arm.com>
>>>
>>> Hi Steven,
>>
>> Hi Kohei,
>>
>>> I've been testing this series and found that when the host CPU doesn't have
>>> ARM64_HAS_ICH_HCR_EL2_TDIR this series doesn't work as expected.
>>
>> Thanks for testing!
>>
>>> Since commit 2a28810cbb8b ("KVM: arm64: GICv3: Detect and work around the lack
>>> of ICV_DIR_EL1 trapping"), when the host CPU doesn't support this feature, KVM
>>> traps all GIC sysreg accesses in the common group. However, currently trap
>>> handlers for ICC_{PMR,RPR,CTLR}_EL1 registers are missing [0]. So when Realm
>>> guests try to access those registers, KVM traps them but just emits the warning
>>> shown in [1], and Realm guests fail to boot.
>>>
>>> As far as I can tell, the CCA requirements don't require the
>>> ARM64_HAS_ICH_HCR_EL2_TDIR feature. If that's the case, this seems to be a
>>> problem. Is there any workaround for this issue, or should we implement trap
>>> handlers for those registers?
>>
>> As Marc has already said in his reply, I'm really surprised you have a
>> CPU which implements CCA but doesn't have ARM64_HAS_ICH_HCR_EL2_TDIR.
>> Can you give some more details about the platform you are testing on?
> 
> Thank you for taking a look, Steve.
> 
> Unfortunately, due to the company's policy, I can't share any details
> about the platform I'm currently testing on. When the time is right,
> I'll be happy to do so.
> 
>>
>> Ultimately there are two options here - either don't support CCA (so
>> detect the lack of ARM64_HAS_ICH_HCR_EL2_TDIR and bail out early), or
>> plumb in the trap handlers - as commit 2a28810cbb8b points out this
>> isn't something we really want to support if we can avoid it.
> 
> Yes, the former makes perfect sense if there would be no systems that
> supports CCA without TDIR. However, if such systems do exist, I'd be
> interested in exploring the latter approach.
> 
>>
>> Hence I'm interested to know where this sits between "hacked up test
>> system" and "production hardware". E.g. if this is an emulator it might
>> be possible to just enable the CPU feature.
> 
> Again, I can't share that right now, but I'd like to share more when the
> time comes.

Given Marc's response for now I'm not going to add support for this. 
"When the time comes" we can revisit whether it makes sense to have 
upstream support and what that might look like.

However, I did ask an AI tool to have a go at implementing this, and it 
came up with the (very lightly tested) patch below. That might at least 
give you something you can test. It doesn't meet Marc's request that it
reuses the existing implementation, and it took the AI a few goes at
getting something that "works" so I suspect it might have bugs - I
haven't reviewed the code myself.

Thanks,
Steve

----8<----
From 7aaaa5089c05f19bf00df2b651fa4bd7d738384c Mon Sep 17 00:00:00 2001
From: Steven Price <steven.price@arm.com>
Date: Thu, 23 Jul 2026 11:49:36 +0100
Subject: [PATCH] KVM: arm64: CCA: Handle GICv3 CPU interface traps for realms

On CPUs that lack ICH_HCR_EL2.TDIR, KVM works around the missing DIR
trap by setting ICH_HCR_EL2.TC and trapping the GICv3 common CPU
interface registers. Normal guests handle these traps in hyp via the
VGIC CPU interface emulation, but realm guests exit through the RMM and
reach KVM's host-side sysreg emulation instead.

That path only handles ICC_DIR_EL1 and treats the rest of the trapped
common group as undefined. A realm guest can therefore take an
unexpected UNDEF when accessing registers such as ICC_PMR_EL1 or
ICC_CTLR_EL1 on systems that require the TC workaround.

Handle the GICv3 common CPU interface registers directly from the realm
sysreg exit path. Reads are satisfied from the saved VGIC state and
writes update the VGIC shadow state. For PMR and CTLR writes, also
restore the VMCR/APR state to the live GIC CPU interface before
re-entering the REC, matching the effect a direct guest sysreg write
would have had.

Signed-off-by: Steven Price <steven.price@arm.com>
---
 arch/arm64/kvm/rmi-exit.c | 119 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 119 insertions(+)

diff --git a/arch/arm64/kvm/rmi-exit.c b/arch/arm64/kvm/rmi-exit.c
index 78d9189fd5ca..0fad8e68d920 100644
--- a/arch/arm64/kvm/rmi-exit.c
+++ b/arch/arm64/kvm/rmi-exit.c
@@ -3,17 +3,25 @@
  * Copyright (C) 2023-2026 ARM Ltd.
  */
 
+#include <linux/bitfield.h>
+#include <linux/irqchip/arm-gic-v3.h>
 #include <linux/kvm_host.h>
 #include <kvm/arm_hypercalls.h>
 #include <kvm/arm_psci.h>
 
 #include <linux/arm-smccc-rmi.h>
 #include <asm/kvm_emulate.h>
+#include <asm/kvm_hyp.h>
 #include <asm/kvm_rmi.h>
 #include <asm/kvm_mmu.h>
+#include <asm/sysreg.h>
+
+#include "vgic/vgic.h"
 
 typedef int (*exit_handler_fn)(struct kvm_vcpu *vcpu);
 
+#define GICV3_IDLE_PRIORITY	0xff
+
 static int rec_exit_reason_notimpl(struct kvm_vcpu *vcpu)
 {
 	vcpu_err(vcpu, "Unhandled exit reason from realm (ESR: %#llx)\n",
@@ -48,6 +56,114 @@ static int rec_exit_sync_iabt(struct kvm_vcpu *vcpu)
 	return -ENXIO;
 }
 
+static int rec_get_gicv3_bpr_min(void)
+{
+	return 8 - (FIELD_GET(ICH_VTR_EL2_PREbits,
+			      kvm_vgic_global_state.ich_vtr_el2) + 1);
+}
+
+static u8 rec_get_gicv3_active_priority(struct kvm_vcpu *vcpu)
+{
+	struct vgic_v3_cpu_if *cpuif = &vcpu->arch.vgic_cpu.vgic_v3;
+	u8 prio = 0;
+
+	for (int i = 0; i <= vgic_v3_max_apr_idx(vcpu); i++) {
+		u32 val = cpuif->vgic_ap0r[i] | cpuif->vgic_ap1r[i];
+
+		if (!val) {
+			prio += 32;
+			continue;
+		}
+
+		return (prio + __ffs(val)) << rec_get_gicv3_bpr_min();
+	}
+
+	return GICV3_IDLE_PRIORITY;
+}
+
+static void rec_restore_gicv3_vmcr_aprs(struct kvm_vcpu *vcpu)
+{
+	preempt_disable();
+	kvm_call_hyp(__vgic_v3_restore_vmcr_aprs,
+		     &vcpu->arch.vgic_cpu.vgic_v3);
+	preempt_enable();
+}
+
+/*
+ * Realm exits are handled after the RMM has returned to the host, so use the
+ * saved VGIC shadow state instead of the hyp-side live sysreg helpers.
+ */
+static bool rec_exit_gicv3_sys_reg(struct kvm_vcpu *vcpu, bool is_write)
+{
+	struct realm_rec *rec = &vcpu->arch.rec;
+	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
+	struct vgic_vmcr vmcr;
+	unsigned long esr = kvm_vcpu_get_esr(vcpu);
+	int rt = kvm_vcpu_sys_get_rt(vcpu);
+	u32 sysreg = esr_sys64_to_sysreg(esr);
+	u64 val;
+
+	if (!kvm_has_gicv3(vcpu->kvm))
+		return false;
+
+	vgic_get_vmcr(vcpu, &vmcr);
+
+	switch (sysreg) {
+	case SYS_ICC_DIR_EL1:
+		if (!is_write)
+			return false;
+
+		vgic_v3_deactivate(vcpu, rec->run->exit.gprs[rt]);
+		return true;
+	case SYS_ICC_PMR_EL1:
+		if (is_write) {
+			vmcr.pmr = FIELD_GET(ICC_PMR_EL1_MASK,
+					     rec->run->exit.gprs[rt]);
+			vgic_set_vmcr(vcpu, &vmcr);
+			rec_restore_gicv3_vmcr_aprs(vcpu);
+		} else {
+			rec->run->enter.gprs[rt] = FIELD_PREP(ICC_PMR_EL1_MASK,
+							      vmcr.pmr);
+		}
+
+		return true;
+	case SYS_ICC_CTLR_EL1:
+		if (is_write) {
+			val = rec->run->exit.gprs[rt];
+			vmcr.cbpr = FIELD_GET(ICC_CTLR_EL1_CBPR_MASK, val);
+			vmcr.eoim = FIELD_GET(ICC_CTLR_EL1_EOImode_MASK, val);
+			vgic_set_vmcr(vcpu, &vmcr);
+			rec_restore_gicv3_vmcr_aprs(vcpu);
+		} else {
+			val  = FIELD_PREP(ICC_CTLR_EL1_PRI_BITS_MASK,
+					  vgic_cpu->num_pri_bits - 1);
+			val |= FIELD_PREP(ICC_CTLR_EL1_ID_BITS_MASK,
+					  vgic_cpu->num_id_bits);
+			val |= FIELD_PREP(ICC_CTLR_EL1_SEIS_MASK,
+					  FIELD_GET(ICH_VTR_EL2_SEIS,
+						    kvm_vgic_global_state.ich_vtr_el2));
+			val |= FIELD_PREP(ICC_CTLR_EL1_A3V_MASK,
+					  FIELD_GET(ICH_VTR_EL2_A3V,
+						    kvm_vgic_global_state.ich_vtr_el2));
+			val |= FIELD_PREP(ICC_CTLR_EL1_CBPR_MASK,
+					  vmcr.cbpr);
+			val |= FIELD_PREP(ICC_CTLR_EL1_EOImode_MASK,
+					  vmcr.eoim);
+			rec->run->enter.gprs[rt] = val;
+		}
+
+		return true;
+	case SYS_ICC_RPR_EL1:
+		if (is_write)
+			return false;
+
+		rec->run->enter.gprs[rt] = rec_get_gicv3_active_priority(vcpu);
+		return true;
+	default:
+		return false;
+	}
+}
+
 static int rec_exit_sys_reg(struct kvm_vcpu *vcpu)
 {
 	struct realm_rec *rec = &vcpu->arch.rec;
@@ -59,6 +175,9 @@ static int rec_exit_sys_reg(struct kvm_vcpu *vcpu)
 	if (is_write)
 		vcpu_set_reg(vcpu, rt, rec->run->exit.gprs[rt]);
 
+	if (rec_exit_gicv3_sys_reg(vcpu, is_write))
+		return 1;
+
 	ret = kvm_handle_sys_reg(vcpu);
 	if (!is_write)
 		rec->run->enter.gprs[rt] = vcpu_get_reg(vcpu, rt);
-- 
2.43.0


