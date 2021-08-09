Return-Path: <SRS0=yt8/=NA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77F4EC4320E
	for <kvmarm@archiver.kernel.org>; Mon,  9 Aug 2021 15:25:22 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1497E61056
	for <kvmarm@archiver.kernel.org>; Mon,  9 Aug 2021 15:25:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 1497E61056
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AACEA4A4E5;
	Mon,  9 Aug 2021 11:25:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id C-S-JW3xvKYf; Mon,  9 Aug 2021 11:25:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 070F04B0FD;
	Mon,  9 Aug 2021 11:25:18 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1DFFF4B0FA
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Aug 2021 11:25:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MI9lQb6K+Bh1 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Aug 2021 11:25:16 -0400 (EDT)
Received: from mail-qv1-f74.google.com (mail-qv1-f74.google.com
 [209.85.219.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id ECAB840856
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Aug 2021 11:25:15 -0400 (EDT)
Received: by mail-qv1-f74.google.com with SMTP id
 w10-20020a0cfc4a0000b0290335dd22451dso12596357qvp.5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 Aug 2021 08:25:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=4CFmU9uB5cuxc2lPCoWChXDNr9f3K+SqIKdnjLv1P4s=;
 b=rZmm2VKnjSmuiIf5p19o76FrNYszuOISRqkab3N4YFD95ogVFJvhagSQdpHXMeyhyj
 c3A82CuZtPTSFGFh2BXtGtUxrxi+jv2tB4LAp9D4hIFry+Hza8zHQht3NLujuVS1Ibus
 92eAwBDgemHLSymFMTKMs6lCfK4aAEP3jvkHWkXoLKMUSzIQUgc1+A9Ex2PaRj+rpOb9
 rxDag7IKYRu/MIgk/849635PQ18cH9sGG+H1T5zF/KKhXHTs5KpPyb2wXNjdavHHI1KM
 y/oFj0sH5zDEHl5qt/kGTjIthWR1z2MGqphl5V8yT7U28ZnIoRYxuG0VWw9zZDJSn9wM
 UdoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=4CFmU9uB5cuxc2lPCoWChXDNr9f3K+SqIKdnjLv1P4s=;
 b=Ka/03/l5Biq90IDMaG+NOzbZ6CligBl3P3rwijfQsQCNu1yV9IphTn3Co479eB/Vg8
 ne76ec5FO+pQHhDSR64DATB7wtQquFMhBOydKU6B3C3I9j54EjKNqOCWyIXMoLpwJJ0N
 YrMwnwpqgPindwv/nYA9ybcs0t82vArpMFMTt4FzQV0+TGcMQiQTnPZzFBZYccezAnru
 5PDQUzO4wZ5jzQWAvyJgEJ1TEPCE5BTmAF7+3tgjQ9wrT1FcKQAtbTqAZX7ADRypsxh9
 Q2NRE4n9rJkI5BngLZRgeGkc4FV3Mgpi/+3aYFYBhRCIL4GeS885K61j4+5fwECXUZac
 KZ6A==
X-Gm-Message-State: AOAM532buvvEFxNEKoGsSaDP7uP20VA5yZAdzymtJaJffkSccrGFa3BZ
 wdzYko5SOkG6tP+qZfg8r/uZ0epuaEe8
X-Google-Smtp-Source: ABdhPJxlnJqrt/Vc6kgjycoOm+7KHQ8sxsdJFc8/TA+ubWDblTmiAVGwH3I7qjBHoAKuZruQygdEooL2YeNk
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:b0e8:d460:758b:a0ae])
 (user=qperret job=sendgmr) by 2002:a05:6214:10c8:: with SMTP id
 r8mr24109684qvs.28.1628522715621; Mon, 09 Aug 2021 08:25:15 -0700 (PDT)
Date: Mon,  9 Aug 2021 16:24:38 +0100
In-Reply-To: <20210809152448.1810400-1-qperret@google.com>
Message-Id: <20210809152448.1810400-12-qperret@google.com>
Mime-Version: 1.0
References: <20210809152448.1810400-1-qperret@google.com>
X-Mailer: git-send-email 2.32.0.605.g8dce9f2422-goog
Subject: [PATCH v4 11/21] KVM: arm64: Allow populating software bits
From: Quentin Perret <qperret@google.com>
To: maz@kernel.org, james.morse@arm.com, alexandru.elisei@arm.com, 
 suzuki.poulose@arm.com, catalin.marinas@arm.com, will@kernel.org
