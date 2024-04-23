Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13EFC13BAF6
	for <kvmarm@lists.linux.dev>; Tue, 23 Apr 2024 15:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713884794; cv=none; b=GnDv8iVwhWwelYDsk4ShZIDKLlNg8327/RCE/QlhH5DqIL42dxiCgC5K2nVhHNkiRYEG9e8tw6aZGLQ6NMQM3mEyVMZH3ovMaGZZ18LukPml0dJqalntG0FpkXcfHlGm6LhA9b4R3neRmhpKpz9Zm/cGfwLE5rNWX22tgulmK4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713884794; c=relaxed/simple;
	bh=L67FIsLrYDq3m/AAQI7Q0DrdhNhFyjFPI8yfSe7VkZI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BRd2lf6glYOBUSpnsazcQWE3/WQLsY8dZwlghVBaI95KjZEmLUMgx2L9pTxkXpGTmw4akBlpO1FHmwfa8qV/ywjfDUOW9kVdQm7SrZoQf1O9zqCbN+bhbaWomEreyoeUA5OvaOPEBxXbJEHXS3fDbMvemHBFDIQ1fHKX+PZkqdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4ufYIlZz; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4ufYIlZz"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-417df7b0265so27373235e9.3
        for <kvmarm@lists.linux.dev>; Tue, 23 Apr 2024 08:06:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713884791; x=1714489591; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wDNmFjC7o20jtwaWLvYt53CgdwYHs/yn65M4v44/678=;
        b=4ufYIlZzgFTNNfRcI2HmWk2MpAO0/Vidz5zDuBXdtGlxDG3T8b5uKRsq24NIkzXskU
         SkwYLURAH1PaehEU+qe93GtT+hY/6oaUS3fOxYGXG+JJAk0zTNV6PaBMp590rIwWJD+u
         5GIlWuXNNJG9fYHWIDWaBzW8/iOKZmaQN4u/yoeQsfvAQu4qk5ZEW6PBqcTPVbar3WmN
         JwsPsYbnVBYnz8t+g/L1+s/Vw6k9eOY7F8hxzzC5rQDtLKJUbbyctbZChYMagRoOUffU
         SKdIACY2GkWXKYuJTatf/hxm7LtbQbQv5LCajpnmlYeB4qtS7I6YzJmtPJaRREDH30zx
         24jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713884791; x=1714489591;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wDNmFjC7o20jtwaWLvYt53CgdwYHs/yn65M4v44/678=;
        b=wKvpnd1jXE50INzwENP72N2nU2NH7AWOmRR1TEMnhYxHyv7yt1zww73/39SMR63JI0
         BK1hpg/p0lj0va8QZJuEHHevAocYTgs/KMPbwk5KlWDGoM+e4peCIkcC4EguoRNPxjjT
         NXdkQxDUrZEZ2TYouRDMlQEsK1AyLhiyJHLHjFE41IA3lm+QaWCrEvW6cxl5vDxSLePD
         Qks/jBm15nmUjmSf/XWFVKN9Zf6PmLoMirXF97LTVUNm5ZXQJSXrk9mLj1SnOevRtDKv
         CC/iYOdVVAQdJINYTRrLlvFkbkuKWV/UX6VXz16XTO8DptVxPY1vQeieO+B882wI82p2
         HTGQ==
X-Gm-Message-State: AOJu0YxUSRtPyqKFtQSzdWEhUV6QmVHtrAUatBXk264u3DEOagUcN3ib
	zRhgK7NVMsq45biyqaMfc6sPfRVROnN0NzuBgUyMBGg1V8l2cSyhQL2Sd1Vvsyhd8toujLpM3+j
	PIdH6Rw5kjkPUfBpth+lVMO23diCjZO21m32Q931xAsgfFFgNm1Dpet5c+OX9mOXeY8M0pDhxkx
	ah39Geme9b/5Tgn3EesrxwcsynDPM=
X-Google-Smtp-Source: AGHT+IGwZvT9UOeK/KdeTYk9Oh0PQxSOBWs9IKYorFuKz2aY5SZxYkZxo7LQCSg+0V4ULATC/t1QB/2Azg==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:600c:5102:b0:41a:3485:19c4 with SMTP id
 o2-20020a05600c510200b0041a348519c4mr51712wms.3.1713884791047; Tue, 23 Apr
 2024 08:06:31 -0700 (PDT)
Date: Tue, 23 Apr 2024 16:05:30 +0100
In-Reply-To: <20240423150538.2103045-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240423150538.2103045-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
Message-ID: <20240423150538.2103045-23-tabba@google.com>
Subject: [PATCH v4 22/30] KVM: arm64: Move some kvm_psci functions to a shared header
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

