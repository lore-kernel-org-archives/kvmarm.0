Return-Path: <SRS0=IDfC=UT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E15AC48BE3
	for <kvmarm@archiver.kernel.org>; Thu, 20 Jun 2019 13:06:46 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 143762082C
	for <kvmarm@archiver.kernel.org>; Thu, 20 Jun 2019 13:06:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 143762082C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BF89A4A50B;
	Thu, 20 Jun 2019 09:06:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QGedESgwUvwk; Thu, 20 Jun 2019 09:06:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A2D214A52A;
	Thu, 20 Jun 2019 09:06:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6D0AF4A4F3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Jun 2019 09:06:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vpaYnlL51Ih6 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 20 Jun 2019 09:06:42 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 160804A4CA
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Jun 2019 09:06:42 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C32D3360;
 Thu, 20 Jun 2019 06:06:41 -0700 (PDT)
Received: from e108454-lin.cambridge.arm.com (e108454-lin.cambridge.arm.com
 [10.1.196.50])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6ED513F718;
 Thu, 20 Jun 2019 06:06:40 -0700 (PDT)
From: Julien Grall <julien.grall@arm.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu
Subject: [RFC v2 12/14] arm64/lib: asid: Allow user to update the context
 under the lock
Date: Thu, 20 Jun 2019 14:06:06 +0100
Message-Id: <20190620130608.17230-13-julien.grall@arm.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190620130608.17230-1-julien.grall@arm.com>
References: <20190620130608.17230-1-julien.grall@arm.com>
Cc: marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com,
 Julien Grall <julien.grall@arm.com>
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
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Some users of the ASID allocator (e.g VMID) will require to update the
context when a new ASID is generated. This has to be protected by a lock
to prevent concurrent modification.

Rather than introducing yet another lock, it is possible to re-use the
allocator lock for that purpose. This patch introduces a new callback
that will be call when updating the context.

Signed-off-by: Julien Grall <julien.grall@arm.com>
---
 arch/arm64/include/asm/lib_asid.h | 12 ++++++++----
 arch/arm64/lib/asid.c             | 10 ++++++++--
 arch/arm64/mm/context.c           | 11 ++++++++---
 3 files changed, 24 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/include/asm/lib_asid.h b/arch/arm64/include/asm/lib_asid.h
index c18e9eca500e..810f0b05a8da 100644
--- a/arch/arm64/include/asm/lib_asid.h
+++ b/arch/arm64/include/asm/lib_asid.h
@@ -23,6 +23,8 @@ struct asid_info
 	unsigned int		ctxt_shift;
 	/* Callback to locally flush the context. */
 	void			(*flush_cpu_ctxt_cb)(void);
+	/* Callback to call when a context is updated */
+	void			(*update_ctxt_cb)(void *ctxt);
 };
 
 #define NUM_ASIDS(info)			(1UL << ((info)->bits))
@@ -31,7 +33,7 @@ struct asid_info
 #define active_asid(info, cpu)	*per_cpu_ptr((info)->active, cpu)
 
 void asid_new_context(struct asid_info *info, atomic64_t *pasid,
-		      unsigned int cpu);
+		      unsigned int cpu, void *ctxt);
 
 /*
  * Check the ASID is still valid for the context. If not generate a new ASID.
@@ -40,7 +42,8 @@ void asid_new_context(struct asid_info *info, atomic64_t *pasid,
  * @cpu: current CPU ID. Must have been acquired throught get_cpu()
  */
 static inline void asid_check_context(struct asid_info *info,
-				      atomic64_t *pasid, unsigned int cpu)
+				       atomic64_t *pasid, unsigned int cpu,
+				       void *ctxt)
 {
 	u64 asid, old_active_asid;
 
@@ -67,11 +70,12 @@ static inline void asid_check_context(struct asid_info *info,
 				     old_active_asid, asid))
 		return;
 
