Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14E6C3D813F
	for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 06:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781247585; cv=none; b=lGMbGyFXKjbjTXklSXETjBtyYcfguhfR75Oj8Mi2iORVlajFZTfx5wA33Chw6BNPT6pDYXaZfR4pC5gB4easc6OD1mcBpvQEWZZQUCQ+ILPU0EhnTv1rBez7E/HSPJOBlIVPiCYNG6RQ8p5IUUkYOw5CTUz314U/zGrPcBbuaaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781247585; c=relaxed/simple;
	bh=6dyUiTeSzRmFCDfL5uGb7un2oTbS1K23lFvptzrVlrg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DvFq1KYeLYtB2Tc0aRzc83QKndeKNLOpBZddb6GazXYqrviMGwOGA6T5fr9LwspaicnEtIW1SQBXXeHdfv82H/goNOogtKgCv9z2/jRjGcFaHjCIXiX1gKXTnKGCJtYWOn2q07bghn2I7b0TwBNbnMkjwLeTqNtKRTn5xvmEy6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gXTffJBz; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gXTffJBz"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-490ae016853so3786175e9.2
        for <kvmarm@lists.linux.dev>; Thu, 11 Jun 2026 23:59:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781247577; x=1781852377; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2Ak3jNeAkvp8IytqE3xP3zJXzhYP29jFMd9zBAcRoYc=;
        b=gXTffJBzko4m/bZYGxRZ+wFO5YA0jKTHBbl7QhNG5il3w8bFLZtT6XTd2bWozb67i+
         NxT8/BRHhRqH60irB6OA9QgdxY59SoZKXhuIO5njiu/+5Ym9m4UAxQsvdY2rRE4WxAxd
         mFoy9kkyyJlIVLC657xOd462bc1e5w+4RFpR2hGEc7g5UwKY1h59jua+/r1VObolkjPC
         ZenhaHkaQqH1+gdyL4JcQkwqqmAg93gudTF4JjBEVaFzWp+H/1BvvH3BYBtr6dq9vxlH
         nkLBj6ZCDNxEWECVJpPkvbWiMlfeBibclf2HM9t0ombv+6VMFXuTI+W6W4agi0dGwY8T
         dHIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781247577; x=1781852377;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2Ak3jNeAkvp8IytqE3xP3zJXzhYP29jFMd9zBAcRoYc=;
        b=MwuNi/+PpKj0L8a1JMQJs9BkX8uoQRTzdyEBpOx9sxX9Ztrsep+lXWmaGht98mRs5L
         c3KjRxZBo4no8twpFJOYLc3EeO6fG3g7Ln+rKHM460SlZ/ogvNQ4YOmN5mJIP0s4UX00
         HJj9NILzyyDDnsv7iiyg0tEuBvFw2wWzvCDlZIZTpz8/mrpjB2LwBxOXr2SHFFyRRapo
         BTr36WBtFmraiJKeBJhsVXPnSioSqlGADrDshoiEgRJ7wAMNMRbemxWJa3KrcONAXsc8
         M2Bw+QOFHxF+CJnmYukBWYHEUuAcFGEGSy2OMtK5wmAkAzcnJMabTOhPGkVk2UCdH3nS
         MgJw==
X-Forwarded-Encrypted: i=1; AFNElJ8V1QVNAXBpVLaaFjrtrE333XoWDtBha1ugIKVPZXLhDfkFZh7B1VpaYRapWoMJ5Yv9/Z9nPVU=@lists.linux.dev
X-Gm-Message-State: AOJu0YxduPYIfFCdYqDbl6jkbox86IgRy3TjZU8ODnSbZCi2fiFPnvp6
	ri3sx/G4nkwRVMSkguKrhy7n8fFEKNXB273BSkXRQt1zh/WOeo5knlS2H27ItVOTXQaX7acV6xG
	t+A==
X-Received: from wmgg21.prod.google.com ([2002:a05:600d:15:b0:491:34a2:17f7])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:c16f:b0:490:6e11:c303
 with SMTP id 5b1f17b1804b1-490ec4e6f22mr15551875e9.13.1781247577304; Thu, 11
 Jun 2026 23:59:37 -0700 (PDT)
