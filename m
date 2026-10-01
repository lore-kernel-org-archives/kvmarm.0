Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5C1251DAEE
	for <kvmarm@lists.linux.dev>; Thu,  1 Oct 2026 14:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790864957; cv=none; b=P49J1HRUrIxeU0j2VCHKULCK0JLL7pke4YGhLk75w7qoKO1rPhbcTMfEUnpPnSQCVW9FXzIcHTj89Fg2Gtg/WkivYfTBhpMBAoInNA+rJwzTgClDZufz+5qWl85JEMhzE+Vcw6FSi10YxRqyUuWXz2p0uciAcIRu6wOnq86oW5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790864957; c=relaxed/simple;
	bh=U9xzNC0/33AalbyY9+Z87z51/OXES2HrlVd0ydnYxS0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GajPctWCQ3mBbnsjexnrpmU7qLFYNAyqI38GCURLIO+YeYzs3N4dSVKs2uosm/9nhg5G9FHVrmPHqzstkmvxp5k4ZV/f/ltsY5mWpQeWvg2fIpxDLHihz0uEF/L8Pjw3Sgu4Db14ogwsoOoBzoAoYr0vNQAcbz5yS+9HF1Jolr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=d8x508Ri; arc=none smtp.client-ip=209.85.128.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="d8x508Ri"
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4a004b70f99so26723695e9.2
        for <kvmarm@lists.linux.dev>; Thu, 01 Oct 2026 07:29:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790864946; x=1791469746; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8x+WOwJb8ZYQgifj5DAZhtg6Tqmw4UwJVTgrA3MagC4=;
        b=d8x508RiXSXaiub0kEcpJeJMVPkWJQlYQ5tH9w7l9HprQma3oz0w7nCUHgvFY11f5V
         TWBWmuAkegi47ZFc3udjQ3viMB4avmNXN+iQR7W/epZVq+GvHufcjFFw2xfZLto6vbQ5
         KI4j+HdjwVDAeyz/U7C14zVDGNbFf8FRR8jvSpbvPVHpCw3GqKxum29TKORsTCVD2eif
         w//7E3Jq/7H1Pki2QtAMatNIGuRa3RL1PGgenKj1RAyPbexw1L6bHBi78qhw1GXKqDGf
         X2s/b5rJNzc4WBBiqVbUlFRBFoKJNp4akLGUoGuYpgsUO5BIlfHKr7Vp8EvbTLxKwH32
         9STg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790864946; x=1791469746;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8x+WOwJb8ZYQgifj5DAZhtg6Tqmw4UwJVTgrA3MagC4=;
        b=1Z2+3qGO0lmZNVLNX94352uGFunusgAoKqbX/bxfc/pR3U57sJC6IgQI7tyCfKICHt
         YDJ+ohq2FujJoNkeQ96mDZnjl1YQjerfWEktVDyuFejSvNTvm29yEAJSlA2nA1hF5b5M
         tmiYzJAvS6IXwB7H8tfeDSJ4HOekM7pYy/Jwsqt40d1dCK3UANsDJf1gkQzfs1kHlWP0
         ztXA+igPmBMzBkFJVUGzXHKGnvlWPaKhn4vrukGFcBQgoSh1X0JgKPgaRVxQKTtPsp56
         En2445KJELx1ZsrzizaG04Vx28Vmx5+QXjkY8rJ38XZ49tDQYfdc1UzykYcNzn9RLR8T
         +RRg==
X-Forwarded-Encrypted: i=1; AKwUvBwXzh3btIRVzLFgVvkv66kQqRPl3wdS8K7DCUdCExS7TDlrtWiayWCZ4Kx/wPbw7+axAPmW8tM=@lists.linux.dev
X-Gm-Message-State: AFuF++n01qOeZDjt25hSW1kK9zWNs0qevY/vqUrNzR9G1dh8rv8PgutC
	NZ6LGsSqWBy1+KpodeOh+tOl5JdVXkBZ5hu+75w0m/VIsle0zKc3OjMjogB8Ma/rplffn9pX9HW
	oA2pqEpQWy7Xz1E1LZpZGuQ==
X-Received: from wmqg19.prod.google.com ([2002:a05:600c:4ed3:b0:4a0:334:56b4])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4e42:b0:4a0:1d:3ac4 with SMTP id 5b1f17b1804b1-4a01aff06d5mr80499015e9.6.1790864945476;
 Thu, 01 Oct 2026 07:29:05 -0700 (PDT)