-	asid_new_context(info, pasid, cpu);
+	asid_new_context(info, pasid, cpu, ctxt);
 }
 
 int asid_allocator_init(struct asid_info *info,
 			u32 bits, unsigned int asid_per_ctxt,
-			void (*flush_cpu_ctxt_cb)(void));
+			void (*flush_cpu_ctxt_cb)(void),
+			void (*update_ctxt_cb)(void *ctxt));
 
 #endif
diff --git a/arch/arm64/lib/asid.c b/arch/arm64/lib/asid.c
index 7252e4fdd5e9..dd2c6e4c1ff0 100644
--- a/arch/arm64/lib/asid.c
+++ b/arch/arm64/lib/asid.c
@@ -130,9 +130,10 @@ static u64 new_context(struct asid_info *info, atomic64_t *pasid)
  * @pasid: Pointer to the current ASID batch allocated. It will be updated
  * with the new ASID batch.
  * @cpu: current CPU ID. Must have been acquired through get_cpu()
+ * @ctxt: Context to update when calling update_context
  */
 void asid_new_context(struct asid_info *info, atomic64_t *pasid,
-		      unsigned int cpu)
+		      unsigned int cpu, void *ctxt)
 {
 	unsigned long flags;
 	u64 asid;
@@ -149,6 +150,9 @@ void asid_new_context(struct asid_info *info, atomic64_t *pasid,
 		info->flush_cpu_ctxt_cb();
 
 	atomic64_set(&active_asid(info, cpu), asid);
+
+	info->update_ctxt_cb(ctxt);
+
 	raw_spin_unlock_irqrestore(&info->lock, flags);
 }
 
@@ -163,11 +167,13 @@ void asid_new_context(struct asid_info *info, atomic64_t *pasid,
  */
 int asid_allocator_init(struct asid_info *info,
 			u32 bits, unsigned int asid_per_ctxt,
-			void (*flush_cpu_ctxt_cb)(void))
+			void (*flush_cpu_ctxt_cb)(void),
+			void (*update_ctxt_cb)(void *ctxt))
 {
 	info->bits = bits;
 	info->ctxt_shift = ilog2(asid_per_ctxt);
 	info->flush_cpu_ctxt_cb = flush_cpu_ctxt_cb;
+	info->update_ctxt_cb = update_ctxt_cb;
 	/*
 	 * Expect allocation after rollover to fail if we don't have at least
 	 * one more ASID than CPUs. ASID #0 is always reserved.
diff --git a/arch/arm64/mm/context.c b/arch/arm64/mm/context.c
index b745cf356fe1..527ea82983d7 100644
--- a/arch/arm64/mm/context.c
+++ b/arch/arm64/mm/context.c
@@ -82,7 +82,7 @@ void check_and_switch_context(struct mm_struct *mm, unsigned int cpu)
 	if (system_supports_cnp())
 		cpu_set_reserved_ttbr0();
 
-	asid_check_context(&asid_info, &mm->context.id, cpu);
+	asid_check_context(&asid_info, &mm->context.id, cpu, mm);
 
 	arm64_apply_bp_hardening();
 
@@ -108,12 +108,17 @@ static void asid_flush_cpu_ctxt(void)
 	local_flush_tlb_all();
 }
 
+static void asid_update_ctxt(void *ctxt)
+{
+	/* Nothing to do */
+}
+
 static int asids_init(void)
 {
 	u32 bits = get_cpu_asid_bits();
 
-	if (!asid_allocator_init(&asid_info, bits, ASID_PER_CONTEXT,
-				 asid_flush_cpu_ctxt))
+	if (asid_allocator_init(&asid_info, bits, ASID_PER_CONTEXT,
+				asid_flush_cpu_ctxt, asid_update_ctxt))
 		panic("Unable to initialize ASID allocator for %lu ASIDs\n",
 		      NUM_ASIDS(&asid_info));
 
-- 
2.11.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
