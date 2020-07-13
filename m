Return-Path: <SRS0=IpCr=AY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00A06C433E1
	for <kvmarm@archiver.kernel.org>; Mon, 13 Jul 2020 21:05:16 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 76E732075D
	for <kvmarm@archiver.kernel.org>; Mon, 13 Jul 2020 21:05:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="lEz7tqPP"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 76E732075D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BFE424B1FB;
	Mon, 13 Jul 2020 17:05:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bOrI8K7kbTBB; Mon, 13 Jul 2020 17:05:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A7A74B1D8;
	Mon, 13 Jul 2020 17:05:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 367484B1C7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Jul 2020 17:05:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VKX-4i3IOomq for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Jul 2020 17:05:11 -0400 (EDT)
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com
 [209.85.221.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2946C4B1B1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Jul 2020 17:05:11 -0400 (EDT)
Received: by mail-wr1-f73.google.com with SMTP id a18so18830305wrm.14
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Jul 2020 14:05:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=ziKNcPx7mU0h4C5IgXl4an8Odkm/fc+QyB7gdPVhFVA=;
 b=lEz7tqPPJnbsh0q87uzZb4VBXqbT6y4t6wECz/AdUnzIW3a115t4KuGHCj99RtjuQo
 9/VaVL4Nyl7shHVo0lYvHmoYvI9JZi76b7BtfsrgVboksHubJWyR6qJRL1vVf0sF+Kpi
 NxJJcJ8/xpWV4rvXLWI03jqSDomNbOgdtftEeNksWNojv6Joc5yX2KAg/Gy2xMZ7BUSm
 BnShmzqPF7QFwjU0tON+Ie7pdsQq3OfJ2SBTgNrBXy5WmoLzrNEOXFNU5bSKxfvBCxJO
 YDD211qo7yq/9nmPDCHrpmBWZYt4YaoS/royfrVq0lQxs9gsneHHYUdQ7MO9q0QZLZ32
 VRoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=ziKNcPx7mU0h4C5IgXl4an8Odkm/fc+QyB7gdPVhFVA=;
 b=f+Wl1GBl3HulnGGNQyKRrG4vbpiY+JO1EFbIhgZHm4EDfodwpVK8Qn4Kce3JrDvQAR
 yF9jhFxLIx9jSTl+3xkIWyydNUGNkPELWsy6Oz5Ib4aWN+y1vBlGpwCCisdfU4u0Oyv3
 oxmplbH9mYI+DGzoaw4jK+8HDbYqOFsDJrdkY4xyjBz3i6t1Va+ttz6E34lKXRQSRmbv
 2ap1Rdx+Uru5j+CmWTSqHimYQl1Gwl7bshdXQbtZVCQcXkMJTg/PYqXOw8uCnK0pke4w
 6F53LXJYc/133pqZWhrn3ld4L61q34imT346k7U88wDCl/VUVtLVSQSMAE9cOxNXuJ8w
 /GWQ==
X-Gm-Message-State: AOAM532oxk6GfyTrTdFhJ2XHphrYGCdBvsrVZApIbM13BdnwGvW3hePE
 Gjpju0JyOyg7eG+Isu8nAB0EIY0BdnwvNLPoeZWuHVjpmRgDww6wr73WZpiPulbqfkRli3lO2aA
 scq2b8H/zA/9OrtqF7jpxIExJKNEC9iLBza81TFM8KJrZNK/SQIhMH5Kykp9+U4RQai/gDQ==
X-Google-Smtp-Source: ABdhPJy/S9lUGS6bveEViLpzTWT0Pd/cZUYrnQEWiIzZWncK5zmojqLxKYTh84BBdj1KxlWIIHTKgrMMawM=
X-Received: by 2002:a1c:1d93:: with SMTP id d141mr1185923wmd.14.1594674309834; 
 Mon, 13 Jul 2020 14:05:09 -0700 (PDT)
Date: Mon, 13 Jul 2020 22:05:01 +0100
Message-Id: <20200713210505.2959828-1-ascull@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.27.0.383.g050319c2ae-goog
Subject: [PATCH v2 0/4] Manage vcpu flags from the host
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

The aim is to keep management of the flags in the host and out of hyp
where possible. I find this makes it easier to understand how the flags
are used as the responsibilities are clearly divided.

The series applies on top of kvmarm/next after VHE and nVHE have been
separated.

From v1 <20200710095754.3641976-1-ascull@google.com>:
 - Split FP change into smaller patches
 - Addressed Dave's other comments

Andrew Scull (4):
  KVM: arm64: Leave KVM_ARM64_DEBUG_DIRTY updates to the host
  KVM: arm64: Predicate FPSIMD vcpu flags on feature support
  KVM: arm64: Leave vcpu FPSIMD synchronization in host
  KVM: arm64: Stop mapping host task thread flags to hyp

 arch/arm64/include/asm/kvm_host.h         |  7 ++-
 arch/arm64/kvm/arm.c                      |  4 +-
 arch/arm64/kvm/debug.c                    |  2 +
 arch/arm64/kvm/fpsimd.c                   | 54 ++++++++++++++++-------
 arch/arm64/kvm/hyp/include/hyp/debug-sr.h |  2 -
 arch/arm64/kvm/hyp/include/hyp/switch.h   | 19 --------
 arch/arm64/kvm/hyp/nvhe/switch.c          |  3 +-
 arch/arm64/kvm/hyp/vhe/switch.c           |  3 +-
 8 files changed, 48 insertions(+), 46 deletions(-)

-- 
2.27.0.383.g050319c2ae-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
