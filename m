Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 122BFC433EF
	for <kvmarm@archiver.kernel.org>; Thu, 23 Jun 2022 07:30:35 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A16954B42E;
	Thu, 23 Jun 2022 03:30:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YD8TNsPYbcjw; Thu, 23 Jun 2022 03:30:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 55EA34B323;
	Thu, 23 Jun 2022 03:30:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 28ABC4B381
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Jun 2022 22:19:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hAUV4VFMCbI5 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 22 Jun 2022 22:19:38 -0400 (EDT)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BD5024B253
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Jun 2022 22:19:38 -0400 (EDT)
Received: by mail-yb1-f201.google.com with SMTP id
 h82-20020a25d055000000b00668b6a4ee32so14037083ybg.3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Jun 2022 19:19:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=wT4jHGlHPHF9dlfcKzGZH8nhD8vpeQwEkQou9JzLU60=;
 b=RVgxxUJl2hpXa33b+kJtJXbExaoizJzs1IRtinNk7nfyr7rfAQugUZA7d+RrpYEKbL
 lxHsdenRl/U81vQWHbh2ieO7b0GgcNVgtAhi1jrLMUgeR2LQmBpGScCtRjSisDCCaNgw
 zdPf2LmgZwlaYXYa6Bcw8e323ZhLCyGNLakWlg9g8HJ/vvSbzKJfCY5eMJrUzBoC+ios
 G2TiaYtk35xp/tudhc3eyll3CHRE2CqXUFC2BmGOE4Thxb5xXeM6xtAEDe+RLRGLZeIf
 n317+ev8I08NprsuGzNYGVhK0NJX54k1qixYjDwqClxClfhLPNYSu8+7KEWWyZxdW6dh
 W8lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=wT4jHGlHPHF9dlfcKzGZH8nhD8vpeQwEkQou9JzLU60=;
 b=Sg2CUyiNNysqm27fXt9FACUIptEd78Kt/RylIAwz7p21MZr2xxf10rff9QvzmaS9lR
 s96HYyuMkMRQ966CYGHwlrv20nHK1ANhtnH4BC4UbMyK8itGgXjmElE6RZciTBOFOIoN
 cN+EEqCfnD7v/htI+bl4G4RHDb+RMMsbQrBzBuuuBvFnvBSW6nMRZtqYe/VBncwBEvlu
 KB+GEhcLXp+d9/ublOryWZfdkYHAoey6bOmcERUK/mxMAaqgJcSOugY8NNlQ4YXsOrqT
 fSj+kmleJUbHlM0h0CMLdQb1QIJHwbUfN7sMv0i48Tj8w+tEb0e5xtFsGGSetezhDETU
 9jKA==
X-Gm-Message-State: AJIora/HX0d0rgHW3WtOe7YFPURhI1mZT80ZW0pg9MwBv371o4rA50n2
 denCBHhSHYb2+nOESDmQVl1KWDA/CQnDATCYN7WtwFbv1YZ5UmMRf5gFjkTlw3gfx3TfYx+4u7A
 bgHcE30MFAX5Nnfda3Jw6dyIO8+F5F9mK3wk+m9m43GxpWKI3i28cHkGGxbQrYw==
X-Google-Smtp-Source: AGRyM1ub1xVH1VRZd14aVuV55xQTwS7KIATb7Hw6lN8inguHsebJ3kq2h0VMLDkavIHjfGw2R83JCkQ=
X-Received: from pcc-desktop.svl.corp.google.com
 ([2620:15c:2ce:200:ba6f:123c:d287:a160])
 (user=pcc job=sendgmr) by 2002:a0d:dd81:0:b0:317:cd05:1d94 with SMTP id
 g123-20020a0ddd81000000b00317cd051d94mr8038901ywe.189.1655950778275; Wed, 22
 Jun 2022 19:19:38 -0700 (PDT)
Date: Wed, 22 Jun 2022 19:19:24 -0700
In-Reply-To: <20220623021926.3443240-1-pcc@google.com>
Message-Id: <20220623021926.3443240-2-pcc@google.com>
Mime-Version: 1.0
References: <20220623021926.3443240-1-pcc@google.com>
X-Mailer: git-send-email 2.37.0.rc0.104.g0611611a94-goog
Subject: [PATCH 1/3] KVM: arm64: add a hypercall for disowning pages
From: Peter Collingbourne <pcc@google.com>
To: kvmarm@lists.cs.columbia.edu
X-Mailman-Approved-At: Thu, 23 Jun 2022 03:30:27 -0400
Cc: Catalin Marinas <catalin.marinas@arm.com>, kvm@vger.kernel.org,
 Marc Zyngier <maz@kernel.org>, Andy Lutomirski <luto@amacapital.net>,
 Will Deacon <will@kernel.org>, Evgenii Stepanov <eugenis@google.com>,
 Michael Roth <michael.roth@amd.com>, Chao Peng <chao.p.peng@linux.intel.com>,
 Peter Collingbourne <pcc@google.com>, linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Currently we only deny the host access to hyp and guest pages. However,
