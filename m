Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DB5A22C32D
	for <kvmarm@lists.linux.dev>; Thu, 27 Feb 2025 18:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740680285; cv=none; b=iLSc5Txz5x2FEmAlOyfxKfsIw/J3LguRlST7+yboJyTfODNhkxqmXYz7n/ZocRPpLZjN7DXe9yEadIiI5tFm7/6N+T/7GoqBFlUAy0y/VqFplb9kSwRjPmymndYkX5P3ooB6/W+SNSzLUeDbwHisuyRcZDjuIVaTkBgdcy/MKqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740680285; c=relaxed/simple;
	bh=Ep7gH/oCf+sk9jHJM97qe5HKmg83XTq7tAH6ZdSDw0Y=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZB8S/uIqzt+cHKm5V6OnmJ9te7KECakWOD7FwTrbcn1oalRPwCh5AzE9sem34CoVwjOZ49OD+c6/g+GQ/JtijTwo/NVQ0Lsn9VE6NgAU/02KUfc+Do5WW5RaKF6E7rQ5XhbwD1k7zNWhgPD6Uy2A6suflJ3BeHOQxsah6DLmpbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oJqJlh3B; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oJqJlh3B"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-390e5214efdso641661f8f.1
        for <kvmarm@lists.linux.dev>; Thu, 27 Feb 2025 10:18:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740680280; x=1741285080; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hce1wCI+iJiN9AXNLgcvauNehWwU2rw17tT7g22I8ig=;
        b=oJqJlh3B0t98WzHs5XTFiA4V9D0Tlcv+mH69pSgcvusS76HRGRJpuR9Pf+X+XU4k8a
         zPSfDWL3WYN8aM4ti+o6j1BE4bEmPpWCcyxuJDBq36KKXQ8hVws+HWnO6pggvCJbaQoN
         jBqNXxPFWU0ezXi9aT8h02dyQPBB0j/0lS+j5Q3GtjrjXvHFe0GM6K3/4m2n5fN1m7kp
         FSiSB+6zmVLiXw+iMo4qKt5oCHzVKMVLZ4GW870RG3r0R0nhiZ0SaWCbUFjBIdXHvd0l
         4Vn45trdFJzRudGEaMBM2avzONl+d3lMNOnsh6PW9yglRoRR/wHRmKujKGBF5U5RDk38
         ES9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740680280; x=1741285080;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hce1wCI+iJiN9AXNLgcvauNehWwU2rw17tT7g22I8ig=;
        b=jzMiH1txF+Net3fV4hrc6PJg1UI1cMrva+rpb6UcZLbdPUrcT9+uSymVrdveYW+YXt
         62nSlzjyjFpI7l7RQsNJYLFVHFKRvt0bh9XvpSqar1CqRhk8LXh6yrT3KnZIWXN0glKu
         TqtMWCeFQs+U/6p4cFZpfpgR70ickS5qOHXqVP1uAZAlHMTVgRc7Ekd4sNcnNAb6636F
         kIv45o0Kzn9Hzxss+GgDRORfWKOO1U0Y6Pwl1gCGBpk6XjDxFmRAM/EwpiFiRIC0xdsA
         JH4DmWWTyN8FC5VcP2vER4ONr/g5a1YzlVBajEaPKv0A26LYOw3X53EHr1C773w319Tv
         dOww==
X-Gm-Message-State: AOJu0YydluH2pBEK6dNMsE2VK2os9g+FVWicfaSKJOBOkCECdEbizWr7
	v1ykSLHl2JHQsOWkqF+6eWgAJKhoZfh7yRl3/1VEWXavE1K2MRajKKC75vkE8GSTghecT9pRSkd
	q5sLM09iI55OrbPIWOefyRk1biw==
X-Google-Smtp-Source: AGHT+IFKf38sjXhANJwnxVv0t8bQO3XXUn605hIGPZLim6GWv0LFywIR25WQ1XrK1YmlUszpJyRh8MP2vxl9ngqoV7c=
X-Received: from wrbgz3.prod.google.com ([2002:a05:6000:4803:b0:38f:4458:9c7c])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:2108:b0:38f:2289:90f1 with SMTP id ffacd0b85a97d-390ec7d20a4mr172276f8f.29.1740680280768;
 Thu, 27 Feb 2025 10:18:00 -0800 (PST)
Date: Thu, 27 Feb 2025 18:17:48 +0000
In-Reply-To: <20250227181750.3606372-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250227181750.3606372-1-sebastianene@google.com>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250227181750.3606372-4-sebastianene@google.com>
Subject: [PATCH v2 3/4] KVM: arm64: Map the hypervisor FF-A buffers on ffa init
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
never be called.
Prevent the host from using FF-A directly with Trustzone
if the hypervisor could not map its own buffers.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 46 +++++++++++++----------------------
 1 file changed, 17 insertions(+), 29 deletions(-)

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
-- 
2.48.1.711.g2feabab25a-goog

