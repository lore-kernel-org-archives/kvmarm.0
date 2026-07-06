Received: from mail-lj1-f202.google.com (mail-lj1-f202.google.com [209.85.208.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 732FD233926
	for <kvmarm@lists.linux.dev>; Mon,  6 Jul 2026 17:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783360478; cv=none; b=QGtLacRvcgeTPBBvEdio6KJoPDSR31hbsCabJqOZrJarv+iuuNbNwhCYEy78Pg61p1Qs0BGBIboOyOBTaeT0PGwP01p/XHtTOvK+tXPRSN9oJhJZ3g7gNjGr/AsF3Z+E6IKnK5PRQixwEVWVBFqsd6rPt7AOGPtkqKp9K7y0534=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783360478; c=relaxed/simple;
	bh=c3WwG+LoSZ7U8T+hj/S1PanLnOiJAf1D9L8bqg8aGJk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=UqP1CYZeKwNHh6RxlglmceA5bD6naz2vzhenx8aOlbeem94bJ/Q4pjQjyx742jgnXas/kuAZN8HnrPOmZdnXUDDZIpCm1t+1vFvUJ5tIMdh1Y/weFySZbdxc3DpFrbOaw+EPYtyZd1dZ1PZL17IjEkIs6CuSkvXV8Qbrt7D0teE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TceXWifi; arc=none smtp.client-ip=209.85.208.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TceXWifi"
Received: by mail-lj1-f202.google.com with SMTP id 38308e7fff4ca-39b217f842eso477841fa.0
        for <kvmarm@lists.linux.dev>; Mon, 06 Jul 2026 10:54:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783360473; x=1783965273; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6NlFq+eT7KLqzVcBU//MeA//nrJwyvekgJ7IugWGqxY=;
        b=TceXWifizlZew0MWHOrB0a14k4hIODnWFqJ9P+aKeRi11jCVETyslah+DkOv1Q6Dg8
         gNzLdW7omMn83CNYSx67mq11yjmtxJ7BXFMgJHjtHjURnNnawAWsJno1fCkIpcMtqAUz
         sw3zsdRjeBm/d9T6pL2jweQ75MUFRillPZ70sl71LMnOaS63iiCOOzLrN9QoWlpUGk7d
         ngMBeIqyIRUFxcYDUQ2yznnk/5np6t+FKps81i5QS5Juf643IaWkTGn8S+AsLpDvGk9+
         uk8EVUCKNXbJzN5iFwFTPl1WYK82L5J3GGbtv0nhmXWTtsLfNODWG8YeqRU5rqEVzfSf
         A9yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783360473; x=1783965273;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6NlFq+eT7KLqzVcBU//MeA//nrJwyvekgJ7IugWGqxY=;
        b=DP/D2kwlwy4rlVtW8vDlcLW9lD10gkxrEXWD64tsr0KguByKhAmgjpQV7PtGrE6VwQ
         CcwKwrs5xQ36TchpeiOyhLCnR3ngyQmEhMEUfTqMJWfpOPmGGl750z9F4VBxj5ruCYuN
         2MUvlFmbIOjEkSzxC1NT84Qixx5A1ONdHoG/YFQZTeabebf/vMWkUL3IB/UQ7DyatYTm
         WKPShSzJRuVFYFidLYVRZONx6vvbKlLLVGqkpb/CsJe19MxdToXDugznIcKx5f0MqIN4
         8GSYMOmS/U68S2EEV3G3NmZ2W+xQPb/IPy2rXI0yVCobvRSMMFpzdwDIWsDEDlNQoVBc
         I8hA==
X-Forwarded-Encrypted: i=1; AHgh+RrROo6Gf6A7roRQ56Kl/mRNJhFDWc6kTrdefvVAvRegM2Sw93/B3/9360UQzuQ4h39RPIZA9So=@lists.linux.dev
X-Gm-Message-State: AOJu0YyKV5v9AAWZahQSeDMtn7oh0cX6b/HK5wiyCIUNVH2ZlfPeWCWu
	8LQq/dqdTcjLMy+U5gslqJvb4ryjj7vuog1CdMthLB5n6EMXZsZKhWMk1Ynz5APy7s8B719rCtC
	mAY2Qv++gkrQPmm2EEnYmvw==
X-Received: from ljvi25-n2.prod.google.com ([2002:a05:651c:4399:20b0:39b:50cf:4a26])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:651c:19a6:b0:396:8cb0:d264 with SMTP id 38308e7fff4ca-39c5ffc60b7mr4083991fa.8.1783360473127;
 Mon, 06 Jul 2026 10:54:33 -0700 (PDT)
Date: Mon,  6 Jul 2026 18:54:07 +0100
In-Reply-To: <20260706175415.2604046-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260706175415.2604046-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.rc2.803.g1fd1e6609c-goog
Message-ID: <20260706175415.2604046-11-vdonnefort@google.com>
Subject: [PATCH v2 10/18] KVM: arm64: Add selftests for the pKVM heap allocator
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kernel-team@android.com, qperret@google.com, tabba@google.com, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Introduce a comprehensive runtime selftest for the pKVM hypervisor heap
allocator, executed during init when CONFIG_NVHE_EL2_DEBUG is enabled.

The selftest runs entirely at EL2 and exercises allocator's core
mechanisms:

  * over-sized allocations
  * basic allocation and alignment
  * chunk recycling, splitting, merging
  * memory reclaiming
  * memory topup

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index b427ef790b15..07a46860c8b2 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -117,6 +117,7 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___pkvm_hyp_topup,
 	__KVM_HOST_SMCCC_FUNC___pkvm_hyp_reclaim,
 	__KVM_HOST_SMCCC_FUNC___pkvm_hyp_reclaimable,
+	__KVM_HOST_SMCCC_FUNC___pkvm_hyp_alloc_selftest,
 
 	MARKER(__KVM_HOST_SMCCC_FUNC_MAX)
 };
diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
index 3a8590d1793e..5837c2d7928a 100644
--- a/arch/arm64/include/asm/kvm_pkvm.h
+++ b/arch/arm64/include/asm/kvm_pkvm.h
@@ -19,6 +19,7 @@
 
 enum pkvm_topup_id {
 	PKVM_TOPUP_HYP_ALLOC,
+	PKVM_TOPUP_HYP_ALLOC_SELFTEST,
 };
 
 unsigned long pkvm_hyp_reclaim(enum pkvm_topup_id id, unsigned long target);
@@ -209,6 +210,7 @@ struct pkvm_mapping {
 enum pkvm_hyp_req_type {
 	PKVM_HYP_NO_REQ = 0,
 	PKVM_HYP_REQ_HYP_ALLOC,
+	PKVM_HYP_REQ_HYP_ALLOC_SELFTEST,
 	__PKVM_HYP_REQ_TYPE_MAX,
 };
 
@@ -236,6 +238,7 @@ static inline size_t pkvm_hyp_req_arg_size(u8 type)
 	case PKVM_HYP_NO_REQ:
 		return 0;
 	case PKVM_HYP_REQ_HYP_ALLOC:
+	case PKVM_HYP_REQ_HYP_ALLOC_SELFTEST:
 		return sizeof(req->mem);
 	default:
 		WARN_ON(1);
diff --git a/arch/arm64/kvm/hyp/include/nvhe/alloc.h b/arch/arm64/kvm/hyp/include/nvhe/alloc.h
index 8f87a63f8946..329250dad6f6 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/alloc.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/alloc.h
@@ -14,4 +14,11 @@ int hyp_alloc_init(size_t size);
 int hyp_alloc_topup(struct kvm_hyp_memcache *host_mc);
 unsigned long hyp_alloc_reclaimable(void);
 void hyp_alloc_reclaim(struct kvm_hyp_memcache *host_mc, unsigned long target);
+
+#ifdef CONFIG_NVHE_EL2_DEBUG
+int hyp_allocator_selftest(void);
+u32 hyp_alloc_selftest_topup_needed(void);
+int hyp_alloc_selftest_topup(struct kvm_hyp_memcache *host_mc);
+void hyp_alloc_selftest_reclaim(struct kvm_hyp_memcache *host_mc, unsigned long target);
+#endif
 #endif
diff --git a/arch/arm64/kvm/hyp/nvhe/alloc.c b/arch/arm64/kvm/hyp/nvhe/alloc.c
index 07ef0a13855f..e7114dde9142 100644
--- a/arch/arm64/kvm/hyp/nvhe/alloc.c
+++ b/arch/arm64/kvm/hyp/nvhe/alloc.c
@@ -1007,9 +1007,17 @@ int hyp_alloc_errno(void)
 	return hyp_allocator_errno(&hyp_allocator);
 }
 
+static int selftest_init(void);
+
 int hyp_alloc_init(size_t size)
 {
-	return hyp_allocator_init(&hyp_allocator, size);
+	int ret;
+
+	ret = hyp_allocator_init(&hyp_allocator, size);
+	if (ret)
+		return ret;
+
+	return selftest_init();
 }
 
 void hyp_alloc_reclaim(struct kvm_hyp_memcache *mc, unsigned long target)
@@ -1031,3 +1039,179 @@ u32 hyp_alloc_topup_needed(void)
 {
 	return hyp_allocator_topup_needed(&hyp_allocator);
 }
+
+#ifdef CONFIG_NVHE_EL2_DEBUG
+#define SELFTEST_MAX_PAGES 6
+#define SELFTEST_MAX_SIZE (PAGE_SIZE * SELFTEST_MAX_PAGES)
+
+static DEFINE_PER_CPU(int, __selftest_errno);
+static DEFINE_PER_CPU(u32, __selftest_topup_needed);
+
+static struct hyp_allocator selftest_allocator = {
+	.errno = &__selftest_errno,
+	.topup_needed = &__selftest_topup_needed,
+	.lock = __HYP_SPIN_LOCK_UNLOCKED,
+};
+
+int hyp_alloc_selftest_topup(struct kvm_hyp_memcache *host_mc)
+{
+	return hyp_allocator_topup(&selftest_allocator, host_mc);
+}
+
+void hyp_alloc_selftest_reclaim(struct kvm_hyp_memcache *host_mc, unsigned long target)
+{
+	hyp_allocator_reclaim(&selftest_allocator, host_mc, target);
+}
+
+u32 hyp_alloc_selftest_topup_needed(void)
+{
+	return hyp_allocator_topup_needed(&selftest_allocator);
+}
+
+static int selftest_init(void)
+{
+	return hyp_allocator_init(&selftest_allocator, SELFTEST_MAX_SIZE);
+}
+
+static void *selftest_alloc(size_t size)
+{
+	return hyp_allocator_alloc(&selftest_allocator, size);
+}
+
+static void selftest_free(void *addr)
+{
+	hyp_allocator_free(&selftest_allocator, addr);
+}
+
+static int selftest_errno(void)
+{
+	return hyp_allocator_errno(&selftest_allocator);
+}
+
+int hyp_allocator_selftest(void)
+{
+	struct hyp_allocator *allocator = &selftest_allocator;
+	static DEFINE_HYP_SPINLOCK(selftest_lock);
+	struct kvm_hyp_memcache host_mc = { };
+	void *addr1, *addr2, *addr3, *addr4;
+	int ret;
+
+	guard(hyp_spinlock)(&selftest_lock);
+
+	if (allocator->mc.nr_pages < SELFTEST_MAX_PAGES) {
+		*this_cpu_ptr(allocator->topup_needed) = SELFTEST_MAX_PAGES -
+							 allocator->mc.nr_pages;
+		return -ENOMEM;
+	}
+
+	selftest_alloc(SELFTEST_MAX_SIZE);
+	if (selftest_errno() != -E2BIG)
+		return -EINVAL;
+
+	selftest_alloc(SIZE_MAX);
+	if (selftest_errno() != -E2BIG)
+		return -EINVAL;
+
+	/* Test first chunk */
+	addr1 = selftest_alloc(0);
+	if (!addr1 || addr1 != (void *)allocator->start + chunk_hdr_size())
+		return -EINVAL;
+
+	/* Test second contiguous chunk with unaligned size */
+	addr2 = selftest_alloc(MIN_ALLOC_SIZE + 1);
+	if (!addr2)
+		return -EINVAL;
+	addr3 = selftest_alloc(0);
+	if (!addr3 ||
+	    addr3 != addr2 + (2 * MIN_ALLOC_SIZE) + chunk_hdr_size())
+		return -EINVAL;
+
+	selftest_free(addr3);
+
+	/* Test chunk recycling */
+	selftest_free(addr1);
+	if (addr1 != selftest_alloc(0))
+		return -EINVAL;
+
+	/* Test chunk forward merging */
+	addr3 = selftest_alloc(0);
+	selftest_free(addr2);
+	selftest_free(addr1);
+	if (addr1 != selftest_alloc(MIN_ALLOC_SIZE * 2))
+		return -EINVAL;
+
+	selftest_free(addr1);
+
+	/* Test chunk splitting */
+	if (addr1 != selftest_alloc(0))
+		return -EINVAL;
+	if (addr2 != selftest_alloc(0))
+		return -EINVAL;
+
+	/* Test chunk backward merging */
+	selftest_free(addr1);
+	selftest_free(addr2);
+	if (addr1 != selftest_alloc(MIN_ALLOC_SIZE * 2))
+		return -EINVAL;
+
+	selftest_free(addr1);
+
+	/* Test chunk 3-way merging */
+	addr1 = selftest_alloc(0);
+	addr2 = selftest_alloc(0);
+	addr4 = selftest_alloc(0);
+	selftest_free(addr1);
+	selftest_free(addr3);
+	selftest_free(addr2);
+	if (addr1 != selftest_alloc(MIN_ALLOC_SIZE * 3))
+		return -EINVAL;
+
+	selftest_free(addr4);
+	selftest_free(addr1);
+
+	/* Test reclaiming */
+	if (addr1 != selftest_alloc(0))
+		return -EINVAL;
+	if (addr2 != selftest_alloc(PAGE_SIZE * 2))
+		return -EINVAL;
+	addr3 = selftest_alloc(0);
+	addr4 = selftest_alloc(PAGE_SIZE);
+
+	/* Test reclaiming the last chunk of the list */
+	selftest_free(addr4);
+	hyp_allocator_reclaim(allocator, &host_mc, SELFTEST_MAX_PAGES);
+	if (host_mc.nr_pages != SELFTEST_MAX_PAGES - 3)
+		return -EINVAL;
+
+	/* Test punching a hole in the middle of a free chunk ... */
+	selftest_free(addr2);
+	hyp_allocator_reclaim(allocator, &host_mc, SELFTEST_MAX_PAGES);
+	if (host_mc.nr_pages != SELFTEST_MAX_PAGES - 2)
+		return -EINVAL;
+
+	if (selftest_alloc(PAGE_SIZE))
+		return -EINVAL;
+	if (selftest_errno() != -ENOMEM)
+		return -EINVAL;
+
+	/* ... and to refill this hole */
+	ret = hyp_allocator_topup(allocator, &host_mc);
+	if (ret)
+		return ret;
+	/* Chunk at addr2 was made smaller by the reclaim */
+	if (addr2 != selftest_alloc(PAGE_SIZE))
+		return -EINVAL;
+
+	/* Test reclaiming the entire allocator from the host */
+	selftest_free(addr3);
+	selftest_free(addr2);
+	selftest_free(addr1);
+	if (addr1 != selftest_alloc(SELFTEST_MAX_PAGES * PAGE_SIZE - chunk_hdr_size()))
+		return -EINVAL;
+	selftest_free(addr1);
+
+	return 0;
+}
+#else
+static int selftest_init(void) { return 0; }
+#endif
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 8fbebe64a93d..105313bb3dd9 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -633,6 +633,28 @@ static void handle___pkvm_finalize_teardown_vm(struct kvm_cpu_context *host_ctxt
 	cpu_reg(host_ctxt, 1) = __pkvm_finalize_teardown_vm(handle);
 }
 
+#ifdef CONFIG_NVHE_EL2_DEBUG
+static void handle___pkvm_hyp_alloc_selftest(struct kvm_cpu_context *host_ctxt)
+{
+	struct pkvm_hyp_req req = { .type = PKVM_HYP_NO_REQ };
+	int ret;
+
+	ret = hyp_allocator_selftest();
+	if (ret == -ENOMEM) {
+		req.type = PKVM_HYP_REQ_HYP_ALLOC_SELFTEST;
+		req.mem.nr_pages = hyp_alloc_selftest_topup_needed();
+	}
+
+	cpu_reg(host_ctxt, 1) = ret;
+	pkvm_hyp_req_to_smccc(host_ctxt, &req);
+}
+#else
+static void handle___pkvm_hyp_alloc_selftest(struct kvm_cpu_context *host_ctxt)
+{
+	cpu_reg(host_ctxt, 1) = -EPERM;
+}
+#endif
+
 static void handle___pkvm_hyp_topup(struct kvm_cpu_context *host_ctxt)
 {
 	DECLARE_REG(enum pkvm_topup_id, id, host_ctxt, 1);
@@ -648,6 +670,11 @@ static void handle___pkvm_hyp_topup(struct kvm_cpu_context *host_ctxt)
 	case PKVM_TOPUP_HYP_ALLOC:
 		ret = hyp_alloc_topup(&host_mc);
 		break;
+#ifdef CONFIG_NVHE_EL2_DEBUG
+	case PKVM_TOPUP_HYP_ALLOC_SELFTEST:
+		ret = hyp_alloc_selftest_topup(&host_mc);
+		break;
+#endif
 	default:
 		ret = -EINVAL;
 	}
@@ -668,6 +695,11 @@ static void handle___pkvm_hyp_reclaim(struct kvm_cpu_context *host_ctxt)
 	case PKVM_TOPUP_HYP_ALLOC:
 		hyp_alloc_reclaim(&host_mc, target);
 		break;
+#ifdef CONFIG_NVHE_EL2_DEBUG
+	case PKVM_TOPUP_HYP_ALLOC_SELFTEST:
+		hyp_alloc_selftest_reclaim(&host_mc, target);
+		break;
+#endif
 	default:
 		ret = -EINVAL;
 	}
