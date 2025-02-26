Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF9AC25EFA9
	for <kvmarm@lists.linux.dev>; Wed, 26 Feb 2025 21:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740606545; cv=none; b=hoL/LwLVJak6k0Ei3tnWJtom1Vn/3/yndszOscI75+3nOB8uRfPBydq34sxEOcVW2S63y/xflK/S42r6Vi4P5VKrrGX2HRdLDJIDNmKjOlIHN0RZwzu1d8Y/1tG/HfUNDyarR+/Cbu7Q2APPvyE64Wvbm7g9Aw3z3xsLi/oRrDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740606545; c=relaxed/simple;
	bh=AJ0aL67MNMHWLCnIV5QRMRwoPhcRZaFh4TPbk9b014Y=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GRk/Al1Crz6f8vDnLWIgT0PJWhP/SiIa4Gey2w6x/mzSk2efBij5HJKNnTK2sV0cqbj5TEHejt5xcMywXgBM0yC0v0s5NA6PCIj5IlUPfL6/RVPuMcDXCHR5gCxv7mvuK4Lo2wUWeTiNifsB4SDcB4FfRBkBJvie9pJWHxsY378=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Wf2Aq1te; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Wf2Aq1te"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-38f455a8e43so74076f8f.0
        for <kvmarm@lists.linux.dev>; Wed, 26 Feb 2025 13:49:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740606542; x=1741211342; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nn7NkfdNisHNgNHd+oe9siIm1ilJ5hL+n/oLHca/4xQ=;
        b=Wf2Aq1te1bB/fKAxBabdX8dD4wmfxt4h+z5FMHLnRJ5xGShNn0C29B/jmy5G1eWhHT
         szpF8f4bFIzAzlnHD5QTUKIy6B2S/0fwp2fEm3ethDCpxn5fLyL7RWAkW7rooLSKEdZx
         m0pgaAqi+NFJoUouKoUOKand8BE87bJ89Lr7va/SEWRgdFfngqy+WcrQ4N7NO2afFIsZ
         8/OTs0f3wriBp2UdmdckL397acrNfuBpWG6cRybyjEE/OIXespFjQycAmszaCv2K/RX9
         7EO9aC0gHBJJYZTTfN+kDl1UK5qMC3wTGrk5T0MY+ZnwasYtrMFw1RwHjCCTGrfp/aM4
         C8hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740606542; x=1741211342;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nn7NkfdNisHNgNHd+oe9siIm1ilJ5hL+n/oLHca/4xQ=;
        b=GJUDv+hfLkL7iDcUsj3HnT8XJJOr+FAcqcenfPTCIplIEcZBn5m1h0zJTYQv4Bz/GZ
         qQjdyo1HjAGx4V60p8jypKk0CiMOrVZgayLLSOWomGrhTow0x//m+b0YOUUbS0XI+JV8
         hHkX1uFuy+jgE8MtvYe41WG8+oZI5Sbb+HPO6IuKS25BA7hWSV1WIW76DIaB6/PisSiz
         hXpou1pnBlFxIQTRLSFQQZrivtxQhWnHTirvaO9wV+ucoweIVMonWr8LQ2C2RFoS+ayx
         qPiX1ToQA42IKdQYuv7BWsOrf8bpopFF47dNTpybECV6ZMq7kC4ffjw+Yz9BJ7DYk459
         A+Pw==
X-Gm-Message-State: AOJu0YzKV4KCI1qsHrdN2eYXReuL+iWUs8Swf4sAmd899vPv/KTtWhdp
	LEoEQqnwnyz7i9G99Ryd0E7GC1pm+1PCsL/uRWrvm83qFIj+/xY4yXeoK2QJeHfLmVDVmjH7fIB
	BiIWG64P+9CQr46xtzJ840aD4pQ==
X-Google-Smtp-Source: AGHT+IHCoOc2i86YMCnuvttEGcDUZYoM+8yWhiEKuZWCun/eyz4ldBIl5B6mMe4Xqk2ObldseXeE2fv9uBC+67uQ47I=
X-Received: from wmbgw7.prod.google.com ([2002:a05:600c:8507:b0:439:4293:c575])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3111:b0:439:9f42:c137 with SMTP id 5b1f17b1804b1-43ab0f31010mr85525335e9.11.1740606542287;
 Wed, 26 Feb 2025 13:49:02 -0800 (PST)
