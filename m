Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9B743E485
	for <kvmarm@lists.linux.dev>; Fri, 19 Apr 2024 08:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713513637; cv=none; b=Ub+oireN4MrPbUEIcM5rfjHKGdYu5MPxNq4gZChiuB3/miyFuhFdlONcL5Rb0m4DU51agqpNa+09SjhQzONcdzi540kK5Bs7810AjPPcFjfyfogcpeTmYg3GLXkXt+RXppFQdZnDjIJgLQozM1H5aJI+wkC8+dhsmNNPDWC6omY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713513637; c=relaxed/simple;
	bh=L67FIsLrYDq3m/AAQI7Q0DrdhNhFyjFPI8yfSe7VkZI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Fgs4PzoaNOLdGdUBqb5+flCuI0szOZBxILWfsN+vkMUvXfkpGij7TtKMl/8Z9JriXpYIH6mW6CRy5om9CkKWVCn+kMdhpX7ID83Xo0KHeTlL6Rdscs+G4xbNnN6VYhWYBJDOyCsYKWJLGfufodH+v4GMGEKe9n5McqSPX/xqTYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LljmcXEY; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LljmcXEY"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-347f92ab882so1074941f8f.0
        for <kvmarm@lists.linux.dev>; Fri, 19 Apr 2024 01:00:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713513634; x=1714118434; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wDNmFjC7o20jtwaWLvYt53CgdwYHs/yn65M4v44/678=;
        b=LljmcXEYcmbP31NZTMI9HfaK5KZhUegKTRD0mY0pr6e3KwwJXC0y1LdYpLg5YuEQ2X
         ttdJtHAded205SQm8IBqwPQuiI40ZYOnhCjLHvnfDFd3uNC823ZrBT2SoIIvlhJlD71a
         55645dqsNr37LyCnZQeVyYpvKPksM/yl1hFx1bZJ9xppMsK5KXVZHFMPYhK6M3WYeTdZ
         DVq5ozvH8ypiRMmIv1WBZxpKugbDl7yNczGxGt8VuTPOG1uQfSsGGQ0+Fm6UJWmiPsK9
         Sn2MXBL7vNFOFzAGp0zhDP6fy3/mSH80JFpNKysFK3ARwDtLBVzVzTuN1qFfeG/HBgJr
         Kggw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713513634; x=1714118434;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wDNmFjC7o20jtwaWLvYt53CgdwYHs/yn65M4v44/678=;
        b=F1KhztOMdY9d8rN/5i7o5VlSF64x7+MUn1AApB8mza1Aqhyp7/g3mj6savFgxxBaWc
         ISDsDzjNsOwOgBXvRNkmQZQ8L3R3wPdLAnBJVNXfhA5kSg9yig/ILpNX6c+DgNgktDaD
         2oC7XsSR+Mpg2bjDYk94pP/poAz1plUoOlT1Z1wnrvLkCEXlyrRRFH7znoYC39nJyg2u
         q8fhOQaFDfhzCjTOSVXNmmmgx1mHaAmTqPhzKTPCOEVnfw1S0muY6mv8pMxv/J5XcTLc
         OzAVcEnv8Sxhh44aQU0q1NJ9hJYF0xAY91pt+wYL7mONCKRmM0oBy96YE9jXICPJqNfl
         klAw==
X-Gm-Message-State: AOJu0Yw17Rv3OW1yxM9i363x+/AasWrQv5zLJ+r9jiRGRmJFiOVK498k
	ujVerAG8KxiRBeQReXIN622nfeaAfQA43mm40D/Su/9vfrWfJc9Wlp4wahY0+oTR7w+5YdPmQY3
	bN71E8XtgaYm+rvUxRBe14LP4pGrV2knMjz+1grEqhmUNdtImQM3ewlAKuVw0Rwtt4Car/OoBky
	546GibyLpzc1jLGESApHP3u7xRXxg=
X-Google-Smtp-Source: AGHT+IH3Y1RToscx8dh3nmatdOu4rCxOPLxUj+yKHVBay1MGCTedV/VM8G3+y8W/mwBlsPMNRrc/AqOVdA==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:adf:e792:0:b0:343:4337:41e8 with SMTP id
 n18-20020adfe792000000b00343433741e8mr3645wrm.9.1713513633983; Fri, 19 Apr
 2024 01:00:33 -0700 (PDT)
Date: Fri, 19 Apr 2024 08:59:32 +0100
In-Reply-To: <20240419075941.4085061-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240419075941.4085061-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
Message-ID: <20240419075941.4085061-23-tabba@google.com>
Subject: [PATCH v3 22/31] KVM: arm64: Move some kvm_psci functions to a shared header
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
2.44.0.769.g3c40516874-goog

