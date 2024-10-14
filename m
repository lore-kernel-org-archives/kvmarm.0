Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0CB915B966
	for <kvmarm@lists.linux.dev>; Mon, 14 Oct 2024 10:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728901470; cv=none; b=CAT4aWxJMkSj8kEIR1eTJ5eAuBEMw952W1gNC1ekQ22SgjcgMKQhHY7DOv+DlOIlmAiCdN3sl1v1xqSlngFLzp5nKvS+bslTjaCFz7ajF0GTP/cNIJ3T7eRgmEY7DmBinY6QIcN9eX61PCqcAQM6zHs7eQxY77n1SKm037/dYT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728901470; c=relaxed/simple;
	bh=+Tttj1w9r93mHCVP+3hFymnwHbdS9EM+4BBwyKSiaFM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=abyrDR/xzI2/SfzXEE3sRPFbRuVncFp9xBwZeqm3wUtZMJQxAms1ciWAn8QvDE/8Ju+7WYQAN11DOxVMp6KVeFY6e+ssvb2uahx1g/Pkvhm0iCEcGa6uWvbhjLKQPVx1RrIxpeCT5InV3Cx+RBJoaW19sHfhD9ml+qtPrVelr8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Q2gwbQEn; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Q2gwbQEn"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e293150c2c6so3627063276.1
        for <kvmarm@lists.linux.dev>; Mon, 14 Oct 2024 03:24:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728901466; x=1729506266; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hBsiOuoUPTJrqcIbqk4lagLElR1Q8/+Viz4LI9Vn2n8=;
        b=Q2gwbQEniK1uSQdniB+QGiuy6P0uMUkFAgsLBswLIkJfK5H3JCrJo0kxMDzKj5wF7I
         EIyNTPjc1PhAkGtdcWetRUuIOwDlAJS7wPgk7sqczlNae2ekthco8WpF1U/TgnA/RkoS
         sQO41cZxsXsILIPjkXm6YhGzhsmab3huwC/0A0Hkf6yiV2Os/YtgrCNZtfYrLXV/WWU0
         D3x4kIvpEwycoppsr6GVY+BtO/Xp7jHfCTbOpPDOkEIdY/aSNjMafDMV8qc3rXRL+plx
         EM60ci8DBRpxA5TMkBUM/TEOzuR8JchVu9Ufy4iSRc6xPC/O+DLDv9/xJVfVYGEQr5fN
         dmuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728901466; x=1729506266;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hBsiOuoUPTJrqcIbqk4lagLElR1Q8/+Viz4LI9Vn2n8=;
        b=RHUQIEQiwng6brUCgPO/mSI+GvPfqLpno5YVAUyXnpSvuepDN34MO2VJomAeUT1wF5
         GVyt4NSqFrgXU1oEjYEL8b2cykSNfQCVZCaHrXe9m6FUhw4QugD0Zjv4/w2r9DYWufJW
         ZnGAuBCSZ2GbO4g5FKa8l/YOSWhH5pcYUt4iid5hWQeQdS2TnHKdObbqqIgpnTHfZxJw
         BZ/9NOGK1CjV2okTZZ4xmsefoLGgFax9l7M0pRiDlhsmNF+19LdX7Tz+/2DbjVfsffPj
         PLMzc1OSIASAL0ecBBuETjFGWpELj1DztR/inC5bCJiLd7cEe5TNYuVnKNKfmW2anEBZ
         m2uQ==
X-Gm-Message-State: AOJu0YwfAa7GUamUMoEIdQD/lMhdEivMwOMO8klxC2J1wMhtjfCDmik2
	bCnJfWhuVtD397BjLngAsVLreWNkhQEg0ZCq0ezxN0WPJbJqVWu0JbVwUckZSh4NhLKSaFIx1iR
	sMWCZfe252uknKSFQhvmqyfSZmqHxC5QvhuN/5z0pd1SBVI7hP68cri5jnC8s56sCBi7KZHs4pa
	xiCxgg+gZvZ9A9tmG8u53La2AZaYs=
X-Google-Smtp-Source: AGHT+IEFdh0hVyoj2MgBQwLbfceN8az12r7Q/BkvckNAufGyr7TTJGLmDcpzKe8fudSZaser7BMS7ijsNw==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a25:8745:0:b0:e28:fc1b:66bb with SMTP id
 3f1490d57ef6-e2919df896dmr7437276.6.1728901464850; Mon, 14 Oct 2024 03:24:24
 -0700 (PDT)
