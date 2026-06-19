Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6229635F189
	for <kvmarm@lists.linux.dev>; Fri, 19 Jun 2026 07:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781852722; cv=none; b=I/EQhMm2iWroWZ6/bB8HVSQYiZZXL5Kv6Z+017jeREBJwZnXdZLV5aJkek98AZMjtN50fMK+EhWtSWbeDG94KUkkA42TZZ5w1WgBOoABrSVblWVOfBJIgZ3XfSxqvBj9BOWK7U6fBCDEBS/ZWWF9wfcPN4GflZpudpTnZShbNtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781852722; c=relaxed/simple;
	bh=zWB5u1idfA4AdPs7jMtePhO4jDSl0x0MhXVkrlpo+94=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NGRn9WiQT/LO618+G3/CrAzPA/JmEjAovu4qSKISGAkn7CV+ZSHMRUUx/ryLP41dtjJ00hiNNq/IVvCHk0xgiDQ3Tn44odC6FJZ48GDj0QpFI1HR3HXxrw4pi0JZjkYo1ywK8yw5iLERCBp8QTGLaUrZTgs0s/QqIsXKmn7xl8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Rt0uK9da; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Rt0uK9da"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-490b93debc8so12005095e9.1
        for <kvmarm@lists.linux.dev>; Fri, 19 Jun 2026 00:05:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781852719; x=1782457519; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=HiUT5ABfb1SzLS+/NM78To0mA4a5Z1HMNy+YIWkerC4=;
        b=Rt0uK9daIgzLQ3XL9ogsSGUSBK8+xgwGmAbgnhHNeWeyyPw5FcjghUOslZVXHJm6ME
         YN6sh7hCYJd7+GsPe94bABWKFzL03aJp4IjdlbLxvj4nRxsVwHTKUHaePyywiVyaZ2Nu
         qkj7twcVBfcNKduUrgOUhuwY8HRsHoA7lOfTZWWnFk8ycAzEoNhWs1ek2NQcaowluQ83
         LxUVQBSV0QbyghrjNzQvMRaHA7qNUtOKL+Wpbb+LBH2x2oS57EvQo3DlcMXNn2lb++21
         7TV8NEtVIw9Fq5Uww6DnoPS1YMFhQO/AU+re6Z/BQkoiuXL1YpWH/z8zVrAuihE+ym08
         FhKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781852719; x=1782457519;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HiUT5ABfb1SzLS+/NM78To0mA4a5Z1HMNy+YIWkerC4=;
        b=jyMCPyBv3O3uGzQhiqBbhvJVmmFeOlh+VuGoALQZ/+Q+WZS+kVY064PvpwYmxIBFFI
         nlzSH4rpZYCJBrpw8P8TGnvCp2OLV6aHUCiF3BX4DYOneZ0IFVK09aBOa9zJdP5X/bLw
         JXSK2ls0sTfsNRtUANOuCpklV6kjik2zcgVvIF/KOFNYzBuwlBW86QCETVx1+yGk2e4S
         mtbgf7b4+0uKkSpEDX7O057vXdC2P+XJhOMcYtwmENb8/aWhH6BkiWSCUNwVWUhvdF2s
         0cgEkfpVCpevZlhRmi8PT8+9ahVHbQl8kD6y94OXskyq095ENs2MGF9prtqGCpcExk7o
         /PPg==
X-Forwarded-Encrypted: i=1; AFNElJ/cF+v/Gh4YxBdF8hbJDEDqQP3PAdmzzWsXyXg33xvEtAN7yiL3mXqmw2Y25edFedMP4THZZDk=@lists.linux.dev
X-Gm-Message-State: AOJu0YwG1vigWNi1pDi2DYSb7bKO5OSLVmbAuVuN33u09jIkFEMktC0U
	WKoXh3Az0ZWE+rtQ+B5erjzwDxGvXNJMH8U3WcLky67RsldEdw9Z3EQfP6Lvw76n9DYrAvDPUpT
	sbA==
X-Received: from wmfv3.prod.google.com ([2002:a05:600c:15c3:b0:492:4352:4fc7])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:c48e:b0:490:b0e0:3de2
 with SMTP id 5b1f17b1804b1-4923f5a8fd6mr40569085e9.33.1781852718385; Fri, 19
 Jun 2026 00:05:18 -0700 (PDT)
Date: Fri, 19 Jun 2026 08:05:07 +0100
In-Reply-To: <20260619070508.802802-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260619070508.802802-1-tabba@google.com>
X-Mailer: git-send-email 2.55.0.rc0.738.g0c8ab3ebcc-goog
Message-ID: <20260619070508.802802-8-tabba@google.com>
Subject: [PATCH 7/8] KVM: arm64: Add primitives to flush/sync the VGIC state
 at EL2
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

pKVM performs its own world switch for protected VMs but has no
primitives to move the per-vCPU VGIC state between the host and
hypervisor vCPU contexts.

Add flush_hyp_vgic_state() and sync_hyp_vgic_state(). Flush copies
vgic_hcr, the in-use list registers and used_lrs from the host into the
hyp vCPU and pins vgic_sre to a fixed value; sync copies vgic_hcr,
vgic_vmcr and the in-use list registers back. The active priority
registers are handled separately by the save/restore-aprs path.

