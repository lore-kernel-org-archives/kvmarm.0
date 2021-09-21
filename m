Return-Path: <SRS0=n474=OM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 958B2C433EF
	for <kvmarm@archiver.kernel.org>; Wed, 22 Sep 2021 13:12:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 193B460FA0
	for <kvmarm@archiver.kernel.org>; Wed, 22 Sep 2021 13:12:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 193B460FA0
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C0B154B125;
	Wed, 22 Sep 2021 09:12:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9vAhaL5Q2DY6; Wed, 22 Sep 2021 09:11:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8648B4B17C;
	Wed, 22 Sep 2021 09:11:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 97494406E7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Sep 2021 18:22:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DpOmycJHnG0E for <kvmarm@lists.cs.columbia.edu>;
 Tue, 21 Sep 2021 18:22:42 -0400 (EDT)
Received: from mail-qt1-f201.google.com (mail-qt1-f201.google.com
 [209.85.160.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id ADC5E4064F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Sep 2021 18:22:42 -0400 (EDT)
Received: by mail-qt1-f201.google.com with SMTP id
 r6-20020a05622a034600b002a0ba9994f4so3367112qtw.22
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Sep 2021 15:22:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=reply-to:date:in-reply-to:message-id:mime-version:references
 :subject:from:to:cc;
 bh=fe6asXWFzX1XFZzq1x4wsBW8hMTSeHYjNsqHVsCHq7g=;
 b=eV+o7MHP7TJ1wHQqCm2Wyy5n+IVG3LKtSt+UgnoNnssmXw3fD0cefPXnelgq+GjVjr
 9g2hKWvcT6KUhIKypS3wC+X2NLUqbxUgLQR19KNtifP2rjqKyR6MXfYtUCH5/7QswDxf
 FOyLvSgu1SgP/xkZYIUffAaQ7zeFu85jIXz8vchCoJu5QIuscL4HPLnEqgX34hHtDWMA
 xrTIHe/h9QmhXMbrbQkNoklcocbevjzN6q0aDxhtulnOO9ApjUqn+pRM44+YdHHEb1ee
 2L4nQWKAeliciloIFeM553LJHMQvjZTnA/Q+IJHnh5eAVzCDELMxtKFLAZLw7x5OUTOp
 u/vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:date:in-reply-to:message-id
 :mime-version:references:subject:from:to:cc;
 bh=fe6asXWFzX1XFZzq1x4wsBW8hMTSeHYjNsqHVsCHq7g=;
 b=7Y+opFaM8VhzF1TnSHzp1oo4BbMg7mjTEcgy5x4Ne0dH5RQNdKa2YK/jKznJhAFoKr
 md5aJcCArQ6tiWsLwmipSL82nLW864UWlPDiueMbO7fevXBQUFbhhNcq2NeAwqBSEk+q
 mfW6KIJkUOmgzKiyp8S5HlyHvZ1jtZ+m/NxHG2HnXoCOZnf0ehaGKJHg5wzx0oJVUEGx
 XPB5jfPpTuRMEO+HDMs+BGtvPgNM8TomZKuziNUQkgBEuA9PcG+F6DUGbbhjvfyexUCn
 6Q2SzWDb9TQHqAaCAYbxmD0a2LZqUvFdZgVXs+sN/spR3SbnE1ZrNG+2RnmBDhWKCS91
 7uFw==
X-Gm-Message-State: AOAM533TzDMRdwDBIBpo+CBZ53nqvM5K9ZPhV2DkbTiJK/xWWZ4iTB1q
 3eiqp9xX4q5dEcA3LGcXSUzvXcjOVYg=
X-Google-Smtp-Source: ABdhPJx8/aQldYVlTK2IJCFfsX+ImwbCtnIVcIzBZCgyIrvMxEU+TrcEbmTAAYdj+46Ml9lwoGi29S9f6xs=
X-Received: from seanjc798194.pdx.corp.google.com
 ([2620:15c:90:200:b022:92d6:d37b:686c])
 (user=seanjc job=sendgmr) by 2002:a25:ad25:: with SMTP id
 y37mr40583994ybi.407.1632262962301; 
 Tue, 21 Sep 2021 15:22:42 -0700 (PDT)
Date: Tue, 21 Sep 2021 15:22:31 -0700
In-Reply-To: <20210921222231.518092-1-seanjc@google.com>
Message-Id: <20210921222231.518092-3-seanjc@google.com>
Mime-Version: 1.0
References: <20210921222231.518092-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
Subject: [PATCH 2/2] KVM: arm64: Depend on HAVE_KVM => OF instead of directly
 on OF
From: Sean Christopherson <seanjc@google.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Marc Zyngier <maz@kernel.org>
X-Mailman-Approved-At: Wed, 22 Sep 2021 09:11:52 -0400
Cc: Sean Christopherson <seanjc@google.com>, linux-kernel@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
Reply-To: Sean Christopherson <seanjc@google.com>
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

Select HAVE_KVM if the KVM dependency is met (OF / Open Firmware), and
make KVM depend on HAVE_KVM instead of directly on OF.  This fixes the
oddity where arm64 configs can end up with KVM=y and HAVE_KVM=n, and will
hopefully prevent breakage if there are future users of HAVE_KVM.

Note, arm64 unconditionally selects OF, and has always done so (see
commit 8c2c3df31e3b ("arm64: Build infrastructure").  Keep the somewhat
pointless HAVE_KVM dependency on OF to document that KVM requires Open
Firmware support.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/arm64/Kconfig     | 1 +
 arch/arm64/kvm/Kconfig | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index b5b13a932561..38c0f36a5ed4 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -187,6 +187,7 @@ config ARM64
 	select HAVE_GCC_PLUGINS
 	select HAVE_HW_BREAKPOINT if PERF_EVENTS
 	select HAVE_IRQ_TIME_ACCOUNTING
+	select HAVE_KVM if OF
 	select HAVE_NMI
 	select HAVE_PATA_PLATFORM
 	select HAVE_PERF_EVENTS
diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index c50f75cf76fe..e1e400bd8de5 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -20,7 +20,7 @@ if VIRTUALIZATION
 
 menuconfig KVM
 	bool "Kernel-based Virtual Machine (KVM) support"
-	depends on OF
+	depends on HAVE_KVM
 	select MMU_NOTIFIER
 	select PREEMPT_NOTIFIERS
 	select HAVE_KVM_CPU_RELAX_INTERCEPT
-- 
2.33.0.464.g1972c5931b-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