Cc: qwandor@google.com, linux-kernel@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 kernel-team@android.com
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

Introduce infrastructure allowing to manipulate software bits in stage-1
and stage-2 page-tables using additional entries in the kvm_pgtable_prot
enum.

This is heavily inspired by Marc's implementation of a similar feature
in the NV patch series, but adapted to allow stage-1 changes as well:

  https://lore.kernel.org/kvmarm/20210510165920.1913477-56-maz@kernel.org/

Suggested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/include/asm/kvm_pgtable.h | 12 +++++++++++-
 arch/arm64/kvm/hyp/pgtable.c         |  5 +++++
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 2c090b0eee77..ff9d52f8073a 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -121,6 +121,10 @@ enum kvm_pgtable_stage2_flags {
  * @KVM_PGTABLE_PROT_W:		Write permission.
  * @KVM_PGTABLE_PROT_R:		Read permission.
  * @KVM_PGTABLE_PROT_DEVICE:	Device attributes.
+ * @KVM_PGTABLE_PROT_SW0:	Software bit 0.
+ * @KVM_PGTABLE_PROT_SW1:	Software bit 1.
+ * @KVM_PGTABLE_PROT_SW2:	Software bit 2.
+ * @KVM_PGTABLE_PROT_SW3:	Software bit 3.
  */
 enum kvm_pgtable_prot {
 	KVM_PGTABLE_PROT_X			= BIT(0),
@@ -128,6 +132,11 @@ enum kvm_pgtable_prot {
 	KVM_PGTABLE_PROT_R			= BIT(2),
 
 	KVM_PGTABLE_PROT_DEVICE			= BIT(3),
+
+	KVM_PGTABLE_PROT_SW0			= BIT(55),
+	KVM_PGTABLE_PROT_SW1			= BIT(56),
+	KVM_PGTABLE_PROT_SW2			= BIT(57),
+	KVM_PGTABLE_PROT_SW3			= BIT(58),
 };
 
 #define KVM_PGTABLE_PROT_RW	(KVM_PGTABLE_PROT_R | KVM_PGTABLE_PROT_W)
@@ -420,7 +429,8 @@ kvm_pte_t kvm_pgtable_stage2_mkold(struct kvm_pgtable *pgt, u64 addr);
  * If there is a valid, leaf page-table entry used to translate @addr, then
  * relax the permissions in that entry according to the read, write and
  * execute permissions specified by @prot. No permissions are removed, and
- * TLB invalidation is performed after updating the entry.
+ * TLB invalidation is performed after updating the entry. Software bits cannot
+ * be set or cleared using kvm_pgtable_stage2_relax_perms().
  *
  * Return: 0 on success, negative error code on failure.
  */
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index e25d829587b9..cff744136044 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -357,6 +357,7 @@ static int hyp_set_prot_attr(enum kvm_pgtable_prot prot, kvm_pte_t *ptep)
 	attr |= FIELD_PREP(KVM_PTE_LEAF_ATTR_LO_S1_AP, ap);
 	attr |= FIELD_PREP(KVM_PTE_LEAF_ATTR_LO_S1_SH, sh);
 	attr |= KVM_PTE_LEAF_ATTR_LO_S1_AF;
+	attr |= prot & KVM_PTE_LEAF_ATTR_HI_SW;
 	*ptep = attr;
 
 	return 0;
@@ -558,6 +559,7 @@ static int stage2_set_prot_attr(struct kvm_pgtable *pgt, enum kvm_pgtable_prot p
 
 	attr |= FIELD_PREP(KVM_PTE_LEAF_ATTR_LO_S2_SH, sh);
 	attr |= KVM_PTE_LEAF_ATTR_LO_S2_AF;
+	attr |= prot & KVM_PTE_LEAF_ATTR_HI_SW;
 	*ptep = attr;
 
 	return 0;
@@ -1025,6 +1027,9 @@ int kvm_pgtable_stage2_relax_perms(struct kvm_pgtable *pgt, u64 addr,
 	u32 level;
 	kvm_pte_t set = 0, clr = 0;
 
+	if (prot & KVM_PTE_LEAF_ATTR_HI_SW)
+		return -EINVAL;
+
 	if (prot & KVM_PGTABLE_PROT_R)
 		set |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R;
 
-- 
2.32.0.605.g8dce9f2422-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
