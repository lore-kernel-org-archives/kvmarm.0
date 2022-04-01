Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C0DEC43217
	for <kvmarm@archiver.kernel.org>; Fri,  1 Apr 2022 18:21:12 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 21FCC4B2A4;
	Fri,  1 Apr 2022 14:21:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id trnCTHkPd9CC; Fri,  1 Apr 2022 14:21:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 62A114B274;
	Fri,  1 Apr 2022 14:20:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5DAFC4B265
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Apr 2022 13:56:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nFuDbUshowz4 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  1 Apr 2022 13:56:32 -0400 (EDT)
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com
 [209.85.214.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 25B1E4B20F
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Apr 2022 13:56:32 -0400 (EDT)
Received: by mail-pl1-f201.google.com with SMTP id
 r16-20020a170903021000b00155f7af17b6so1793685plh.16
 for <kvmarm@lists.cs.columbia.edu>; Fri, 01 Apr 2022 10:56:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=SFXm2KwniaE00QEj2NzqHgvf1ASQ84rh2AbpNytHfco=;
 b=qJlGcvodbGXModlH9jGukKmgTNEjWAOITQQu62mFHP6LKDJbwZqskUJsLcP86ZbJU6
 ci9SF25lZR0byT8KkjvNOzhD5SdjyuAbbl77X2sYflrRrmhCGM3luPp1sOeeEkV+3EAL
 72SOwJfxzbZxHxeJw0r5hmFUuOz8+1rGkoNZg9n+oGWFvq9KXzbUDF9pwFZSsRX7F7CU
 QAYlhUtNCoVt4sAs4aFJDgnE2BjvLy8UVhToIBfsNEPPIcfoYrdvQP2Y5Al9np8aW+3Z
 vZlfv9GdlmFaj4JXon3BM18j1zorzjZSDNDzm7hgwuUh83hha4yb45BqMoS1/CXJ+Jpn
 +MMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=SFXm2KwniaE00QEj2NzqHgvf1ASQ84rh2AbpNytHfco=;
 b=wlcV14ph1E9f0Et+e3b7dnG3+r+aqSEUyvqQXIXbZJKyM2BbZF1WXlLG2DBAstYs82
 PHfdHDOEgpvc6Sp7plerzikExOgS+swOhi2gwEzK9RPfCKlO3tREp9jgKyCMD47nZaO0
 aEaqGLOYGvHQnuJQzKGW1+e35nWJYxS4f4uoLYeKFaPpVRU0KEraoddYfZmbUVE42+Ji
 xgnv387coDV4ZMQgwNN8m3nhtSYOFktVo2amBkec9B3i3KAbVQSmiOTyWFfenVDrtcXB
 QRnWpTm5PByrEMyvbGoaPAqNuBRzxpNj+RYfaV8Iqc1SKuw1K+G5wv2FSEK+1HeZ4Sm8
 RMdQ==
X-Gm-Message-State: AOAM531LQQUDp1/JeTXCtGds6xyfQS45VBde2zbAFgse90vJUGjgrE7w
 4zw809YLVOuzb6LgG1AvlE7+uaunOS3ySg==
X-Google-Smtp-Source: ABdhPJy5g1z/iSbFZBwpj7J/HiTUYMlrOwh+Ud1JO3xyCytgN0gs7EbKQm2V60MVCQpu5tAlITqiMh3TNmIocA==
X-Received: from dmatlack-heavy.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:902:e78f:b0:156:3b3b:e4ce with SMTP
 id cp15-20020a170902e78f00b001563b3be4cemr17310175plb.8.1648835791370; Fri,
 01 Apr 2022 10:56:31 -0700 (PDT)
Date: Fri,  1 Apr 2022 17:55:50 +0000
In-Reply-To: <20220401175554.1931568-1-dmatlack@google.com>
Message-Id: <20220401175554.1931568-20-dmatlack@google.com>
Mime-Version: 1.0
References: <20220401175554.1931568-1-dmatlack@google.com>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH v3 19/23] KVM: x86/mmu: Refactor drop_large_spte()
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
X-Mailman-Approved-At: Fri, 01 Apr 2022 14:20:42 -0400
Cc: Albert Ou <aou@eecs.berkeley.edu>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <kvm@vger.kernel.org>, Marc Zyngier <maz@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>,
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

drop_large_spte() drops a large SPTE if it exists and then flushes TLBs.
Its helper function, __drop_large_spte(), does the drop without the
flush.

In preparation for eager page splitting, which will need to sometimes
flush when dropping large SPTEs (and sometimes not), push the flushing
logic down into __drop_large_spte() and add a bool parameter to control
it.

No functional change intended.

Reviewed-by: Peter Xu <peterx@redhat.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 6390b23d286a..f058f28909ea 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1184,28 +1184,29 @@ static void drop_spte(struct kvm *kvm, u64 *sptep)
 		rmap_remove(kvm, sptep);
 }
 
-
-static bool __drop_large_spte(struct kvm *kvm, u64 *sptep)
+static void __drop_large_spte(struct kvm *kvm, u64 *sptep, bool flush)
 {
-	if (is_large_pte(*sptep)) {
-		WARN_ON(sptep_to_sp(sptep)->role.level == PG_LEVEL_4K);
-		drop_spte(kvm, sptep);
-		return true;
-	}
+	struct kvm_mmu_page *sp;
 
-	return false;
-}
+	if (!is_large_pte(*sptep))
+		return;
 
-static void drop_large_spte(struct kvm_vcpu *vcpu, u64 *sptep)
-{
-	if (__drop_large_spte(vcpu->kvm, sptep)) {
-		struct kvm_mmu_page *sp = sptep_to_sp(sptep);
+	sp = sptep_to_sp(sptep);
+	WARN_ON(sp->role.level == PG_LEVEL_4K);
 
-		kvm_flush_remote_tlbs_with_address(vcpu->kvm, sp->gfn,
+	drop_spte(kvm, sptep);
+
+	if (flush) {
+		kvm_flush_remote_tlbs_with_address(kvm, sp->gfn,
 			KVM_PAGES_PER_HPAGE(sp->role.level));
 	}
 }
 
+static void drop_large_spte(struct kvm_vcpu *vcpu, u64 *sptep)
+{
+	return __drop_large_spte(vcpu->kvm, sptep, true);
+}
+
 /*
  * Write-protect on the specified @sptep, @pt_protect indicates whether
  * spte write-protection is caused by protecting shadow page table.
-- 
2.35.1.1094.g7c7d902a7c-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
