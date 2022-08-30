Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9A92ECAAD5
	for <kvmarm@archiver.kernel.org>; Tue, 30 Aug 2022 19:42:06 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 50B614B9AB;
	Tue, 30 Aug 2022 15:42:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id aXNl+U-qHhK0; Tue, 30 Aug 2022 15:42:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1DAF44B98C;
	Tue, 30 Aug 2022 15:42:05 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C79924B989
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Aug 2022 15:42:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FIAvAqX3zUt1 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 30 Aug 2022 15:42:02 -0400 (EDT)
Received: from out1.migadu.com (out1.migadu.com [91.121.223.63])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B41984B9A9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Aug 2022 15:42:02 -0400 (EDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1661888521;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=Xy7sGLxjAT/lUb6VxuHy5G9CxzSH9danSLyrRA8SNo8=;
 b=YWhPezTnq9e2aJBPAISR7BKtVevt4gSoGZZr0fvBiC9+/vCIdM0mN6owEMQrvhKDyeCros
 rxi1MU/gBeGwWVYGk8vk0QtJi6NA82RCdujVR8y3X2gzYtCNz4LzR+OQMJISEBRDYdvGo+
 rA6kt1uyY+JJwu/CQ9MKOfx7IuqPbyE=
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Quentin Perret <qperret@google.com>, Ricardo Koller <ricarkol@google.com>,
 Reiji Watanabe <reijiw@google.com>, David Matlack <dmatlack@google.com>,
 Ben Gardon <bgardon@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Gavin Shan <gshan@redhat.com>, Peter Xu <peterx@redhat.com>,
 Sean Christopherson <seanjc@google.com>,
 Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 03/14] KVM: arm64: Directly read owner id field in
 stage2_pte_is_counted()
Date: Tue, 30 Aug 2022 19:41:21 +0000
Message-Id: <20220830194132.962932-4-oliver.upton@linux.dev>
In-Reply-To: <20220830194132.962932-1-oliver.upton@linux.dev>
References: <20220830194132.962932-1-oliver.upton@linux.dev>
MIME-Version: 1.0
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
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

A subsequent change to KVM will make use of additional bits in invalid
ptes. Prepare for said change by explicitly checking the valid bit and
owner fields in stage2_pte_is_counted()

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/hyp/pgtable.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 5c0c8028d71c..b6ce786ae570 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -172,6 +172,11 @@ static kvm_pte_t kvm_init_invalid_leaf_owner(u8 owner_id)
 	return FIELD_PREP(KVM_INVALID_PTE_OWNER_MASK, owner_id);
 }
 
+static u8 kvm_invalid_pte_owner(kvm_pte_t pte)
+{
+	return FIELD_GET(KVM_INVALID_PTE_OWNER_MASK, pte);
+}
+
 static int kvm_pgtable_visitor_cb(struct kvm_pgtable_walk_data *data, u64 addr,
 				  u32 level, kvm_pte_t *ptep,
 				  enum kvm_pgtable_walk_flags flag)
@@ -679,7 +684,7 @@ static bool stage2_pte_is_counted(kvm_pte_t pte)
 	 * encode ownership of a page to another entity than the page-table
 	 * owner, whose id is 0.
 	 */
-	return !!pte;
+	return kvm_pte_valid(pte) || kvm_invalid_pte_owner(pte);
 }
 
 static void stage2_put_pte(kvm_pte_t *ptep, struct kvm_s2_mmu *mmu, u64 addr,
-- 
2.37.2.672.g94769d06f0-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
