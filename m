Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.197
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795114352;
	b=3eS5PalOgwt1h4nd84i9I5s0FMeUnOeRRPCWD5+Mu/rBP8h/ZAVYpii89ZLY7H9Q3eL+
	 uifUlEx0FXwz6BgVcBzL04wlz5ltfpbiMeiIVGaAHgychvCiPZxVkuWjQQ1EHovSCctPb
	 6kBH7QC7RI5bKxiPxnDH2k6IJ5adkyGoTbh0q1xto/CF55oYOqdPc2bra4BWMJAWTM0a0
	 GqUTXPLSdEJcR5IVIP46+OyYO2Y3c5ccdcqjoh2+ek5oABtkLDkAo8/XqZHF2oet2Gpdg
	 s+M0GZVgwiNofGRFOAeautBNJYrHilZyjw8cZiJaqCUzg7QfqhAERh3HNGzsjCTB5Pg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795114352;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=ss6SV+PFlqizaJrWDEhTfQYiu9JlRuTku7nU9+88v4U=;
	b=DoQoVH7XLETmnGsEHJFeS5FS4xPBo7y9qJqz0z4hdBYxtWNx9unhaHxCyjdjQNkCJ1R2
	 JfkmkdBOCoYnX38p6mO4rhLN55gy5BPVBhIn08iE/3FwQ1OGWYL0Gxycys/pOFvUEhOOF
	 UnGOwGqnMg+MrQBixDcVbB4Wllka6U1/+/+etBVXQujyw5YvL1ESYXSOQvCyvQf3QOGAF
	 kHNppOpIi3rUjRWmw59/4zo+u5tpFwI0y2QgmDVLDWYFSOWy+KAXiGEQPmtKI/ZWDxmgQ
	 gVvIdQ2IXHCDCTfDOu4ELd+QSgELBOPIl5qGlkOlG1LBtnJvDcftr6njs9lujdmihQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=pYbsEnj5;
	arc=none smtp.remote-ip=209.85.167.197
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBD9C606C13B
	for <kvmarm@lists.linux.dev>; Thu, 19 Nov 2026 18:52:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EBD9C606C13B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=pYbsEnj5
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-4cbf700ddccso164752b6e.0
        for <kvmarm@lists.linux.dev>; Thu, 19 Nov 2026 10:52:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795114351; x=1795719151; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ss6SV+PFlqizaJrWDEhTfQYiu9JlRuTku7nU9+88v4U=;
        b=pYbsEnj5zgqZPNFI53s6d10nNxQwcLr0NJQWL0mhkndCUVUTailQ63EGPdb5q5ah1u
         lY1KXmoWlrOws0S9jgpLCuUYNzPeVUlCdAxDeyjj2XAFKXoW/1Xxm9i++Oojr+6POelQ
         L+kgoSnPQORBaZlB3GoCTAEiLVoi3ZvfSi9FhSHjQWYZ523an/xY0/490UNcKX1QFEeZ
         Qy1DZOGLQe02VAqBqe7Rnmo3p32GYFFNXE4MAD1t90VaK7Kdo5tXechcp0MnJV24eZC5
         LjFdyQuNYhnbXtvETCz7RKvqBdmhU+0Fw4ZDpdVubd5z2r34Fr9cRHE3mrWQ/1NVzm6s
         4C+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795114351; x=1795719151;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ss6SV+PFlqizaJrWDEhTfQYiu9JlRuTku7nU9+88v4U=;
        b=HEeRj1dMtldJ6Z4gNTp/3t3Vgg0sD1XOzQAQ2MGsQx1DkYXJ8ACnnI66T69KHgRiUj
         xiuhywv5kYUJQzgPqdc8X3kFT5GMZuftO2zbOpeeaZStvjJ5KWwR5VbH78xlemHJtxe0
         1+9U8FL0RHZbBDA4n1W1L2yl1oR0JE/lyO4Wbuhx5hW9XKR5kV7Do5xp2CACi3dgHK+a
         51upPz4fygc/8ib6Rf5aqOj17tjiBryDW3Gb82UpxqCmId0BWefLopNCFRk/MEueiBOE
         UHy/p7dIWX1C33x6L4PJ8DM4MeptsNemEbA1DQsw7g1+EOQGkvhaVAnVYTOEgwlBkTCn
         9gkA==
X-Forwarded-Encrypted: i=1; AL+hErHC7QMLvMW7vYjJK4OSGDqBhl75L0wi89alWDeHNJVamWlw5M4quWg+uIVcapkw9xJ1uaZ4zHQ=@lists.linux.dev
X-Gm-Message-State: APuU4Z8fNKQ8pFkJkxLP4y3+PL0zMVXPTlsQKikpfvD9HB+yBjpimrIj
	RYlxiRUsWZQwZG61StBJF9cauGRbuqlC2HITVvG5JBUtSEoNX84GIWs1+g4Qvyi5+ClY0hKsQ6H
	9aUyWmhEr5Fq3nnEYa48wYvWNWA==
X-Received: from jaav16-n2.prod.google.com ([2002:a05:6639:1d0:20b0:61f:23a0:7d2])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:4f4f:b0:56a:dc07:f218 with SMTP id 5614622812f47-57a0a10c801mr992416b6e.20.1795114350522;
 Thu, 19 Nov 2026 10:52:30 -0800 (PST)
Date: Thu, 19 Nov 2026 18:51:57 +0000
In-Reply-To: <20261119185215.632334-1-coltonlewis@google.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20261119185215.632334-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.56.1.809.ga0b61035b5-goog
Message-ID: <20261119185215.632334-16-coltonlewis@google.com>
Subject: [PATCH v10 15/33] KVM: arm64: Construct mdcr_el2 in a local variable
 in kvm_arm_setup_mdcr_el2()
