Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com [209.85.208.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BC5C4CCDD4
	for <kvmarm@lists.linux.dev>; Tue,  1 Sep 2026 08:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788250203; cv=none; b=oXcElhe1DzDVOiZSvfWfxhWj6JpJ3DKkIDlA+GQRJgUflGyvoKYxGnwK/GCgClGshGEwn/YvSP+5B14snHE6uMD3NHnruRes5J3XQfkksio6EySz49zgFiVWFOvsjw+IfPphlpUZ3WdzhnGae4lf8g6r8yTP3zrzOaDg7QNAvb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788250203; c=relaxed/simple;
	bh=tuQ0BolzeI4vF5zbpF7GGvEK8whfsRhjVltVE8pvAvg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Q4X0xTY9Gp0wJDxOijzdiMmnkvLVIV91Kjs5l3DgNcsnprHVqWhH5OKzqkpKtkHXtRraPIGZbdPJ5hGtMke3UBesr5K05O/N6Eq+aIShFz2mnStZ/tInaOhwWaTVPY/Vm7B2iGXyK8pVwLBdxAgO3NM+7s68Cs7zsziolqr8jAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EJPczPoJ; arc=none smtp.client-ip=209.85.208.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EJPczPoJ"
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-6a615ab0d2bso4283543a12.0
        for <kvmarm@lists.linux.dev>; Tue, 01 Sep 2026 01:10:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788250200; x=1788855000; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DcGXRbOjTcgaUXDimFb+w2dbIkSAxSexDhooE+XIces=;
        b=EJPczPoJArnDYbxNQ0Zao6Y4/UX9dCjRfypflAgJgy5Dxrp/tEPnLG8OrEbnft7X9d
         HDLsSLTgp3hCiCKHs2fmpgKpszFP5Vegigqc5KwEyXDvHgVnJQR5JD1gLd+VzT3xeQUW
         cnFJKq6Y3NFzOcMqYVas+E0L5XSX2sAfHE1I7T9r70R6muTz1APlllSfjYlmN2weOMPS
         aIph7sLLKPhAwf4LXZee3Zj4VcX7KcqO8esODjLfQwiWV2c7hidv34fbW60BF1ZoEu+u
         gXBglRSCBWeXqYsIm4mw2Qj392y0Q9kc+k12/oxtek0jy3RNu5942ECZh7iFnIor1mMI
         tbaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788250200; x=1788855000;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DcGXRbOjTcgaUXDimFb+w2dbIkSAxSexDhooE+XIces=;
        b=T1//ZjmoqiN5QYBrIR9d7SrGFu3at2iLB6s2C0/0LIi1nL6PGeqftvoMez1+0SHRlK
         bvgoQM3bdWeaV1+FWZshlyJIjWU7/gmicQVL5DPbrpgxHh9h/psSDBxhGxlXm4QunGLW
         kYcFsN2W1NMQlLzWUgpFHvupdNwyHtP05SdXsWGD2jrwLnoYs2v8TroIBwiidZV03C0T
         s3fRvMGbuhnzI8qXh1JphDBv/9cTcOTont5WIEqaaGnZv25g8DCBRG28hrF/2R66v0rc
         +jC/TqBDsCBjf4U5Qs2jD1PZbnfWZMbnpLxDQ6lz34su+atOQ4mE4JH/rsVblshTyT9k
         4Zaw==
X-Forwarded-Encrypted: i=1; AKwUvByQ/RsTiixVtSZ7z/ySy2Gxkdh6ImhzMNKxV+6247Pk82ghWhyNhYlBOKuX6GhTqRIwHTzBlA8=@lists.linux.dev
X-Gm-Message-State: AFuF++lcAaAPV3OdZ+8L5DEVmAdfAfXC9AbAalXz/cWBMMz7bFTFFUcq
	F+OieJ24f8sAQmUP/cFW/kTwKmSGfb3JH6/tKN1BoXXMGUbJdRKAS/9FAVblECkOqM6QhQTnnon
	BsnE3HbR5RLk2SbVFU/ucRQ==
X-Received: from edat36.prod.google.com ([2002:a05:6402:2424:b0:6a6:7416:c649])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:505c:b0:6a6:489:e89b with SMTP id 4fb4d7f45d1cf-6a60d33f88dmr17579445a12.5.1788250199559;
 Tue, 01 Sep 2026 01:09:59 -0700 (PDT)
Date: Tue,  1 Sep 2026 09:09:32 +0100
In-Reply-To: <20260901080941.997769-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260901080941.997769-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.897.gb25b4bd76c-goog
Message-ID: <20260901080941.997769-10-vdonnefort@google.com>
Subject: [PATCH v5 09/18] KVM: arm64: Add selftests for the pKVM heap allocator
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, qperret@google.com, 
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

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Tested-by: Fuad Tabba <fuad.tabba@linux.dev>
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index fc3c52b03154..0a8df74a7b4e 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -92,6 +92,7 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___pkvm_hyp_topup,
 	__KVM_HOST_SMCCC_FUNC___pkvm_hyp_reclaim,
 	__KVM_HOST_SMCCC_FUNC___pkvm_hyp_reclaimable,
+	__KVM_HOST_SMCCC_FUNC___pkvm_hyp_alloc_selftest,
 
 	MARKER(__KVM_HOST_SMCCC_FUNC_PKVM_ONLY),
 
diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
index 5ea5633705ef..366bbd5c854b 100644
--- a/arch/arm64/include/asm/kvm_pkvm.h
+++ b/arch/arm64/include/asm/kvm_pkvm.h
@@ -19,8 +19,10 @@
 
 enum pkvm_topup_id {
 	PKVM_TOPUP_HYP_ALLOC,
+	PKVM_TOPUP_HYP_ALLOC_SELFTEST,
 };
 
+void pkvm_selftests(void);
 int pkvm_init_host_vm(struct kvm *kvm, unsigned long type);
 int pkvm_create_hyp_vm(struct kvm *kvm);
 bool pkvm_hyp_vm_is_created(struct kvm *kvm);
@@ -212,6 +214,7 @@ struct pkvm_mapping {
 enum pkvm_hyp_req_type {
 	PKVM_HYP_NO_REQ = 0,
 	PKVM_HYP_REQ_HYP_ALLOC,
+	PKVM_HYP_REQ_HYP_ALLOC_SELFTEST,
 	__PKVM_HYP_REQ_TYPE_MAX,
 };
 
@@ -239,6 +242,7 @@ static inline size_t pkvm_hyp_req_arg_size(u8 type)
 	case PKVM_HYP_NO_REQ:
 		return 0;
 	case PKVM_HYP_REQ_HYP_ALLOC:
+	case PKVM_HYP_REQ_HYP_ALLOC_SELFTEST:
 		return sizeof(req->mem);
 	default:
 		WARN_ON(1);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 8b080804bc90..09ae5431ce58 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2914,6 +2914,8 @@ static int __init init_hyp_mode(void)
 			kvm_err("Failed to init hyp memory protection\n");
 			goto out_err;
 		}
+
+		pkvm_selftests();
 	}
 
 	return 0;
