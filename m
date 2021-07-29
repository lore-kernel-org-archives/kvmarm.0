Return-Path: <SRS0=9/XU=MV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0478C4338F
	for <kvmarm@archiver.kernel.org>; Thu, 29 Jul 2021 13:28:59 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7987660EFD
	for <kvmarm@archiver.kernel.org>; Thu, 29 Jul 2021 13:28:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 7987660EFD
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2D6FF4B104;
	Thu, 29 Jul 2021 09:28:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1EVySFyfa5o2; Thu, 29 Jul 2021 09:28:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 41E554B0DF;
	Thu, 29 Jul 2021 09:28:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 246A140D0A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Jul 2021 09:28:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PJrA3GITqaNz for <kvmarm@lists.cs.columbia.edu>;
 Thu, 29 Jul 2021 09:28:55 -0400 (EDT)
Received: from mail-qv1-f74.google.com (mail-qv1-f74.google.com
 [209.85.219.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 429184B085
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Jul 2021 09:28:55 -0400 (EDT)
Received: by mail-qv1-f74.google.com with SMTP id
 hf7-20020a0562140e87b02902dc988b8675so3940841qvb.3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Jul 2021 06:28:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=RPFJCEtaWTMugcF+NjceDUD4B85Vp1oeldRispcGqoY=;
 b=bCde7WqPKlxY/xHp5JNTJjJWBNhOJVIwYFfYXuBL6y9hVFcJKQjvu1Mgb3V+PuXsnX
 mqBCCgRgi/wqWG8KCgA+CMGVirqrgoaOVCFuzncfBsxc8XcDVkSloOQL2ifClKz0If3Y
 1wGjcqXn9IBvEFZrjB/A6wvBdmg9otbA4SPJIe1YnoJj2Zoifvf6c0fZu36QDT+x1w2U
 MwG1JN/XJryBjI4GbZ9IGY2pInQUGfILqs/7RNeTqPYGYAb8DyV5wZCuO40ax1atjGrB
 w8RvMOQRQqGwRk0P2fFmfVIf+LG2HiF0+IJYdhgVjWw3xx+9XsPAm+vszSyUj/0eUuYl
 Xufw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=RPFJCEtaWTMugcF+NjceDUD4B85Vp1oeldRispcGqoY=;
 b=BKU7l8wveCkRSeleq6sWRmTLSrU1MRGKVRvXMJPpb+tkLQxOvZCbvhiH8zOeO33qd9
 mlRR2q+tNbaAe2X1kdoz2tD9mDImrlwgg6ynDSw41XLSMZn8qp14dhLEi2DW2qAgq7Bl
 5EhYVfN+IV3Lh9HQTYdiNcsLAVmUQ9lYUQ0C7AyBEo07Cu7qQoPeuPwSFyQRYZxe5wv9
 xi0OmzpaBDkZkWRa3li4O5KjOQrzYQsl2VjPnoeGDCY2FDh/CjX3yQnmDlmHt695+/LJ
 RBTZXFr1Is4FKVhiFYA/df4KIpqi3CzID4GEhFrGw1DV2dNTtxwUv9lmmf10qUGchU1B
 glJw==
X-Gm-Message-State: AOAM531Z2IdRct81VAxRGi72irdWyCW8TLpZGJG9gRAjIoNE8ZJBpReg
 MgMj2/1pRnzlKKRPttMojtVYU0+DAwPa
X-Google-Smtp-Source: ABdhPJxO1maZxYuMOOkc4lCtsFIycuYzMEuf8no7IwacnRivc5nMk/nvcqWV/4Hs90Z3Rs5fFhvpcPIxnoD0
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:293a:bc89:7514:5218])
 (user=qperret job=sendgmr) by 2002:ad4:4a8c:: with SMTP id
 h12mr5181240qvx.62.1627565334836; Thu, 29 Jul 2021 06:28:54 -0700 (PDT)
Date: Thu, 29 Jul 2021 14:28:11 +0100
In-Reply-To: <20210729132818.4091769-1-qperret@google.com>
Message-Id: <20210729132818.4091769-15-qperret@google.com>
Mime-Version: 1.0
References: <20210729132818.4091769-1-qperret@google.com>
X-Mailer: git-send-email 2.32.0.432.gabb21c7263-goog
Subject: [PATCH v3 14/21] KVM: arm64: Expose pkvm_hyp_id
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

Allow references to the hypervisor's owner id from outside
mem_protect.c.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h | 2 ++
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index 47c2a0c51612..cc86598654b9 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -46,6 +46,8 @@ struct host_kvm {
 };
 extern struct host_kvm host_kvm;
 
+extern const u8 pkvm_hyp_id;
+
 int __pkvm_prot_finalize(void);
 int __pkvm_mark_hyp(phys_addr_t start, phys_addr_t end);
 
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index a7f6134789e0..bb18940c3d12 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -31,7 +31,7 @@ static struct hyp_pool host_s2_pool;
 u64 id_aa64mmfr0_el1_sys_val;
 u64 id_aa64mmfr1_el1_sys_val;
 
-static const u8 pkvm_hyp_id = 1;
+const u8 pkvm_hyp_id = 1;
 
 static void *host_s2_zalloc_pages_exact(size_t size)
 {
-- 
2.32.0.432.gabb21c7263-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
