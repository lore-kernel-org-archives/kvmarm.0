Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.70
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794937477;
	b=BZe6zE+lTGe8vNvtvVsZQm1U8EI+lJ+eT4tECV+SNgEOFHeVwaxgXEVxeNxs2um8gfAa
	 RFtedyijVvjcVaA7YdmPzQHvct+nUkOMBAP5yR3/bLCKyTceAz/F75ld/Wlg4wJDW7mE0
	 C93IxwYvRELBYCJ49Dg9Na/TguUCTgYgkzYl/qMaK5EVx/PA7/cumujentWHrctEITg0a
	 kdAbdshkOHTS5uW3rBlS0WLY2JMbbThXoIikieXHh5ZvqW1xKyQRnSpL2G9ce8EQN32pt
	 jXykqs5bgGd+uFXfnqPWnXJOJSTVn9DRBMJdbT5TRrDhuD1dyvfZNOO7+VXh4h6ZJCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794937477;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=4ZFadknJpT2Sg2IX1pxLhHdSKqVRpbEQfn2dRJVi6Mw=;
	b=rPPCF1stLtW4HgfRnPbMzyauv1BlGEzOyOsILv9sVVJ+8xuxqAN2cjpr+gG3/iCXhDp/
	 voPs11frXFZTVeK/TeNTLdFRKEHvDAaVMUxdI6BYAGnCAsQs+xuoj4qNo6UCnT6qT0dMR
	 DWO24JfNn91cyacbzR5zlNzHFTP7xSPfFFokPX4H1cRe8tzgUuK5jXW3m2lqCq4xKkw9E
	 hRn0FON+mxr1Io2l+BZJdnh1ydWpr8jGGYjchXGhQBlePuEMV1jLXzGUXJUx2ztFj2Dkd
	 lh04R5+IEGKZmx4tByY1orZlmWN0vkttj3m5TXWaFWUADL2JkLowZl+7Y9XdOv7Qjdw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b="Gu4GX7/L";
	arc=none smtp.remote-ip=209.85.128.70
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28587606A32C
	for <kvmarm@lists.linux.dev>; Tue, 17 Nov 2026 17:44:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 28587606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Gu4GX7/L
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4a359c7f47bso672015e9.2
        for <kvmarm@lists.linux.dev>; Tue, 17 Nov 2026 09:44:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794937476; x=1795542276; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4ZFadknJpT2Sg2IX1pxLhHdSKqVRpbEQfn2dRJVi6Mw=;
        b=Gu4GX7/LRfT8RU68U4Pw3VGV5gdES9N8iUBnjWA+JlJ4PleEu9cpu3yEv5l2QUgEjh
         IpOz9CEEX3sUsini45g82fUMrNATYQo6/zVkixLTE+f2i6d0j7S+1krH+Ou2k7TbWXHI
         U+/4+aI3JAuZPLDKPmmJJuB7DCKJTnfs2fCpN+tnlkQlnWEPORC5pwX+Ln6zxUqy248v
         CRjTMR10lw84VrrvzWBHDJz75v4nukkOJBssJHD8MIejADMvNI4SmsiDR79zhzFCeV4f
         wo+hRtDnom0Fxdwo76D7LiXD5M190SinwJt/amkgbXwH75UwPns8Ojm8jVPzM+uCgI/x
         3CLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794937476; x=1795542276;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4ZFadknJpT2Sg2IX1pxLhHdSKqVRpbEQfn2dRJVi6Mw=;
        b=nRLAd32WJQcRx3z6yyiJ9Ur05ttMSapve8dvVNN5yZvFCX5KtS+Q7vCxKDZywtVgJP
         U+L+iDf4H23VW/97NyeUFqAfZU9mDDETHYma0nO4DOaA+wGZjnlc41UGZNtEIy4Path4
         0/lDfmHG20GH+FWs2P1uB3GCu9YhhcXsK6n62tWgfUhchIyyDeckXOaxmqUmLYUgIqZH
         o4sA8j1pacaQ83ddddZJOJMs/fzI5NkqoyN8p7Kxaj0H0v7DRaGfu5XeR+8Bci8tX2B8
         bwxeQF4AqqVxAsq7QSvSXgj/fVx8UmU/IPtt1ctZH2rkjal4zPvbFqym4yiq2kwrcej5
         D+Dw==
X-Forwarded-Encrypted: i=1; AL+hErErvMrS4kPdginFrP6kHa3IEiyD50tJtIFPZvp83rUPDzKfh1T99OHPmK8HWuZJX8aY9TzWeNM=@lists.linux.dev
X-Gm-Message-State: APuU4Z8CwU93IXdM4mTh3EtRnrYIUWGODtqM2L8UsTIy5ZQbL2VU/7Sk
	ebQtw7j8dKLMuEzvDZcVJHYlZeYaTfhDbLS9TlnoEoBNDQr9toQILtMQXai4hBZUQBDf3yAkDZD
	zYxpoDMPFvMpydSrsGjH5PA==
