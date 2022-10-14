Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24863C433FE
	for <kvmarm@archiver.kernel.org>; Fri, 14 Oct 2022 18:46:41 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6BFE040B62;
	Fri, 14 Oct 2022 14:46:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@chromium.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id CbBo0i43BxVs; Fri, 14 Oct 2022 14:46:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3FF374B621;
	Fri, 14 Oct 2022 14:46:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9CEFA4B0E6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 14 Oct 2022 14:46:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WGuc7siQXqQD for <kvmarm@lists.cs.columbia.edu>;
 Fri, 14 Oct 2022 14:46:37 -0400 (EDT)
Received: from mail-pf1-f195.google.com (mail-pf1-f195.google.com
 [209.85.210.195])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5BB5D40DE6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 14 Oct 2022 14:46:37 -0400 (EDT)
Received: by mail-pf1-f195.google.com with SMTP id m6so5755441pfb.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 14 Oct 2022 11:46:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chromium.org; s=google;
 h=content-transfer-encoding:mime-version:message-id:date:subject:cc
 :to:from:from:to:cc:subject:date:message-id:reply-to;
 bh=r9b1WxYCtQHAvJQbAPYaXXw5JIstR8dPjphyBTVotDg=;
 b=C9ChpAljNx+6EX+b7MIXOhJ/DxR1oEgil1ZdehQzrOHu0htP0Wb4hihn7cdKw7kusB
 unlXoi0fYM8ckb4UqUThqiouQ/fgrebyEJmB7iEik2j7ocpYju1X+GtQNb/e2THXGyfu
 pdn2pYHgdd7SXL+E5NiLfpnCE8W4Xn9DguZTY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:message-id:date:subject:cc
 :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=r9b1WxYCtQHAvJQbAPYaXXw5JIstR8dPjphyBTVotDg=;
 b=j+9qTd767buA8ItQLNBVwhgp1tIgNFwclPXhlo7g+fo5YUY9kpIhlllAQ/GhgIAusc
 IsOaGXbLC6bPsZJdvvK+IA+IJXKDrTSoLxGnha/UrRW38PQFxsw2pmNjXSz0OViwYvHd
 kicGJJ2DCwG7Lpp1Bhdd4O6TjhJT2ETp9VEPa/iIkopbD4kbaeZdX2N1zqSJvBRF/e99
 VXZJr3XwE5z5rpKlh+uiyvde4y75rw6/6Gp82neMTlfS/PKCrwyznlIi+NQNED/IdsSp
 khMrvlZKyEmPMta2gbzvwMYFIKMgmuvHTzWKJvvB0wGFZKXceiijbQHcbxm7ffDT0e3C
 yAfg==
X-Gm-Message-State: ACrzQf09Wr6m6RtWM2Pz1/JCqkzCnVT9JMdfpeGPyd3CB1cO0Nye9JD4
 5Lnq2PxlgeJQX7lEudw8UofCFg==
X-Google-Smtp-Source: AMsMyM4KxZFUnZ3+JVUZbSV1KdBMKe5N17ONrn6zYeMpUbJ+0CiKCyk427n5W/she7eWjJeNE5SITA==
X-Received: by 2002:a05:6a00:1707:b0:562:e790:dfc3 with SMTP id
 h7-20020a056a00170700b00562e790dfc3mr6609803pfc.59.1665773196248; 
 Fri, 14 Oct 2022 11:46:36 -0700 (PDT)
Received: from localhost ([2620:15c:2ce:200:e8c9:5029:f577:f6ca])
 by smtp.gmail.com with UTF8SMTPSA id
 203-20020a6217d4000000b0053653c6b9f9sm2047145pfx.204.2022.10.14.11.46.34
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 14 Oct 2022 11:46:35 -0700 (PDT)
From: Denis Nikitin <denik@chromium.org>
To: Marc Zyngier <maz@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>
Subject: [PATCH v3] KVM: arm64: nvhe: Fix build with profile optimization
Date: Fri, 14 Oct 2022 11:45:32 -0700
Message-Id: <20221014184532.3153551-1-denik@chromium.org>
X-Mailer: git-send-email 2.38.0.413.g74048e4d9e-goog
MIME-Version: 1.0
Cc: Denis Nikitin <denik@chromium.org>,
 Nick Desaulniers <ndesaulniers@google.com>, linux-kernel@vger.kernel.org,
 Manoj Gupta <manojgupta@google.com>, kvmarm@lists.linux.dev,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

Kernel build with clang and KCFLAGS=-fprofile-sample-use=<profile> fails with:

error: arch/arm64/kvm/hyp/nvhe/kvm_nvhe.tmp.o: Unexpected SHT_REL
section ".rel.llvm.call-graph-profile"

Starting from 13.0.0 llvm can generate SHT_REL section, see
https://reviews.llvm.org/rGca3bdb57fa1ac98b711a735de048c12b5fdd8086.
gen-hyprel does not support SHT_REL relocation section.

Filter out profile use flags to fix the build with profile optimization.

Signed-off-by: Denis Nikitin <denik@chromium.org>
---
V2 -> V3: Filter out the profile-use flags.
V1 -> V2: Remove the relocation instead of disabling the profile-use flags.
---
 arch/arm64/kvm/hyp/nvhe/Makefile | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index b5c5119c7396..16c6abdda494 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -89,6 +89,10 @@ quiet_cmd_hypcopy = HYPCOPY $@
 # Remove ftrace, Shadow Call Stack, and CFI CFLAGS.
 # This is equivalent to the 'notrace', '__noscs', and '__nocfi' annotations.
 KBUILD_CFLAGS := $(filter-out $(CC_FLAGS_FTRACE) $(CC_FLAGS_SCS) $(CC_FLAGS_CFI), $(KBUILD_CFLAGS))
+# Starting from 13.0.0 llvm emits SHT_REL section '.llvm.call-graph-profile'
+# when profile optimization is applied. gen-hyprel does not support SHT_REL and
+# causes a build failure. Remove profile optimization flags.
+KBUILD_CFLAGS := $(filter-out -fprofile-sample-use=% -fprofile-use=%, $(KBUILD_CFLAGS))
 
 # KVM nVHE code is run at a different exception code with a different map, so
 # compiler instrumentation that inserts callbacks or checks into the code may
-- 
2.38.0.413.g74048e4d9e-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
