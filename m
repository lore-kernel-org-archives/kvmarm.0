Return-Path: <SRS0=xLVY=HF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3F94C433E6
	for <kvmarm@archiver.kernel.org>; Wed,  3 Feb 2021 14:19:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5A0D364F51
	for <kvmarm@archiver.kernel.org>; Wed,  3 Feb 2021 14:19:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5A0D364F51
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EDF1C4B28C;
	Wed,  3 Feb 2021 09:19:44 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Z8FcHUXpF285; Wed,  3 Feb 2021 09:19:44 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C83514B27F;
	Wed,  3 Feb 2021 09:19:43 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BD3894B276
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Feb 2021 09:19:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BoWd0V+bh0e2 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  3 Feb 2021 09:19:40 -0500 (EST)
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com
 [209.85.221.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A44194B270
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Feb 2021 09:19:40 -0500 (EST)
Received: by mail-wr1-f74.google.com with SMTP id x7so14697516wrp.9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 03 Feb 2021 06:19:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=3+fgEg8CcwEZPzx5ba9dQiG1Bbp/LPpxkX/DyY7YReU=;
 b=ECa2T6w6Xzk+c+UXae/1//JfQrHaqmwEkNwbH6t+u9iPQ+/taS5oBKC8Gdqmp/aqiS
 aWV1vP6sIY7I+36pxfKtp6BYAhvNYVM64tQOefQf3JpLHeq5B5y7sSNryppKrNjWC09F
 KQQw/1A6xu6SK5Ii45Ua8ZLlMnDnoZjIvHpqAo5Dh84Q+1sfak9uVyPdlgkGcyuMPrAI
 wB88GN04WPUz/e/1yHNgAd0LN897HqvJADs9WusShW2qlUqp7oHeS/3lUgZFXR+SgmIx
 5TRBYFlfBEMGsSEHF4P6X7W+Hdy05RHZMqLi2jrB0fCxInNLjLcZo1WaTrAND7O1t9AA
 BuBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=3+fgEg8CcwEZPzx5ba9dQiG1Bbp/LPpxkX/DyY7YReU=;
 b=J0YCcaHaWFb5mLAqtHn7Cg4nFULKRbARgim6TwvV01TNqkyXW5HMZ13rKN48GTohmG
 dQf4171RcEOhoGeGwIqQxY133ShHcSSNUNMBZrvmUHspEXAPys8bCfVFhBJ1mOpmJfOU
 ZocMQ6/ej+hIQcHSM5Bnqc+B7Xe4ITJlyighyeVv+8q6WMcfPtJgzY3TwHSfx7yIlGAr
 35N/ehVp43Yasvlfl7EwpPeaAEYli4VKY2jujDh+lquGG7f3pYiSo3b3baV7gz8WETT4
 afoGMPAK/kNnLgWaCUyJJhHPnHuFdXEGO0GaL+ESfAouKvUMC9225si/aZS6s9yqGBdr
 booQ==
X-Gm-Message-State: AOAM532UuQTKs7c9JSRMqzaMMUGCH82fji/107ztthTbIoQE7VDLLwc0
 fiYyO+z4f/ltU5xq3vbPvJ2xyeYDB3sW
X-Google-Smtp-Source: ABdhPJyxHdPdDI/OtCdUuxvsWAYFicQkJiykIbbaVqcEXDzFTBrAuOyz3VUX4A/8Da4tuA80b98i9u7Cj/PZ
X-Received: from r2d2-qp.c.googlers.com
 ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:a7b:c044:: with SMTP id
 u4mr1036932wmc.1.1612361978973; Wed, 03 Feb 2021 06:19:38 -0800 (PST)
Date: Wed,  3 Feb 2021 14:19:31 +0000
In-Reply-To: <20210203141931.615898-1-qperret@google.com>
Message-Id: <20210203141931.615898-3-qperret@google.com>
Mime-Version: 1.0
References: <20210203141931.615898-1-qperret@google.com>
X-Mailer: git-send-email 2.30.0.365.g02bc693789-goog
Subject: [PATCH 2/2] KVM: arm64: Stub EXPORT_SYMBOL for nVHE EL2 code
From: Quentin Perret <qperret@google.com>
To: arnd@arndb.de, maz@kernel.org, catalin.marinas@arm.com, will@kernel.org
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 kernel-team@android.com, ardb@kernel.org
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

In order to ensure the module loader does not get confused if a symbol
is exported in EL2 nVHE code (as will be the case when we will compile
e.g. lib/memset.S into the EL2 object), make sure to stub all exports
using __DISABLE_EXPORTS in the nvhe folder.

Suggested-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/nvhe/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index 1f1e351c5fe2..c9c121c8d5de 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -3,8 +3,8 @@
 # Makefile for Kernel-based Virtual Machine module, HYP/nVHE part
 #
 
-asflags-y := -D__KVM_NVHE_HYPERVISOR__
-ccflags-y := -D__KVM_NVHE_HYPERVISOR__
+asflags-y := -D__KVM_NVHE_HYPERVISOR__ -D__DISABLE_EXPORTS
+ccflags-y := -D__KVM_NVHE_HYPERVISOR__ -D__DISABLE_EXPORTS
 
 obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o hyp-init.o host.o \
 	 hyp-main.o hyp-smp.o psci-relay.o
-- 
2.30.0.365.g02bc693789-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
