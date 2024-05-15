Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 419553BBD8
	for <kvmarm@lists.linux.dev>; Wed, 15 May 2024 17:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715793792; cv=none; b=ZwD+9GDHSLWaNf2cmDih0pWzO2aKI0cmgzB5REGnsjiE0rnKkcgyjN63/V/3fQUIcEsZDYcHw43dwe9v1j5Kh0j3t9sfFetpSePozjbSlkceD8A035PrHJ/7Yyg403QrZmWRLx6M2vv9B4f/auPjzZgY8DtdqFZ3vhNc/aIwIOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715793792; c=relaxed/simple;
	bh=QYil/6bNPDyLFlt/IP4iXiqn4VhW5HCAEKor3jRfRXs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lSCNSFODAix8lrSgv+FMmAYa9q8zPTCEB+Y9jGjU3mNFI9DozQwxXlnCcwVSJlEVf+0KsCRMXPJWql1R7Qv5tLRhXczbEe4EHmUuBRhx96u4/pxSGEoGE4ZebIVgIGu6pZgw7c1Ck4DommiY1fE0p/L1s9vrLsn6r2y2iqEAdFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Kb9DQScg; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Kb9DQScg"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-61be325413eso90100047b3.1
        for <kvmarm@lists.linux.dev>; Wed, 15 May 2024 10:23:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715793790; x=1716398590; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=WQNv0L9f8Ur9QycJthQG4bmvCcJmqN/f24s1YQ7H6/M=;
        b=Kb9DQScgR4OIoy+2vCEaY5P5SVbkGgQiTFN14gVbpMGz7PG0isRIquCNkGNFSGan8t
         TQ+4rRB2wrMEMcockD9wdCV+7joG7uWDFmj4/9XaywVEu/KHttaxDyR5HlnVtHKDEPSo
         IUyC7qSF/AuNqUOK/9fBhnj9gEnPsqzmf8iOshsjPRpJNpkaqPFfdsPN9wQjZBJWm8sV
         nW6wuPJZcbh0zg3Qca77Hoi+hu/wV38pYzQ+dOTkX1uxIBgi6JFsZsLtvSgCEtMAjuM0
         gS4Ia7tAmw5djJI/swfRgSkmHiJwsdNvegkzT3tiC7d0Tt4aA3H5EEpc7OX60cDoZ2Ha
         tq1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715793790; x=1716398590;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WQNv0L9f8Ur9QycJthQG4bmvCcJmqN/f24s1YQ7H6/M=;
        b=w3PY40c2ObfCGeq9If/OX702wOdA7JAL2BEZHxwpO4vkJkgcr4L3i9GDfGRVrvJw/3
         qz4HFz5m1eNI7fPhg664LfdgjONfsnOj8/SS43hl0rE/bLALZmNFQa7p4JPcu2Awyici
         cnQ7XgdKjMTdYMj0nDbWFDAZc6uAuAMWDzwu1pE6Uu6f9JV4e2GDUxTyaabaK1v2+20v
         5gnE9zEMLMePbNXyhyi5ZsWHTi4sehDWuzHLerZEBLbFKDNqGmIs7HIScKzYqIEGt3RD
         VGQjwMhzlE6C4b/P46FMoEkmAtU7raiXw6w57xd0jPeQd0oRSTuSYldV2S9pwv6M2Bs7
         n60Q==
X-Gm-Message-State: AOJu0YySmlu9acJu8KbTn/joCsS3mm7DDBoFGaLS+hEZvz/aCwrOPoHS
	H9yOyVVEwvoFnxqycNYDl54phSi7yP2DXaWvM1IPWJk4WVcM/jpGucuQANrsg7/mHVFHBRfAzuu
	rZRegadEosrLjx7Eul4rXRtlj8g==
X-Google-Smtp-Source: AGHT+IFWj0CPWZNjkZCa8D6KDWXhJ9Flvad+9yi5Xs81Nbt0wNqI/d2+oXKWmpATfuUhMILUHaW60rmoGvWSagTvTps=
X-Received: from sebkvm.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:cd5])
 (user=sebastianene job=sendgmr) by 2002:a05:690c:6904:b0:611:6f24:62b1 with
 SMTP id 00721157ae682-622af7a98aamr44278057b3.1.1715793790276; Wed, 15 May
 2024 10:23:10 -0700 (PDT)
