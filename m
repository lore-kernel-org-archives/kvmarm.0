Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C38235AC2C
	for <kvmarm@lists.linux.dev>; Fri, 19 Jun 2026 07:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781852718; cv=none; b=b+N7LQ6O7ULzKrY8PoxMCya98O6uExzMZ1gtz/wtZjkT2Bf2Md+cjo6nedvF1/r3cosrH0nNMdgP8+HmY7so8DIE4fORmXVI1OSEprwxFe+b9ifTFugzmiub6ctgls7I2tezdcE3aLqqZV8CMkLqy2ex2tZzN4iXiQ6jnNa+BKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781852718; c=relaxed/simple;
	bh=9JDMmHjB8wIpJAXXialivP1h3vqF/BPRvofAJksL8RU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=B9mOR2N2o2M9aUDGQKmJa3jMm6/pDWJikvyyqVPFJQl7OrJrXsOYkJPLGDufvAMVZQ1NLhRvGsBA42rFP87DxOvFsue0CR0qPOycwXaTbQt3PeUMy39DqH/6lM4Sl82bH1xNszEySdleSBHuOCWXd1wK1yE76Xb3RYAC5q8HiTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JHlI7+cr; arc=none smtp.client-ip=209.85.208.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JHlI7+cr"
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-695837464bcso2199553a12.3
        for <kvmarm@lists.linux.dev>; Fri, 19 Jun 2026 00:05:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781852715; x=1782457515; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=S1QUYcee151+QuSJM7wM7vpmF/sftjcL7x2ymejauNs=;
        b=JHlI7+crT++jZn6vfprxyWMYz6LDWoF9w1vv/xLR5KpdvsMbsbY6A20+Gt14ceMjAA
         TYuxkwccKkcs2UawslCtnyXpXO0YBg0t8rjeyT40G0eLYLaKdaWPUseYaOBpNP16DodV
         x3e16tBGC00Dj6NV0wcj7pbBdFXx7H2ZzXV+bQKOyZUjSEQQdVOOQXxuDRyBINElwAvd
         fyeN0v4gNdCxbZgnRtjGv11/nbq+3iPbE/MLWBV8+GIqgqNClDIfG1F2kHbQTR43CJ2y
         TI0GqGeDnKyk7naqd31+YqjYmScFD2oh3/fei/2wbKg1w2/USHt6RXT0HY2v5k84tBFf
         pvRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781852715; x=1782457515;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=S1QUYcee151+QuSJM7wM7vpmF/sftjcL7x2ymejauNs=;
        b=SY+FmlTGMIH2QpyxnrDG1KIuwYbK//vItVp8fafY4KOisRJ8j7vZebtB/+rdMr7OLw
         sRljaJ5iZEqVRuknOdLGRMmayXbSj6YY+M4etwkgYRjeTQ7WzwTkp6HEVAWs54sjFFXu
         3NpPgloWg3B1+TW4g/rpgWZA+bvETY0huNMauFg77ITEQFKfYP1iRXRozcAG5s9C+VoN
         5hGxMqrhi50XsLWoSzHwwKl/ZzQNWFHTFKgTvHrLrVQvepSyNgS4s7iiG8+hjX4pJta2
         37l/2eb007vAj3rnZ/Y7ouPydb2jS1AseYvKzSF9r58CCBDoqB6qk4h93Pp5nPNU/lh9
         DhYg==
X-Forwarded-Encrypted: i=1; AFNElJ83D5UGnvHELbRW+8GIBISJF9QckrI3eLxzS7wGDKg2ueNVCh5HRfAFyZNbc6L7uL7kVWqR0NA=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw1moHA3jyv7EM4ZS0zgbefwPwUaZB6QSnJI5iHHSR29jxwFhbA
	LQeC/c4qlSLadqsgaqZqVPJRKuAzY8SOesqSqDSFFMxjOePa5PxcgxcrVV70PEEf+4ZLvkpaybD
	Xug==
X-Received: from edrl9.prod.google.com ([2002:aa7:c3c9:0:b0:696:1db4:76f8])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:274c:b0:693:ed2:3f7a
 with SMTP id 4fb4d7f45d1cf-696e52367dfmr1182084a12.25.1781852714655; Fri, 19
 Jun 2026 00:05:14 -0700 (PDT)
Date: Fri, 19 Jun 2026 08:05:04 +0100
In-Reply-To: <20260619070508.802802-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260619070508.802802-1-tabba@google.com>
X-Mailer: git-send-email 2.55.0.rc0.738.g0c8ab3ebcc-goog
Message-ID: <20260619070508.802802-5-tabba@google.com>
Subject: [PATCH 4/8] KVM: arm64: Move PSCI helper functions to a shared header
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

Move kvm_psci_valid_affinity() and kvm_psci_narrow_to_32bit() from
psci.c to include/kvm/arm_psci.h, and move psci_affinity_mask() there
too, renaming it kvm_psci_affinity_mask() now that it is no longer
file-local. A follow-up series handles some protected-guest PSCI calls
at EL2 using these helpers.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/psci.c  | 30 +-----------------------------
 include/kvm/arm_psci.h | 27 +++++++++++++++++++++++++++
 2 files changed, 28 insertions(+), 29 deletions(-)

diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
index 3b5dbe9a0a0e..e3db84400d1f 100644
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
@@ -135,7 +119,7 @@ static unsigned long kvm_psci_vcpu_affinity_info(struct kvm_vcpu *vcpu)
 		return PSCI_RET_INVALID_PARAMS;
 
 	/* Determine target affinity mask */
-	target_affinity_mask = psci_affinity_mask(lowest_affinity_level);
+	target_affinity_mask = kvm_psci_affinity_mask(lowest_affinity_level);
 	if (!target_affinity_mask)
 		return PSCI_RET_INVALID_PARAMS;
 
@@ -220,18 +204,6 @@ static void kvm_psci_system_suspend(struct kvm_vcpu *vcpu)
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
index cbaec804eb83..f86a006d6713 100644
--- a/include/kvm/arm_psci.h
+++ b/include/kvm/arm_psci.h
@@ -38,6 +38,33 @@ static inline int kvm_psci_version(struct kvm_vcpu *vcpu)
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
+static inline unsigned long kvm_psci_affinity_mask(unsigned long affinity_level)
+{
+	if (affinity_level <= 3)
+		return MPIDR_HWID_BITMASK &
+			~((0x1UL << (affinity_level * MPIDR_LEVEL_BITS)) - 1);
+
+	return 0;
+}
 
 int kvm_psci_call(struct kvm_vcpu *vcpu);
 
-- 
2.55.0.rc0.738.g0c8ab3ebcc-goog

