Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 679A714430D
	for <kvmarm@lists.linux.dev>; Thu, 13 Jun 2024 13:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718284858; cv=none; b=d6Gywn2DzgHaEzjHLTZo5mPbpXcc7S0pcpXE2I9Ue9P2KFCrYzMfA2xt1RJIn2ZJ8TnsvGDymhzbnsFv3K7G4fD1fzRqkZHV9iphaautaT62xf3JEE1jerH6I0ji+VHZCSiwcJpLvcr4vI67rXSB5b17Yfgu4HFZCeLttSARbzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718284858; c=relaxed/simple;
	bh=idFXAPcpVQmcGmiIJZdKfaTJHLacQJPR7UwwsA0QvKg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=P4rpLBE/ZsgsyRU2dVSDCwMf62kafg3P/67nxoiQIj2s+DDETPYN8dPNghg6DT7Lsl02MF/K50HKkphKH27jlpSFjBZXXYhTj1EFXtOyHB9eCWtgNSFgJvm9Jl3ef9EjfYoeHEyqQ6q5dcsVzp8GBWZoTanIB8C7i7M5zDGZCQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=b6wsnuhZ; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="b6wsnuhZ"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-35f06558bc3so703856f8f.1
        for <kvmarm@lists.linux.dev>; Thu, 13 Jun 2024 06:20:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718284855; x=1718889655; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=sESXJ6lTpXS1Uiyd1DMUTJSwf8gpaqDrOmX2O7P+Tt8=;
        b=b6wsnuhZKwl6BmJ+Jmb0QN8j6p2SeiCSrLzM7q8eBSBFzuDkIvWbJ77HUaDf5KvSJv
         rAVZCaOImH2CnaqHH72hrQ+JTuP7GMtSj3BczFQaOQgm6x4OF5TmHaS6bRYy5qX8wV+y
         ShbCjfu/f4w0PArrXpCCJCBTpYo3SQ+utZlnJJ7yxx7EtizLg+r1gnBiQdWf2D62CYkS
         R4am6iVUeHKV2+zP5AB7soCm2lOULRAOEO2eH7aBmzgprEwdfIhThBsD/VLGsulrxxqh
         YmnBPzxc93m7qWRjJw5BqVhYFCvIMggQPz8jnCOLKFm/zQKpOU30ua606+cZ5oEQdd9j
         g3ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718284855; x=1718889655;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sESXJ6lTpXS1Uiyd1DMUTJSwf8gpaqDrOmX2O7P+Tt8=;
        b=T4vOrCF1yumaet25X4kJIyUn6yKsE46lNLuRS5sJdpn+bhDcKMsmFDlS2X2euxI2JI
         FSXCErvGxqbp5ztyY2wZHPGKqUnoZeAq1JqIhWB84uCsiGPrG9XbmrX39KZgdPHZHu1K
         vQe6i1txeOlk53LqpeoLTe7Ni4YshuL3nugBN++zZa7Qk3PWnhoPwz5qngsGaYgmyqh0
         k2AKfmmz3RiP73FPFXfXcyvNIOLhYOR/l5BKvSxpeauYsJy4+krS6/RMLSrMS0LsItsV
         HpfHJsIm+Ij7DkgRRmliDom0J6ZQW6/enZUZErLj64+67igH9z0Di8uTVQJmu/l1RADu
         0HkQ==
X-Gm-Message-State: AOJu0YxeVuEiC/NeKxHM+/uyq6rmjNY4DYBPINbIdqYEVXfGXkwF41Y5
	UpfjRgJoRmEPselW8wkNZO/WjjJjykMUrhSzOW0KUbR6wk6i7JSDucYVAmU/3xE51Iyl9uWoDo5
	jop+7smtcpfT3P8T3LNjOunVAoA==
X-Google-Smtp-Source: AGHT+IEuL/StGDQdidgafs+3ZU4qfQosVRrlPI2JL8IIcAF+ju+qgsK/HapKvJnwS4cSax/FEowSz1v2ebxWWLTYgbE=
X-Received: from sebkvm.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:cd5])
 (user=sebastianene job=sendgmr) by 2002:a5d:6405:0:b0:35f:2e9c:3295 with SMTP
 id ffacd0b85a97d-35fdf7aad26mr10867f8f.4.1718284854455; Thu, 13 Jun 2024
 06:20:54 -0700 (PDT)
Date: Thu, 13 Jun 2024 13:20:32 +0000
In-Reply-To: <20240613132035.1070360-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240613132035.1070360-1-sebastianene@google.com>
X-Mailer: git-send-email 2.45.2.505.gda0bf45e8d-goog
Message-ID: <20240613132035.1070360-2-sebastianene@google.com>
Subject: [PATCH v3 1/4] KVM: arm64: Trap FFA_VERSION host call in pKVM
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
Reviewed-by: Sudeep Holla <sudeep.holla@arm.com>
Tested-by: Sudeep Holla <sudeep.holla@arm.com>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 120 +++++++++++++++++++++++++---------
 1 file changed, 90 insertions(+), 30 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index 02746f9d0980..c8ab51c331f0 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -67,6 +67,9 @@ struct kvm_ffa_buffers {
  */
 static struct kvm_ffa_buffers hyp_buffers;
 static struct kvm_ffa_buffers host_buffers;
+static u32 hyp_ffa_version;
+static bool has_version_negotiated;
+static hyp_spinlock_t version_lock;
 
 static void ffa_to_smccc_error(struct arm_smccc_res *res, u64 ffa_errno)
 {
@@ -639,6 +642,83 @@ static bool do_ffa_features(struct arm_smccc_res *res,
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
@@ -659,6 +739,11 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
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
@@ -685,6 +770,9 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
 	case FFA_MEM_FRAG_TX:
 		do_ffa_mem_frag_tx(&res, host_ctxt);
 		goto out_handled;
+	case FFA_VERSION:
+		do_ffa_version(&res, host_ctxt);
+		goto out_handled;
 	}
 
 	if (ffa_call_supported(func_id))
@@ -699,7 +787,6 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
 int hyp_ffa_init(void *pages)
 {
 	struct arm_smccc_res res;
-	size_t min_rxtx_sz;
 	void *tx, *rx;
 
 	if (kvm_host_psci_config.smccc_version < ARM_SMCCC_VERSION_1_2)
@@ -725,35 +812,7 @@ int hyp_ffa_init(void *pages)
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
@@ -775,5 +834,6 @@ int hyp_ffa_init(void *pages)
 		.lock	= __HYP_SPIN_LOCK_UNLOCKED,
 	};
 
+	version_lock = __HYP_SPIN_LOCK_UNLOCKED;
 	return 0;
 }
-- 
2.45.2.505.gda0bf45e8d-goog