Date: Wed, 15 May 2024 17:22:55 +0000
In-Reply-To: <20240515172258.1680881-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240515172258.1680881-1-sebastianene@google.com>
X-Mailer: git-send-email 2.45.0.rc1.225.g2a3ae87e7f-goog
Message-ID: <20240515172258.1680881-2-sebastianene@google.com>
Subject: [PATCH v2 1/4] KVM: arm64: Trap FFA_VERSION host call in pKVM
From: Sebastian Ene <sebastianene@google.com>
To: catalin.marinas@arm.com, james.morse@arm.com, jean-philippe@linaro.org, 
	maz@kernel.org, oliver.upton@linux.dev, qperret@google.com, 
	qwandor@google.com, sudeep.holla@arm.com, suzuki.poulose@arm.com, 
	tabba@google.com, will@kernel.org, yuzenghui@huawei.com, 
	lpieralisi@kernel.org
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kernel-team@android.com, 
	Sebastian Ene <sebastianene@google.com>
Content-Type: text/plain; charset="UTF-8"

The pKVM hypervisor initializes with FF-A version 1.0. The spec requires
that no other FF-A calls to be issued before the version negotiation
phase is complete. Split the hypervisor proxy initialization code in two
parts so that we can move the later one after the host negotiates its
version.
Without trapping the call, the host drivers can negotiate a higher
version number with TEE which can result in a different memory layout
described during the memory sharing calls.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 123 +++++++++++++++++++++++++---------
 1 file changed, 92 insertions(+), 31 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index 320f2eaa14a9..72f1206c85fb 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -1,4 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-only
+//
 /*
  * FF-A v1.0 proxy to filter out invalid memory-sharing SMC calls issued by
  * the host. FF-A is a slightly more palatable abbreviation of "Arm Firmware
@@ -67,6 +68,9 @@ struct kvm_ffa_buffers {
  */
 static struct kvm_ffa_buffers hyp_buffers;
 static struct kvm_ffa_buffers host_buffers;
