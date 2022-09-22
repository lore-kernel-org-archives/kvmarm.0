Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70C5CC6FA8B
	for <kvmarm@archiver.kernel.org>; Thu, 22 Sep 2022 17:01:59 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D944B4B62B;
	Thu, 22 Sep 2022 13:01:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id djonEN40jbcv; Thu, 22 Sep 2022 13:01:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B98354B1AD;
	Thu, 22 Sep 2022 13:01:57 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 631A74B256
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Sep 2022 13:01:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id v7zMsheT9Prr for <kvmarm@lists.cs.columbia.edu>;
 Thu, 22 Sep 2022 13:01:56 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 33B8741071
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Sep 2022 13:01:56 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 822D9636B9;
 Thu, 22 Sep 2022 17:01:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 463CEC433C1;
 Thu, 22 Sep 2022 17:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1663866115;
 bh=k79Y4hLlE6C9zOK8ak9v3sdPQfDZmueRgBsCVRUicak=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=rurnMhTfLjVG27gPLBTEYM2BqHtNZldocEHOIvbzyh0jOnr1rcY7QgbNVqUCgRxIb
 J2Cp97nXtPNMGyA40It4ALqwi4PwZFPQr5vdLATbNQ/K1cFuROqHELn8OVgkXg7Pmx
 0OQf5EksnCDucYGidMzs5blTKLfT4t8PCWFTtcOC4lFonC+GOC10mOU8QqYESt7tS5
 tEr3n8Rd7mgompykfLZ8IoTLKxb9HmdN4FlccjCCPzLcedDskIZim8sKBzleaLrW1x
 VitlUxSLTtOuLy8Pn1hDcvIlKXkRuwa9KlONGSQarx4wNvR5L2pIo7vNbZKRKGt0Kk
 K5LzB0yXPY9/A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.95)
 (envelope-from <maz@kernel.org>) id 1obPaD-00Bxdo-6C;
 Thu, 22 Sep 2022 18:01:53 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu,
	kvm@vger.kernel.org
Subject: [PATCH 1/6] KVM: Use acquire/release semantics when accessing dirty
 ring GFN state
Date: Thu, 22 Sep 2022 18:01:28 +0100
Message-Id: <20220922170133.2617189-2-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220922170133.2617189-1-maz@kernel.org>
References: <20220922170133.2617189-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 catalin.marinas@arm.com, bgardon@google.com, shuah@kernel.org,
 andrew.jones@linux.dev, will@kernel.org, dmatlack@google.com,
 peterx@redhat.com, pbonzini@redhat.com, zhenyzha@redhat.com,
 shan.gavin@gmail.com, gshan@redhat.com, james.morse@arm.com,
 suzuki.poulose@arm.com, alexandru.elisei@arm.com, oliver.upton@linux.dev
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: will@kernel.org, catalin.marinas@arm.com, andrew.jones@linux.dev,
 shan.gavin@gmail.com, bgardon@google.com, dmatlack@google.com,
 pbonzini@redhat.com, zhenyzha@redhat.com, shuah@kernel.org
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

The current implementation of the dirty ring has an implicit requirement
that stores to the dirty ring from userspace must be:

- be ordered with one another

- visible from another CPU executing a ring reset

While these implicit requirements work well for x86 (and any other
TSO-like architecture), they do not work for more relaxed architectures
such as arm64 where stores to different addresses can be freely
reordered, and loads from these addresses not observing writes from
another CPU unless the required barriers (or acquire/release semantics)
are used.

In order to start fixing this, upgrade the ring reset accesses:

- the kvm_dirty_gfn_harvested() helper now uses acquire semantics
  so it is ordered after all previous writes, including that from
  userspace

- the kvm_dirty_gfn_set_invalid() helper now uses release semantics
  so that the next_slot and next_offset reads don't drift past
  the entry invalidation

This is only a partial fix as the userspace side also need upgrading.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 virt/kvm/dirty_ring.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/dirty_ring.c b/virt/kvm/dirty_ring.c
index f4c2a6eb1666..784bed80221d 100644
--- a/virt/kvm/dirty_ring.c
+++ b/virt/kvm/dirty_ring.c
@@ -79,12 +79,12 @@ static inline void kvm_dirty_gfn_set_invalid(struct kvm_dirty_gfn *gfn)
 
 static inline void kvm_dirty_gfn_set_dirtied(struct kvm_dirty_gfn *gfn)
 {
-	gfn->flags = KVM_DIRTY_GFN_F_DIRTY;
+	smp_store_release(&gfn->flags, KVM_DIRTY_GFN_F_DIRTY);
 }
 
 static inline bool kvm_dirty_gfn_harvested(struct kvm_dirty_gfn *gfn)
 {
-	return gfn->flags & KVM_DIRTY_GFN_F_RESET;
+	return smp_load_acquire(&gfn->flags) & KVM_DIRTY_GFN_F_RESET;
 }
 
 int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring)
-- 
2.34.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
