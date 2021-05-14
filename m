Return-Path: <SRS0=n2ZT=KJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 786CEC433B4
	for <kvmarm@archiver.kernel.org>; Fri, 14 May 2021 08:56:53 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 22C4E613F1
	for <kvmarm@archiver.kernel.org>; Fri, 14 May 2021 08:56:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 22C4E613F1
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C7C734B962;
	Fri, 14 May 2021 04:56:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cWVW5soJUPUQ; Fri, 14 May 2021 04:56:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D10034B8E4;
	Fri, 14 May 2021 04:56:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F17AB4B57A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 14 May 2021 04:56:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cjH4T14dtBmi for <kvmarm@lists.cs.columbia.edu>;
 Fri, 14 May 2021 04:56:46 -0400 (EDT)
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com
 [209.85.221.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 63E634B4BA
 for <kvmarm@lists.cs.columbia.edu>; Fri, 14 May 2021 04:56:46 -0400 (EDT)
Received: by mail-wr1-f74.google.com with SMTP id
 i102-20020adf90ef0000b029010dfcfc46c0so12512608wri.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 14 May 2021 01:56:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=DsoFxeRTL+Nw5DWaxppkuPUe8Hn6PzBriXdZl5+wSCA=;
 b=o1IANvbfwJfcYogRTJ0Cq9xqN59Gs0pQcdUdRRCJAox4SGoL88ZbtN6tc2X1M/m79o
 LxMRxxyayr3y+IkT6LgIkSBZI5ZnrMe5nFDEeGpvo555JarNmLruWALYTsejpqbo3oOE
 zbYBJUWxMOfjDp5sd1n3OQIH8ajeo2L1Ak+/rBNxjDtobeJ9zzT8gTg9LplN3SBo93we
 lzqBjDLj70LHAx30XsCyAdhYQ/LEnn3EosuNbmS85nA9M1nk8Rt5CgkdRlYkAS91EJeu
 g5woXftzpM+LTVa+xzgulESoWSMZ150gV8meRZQs+ERc6aCgm6Ao8rtfM3xxOYYK0Gpl
 nOvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=DsoFxeRTL+Nw5DWaxppkuPUe8Hn6PzBriXdZl5+wSCA=;
 b=g+vi3JpCyk1RQJikGSgydlBDvNQqfmNvpny4VC2D+nhQV/hUR8yAUhw2nmdW6tKMIP
 AVLV1wsVvHo2xaYxRaIS7ufEq4mDMoEnB3oJa1FZoNMUxndPgVZPCt32Fb7r5Ti8WzMR
 bEFWwTCoQL90nR+WeRDhC4ScCuHr53C4ExtWeck5d6rl7Te6djBYbtcypea7IhI48FJ/
 DUAX+9mTHV0TOOPeSVug6vVzXX3HT6RewmeePlAJfW6EG9lAYlTm19UyqM/wiTN2lztX
 NvLZFdje38sScjoG7HdXx+jNU7XBlIwQ9AlD0dVbwkQGnkGNDf+R4m7+LbeNovbzxbf2
 QUGQ==
X-Gm-Message-State: AOAM533WrVElyMGZ2MwxPpUKiGcKya9ZYm0q6Jo2ck3UckfCmlJdzemk
 YISzDWUY6+1vZWm3TqA/+yMIFP4YUKgMtBfj+SkSwLKZXTS+j7pWrXkRdzHk20tTWC7s77guQV3
 CkDUy3lljgksYlzKTsLqqJNyyElRtGO8NtYIgu/k8Fp0LsO60ycqzDkn9SeaUssrpgD/yQPFw
X-Google-Smtp-Source: ABdhPJzaBzglqhH5jl6kGuuMK4XkhqAX/1DOXGw8R8/pEOGolUrc38Zbx3be2lRM3FrcTGps8iYnNLsf2xsD
X-Received: from r2d2-qp.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:a7b:cd01:: with SMTP id
 f1mr8311134wmj.177.1620982605506; Fri, 14 May 2021 01:56:45 -0700 (PDT)
Date: Fri, 14 May 2021 08:56:39 +0000
In-Reply-To: <20210514085640.3917886-1-qperret@google.com>
Message-Id: <20210514085640.3917886-2-qperret@google.com>
Mime-Version: 1.0
References: <20210514085640.3917886-1-qperret@google.com>
X-Mailer: git-send-email 2.31.1.751.gd2f1c929bd-goog
Subject: [PATCH 1/2] KVM: arm64: Mark pkvm_pgtable_mm_ops static
From: Quentin Perret <qperret@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: maz@kernel.org, will@kernel.org, kbuild-all@lists.01.org
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

It is not used outside of setup.c, mark it static.

Fixes:f320bc742bc2 ("KVM: arm64: Prepare the creation of s1 mappings at EL2")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/nvhe/setup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index 7488f53b0aa2..a3d3a275344e 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -17,7 +17,6 @@
 #include <nvhe/trap_handler.h>
 
 struct hyp_pool hpool;
-struct kvm_pgtable_mm_ops pkvm_pgtable_mm_ops;
 unsigned long hyp_nr_cpus;
 
 #define hyp_percpu_size ((unsigned long)__per_cpu_end - \
@@ -27,6 +26,7 @@ static void *vmemmap_base;
 static void *hyp_pgt_base;
 static void *host_s2_mem_pgt_base;
 static void *host_s2_dev_pgt_base;
+static struct kvm_pgtable_mm_ops pkvm_pgtable_mm_ops;
 
 static int divide_memory_pool(void *virt, unsigned long size)
 {
-- 
2.31.1.751.gd2f1c929bd-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
