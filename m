Return-Path: <SRS0=a/wb=IA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5D88C433DB
	for <kvmarm@archiver.kernel.org>; Tue,  2 Mar 2021 15:01:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8006D64F3B
	for <kvmarm@archiver.kernel.org>; Tue,  2 Mar 2021 15:01:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8006D64F3B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2F62D4B698;
	Tue,  2 Mar 2021 10:01:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id H4-hSY78Ng8F; Tue,  2 Mar 2021 10:01:09 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1DF884B68C;
	Tue,  2 Mar 2021 10:01:09 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A8EA94B642
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Mar 2021 10:01:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id p6XGoqFRnejQ for <kvmarm@lists.cs.columbia.edu>;
 Tue,  2 Mar 2021 10:01:06 -0500 (EST)
Received: from mail-qk1-f202.google.com (mail-qk1-f202.google.com
 [209.85.222.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E9BB14B69C
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Mar 2021 10:01:05 -0500 (EST)
Received: by mail-qk1-f202.google.com with SMTP id i69so7291804qke.19
 for <kvmarm@lists.cs.columbia.edu>; Tue, 02 Mar 2021 07:01:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=fnu4kZLmantAPLgmfgZ7PZzVHqXbW8DjkSliDC/e8I8=;
 b=uUNW1RSwz/PPPl1Ua1IuQ64hOM0R+lTodrWU3UbAefyenAEai8RA0+im6R8w77uKKJ
 g4DVj/KqEe1TwMkcz/Ygt9jjIn5f38pgXuncyWnVA/+aa/N++uGeKO34r+o678oP9Mq8
 67RAjq0NNwnf+jsn3QGIHhc250LRidVe1EfBP+5OIoO/7rtNLutaZrtEM1c24NPrdROO
 AFGrLf0EhJQzjScHxY2yPE6vMV/MjHb4X61lyzoWiVZ4RX2UG8RcNll2OE8OrY1N1eKg
 6/SG5RQNSa0TOnAV1pRMMAOGJJqvxbtGjwYBUsH85FOGQKa/2mvXOYVgOo4Aa+FxfQOa
 yteA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=fnu4kZLmantAPLgmfgZ7PZzVHqXbW8DjkSliDC/e8I8=;
 b=JeMZgoOTqpo3uK9dUf8Skbu+g8aoSfkJFV66loxGmz9AsAzIPbfvCEMS21jcj2IOgc
 zG0xEWgnXuqwR3hWyptCUebrxcPikADNdokQ8sFQKHlqvyfWZK2ix4UAxqW6CBTAFVSn
 U6IuIPB+BERmj3eW1nqU5vt22s20nAMDIt8kTwtsJKSh7QEco6BEizlDhA3IF+7XnJuy
 3eSjpMVsOLOOrHTkpPIbetXiFg5+eW4lAmFUO10pJW6Gs8Qwur4NGzDDPnb8q9+LK0qs
 dEOItBozo3W/SVEc8b1h3gcba+yVZThrw9VPWcSSF9Mt8yP0Uj6JJWtlKyTJ9O2nVSAa
 vegQ==
X-Gm-Message-State: AOAM532h4BzGcndS2FgjcK7YHJdeQdEBXaQvXBNbkVAAOmg+MM7lFS9p
 BFB6wVr2DSGdJh5nMYM7fAj+lM6dY/Fy
X-Google-Smtp-Source: ABdhPJw8Dq6/V08jN1owoo4yABfxU5wp1FwJVtfeIaUa56rS2EjFaWfxxNpGQxARvmsP7DWrgv0nk/HKhje6
X-Received: from r2d2-qp.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:a0c:c78c:: with SMTP id
 k12mr3964748qvj.47.1614697265404; Tue, 02 Mar 2021 07:01:05 -0800 (PST)
Date: Tue,  2 Mar 2021 14:59:56 +0000
In-Reply-To: <20210302150002.3685113-1-qperret@google.com>
Message-Id: <20210302150002.3685113-27-qperret@google.com>
Mime-Version: 1.0
References: <20210302150002.3685113-1-qperret@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH v3 26/32] KVM: arm64: Introduce PROT_NONE mappings for stage 2
From: Quentin Perret <qperret@google.com>
To: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
Cc: android-kvm@google.com, seanjc@google.com, mate.toth-pal@arm.com,
 linux-kernel@vger.kernel.org, robh+dt@kernel.org,
 linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
 kvmarm@lists.cs.columbia.edu, tabba@google.com
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

Once we start unmapping portions of memory from the host stage 2 (such
as e.g. the hypervisor memory sections, or pages that belong to
protected guests), we will need a way to track page ownership. And
given that all mappings in the host stage 2 will be identity-mapped, we
can use the host stage 2 page-table itself as a simplistic rmap.

As a first step towards this, introduce a new protection attribute
in the stage 2 page table code, called KVM_PGTABLE_PROT_NONE, which
allows to annotate portions of the IPA space as inaccessible. For
simplicity, PROT_NONE mappings are created as invalid mappings with a
software bit set.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/include/asm/kvm_pgtable.h |  2 ++
 arch/arm64/kvm/hyp/pgtable.c         | 26 ++++++++++++++++++++++++--
 2 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 9935dbae2cc1..c9f6ed76e0ad 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -80,6 +80,7 @@ struct kvm_pgtable {
  * @KVM_PGTABLE_PROT_W:		Write permission.
  * @KVM_PGTABLE_PROT_R:		Read permission.
  * @KVM_PGTABLE_PROT_DEVICE:	Device attributes.
+ * @KVM_PGTABLE_PROT_NONE:	No permission.
  */
 enum kvm_pgtable_prot {
 	KVM_PGTABLE_PROT_X			= BIT(0),
@@ -87,6 +88,7 @@ enum kvm_pgtable_prot {
 	KVM_PGTABLE_PROT_R			= BIT(2),
 
 	KVM_PGTABLE_PROT_DEVICE			= BIT(3),
+	KVM_PGTABLE_PROT_NONE			= BIT(4),
 };
 
 #define PAGE_HYP		(KVM_PGTABLE_PROT_R | KVM_PGTABLE_PROT_W)
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index bdd6e3d4eeb6..8e7059fcfd40 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -48,6 +48,8 @@
 					 KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W | \
 					 KVM_PTE_LEAF_ATTR_HI_S2_XN)
 
+#define KVM_PTE_LEAF_SW_BIT_PROT_NONE	BIT(55)
+
 struct kvm_pgtable_walk_data {
 	struct kvm_pgtable		*pgt;
 	struct kvm_pgtable_walker	*walker;
@@ -120,6 +122,16 @@ static bool kvm_pte_valid(kvm_pte_t pte)
 	return pte & KVM_PTE_VALID;
 }
 
+static bool kvm_pte_prot_none(kvm_pte_t pte)
+{
+	return pte & KVM_PTE_LEAF_SW_BIT_PROT_NONE;
+}
+
+static inline bool stage2_is_permanent_mapping(kvm_pte_t pte)
+{
+	return kvm_pte_prot_none(pte);
+}
+
 static bool kvm_pte_table(kvm_pte_t pte, u32 level)
 {
 	if (level == KVM_PGTABLE_MAX_LEVELS - 1)
@@ -182,7 +194,8 @@ static kvm_pte_t kvm_init_valid_leaf_pte(u64 pa, kvm_pte_t attr, u32 level)
 
 	pte |= attr & (KVM_PTE_LEAF_ATTR_LO | KVM_PTE_LEAF_ATTR_HI);
 	pte |= FIELD_PREP(KVM_PTE_TYPE, type);
-	pte |= KVM_PTE_VALID;
+	if (!kvm_pte_prot_none(pte))
+		pte |= KVM_PTE_VALID;
 
 	return pte;
 }
@@ -317,7 +330,7 @@ static int hyp_map_set_prot_attr(enum kvm_pgtable_prot prot,
 	u32 ap = (prot & KVM_PGTABLE_PROT_W) ? KVM_PTE_LEAF_ATTR_LO_S1_AP_RW :
 					       KVM_PTE_LEAF_ATTR_LO_S1_AP_RO;
 
-	if (!(prot & KVM_PGTABLE_PROT_R))
+	if (!(prot & KVM_PGTABLE_PROT_R) || (prot & KVM_PGTABLE_PROT_NONE))
 		return -EINVAL;
 
 	if (prot & KVM_PGTABLE_PROT_X) {
@@ -489,6 +502,13 @@ static int stage2_map_set_prot_attr(enum kvm_pgtable_prot prot,
 			    PAGE_S2_MEMATTR(NORMAL);
 	u32 sh = KVM_PTE_LEAF_ATTR_LO_S2_SH_IS;
 
+	if (prot & KVM_PGTABLE_PROT_NONE) {
+		if (prot != KVM_PGTABLE_PROT_NONE)
+			return -EINVAL;
+		attr |= KVM_PTE_LEAF_SW_BIT_PROT_NONE;
+		goto out;
+	}
+
 	if (!(prot & KVM_PGTABLE_PROT_X))
 		attr |= KVM_PTE_LEAF_ATTR_HI_S2_XN;
 	else if (device)
@@ -502,6 +522,8 @@ static int stage2_map_set_prot_attr(enum kvm_pgtable_prot prot,
 
 	attr |= FIELD_PREP(KVM_PTE_LEAF_ATTR_LO_S2_SH, sh);
 	attr |= KVM_PTE_LEAF_ATTR_LO_S2_AF;
+
+out:
 	data->attr = attr;
 	return 0;
 }
-- 
2.30.1.766.gb4fecdf3b7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
