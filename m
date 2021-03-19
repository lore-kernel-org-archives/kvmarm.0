Return-Path: <SRS0=QSSN=IR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1430C433E6
	for <kvmarm@archiver.kernel.org>; Fri, 19 Mar 2021 10:02:59 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3885564F1F
	for <kvmarm@archiver.kernel.org>; Fri, 19 Mar 2021 10:02:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3885564F1F
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B4F714B760;
	Fri, 19 Mar 2021 06:02:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id mITAuU1onF1A; Fri, 19 Mar 2021 06:02:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9B4CF4B73C;
	Fri, 19 Mar 2021 06:02:57 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 924A64B682
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Mar 2021 06:02:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EgdGaL0EgjnT for <kvmarm@lists.cs.columbia.edu>;
 Fri, 19 Mar 2021 06:02:55 -0400 (EDT)
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com
 [209.85.221.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 746CF4B72A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Mar 2021 06:02:55 -0400 (EDT)
Received: by mail-wr1-f73.google.com with SMTP id r6so8311946wrt.20
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Mar 2021 03:02:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=az3qu5AfEWynjCbFKTE0XZEp3dT+VbY/5SeZh8Qx1Io=;
 b=cxbBujXKeT7rjNVAEodiKZztncnTfQVckR4v8vwFPMKDrgrm1aS5gn6bsHGTh26ozr
 5NXwVfmV3JBwX9v2RgOlXugAGAj22i37MNTbOcZwFdW8Q8Q3L9fEdOvqiG7ablWqHS7F
 ZKZmf+usDnAKHy69Fovh8Oc7K0mZ1R7Kjz4m80j63v8xbEYNJT216buBFJQTuizAJmUs
 jBv+o9Q9+p3iUJ7tcHdP1AhV1463HK3ZlBCTE/xNJz3FJn2A+ruZ+LfKIQ85QUJhuulQ
 /P8bBvB0pH38dveW/rwtcRUU+iIcl/0fvhnTlyUEAkdskj8jaK4CCHehnwAvL7WIlDnt
 ydnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=az3qu5AfEWynjCbFKTE0XZEp3dT+VbY/5SeZh8Qx1Io=;
 b=WAzrbNQHjQ1xzPFUCcqy5v9ufwnRE9NG0j2y9eeaBIxKYX8MVeRlKLrwaMDHEy3Qcd
 Oeyo0UdIPStipPJ6d9Zd7igxT3FG7LScd3bQLfZZUk6vuT2g2BO+IhbmNat3e4KpzqyC
 AOdC21lNARAPqBZsF1TA/CJ/PkTnd5TyaakE1sWJVaK9njg9ygN9/Xs/iwIDNM4LFZeO
 CmiaJDD5QksZw3f9N3VUmjSYqAjhqtmDKk48Z6XNsrvKv19vMuSigUGfh0FP7H7jk1dC
 h/5dwg5d0qqMKvKGXf6LQeEdkojAqPVtJAz6eUhh6ZfcVKGGiJCZMhl10/M0e3ku7heD
 6OOg==
X-Gm-Message-State: AOAM530aEzj1KZ/p83u6r09nbFi8c3AcglOjr2kR71qPv1QCwaXjMhGc
 bNBMLV3Tpzrul/+leTOIjuBMoUxqbcrH
X-Google-Smtp-Source: ABdhPJw0KphugbkLaQeWstGqY/zCm8YSOnc3bOjtBswO1zBwU/9BG0fClCmUPZTFDDpqAABcRYc9sN+uHyq/
X-Received: from r2d2-qp.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:a1c:e18b:: with SMTP id
 y133mr2987504wmg.22.1616148174537; Fri, 19 Mar 2021 03:02:54 -0700 (PDT)
Date: Fri, 19 Mar 2021 10:01:38 +0000
In-Reply-To: <20210319100146.1149909-1-qperret@google.com>
Message-Id: <20210319100146.1149909-31-qperret@google.com>
Mime-Version: 1.0
References: <20210319100146.1149909-1-qperret@google.com>
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
Subject: [PATCH v6 30/38] KVM: arm64: Refactor the *_map_set_prot_attr()
 helpers
From: Quentin Perret <qperret@google.com>
To: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
Cc: android-kvm@google.com, seanjc@google.com, mate.toth-pal@arm.com,
 linux-kernel@vger.kernel.org, robh+dt@kernel.org, tabba@google.com,
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

In order to ease their re-use in other code paths, refactor the
*_map_set_prot_attr() helpers to not depend on a map_data struct.
No functional change intended.

Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/pgtable.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index eefb226e1d1e..f4a514a2e7ae 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -325,8 +325,7 @@ struct hyp_map_data {
 	struct kvm_pgtable_mm_ops	*mm_ops;
 };
 
-static int hyp_map_set_prot_attr(enum kvm_pgtable_prot prot,
-				 struct hyp_map_data *data)
+static int hyp_set_prot_attr(enum kvm_pgtable_prot prot, kvm_pte_t *ptep)
 {
 	bool device = prot & KVM_PGTABLE_PROT_DEVICE;
 	u32 mtype = device ? MT_DEVICE_nGnRE : MT_NORMAL;
@@ -351,7 +350,8 @@ static int hyp_map_set_prot_attr(enum kvm_pgtable_prot prot,
 	attr |= FIELD_PREP(KVM_PTE_LEAF_ATTR_LO_S1_AP, ap);
 	attr |= FIELD_PREP(KVM_PTE_LEAF_ATTR_LO_S1_SH, sh);
 	attr |= KVM_PTE_LEAF_ATTR_LO_S1_AF;
-	data->attr = attr;
+	*ptep = attr;
+
 	return 0;
 }
 
@@ -408,7 +408,7 @@ int kvm_pgtable_hyp_map(struct kvm_pgtable *pgt, u64 addr, u64 size, u64 phys,
 		.arg	= &map_data,
 	};
 
-	ret = hyp_map_set_prot_attr(prot, &map_data);
+	ret = hyp_set_prot_attr(prot, &map_data.attr);
 	if (ret)
 		return ret;
 
@@ -501,8 +501,7 @@ u64 kvm_get_vtcr(u64 mmfr0, u64 mmfr1, u32 phys_shift)
 	return vtcr;
 }
 
-static int stage2_map_set_prot_attr(enum kvm_pgtable_prot prot,
-				    struct stage2_map_data *data)
+static int stage2_set_prot_attr(enum kvm_pgtable_prot prot, kvm_pte_t *ptep)
 {
 	bool device = prot & KVM_PGTABLE_PROT_DEVICE;
 	kvm_pte_t attr = device ? PAGE_S2_MEMATTR(DEVICE_nGnRE) :
@@ -522,7 +521,8 @@ static int stage2_map_set_prot_attr(enum kvm_pgtable_prot prot,
 
 	attr |= FIELD_PREP(KVM_PTE_LEAF_ATTR_LO_S2_SH, sh);
 	attr |= KVM_PTE_LEAF_ATTR_LO_S2_AF;
-	data->attr = attr;
+	*ptep = attr;
+
 	return 0;
 }
 
@@ -742,7 +742,7 @@ int kvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
 		.arg		= &map_data,
 	};
 
-	ret = stage2_map_set_prot_attr(prot, &map_data);
+	ret = stage2_set_prot_attr(prot, &map_data.attr);
 	if (ret)
 		return ret;
 
-- 
2.31.0.rc2.261.g7f71774620-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
