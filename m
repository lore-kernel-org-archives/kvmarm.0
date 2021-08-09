Return-Path: <SRS0=yt8/=NA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D62DC4320E
	for <kvmarm@archiver.kernel.org>; Mon,  9 Aug 2021 15:25:12 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1520F61101
	for <kvmarm@archiver.kernel.org>; Mon,  9 Aug 2021 15:25:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 1520F61101
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A97BE49F6C;
	Mon,  9 Aug 2021 11:25:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zfdlgZW5z3jp; Mon,  9 Aug 2021 11:25:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 670E64B0FD;
	Mon,  9 Aug 2021 11:25:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DEB0849F6C
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Aug 2021 11:25:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EFvr5qb0X1aO for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Aug 2021 11:25:07 -0400 (EDT)
Received: from mail-qv1-f73.google.com (mail-qv1-f73.google.com
 [209.85.219.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0CF3D4B0EA
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Aug 2021 11:25:07 -0400 (EDT)
Received: by mail-qv1-f73.google.com with SMTP id
 b2-20020a0cc9820000b0290352b2c7d7e1so3072032qvk.9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 Aug 2021 08:25:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=0U6bEbFLcZw+EVlWCQFxbjscDvzC1GFCLaFxX8mML7w=;
 b=kOLCXZaTuLa+M/eAksDlmTXxarvjJi/4V0U691zcl9If3pch1JmCrYhjGOY8XVKtJE
 6NuTYclkw0GPt0FK2mSGr3hTr4kwtJkTW+ezZALU33xRPk28YsNg05w+3w7O4PtRSL8i
 wrjld/G5kuClFhvVfczeYTwUpwU7xzbTze9JQU4DBSUbnKUAk+5TmjEX1GPeAbpvo7EB
 8VtQ67ClSRfBWW+SLvG80L6+JEtKS6B+eU5WjxhSeBvp0pLR+HNQV+YuuMmfIvZp+APm
 fiAK3U3VTWGVuBaz5uZbFLU0vd0fRk8vYM5Ajv1XJbbeZUdR+aL0PvPbhBv8YESCUjpZ
 TKFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=0U6bEbFLcZw+EVlWCQFxbjscDvzC1GFCLaFxX8mML7w=;
 b=FnQDqS5B4M/H07pw3s0t4OuHwHZN3y0i5KsBBbVB2ZGuKjy8ImFyipg2c50CuOpaiK
 MqK60SCaGXUR1MOuRN7p5/lFG+kuX+n5OENzTr6f03ReinFSUQP8qzOA30smRsLg7LXE
 dueAECFdSM4aXlMaicwetsJ2SDvSMHGTawZ1qyoaeS1tJwFj2zu5+65jcUgSReKEwWg0
 2HcgpX+WDl/gWwLH1JY7qFGzKMwFI5Ulk7IbmUwrwAfFGiVRCyT6pzWGzlmb+OPKYe3F
 retXyE7fv7Kn2YdORJxfA+YzFmH07vUQNNbr4eSDCxZ87GCay4BF/QM/OZbDVjb9Zxie
 PB2Q==
X-Gm-Message-State: AOAM531np2VWtU/bi8O74ZjUhfHtzNBmVYRQo4R+rwJqnHXkHoljkACi
 xCaN0rAZCqTheSqNAGDhMg2f+M9njl9f
X-Google-Smtp-Source: ABdhPJyLymu2D60zHUrmLqd+Yu9r4hpSVIXHgBvGpH3s/oeTvKgBK0EWZGKeXuUJmU+jyvIS3H1jipiit27T
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:b0e8:d460:758b:a0ae])
 (user=qperret job=sendgmr) by 2002:a05:6214:62c:: with SMTP id
 a12mr14308495qvx.49.1628522706714; Mon, 09 Aug 2021 08:25:06 -0700 (PDT)
Date: Mon,  9 Aug 2021 16:24:34 +0100
In-Reply-To: <20210809152448.1810400-1-qperret@google.com>
Message-Id: <20210809152448.1810400-8-qperret@google.com>
Mime-Version: 1.0
References: <20210809152448.1810400-1-qperret@google.com>
X-Mailer: git-send-email 2.32.0.605.g8dce9f2422-goog
Subject: [PATCH v4 07/21] KVM: arm64: Rename KVM_PTE_LEAF_ATTR_S2_IGNORED
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

The ignored bits for both stage-1 and stage-2 page and block
descriptors are in [55:58], so rename KVM_PTE_LEAF_ATTR_S2_IGNORED to
make it applicable to both. And while at it, since these bits are more
commonly known as 'software' bits, rename accordingly.

Reviewed-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/pgtable.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 4dff2ad39ee4..59a394d82de3 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -36,6 +36,8 @@
 
 #define KVM_PTE_LEAF_ATTR_HI		GENMASK(63, 51)
 
+#define KVM_PTE_LEAF_ATTR_HI_SW		GENMASK(58, 55)
+
 #define KVM_PTE_LEAF_ATTR_HI_S1_XN	BIT(54)
 
 #define KVM_PTE_LEAF_ATTR_HI_S2_XN	BIT(54)
@@ -44,8 +46,6 @@
 					 KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W | \
 					 KVM_PTE_LEAF_ATTR_HI_S2_XN)
 
-#define KVM_PTE_LEAF_ATTR_S2_IGNORED	GENMASK(58, 55)
-
 #define KVM_INVALID_PTE_OWNER_MASK	GENMASK(63, 56)
 #define KVM_MAX_OWNER_ID		1
 
-- 
2.32.0.605.g8dce9f2422-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
