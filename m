Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9914B3F1662
	for <kvmarm@lists.linux.dev>; Wed, 20 May 2026 15:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779290844; cv=none; b=ihYR8iix0pE96VxaQAPR+LbP4vkS6/HanXXBmZIGCdYfyIVipuxeteB+to8n8vx7K4WwQ/nBw+G//NLeGsVkx539dFpZd2YL8H955zSRN1njlA9aIUM6ymt+M05GH0OvaPjPHlO6dDi9nolnr2dhuRKh+jXZ+ee4Vc54qN3D5k4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779290844; c=relaxed/simple;
	bh=2A6zI9DCR/pLSH15UHq20NdL5+1YUdQehhAaRbMA75Y=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nBrHRLivLVQIzEKTf1lEI74Ol9Y0dFElkrRN1HN7tQRdEQ2FAoopQK1LLJ8gCeSLlw8hoUUcdqUK1nXxXmhic9jpcA7GjIhtsJSPQP1Paw9KKdh9m7Qrm/XfItXjoSXs3cKlAmSGqwmjzocSYOHYOFdi9lJ2dKqeUDj4P4wRgyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mdrS49yk; arc=none smtp.client-ip=209.85.218.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mdrS49yk"
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-bcbb3e56f10so492022666b.2
        for <kvmarm@lists.linux.dev>; Wed, 20 May 2026 08:27:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779290841; x=1779895641; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=QjWpwL/LE/VZqD55anKNHz7HfyCLzMU4NvzDqdhCqMQ=;
        b=mdrS49ykSqdjqz9Sj3ClIiTgBo5eeuv2fFk7BTr0ppu20BbuZvoJKKJdwvM8xdQwTV
         CgGw9zo1h3Y/fxbgpCi4B+RrE1WFcocvmT3XxKfDBDSyMjZRBCisNuq7Epb45ZyxTaUo
         4CCpiHbiNQjutFBtTXZZ/9Jo9ko0vUG3xFBqZFUJpych6MtzNL1fjfSltenpI49htVzR
         gcbE0cKgZU8jyLsEhiHxot6nICSZYmEiZd1NcoVMspEACYWpuxvb2m4btiuPRJtJGiAn
         8fp9Y0DOsGLzI3qUtBArj8PrQf4SpJHnYA2/Vt/tbzMOnW5Byefcf0VVh/6wJ6CMO4rT
         kMDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779290841; x=1779895641;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QjWpwL/LE/VZqD55anKNHz7HfyCLzMU4NvzDqdhCqMQ=;
        b=ke+kYum+fMWzi/4x92l+Ug1yohaWJxQWjWbnxiYEDz7oNB71i0IWZJRy2RWYYpJR3Q
         sPN3m7SvjFUJ4C8iB3A5zo0YXLBRErVluUm4NI1OF35mFlrHCQMgdvAu1AkbBVfukyZ8
         CsoqBgeWuaH850+Msl+zbjVBIt5wePqVbcSw4JOyo2W8gNHnPR3d7fL7KBEgC6B/X+RS
         KZLWW0cr0846PFoPj48W/XEfFJOzkXOnFCIshmgGghKqqEqm54tBZ3T1rPMr3kUcqOCe
         8trCocnUrDYfvts3Af44yGD4GyVl/DERussj8a6f3juQQILKbjDptNTAMmXLTVBZtTd2
         h2ng==
X-Forwarded-Encrypted: i=1; AFNElJ/T9E73CVdG58DpPMGiRC1h0Ow9hIDO8SQeSyZ4N6RTZwIiqkiDhnKWANdLEKjTmGs5xo08cnA=@lists.linux.dev
X-Gm-Message-State: AOJu0YwgwF0K4i9XZXHQk6PMQvXThk4vWZeJ+QFYRe1rEzfdcbqoZufN
	fqSkP5n/6ZsUwObDKUgzfQ2IOgqg4s6jkhM5PJ5QdiTAR9Z2LOCvwOC3WSjJ/H0Ch9Qnk6thTlh
	QhOW94OivskCw9l4NHqIYEg==
X-Received: from edfg6-n2.prod.google.com ([2002:a05:6402:a246:20b0:687:381a:b147])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:d708:b0:bc8:b8cd:8a22 with SMTP id a640c23a62f3a-bd51791c807mr1230766166b.23.1779290840487;
 Wed, 20 May 2026 08:27:20 -0700 (PDT)
Date: Wed, 20 May 2026 16:26:39 +0100
In-Reply-To: <20260520152650.4107895-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260520152650.4107895-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.54.0.631.ge1b05301d1-goog
Message-ID: <20260520152650.4107895-7-vdonnefort@google.com>
Subject: [PATCH 06/17] KVM: arm64: Add topup interface for the pKVM heap allocator
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kernel-team@android.com, qperret@google.com, tabba@google.com, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Introduce a host HVC interface and a host side helper to allow refilling
the pKVM heap allocator.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 043495f7fc78..681b7bf8ac08 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -114,6 +114,7 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___pkvm_vcpu_load,
 	__KVM_HOST_SMCCC_FUNC___pkvm_vcpu_put,
 	__KVM_HOST_SMCCC_FUNC___pkvm_tlb_flush_vmid,
+	__KVM_HOST_SMCCC_FUNC___pkvm_hyp_topup,
 
 	MARKER(__KVM_HOST_SMCCC_FUNC_MAX)
 };
diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
index 2954b311128c..879f1667ec67 100644
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
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 06db299c37a8..38ce834ca840 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -15,6 +15,7 @@
 #include <asm/kvm_hypevents.h>
 #include <asm/kvm_mmu.h>
 
+#include <nvhe/alloc.h>
 #include <nvhe/ffa.h>
 #include <nvhe/mem_protect.h>
 #include <nvhe/mm.h>
@@ -613,6 +614,30 @@ static void handle___pkvm_finalize_teardown_vm(struct kvm_cpu_context *host_ctxt
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
@@ -743,6 +768,7 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__pkvm_vcpu_load),
 	HANDLE_FUNC(__pkvm_vcpu_put),
 	HANDLE_FUNC(__pkvm_tlb_flush_vmid),
+	HANDLE_FUNC(__pkvm_hyp_topup),
 };
 
 static void handle_host_hcall(struct kvm_cpu_context *host_ctxt)
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 8324a6a1bc48..7abdc250b633 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -85,6 +85,29 @@ void __init kvm_hyp_reserve(void)
 		 hyp_mem_base);
 }
 
+static int pkvm_hyp_topup(enum pkvm_topup_id id, unsigned long nr_pages)
+{
+	struct arm_smccc_res res;
+	struct kvm_hyp_memcache mc;
+	int ret;
+
+	init_hyp_memcache(&mc);
+
+	ret = topup_hyp_memcache(&mc, nr_pages);
+	if (ret)
+		return ret;
+
+	arm_smccc_1_1_hvc(KVM_HOST_SMCCC_FUNC(__pkvm_hyp_topup), id, mc.head,
+			  mc.nr_pages, &res);
+	WARN_ON(res.a0 != SMCCC_RET_SUCCESS);
+
+	mc.head = res.a2;
+	mc.nr_pages = res.a3;
+	free_hyp_memcache(&mc);
+
+	return res.a1;
+}
+
 static void __pkvm_destroy_hyp_vm(struct kvm *kvm)
 {
 	if (pkvm_hyp_vm_is_created(kvm)) {
-- 
2.54.0.631.ge1b05301d1-goog

