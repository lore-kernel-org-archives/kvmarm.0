Return-Path: <SRS0=ky3n=LC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EA17C4743F
	for <kvmarm@archiver.kernel.org>; Tue,  8 Jun 2021 14:12:09 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 54BB961359
	for <kvmarm@archiver.kernel.org>; Tue,  8 Jun 2021 14:12:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 54BB961359
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 05D9F40617;
	Tue,  8 Jun 2021 10:12:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xPYU+f7miRLG; Tue,  8 Jun 2021 10:12:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 126B44086F;
	Tue,  8 Jun 2021 10:12:07 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A455A49E93
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Jun 2021 10:12:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jQE0X+R6+UhI for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Jun 2021 10:12:04 -0400 (EDT)
Received: from mail-qt1-f201.google.com (mail-qt1-f201.google.com
 [209.85.160.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1B4AA4A198
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Jun 2021 10:12:04 -0400 (EDT)
Received: by mail-qt1-f201.google.com with SMTP id
 z20-20020ac845540000b0290248cbf50215so1854566qtn.10
 for <kvmarm@lists.cs.columbia.edu>; Tue, 08 Jun 2021 07:12:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=/Mt8MqtrF+0ijPrbzI2Iua+6aoYU0GqD+XJoEIBz4Ww=;
 b=RFQw40Od12GityDnZo7Kd/94h6wYJrr5TxRqbfenOuViXa1LbDJ5HBSpEzf3MaEc6r
 xVJWDV0RGF2FuaZ4q/eel/c+IsNzhEazQQUUgHrAmLn9mPMZnrUH0CAxhGFIVKckjjR7
 TU5ovJ3z8hUNmg58EW+DZe3QIGkXohuJGa9B3abxBrZWiydDI73wFvCJMUUvrLwtDCkt
 gH63E9BKHYEH1IvpcXEekuA2/G3JlfA+k2eN3Vg5GZ3ZKMFE8kQ1WTrN6vBxYFE4cgik
 08dUTzFaOg/LgfM7ZiKWI8JvNOsM2AJ5/3D09dW//e2huy5HxBH9HhFiY9CGNVazOag2
 Vp6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=/Mt8MqtrF+0ijPrbzI2Iua+6aoYU0GqD+XJoEIBz4Ww=;
 b=KtiKvtdWeqT825JZ8dDs8ejKrcMbgK7ze0LWYMFGZP1c2tbXulZCxqHH1s9y/5358L
 4sLfiFkSyhU0XvTpoU0SEHoHrTEF6yxKYb87wsHk6U7r/Re3fzuV1bNwcmrvGxw1zvPS
 k9xHu6QOHu8tGLz7GfA8C5Owg/TsuLPkyKgBwifM5M8N+w+AK2bNTwAZCVypBIrn5HBA
 RZcBthc0GP9KxAc2XMPnlj+eGF5Ah/aQFXV3eyjdjw+s3YCMVz3Rx5SDANDw/fYBNkpU
 cfiqCj7sqHu6ukj6bhxpEU/R3Zu54lAUPNRf3HJogKC+XLz1s6qV+Mq13Sria3evTEfV
 VyjQ==
X-Gm-Message-State: AOAM532z090zk5k5Xl8V/9h95WGFrT4fut3Jpa4Y08EjIR3EM5NWAY/f
 vMWyZehjgT7gndaXO3S/cjVvfqmMSZA0uxKEKfgvKR1k5x280LnszNSVsdz1WinDuNooo5JqwwS
 spUrpeSt7Jzo1W3sCmERxUNSBZfVL3neHsCYkmBJkPHxGPtqKRM2tVcTRooM0QxlPIwk=
X-Google-Smtp-Source: ABdhPJxe0XAsOIoUJkVFC3croItftPKyjg8mxh5Z0V9YqYts9/X6Kv08kRsA9WOzWOgAaN4iTUgVVjEXiw==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a0c:ff48:: with SMTP id
 y8mr182068qvt.29.1623161523559; 
 Tue, 08 Jun 2021 07:12:03 -0700 (PDT)
Date: Tue,  8 Jun 2021 15:11:38 +0100
In-Reply-To: <20210608141141.997398-1-tabba@google.com>
Message-Id: <20210608141141.997398-11-tabba@google.com>
Mime-Version: 1.0
References: <20210608141141.997398-1-tabba@google.com>
X-Mailer: git-send-email 2.32.0.rc1.229.g3e70b5a671-goog
Subject: [PATCH v1 10/13] KVM: arm64: Move sanitized copies of CPU features
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kernel-team@android.com, kvm@vger.kernel.org, maz@kernel.org,
 pbonzini@redhat.com, will@kernel.org, linux-arm-kernel@lists.infradead.org
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

Move the sanitized copies of the CPU feature registers to the
recently created sys_regs.c. This consolidates all copies in a
more relevant file.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 6 ------
 arch/arm64/kvm/hyp/nvhe/sys_regs.c    | 5 +++++
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 4b60c0056c04..de734d29e938 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -26,12 +26,6 @@ struct host_kvm host_kvm;
 static struct hyp_pool host_s2_mem;
 static struct hyp_pool host_s2_dev;
 
-/*
- * Copies of the host's CPU features registers holding sanitized values.
- */
-u64 id_aa64mmfr0_el1_sys_val;
-u64 id_aa64mmfr1_el1_sys_val;
-
 static const u8 pkvm_hyp_id = 1;
 
 static void *host_s2_zalloc_pages_exact(size_t size)
diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
index 890c96315e55..998b1b48b089 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -14,9 +14,14 @@
 
 #include "../../sys_regs.h"
 
+/*
+ * Copies of the host's CPU features registers holding sanitized values.
+ */
 u64 id_aa64pfr0_el1_sys_val;
 u64 id_aa64pfr1_el1_sys_val;
 u64 id_aa64dfr0_el1_sys_val;
+u64 id_aa64mmfr0_el1_sys_val;
+u64 id_aa64mmfr1_el1_sys_val;
 u64 id_aa64mmfr2_el1_sys_val;
 
 /*
-- 
2.32.0.rc1.229.g3e70b5a671-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