+static u32 hyp_ffa_version;
+static bool has_version_negotiated;
+static hyp_spinlock_t version_lock;
 
 static void ffa_to_smccc_error(struct arm_smccc_res *res, u64 ffa_errno)
 {
@@ -640,6 +644,83 @@ static bool do_ffa_features(struct arm_smccc_res *res,
 	return true;
 }
 
+static int hyp_ffa_post_init(void)
+{
+	size_t min_rxtx_sz;
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_smc(FFA_ID_GET, 0, 0, 0, 0, 0, 0, 0, &res);
+	if (res.a0 != FFA_SUCCESS)
+		return -EOPNOTSUPP;
+
+	if (res.a2 != HOST_FFA_ID)
+		return -EINVAL;
+
+	arm_smccc_1_1_smc(FFA_FEATURES, FFA_FN64_RXTX_MAP,
+			  0, 0, 0, 0, 0, 0, &res);
+	if (res.a0 != FFA_SUCCESS)
+		return -EOPNOTSUPP;
+
+	switch (res.a2) {
+	case FFA_FEAT_RXTX_MIN_SZ_4K:
+		min_rxtx_sz = SZ_4K;
+		break;
+	case FFA_FEAT_RXTX_MIN_SZ_16K:
+		min_rxtx_sz = SZ_16K;
+		break;
+	case FFA_FEAT_RXTX_MIN_SZ_64K:
+		min_rxtx_sz = SZ_64K;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	if (min_rxtx_sz > PAGE_SIZE)
+		return -EOPNOTSUPP;
+
+	return 0;
+}
+
+static void do_ffa_version(struct arm_smccc_res *res,
+			   struct kvm_cpu_context *ctxt)
+{
+	DECLARE_REG(u32, ffa_req_version, ctxt, 1);
+
+	if (FFA_MAJOR_VERSION(ffa_req_version) != 1) {
+		res->a0 = FFA_RET_NOT_SUPPORTED;
+		return;
+	}
+
+	hyp_spin_lock(&version_lock);
+	if (has_version_negotiated) {
+		res->a0 = hyp_ffa_version;
+		goto unlock;
+	}
+
+	/*
+	 * If the client driver tries to downgrade the version, we need to ask
+	 * first if TEE supports it.
+	 */
+	if (FFA_MINOR_VERSION(ffa_req_version) < FFA_MINOR_VERSION(hyp_ffa_version)) {
+		arm_smccc_1_1_smc(FFA_VERSION, ffa_req_version, 0,
+				  0, 0, 0, 0, 0,
+				  res);
+		if (res->a0 == FFA_RET_NOT_SUPPORTED)
+			goto unlock;
+
+		hyp_ffa_version = ffa_req_version;
+	}
+
+	if (hyp_ffa_post_init())
+		res->a0 = FFA_RET_NOT_SUPPORTED;
+	else {
+		has_version_negotiated = true;
+		res->a0 = hyp_ffa_version;
+	}
+unlock:
+	hyp_spin_unlock(&version_lock);
+}
+
 bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
 {
 	struct arm_smccc_res res;
@@ -660,6 +741,11 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
 	if (!is_ffa_call(func_id))
 		return false;
 
+	if (!has_version_negotiated && func_id != FFA_VERSION) {
+		ffa_to_smccc_error(&res, FFA_RET_INVALID_PARAMETERS);
+		goto out_handled;
+	}
+
 	switch (func_id) {
 	case FFA_FEATURES:
 		if (!do_ffa_features(&res, host_ctxt))
@@ -686,6 +772,9 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
 	case FFA_MEM_FRAG_TX:
 		do_ffa_mem_frag_tx(&res, host_ctxt);
 		goto out_handled;
+	case FFA_VERSION:
+		do_ffa_version(&res, host_ctxt);
+		goto out_handled;
 	}
 
 	if (ffa_call_supported(func_id))
@@ -700,7 +789,6 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
 int hyp_ffa_init(void *pages)
 {
 	struct arm_smccc_res res;
-	size_t min_rxtx_sz;
 	void *tx, *rx;
 
 	if (kvm_host_psci_config.smccc_version < ARM_SMCCC_VERSION_1_2)
@@ -726,35 +814,7 @@ int hyp_ffa_init(void *pages)
 	if (FFA_MAJOR_VERSION(res.a0) != 1)
 		return -EOPNOTSUPP;
 
-	arm_smccc_1_1_smc(FFA_ID_GET, 0, 0, 0, 0, 0, 0, 0, &res);
-	if (res.a0 != FFA_SUCCESS)
-		return -EOPNOTSUPP;
-
-	if (res.a2 != HOST_FFA_ID)
-		return -EINVAL;
-
-	arm_smccc_1_1_smc(FFA_FEATURES, FFA_FN64_RXTX_MAP,
-			  0, 0, 0, 0, 0, 0, &res);
-	if (res.a0 != FFA_SUCCESS)
-		return -EOPNOTSUPP;
-
-	switch (res.a2) {
-	case FFA_FEAT_RXTX_MIN_SZ_4K:
-		min_rxtx_sz = SZ_4K;
-		break;
-	case FFA_FEAT_RXTX_MIN_SZ_16K:
-		min_rxtx_sz = SZ_16K;
-		break;
-	case FFA_FEAT_RXTX_MIN_SZ_64K:
-		min_rxtx_sz = SZ_64K;
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	if (min_rxtx_sz > PAGE_SIZE)
-		return -EOPNOTSUPP;
-
+	hyp_ffa_version = FFA_VERSION_1_0;
 	tx = pages;
 	pages += KVM_FFA_MBOX_NR_PAGES * PAGE_SIZE;
 	rx = pages;
@@ -773,8 +833,9 @@ int hyp_ffa_init(void *pages)
 	};
 
 	host_buffers = (struct kvm_ffa_buffers) {
-		.lock	= __HYP_SPIN_LOCK_UNLOCKED,
+		.lock   = __HYP_SPIN_LOCK_UNLOCKED,
 	};
 
+	version_lock = __HYP_SPIN_LOCK_UNLOCKED;
 	return 0;
 }
-- 
2.45.0.rc1.225.g2a3ae87e7f-goog

