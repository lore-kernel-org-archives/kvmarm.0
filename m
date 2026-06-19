Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B6BB35E55D
	for <kvmarm@lists.linux.dev>; Fri, 19 Jun 2026 07:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781852721; cv=none; b=J1BnKxxgo/mcYiZHqkRc1GLHEIhhoJM9nkhsgSFm1ioMgqSc9XtSu2WxSnY/vPxMU+pRmXS4St3m6M616bi1wEgacy0tIFEyPX0dZimmIDlCFttiKsNArAwl58RqFkRKdpigK79I67tLtebAEKKdtOiOZjv9BrVPLqHyeZ6hlxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781852721; c=relaxed/simple;
	bh=YW3jA9tm3/u2Cm7/0Cqvg0Oho7qgO/I+QS7ISjHRBBU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Ve1pAkhkRFNV9BXt+wWGU2Ar/gtj19Id9tAqf7Px7nNWY+BOcQdBg0XdDLsA752UIn3549SwpjCRJb+ZTm8OgAVkgYwUucgGcTShxKOfk/PEI3jsQuLWGMe4ghLx4uvqoP5bydgPKr3NszEeJCjiWiVmvYV2NeGWSCAjoTQQrsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BSXYTS+O; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BSXYTS+O"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-490ae3bcf4cso8146315e9.3
        for <kvmarm@lists.linux.dev>; Fri, 19 Jun 2026 00:05:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781852718; x=1782457518; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nFTjg/IHL8HMr8nAct3jT4CdzzQIgwwmBvMwQOcvCtw=;
        b=BSXYTS+OVeEngKfK8m/1g3+sBi6eIU6pQmG2Uc48AjEf2Q/qBemIArwsxNCUii1+6F
         3o9BWGINHXSWp09PQRLR/bpebNHmNri5ltxttIkAweJ0AdKkQESKcb74fQ/BlfmwdxM3
         EZRyxRDal8z3Auw77x2xF8nFwDKZesEqjv+7XvZBufCGThfRYDMDj5raGYiHLnrI/1kZ
         ThyC1qy2xDyTEaDI+mkC7FTab64FvR3Ba57WjSYl+zOcnYutP39cE9MTBqlkhJkY+8Lj
         ouY3//9tvw2lI/lCrPJfscKl7uS/ocj2Qh+6sIEYkPvqORe4tAt584Y5InekVP8qjwDJ
         y2DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781852718; x=1782457518;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nFTjg/IHL8HMr8nAct3jT4CdzzQIgwwmBvMwQOcvCtw=;
        b=Yf/6/JkUPo/yyX4xrqnwgBBKX8gXfLV5chMzWxx4bja8db/acUeaStBpXxPpSrnSiq
         WVqAtCcV4WRTVHipSw5at/hpsZvrB2Vq51ezYUVdCCkCzcHzj4J27IRjuGmn0DlcF8qJ
         TdLeI8/V3ujtVXFx3TXqAZPdcz3OJqOtmHpAZgJv6mRd5ugZxaZGSHKsuHytGlK9lJVS
         h492KiMV7WDFoPF1N/dAudFHLC+uwEqZZ1m/enzOtqLI2byeI4leZfFkQPyaGQB+98Lh
         2D2VP8ZPWVeALonRp8xr+A3V/856aMhh3shcGAa53zxedMTOQc0pArJD1MPik04iiNZP
         vhQQ==
X-Forwarded-Encrypted: i=1; AFNElJ80sIO6QwIXEqHXTJcxMGExtXr7NQ/NvBWHvIjfWYePozO8NeYum24UqWZpn9qhCUErx9ai3hg=@lists.linux.dev
X-Gm-Message-State: AOJu0YwBPyevifAvEOm/mkC+wfYzDrBT7qMVDmzOlmg2ZP52iI69GKOZ
	cwO1fBDBzarkVmabraiK7wmF7o5IpxPyeui1Gq8QXgwoxrgXBzOms4NgK/sylDKb3m0zHl1Kbjz
	PmQ==
X-Received: from wmbh23.prod.google.com ([2002:a05:600c:a117:b0:485:3a14:a74e])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4fd4:b0:490:a296:fdad
 with SMTP id 5b1f17b1804b1-4923f56c05cmr38712945e9.24.1781852717408; Fri, 19
 Jun 2026 00:05:17 -0700 (PDT)
Date: Fri, 19 Jun 2026 08:05:06 +0100
In-Reply-To: <20260619070508.802802-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260619070508.802802-1-tabba@google.com>
X-Mailer: git-send-email 2.55.0.rc0.738.g0c8ab3ebcc-goog
Message-ID: <20260619070508.802802-7-tabba@google.com>
Subject: [PATCH 6/8] KVM: arm64: Minimise EL2's exposure of host VGIC state
 during world switch
From: Fuad Tabba <tabba@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Vincent Donnefort <vdonnefort@google.com>, Quentin Perret <qperret@google.com>, 
	Sebastian Ene <sebastianene@google.com>, Hyunwoo Kim <imv4bel@gmail.com>, 
	Fuad Tabba <tabba@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Marc Zyngier <maz@kernel.org>

The host passes a vgic_v3_cpu_if pointer to the __vgic_v3_save_aprs and
__vgic_v3_restore_vmcr_aprs hypercalls, which EL2 dereferences
wholesale. That exposes the host's full VGIC emulation state to the
hypervisor, against pKVM's isolation goals.

