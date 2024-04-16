Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA4EC85929
	for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 09:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713261447; cv=none; b=jzL4rkPt4Rrue/39N3yZywtz1xyT4XVvnS/rw0LrpbGhFihw0whH0jppQMZ5AjwWmNWYna+8F1ddsitHRzw8mw6TbWc5Hp3gjovPPvkiKZ+B66WAA5TlhErwzwPE6YpwntWklgRH8mk8eo5daR9CVHI2eAmCEHZ1JBa3zwU8xAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713261447; c=relaxed/simple;
	bh=YofNHGlvcdj4MjrlHziY15xmL01amqasGoHxR/R8aX4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Kd1ll4Fs8tlQJO8zoH51YGbErfz0vooQky6Ci8ZbauvvRsgr41lttL6f7hEFFzfydwaD+QID1jvMgP3BcwPweG555CaMKinaVuTLsyYlsxe4LU56nT++7E0jaaJkzzOdTkHqtxXagKwwzT/sVAupkIb/s+HcUKFp8BGIZARWIeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Cdo/7oDh; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Cdo/7oDh"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dced704f17cso7121511276.1
        for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 02:57:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713261445; x=1713866245; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Nxcuw5rcydtXMEmOEVxfp//WijmrF6Z0TCXkDgPHyuk=;
        b=Cdo/7oDhj9EZuGRX1fFL7RSPh0u72287rficH9nzAprlA+fawn3Zqlu3Q5Z6wECjDI
         S6Z5eygxvfavzM8Ac00/RVJD2yyH2EvacXQDguBQH9e3DcdPF26jfevTby4jvR68x/Dj
         mRkIZe19p20nUepP7wR8CFRaJ2mpJ4YcJ1SUlsvh/oAV3WMRk1R1aIprxO/yMDE2VuZt
         xfua2jh8/5poFaCsf/WCVt4qyzNxMueP3/pu/kr5JHnCz1aQY6yOsseA3u0mVDwv1yph
         Jn1dDuLHV1+Z16RPRPstlhIcxD3pQ8TBcrNqPZ4of/anp7/080/COJfRWlfEHv6H+ZUw
         pQpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713261445; x=1713866245;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Nxcuw5rcydtXMEmOEVxfp//WijmrF6Z0TCXkDgPHyuk=;
        b=Jnb+W7kv6uJJ0XxOQlxCONJYiycESSCbnOqSUx0ykRJeM8Rur/Mwy2a8QqMd5M02J5
         cQ81YRQbsOhaRyw9FBFkI+En5lDwqtuywocFRG4tkWdEqe9bawl1tbXQ48+Du8vdN/Qn
         kHcGYdvdI088QcyqMHBp+/AybO9zXRwT/eMSBiG+IxCg/Fz3gbRgydgF1QVF/qcFQNg7
         2jQpI4nZSBtVJf8nUFensKbkh678a/xnlHYXp7pymUh/0Z5+Ka3pl8fbRXcIu35STa58
         VRDh8owseEwMoi38rwpioOzfp87VIP5CTIaCoU566Nhe3NCjPeYnxZcSNmMUVdBrLqNm
         syCg==
X-Gm-Message-State: AOJu0Yy1ef0OrSBtd36BbObeaHwd1D7thyMHjsDHVPH5Dd+eUAOw+qZg
	9CT9YzoJzD3WIP2cEWx55wZnEhnglvTvun7yaZMpJWBoH9qtCcSvV9BJAAlWAnfkHt2pyWL4/Et
	1LojWSvRbNmwNSX8x43ay99VhZl3LcFAt5avsHF9s80L7yoLffj/otqywubPfz0AZRIdCTMyvTQ
	i8Qq6yQI4WiAjDUuiY573u7PIzDkI=
X-Google-Smtp-Source: AGHT+IGl4i7jih8ofXtGtkEMKnA6OJSit9kimw7M9gRhzgKQZFhiDm1KTQ43A53mLvRf/razVUntC2FW2Q==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:6902:1247:b0:dda:c565:1025 with SMTP id
 t7-20020a056902124700b00ddac5651025mr1397310ybu.2.1713261444516; Tue, 16 Apr
 2024 02:57:24 -0700 (PDT)
