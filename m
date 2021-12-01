Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 967E0C433F5
	for <kvmarm@archiver.kernel.org>; Wed,  1 Dec 2021 17:04:26 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3247C4B204;
	Wed,  1 Dec 2021 12:04:26 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id blsy677SFQuf; Wed,  1 Dec 2021 12:04:25 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1E5434B21F;
	Wed,  1 Dec 2021 12:04:25 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CEFA44B204
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Dec 2021 12:04:23 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EUAsRBAGMva8 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  1 Dec 2021 12:04:22 -0500 (EST)
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com
 [209.85.128.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 783BD4B21E
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Dec 2021 12:04:22 -0500 (EST)
Received: by mail-wm1-f73.google.com with SMTP id
 205-20020a1c00d6000000b003335d1384f1so146675wma.3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 01 Dec 2021 09:04:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=5u4bcd8p5lWhOh9Twmw6ckk6rlz/H+k7Di86Nv+W7y0=;
 b=c2jCqyYJWi6j0q+TdDuz84phld5+VtSpY4m7fhUMjwZLascGKc4969abcgbluEB/Ze
 h/sY9sRt4zD8i/w/dPj//QCFbZ71q4VJxjSfwZNtAByXbmjpRHJ+yOLVXEcfb6s9kZIH
 NnaaFE1z0Ehl4VNNXPMVWuvl102KADwuQxFHzKv2d2JeQSOYpIVIs1BlfbuuZmb857DQ
 r30VAksuJc/Cbj3iGu3aZe7i20L+ENRdWzTjRz5xtASwajdp145hE153kJaS7HGrgjxj
 8SIhH82RSlvwXFa2KohYPvS1mvjQCVQPZ51hqOt61AfOjEwOtzTvnuVJWbZIxCVcSEw1
 GHXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=5u4bcd8p5lWhOh9Twmw6ckk6rlz/H+k7Di86Nv+W7y0=;
 b=uNakoxEgk0UMu0V0X84/rgNkteMNKZZ9tJd9/9kv2UQ4OPuBw50yCrb4v4wOB0GM/u
 McUbUJRwE2tqrlt6vqO+i2QC3dudho7ujGNRqoEDi9eAu0pxx/vIxICP5nNDou+COmHM
 sY3rkb4oCzv8yXhf/SI3EayxPWMBL4mU+POzBdxvOOl+7dha/eS3TBLnP0u35iqhxnhx
 nNglXbG3yM+indAN1UTSMlM4+Px5EuA/B4qWkhAr84hPppTz1NWSwISz0ZeglsdWF/aK
 0ygT67s/bStda1l1UR6z7zgqYX95739gr0W9h7rcxX9vMSaSDE1sCO1uyTMrvZnuPo6R
 xirg==
X-Gm-Message-State: AOAM531mQl8T368J/DOBdjMxK/E1v+vrttU7rVcCjzcjohLfN0Ba8Ly4
 3ViTL8M+EynfAEBg3PezKo9eRVlo0u9S
X-Google-Smtp-Source: ABdhPJz8KqUSlppvt5PWeoeu8pXK06/96X8A4lVCiTuTfHGPzga9ENc8lxXkM7E2YtzgjN+WEGl+8JdtGsxP
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:1cab:1a20:2ef1:ddde])
 (user=qperret job=sendgmr) by 2002:a05:6000:23a:: with SMTP id
 l26mr8091897wrz.215.1638378261551; Wed, 01 Dec 2021 09:04:21 -0800 (PST)
Date: Wed,  1 Dec 2021 17:03:56 +0000
In-Reply-To: <20211201170411.1561936-1-qperret@google.com>
Message-Id: <20211201170411.1561936-3-qperret@google.com>
Mime-Version: 1.0
References: <20211201170411.1561936-1-qperret@google.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [PATCH v3 02/15] KVM: arm64: Provide {get, put}_page() stubs for early
 hyp allocator
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Cc: kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
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

In nVHE protected mode, the EL2 code uses a temporary allocator during
boot while re-creating its stage-1 page-table. Unfortunately, the
hyp_vmmemap is not ready to use at this stage, so refcounting pages
is not possible. That is not currently a problem because hyp stage-1
mappings are never removed, which implies refcounting of page-table
pages is unnecessary.

In preparation for allowing hypervisor stage-1 mappings to be removed,
provide stub implementations for {get,put}_page() in the early allocator.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/nvhe/early_alloc.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/early_alloc.c b/arch/arm64/kvm/hyp/nvhe/early_alloc.c
index 1306c430ab87..00de04153cc6 100644
--- a/arch/arm64/kvm/hyp/nvhe/early_alloc.c
+++ b/arch/arm64/kvm/hyp/nvhe/early_alloc.c
@@ -43,6 +43,9 @@ void *hyp_early_alloc_page(void *arg)
 	return hyp_early_alloc_contig(1);
 }
 
+static void hyp_early_alloc_get_page(void *addr) { }
+static void hyp_early_alloc_put_page(void *addr) { }
+
 void hyp_early_alloc_init(void *virt, unsigned long size)
 {
 	base = cur = (unsigned long)virt;
@@ -51,4 +54,6 @@ void hyp_early_alloc_init(void *virt, unsigned long size)
 	hyp_early_alloc_mm_ops.zalloc_page = hyp_early_alloc_page;
 	hyp_early_alloc_mm_ops.phys_to_virt = hyp_phys_to_virt;
 	hyp_early_alloc_mm_ops.virt_to_phys = hyp_virt_to_phys;
+	hyp_early_alloc_mm_ops.get_page = hyp_early_alloc_get_page;
+	hyp_early_alloc_mm_ops.put_page = hyp_early_alloc_put_page;
 }
-- 
2.34.0.rc2.393.gf8c9666880-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
