Return-Path: <SRS0=xhzu=LJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C45A5C49361
	for <kvmarm@archiver.kernel.org>; Tue, 15 Jun 2021 13:40:00 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 584A261481
	for <kvmarm@archiver.kernel.org>; Tue, 15 Jun 2021 13:40:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 584A261481
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F23DE4B107;
	Tue, 15 Jun 2021 09:39:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ezDHgsOOm2wW; Tue, 15 Jun 2021 09:39:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A89604B0ED;
	Tue, 15 Jun 2021 09:39:57 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E56854B0D2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Jun 2021 09:39:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id v8AZGrYlLGj8 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Jun 2021 09:39:56 -0400 (EDT)
Received: from mail-qv1-f73.google.com (mail-qv1-f73.google.com
 [209.85.219.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0B6334B0CD
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Jun 2021 09:39:56 -0400 (EDT)
Received: by mail-qv1-f73.google.com with SMTP id
 a2-20020ad441c20000b0290251bb08ce61so4802782qvq.19
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Jun 2021 06:39:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=3CDZtfonJ6Kn0YHhhj73hjP54PoBU2rnCZTJCgmS6Ek=;
 b=JwmZkhwZ0+KjEQ3/dK0BZHYgAZwsVcpyKPxOiybVfwZM7HxKzOvL9ECy20QZQCuDdH
 Y/gkSzrqWNwnI9h0nwDwprMsEipVhr/Eu2ESMTLqDQ0YmHVOuZKNKur2hikmhArCr1q1
 tNBc9T+04c62v/wohI+qHWPudpvjhj2gEYdK5Zx0inaHlVlthoxZAeOwtPPfZ10tm7wA
 JM5Gf0QzlKZu4aZTJaj7SrHQ2LHHFDPY6iluxTiMZVJsmoz/WA6UJ0ZV3wlXo7k0mQjI
 wy3CkKZtNkK2E6ApH1rjqC7WVlIJZY8nYOTehL/WO0r5e1EUpAf+x4IyUVpH3kuLJOnJ
 kvaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=3CDZtfonJ6Kn0YHhhj73hjP54PoBU2rnCZTJCgmS6Ek=;
 b=GKOf4zBKngiJHUCl2LHYYrxBTlR9U8jpmvYIlm6LwOv2NOBnGpDhKq3CBsBKvNMH4Q
 RLgPe14mhVtnfF0ONB5IL1/ImQZrso0oLk6oIUnHhC37yKr+QGirG/aflbl1N38xDA4O
 FvtwJTGNnTL4dKrI2ZntkZ3pOHtEfJgBB6OSL/o1YFhQZKMjeHqZHkcva0CjqqpVYEww
 RhgZ9hrnpNwzIsnwl2ddl3M7wW1uEvkkJEwVCx/93w/3ZuX1JBhF8St6TFaxXMA51WoS
 dASpo86TmtKqEji73jNX2WvmxwyuASOezO7FbdTrlIbivhz3C921LaQHUh1pueC9X+Cl
 juKw==
X-Gm-Message-State: AOAM533/pHcUB2zxve1Mai1f7GAHy2alNfvfQuKgkGzvM056hFJXgV6E
 wARRE1v9XIGbmmgGYrwQhzftijprcHoXGiuOB85ukd3BggGRO2y0EtQoywdeprBrt/upuwY8ZuD
 PxP58jZvSmFzQnAqp0ITP/mTwKV4LN7OtMhlHvLKeLRMsWZMJNdRbEmSIqQKuWQpk4EA=
X-Google-Smtp-Source: ABdhPJx9VNK6pVq9QAAsYb7IoPgKgLtqLpsG5afdZqLH2tZYOQNCIUUUbr3GlXuAnKQu+b0JevOAo+NnnQ==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a0c:ca94:: with SMTP id
 a20mr5113188qvk.49.1623764395363; 
 Tue, 15 Jun 2021 06:39:55 -0700 (PDT)
Date: Tue, 15 Jun 2021 14:39:38 +0100
In-Reply-To: <20210615133950.693489-1-tabba@google.com>
Message-Id: <20210615133950.693489-2-tabba@google.com>
Mime-Version: 1.0
References: <20210615133950.693489-1-tabba@google.com>
X-Mailer: git-send-email 2.32.0.272.g935e593368-goog
Subject: [PATCH v2 01/13] KVM: arm64: Remove trailing whitespace in comments
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

Editing this file later, and my editor always cleans up trailing
whitespace. Removing it earler for clearer future patches.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/sys_regs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 1a7968ad078c..15c247fc9f0c 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -318,14 +318,14 @@ static bool trap_dbgauthstatus_el1(struct kvm_vcpu *vcpu,
 /*
  * We want to avoid world-switching all the DBG registers all the
  * time:
- * 
+ *
  * - If we've touched any debug register, it is likely that we're
  *   going to touch more of them. It then makes sense to disable the
  *   traps and start doing the save/restore dance
  * - If debug is active (DBG_MDSCR_KDE or DBG_MDSCR_MDE set), it is
  *   then mandatory to save/restore the registers, as the guest
  *   depends on them.
- * 
+ *
  * For this, we use a DIRTY bit, indicating the guest has modified the
  * debug registers, used as follow:
  *
-- 
2.32.0.272.g935e593368-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