X-Received: from wmhk6.prod.google.com ([2002:a05:600c:4086:b0:4a1:989a:a866])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4f13:b0:4a3:5d64:df91 with SMTP id 5b1f17b1804b1-4bb55a5a523mr375962935e9.18.1794937475224;
 Tue, 17 Nov 2026 09:44:35 -0800 (PST)
Date: Tue, 17 Nov 2026 17:43:56 +0000
In-Reply-To: <20261117174403.58762-1-vdonnefort@google.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20261117174403.58762-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.56.1.708.g77570a6a1d-goog
Message-ID: <20261117174403.58762-18-vdonnefort@google.com>
Subject: [PATCH v4 17/23] KVM: arm64: Add vcpu conduit for pkvm_hyp_req
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, qperret@google.com, 
	weilin.chang@arm.com, Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

The pKVM hypervisor depends on the host for a lot of operations like
memory allocation. It can raise a request by populating a pkvm_hyp_req
on the extra registers when returning a SMCCC call.

Add a new conduit, using a per-vCPU pkvm_hyp_req, populated on
ARM_EXCEPTION_PKVM_HYP_REQ. This allows processing the request later, in
a less restrictive context than the one from where the __kvm_vcpu_run
HVC is called, just like the other exceptions are handled.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
---
 arch/arm64/include/asm/kvm_asm.h   | 10 ++++++----
 arch/arm64/include/asm/kvm_host.h  | 26 ++++++++++++++++++++++++++
 arch/arm64/include/asm/kvm_pkvm.h  | 24 +-----------------------
 arch/arm64/kvm/handle_exit.c       |  3 +++
 arch/arm64/kvm/hyp/nvhe/hyp-main.c |  2 ++
 arch/arm64/kvm/pkvm.c              |  9 +++++++--
 6 files changed, 45 insertions(+), 29 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 3efc63e1a823..872185f9ac53 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -17,10 +17,11 @@
 #define ARM_EXCEPTION_IS_TRAP(x)  (ARM_EXCEPTION_CODE((x)) == ARM_EXCEPTION_TRAP)
 #define ARM_SERROR_PENDING(x)	  !!((x) & (1U << ARM_EXIT_WITH_SERROR_BIT))
 
-#define ARM_EXCEPTION_IRQ	  0
-#define ARM_EXCEPTION_EL1_SERROR  1
-#define ARM_EXCEPTION_TRAP	  2
-#define ARM_EXCEPTION_IL	  3
+#define ARM_EXCEPTION_IRQ		0
+#define ARM_EXCEPTION_EL1_SERROR	1
+#define ARM_EXCEPTION_TRAP		2
+#define ARM_EXCEPTION_IL		3
+#define ARM_EXCEPTION_PKVM_HYP_REQ	4
 /* The hyp-stub will return this for any kvm_call_hyp() call */
 #define ARM_EXCEPTION_HYP_GONE	  HVC_STUB_ERR
 
@@ -28,6 +29,7 @@
 	{ARM_EXCEPTION_IRQ,		"IRQ"		},	\
 	{ARM_EXCEPTION_EL1_SERROR, 	"SERROR"	},	\
 	{ARM_EXCEPTION_TRAP, 		"TRAP"		},	\
