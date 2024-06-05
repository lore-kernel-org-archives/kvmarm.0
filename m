Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFD724D5A0
	for <kvmarm@lists.linux.dev>; Wed,  5 Jun 2024 15:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717599797; cv=none; b=M4pGqgn0XUfWDTvxVvrKSDbEBWKkVCG4GkhAS076IYuwKq+LtEaz5tak6jbxO2bzcmT8wd+sWDTYw/1CQSFOl2HHs2x6ReBLbt7Y5KcCvBEux3+dXU9/VtHeA3ULQdaA2IOKEo6g5dUuA9+azDWo8VBQ1/wyJt39w7Uxl2n4ed0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717599797; c=relaxed/simple;
	bh=By/T1N0/Ew6fg9IKZko7zNTUNtWD94qCzZxXw5XDSc4=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=Usy2hZEf5LqT8jTRL1qt/VUxCid6psNizZ6BSNj+gu6nIDn0Pu/+8SzNT3cxJ9aQnFm/GNSVvHEGJfnG1xTAHCtN+aDCGa7O/X7zRBiXzxjAjRIyL7s+H4pbtqq1lQ81veLACA2zLRFfi3sEP21anuZs6Rojh+CFKHGadWS2Tus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xpV6LBhQ; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xpV6LBhQ"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-62a1e9807c0so14062137b3.0
        for <kvmarm@lists.linux.dev>; Wed, 05 Jun 2024 08:03:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717599795; x=1718204595; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=KO8MH7UmY8zG+vK98T7XFrbBCxXrZgBjolcXAlPlLF8=;
        b=xpV6LBhQRIS/FDFrpC/Sv/2ihu/kYZVEjFTyqLpR8+zWqPRuVoEeS5ZLI9ogMJjaIm
         4ebZ3dlxeAAXcUttxjuZ9pe3sxwvdCupN6bTFLqg5cYkbg/y8Abk0J3eEqH78yOrR5xY
         sWaEnIQUbKht2ZaTlWfZ5YGAYfuXqFaaeppdu0vejTnUCj6mME90Vvh1o502Txtuydnw
         03HXxbzdZz1onbxwdjbfvSmq/LAQhxrU7Z++HLkt3rDhvZrjUOxzTFA4xun793LJpYF+
         gs7AuLPvX3U5Pwe3PIhksDtmLLiFqwxHqW7DKJdLJfwhBRLNtZ54OJ0WcH5vjrSyQ/eH
         SGoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717599795; x=1718204595;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KO8MH7UmY8zG+vK98T7XFrbBCxXrZgBjolcXAlPlLF8=;
        b=YzfR65z8ROcSEJCEY5wsTsTZ4ozVZcAv2jhX+5cAMZl9xf1oO/N0QvQnL98bDJQrY8
         EO5CzAFs/j+FrHYOX2K7R3gJHLQo6WzVDifJfxsizjaHuTwtFbg0v7XKrWoLfFLSdFH8
         YzanwOwfUO4wABEOVKhHpj3vbPTJ8KF0EDo3evyjHGd+YXDaM0mRGrwpHfM0g7Oz9I0h
         N09PesMrXAGnSY/ya3xydMyLZolQNMkypnZypSyy+rkkmf0J3KAQCI6uGYWnzUFMVYN5
         eeAQsw7sp1YHcwd/j8PW1m+7jRsHJtBFoedKBj89/nsjGuMN6YQqbIMaL8PUDHlnR7NI
         TAQA==
X-Gm-Message-State: AOJu0YyZsGZDd4BGtyerHbnKwKBIYnb6dWwx9ftAm/0XcBdlAczu5B+T
	iRVU1x78CCJl5NFncBEfGIHiXnNCKoZckvjvj7ahXmbtRXn390D26fjg725ZPLyS+ij6e4753FV
	tVQ60i9mkYmsfFJbZ89YypfchwosdIs2we/DCBZjgzSV5lfVxy5dR8kcWYtjJH3Jhu6zZxs9och
	jyFms0rnhtA1hZLmHpgDCXyqui5Ik=
X-Google-Smtp-Source: AGHT+IEeAnaR9jSQ+V4+n4UfVSqeVpPLwX2KsXZ2qD/bj5ehSaei1CPViNnfLN7SLX4G8piQoeN2J14URQ==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:690c:10c:b0:618:5009:cb71 with SMTP id
 00721157ae682-62cba685399mr8509867b3.5.1717599794733; Wed, 05 Jun 2024
 08:03:14 -0700 (PDT)