Date: Tue, 16 Apr 2024 10:56:10 +0100
In-Reply-To: <20240416095638.3620345-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240416095638.3620345-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.683.g7961c838ac-goog
Message-ID: <20240416095638.3620345-20-tabba@google.com>
Subject: [PATCH v2 19/47] KVM: arm64: Move some kvm_psci functions to a shared header
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com, smostafa@google.com
Content-Type: text/plain; charset="UTF-8"

Move some PSCI functions and macros to a shared header to be used
by hyp in protected mode.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/psci.c  | 28 ----------------------------
 include/kvm/arm_psci.h | 29 +++++++++++++++++++++++++++++
 2 files changed, 29 insertions(+), 28 deletions(-)

diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
index 1f69b667332b..43458949d955 100644
--- a/arch/arm64/kvm/psci.c
+++ b/arch/arm64/kvm/psci.c
@@ -21,16 +21,6 @@
  * as described in ARM document number ARM DEN 0022A.
  */
 
-#define AFFINITY_MASK(level)	~((0x1UL << ((level) * MPIDR_LEVEL_BITS)) - 1)
-
-static unsigned long psci_affinity_mask(unsigned long affinity_level)
-{
-	if (affinity_level <= 3)
-		return MPIDR_HWID_BITMASK & AFFINITY_MASK(affinity_level);
-
-	return 0;
-}
-
 static unsigned long kvm_psci_vcpu_suspend(struct kvm_vcpu *vcpu)
 {
 	/*
@@ -51,12 +41,6 @@ static unsigned long kvm_psci_vcpu_suspend(struct kvm_vcpu *vcpu)
 	return PSCI_RET_SUCCESS;
 }
 
-static inline bool kvm_psci_valid_affinity(struct kvm_vcpu *vcpu,
-					   unsigned long affinity)
-{
-	return !(affinity & ~MPIDR_HWID_BITMASK);
-}
-
 static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
 {
 	struct vcpu_reset_state *reset_state;
@@ -214,18 +198,6 @@ static void kvm_psci_system_suspend(struct kvm_vcpu *vcpu)
 	run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
 }
 
-static void kvm_psci_narrow_to_32bit(struct kvm_vcpu *vcpu)
-{
-	int i;
-
-	/*
-	 * Zero the input registers' upper 32 bits. They will be fully
-	 * zeroed on exit, so we're fine changing them in place.
-	 */
-	for (i = 1; i < 4; i++)
-		vcpu_set_reg(vcpu, i, lower_32_bits(vcpu_get_reg(vcpu, i)));
-}
-
 static unsigned long kvm_psci_check_allowed_function(struct kvm_vcpu *vcpu, u32 fn)
 {
 	/*
diff --git a/include/kvm/arm_psci.h b/include/kvm/arm_psci.h
index e8fb624013d1..c86f228efae1 100644
--- a/include/kvm/arm_psci.h
+++ b/include/kvm/arm_psci.h
@@ -36,6 +36,35 @@ static inline int kvm_psci_version(struct kvm_vcpu *vcpu)
 	return KVM_ARM_PSCI_0_1;
 }
 
+/* Narrow the PSCI register arguments (r1 to r3) to 32 bits. */
+static inline void kvm_psci_narrow_to_32bit(struct kvm_vcpu *vcpu)
+{
+	int i;
+
+	/*
+	 * Zero the input registers' upper 32 bits. They will be fully
+	 * zeroed on exit, so we're fine changing them in place.
+	 */
+	for (i = 1; i < 4; i++)
+		vcpu_set_reg(vcpu, i, lower_32_bits(vcpu_get_reg(vcpu, i)));
+}
+
+static inline bool kvm_psci_valid_affinity(struct kvm_vcpu *vcpu,
+					   unsigned long affinity)
+{
+	return !(affinity & ~MPIDR_HWID_BITMASK);
+}
+
+
+#define AFFINITY_MASK(level)	~((0x1UL << ((level) * MPIDR_LEVEL_BITS)) - 1)
+
+static inline unsigned long psci_affinity_mask(unsigned long affinity_level)
+{
+	if (affinity_level <= 3)
+		return MPIDR_HWID_BITMASK & AFFINITY_MASK(affinity_level);
+
+	return 0;
+}
 
 int kvm_psci_call(struct kvm_vcpu *vcpu);
 
-- 
2.44.0.683.g7961c838ac-goog