diff --git a/arch/arm64/kvm/hyp/include/nvhe/alloc.h b/arch/arm64/kvm/hyp/include/nvhe/alloc.h
index 8f87a63f8946..bca0168e0046 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/alloc.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/alloc.h
@@ -14,4 +14,15 @@ int hyp_alloc_init(size_t size);
 int hyp_alloc_topup(struct kvm_hyp_memcache *host_mc);
 unsigned long hyp_alloc_reclaimable(void);
 void hyp_alloc_reclaim(struct kvm_hyp_memcache *host_mc, unsigned long target);
+
+#ifdef CONFIG_NVHE_EL2_DEBUG
+int hyp_allocator_selftest(void);
+u32 hyp_alloc_selftest_topup_needed(void);
+int hyp_alloc_selftest_topup(struct kvm_hyp_memcache *host_mc);
+void hyp_alloc_selftest_reclaim(struct kvm_hyp_memcache *host_mc, unsigned long target);
+#else
+static inline int hyp_alloc_selftest_topup(struct kvm_hyp_memcache *host_mc) { return 0; };
+static inline void
+hyp_alloc_selftest_reclaim(struct kvm_hyp_memcache *host_mc, unsigned long target) { };
+#endif
 #endif
diff --git a/arch/arm64/kvm/hyp/nvhe/alloc.c b/arch/arm64/kvm/hyp/nvhe/alloc.c
index 32435782030b..3b83de90472a 100644
--- a/arch/arm64/kvm/hyp/nvhe/alloc.c
+++ b/arch/arm64/kvm/hyp/nvhe/alloc.c
@@ -1001,9 +1001,17 @@ int hyp_alloc_errno(void)
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
@@ -1025,3 +1033,179 @@ u32 hyp_alloc_topup_needed(void)
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
index 62567560e1a5..563be134c0cb 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -827,6 +827,22 @@ static void handle___pkvm_finalize_teardown_vm(struct kvm_cpu_context *host_ctxt
 	cpu_reg(host_ctxt, 1) = __pkvm_finalize_teardown_vm(handle);
 }
 