Recover the host vCPU from the supplied cpu_if via container_of() and
copy only vgic_vmcr and the active priority registers between EL2's
hyp-side state and the host vCPU, so EL2 no longer dereferences the
host's vgic_v3_cpu_if directly.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Co-developed-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 67 ++++++++++++++++++++++++++++--
 1 file changed, 63 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 8923f594c264..f25ee3971528 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -7,6 +7,8 @@
 #include <hyp/adjust_pc.h>
 #include <hyp/switch.h>
 
+#include <linux/irqchip/arm-gic-v3.h>
+
 #include <asm/pgtable-types.h>
 #include <asm/kvm_asm.h>
 #include <asm/kvm_emulate.h>
@@ -237,6 +239,16 @@ static struct kvm_vcpu *__get_host_hyp_vcpus(struct kvm_vcpu *arg,
 		__get_host_hyp_vcpus(__vcpu, hyp_vcpup);		\
 	})
 
+#define get_host_hyp_vcpus_from_vgic_v3_cpu_if(ctxt, regnr, hyp_vcpup)		\
+	({									\
+		DECLARE_REG(struct vgic_v3_cpu_if *, cif, ctxt, regnr);\
+		struct kvm_vcpu *__vcpu = container_of(cif,			\
+						       struct kvm_vcpu,		\
+						       arch.vgic_cpu.vgic_v3);	\
+										\
+		__get_host_hyp_vcpus(__vcpu, hyp_vcpup);			\
+	})
+
 static void handle___kvm_vcpu_run(struct kvm_cpu_context *host_ctxt)
 {
 	struct pkvm_hyp_vcpu *hyp_vcpu;
@@ -506,16 +518,63 @@ static void handle___vgic_v3_init_lrs(struct kvm_cpu_context *host_ctxt)
 
 static void handle___vgic_v3_save_aprs(struct kvm_cpu_context *host_ctxt)
 {
-	DECLARE_REG(struct vgic_v3_cpu_if *, cpu_if, host_ctxt, 1);
+	struct pkvm_hyp_vcpu *hyp_vcpu;
+	struct kvm_vcpu *host_vcpu;
 
-	__vgic_v3_save_aprs(kern_hyp_va(cpu_if));
+	host_vcpu = get_host_hyp_vcpus_from_vgic_v3_cpu_if(host_ctxt, 1,
+							   &hyp_vcpu);
+	if (!host_vcpu)
+		return;
+
+	if (unlikely(hyp_vcpu)) {
+		struct vgic_v3_cpu_if *hyp_cpu_if, *host_cpu_if;
+		int i;
+
+		hyp_cpu_if = &hyp_vcpu->vcpu.arch.vgic_cpu.vgic_v3;
+		__vgic_v3_save_aprs(hyp_cpu_if);
+
+		host_cpu_if = &host_vcpu->arch.vgic_cpu.vgic_v3;
+		host_cpu_if->vgic_vmcr = hyp_cpu_if->vgic_vmcr;
+		for (i = 0; i < ARRAY_SIZE(host_cpu_if->vgic_ap0r); i++) {
+			host_cpu_if->vgic_ap0r[i] = hyp_cpu_if->vgic_ap0r[i];
+			host_cpu_if->vgic_ap1r[i] = hyp_cpu_if->vgic_ap1r[i];
+		}
+	} else {
+		__vgic_v3_save_aprs(&host_vcpu->arch.vgic_cpu.vgic_v3);
+	}
 }
 
 static void handle___vgic_v3_restore_vmcr_aprs(struct kvm_cpu_context *host_ctxt)
 {
-	DECLARE_REG(struct vgic_v3_cpu_if *, cpu_if, host_ctxt, 1);
+	struct pkvm_hyp_vcpu *hyp_vcpu;
+	struct kvm_vcpu *host_vcpu;
 
-	__vgic_v3_restore_vmcr_aprs(kern_hyp_va(cpu_if));
+	host_vcpu = get_host_hyp_vcpus_from_vgic_v3_cpu_if(host_ctxt, 1,
+							   &hyp_vcpu);
+	if (!host_vcpu)
+		return;
+
+	if (unlikely(hyp_vcpu)) {
+		struct vgic_v3_cpu_if *hyp_cpu_if, *host_cpu_if;
+		int i;
+
+		hyp_cpu_if = &hyp_vcpu->vcpu.arch.vgic_cpu.vgic_v3;
+		host_cpu_if = &host_vcpu->arch.vgic_cpu.vgic_v3;
+
+		hyp_cpu_if->vgic_vmcr = host_cpu_if->vgic_vmcr;
+		/* Should be a one-off */
+		hyp_cpu_if->vgic_sre = (ICC_SRE_EL1_DIB |
+					ICC_SRE_EL1_DFB |
+					ICC_SRE_EL1_SRE);
+		for (i = 0; i < ARRAY_SIZE(host_cpu_if->vgic_ap0r); i++) {
+			hyp_cpu_if->vgic_ap0r[i] = host_cpu_if->vgic_ap0r[i];
+			hyp_cpu_if->vgic_ap1r[i] = host_cpu_if->vgic_ap1r[i];
+		}
+
+		__vgic_v3_restore_vmcr_aprs(hyp_cpu_if);
+	} else {
+		__vgic_v3_restore_vmcr_aprs(&host_vcpu->arch.vgic_cpu.vgic_v3);
+	}
 }
 
 static void handle___pkvm_init(struct kvm_cpu_context *host_ctxt)
-- 
2.55.0.rc0.738.g0c8ab3ebcc-goog