+	{ARM_EXCEPTION_PKVM_HYP_REQ,	"PKVM_HYP_REQ"	},	\
 	{ARM_EXCEPTION_HYP_GONE,	"HYP_GONE"	}
 
 /*
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 97332ffcb130..0161bcb8123b 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -138,6 +138,29 @@ u32 __attribute_const__ kvm_target_cpu(void);
 void kvm_reset_vcpu(struct kvm_vcpu *vcpu);
 void kvm_arm_vcpu_destroy(struct kvm_vcpu *vcpu);
 
+enum pkvm_hyp_req_type {
+	PKVM_HYP_NO_REQ = 0,
+	PKVM_HYP_REQ_HYP_ALLOC,
+	PKVM_HYP_REQ_HYP_ALLOC_SELFTEST,
+	__PKVM_HYP_REQ_TYPE_MAX,
+};
+
+#define PKVM_HYP_REQ_SMCCC_ARG_SIZE_MAX \
+	(sizeof(struct arm_smccc_res) - offsetof(struct arm_smccc_res, a2) - 1)
+
+struct pkvm_hyp_req {
+	u8 type;
+	union {
+		struct {
+			u32	nr_pages;
+		} mem;
+		struct {
+			/* Helper for SMCCC encoding/decoding */
+			u8	args[PKVM_HYP_REQ_SMCCC_ARG_SIZE_MAX];
+		} args;
+	};
+};
+
 struct kvm_hyp_memcache {
 	phys_addr_t head;
 	unsigned long nr_pages;
@@ -1006,6 +1029,9 @@ struct kvm_vcpu_arch {
 	/* Pages to top-up the pKVM/EL2 guest stage-2 pool */
 	struct kvm_hyp_memcache stage2_mc;
 
+	/* To be read on ARM_EXCEPTION_PKVM_HYP_REQ */
+	struct pkvm_hyp_req pkvm_hyp_req;
+
 	/* Virtual SError ESR to restore when HCR_EL2.VSE is set */
 	u64 vsesr_el2;
 
diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
index b75dc3d03a98..3e51337f2d9e 100644
--- a/arch/arm64/include/asm/kvm_pkvm.h
+++ b/arch/arm64/include/asm/kvm_pkvm.h
@@ -22,6 +22,7 @@ int pkvm_create_hyp_vm(struct kvm *kvm);
 bool pkvm_hyp_vm_is_created(struct kvm *kvm);
 void pkvm_destroy_hyp_vm(struct kvm *kvm);
 int pkvm_create_hyp_vcpu(struct kvm_vcpu *vcpu);
+int __pkvm_handle_vcpu_req(struct kvm_vcpu *vcpu);
 
 /*
  * Check whether the specific capability is allowed in pKVM.
@@ -231,29 +232,6 @@ struct pkvm_mapping {
 	u64 __subtree_last;	/* Internal member for interval tree */
 };
 
-enum pkvm_hyp_req_type {
-	PKVM_HYP_NO_REQ = 0,
-	PKVM_HYP_REQ_HYP_ALLOC,
-	PKVM_HYP_REQ_HYP_ALLOC_SELFTEST,
-	__PKVM_HYP_REQ_TYPE_MAX,
-};
-
-#define PKVM_HYP_REQ_SMCCC_ARG_SIZE_MAX \
-	(sizeof(struct arm_smccc_res) - offsetof(struct arm_smccc_res, a2) - 1)
-
-struct pkvm_hyp_req {
-	u8 type;
-	union {
-		struct {
-			u32	nr_pages;
-		} mem;
-		struct {
-			/* Helper for SMCCC encoding/decoding */
-			u8	args[PKVM_HYP_REQ_SMCCC_ARG_SIZE_MAX];
-		} args;
-	};
-};
-
 static inline size_t pkvm_hyp_req_arg_size(u8 type)
 {
 	struct pkvm_hyp_req *req;
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 9931192735d4..2030675304ca 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -18,6 +18,7 @@
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_mmu.h>
 #include <asm/kvm_nested.h>
+#include <asm/kvm_pkvm.h>
 #include <asm/debug-monitors.h>
 #include <asm/stacktrace/nvhe.h>
 #include <asm/traps.h>
@@ -464,6 +465,8 @@ int handle_exit(struct kvm_vcpu *vcpu, int exception_index)
 		return 1;
 	case ARM_EXCEPTION_TRAP:
 		return handle_trap_exceptions(vcpu);
+	case ARM_EXCEPTION_PKVM_HYP_REQ:
+		return __pkvm_handle_vcpu_req(vcpu);
 	case ARM_EXCEPTION_HYP_GONE:
 		/*
 		 * EL2 has been reset to the hyp-stub. This happens when a guest
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index c322ef4432c9..41817f45115d 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -734,6 +734,7 @@ static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
 	case ARM_EXCEPTION_IRQ:
 	case ARM_EXCEPTION_EL1_SERROR:
 	case ARM_EXCEPTION_IL:
+	case ARM_EXCEPTION_PKVM_HYP_REQ:
 		break;
 	case ARM_EXCEPTION_TRAP:
 		/* Nothing was marshalled for this trap, see sync_hyp_vcpu(). */
@@ -803,6 +804,7 @@ static void sync_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu, u32 exit_reason)
 		break;
 	case ARM_EXCEPTION_EL1_SERROR:
 	case ARM_EXCEPTION_IL:
+	case ARM_EXCEPTION_PKVM_HYP_REQ:
 		break;
 	default:
 		BUG();
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index ae53c701206a..c55b6d442d0e 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -765,7 +765,7 @@ bool pkvm_force_reclaim_guest_page(phys_addr_t phys)
 	return !ret || ret == -EAGAIN;
 }
 
-static int pkvm_handle_hyp_req(struct pkvm_hyp_req *req)
+static int pkvm_handle_hyp_req(struct pkvm_hyp_req *req, struct kvm_vcpu *vcpu)
 {
 	int ret = -EINVAL;
 
@@ -788,7 +788,12 @@ int __pkvm_handle_smccc_req(struct arm_smccc_res *res)
 	struct pkvm_hyp_req req;
 
 	if (smccc_to_pkvm_hyp_req(&req, res))
-		return pkvm_handle_hyp_req(&req);
+		return pkvm_handle_hyp_req(&req, NULL);
 
 	return res->a1;
 }
+
+int __pkvm_handle_vcpu_req(struct kvm_vcpu *vcpu)
+{
+	return pkvm_handle_hyp_req(&vcpu->arch.pkvm_hyp_req, vcpu) ?: 1;
+}
-- 
2.56.1.708.g77570a6a1d-goog