+static void handle___pkvm_hyp_alloc_selftest(struct kvm_cpu_context *host_ctxt)
+{
+	struct pkvm_hyp_req req = { .type = PKVM_HYP_NO_REQ };
+	int ret = -EPERM;
+
+#ifdef CONFIG_NVHE_EL2_DEBUG
+	ret = hyp_allocator_selftest();
+	if (ret == -ENOMEM) {
+		req.type = PKVM_HYP_REQ_HYP_ALLOC_SELFTEST;
+		req.mem.nr_pages = hyp_alloc_selftest_topup_needed();
+	}
+#endif
+	cpu_reg(host_ctxt, 1) = ret;
+	pkvm_hyp_req_to_smccc(host_ctxt, &req);
+}
+
 static void handle___pkvm_hyp_topup(struct kvm_cpu_context *host_ctxt)
 {
 	DECLARE_REG(enum pkvm_topup_id, id, host_ctxt, 1);
@@ -842,6 +858,9 @@ static void handle___pkvm_hyp_topup(struct kvm_cpu_context *host_ctxt)
 	case PKVM_TOPUP_HYP_ALLOC:
 		ret = hyp_alloc_topup(&host_mc);
 		break;
+	case PKVM_TOPUP_HYP_ALLOC_SELFTEST:
+		ret = hyp_alloc_selftest_topup(&host_mc);
+		break;
 	default:
 		ret = -EINVAL;
 	}
@@ -862,6 +881,9 @@ static void handle___pkvm_hyp_reclaim(struct kvm_cpu_context *host_ctxt)
 	case PKVM_TOPUP_HYP_ALLOC:
 		hyp_alloc_reclaim(&host_mc, target);
 		break;
+	case PKVM_TOPUP_HYP_ALLOC_SELFTEST:
+		hyp_alloc_selftest_reclaim(&host_mc, target);
+		break;
 	default:
 		ret = -EINVAL;
 	}
@@ -998,6 +1020,7 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__pkvm_hyp_topup),
 	HANDLE_FUNC(__pkvm_hyp_reclaim),
 	HANDLE_FUNC(__pkvm_hyp_reclaimable),
+	HANDLE_FUNC(__pkvm_hyp_alloc_selftest),
 
 	HANDLE_FUNC(__pkvm_host_share_hyp),
 	HANDLE_FUNC(__pkvm_host_unshare_hyp),
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index fec819a9dc78..7821f2592eba 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -344,6 +344,22 @@ static int __init pkvm_drop_host_privileges(void)
 	return ret;
 }
 
+void __init pkvm_selftests(void)
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
@@ -677,6 +693,9 @@ static int pkvm_handle_hyp_req(struct pkvm_hyp_req *req)
 	case PKVM_HYP_REQ_HYP_ALLOC:
 		ret = pkvm_hyp_topup(PKVM_TOPUP_HYP_ALLOC, req->mem.nr_pages);
 		break;
+	case PKVM_HYP_REQ_HYP_ALLOC_SELFTEST:
+		ret = pkvm_hyp_topup(PKVM_TOPUP_HYP_ALLOC_SELFTEST, req->mem.nr_pages);
+		break;
 	}
 
 	trace_kvm_handle_pkvm_hyp_req(req, ret);
-- 
2.55.0.897.gb25b4bd76c-goog

