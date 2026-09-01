Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com [209.85.208.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBAD8370AE2
	for <kvmarm@lists.linux.dev>; Tue,  1 Sep 2026 08:09:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788250200; cv=none; b=u0VhqGIcGgpp0vcnTgRL3+qa+dFzwDqG/pDpuB80221M7h8Z40733peEB2raML2vNhDuOqYQCanEbic4PHM0mGRgKdZt0lZ1z86ebVRwaYna92q9AsMN3tknuiJ7mm+2RcsTXYaaxRX+9DnXUstGl6CworckPJMyz9t8mpdQOG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788250200; c=relaxed/simple;
	bh=7ZJJft+II8IePTSnSUtntQXfErbhhbv2zGiGk14w6Vw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Mgbv9bpuPntcDIR32TqUgs9ALAWCGoMtJ6LsjtB6T9kpype0C1RjJviI3vuH0nGLSCEVJLw7rde87pKao0F9xGrmkvN3YcmKFngNbXAMwLEKna+nFuOEp/0fKfGB3lUaudmdPvFciYH55ByETblJMmp7hYETASHA3NGC4UnzR00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ojXjJ44p; arc=none smtp.client-ip=209.85.208.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ojXjJ44p"
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-6a178080182so4805444a12.2
        for <kvmarm@lists.linux.dev>; Tue, 01 Sep 2026 01:09:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788250197; x=1788854997; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eptbgNmTS4rkLSwMh/pJm6Fg1kYiL08r3P/b5PdQUAE=;
        b=ojXjJ44pZkw+Nm6qj53g0wGjQyPfkazFp8tQY0WCNcMtGReWxNcLG+2Gr4tjc9ivCf
         SrK3e4jZFdOZjCqGZDL5zMO0LEBh1W/PGyA/UpyZcONSvB7JuKcmjRsdUi1gbu+p7Rtb
         jWcFrdSo9nNJ0/zj/xBB43F0nFI69aYUsDLLTtUz9jvtN8Hk9WMp1nYkK5bWoqLEU04f
         t0ayinWsR0iv0qMjVIto9kb7reiTa2vr9xSFHOVNewn+HD5caWXSntmmWEcp9PWWTIbi
         9dceoohxP6JZsI6jC32MphBlnvvm9K9KUaB5FFVGf0niL8kwXau0QfOarSftnJfzXsmC
         SGcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788250197; x=1788854997;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=eptbgNmTS4rkLSwMh/pJm6Fg1kYiL08r3P/b5PdQUAE=;
        b=IQHPTjkvoxpoGT4Qv1zLagNmHKRbY+w5B7BCWD3uaLKgyLvsO1+slBpzSRVeW0Ao5Q
         oIX7Z3TExVES3ai/otWBlervU6AG0PIJqsKIIlEbC19pDcgWWsWb4z0OfaPQ80raPPDM
         bEL3mxyxN67mzv7aNv/KsihiYK/RQFRbg5WB0Z3HhWavsJFxEgVBbCMhoAietkcZ2TKf
         n9PHFFubU0ryK1a7OpYjyJBfIZspuDlPLCK3XD4F1OpTGLGRXeEEhK2f7yxPWI71jhrK
         Xn/aFvKGryGTVErT8keDJ5wSkT1D8SMlUSQ1mzPKdIbMwgMD2Ckz7A3j6v2xi4iJd3+G
         mLSQ==
X-Forwarded-Encrypted: i=1; AKwUvBxo3WAvC9h9Hm4mmLrAFdpJJibrilacVNUGrsp4Cje6e/wxvJhpNIh6IaxwGXCKU/yTHfTJrPI=@lists.linux.dev
X-Gm-Message-State: AFuF++ncps2QKDLtCidufkcjCGB+51TNl5ZPbh786OSvFOqcOXSpCoiV
	YBfrV+9w5RYSgyepho2OlgmuzKQP2cY7fstRVP1h9DjKJSSLe6u3oEVCcrwdVPk0OpQJbWmOwSo
	BT3VGb1L0AoT+N1q2zng5jQ==
X-Received: from edgi18-n2.prod.google.com ([2002:a05:6402:a592:20b0:6a6:72b4:df94])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:4285:b0:6a5:dd97:23ea with SMTP id 4fb4d7f45d1cf-6a60d3715b5mr20153705a12.11.1788250196848;
 Tue, 01 Sep 2026 01:09:56 -0700 (PDT)
Date: Tue,  1 Sep 2026 09:09:30 +0100
In-Reply-To: <20260901080941.997769-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260901080941.997769-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.897.gb25b4bd76c-goog
Message-ID: <20260901080941.997769-8-vdonnefort@google.com>
Subject: [PATCH v5 07/18] KVM: arm64: Add PKVM_HYP_REQ_HYP_ALLOC request
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, qperret@google.com, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Introduce a new pkvm_hyp_request type asking the host to top up the pKVM
heap allocator.

Tested-by: Fuad Tabba <fuad.tabba@linux.dev>
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

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
 
diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
index 19bddf261c82..5ea5633705ef 100644
--- a/arch/arm64/include/asm/kvm_pkvm.h
+++ b/arch/arm64/include/asm/kvm_pkvm.h
@@ -17,6 +17,10 @@
 
 #define HYP_MEMBLOCK_REGIONS 128
 
+enum pkvm_topup_id {
+	PKVM_TOPUP_HYP_ALLOC,
+};
+
 int pkvm_init_host_vm(struct kvm *kvm, unsigned long type);
 int pkvm_create_hyp_vm(struct kvm *kvm);
 bool pkvm_hyp_vm_is_created(struct kvm *kvm);
@@ -207,6 +211,7 @@ struct pkvm_mapping {
 
 enum pkvm_hyp_req_type {
 	PKVM_HYP_NO_REQ = 0,
+	PKVM_HYP_REQ_HYP_ALLOC,
 	__PKVM_HYP_REQ_TYPE_MAX,
 };
 
@@ -228,9 +233,13 @@ struct pkvm_hyp_req {
 
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
index 9a3b92e626ad..0e590261f1cc 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -17,6 +17,7 @@
 #include <asm/kvm_hypevents.h>
 #include <asm/kvm_mmu.h>
 
+#include <nvhe/alloc.h>
 #include <nvhe/ffa.h>
 #include <nvhe/mem_protect.h>
 #include <nvhe/mm.h>
@@ -826,6 +827,30 @@ static void handle___pkvm_finalize_teardown_vm(struct kvm_cpu_context *host_ctxt
 	cpu_reg(host_ctxt, 1) = __pkvm_finalize_teardown_vm(handle);
 }
 
+static void handle___pkvm_hyp_topup(struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(enum pkvm_topup_id, id, host_ctxt, 1);
+	DECLARE_REG(phys_addr_t, head, host_ctxt, 2);
+	DECLARE_REG(unsigned long, nr_pages, host_ctxt, 3);
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
+	cpu_reg(host_ctxt, 1) = ret;
+	cpu_reg(host_ctxt, 2) = host_mc.head;
+	cpu_reg(host_ctxt, 3) = host_mc.nr_pages;
+}
+
 static void handle___tracing_load(struct kvm_cpu_context *host_ctxt)
 {
 	DECLARE_REG(unsigned long, desc_hva, host_ctxt, 1);
@@ -934,6 +959,7 @@ static const hcall_t host_hcall[] = {
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
2.55.0.897.gb25b4bd76c-goog

