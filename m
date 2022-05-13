Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7208DC433FE
	for <kvmarm@archiver.kernel.org>; Sat, 14 May 2022 10:09:12 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 214F34B172;
	Sat, 14 May 2022 06:09:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2X-hxRb5Zfp2; Sat, 14 May 2022 06:09:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 419AE4B265;
	Sat, 14 May 2022 06:08:57 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CAD5349EF6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 May 2022 16:28:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CZwFKoKa+Ia0 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 13 May 2022 16:28:52 -0400 (EDT)
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com
 [209.85.214.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B81DA49F46
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 May 2022 16:28:52 -0400 (EDT)
Received: by mail-pl1-f202.google.com with SMTP id
 s2-20020a17090302c200b00158ea215fa2so4865286plk.3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 May 2022 13:28:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=lgtnhvy7+1BCZ2eFCe2s9WzklomHzRT131Cc2B3t8Gs=;
 b=nlPBmMlvFaiiHIxBMCrdBviz09aO2UJ3P4BQKD5zdeS25QzxpRCDfJttzo3xnUZ3Zs
 Woc893zPTgCcikXTcx871Qn4AldyKgfNp5bhRfkB5aTHiWuKhD/2hlwkDGQG+bdtSfCJ
 htizOAEaEMSFrbCyY8nQEcTm+sBtLwKgpm0M1SnltyfsLkatXQvqOzXVLhssiby5a9uA
 nCGOh5FXrAGdfj5Gi01e06xx6gcqb9lxybyoHb0Ra8A20IDSft8W4ZT923y2E/L1w1Jn
 8JQ+rvf4CFTSsJ1aFmJndTHh1Mk5kLvigrQojP9i4rbS7D9XblX3FX2aqFNyzr3FsSV+
 9BmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=lgtnhvy7+1BCZ2eFCe2s9WzklomHzRT131Cc2B3t8Gs=;
 b=pZusD0IOm3CFTX4hiCbTaL3ea8DejUnRaLNloYGND5tF77WFdNuVbwyO8xHz5PAOXB
 vE8ZTr/Y2hA9kHS2xOZQCCT4SJSnujXNMrt9c3Ch/WSStjJB5XZVJTPKzqlBt5KX9x9Y
 HbtPmIsxicn4C7OMJ+nTOrz9cTBCI7YPoBRAn1txT9SeqpWe5q5YidEfIxqP7qCCxYYd
 tmoUCbJP6OK2LFA0hnnN1wouFWaOV+PQNwzG64PQdyGHBQIf6WmH9pd1LommLUAz5SvM
 oyM1VDDcv7ig0i2galM4jfEAa56e2DlbPYQRDgdROrT3w7/mS5dqZDqM7q8GiGLJ3gyS
 64Tg==
X-Gm-Message-State: AOAM532jfhiGinz9wmIvFylmtnO5tC01Yl4ax4A/XkhZrUhiqqzueMx5
 +efvpV2WbuWhOn1D/r72yWlvR4ixYKHxgA==
X-Google-Smtp-Source: ABdhPJwTCP7I8XFt//8SoYQKhPgP4tZAxj29bs/HtPYVJcnz6pLypD536V2k28Bo91JrBLRkEwYnsf8a77QRUg==
X-Received: from dmatlack-heavy.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:90b:1251:b0:1d7:f7ae:9f1 with SMTP id
 gx17-20020a17090b125100b001d7f7ae09f1mr17935511pjb.65.1652473731863; Fri, 13
 May 2022 13:28:51 -0700 (PDT)
Date: Fri, 13 May 2022 20:28:10 +0000
In-Reply-To: <20220513202819.829591-1-dmatlack@google.com>
Message-Id: <20220513202819.829591-13-dmatlack@google.com>
Mime-Version: 1.0
References: <20220513202819.829591-1-dmatlack@google.com>
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
Subject: [PATCH v5 12/21] KVM: x86/mmu: Allow NULL @vcpu in
 kvm_mmu_find_shadow_page()
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
X-Mailman-Approved-At: Sat, 14 May 2022 06:08:54 -0400
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
index cf27c5de9dc0..bc66029d837f 100644
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
