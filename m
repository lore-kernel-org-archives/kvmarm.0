Return-Path: <SRS0=fiTO=MS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 374DBC432BE
	for <kvmarm@archiver.kernel.org>; Mon, 26 Jul 2021 15:36:06 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D99C860F59
	for <kvmarm@archiver.kernel.org>; Mon, 26 Jul 2021 15:36:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org D99C860F59
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8D2914A49C;
	Mon, 26 Jul 2021 11:36:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XR5lXl7fHrCF; Mon, 26 Jul 2021 11:36:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1549D4B09A;
	Mon, 26 Jul 2021 11:36:03 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D9D5F4A1A7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Jul 2021 11:36:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FrLVhuDBue0E for <kvmarm@lists.cs.columbia.edu>;
 Mon, 26 Jul 2021 11:36:00 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E47C74A1B0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Jul 2021 11:35:59 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 3C1DD60F58;
 Mon, 26 Jul 2021 15:35:59 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1m82e5-001511-JT; Mon, 26 Jul 2021 16:35:57 +0100
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-mm@kvack.org
Subject: [PATCH v2 6/6] KVM: Get rid of kvm_get_pfn()
Date: Mon, 26 Jul 2021 16:35:52 +0100
Message-Id: <20210726153552.1535838-7-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210726153552.1535838-1-maz@kernel.org>
References: <20210726153552.1535838-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-mm@kvack.org, seanjc@google.com,
 willy@infradead.org, pbonzini@redhat.com, will@kernel.org, qperret@google.com,
 james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com,
 kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Sean Christopherson <seanjc@google.com>,
 Matthew Wilcox <willy@infradead.org>, Paolo Bonzini <pbonzini@redhat.com>,
 Will Deacon <will@kernel.org>
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

Nobody is using kvm_get_pfn() anymore. Get rid of it.

Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 include/linux/kvm_host.h | 1 -
 virt/kvm/kvm_main.c      | 9 +--------
 2 files changed, 1 insertion(+), 9 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index ae7735b490b4..9818d271c2a1 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -824,7 +824,6 @@ void kvm_release_pfn_clean(kvm_pfn_t pfn);
 void kvm_release_pfn_dirty(kvm_pfn_t pfn);
 void kvm_set_pfn_dirty(kvm_pfn_t pfn);
 void kvm_set_pfn_accessed(kvm_pfn_t pfn);
-void kvm_get_pfn(kvm_pfn_t pfn);
 
 void kvm_release_pfn(kvm_pfn_t pfn, bool dirty, struct gfn_to_pfn_cache *cache);
 int kvm_read_guest_page(struct kvm *kvm, gfn_t gfn, void *data, int offset,
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 956ef6ddce7f..54bf3a14958a 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2215,7 +2215,7 @@ static int hva_to_pfn_remapped(struct vm_area_struct *vma,
 	 * Get a reference here because callers of *hva_to_pfn* and
 	 * *gfn_to_pfn* ultimately call kvm_release_pfn_clean on the
 	 * returned pfn.  This is only needed if the VMA has VM_MIXEDMAP
-	 * set, but the kvm_get_pfn/kvm_release_pfn_clean pair will
+	 * set, but the kvm_try_get_pfn/kvm_release_pfn_clean pair will
 	 * simply do nothing for reserved pfns.
 	 *
 	 * Whoever called remap_pfn_range is also going to call e.g.
@@ -2612,13 +2612,6 @@ void kvm_set_pfn_accessed(kvm_pfn_t pfn)
 }
 EXPORT_SYMBOL_GPL(kvm_set_pfn_accessed);
 
-void kvm_get_pfn(kvm_pfn_t pfn)
-{
-	if (!kvm_is_reserved_pfn(pfn))
-		get_page(pfn_to_page(pfn));
-}
-EXPORT_SYMBOL_GPL(kvm_get_pfn);
-
 static int next_segment(unsigned long len, int offset)
 {
 	if (len > PAGE_SIZE - offset)
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