Bound used_lrs by hyp_gicv3_nr_lr, the cached implemented-LR count,
instead of reading ICH_VTR_EL2 on each entry. That clamps the
host-supplied value and avoids a per-entry sysreg read that is costly
under NV.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Co-developed-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 55 ++++++++++++++++++++++--------
 1 file changed, 41 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index f25ee3971528..0194965930e6 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -102,6 +102,45 @@ static void fpsimd_sve_sync(struct kvm_vcpu *vcpu)
 	*host_data_ptr(fp_owner) = FP_STATE_HOST_OWNED;
 }
 
+static void flush_hyp_vgic_state(struct pkvm_hyp_vcpu *hyp_vcpu)
+{
+	struct kvm_vcpu *host_vcpu = hyp_vcpu->host_vcpu;
+	struct vgic_v3_cpu_if *host_cpu_if, *hyp_cpu_if;
+	unsigned int used_lrs, i;
+
+	host_cpu_if	= &host_vcpu->arch.vgic_cpu.vgic_v3;
+	hyp_cpu_if	= &hyp_vcpu->vcpu.arch.vgic_cpu.vgic_v3;
+
+	used_lrs	= host_cpu_if->used_lrs;
+	used_lrs	= min(used_lrs, hyp_gicv3_nr_lr);
+
+	hyp_cpu_if->vgic_hcr	= host_cpu_if->vgic_hcr;
+	/* Should be a one-off */
+	hyp_cpu_if->vgic_sre	= (ICC_SRE_EL1_DIB |
+				   ICC_SRE_EL1_DFB |
+				   ICC_SRE_EL1_SRE);
+	hyp_cpu_if->used_lrs	= used_lrs;
+
+	for (i = 0; i < used_lrs; i++)
+		hyp_cpu_if->vgic_lr[i] = host_cpu_if->vgic_lr[i];
+}
+
+static void sync_hyp_vgic_state(struct pkvm_hyp_vcpu *hyp_vcpu)
+{
+	struct kvm_vcpu *host_vcpu = hyp_vcpu->host_vcpu;
+	struct vgic_v3_cpu_if *host_cpu_if, *hyp_cpu_if;
+	unsigned int i;
+
+	host_cpu_if	= &host_vcpu->arch.vgic_cpu.vgic_v3;
+	hyp_cpu_if	= &hyp_vcpu->vcpu.arch.vgic_cpu.vgic_v3;
+
+	host_cpu_if->vgic_hcr = hyp_cpu_if->vgic_hcr;
+	host_cpu_if->vgic_vmcr = hyp_cpu_if->vgic_vmcr;
+
+	for (i = 0; i < hyp_cpu_if->used_lrs; i++)
+		host_cpu_if->vgic_lr[i] = hyp_cpu_if->vgic_lr[i];
+}
+
 static void flush_debug_state(struct pkvm_hyp_vcpu *hyp_vcpu)
 {
 	struct kvm_vcpu *host_vcpu = hyp_vcpu->host_vcpu;
@@ -150,13 +189,7 @@ static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
 
 	hyp_vcpu->vcpu.arch.vsesr_el2	= host_vcpu->arch.vsesr_el2;
 
-	hyp_vcpu->vcpu.arch.vgic_cpu.vgic_v3 = host_vcpu->arch.vgic_cpu.vgic_v3;
-
-	/* Bound used_lrs by the number of implemented list registers. */
-	hyp_vcpu->vcpu.arch.vgic_cpu.vgic_v3.used_lrs =
-		min_t(unsigned int,
-		      hyp_vcpu->vcpu.arch.vgic_cpu.vgic_v3.used_lrs,
-		      hyp_gicv3_nr_lr);
+	flush_hyp_vgic_state(hyp_vcpu);
 
 	hyp_vcpu->vcpu.arch.pid = host_vcpu->arch.pid;
 }
@@ -164,9 +197,6 @@ static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
 static void sync_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
 {
 	struct kvm_vcpu *host_vcpu = hyp_vcpu->host_vcpu;
-	struct vgic_v3_cpu_if *hyp_cpu_if = &hyp_vcpu->vcpu.arch.vgic_cpu.vgic_v3;
-	struct vgic_v3_cpu_if *host_cpu_if = &host_vcpu->arch.vgic_cpu.vgic_v3;
-	unsigned int i;
 
 	fpsimd_sve_sync(&hyp_vcpu->vcpu);
 	sync_debug_state(hyp_vcpu);
@@ -179,10 +209,7 @@ static void sync_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
 
 	host_vcpu->arch.iflags		= hyp_vcpu->vcpu.arch.iflags;
 
-	host_cpu_if->vgic_hcr		= hyp_cpu_if->vgic_hcr;
-	host_cpu_if->vgic_vmcr		= hyp_cpu_if->vgic_vmcr;
-	for (i = 0; i < hyp_cpu_if->used_lrs; ++i)
-		host_cpu_if->vgic_lr[i] = hyp_cpu_if->vgic_lr[i];
+	sync_hyp_vgic_state(hyp_vcpu);
 }
 
 static void handle___pkvm_vcpu_load(struct kvm_cpu_context *host_ctxt)
-- 
2.55.0.rc0.738.g0c8ab3ebcc-goog

