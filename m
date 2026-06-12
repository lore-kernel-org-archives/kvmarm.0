Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6FC73D75CE
	for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 06:59:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781247578; cv=none; b=i9gkoe6fWiQ4waIJTk+2Gz3xAUZEfI7rXyX33FmMWFgHEPi6oSIKvyzjybgb0ZNSIT/I+zUZi0GY61Jvo3OuaMiMwcqCupRB257o36m1n6soRs0zdS8RJOQ/KyPJ6OabiLK74gAyjfJxNRWnN6v60wSRLaFy9RGGKEPax8JlXBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781247578; c=relaxed/simple;
	bh=Q0Hnrqlxx3zQPWTPMSg7qMZl5yITEayf5Kj/T+48KP0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VADpT/aeBDE24fMktBksnogbICxRJffBH30+97zBlprnOQqmq6PKUb+/b+/FjSWBPMfxs0Sw72hzEKRIZecd3mCHZMjbm5oIlVynvepRm8YLUfecVcNdsob5jJSWp82fbjl2b0QC5Mq2xTse54lhGxQL42O2jO44+w3hSPIgytA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FhwVItu5; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FhwVItu5"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-490b93debc8so5130705e9.1
        for <kvmarm@lists.linux.dev>; Thu, 11 Jun 2026 23:59:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781247574; x=1781852374; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1n7cJGRx/zTufLA+k8QJWETRRdEVZBs0mmRutVAhkNk=;
        b=FhwVItu5G3+uMgWyw0Ls62LRhQ3IJyXzMhxwkDguK1JmnWpPueSxy3bbFlHFA7KOXs
         HcjWtj8ZZuF62tftRI46stbThEUcEeG4jnDE0BIYHuD3amVbA8GYSooqOi8BJC7SDVT2
         RselljqjjTNiO06O7+BLCvGrmX5wmLBZxejsQhaRIyoeJ/yALUXAV/VWSILdjNYyFDNl
         gds3FTFkCjeA4CWVM2qegNQLiNqolkzGBCigjhhwGYNndj5bioYIv3mheGbSpohv4ulC
         XSiqO6Zbg9gBMWnYLW2XHRQjL+sUuLN0VzDCMqYI29A9lIfDAKHtnTvZRd00XsRzQNXc
         ocKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781247574; x=1781852374;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1n7cJGRx/zTufLA+k8QJWETRRdEVZBs0mmRutVAhkNk=;
        b=pLXbi+CU1lXtegCLk/XQSYcbCXPrC9p0n4dkeUFRA9Wy1fzAz/PmTKCeqnPqcHLAX9
         iO0ocjVbe0a0aGBu0ZFyyY9uFK35xzjOOCoBYUBBmGlsVPGPDjkOCojmOL0xQINtb/v3
         5fDqDz5ndiVN35eRID2IpH5EadR0Msk8L1dmXvioRsjHa3XOGvjgCXb9ql5EQc1L/cov
         jmYUW++G1r6+Kw9Bs6LJXw36z0HrbMijhv4abuhkVtAYcgltakQlNvzm9Clf3yjMksJc
         HaB47FGh0ok4qtOaZBpUlu9BqOzPSX4NwkHFi3+qrNqtaBo1TJfc//Xepu/lXGBcfcJr
         Nqzw==
X-Forwarded-Encrypted: i=1; AFNElJ+NJidAPZ2CW+YyUN6XrWpqnUT4QguitvWEDB0GPojk1RaOyuV1eBc6fNZGp/DvexMKSpFSOHA=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx13ZIqvx5d5jztGo03/vMbdHvz6stMH9xneTMUq2Sd6JQoGi79
	ze35vnsZB7QM8clrhzEZSqt+dLhM/enNj8MZo2jjvxf8zsoJCwPBUoQyFLp0dsIdlMNjRx2Qy2s
	6uQ==
X-Received: from wmc19.prod.google.com ([2002:a05:600c:6013:b0:490:bdab:4cf6])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:c107:b0:48e:7854:1608
 with SMTP id 5b1f17b1804b1-490ec508dbfmr16032775e9.25.1781247573832; Thu, 11
 Jun 2026 23:59:33 -0700 (PDT)
Date: Fri, 12 Jun 2026 07:59:21 +0100
In-Reply-To: <20260612065925.755562-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260612065925.755562-1-tabba@google.com>
X-Mailer: git-send-email 2.54.0.1136.gdb2ca164c4-goog
Message-ID: <20260612065925.755562-8-tabba@google.com>
Subject: [PATCH v1 07/11] KVM: arm64: Move PSCI helper functions to a shared header
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

Move kvm_psci_valid_affinity() and kvm_psci_narrow_to_32bit() from
psci.c to include/kvm/arm_psci.h, and move psci_affinity_mask() there
too, renaming it kvm_psci_affinity_mask() now that it is no longer
file-local. A follow-up series handles some protected-guest PSCI calls
at EL2 using these helpers.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/psci.c  | 30 +-----------------------------
 include/kvm/arm_psci.h | 28 ++++++++++++++++++++++++++++
 2 files changed, 29 insertions(+), 29 deletions(-)

diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
index e1389c525e9d..228e5040c379 100644
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
@@ -131,7 +115,7 @@ static unsigned long kvm_psci_vcpu_affinity_info(struct kvm_vcpu *vcpu)
 		return PSCI_RET_INVALID_PARAMS;
 
 	/* Determine target affinity mask */
-	target_affinity_mask = psci_affinity_mask(lowest_affinity_level);
+	target_affinity_mask = kvm_psci_affinity_mask(lowest_affinity_level);
 	if (!target_affinity_mask)
 		return PSCI_RET_INVALID_PARAMS;
 
@@ -215,18 +199,6 @@ static void kvm_psci_system_suspend(struct kvm_vcpu *vcpu)
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
index cbaec804eb83..f12b74a4b176 100644
--- a/include/kvm/arm_psci.h
+++ b/include/kvm/arm_psci.h
@@ -38,6 +38,34 @@ static inline int kvm_psci_version(struct kvm_vcpu *vcpu)
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
2.54.0.1136.gdb2ca164c4-goog

