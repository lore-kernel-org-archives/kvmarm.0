Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DB013D092D
	for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 06:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781247582; cv=none; b=UFJtpt2SbP4EUPTNO5KFnHKWBPvorXTiI6RvrE7593AXhD7ZKeGAfrZfK1xP46ws/enqmgF+OKXuYhPoa64Ov3BHWgCs8Bsut6Gj2VTUAdpVvd6YeVEUOWnKl63WQWxdTeHXEHQAV12qF8DbIV4w6qoN63ZJ8aw8kV87UMmoiIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781247582; c=relaxed/simple;
	bh=nPvyAKqBIhUojwNk0xa7eh01eFuZtPOkUGrZd/kDP6w=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fwUlVLkNFj0BYn3XS3FOLv5fgkAtpfeJDidF5Q3W2OrrLbcC+T0gfMtZ32RWHA5SBb938wio3ZJbCiQZo+hM7T6156DVaYkhglFfQeDRv9zp/iC8RbVrLPA8g1HUqEEpaARjqUoS94tw3/vH9pN0Qow238IX2KUExfgRoEmQVCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RjxOG0VH; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RjxOG0VH"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-490e547f3cfso5719525e9.3
        for <kvmarm@lists.linux.dev>; Thu, 11 Jun 2026 23:59:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781247576; x=1781852376; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xebdFH52a2q7PdzScDZN73wHZPgaOs9QBV3wO9+5R+0=;
        b=RjxOG0VHRMI+mzBjpU5ycodM7g/QKMhm+mZE0FtMzpO9+ij+F4gosRaHspoOnqIEWF
         GatYYszAf8xbC0URBmH3moxEo81XO1shoMjZaRHm74uDLAc7ttYIl4JpEdNx3npJ41yq
         UZgrcwbiHjTnxjNJGfgnFQ/vQ9XeGZ6nF8AshjO/rtF9MrQI/8gdLwpVPMUOnJy9m5KJ
         GQ+y9kvbc4dLbz+6uQsIL+jqKj6xiY7lTXSxNs+Mpgt7INR7hIZk8xXvsqWMSZbXf47L
         6Cu2/eMChBkxDN37XUl4cmHs2Zg8sMRen9SgDMCnTUq0eJ/0ckrZS6iyxc0ZKrSkWjyk
         MYXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781247576; x=1781852376;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xebdFH52a2q7PdzScDZN73wHZPgaOs9QBV3wO9+5R+0=;
        b=CJqUCA8mBy08Xku9jSSq/34SK54UHh2We90OaZztn8ObwcsRUvAHf5cjoilmp9KXKD
         991Pmw5NaGzIZBFN0FfJPPRDcBJvCYguggjJvZiNIAI5EZzNAWsU04S0/1+ZsJ9jUUdp
         btRCXicz60rwXyTdiCjOwPHNWcLju/hvl1JBFF69zrkYHebVyoxYfNgobsMphwYtcuHl
         xV1prIzV41TzsWaD14nAEP6rf3EFA+4ht/ztRF+zV1590cLgZxVTJt/gCPEd85VRR5NJ
         rJF+ayu/XCMsr1Nt8o26JsvYqonbanPWpib+8ydsXA8egQkgaM9g9qzi9Y2geDU6mWdb
         gOCw==
X-Forwarded-Encrypted: i=1; AFNElJ9aGHpcPzlIDHv7yZFUn9KqXv0OI6s7m4IG72ki5Tw0Tys+iq0JBiz3ZWNpeToyR7/8AO9rJTA=@lists.linux.dev
X-Gm-Message-State: AOJu0YwErxt8fjEgNGQs+zi9VpdYtGq/EiOwwh41IXlG/IqZlNPdsMK4
	lwfyB8gf6DCap3hP5K+9xXWnB4FqgC6JDcvohvRJ5/K7Sizsy3d7s7EFGYAAQQ3zgX5TxdYAmhm
	Qrw==
X-Received: from wmby27.prod.google.com ([2002:a05:600c:c05b:b0:483:6e28:c16f])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:c4ab:b0:48f:f64c:c2fe
 with SMTP id 5b1f17b1804b1-490ec4f8090mr18979405e9.22.1781247576386; Thu, 11
 Jun 2026 23:59:36 -0700 (PDT)
Date: Fri, 12 Jun 2026 07:59:23 +0100
In-Reply-To: <20260612065925.755562-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260612065925.755562-1-tabba@google.com>
X-Mailer: git-send-email 2.54.0.1136.gdb2ca164c4-goog
Message-ID: <20260612065925.755562-10-tabba@google.com>
Subject: [PATCH v1 09/11] KVM: arm64: Minimise EL2's exposure of host VGIC
 state during world switch
From: tabba@google.com
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>
Cc: Fuad Tabba <tabba@google.com>, Will Deacon <will@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Quentin Perret <qperret@google.com>, 
	Vincent Donnefort <vdonnefort@google.com>, Sebastian Ene <sebastianene@google.com>, 
	Per Larsen <perlarsen@google.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Mark Rutland <mark.rutland@arm.com>, 
	Jonathan Cameron <jonathan.cameron@huawei.com>, Hyunwoo Kim <imv4bel@gmail.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
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
index 420fb19a6476..2f165b6c7b07 100644
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
@@ -220,6 +222,16 @@ static struct kvm_vcpu *__get_host_hyp_vcpus(struct kvm_vcpu *arg,
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
@@ -489,16 +501,63 @@ static void handle___vgic_v3_init_lrs(struct kvm_cpu_context *host_ctxt)
 
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
2.54.0.1136.gdb2ca164c4-goog