Date: Wed, 26 Feb 2025 21:48:52 +0000
In-Reply-To: <20250226214853.3267057-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250226214853.3267057-1-sebastianene@google.com>
X-Mailer: git-send-email 2.48.1.658.g4767266eb4-goog
Message-ID: <20250226214853.3267057-3-sebastianene@google.com>
Subject: [PATCH 2/3] KVM: arm64: Map the hypervisor FF-A buffers on ffa init
From: Sebastian Ene <sebastianene@google.com>
To: catalin.marinas@arm.com, joey.gouly@arm.com, maz@kernel.org, 
	oliver.upton@linux.dev, sebastianene@google.com, snehalreddy@google.com, 
	sudeep.holla@arm.com, suzuki.poulose@arm.com, vdonnefort@google.com, 
	will@kernel.org, yuzenghui@huawei.com
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kernel-team@android.com
Content-Type: text/plain; charset="UTF-8"

Map the hypervisor's buffers irrespective to the host and return
a linux error code from the FF-A error code on failure. Remove
the unmap ff-a buffers calls from the hypervisor as it will
never be called and move the definition of the
ffa_to_linux_error map in the header where it should belong to.
Prevent the host from using FF-A if the hypervisor could not
map its own buffers with Trustzone.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c     | 46 ++++++++++++-------------------
 drivers/firmware/arm_ffa/driver.c | 24 ----------------
 include/linux/arm_ffa.h           | 24 ++++++++++++++++
 3 files changed, 41 insertions(+), 53 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index 6df6131f1107..861f24de97cb 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -69,6 +69,7 @@ static struct kvm_ffa_buffers hyp_buffers;
 static struct kvm_ffa_buffers host_buffers;
 static u32 hyp_ffa_version;
 static bool has_version_negotiated;
+static bool has_ffa_supported;
 static DEFINE_HYP_SPINLOCK(version_lock);
 
 static void ffa_to_smccc_error(struct arm_smccc_res *res, u64 ffa_errno)
@@ -111,30 +112,18 @@ static bool is_ffa_call(u64 func_id)
 	       ARM_SMCCC_FUNC_NUM(func_id) <= FFA_MAX_FUNC_NUM;
 }
 
