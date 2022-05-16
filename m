Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BDBCC433F5
	for <kvmarm@archiver.kernel.org>; Tue, 17 May 2022 07:02:42 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 29CFD4B348;
	Tue, 17 May 2022 03:02:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9BdjzieMsNYZ; Tue, 17 May 2022 03:02:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7D2B74B305;
	Tue, 17 May 2022 03:02:27 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7649D49EBB
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 May 2022 19:22:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GtgCvJIgPgcu for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 May 2022 19:22:03 -0400 (EDT)
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com
 [209.85.215.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 412A64B1ED
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 May 2022 19:22:03 -0400 (EDT)
Received: by mail-pg1-f201.google.com with SMTP id
 q13-20020a638c4d000000b003821725ad66so7991851pgn.23
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 May 2022 16:22:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=A6CVaoOuq2onvCNWimXYpavQumfN27L5Xs2b3S02gqQ=;
 b=bcwsxBglOBT4ZMVcMYItKNA0ZXLA0rV5EG2SQ5hQYnPtPtavU8lCYwMOUrK0CF/3/Z
 GAZ5SE/AFjz6wbTCtxZVlBnxdb9ONyz51LENidkTwYadfda963XbV0U96/xbrAN2RHWl
 zbPrybTDO7h17b1zmyv8x54rr7IjJ0tbGwzq/zxnHDqoGr/Flesx6upKd4aNlQ5552D/
 0+2IH/aMiLKSoEvKrd5KW4r42n2ARj+Oel56xhrDVgm5FK51oek4doTlm9nt4Bu9Bcy0
 QnakT0ka/TDa3fVDGIuyGZdr96UfKNygkvuRPBTNCSHxMC0Sw+6Rpsix8IViN7Sgi343
 cpIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=A6CVaoOuq2onvCNWimXYpavQumfN27L5Xs2b3S02gqQ=;
 b=1KioWuIQ4UDwbQNlVGzsVQzM1hRduJYx+HHzaQ4PFjbKEfDU8d6FvWKUH/zal0Yei1
 c+LmEB5r7bpRRoV1eseXsZPeeiE7zyfqyx/wDVwDWaP7Sqyi0huLP9QLrQXNma9NibwL
 zD2SqoZSODjf6h0GyGeNnHvd8LpdccMU7DtOczKFSkYO6WD9dSzbinawhLZebGB/OYxi
 WfmKaF1K2GUJv2MPF6cdebt1KDSKgZTYL6cYbEMOQ+m88j+UuIDVB0pIbUj5vBkL1EAo
 CCAAHFpwOARI55PyinFqI1cRxgdjxg/7o6kpNZsB6AaSebtDGpVklDs5sJcwCTQKNSWR
 w+eg==
X-Gm-Message-State: AOAM5336V1e1B9ACvcjKvVdaOlrIIzcA9bOjXSGi8RKPRQPqbHszu5IT
 oHsbJpqLIOhNtr3Vc5jcWLb78PJOrKcjfA==
X-Google-Smtp-Source: ABdhPJwbkPyHCHgoWRkNMjiw3yFJAqcG0ROERSd4sGrkNJEIJIVAScIP5FlL7jgS9O1xF6hECroMyEfuaoOXnA==
X-Received: from dmatlack-heavy.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a05:6a00:ad2:b0:4f1:2734:a3d9 with SMTP
 id c18-20020a056a000ad200b004f12734a3d9mr19554806pfl.61.1652743322409; Mon,
 16 May 2022 16:22:02 -0700 (PDT)
Date: Mon, 16 May 2022 23:21:29 +0000
In-Reply-To: <20220516232138.1783324-1-dmatlack@google.com>
Message-Id: <20220516232138.1783324-14-dmatlack@google.com>
Mime-Version: 1.0
References: <20220516232138.1783324-1-dmatlack@google.com>
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
Subject: [PATCH v6 13/22] KVM: x86/mmu: Allow NULL @vcpu in
 kvm_mmu_find_shadow_page()
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
X-Mailman-Approved-At: Tue, 17 May 2022 03:02:25 -0400
Cc: Albert Ou <aou@eecs.berkeley.edu>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <kvm@vger.kernel.org>, Marc Zyngier <maz@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <linux-mips@vger.kernel.org>, David Matlack <dmatlack@google.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Palmer Dabbelt <palmer@dabbelt.com>,
 "open list:KERNEL VIRTUAL MACHINE FOR RISC-V \(KVM/riscv\)"
 <kvm-riscv@lists.infradead.org>, Paul Walmsley <paul.walmsley@sifive.com>,
 Ben Gardon <bgardon@google.com>, maciej.szmigiero@oracle.com,
 "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <kvmarm@lists.cs.columbia.edu>, Peter Feiner <pfeiner@google.com>
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

Allow @vcpu to be NULL in kvm_mmu_find_shadow_page() (and its only
caller __kvm_mmu_get_shadow_page()). @vcpu is only required to sync
indirect shadow pages, so it's safe to pass in NULL when looking up
direct shadow pages.

This will be used for doing eager page splitting, which allocates direct
shadow pages from the context of a VM ioctl without access to a vCPU
pointer.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 4fbc2da47428..acb54d6e0ea5 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1850,6 +1850,7 @@ static int kvm_sync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 
 	if (ret < 0)
 		kvm_mmu_prepare_zap_page(vcpu->kvm, sp, invalid_list);
+
 	return ret;
 }
 
@@ -2001,6 +2002,7 @@ static void clear_sp_write_flooding_count(u64 *spte)
 	__clear_sp_write_flooding_count(sptep_to_sp(spte));
 }
 
+/* Note, @vcpu may be NULL if @role.direct is true. */
 static struct kvm_mmu_page *kvm_mmu_find_shadow_page(struct kvm *kvm,
 						     struct kvm_vcpu *vcpu,
 						     gfn_t gfn,
@@ -2039,6 +2041,16 @@ static struct kvm_mmu_page *kvm_mmu_find_shadow_page(struct kvm *kvm,
 			goto out;
 
 		if (sp->unsync) {
+			/*
+			 * A vCPU pointer should always be provided when finding
+			 * indirect shadow pages, as that shadow page may
+			 * already exist and need to be synced using the vCPU
+			 * pointer. Direct shadow pages are never unsync and
+			 * thus do not require a vCPU pointer.
+			 */
+			if (KVM_BUG_ON(!vcpu, kvm))
+				break;
+
 			/*
 			 * The page is good, but is stale.  kvm_sync_page does
 			 * get the latest guest state, but (unlike mmu_unsync_children)
@@ -2116,6 +2128,7 @@ static struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm *kvm,
 	return sp;
 }
 
+/* Note, @vcpu may be NULL if @role.direct is true. */
 static struct kvm_mmu_page *__kvm_mmu_get_shadow_page(struct kvm *kvm,
 						      struct kvm_vcpu *vcpu,
 						      struct shadow_page_caches *caches,
-- 
2.36.0.550.gb090851708-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