Date: Wed,  5 Jun 2024 16:03:12 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.45.2.505.gda0bf45e8d-goog
Message-ID: <20240605150312.3684150-1-tabba@google.com>
Subject: [PATCH v1] KVM: arm64: Allocate for maximum vector length for pKVM
 host sve state
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com, yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"

In a heterogeneous system, a cpu could have an sve/sme vector
length that is larger than the rest. Store the value of the
largest possible vector length in the system. When allocating
memory for the host sve state in pKVM, allocate for the largest
possible sve vector length.

Fixes: 66d5b53e20a6 ("KVM: arm64: Allocate memory mapped at hyp for host sve state in pKVM")
Reported-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
Based on kvmarm/fixes (afb91f5f8ad7)

Mark Brown submitted a patch series that fixes this [1].
I'm sending this patch since it might be simpler.

[1] https://lore.kernel.org/all/20240605-kvm-arm64-fix-pkvm-sve-vl-v1-0-680d6b43b4c1@kernel.org/
---
 arch/arm64/include/asm/fpsimd.h | 13 +++++++++++++
 arch/arm64/kernel/fpsimd.c      |  7 ++++++-
 arch/arm64/kvm/reset.c          |  2 +-
 3 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/fpsimd.h
index bc69ac368d73..a72dda932291 100644
--- a/arch/arm64/include/asm/fpsimd.h
+++ b/arch/arm64/include/asm/fpsimd.h
@@ -184,6 +184,9 @@ struct vl_info {
 	int max_vl;
 	int max_virtualisable_vl;
 
+	/* The maximum vl encountered for any cpu in the system. */
+	int max_system_vl;
+
 	/*
 	 * Set of available vector lengths,
 	 * where length vq encoded as bit __vq_to_bit(vq):
@@ -274,6 +277,11 @@ static inline int vec_max_virtualisable_vl(enum vec_type type)
 	return vl_info[type].max_virtualisable_vl;
 }
 
+static inline int vec_max_system_vl(enum vec_type type)
+{
+	return vl_info[type].max_system_vl;
+}
+
 static inline int sve_max_vl(void)
 {
 	return vec_max_vl(ARM64_VEC_SVE);
@@ -284,6 +292,11 @@ static inline int sve_max_virtualisable_vl(void)
 	return vec_max_virtualisable_vl(ARM64_VEC_SVE);
 }
 
+static inline int sve_max_system_vl(void)
+{
+	return vec_max_system_vl(ARM64_VEC_SVE);
+}
+
 /* Ensure vq >= SVE_VQ_MIN && vq <= SVE_VQ_MAX before calling this function */
 static inline bool vq_available(enum vec_type type, unsigned int vq)
 {
diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index 82e8a6017382..e0af4c3c9a40 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -1006,7 +1006,7 @@ int sme_get_current_vl(void)
 static void vec_probe_vqs(struct vl_info *info,
 			  DECLARE_BITMAP(map, SVE_VQ_MAX))
 {
-	unsigned int vq, vl;
+	unsigned int vq, vl, max_vl = 0;
 
 	bitmap_zero(map, SVE_VQ_MAX);
 
@@ -1031,7 +1031,12 @@ static void vec_probe_vqs(struct vl_info *info,
 
 		vq = sve_vq_from_vl(vl); /* skip intervening lengths */
 		set_bit(__vq_to_bit(vq), map);
+
+		if (!max_vl)
+			max_vl = vl;
 	}
+
+	info->max_system_vl = max((int) max_vl, info->max_system_vl);
 }
 
 /*
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 3fc8ca164dbe..6236f9d0a0ec 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -52,7 +52,7 @@ int __init kvm_arm_init_sve(void)
 {
 	if (system_supports_sve()) {
 		kvm_sve_max_vl = sve_max_virtualisable_vl();
-		kvm_host_sve_max_vl = sve_max_vl();
+		kvm_host_sve_max_vl = sve_max_system_vl();
 		kvm_nvhe_sym(kvm_host_sve_max_vl) = kvm_host_sve_max_vl;
 
 		/*

base-commit: afb91f5f8ad7af172d993a34fde1947892408f53
-- 
2.45.2.505.gda0bf45e8d-goog

