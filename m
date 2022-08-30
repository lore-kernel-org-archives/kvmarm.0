Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A227C0502C
	for <kvmarm@archiver.kernel.org>; Tue, 30 Aug 2022 19:42:23 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 265944B9A9;
	Tue, 30 Aug 2022 15:42:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id p74RCXmrQy1N; Tue, 30 Aug 2022 15:42:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BCE194B98D;
	Tue, 30 Aug 2022 15:42:21 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 168E24B98A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Aug 2022 15:42:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id q8Af5pMQgsU3 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 30 Aug 2022 15:42:19 -0400 (EDT)
Received: from out1.migadu.com (out1.migadu.com [91.121.223.63])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D022F4B624
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Aug 2022 15:42:18 -0400 (EDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1661888538;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=fQeI6zpamXufaG6UtIBPMTAxGRkDzaVjmSqbL7fqmA4=;
 b=D9h9JwBXgp4fk3oXEgNrHS+gL2418x+oOQGDIhu15jN7Y5D9JRtyE3eEsyuBeRj9CrBaD2
 A90lb39Q6XzojxcGyb2Go/11MI9HEgqpfAGScUJOzE/yMG2o6XrcZg782/2VeGVGKzCubS
 V8ZWLLP9SU9I0vP7yG914m7jhzl30+0=
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
Subject: [PATCH 07/14] KVM: arm64: Document behavior of pgtable visitor
 callback
Date: Tue, 30 Aug 2022 19:41:25 +0000
Message-Id: <20220830194132.962932-8-oliver.upton@linux.dev>
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

The argument list to kvm_pgtable_visitor_fn_t has gotten rather long.
Additionally, @old serves as both an input and output parameter, which
isn't easily discerned from the declaration alone.

Document the meaning of the visitor callback arguments and the
conditions under which @old was written to.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_pgtable.h | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 47920ae3f7e7..78fbb7be1af6 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -194,6 +194,22 @@ enum kvm_pgtable_walk_flags {
 	KVM_PGTABLE_WALK_TABLE_POST		= BIT(2),
 };
 
+/**
+ * kvm_pgtable_visitor_fn_t - Page table traversal callback for visiting a PTE.
+ * @addr:	Input address (IA) mapped by the PTE.
+ * @end:	IA corresponding to the end of the page table traversal range.
+ * @ptep:	Pointer to the PTE.
+ * @old:	Value of the PTE observed by the visitor. Also used as an output
+ *		parameter for returning the new PTE value.
+ * @flag:	Flag identifying the entry type visited.
+ * @arg:	Argument passed to the callback function.
+ *
+ * Callback function signature invoked during page table traversal. Optionally
+ * returns the new value of the PTE via @old if the new value requires further
+ * traversal (i.e. installing a new table).
+ *
+ * Return: 0 on success, negative error code on failure.
+ */
 typedef int (*kvm_pgtable_visitor_fn_t)(u64 addr, u64 end, u32 level,
 					kvm_pte_t *ptep, kvm_pte_t *old,
 					enum kvm_pgtable_walk_flags flag,
-- 
2.37.2.672.g94769d06f0-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
