Return-Path: <SRS0=fiTO=MS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6EE2C4338F
	for <kvmarm@archiver.kernel.org>; Mon, 26 Jul 2021 09:29:29 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 91F8560F02
	for <kvmarm@archiver.kernel.org>; Mon, 26 Jul 2021 09:29:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 91F8560F02
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 345C449F6C;
	Mon, 26 Jul 2021 05:29:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HZIrG88mkQqH; Mon, 26 Jul 2021 05:29:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1F0F04AC80;
	Mon, 26 Jul 2021 05:29:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 025C649DE3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Jul 2021 05:29:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pcj+fy09IOcU for <kvmarm@lists.cs.columbia.edu>;
 Mon, 26 Jul 2021 05:29:26 -0400 (EDT)
Received: from mail-qv1-f73.google.com (mail-qv1-f73.google.com
 [209.85.219.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EC72D4A7FD
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Jul 2021 05:29:24 -0400 (EDT)
Received: by mail-qv1-f73.google.com with SMTP id
 o32-20020a0c85a30000b0290328f91ede2bso4305579qva.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Jul 2021 02:29:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=xhqFHmC/x7AnH8ZRcl4l1dWbyNuPeqmFIi1qz6ztr7w=;
 b=ky9L1rdM2E3/pnvC1byWpnnDrketwgcUM2bCx8+9oPsj/Yt617M9WBkhR3Ympi/l4L
 VTeD1nruEtGe4LWOp3GLcU+7LstB63zkiS4nWY8QanDvEdLTpsDsMTSnXOla07D8Y4LE
 CKd5U8AUGdUjttxk0FKMZofS9v9BiNVjLm3R2YTEuFvxA2hECbp42flWzlsfaVnzYCaW
 ff1fKfwwzoN8osSFvI3OV/+2ArYR9Z0WC5vtT3Q8fMLNmb0YI3GsjsikhLyr2K4YGhdV
 OtFyNK5p9iKQ8eOXfzV9kQ58g82+/f5r/bb15bcMbUTlfDrVHghBIyXO41eZuDmkB84i
 dKbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=xhqFHmC/x7AnH8ZRcl4l1dWbyNuPeqmFIi1qz6ztr7w=;
 b=a2y9wNU+ItwI0Ebt9DYpVqNb/KbnrN0dHKkJmjTGXbC/vteBOu7+jlIL+Pl8OaAp+l
 FgyNW7vpxVQd+4n40/UdNGdffL64eSoQ5HzV/96WSUslre3wF2woXQXH9lpIwlvc8k+x
 wq5l9KbcaffrTQL67HmWaELf8Gpbytuyr0FXFO74zfbSNLFiGB67/MDPWox4gHrbuI8N
 bW0wxUVmOiX3jnkRIHranGoJ7+JlvALV4qmGKSyx9yz57eNzWmO/fnkszkAAxdakmv8V
 MrkhknhwsFQOo7X4AVuxofqJZX4stqyDuuPTJ3Q/Pdt5vbXbyYY5qpodYm370PlQ3/Gz
 2rNQ==
X-Gm-Message-State: AOAM53142jm72/1qp7A3dGZp8Vq+cEytZkk90iXP3NyBgMTV4fNLvaGe
 xWBy3+PJZAKb3CO3ce4Y2BerpbZrb9+3
X-Google-Smtp-Source: ABdhPJw4miv6yKMoP660KkuAQKoQs6QJrbWUOze6sSCFx/jyqDsnRSbtfSCLwuMOdKieMRJBqFuxCCiKdHzU
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:23a0:2f14:433:e6cb])
 (user=qperret job=sendgmr) by 2002:a0c:fbd1:: with SMTP id
 n17mr17016888qvp.19.1627291764500; Mon, 26 Jul 2021 02:29:24 -0700 (PDT)
Date: Mon, 26 Jul 2021 10:28:55 +0100
In-Reply-To: <20210726092905.2198501-1-qperret@google.com>
Message-Id: <20210726092905.2198501-7-qperret@google.com>
Mime-Version: 1.0
References: <20210726092905.2198501-1-qperret@google.com>
X-Mailer: git-send-email 2.32.0.432.gabb21c7263-goog
Subject: [PATCH v2 06/16] KVM: arm64: Don't overwrite software bits with owner
 id
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

We will soon start annotating page-tables with new flags to track shared
pages and such, and we will do so in valid mappings using software bits
in the PTEs, as provided by the architecture. However, it is possible
that we will need to use those flags to annotate invalid mappings as
well in the future, similar to what we do to track page ownership in the
host stage-2.

In order to facilitate the annotation of invalid mappings with such
flags, it would be preferable to re-use the same bits as for valid
mappings (bits [58-55]), but these are currently used for ownership
encoding. Since we have plenty of bits left to use in invalid
mappings, move the ownership bits further down the PTE to avoid the
conflict.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/pgtable.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 516c1b8ce6b8..b5ca21b44b6a 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -49,7 +49,7 @@
 					 KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W | \
 					 KVM_PTE_LEAF_ATTR_HI_S2_XN)
 
-#define KVM_INVALID_PTE_OWNER_MASK	GENMASK(63, 56)
+#define KVM_INVALID_PTE_OWNER_MASK	GENMASK(9, 2)
 #define KVM_MAX_OWNER_ID		1
 
 struct kvm_pgtable_walk_data {
-- 
2.32.0.432.gabb21c7263-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