@@ -826,6 +858,7 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__pkvm_hyp_topup),
 	HANDLE_FUNC(__pkvm_hyp_reclaim),
 	HANDLE_FUNC(__pkvm_hyp_reclaimable),
+	HANDLE_FUNC(__pkvm_hyp_alloc_selftest),
 };
 
 static void handle_host_hcall(struct kvm_cpu_context *host_ctxt)
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index eb4c60a0db5a..f7e1846d6093 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -137,6 +137,7 @@ unsigned long pkvm_hyp_reclaimable(enum pkvm_topup_id id)
 {
 	return kvm_call_hyp_nvhe(__pkvm_hyp_reclaimable, id);
 }
+
 static void __pkvm_destroy_hyp_vm(struct kvm *kvm)
 {
 	if (pkvm_hyp_vm_is_created(kvm)) {
@@ -325,6 +326,22 @@ static int __init pkvm_drop_host_privileges(void)
 	return ret;
 }
 
+static void __init pkvm_selftests(void)
+{
+#ifdef CONFIG_NVHE_EL2_DEBUG
+	int ret = pkvm_call_hyp_req(__pkvm_hyp_alloc_selftest);
+	unsigned long reclaimed;
+
+	reclaimed = pkvm_hyp_reclaim(PKVM_TOPUP_HYP_ALLOC_SELFTEST, ULONG_MAX);
+
+	/* On failure, not all the pages may be reclaimable */
+	if (!ret)
+		WARN_ON(reclaimed != 6 /* SELFTEST_MAX_PAGES */);
+	else
+		kvm_err("pKVM hyp allocator selftest failed (%d)\n", ret);
+#endif
+}
+
 static int __init finalize_pkvm(void)
 {
 	int ret;
@@ -345,6 +362,9 @@ static int __init finalize_pkvm(void)
 	if (ret)
 		pr_err("Failed to finalize Hyp protection: %d\n", ret);
 
+	if (!ret)
+		pkvm_selftests();
+
 	return ret;
 }
 device_initcall_sync(finalize_pkvm);
@@ -651,6 +671,9 @@ static int pkvm_handle_hyp_req(struct pkvm_hyp_req *req)
 	case PKVM_HYP_REQ_HYP_ALLOC:
 		ret = pkvm_hyp_topup(PKVM_TOPUP_HYP_ALLOC, req->mem.nr_pages);
 		break;
+	case PKVM_HYP_REQ_HYP_ALLOC_SELFTEST:
+		ret = pkvm_hyp_topup(PKVM_TOPUP_HYP_ALLOC_SELFTEST, req->mem.nr_pages);
+		break;
 	}
 
 	trace_kvm_handle_pkvm_hyp_req(req, ret);
-- 
2.55.0.rc2.803.g1fd1e6609c-goog

