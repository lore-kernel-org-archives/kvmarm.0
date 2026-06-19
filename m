Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4729A33507D
	for <kvmarm@lists.linux.dev>; Fri, 19 Jun 2026 07:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781852848; cv=none; b=tgpQnaC4+SodQztsX14H+fmEFVoy4qZ6HCirOUM418sIUnpjoDlZj+K931u0E+D1R6XRiyi+raOZpsIHtcLWKZUOJl9z1nG98IoZc6NTMWvimkTAgP3QcOH5Kr0PEmnT/nUnD7xZo16CM7CkIuI/MdITx8uJBs2KlAHtlVmCJUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781852848; c=relaxed/simple;
	bh=9JDMmHjB8wIpJAXXialivP1h3vqF/BPRvofAJksL8RU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jHGAm2Aq0+Osuotw87+v2LGo6ogZyJnjBy/27Vo2mXXyUOuay4/Omc3ARh+xmOz60eRkPSiJ5t4Mse/Zop93H4tKlCz+H5bcVvn+QJZjegarTYuHEAgqX+Vhttn7Pd+MTZtamajEpVCL/HhvPqbpCtjBC8WMRjNrWypicTowBUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hV6GTbqx; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hV6GTbqx"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-4629f312a67so1821932f8f.2
        for <kvmarm@lists.linux.dev>; Fri, 19 Jun 2026 00:07:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781852846; x=1782457646; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=S1QUYcee151+QuSJM7wM7vpmF/sftjcL7x2ymejauNs=;
        b=hV6GTbqx/wa5Y/Iq//6+78bdlj1oSd8Gf3GXJZUSqu89p5gEPGQVCaUnmLyLZw796P
         SdrxcNV07ZeKhlAm7h2/cuCUDt64byonFVtJeQY+/y7h8xqLCa+ShsYiuL1OwQ2Qd+6d
         u2pPosMp+BW/yKG+MK4JTBPsvLtm+xDJjFnGBRgb+2V9KWyEA30rfYduR8sCHH6JtEWE
         CKTywIl0XLY67YNYtzjILNk9O6dGJGCWxEHqyTCWg1NTrumWSvoCszoUBK2kmfv+IZXY
         3XxQ/i8K3E/9YMY3epp6B7XHFHfOf8h6wcqhN+Wk5KuKmhr6xanF7ZcLsDpjArlE+5mp
         Uh0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781852846; x=1782457646;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=S1QUYcee151+QuSJM7wM7vpmF/sftjcL7x2ymejauNs=;
        b=lPJD+gUGVFw547a+tF1gW59L4HyiEuSuZ6tlkiiKtWdE8NcPbCs34lWtryIF6WEA1N
         F2SK2pLrU24IeNVjUavGnGEfhTCbNACHmSpYFBP9jUuQj97Hr6ZTA9wDmLf0jEN1MmVu
         jiq7VkwOktUIkkg7mvDaV/l3hIwmQfpE2D8XzgGroWDS0OFIqNjOBG8m8K+1ZKWC6atH
         WlD8nZFuMnxh4lTrvfPCdqgb5hB6BTPnVzvl0kp5hyuhY6fl1GbZNBR8q1Q34WlUwLiK
         sDt0cgixq7aBJCG9t05inQGs2Vp542td6B9ryw6HUlkPSvSYqG8C3I6W/pQrrP55C4tV
         17AA==
X-Forwarded-Encrypted: i=1; AFNElJ/yu8b/pVyYkYR63orw5+TeAsquUtOzICPKc0pHceIMRwfjdT1A6JoAHeODCDnZgNkVfNRjBOE=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxb2nyBtmMzzWUdSULGs69JbOKi+oOpmlEa8BhetGANgXzkVit0
	FdJW1Nwl1K+zMEksdcJG3ym4hBhwl0wkhbylJOw+Fy8Ap8FIgpq1bXQsnAFJp3jgHp4PmZAgwtJ
	V/A==
X-Received: from wrmd14.prod.google.com ([2002:adf:e88e:0:b0:44b:7bd5:1b9f])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:adf:e891:0:b0:45e:ea68:523b
 with SMTP id ffacd0b85a97d-465004395ccmr3242226f8f.10.1781852845441; Fri, 19
 Jun 2026 00:07:25 -0700 (PDT)
Date: Fri, 19 Jun 2026 08:07:15 +0100
In-Reply-To: <20260619070719.812227-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260619070719.812227-1-tabba@google.com>
X-Mailer: git-send-email 2.55.0.rc0.738.g0c8ab3ebcc-goog
Message-ID: <20260619070719.812227-5-tabba@google.com>
Subject: [PATCH v2 4/8] KVM: arm64: Move PSCI helper functions to a shared header
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