Date: Mon, 14 Oct 2024 11:24:12 +0100
In-Reply-To: <20241014102413.4092725-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241014102413.4092725-1-tabba@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241014102413.4092725-5-tabba@google.com>
Subject: [PATCH v1 4/4] KVM: arm64: Initialize trap register values in hyp in pKVM
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, oliver.upton@linux.dev, catalin.marinas@arm.com, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	will@kernel.org, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Handle the initialization of trap registers at the hypervisor in
pKVM, even for non-protected guests. The host is not trusted with
the values of the trap registers, regardless of the VM type.
Therefore, when switching between the host and the guests, only
flush the required bits of the trap registers from the host's
view that are required for hyp-host communication.

Reported-by: Will Deacon <will@kernel.org>
Fixes: 814ad8f96e92 ("KVM: arm64: Drop trapping of PAuth instructions/keys")
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/hyp-main.c |  4 +++-
 arch/arm64/kvm/hyp/nvhe/pkvm.c     | 35 ++++++++++++++++++++++++++++++
 2 files changed, 38 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 1a224d5df207..6aa0b13d86e5 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -105,8 +105,10 @@ static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
 
 	hyp_vcpu->vcpu.arch.hw_mmu	= host_vcpu->arch.hw_mmu;
 
-	hyp_vcpu->vcpu.arch.hcr_el2	= host_vcpu->arch.hcr_el2;
 	hyp_vcpu->vcpu.arch.mdcr_el2	= host_vcpu->arch.mdcr_el2;
+	hyp_vcpu->vcpu.arch.hcr_el2 &= ~(HCR_TWI | HCR_TWE);
+	hyp_vcpu->vcpu.arch.hcr_el2 |= READ_ONCE(host_vcpu->arch.hcr_el2) &
+						 (HCR_TWI | HCR_TWE);
 
 	hyp_vcpu->vcpu.arch.iflags	= host_vcpu->arch.iflags;
 
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 954df57a935f..01616c39a810 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -204,11 +204,46 @@ static void pvm_init_trap_regs(struct kvm_vcpu *vcpu)
 	}
 }
 
+static void pkvm_vcpu_reset_hcr(struct kvm_vcpu *vcpu)
+{
+	vcpu->arch.hcr_el2 = HCR_GUEST_FLAGS;
+
+	if (has_hvhe())
+		vcpu->arch.hcr_el2 |= HCR_E2H;
+
+	if (cpus_have_final_cap(ARM64_HAS_RAS_EXTN)) {
+		/* route synchronous external abort exceptions to EL2 */
+		vcpu->arch.hcr_el2 |= HCR_TEA;
+		/* trap error record accesses */
+		vcpu->arch.hcr_el2 |= HCR_TERR;
+	}
+
+	if (cpus_have_final_cap(ARM64_HAS_STAGE2_FWB))
+		vcpu->arch.hcr_el2 |= HCR_FWB;
+
+	if (cpus_have_final_cap(ARM64_HAS_EVT) &&
+	    !cpus_have_final_cap(ARM64_MISMATCHED_CACHE_TYPE))
+		vcpu->arch.hcr_el2 |= HCR_TID4;
+	else
+		vcpu->arch.hcr_el2 |= HCR_TID2;
+
+	if (vcpu_has_ptrauth(vcpu))
+		vcpu->arch.hcr_el2 |= (HCR_API | HCR_APK);
+}
+
 /*
  * Initialize trap register values in protected mode.
  */
 static void pkvm_vcpu_init_traps(struct kvm_vcpu *vcpu)
 {
+	vcpu->arch.cptr_el2 = kvm_get_reset_cptr_el2(vcpu);
+	vcpu->arch.mdcr_el2 = 0;
+
+	pkvm_vcpu_reset_hcr(vcpu);
+
+	if ((!vcpu_is_protected(vcpu)))
+		return;
+
 	pvm_init_trap_regs(vcpu);
 	pvm_init_traps_aa64pfr0(vcpu);
 	pvm_init_traps_aa64pfr1(vcpu);
-- 
2.47.0.rc1.288.g06298d1525-goog