Date: Thu,  1 Oct 2026 15:28:38 +0100
In-Reply-To: <20261001142849.3367614-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20261001142849.3367614-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20261001142849.3367614-8-vdonnefort@google.com>
Subject: [PATCH v6 07/18] KVM: arm64: Add PKVM_HYP_REQ_HYP_ALLOC request
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Introduce a new pkvm_hyp_request type asking the host to top up the pKVM
heap allocator.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
Tested-by: Fuad Tabba <fuad.tabba@linux.dev>
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/include/asm/kvm_asm.h   |  1 +
 arch/arm64/include/asm/kvm_hcall.h |  6 ++++++
 arch/arm64/include/asm/kvm_pkvm.h  |  5 +++++
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 26 ++++++++++++++++++++++++++
 arch/arm64/kvm/pkvm.c              | 30 ++++++++++++++++++++++++++++++
 arch/arm64/kvm/trace_pkvm.h        |  6 ++++--
 6 files changed, 72 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index e5b92ac09e69..de59e89318fa 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -89,6 +89,7 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___vgic_v3_restore_vmcr_aprs,
 	__KVM_HOST_SMCCC_FUNC___vgic_v5_save_apr,
 	__KVM_HOST_SMCCC_FUNC___vgic_v5_restore_vmcr_apr,
+	__KVM_HOST_SMCCC_FUNC___pkvm_hyp_topup,
 
 	MARKER(__KVM_HOST_SMCCC_FUNC_PKVM_ONLY),
 
diff --git a/arch/arm64/include/asm/kvm_hcall.h b/arch/arm64/include/asm/kvm_hcall.h
index 9f06af58a4b0..6d6f12400e94 100644
--- a/arch/arm64/include/asm/kvm_hcall.h
+++ b/arch/arm64/include/asm/kvm_hcall.h
@@ -22,6 +22,10 @@
 
 typedef u16 pkvm_handle_t;
 
+enum pkvm_topup_id {
+	PKVM_TOPUP_HYP_ALLOC,
+};
+
 struct kvm;
 struct kvm_s2_mmu;
 struct kvm_vcpu;
@@ -193,6 +197,8 @@ DECLARE_KVM_HOST_HCALL(void, __vgic_v5_save_apr,
 	struct vgic_v5_cpu_if __kern *, cpu_if)
 DECLARE_KVM_HOST_HCALL(void, __vgic_v5_restore_vmcr_apr,
 	struct vgic_v5_cpu_if __kern *, cpu_if)
