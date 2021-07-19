Return-Path: <SRS0=FmU0=ML=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA41AC07E9D
	for <kvmarm@archiver.kernel.org>; Mon, 19 Jul 2021 16:04:18 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8530A61492
	for <kvmarm@archiver.kernel.org>; Mon, 19 Jul 2021 16:04:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8530A61492
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 371BA4B0E0;
	Mon, 19 Jul 2021 12:04:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MCxBCafAsZBT; Mon, 19 Jul 2021 12:04:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0620A4B0D1;
	Mon, 19 Jul 2021 12:04:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 91AD84A023
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 12:04:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iWewDCH-lnqs for <kvmarm@lists.cs.columbia.edu>;
 Mon, 19 Jul 2021 12:04:13 -0400 (EDT)
Received: from mail-qv1-f74.google.com (mail-qv1-f74.google.com
 [209.85.219.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 969E84B093
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 12:04:13 -0400 (EDT)
Received: by mail-qv1-f74.google.com with SMTP id
 y12-20020a0ceacc0000b02902eaed054a57so15555383qvp.15
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 09:04:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=AJdpXDjb5aqrnyWXTohbslhSMhG4QVJMKzdIEyMUQpc=;
 b=Lwsz6htTsTWfi7NrN+36zuCZsSkjE9PZhnpdh3+672pcVHhLdTHphSHEHVUhe8wDhl
 7J3Xk8TAOfZ5iSvTkWeRqsk9kbNKyezC11ubg0T7vKXHeMoZypUm5MD10dFoNf+LFn8Y
 HIrDaF8b1EWtG514FOl8z3rUi6HjMb7rDasSWjFGXbngMsi0eE1/jk0qbpTTwN9kJt7b
 kL4fP0N0g5o1OFBXV/EIZcTpOOIx0AVoqX4L7bZgQKOD5s6FHWKY2+GdtJP4wux4AZTT
 tQ+qmqYKXZbH7mqZ8qYQIxpp5zGgL685HlOF9JSq1WN/DUKZBSPZ7ycql8Q3c9gEPou0
 rjoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=AJdpXDjb5aqrnyWXTohbslhSMhG4QVJMKzdIEyMUQpc=;
 b=f62FQw90UrM1uuSpvPL30dt3BbcdQYZgjwYifv25ikTsN9YERUhsax40lIz1A/6+HF
 DBGI8yo/kanW0tx8JsWd+HhBtQUOE0NlntFCwfjfZ1g+khzV5BToOIPGyf8sDbRmoEY3
 HKG0+kNpcS5tqRkNleX2ggWV/2d7vAogIHfZ1UOSPmsWyS3jjjrsaDSy0LAHmw14njmn
 T8KMkCK5mqcPhfa06IVEV48Uuu9khHZJbkVG2PTaYVKluNxZ+u9iELFfK5JAVWhbwEB0
 zxJsus4bSYok+xfd4rDoE7VkP+lZPOWMDkVkdQuvN66JZ/2XbTisSNrs5KG07gFumMGO
 UYBA==
X-Gm-Message-State: AOAM533sfRQ9T42WNJ/l6HZj+Dbf/Y10sI1LYqd0t2LEov7+vIJCQHCx
 nH3hUow7MFiXYZ443okL1H7/tgeIrP/DZxu4bMgKpupRW7TIDT/SLFoegEEGmR2HULxgwMfkVu4
 qQc7OEMEzHv4/o35/gtUMcBDfVFF1dRCZMs5zLn+Bso+0H5G3W0OcFVxA+bA+S1ZGjOE=
X-Google-Smtp-Source: ABdhPJw3tryWXJT3EFvXJKKt9agcIqsoHY0evVKNv/qv6pjB5RoCSQQ/BO2TYjmoqow8vwgbItMGRJsLYA==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a05:6214:529:: with SMTP id
 x9mr15850705qvw.0.1626710653088; Mon, 19 Jul 2021 09:04:13 -0700 (PDT)
Date: Mon, 19 Jul 2021 17:03:43 +0100
In-Reply-To: <20210719160346.609914-1-tabba@google.com>
Message-Id: <20210719160346.609914-13-tabba@google.com>
Mime-Version: 1.0
References: <20210719160346.609914-1-tabba@google.com>
X-Mailer: git-send-email 2.32.0.402.g57bb445576-goog
Subject: [PATCH v3 12/15] KVM: arm64: Move sanitized copies of CPU features
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
 arch/arm64/kvm/hyp/nvhe/sys_regs.c    | 2 ++
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index d938ce95d3bd..925c7db7fa34 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -25,12 +25,6 @@ struct host_kvm host_kvm;
 
 static struct hyp_pool host_s2_pool;
 
-/*
- * Copies of the host's CPU features registers holding sanitized values.
- */
-u64 id_aa64mmfr0_el1_sys_val;
-u64 id_aa64mmfr1_el1_sys_val;
-
 static const u8 pkvm_hyp_id = 1;
 
 static void *host_s2_zalloc_pages_exact(size_t size)
diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
index 6c7230aa70e9..e928567430c1 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -20,6 +20,8 @@
  */
 u64 id_aa64pfr0_el1_sys_val;
 u64 id_aa64pfr1_el1_sys_val;
+u64 id_aa64mmfr0_el1_sys_val;
+u64 id_aa64mmfr1_el1_sys_val;
 u64 id_aa64mmfr2_el1_sys_val;
 
 /*
-- 
2.32.0.402.g57bb445576-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
