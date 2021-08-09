Return-Path: <SRS0=yt8/=NA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5533C4338F
	for <kvmarm@archiver.kernel.org>; Mon,  9 Aug 2021 15:25:27 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 611FD61058
	for <kvmarm@archiver.kernel.org>; Mon,  9 Aug 2021 15:25:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 611FD61058
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 02E4F4A19F;
	Mon,  9 Aug 2021 11:25:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id a+Hd6+GYwtub; Mon,  9 Aug 2021 11:25:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7EEE94B0EF;
	Mon,  9 Aug 2021 11:25:25 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6C0AA4B10D
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Aug 2021 11:25:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ENMw-SYR24+9 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Aug 2021 11:25:23 -0400 (EDT)
Received: from mail-qv1-f73.google.com (mail-qv1-f73.google.com
 [209.85.219.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1D54B49F6C
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Aug 2021 11:25:22 -0400 (EDT)
Received: by mail-qv1-f73.google.com with SMTP id
 kk20-20020a0562145094b029034e3ec4ffb4so6703322qvb.11
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 Aug 2021 08:25:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=PF2it3NjGIyKq5ORZJDtBzFFsiYhiJLkV2yaXKhO9X4=;
 b=ftXs+EPnLTaD5rCUC9K5I63oGlpyo8cK1JWBx8UMjZ9M93skpv50giZG25JXZCnqR3
 P4/bzs5IMikwsrEoPn4s5CIbKMUP2g9FrdX9jEn37cKvQer2/nFU7JUQGu84PZkYKdGE
 gpcZQBLTk7tFHRo7TSjmGRlJsxEFHP4XQsoDp4RyZR5TldotXatjcdMTOVVOTTnD+PyE
 eJg9fO9N/IZNYFbV/fpOFXkoJkn69ctU91Sa2C5RC/VOqM5oXnCCBiwB7oQviBUSERLr
 uASVreo2KG9expDo8/UU/xVSjkvRLYkgukVyElK5YqFZ7V2OhNzd0/5x5vxtQw21L+ex
 2/zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=PF2it3NjGIyKq5ORZJDtBzFFsiYhiJLkV2yaXKhO9X4=;
 b=XZHiiayZhbVXpc++W/fkKLdJ2wfnJ9MSjwEnbPswZBOW4qssetwQDNi9o1+YlGvrWc
 mbqN4P9rHMAVSMGhAXyy92yUDl2+2zlUSNDOt+MKAr8c2h2ckLFsS9rs0OB38A/p/Vmn
 qWO24YS+ZvKcZ7KaMBe0ExYroi2lxWMaJ+ZFyR4t2P1flljUDiH20KOdRZy/UQar0rfR
 vgVPl4tenuCiIZjTHd5roe0HHCtYvDHv309N8Q/XcqrgDe9s053Y/ogZPrah+KifgkHy
 xAWe65Phj3HIdPJn0CuZi4Ybpg7uvHiH3DG/xWf9Am+rXd4P7PFdNKmgM9v3iNCs4AlN
 l5RQ==
X-Gm-Message-State: AOAM531jByPUmFd9zWx7C7PorX5LM6BlUmutbX+F1UdhtqhA1gPB0v25
 7GOAxhorXDzucW+YvLthR+s8HLXmkouy
X-Google-Smtp-Source: ABdhPJykT3ZqBNKwN2TK8pulE0GyjvqWRyK+t1M7X0TDYfKeIo+MjBoUBZPBPTR6JMY1GKpSBOFS/zgqRiv2
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:b0e8:d460:758b:a0ae])
 (user=qperret job=sendgmr) by 2002:a05:6214:10e6:: with SMTP id
 q6mr24439882qvt.11.1628522721784; Mon, 09 Aug 2021 08:25:21 -0700 (PDT)
Date: Mon,  9 Aug 2021 16:24:41 +0100
In-Reply-To: <20210809152448.1810400-1-qperret@google.com>
Message-Id: <20210809152448.1810400-15-qperret@google.com>
Mime-Version: 1.0
References: <20210809152448.1810400-1-qperret@google.com>
X-Mailer: git-send-email 2.32.0.605.g8dce9f2422-goog
Subject: [PATCH v4 14/21] KVM: arm64: Expose pkvm_hyp_id
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
index 0849ee8fa260..23316a021880 100644
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
index f95a5a4aa09c..ee255171945c 100644
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
2.32.0.605.g8dce9f2422-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
