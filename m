Return-Path: <SRS0=VcQF=EX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2E4FC5519F
	for <kvmarm@archiver.kernel.org>; Tue, 17 Nov 2020 18:16:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 52451221FB
	for <kvmarm@archiver.kernel.org>; Tue, 17 Nov 2020 18:16:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="lNGeNA+z"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 52451221FB
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B5DA44B815;
	Tue, 17 Nov 2020 13:16:35 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id u2DhXWS2Va66; Tue, 17 Nov 2020 13:16:34 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D4C9E4B60C;
	Tue, 17 Nov 2020 13:16:33 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0CAD44B601
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Nov 2020 13:16:33 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lWgUr71Rfio2 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Nov 2020 13:16:31 -0500 (EST)
Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com
 [209.85.208.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C05944B83D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Nov 2020 13:16:31 -0500 (EST)
Received: by mail-ed1-f73.google.com with SMTP id f20so9970843edx.23
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Nov 2020 10:16:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=NAAv66aNUaltEt0mONTaW9BQUFoOFbMtL1i8hZDZuGs=;
 b=lNGeNA+zGfHwCaxYy0TrJSE1pl2oq3vvwMkxyPjR74vzMfWQMK1AHp2yCHnWdNCzXT
 SKJ0EyWSPKtiPU3Wh2G9XDOR5Y1cjmB7NRaJEONE0OXpf5p3XNmXzb90URbBEsu0OiMG
 KuXcCgSExkU9INz54eIwLV4KcmNLH/I9a0/DDvClup2XnMQzTU+/aAnYh5EhesGt/A7s
 qFxI65OjN5RHOHpWYJu5e+gN57HAzMgmW6bGR1CZy3/rKzcs8kJUQWw+4bFdSnzI54qo
 Py6oernt+i8KqdH6xBSdPV2GkNn6JTGC8WeFqhURYfWCHRkbLG4rP+XZYrsjO7KLM2cu
 CPCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=NAAv66aNUaltEt0mONTaW9BQUFoOFbMtL1i8hZDZuGs=;
 b=LqXHiIrDmsTIRKO+NoTuXLTnEQwgsSlYPS65OSRv2XdGIT4tFjOFTVHZh5E8C7bvjr
 lA5U2wuV8izj2TOs4JyrM6lrltC7nCoG0MqBjSLbXek97bzL+56L4c0bl05iu1VBRT9W
 E8gqBY6cg1sfzKv51Yv4jOr9XX58clGk73M09CCDAX8pnKsaNgbjOAf/DRKkocdw2vtC
 moGfypl+2soDXoOWpTjOYXlZLgjqUt5f9UMUzbRoe6jTx8qUj9DdDrv04VpMdpkKCdb2
 CM/msE+cGEMbLutG+dZG37/pa3p872p7AeFYulp4KlkeO9FwzZBYbnte5Y/MbUgo+Kou
 iTVA==
X-Gm-Message-State: AOAM53256FT85HAqThtIDmUoN3iQRMaROwRQojPu4cuvKECL1tr7VTbd
 FYhKNtbOvgMpf5E6iUxB1niELyKTOmnE
X-Google-Smtp-Source: ABdhPJwRKjykeVPq3BUBGAvQxs6YtxOlWZ1XX97g5ZVMcWNcwBONleeq9otY9dDDVDJIIzj6jTLQHcAJgIdB
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:f693:9fff:fef4:a7ef])
 (user=qperret job=sendgmr) by 2002:a17:906:6414:: with SMTP id
 d20mr19849332ejm.82.1605636990564; Tue, 17 Nov 2020 10:16:30 -0800 (PST)
Date: Tue, 17 Nov 2020 18:15:45 +0000
In-Reply-To: <20201117181607.1761516-1-qperret@google.com>
Message-Id: <20201117181607.1761516-6-qperret@google.com>
Mime-Version: 1.0
References: <20201117181607.1761516-1-qperret@google.com>
X-Mailer: git-send-email 2.29.2.299.gdc1121823c-goog
Subject: [RFC PATCH 05/27] KVM: arm64: Avoid free_page() in page-table
 allocator
From: Quentin Perret <qperret@google.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
 Julien Thierry <julien.thierry.kdev@gmail.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Rob Herring <robh+dt@kernel.org>, Frank Rowand <frowand.list@gmail.com>
Cc: "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE"
 <devicetree@vger.kernel.org>, android-kvm@google.com,
 open list <linux-kernel@vger.kernel.org>, kernel-team@android.com,
 "open list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <kvmarm@lists.cs.columbia.edu>,
 "moderated list:ARM64 PORT \(AARCH64 ARCHITECTURE\)"
 <linux-arm-kernel@lists.infradead.org>
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
2.29.2.299.gdc1121823c-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