+DECLARE_KVM_HOST_HCALL(int, __pkvm_hyp_topup,
+	enum pkvm_topup_id, id, phys_addr_t, head, unsigned long, nr_pages)
 
 /* Hypercalls that are available only when pKVM has finalised. */
 DECLARE_KVM_HOST_HCALL(int, __pkvm_host_share_hyp,
diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
index 19bddf261c82..c338178d6bb2 100644
--- a/arch/arm64/include/asm/kvm_pkvm.h
+++ b/arch/arm64/include/asm/kvm_pkvm.h
@@ -207,6 +207,7 @@ struct pkvm_mapping {
 
 enum pkvm_hyp_req_type {
 	PKVM_HYP_NO_REQ = 0,
+	PKVM_HYP_REQ_HYP_ALLOC,
 	__PKVM_HYP_REQ_TYPE_MAX,
 };
 
@@ -228,9 +229,13 @@ struct pkvm_hyp_req {
 
 static inline size_t pkvm_hyp_req_arg_size(u8 type)
 {
+	struct pkvm_hyp_req *req;
+
 	switch (type) {
 	case PKVM_HYP_NO_REQ:
 		return 0;
+	case PKVM_HYP_REQ_HYP_ALLOC:
+		return sizeof(req->mem);
 	default:
 		WARN_ON(1);
 	}
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 91e74a1a334f..2b89eb274482 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -17,6 +17,7 @@
 #include <asm/kvm_hypevents.h>
 #include <asm/kvm_mmu.h>
 
+#include <nvhe/alloc.h>
 #include <nvhe/ffa.h>
 #include <nvhe/mem_protect.h>
 #include <nvhe/mm.h>
@@ -799,6 +800,30 @@ DEFINE_KVM_HOST_HCALL(int, __pkvm_finalize_teardown_vm,
 	return __pkvm_finalize_teardown_vm(handle);
 }
 
+DEFINE_KVM_HOST_HCALL(int, __pkvm_hyp_topup,
+	enum pkvm_topup_id, id, phys_addr_t, head, unsigned long, nr_pages)
+{
+	struct kvm_cpu_context *host_ctxt = host_data_ptr(host_ctxt);
+	struct kvm_hyp_memcache host_mc = {
+		.head = head,
+		.nr_pages = nr_pages,
+	};
+	int ret;
+
+	switch (id) {
+	case PKVM_TOPUP_HYP_ALLOC:
+		ret = hyp_alloc_topup(&host_mc);
+		break;
+	default:
+		ret = -EINVAL;
+	}
+
+	cpu_reg(host_ctxt, 2) = host_mc.head;
+	cpu_reg(host_ctxt, 3) = host_mc.nr_pages;
+
+	return ret;
+}
+
 DEFINE_KVM_HOST_HCALL(int, __tracing_load,
 	void __kern *, desc_hva, size_t, desc_size)
 {
@@ -893,6 +918,7 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__vgic_v3_restore_vmcr_aprs),
 	HANDLE_FUNC(__vgic_v5_save_apr),
 	HANDLE_FUNC(__vgic_v5_restore_vmcr_apr),
+	HANDLE_FUNC(__pkvm_hyp_topup),
 
 	HANDLE_FUNC(__pkvm_host_share_hyp),
 	HANDLE_FUNC(__pkvm_host_unshare_hyp),
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 11d9e2f70cd8..9cd23978481c 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -88,6 +88,33 @@ void __init kvm_hyp_reserve(void)
 		 hyp_mem_base);
 }
 
+static int pkvm_hyp_topup(enum pkvm_topup_id id, unsigned long nr_pages)
+{
+	struct kvm_hyp_memcache mc;
+	struct arm_smccc_res res;
+	int ret;
+
+	init_hyp_memcache(&mc);
+	ret = topup_hyp_memcache(&mc, nr_pages);
+	if (ret)
+		goto err;
+
+	arm_smccc_1_1_hvc(KVM_HOST_SMCCC_FUNC(__pkvm_hyp_topup), id, mc.head,
+			  mc.nr_pages, &res);
+	if (WARN_ON_ONCE(res.a0 != SMCCC_RET_SUCCESS)) {
+		ret = -EINVAL;
+		goto err;
+	}
+
+	ret = res.a1;
+	mc.head = res.a2;
+	mc.nr_pages = res.a3;
+
+err:
+	free_hyp_memcache(&mc);
+	return ret;
+}
+
 static void __pkvm_destroy_hyp_vm(struct kvm *kvm)
 {
 	if (pkvm_hyp_vm_is_created(kvm)) {
@@ -603,6 +630,9 @@ static int pkvm_handle_hyp_req(struct pkvm_hyp_req *req)
 	int ret = -EINVAL;
 
 	switch (req->type) {
+	case PKVM_HYP_REQ_HYP_ALLOC:
+		ret = pkvm_hyp_topup(PKVM_TOPUP_HYP_ALLOC, req->mem.nr_pages);
+		break;
 	}
 
 	trace_kvm_handle_pkvm_hyp_req(req, ret);
diff --git a/arch/arm64/kvm/trace_pkvm.h b/arch/arm64/kvm/trace_pkvm.h
index 3966c111e3ad..493225e3282d 100644
--- a/arch/arm64/kvm/trace_pkvm.h
+++ b/arch/arm64/kvm/trace_pkvm.h
@@ -9,9 +9,11 @@
 #define TRACE_SYSTEM kvm
 
 TRACE_DEFINE_ENUM(PKVM_HYP_NO_REQ);
+TRACE_DEFINE_ENUM(PKVM_HYP_REQ_HYP_ALLOC);
 
-#define PKVM_HYP_REQ_TYPES \
-	{ PKVM_HYP_NO_REQ, "NO_REQ" }
+#define PKVM_HYP_REQ_TYPES				\
+	{ PKVM_HYP_NO_REQ, "NO_REQ" },			\
+	{ PKVM_HYP_REQ_HYP_ALLOC, "HYP_ALLOC" }
 
 TRACE_EVENT(kvm_handle_pkvm_hyp_req,
 	TP_PROTO(struct pkvm_hyp_req *req, int ret),
-- 
2.56.0.rc1.315.gc6ed9934b7-goog