Date: Fri, 12 Jun 2026 07:59:24 +0100
In-Reply-To: <20260612065925.755562-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260612065925.755562-1-tabba@google.com>
X-Mailer: git-send-email 2.54.0.1136.gdb2ca164c4-goog
Message-ID: <20260612065925.755562-11-tabba@google.com>
Subject: [PATCH v1 10/11] KVM: arm64: Add primitives to flush/sync the VGIC
 state at EL2
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

pKVM performs its own world switch for protected VMs but has no
primitives to move the per-vCPU VGIC state between the host and
hypervisor vCPU contexts.

Add flush_hyp_vgic_state() and sync_hyp_vgic_state(). Flush copies
vgic_hcr, the in-use list registers and used_lrs from the host into the
hyp vCPU and pins vgic_sre to a fixed value; sync copies vgic_hcr,
vgic_vmcr and the in-use list registers back. The active priority
registers are handled separately by the save/restore-aprs path.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Co-developed-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 50 +++++++++++++++++++++++++-----
 1 file changed, 42 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 2f165b6c7b07..23e644c24a03 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -99,6 +99,46 @@ static void fpsimd_sve_sync(struct kvm_vcpu *vcpu)
 	*host_data_ptr(fp_owner) = FP_STATE_HOST_OWNED;
 }
 
+static void flush_hyp_vgic_state(struct pkvm_hyp_vcpu *hyp_vcpu)
+{
+	struct kvm_vcpu *host_vcpu = hyp_vcpu->host_vcpu;
+	struct vgic_v3_cpu_if *host_cpu_if, *hyp_cpu_if;
+	unsigned int used_lrs, max_lrs, i;
+
+	host_cpu_if	= &host_vcpu->arch.vgic_cpu.vgic_v3;
+	hyp_cpu_if	= &hyp_vcpu->vcpu.arch.vgic_cpu.vgic_v3;
+
+	max_lrs		= (read_gicreg(ICH_VTR_EL2) & ICH_VTR_EL2_ListRegs) + 1;
+	used_lrs	= host_cpu_if->used_lrs;
+	used_lrs	= min(used_lrs, max_lrs);
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
@@ -139,7 +179,7 @@ static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
 
 	hyp_vcpu->vcpu.arch.vsesr_el2	= host_vcpu->arch.vsesr_el2;
 
-	hyp_vcpu->vcpu.arch.vgic_cpu.vgic_v3 = host_vcpu->arch.vgic_cpu.vgic_v3;
+	flush_hyp_vgic_state(hyp_vcpu);
 
 	hyp_vcpu->vcpu.arch.pid = host_vcpu->arch.pid;
 }
@@ -147,9 +187,6 @@ static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
 static void sync_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
 {
 	struct kvm_vcpu *host_vcpu = hyp_vcpu->host_vcpu;
-	struct vgic_v3_cpu_if *hyp_cpu_if = &hyp_vcpu->vcpu.arch.vgic_cpu.vgic_v3;
-	struct vgic_v3_cpu_if *host_cpu_if = &host_vcpu->arch.vgic_cpu.vgic_v3;
-	unsigned int i;
 
 	fpsimd_sve_sync(&hyp_vcpu->vcpu);
 	sync_debug_state(hyp_vcpu);
@@ -162,10 +199,7 @@ static void sync_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
 
 	host_vcpu->arch.iflags		= hyp_vcpu->vcpu.arch.iflags;
 
-	host_cpu_if->vgic_hcr		= hyp_cpu_if->vgic_hcr;
-	host_cpu_if->vgic_vmcr		= hyp_cpu_if->vgic_vmcr;
-	for (i = 0; i < hyp_cpu_if->used_lrs; ++i)
-		host_cpu_if->vgic_lr[i] = hyp_cpu_if->vgic_lr[i];
+	sync_hyp_vgic_state(hyp_vcpu);
 }
 
 static void handle___pkvm_vcpu_load(struct kvm_cpu_context *host_ctxt)
-- 
2.54.0.1136.gdb2ca164c4-goog

