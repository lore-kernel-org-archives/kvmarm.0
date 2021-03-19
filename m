Return-Path: <SRS0=QSSN=IR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D035C433DB
	for <kvmarm@archiver.kernel.org>; Fri, 19 Mar 2021 10:03:09 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A05D064F78
	for <kvmarm@archiver.kernel.org>; Fri, 19 Mar 2021 10:03:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A05D064F78
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 556B04B72A;
	Fri, 19 Mar 2021 06:03:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id BKcExmrIdVMF; Fri, 19 Mar 2021 06:03:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 502864B781;
	Fri, 19 Mar 2021 06:03:07 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4435E4B739
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Mar 2021 06:03:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eS5AcVo6QtG9 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 19 Mar 2021 06:03:01 -0400 (EDT)
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com
 [209.85.128.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6B0DD4B6FD
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Mar 2021 06:03:01 -0400 (EDT)
Received: by mail-wm1-f74.google.com with SMTP id v5so12693607wml.9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Mar 2021 03:03:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=n6oA03qLjjcwBcDPSDV80wKa+1IBsnhq2bkZWDiODR0=;
 b=TBtrGf5J9GSkUt3b2QMHJgjotxPiRgZJPd7t0Rl9i8F+OSnh0QlipR4VWyCkBIBE1/
 w9n80rWnVXqQOCU+0BPNn93dUIAuOiwEl2SSrONUZWjNuUoC48DwYVV4Vc+pka17RdJw
 YwmYzsL/FA1poINK+D45uXb7866EOkTqngIueW545/vd60y59pVB5ZY8OJKdD/6QdQtQ
 Zu4vGCwDv3N/+AtOwtettFL0mhuTkxWJdfksr/cQjWHTNgy959u6NYrmBz4cD2xUxXh2
 BxJpKQ/VN+NwtBQpqQ3eJ8xZshcVIw5cHOeZbiN/Wsffafzm+SDb4bZYqzX2kBVYdqWD
 ITXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=n6oA03qLjjcwBcDPSDV80wKa+1IBsnhq2bkZWDiODR0=;
 b=ul02jajETkXecs3u4Vek0RNT+K8n209fan7Dr9/Xd1E4arQfncdcylgJHcI+BdYoXn
 ioaMVBChpLWExw/tsytns8nNi8Af2ztJPosNbO4W/yI5HOPx4U85UaI6rlmHqsd3lh9Y
 z7dlR3W7rIeCVDnn7H876rraCvaLr1ZrLqfZgSt0wjo/d0VfhunfV7Xyup+QDM6xNCpS
 VuUuB/ytAkie6TEGurSgSUJcaxpEwzpQUCXqviUwnphyYmG/1CSjQmSO/9J9HOv/NP9g
 EZYiVBLuSqowrdZu280sOtdH1CqUVX0PldNjiBsTWYTbgvux4J4c6yQGrxfHTwzla/8U
 I4Pg==
X-Gm-Message-State: AOAM533dRKiY+qdxQywwDIEeNpivPn8lllB+ZLxNQvIq9Zf8fJeFpFJI
 SyH7zwFWZHWiWofX5OH9Vnw193rLk4Sj
X-Google-Smtp-Source: ABdhPJwV6AcbNU8vjqv/vxj6ZmaNuK9vPiNcReyF8MlFlNm0j8dC0O+RJqRpgMWskICkLeA+1c+B+RkdnB4S
X-Received: from r2d2-qp.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:a1c:4e12:: with SMTP id
 g18mr2881922wmh.56.1616148180533; Fri, 19 Mar 2021 03:03:00 -0700 (PDT)
Date: Fri, 19 Mar 2021 10:01:41 +0000
In-Reply-To: <20210319100146.1149909-1-qperret@google.com>
Message-Id: <20210319100146.1149909-34-qperret@google.com>
Mime-Version: 1.0
References: <20210319100146.1149909-1-qperret@google.com>
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
Subject: [PATCH v6 33/38] KVM: arm64: Introduce KVM_PGTABLE_S2_IDMAP stage 2
 flag
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

Introduce a new stage 2 configuration flag to specify that all mappings
in a given page-table will be identity-mapped, as will be the case for
the host. This allows to introduce sanity checks in the map path and to
avoid programming errors.

Suggested-by: Will Deacon <will@kernel.org>
Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/include/asm/kvm_pgtable.h | 2 ++
 arch/arm64/kvm/hyp/pgtable.c         | 3 +++
 2 files changed, 5 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 55452f4831d2..c3674c47d48c 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -60,9 +60,11 @@ struct kvm_pgtable_mm_ops {
  * enum kvm_pgtable_stage2_flags - Stage-2 page-table flags.
  * @KVM_PGTABLE_S2_NOFWB:	Don't enforce Normal-WB even if the CPUs have
  *				ARM64_HAS_STAGE2_FWB.
+ * @KVM_PGTABLE_S2_IDMAP:	Only use identity mappings.
  */
 enum kvm_pgtable_stage2_flags {
 	KVM_PGTABLE_S2_NOFWB			= BIT(0),
+	KVM_PGTABLE_S2_IDMAP			= BIT(1),
 };
 
 /**
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index b22b4860630c..c37c1dc4feaf 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -760,6 +760,9 @@ int kvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
 		.arg		= &map_data,
 	};
 
+	if (WARN_ON((pgt->flags & KVM_PGTABLE_S2_IDMAP) && (addr != phys)))
+		return -EINVAL;
+
 	ret = stage2_set_prot_attr(pgt, prot, &map_data.attr);
 	if (ret)
 		return ret;
-- 
2.31.0.rc2.261.g7f71774620-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
