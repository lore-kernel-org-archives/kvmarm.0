Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE71835E1B3
	for <kvmarm@lists.linux.dev>; Fri, 19 Jun 2026 07:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781852851; cv=none; b=ioEAbXFANqHfRcv7mHQuFf1xh/ZLGYZOdr/M5fk1Rpp+FkcsjckHXJWrifeyy/fBxmiSGqoxSoi2Jfq2cmHmN2bIQJxSBPVPwF84kXnjNsqulnzILCpeBBDO3gi5CXAro2xgL/2Q3nV1C3c1COYuViW3MRyA7TvYwoB8pXeFp9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781852851; c=relaxed/simple;
	bh=YW3jA9tm3/u2Cm7/0Cqvg0Oho7qgO/I+QS7ISjHRBBU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=G5FIba+LuF1jpX8R8zFmJUFX3arkBWYw1NqwUnNTssBBrWAgrdt0X9sC5yZ7UWEudB0uMP8lhH2TbX+ck3QfF9Mb2za2oAJ/V+7YE+kJcSni0/i9vtShp0s7YT2xw4xbJpNwcR2p54oo4zsWWeEdO/z5Q1QopJ3Rzz5v1IeGbl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OB4tgS7a; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OB4tgS7a"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-49244130073so1216125e9.1
        for <kvmarm@lists.linux.dev>; Fri, 19 Jun 2026 00:07:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781852848; x=1782457648; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nFTjg/IHL8HMr8nAct3jT4CdzzQIgwwmBvMwQOcvCtw=;
        b=OB4tgS7aX8xfHab4DNYageNsPLzXiL39uBb1yDx9jIc+UQXTYpn+2TjGkf5hk8Eia5
         jgkE+L7I9PJU2D0RzH4KPTA3agi3CYBsIOlk2ETZHqv0M8H7aENcBMei1qxPvJgQLeqk
         Uoo76Z+LrVmgIPEmxWt3llzqp0cBUAAhw4dLC35Y8V/Fh/CBQATT9OlFP2IiAN9WscsH
         J7SHk9n8jz9gKyUQLBnkUK+7lmlGUjAv7MzNIW1+lyQZb4KcVfqUYlwL0NiR8HdlQbhJ
         Yq+NTgv+AVF18q7WWEjc2qZ+8Uj7QU7++MUxXPmzW6shq1I+fT0te5vuiMtxYhob9Qwp
         oTng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781852848; x=1782457648;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nFTjg/IHL8HMr8nAct3jT4CdzzQIgwwmBvMwQOcvCtw=;
        b=gKg899e4dQl1cm6bpgQVxy1Yf7YV5mwtpddWJsQfkJ6zU4RqvWEwzJxcOqXCrvokgc
         mgyL84JvJdXWrAJYs0l0FBDAhh8kpFx5XPsXvDtNp9WGyGWRlq8lOiK52nIojUCxhW7K
         vP6oaaUAJxoSCX6UlpAysmvF/2B+/7/mxki/7lZuK9pfpY0dRV3lrCkhikg7ot6dSGZB
         0o/Sfs44EUHZD+DaqNBLSj2J69AH0Py/y27lkZoRbeZAxu1pLmBmSDwLW9vKhVJDHnCB
         Ibm2gTVKgTUccZW3LU5M1cFaGMFTMEBZMys/3SlvCUIt/Hiw3PJwXb7mU38biTfDODPq
         S2VQ==
X-Forwarded-Encrypted: i=1; AFNElJ9fUNTNA7eOipXsVjKobcf/dwliYlIBXYdylGZCOR/r7WnjQjPkQIM/AW1RRyLcj3SCC0asti8=@lists.linux.dev
X-Gm-Message-State: AOJu0YyxVEeLx5USMTJs0x/5myM39fw+zegyyRq8QuX35ElRWp4FSkqj
	9MNTYCQsFXgb3roFfdgpCXRZ1UDDDLYRG0JH5ieZaS44NnIVmdRQ/L4tt/FulJa5UIGp1n19Qoq
	A1Q==
X-Received: from wmbf6.prod.google.com ([2002:a05:600c:5946:b0:492:4336:6b5f])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:310e:b0:48f:e3e7:3d39
 with SMTP id 5b1f17b1804b1-49242328b63mr18197345e9.11.1781852848101; Fri, 19
 Jun 2026 00:07:28 -0700 (PDT)
Date: Fri, 19 Jun 2026 08:07:17 +0100
In-Reply-To: <20260619070719.812227-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260619070719.812227-1-tabba@google.com>
X-Mailer: git-send-email 2.55.0.rc0.738.g0c8ab3ebcc-goog
Message-ID: <20260619070719.812227-7-tabba@google.com>
Subject: [PATCH v2 6/8] KVM: arm64: Minimise EL2's exposure of host VGIC state
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