-static int ffa_map_hyp_buffers(u64 ffa_page_count)
+static int ffa_map_hyp_buffers(void)
 {
 	struct arm_smccc_res res;
 
 	arm_smccc_1_1_smc(FFA_FN64_RXTX_MAP,
 			  hyp_virt_to_phys(hyp_buffers.tx),
 			  hyp_virt_to_phys(hyp_buffers.rx),
-			  ffa_page_count,
+			  KVM_FFA_MBOX_NR_PAGES,
 			  0, 0, 0, 0,
 			  &res);
 
-	return res.a0 == FFA_SUCCESS ? FFA_RET_SUCCESS : res.a2;
-}
-
-static int ffa_unmap_hyp_buffers(void)
-{
-	struct arm_smccc_res res;
-
-	arm_smccc_1_1_smc(FFA_RXTX_UNMAP,
-			  HOST_FFA_ID,
-			  0, 0, 0, 0, 0, 0,
-			  &res);
-
-	return res.a0 == FFA_SUCCESS ? FFA_RET_SUCCESS : res.a2;
+	return res.a0 == FFA_SUCCESS ? 0 : ffa_to_linux_errno(res.a2);
 }
 
 static void ffa_mem_frag_tx(struct arm_smccc_res *res, u32 handle_lo,
@@ -213,18 +202,10 @@ static void do_ffa_rxtx_map(struct arm_smccc_res *res,
 		goto out_unlock;
 	}
 
-	/*
-	 * Map our hypervisor buffers into the SPMD before mapping and
-	 * pinning the host buffers in our own address space.
-	 */
-	ret = ffa_map_hyp_buffers(npages);
-	if (ret)
-		goto out_unlock;
-
 	ret = __pkvm_host_share_hyp(hyp_phys_to_pfn(tx));
 	if (ret) {
 		ret = FFA_RET_INVALID_PARAMETERS;
-		goto err_unmap;
+		goto out_unlock;
 	}
 
 	ret = __pkvm_host_share_hyp(hyp_phys_to_pfn(rx));
@@ -262,8 +243,6 @@ static void do_ffa_rxtx_map(struct arm_smccc_res *res,
 	__pkvm_host_unshare_hyp(hyp_phys_to_pfn(rx));
 err_unshare_tx:
 	__pkvm_host_unshare_hyp(hyp_phys_to_pfn(tx));
-err_unmap:
-	ffa_unmap_hyp_buffers();
 	goto out_unlock;
 }
 
@@ -291,9 +270,6 @@ static void do_ffa_rxtx_unmap(struct arm_smccc_res *res,
 	hyp_unpin_shared_mem(host_buffers.rx, host_buffers.rx + 1);
 	WARN_ON(__pkvm_host_unshare_hyp(hyp_virt_to_pfn(host_buffers.rx)));
 	host_buffers.rx = NULL;
-
-	ffa_unmap_hyp_buffers();
-
 out_unlock:
 	hyp_spin_unlock(&host_buffers.lock);
 out:
@@ -809,6 +785,11 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
 	if (!is_ffa_call(func_id))
 		return false;
 
+	if (!has_ffa_supported) {
+		ffa_to_smccc_error(&res, FFA_RET_NOT_SUPPORTED);
+		goto out_handled;
+	}
+
 	if (!has_version_negotiated && func_id != FFA_VERSION) {
 		ffa_to_smccc_error(&res, FFA_RET_INVALID_PARAMETERS);
 		goto out_handled;
@@ -861,6 +842,7 @@ int hyp_ffa_init(void *pages)
 {
 	struct arm_smccc_res res;
 	void *tx, *rx;
+	int ret;
 
 	if (kvm_host_psci_config.smccc_version < ARM_SMCCC_VERSION_1_2)
 		return 0;
@@ -911,5 +893,11 @@ int hyp_ffa_init(void *pages)
 		.lock	= __HYP_SPIN_LOCK_UNLOCKED,
 	};
 
+	/* Map our hypervisor buffers into the SPMD */
+	ret = ffa_map_hyp_buffers();
+	if (ret)
+		return ret;
+
+	has_ffa_supported = true;
 	return 0;
 }
diff --git a/drivers/firmware/arm_ffa/driver.c b/drivers/firmware/arm_ffa/driver.c
index 2c2ec3c35f15..b02b80f3dfe8 100644
--- a/drivers/firmware/arm_ffa/driver.c
+++ b/drivers/firmware/arm_ffa/driver.c
@@ -61,30 +61,6 @@
 
 static ffa_fn *invoke_ffa_fn;
 
-static const int ffa_linux_errmap[] = {
-	/* better than switch case as long as return value is continuous */
-	0,		/* FFA_RET_SUCCESS */
-	-EOPNOTSUPP,	/* FFA_RET_NOT_SUPPORTED */
-	-EINVAL,	/* FFA_RET_INVALID_PARAMETERS */
-	-ENOMEM,	/* FFA_RET_NO_MEMORY */
-	-EBUSY,		/* FFA_RET_BUSY */
-	-EINTR,		/* FFA_RET_INTERRUPTED */
-	-EACCES,	/* FFA_RET_DENIED */
-	-EAGAIN,	/* FFA_RET_RETRY */
-	-ECANCELED,	/* FFA_RET_ABORTED */
-	-ENODATA,	/* FFA_RET_NO_DATA */
-	-EAGAIN,	/* FFA_RET_NOT_READY */
-};
-
-static inline int ffa_to_linux_errno(int errno)
-{
-	int err_idx = -errno;
-
-	if (err_idx >= 0 && err_idx < ARRAY_SIZE(ffa_linux_errmap))
-		return ffa_linux_errmap[err_idx];
-	return -EINVAL;
-}
-
 struct ffa_pcpu_irq {
 	struct ffa_drv_info *info;
 };
diff --git a/include/linux/arm_ffa.h b/include/linux/arm_ffa.h
index 74169dd0f659..850577edadbc 100644
--- a/include/linux/arm_ffa.h
+++ b/include/linux/arm_ffa.h
@@ -475,4 +475,28 @@ struct ffa_ops {
 	const struct ffa_notifier_ops *notifier_ops;
 };
 
+static const int ffa_linux_errmap[] = {
+	/* better than switch case as long as return value is continuous */
+	0,		/* FFA_RET_SUCCESS */
+	-EOPNOTSUPP,	/* FFA_RET_NOT_SUPPORTED */
+	-EINVAL,	/* FFA_RET_INVALID_PARAMETERS */
+	-ENOMEM,	/* FFA_RET_NO_MEMORY */
+	-EBUSY,		/* FFA_RET_BUSY */
+	-EINTR,		/* FFA_RET_INTERRUPTED */
+	-EACCES,	/* FFA_RET_DENIED */
+	-EAGAIN,	/* FFA_RET_RETRY */
+	-ECANCELED,	/* FFA_RET_ABORTED */
+	-ENODATA,	/* FFA_RET_NO_DATA */
+	-EAGAIN,	/* FFA_RET_NOT_READY */
+};
+
+static inline int ffa_to_linux_errno(int errno)
+{
+	int err_idx = -errno;
+
+	if (err_idx >= 0 && err_idx < ARRAY_SIZE(ffa_linux_errmap))
+		return ffa_linux_errmap[err_idx];
+	return -EINVAL;
+}
+
 #endif /* _LINUX_ARM_FFA_H */
-- 
2.48.1.658.g4767266eb4-goog

