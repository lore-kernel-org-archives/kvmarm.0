Return-Path: <SRS0=HOrx=GL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCB3AC433DB
	for <kvmarm@archiver.kernel.org>; Fri,  8 Jan 2021 12:15:42 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 44E272399A
	for <kvmarm@archiver.kernel.org>; Fri,  8 Jan 2021 12:15:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 44E272399A
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D77344B415;
	Fri,  8 Jan 2021 07:15:41 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 00UpM-c3qsfQ; Fri,  8 Jan 2021 07:15:40 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 965CF4B3E1;
	Fri,  8 Jan 2021 07:15:40 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 903EC4B268
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Jan 2021 07:15:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JjBpsdRPXjo7 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Jan 2021 07:15:38 -0500 (EST)
Received: from mail-qv1-f73.google.com (mail-qv1-f73.google.com
 [209.85.219.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 917464B403
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Jan 2021 07:15:37 -0500 (EST)
Received: by mail-qv1-f73.google.com with SMTP id m8so8120314qvk.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 08 Jan 2021 04:15:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=unx+w/DYhIKkLLjEFZ0ZjVS7ADRwuEnqRq53UmcJNco=;
 b=siB1XHnnTlEHKkQZGDr8YyjzyGhAZrCxbjSbr5CQNJ9d5DIj1wZzvNJWZGJt3xADr7
 RPbPqVYK7G/VjHQbbDFy9FHLUf8EvAZ37P9j+wpxd0ndJ+tgVdfgIKCOMtA/3mGyqOwg
 m/00VMN9dan8SnkxyGgNCyaQtGwDsNJrwgBtTpJWAvLEnqEYh6rBD8HUvXsNXLHMjD8v
 CrzfgYDC4I+fG7aQ12H1g9qmiXCJAI//rxlzo/WqKUuMkqjSOJ1fiiDhZeIcQFkHbRcQ
 OcOGC7EQ7FnqzdklWauf0h4lPGJW8VoDERKaWoBtCaZRuVy8Tp2QyWRbTfRcnGDltlD0
 OOCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=unx+w/DYhIKkLLjEFZ0ZjVS7ADRwuEnqRq53UmcJNco=;
 b=trgK0iqy0sWd2Co3JtR0J+WqPt9HOfQB+gfbQf4yvyUwRg6KQOCn8nz8M3tS+kywH/
 /j/1IaOOoloxXv0ZsM/8Xu58cwgyxOvNRbgQKzTSkNoH+dfctgQKYa3/wg8fFxhrU+xV
 IIFL0qw0DJQvPLV/LWXT1iq37ctbauKOxFDlW92T6u4yeQIgAYaLTsylzaFtikJ1rlQ9
 Shv8xbKUdltfeLo04FybI9kgrfUQ9C3kuhOiWrvgoyStQT5rRJZHDsgy1/lw1VAHBt0l
 0RYP7e0Mzio/3Y0VSH76K2fIM+VZgPGzsABUFB8Fn35iSMex2cOPB8B8/zqM4vZjpZZ4
 6xYw==
X-Gm-Message-State: AOAM530T5pkPXMlaGTA6eiIdFHdYcdt0DRdTKk/X+riEOFxoCuDWEIl2
 dM+FAQhK2VRY6QkEN+m2gQWiqn6KNvDd
X-Google-Smtp-Source: ABdhPJzbPjW7FIolFk3swj7ZTloyVho84hOEZCHjuWJg3S9PMHPt+3WGf+xElVymEqN4wYzsD6qCiUsy42cO
X-Received: from r2d2-qp.c.googlers.com
 ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:a05:6214:1230:: with SMTP id
 p16mr3316335qvv.47.1610108137203; Fri, 08 Jan 2021 04:15:37 -0800 (PST)
Date: Fri,  8 Jan 2021 12:15:03 +0000
In-Reply-To: <20210108121524.656872-1-qperret@google.com>
Message-Id: <20210108121524.656872-6-qperret@google.com>
Mime-Version: 1.0
References: <20210108121524.656872-1-qperret@google.com>
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
Subject: [RFC PATCH v2 05/26] KVM: arm64: Avoid free_page() in page-table
 allocator
From: Quentin Perret <qperret@google.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
 Julien Thierry <julien.thierry.kdev@gmail.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Rob Herring <robh+dt@kernel.org>, Frank Rowand <frowand.list@gmail.com>
Cc: devicetree@vger.kernel.org, android-kvm@google.com,
 linux-kernel@vger.kernel.org, Fuad Tabba <tabba@google.com>,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

Currently, the KVM page-table allocator uses a mix of put_page() and
free_page() calls depending on the context even though page-allocation
is always achieved using variants of __get_free_page().

Make the code consitent by using put_page() throughout, and reduce the
memory management API surface used by the page-table code. This will
ease factoring out page-alloction from pgtable.c, which is a
pre-requisite to creating page-tables at EL2.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/pgtable.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 0271b4a3b9fe..d7122c5eac24 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -410,7 +410,7 @@ int kvm_pgtable_hyp_init(struct kvm_pgtable *pgt, u32 va_bits)
 static int hyp_free_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 			   enum kvm_pgtable_walk_flags flag, void * const arg)
 {
-	free_page((unsigned long)kvm_pte_follow(*ptep));
+	put_page(virt_to_page(kvm_pte_follow(*ptep)));
 	return 0;
 }
 
@@ -422,7 +422,7 @@ void kvm_pgtable_hyp_destroy(struct kvm_pgtable *pgt)
 	};
 
 	WARN_ON(kvm_pgtable_walk(pgt, 0, BIT(pgt->ia_bits), &walker));
-	free_page((unsigned long)pgt->pgd);
+	put_page(virt_to_page(pgt->pgd));
 	pgt->pgd = NULL;
 }
 
@@ -551,7 +551,7 @@ static int stage2_map_walk_table_post(u64 addr, u64 end, u32 level,
 	if (!data->anchor)
 		return 0;
 
-	free_page((unsigned long)kvm_pte_follow(*ptep));
+	put_page(virt_to_page(kvm_pte_follow(*ptep)));
 	put_page(virt_to_page(ptep));
 
 	if (data->anchor == ptep) {
@@ -674,7 +674,7 @@ static int stage2_unmap_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 	}
 
 	if (childp)
-		free_page((unsigned long)childp);
+		put_page(virt_to_page(childp));
 
 	return 0;
 }
@@ -871,7 +871,7 @@ static int stage2_free_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 	put_page(virt_to_page(ptep));
 
 	if (kvm_pte_table(pte, level))
-		free_page((unsigned long)kvm_pte_follow(pte));
+		put_page(virt_to_page(kvm_pte_follow(pte)));
 
 	return 0;
 }
-- 
2.30.0.284.gd98b1dd5eaa7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