From: Colton Lewis <coltonlewis@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Peter Zijlstra <peterz@infradead.org>, 
	Ingo Molnar <mingo@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Russell King <linux@armlinux.org.uk>, Jonathan Corbet <corbet@lwn.net>, 
	Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, James Clark <james.clark@linaro.org>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Mingwei Zhang <mizhang@google.com>, 
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Construct the new MDCR_EL2 value in a local variable before writing it
once to vcpu->arch.mdcr_el2. This avoids exposing intermediate states in
vcpu->arch.mdcr_el2 to interrupt or NMI handlers that may inspect it,
and simplifies upcoming Partitioned PMU modifications to MDCR_EL2.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm64/include/asm/kvm_nested.h |  2 +-
 arch/arm64/kvm/debug.c              | 27 +++++++++++++++------------
 arch/arm64/kvm/nested.c             |  6 +++---
 3 files changed, 19 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index 0f899addafa8b..a1ad046428a2d 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -90,7 +90,7 @@ extern void check_nested_vcpu_requests(struct kvm_vcpu *vcpu);
 extern void kvm_nested_flush_hwstate(struct kvm_vcpu *vcpu);
 extern void kvm_nested_sync_hwstate(struct kvm_vcpu *vcpu);
 
-extern void kvm_nested_setup_mdcr_el2(struct kvm_vcpu *vcpu);
+void kvm_nested_setup_mdcr_el2(struct kvm_vcpu *vcpu, u64 *mdcr);
 
 struct kvm_s2_trans {
 	phys_addr_t output;
diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
index f4d7b12045e8f..89c9fb0cfeee2 100644
--- a/arch/arm64/kvm/debug.c
+++ b/arch/arm64/kvm/debug.c
@@ -37,38 +37,41 @@ static int cpu_has_spe(u64 dfr0)
  */
 static void kvm_arm_setup_mdcr_el2(struct kvm_vcpu *vcpu)
 {
+	u64 mdcr;
+
 	preempt_disable();
 
 	/*
 	 * This also clears MDCR_EL2_E2PB_MASK and MDCR_EL2_E2TB_MASK
 	 * to disable guest access to the profiling and trace buffers
 	 */
-	vcpu->arch.mdcr_el2 = FIELD_PREP(MDCR_EL2_HPMN,
-					 *host_data_ptr(nr_event_counters));
-	vcpu->arch.mdcr_el2 |= (MDCR_EL2_TPM |
-				MDCR_EL2_TPMS |
-				MDCR_EL2_TTRF |
-				MDCR_EL2_TPMCR |
-				MDCR_EL2_TDRA |
-				MDCR_EL2_TDOSA);
+	mdcr = FIELD_PREP(MDCR_EL2_HPMN, *host_data_ptr(nr_event_counters));
+	mdcr |= (MDCR_EL2_TPM |
+		 MDCR_EL2_TPMS |
+		 MDCR_EL2_TTRF |
+		 MDCR_EL2_TPMCR |
+		 MDCR_EL2_TDRA |
+		 MDCR_EL2_TDOSA);
 
 	/* Is the VM being debugged by userspace? */
 	if (vcpu->guest_debug)
 		/* Route all software debug exceptions to EL2 */
-		vcpu->arch.mdcr_el2 |= MDCR_EL2_TDE;
+		mdcr |= MDCR_EL2_TDE;
 
 	/*
 	 * Trap debug registers if the guest doesn't have ownership of them.
 	 */
 	if (!kvm_guest_owns_debug_regs(vcpu))
-		vcpu->arch.mdcr_el2 |= MDCR_EL2_TDA;
+		mdcr |= MDCR_EL2_TDA;
 
 	if (vcpu_has_nv(vcpu))
-		kvm_nested_setup_mdcr_el2(vcpu);
+		kvm_nested_setup_mdcr_el2(vcpu, &mdcr);
+
+	WRITE_ONCE(vcpu->arch.mdcr_el2, mdcr);
 
 	/* Write MDCR_EL2 directly if we're already at EL2 */
 	if (has_vhe())
-		write_sysreg(vcpu->arch.mdcr_el2, mdcr_el2);
+		write_sysreg(mdcr, mdcr_el2);
 
 	preempt_enable();
 }
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 4d83281a7a28b..b80d90ede9004 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -2237,12 +2237,12 @@ void kvm_nested_sync_hwstate(struct kvm_vcpu *vcpu)
 				 MDCR_EL2_TDCC	|	\
 				 MDCR_EL2_TDOSA)
 
-void kvm_nested_setup_mdcr_el2(struct kvm_vcpu *vcpu)
+void kvm_nested_setup_mdcr_el2(struct kvm_vcpu *vcpu, u64 *mdcr)
 {
 	u64 guest_mdcr = __vcpu_sys_reg(vcpu, MDCR_EL2);
 
 	if (is_nested_ctxt(vcpu))
-		vcpu->arch.mdcr_el2 |= (guest_mdcr & NV_MDCR_GUEST_INCLUDE);
+		*mdcr |= (guest_mdcr & NV_MDCR_GUEST_INCLUDE);
 	/*
 	 * In yet another example where FEAT_NV2 is fscking broken, accesses
 	 * to MDSCR_EL1 are redirected to the VNCR despite having an effect
@@ -2252,5 +2252,5 @@ void kvm_nested_setup_mdcr_el2(struct kvm_vcpu *vcpu)
 	 * trap MDSCR_EL1.
 	 */
 	else if (!cpus_have_final_cap(ARM64_HAS_FGT))
-		vcpu->arch.mdcr_el2 |= MDCR_EL2_TDA;
+		*mdcr |= MDCR_EL2_TDA;
 }
-- 
2.56.1.708.g77570a6a1d-goog

