Return-Path: <SRS0=mTyv=AV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A399BC433E0
	for <kvmarm@archiver.kernel.org>; Fri, 10 Jul 2020 09:58:28 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1493420767
	for <kvmarm@archiver.kernel.org>; Fri, 10 Jul 2020 09:58:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="EJ8OPLbg"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1493420767
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8A3724B131;
	Fri, 10 Jul 2020 05:58:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tKo9nNohCmCh; Fri, 10 Jul 2020 05:58:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A186E4B142;
	Fri, 10 Jul 2020 05:58:26 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 891764B131
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Jul 2020 05:58:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Z9m9tQvb1hsp for <kvmarm@lists.cs.columbia.edu>;
 Fri, 10 Jul 2020 05:58:24 -0400 (EDT)
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com
 [209.85.128.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 97E444B0CB
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Jul 2020 05:58:24 -0400 (EDT)
Received: by mail-wm1-f74.google.com with SMTP id y204so6192217wmd.2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Jul 2020 02:58:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=GNhEApco89hKeFGMDTikTUZ1jYU56W4Cu/VOf+YFTYI=;
 b=EJ8OPLbgST8bx3X2mWTRqR1hlUD8rnPvOeuVmdKliMX8RaFV0S2aGYCA+TXa/03JqC
 CfCoJZlDJBzDegD6Eh64Ku7HuOFTznOGQucv0rHvmQw5whWUFZA2TxnaN5NVT4Co89EH
 WF7pGWf/11e+zFMo9RcnwSL+7tO/CORvsiSgvEVEHeaEDpvWncjCablbYicZRk0hCuJu
 LaxroPSHGnC+zWEgT6mLlOI/F8S/g8BYI0amaC3DpIjb5rgolY2ft9qN4gOQ1wgGe3kT
 LzLkX5qgQ5C51o6hhHSUSkThI47KAgfv5YS2XcJaTaAaJp4T2v3M648GGbrFGF6MEzfz
 EBjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=GNhEApco89hKeFGMDTikTUZ1jYU56W4Cu/VOf+YFTYI=;
 b=tzvWJ40IkT1nq8HxqZBPvnZpRm45Mu7EM1Rg5In9+Pbe1I3X9uO93bV/9zH0etGIpb
 ZbYJAa1d7PPDV/9F9KuU42YEGqCdz4+Q6FM6WxjxdcV9yFKWWCQ80RLoFuZqGSXJTZa2
 urqs80KyB73f4Plbn3OrEPOLNodPKhAYaSC0Sg4b0F3nrd4hh2KGWuJE/pSM51RjQYc0
 1AdE2gjcYrkSnvy8UzGcs5vjTOVJ2WJ9WvUCrS8/CfYkZm+tI7Meenv2TLWustT5h4vF
 CDvOOKl1g/ujWvIuEGPK95qfXlQZ+VNz18QWnlAPVJ9+nTTMPjdu63YjoGFf+XKEoYuG
 SgIw==
X-Gm-Message-State: AOAM530LtgTAnhHe6QKJ3ADcExp59xICD5u/XSAuF5XdCXxTzgNYnlSJ
 3SiVYzCz5e/FhQI2ZNxQaRZCv5RlzSbVeVPzciEJUIEJxA6vdX/UVHuLlAOSOpxJFLnBp7trFK3
 EFTbPCG/1mCFllrPNJpstqESgmsZIE1+w5hiSpTapmAd32PyV482tYlvjbS2JLct5U6GPPQ==
X-Google-Smtp-Source: ABdhPJxRC/ReZJMKdYOnmIK5o/qlZueJC+UxM90jzI7OdaYoXCXvWVV5u3dA552UXu6GhX8+Gfbgxda9wNc=
X-Received: by 2002:a5d:55cb:: with SMTP id i11mr63714584wrw.28.1594375103252; 
 Fri, 10 Jul 2020 02:58:23 -0700 (PDT)
Date: Fri, 10 Jul 2020 10:57:52 +0100
Message-Id: <20200710095754.3641976-1-ascull@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.27.0.383.g050319c2ae-goog
Subject: [PATCH 0/2] Manage vcpu flags from the host
From: Andrew Scull <ascull@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: maz@kernel.org, kernel-team@android.com, dave.martin@arm.com
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

This is a clean up and no functional change is intended.

The aim is to keep management of the flags in the host and out of hyp. I
find this makes it easier to understand how the flags are used.

This is the result of a previous thread with Dave where it was explained
that there is an intent to synchronize the flags in clearly defined
places <20200707145713.287710-1-ascull@google.com>

Andrew Scull (2):
  KVM: arm64: Leave KVM_ARM64_DEBUG_DIRTY updates to the host
  KVM: arm64: Leave vcpu FPSIMD synchronization in host

 arch/arm64/include/asm/kvm_host.h         |  7 ++-
 arch/arm64/kvm/arm.c                      |  4 +-
 arch/arm64/kvm/debug.c                    |  2 +
 arch/arm64/kvm/fpsimd.c                   | 57 ++++++++++++++++-------
 arch/arm64/kvm/hyp/include/hyp/debug-sr.h |  2 -
 arch/arm64/kvm/hyp/include/hyp/switch.h   | 19 --------
 arch/arm64/kvm/hyp/nvhe/switch.c          |  3 +-
 arch/arm64/kvm/hyp/vhe/switch.c           |  3 +-
 8 files changed, 51 insertions(+), 46 deletions(-)

-- 
2.27.0.383.g050319c2ae-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
