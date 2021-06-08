Return-Path: <SRS0=ky3n=LC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC9FAC4743D
	for <kvmarm@archiver.kernel.org>; Tue,  8 Jun 2021 11:45:31 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 52AB26135D
	for <kvmarm@archiver.kernel.org>; Tue,  8 Jun 2021 11:45:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 52AB26135D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BBF8B402DB;
	Tue,  8 Jun 2021 07:45:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ye91P5i5wOOj; Tue,  8 Jun 2021 07:45:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C8C0B407ED;
	Tue,  8 Jun 2021 07:45:26 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C8AB3407B0
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Jun 2021 07:45:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KSE-mbMLaTJX for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Jun 2021 07:45:24 -0400 (EDT)
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com
 [209.85.128.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 89F26402DB
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Jun 2021 07:45:24 -0400 (EDT)
Received: by mail-wm1-f74.google.com with SMTP id
 n2-20020a05600c3b82b02901aeb7a4ac06so1082470wms.5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 08 Jun 2021 04:45:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=vVP6MnE5jtfCRNBSFEk8Tts1aw1n4jW8xd82TUR2TLU=;
 b=bsninEwjms+mWvprSOPlfQ4X/AFVMRBlxagtmZ/Wb9PNB3vao021HDHSnPOnN1bbG8
 c/k1nJyU8KGyKg1CHj50UHzW9860yE4GUoBteLsOMatA76Lnku3N9/7yQFSdd+cu5tux
 1SOqFVEshQtQlXFDUf63YvlroPYZPvMZ1fAiSZhJwcR+rtqz4AEfZ7lL6lcqyYN9SeZk
 o4cGRh/9uY15ziLA+Tvu3lz2eJUlm4PJC9zpyFs1VslISm3QD3Xsj0cgmyVUt8FAIg89
 GoKfasGi/ePTYi1DRf5IbMaWAjvN7QRM4W2XfRJnlvP/FrdhyMmyOUrGuUXgV8WSVN8J
 0AoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=vVP6MnE5jtfCRNBSFEk8Tts1aw1n4jW8xd82TUR2TLU=;
 b=ilBGnMQueOOlvU0n7SHAbYYw/4WLDy8+W7enV0pMQq+FlJAGjonnAyvKNfKWxUmU46
 HImGJAoGp4hCWIxSgDQx3PvmFonVAj5nrWZBxVH8bAsXBo4aU9r7d3m05D5g7wh9SapU
 7uT5g54l9lkmPZ5ElsdX+waAOvYeocbKz5t5rC0WF903HGLNgi1P/LH+dT5fxHHGpvZn
 BwpJS07yCXWyjSv/p9bcglNUlgyQZ6qwNHeSkWz/Ax8/OhN9awaPEtWbpmj2Ozwl5hq7
 Qw50sUmI06AUASbq55YKXy72H90lGGodElBOHifGZdy4BamphxCsR08Pq8vSxzTVwli6
 kHXg==
X-Gm-Message-State: AOAM532NChMaNMzTkpr14ZWjBqWq3wg2LeU1TgHoQYIZJtr5HopmEB78
 gkIopiiLgb92q1ckDw5zukLh3XJHmbR/
X-Google-Smtp-Source: ABdhPJxnQTZBsAgtPXFz17t2riToek8ZifdE5myRG5kTzUVYdJXzhpzMu8D3AEklq9Tq4ufpuZnb/AOKJ/Uu
X-Received: from r2d2-qp.c.googlers.com
 ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:a7b:c013:: with SMTP id
 c19mr3738933wmb.158.1623152723285; Tue, 08 Jun 2021 04:45:23 -0700 (PDT)
Date: Tue,  8 Jun 2021 11:45:11 +0000
Message-Id: <20210608114518.748712-1-qperret@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.rc1.229.g3e70b5a671-goog
Subject: [PATCH v3 0/7] KVM: arm64: Reduce hyp_vmemmap overhead
From: Quentin Perret <qperret@google.com>
To: maz@kernel.org, will@kernel.org, james.morse@arm.com, 
 alexandru.elisei@arm.com, catalin.marinas@arm.com, suzuki.poulose@arm.com
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

Hi all,

This is a v3 of the patch series previously posted here:

  https://lore.kernel.org/r/20210602094347.3730846-1-qperret@google.com

Please refer to the cover letter of v1 for the context and motivation
behind the series.

Changes since v2:
 - Rebased on kvmarm/next

Thanks,
Quentin

Quentin Perret (7):
  KVM: arm64: Move hyp_pool locking out of refcount helpers
  KVM: arm64: Use refcount at hyp to check page availability
  KVM: arm64: Remove list_head from hyp_page
  KVM: arm64: Unify MMIO and mem host stage-2 pools
  KVM: arm64: Remove hyp_pool pointer from struct hyp_page
  KVM: arm64: Use less bits for hyp_page order
  KVM: arm64: Use less bits for hyp_page refcount

 arch/arm64/kvm/hyp/include/nvhe/gfp.h         |  45 +------
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |   2 +-
 arch/arm64/kvm/hyp/include/nvhe/memory.h      |   7 +-
 arch/arm64/kvm/hyp/include/nvhe/mm.h          |  13 +-
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         |  60 +++++-----
 arch/arm64/kvm/hyp/nvhe/page_alloc.c          | 112 +++++++++++++-----
 arch/arm64/kvm/hyp/nvhe/setup.c               |  30 +++--
 arch/arm64/kvm/hyp/reserved_mem.c             |   3 +-
 8 files changed, 145 insertions(+), 127 deletions(-)

-- 
2.32.0.rc1.229.g3e70b5a671-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