there may be other pages that could potentially be used to indirectly
compromise the hypervisor or the other guests. Therefore introduce a
__pkvm_disown_pages hypercall that the host kernel may use to deny its
future self access to those pages before deprivileging itself.

Signed-off-by: Peter Collingbourne <pcc@google.com>
---
 arch/arm64/include/asm/kvm_asm.h              |  1 +
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  1 +
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h        |  1 +
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            |  9 +++++++++
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 11 +++++++++++
 arch/arm64/kvm/hyp/pgtable.c                  |  5 +++--
 6 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 411cfbe3ebbd..1a177d9ed517 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -63,6 +63,7 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___kvm_tlb_flush_vmid_ipa,
 	__KVM_HOST_SMCCC_FUNC___kvm_tlb_flush_vmid,
 	__KVM_HOST_SMCCC_FUNC___kvm_flush_cpu_context,
+	__KVM_HOST_SMCCC_FUNC___pkvm_disown_pages,
 	__KVM_HOST_SMCCC_FUNC___pkvm_prot_finalize,
 
 	/* Hypercalls available after pKVM finalisation */
diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index e0bbb1726fa3..e88a9dab9cd5 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -58,6 +58,7 @@ enum pkvm_component_id {
 	PKVM_ID_HOST,
 	PKVM_ID_HYP,
 	PKVM_ID_GUEST,
+	PKVM_ID_NOBODY,
 };
 
 extern unsigned long hyp_nr_cpus;
diff --git a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
index c1987115b217..fbd991a46ab3 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
@@ -98,6 +98,7 @@ int __pkvm_init_shadow(struct kvm *kvm,
 		       unsigned long pgd_hva,
 		       unsigned long last_ran_hva, size_t last_ran_size);
 int __pkvm_teardown_shadow(unsigned int shadow_handle);
+int __pkvm_disown_pages(phys_addr_t phys, size_t size);
 
 struct kvm_shadow_vcpu_state *
 pkvm_load_shadow_vcpu_state(unsigned int shadow_handle, unsigned int vcpu_idx);
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index ddb36d172b60..b81908ef13e2 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -1055,6 +1055,14 @@ static void handle___pkvm_teardown_shadow(struct kvm_cpu_context *host_ctxt)
 	cpu_reg(host_ctxt, 1) = __pkvm_teardown_shadow(shadow_handle);
 }
 
+static void handle___pkvm_disown_pages(struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(phys_addr_t, phys, host_ctxt, 1);
+	DECLARE_REG(size_t, size, host_ctxt, 2);
+
+	cpu_reg(host_ctxt, 1) = __pkvm_disown_pages(phys, size);
+}
+
 typedef void (*hcall_t)(struct kvm_cpu_context *);
 
 #define HANDLE_FUNC(x)	[__KVM_HOST_SMCCC_FUNC_##x] = (hcall_t)handle_##x
@@ -1072,6 +1080,7 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__kvm_tlb_flush_vmid_ipa),
 	HANDLE_FUNC(__kvm_tlb_flush_vmid),
 	HANDLE_FUNC(__kvm_flush_cpu_context),
+	HANDLE_FUNC(__pkvm_disown_pages),
 	HANDLE_FUNC(__pkvm_prot_finalize),
 
 	HANDLE_FUNC(__pkvm_host_share_hyp),
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index d839bb573b49..b3a2ad8454cc 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -1756,3 +1756,14 @@ int __pkvm_host_reclaim_page(u64 pfn)
 
 	return ret;
 }
+
+int __pkvm_disown_pages(phys_addr_t phys, size_t size)
+{
+	int ret;
+
+	host_lock_component();
+	ret = host_stage2_set_owner_locked(phys, size, PKVM_ID_NOBODY);
+	host_unlock_component();
+
+	return ret;
+}
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 756bbb15c1f3..e1ecddd43885 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -10,6 +10,7 @@
 #include <linux/bitfield.h>
 #include <asm/kvm_pgtable.h>
 #include <asm/stage2_pgtable.h>
+#include <nvhe/mem_protect.h>
 
 
 #define KVM_PTE_TYPE			BIT(1)
@@ -677,9 +678,9 @@ static bool stage2_pte_is_counted(kvm_pte_t pte)
 	/*
 	 * The refcount tracks valid entries as well as invalid entries if they
 	 * encode ownership of a page to another entity than the page-table
-	 * owner, whose id is 0.
+	 * owner, whose id is 0, or NOBODY, which does not correspond to a page-table.
 	 */
-	return !!pte;
+	return !!pte && pte != kvm_init_invalid_leaf_owner(PKVM_ID_NOBODY);
 }
 
 static void stage2_put_pte(kvm_pte_t *ptep, struct kvm_s2_mmu *mmu, u64 addr,
-- 
2.37.0.rc0.104.g0611611a94-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
