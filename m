Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33D1EC4332F
	for <kvmarm@archiver.kernel.org>; Sun, 18 Dec 2022 05:15:33 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9CBDF43C6F;
	Sun, 18 Dec 2022 00:15:32 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered)
	header.i=@daynix-com.20210112.gappssmtp.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5c+lZkJIMLCA; Sun, 18 Dec 2022 00:15:31 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4B2EE4B349;
	Sun, 18 Dec 2022 00:15:31 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 06AD043C6F
 for <kvmarm@lists.cs.columbia.edu>; Sun, 18 Dec 2022 00:15:30 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IUCyXXCrhX3Q for <kvmarm@lists.cs.columbia.edu>;
 Sun, 18 Dec 2022 00:15:25 -0500 (EST)
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com
 [209.85.216.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A44DB43482
 for <kvmarm@lists.cs.columbia.edu>; Sun, 18 Dec 2022 00:15:25 -0500 (EST)
Received: by mail-pj1-f41.google.com with SMTP id
 b13-20020a17090a5a0d00b0021906102d05so6056341pjd.5
 for <kvmarm@lists.cs.columbia.edu>; Sat, 17 Dec 2022 21:15:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=daynix-com.20210112.gappssmtp.com; s=20210112;
 h=content-transfer-encoding:mime-version:message-id:date:subject:cc
 :to:from:from:to:cc:subject:date:message-id:reply-to;
 bh=a01G1GBaf3qfiSutprsFR/TlqOiwESaNiFiCPW34lhQ=;
 b=oB2m/VIEAkS9xOaITyE3rjE56r6CApd8uv6/I9Uhzf8pGv9vmJR578c5JqGMjoKvPv
 kRaPQEyoEv/UxuTchSJGFAhseLU8GEBHWCYoQenv0Ni/ERulgVgmbY3R/CwgWJw/TvAs
 3IeonmoVwK5kmEVznc8OofYBZSw1es2YvP7mL6RU21/0ABA/Kh6iBYlEl6MlbLsjVe4X
 ALHKRtXC/iDcupj1w/c56rFgGtEO3dQpCE4BWpSytHZIad5dgzuxbns1fNb3nFkpVaw0
 ts9lgWdtWxzOk2YhyxanXAGFYk4O0Rk9MCFkzxjA6qSrJb/6shjAA5V82VzCfyKPQ4Og
 HTbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:message-id:date:subject:cc
 :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=a01G1GBaf3qfiSutprsFR/TlqOiwESaNiFiCPW34lhQ=;
 b=2wvIJ5Bt6gLy08wW2H7FcJA84Bt2DlyvGwlLZPCAKlmeSx9Kli75odcEnIZLF9ONEc
 tHkGfgSjB1QJT5a2mn4DK9fmofD8shzLCJYRTtHYIOJOr9EpzOi5/p490yleiDzHfFJv
 n08n/dOgs84sL6xoFuZynL1P55pLdQYZiWty9sl/3cFsazUPphKKcO/R7KSM2uQ3NNtc
 IGxEAKnFo5384zlu133k4PqtsOpomMHtyaCkHGWCuOagw+89Vja+2KWSfnRAbIKqFEUQ
 nP119Fdcc5HlvBurFtbBDeggdL+nsdvH39lPRwoZWdTGiJie6vpZPYwjiNnC4GgMUZrF
 uSpg==
X-Gm-Message-State: ANoB5pmNRZwKn88WZo593KQi3Xlr9OMSFkUXzaaeHO+gYWozjcOJ6Xfq
 ascr4qvNNtjNtu5jzlmaJHGj2g==
X-Google-Smtp-Source: AA0mqf72YV5edT4kAgOZXEWT3kE8W12UBWocuqS2BFj9Nm3zqofKc8b75dDfMhucuQYOpxQGxpjPjQ==
X-Received: by 2002:a17:90b:4a8c:b0:219:e763:1d21 with SMTP id
 lp12-20020a17090b4a8c00b00219e7631d21mr39250867pjb.5.1671340524491; 
 Sat, 17 Dec 2022 21:15:24 -0800 (PST)
Received: from fedora.flets-east.jp ([2400:4050:c360:8200:8ae8:3c4:c0da:7419])
 by smtp.gmail.com with ESMTPSA id
 b1-20020a17090a6ac100b002139459e121sm7002417pjm.27.2022.12.17.21.15.20
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sat, 17 Dec 2022 21:15:23 -0800 (PST)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
To: 
Subject: [PATCH v3 0/7] KVM: arm64: Normalize cache configuration
Date: Sun, 18 Dec 2022 14:14:05 +0900
Message-Id: <20221218051412.384657-1-akihiko.odaki@daynix.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Cc: Alyssa Rosenzweig <alyssa@rosenzweig.io>, Hector Martin <marcan@marcan.st>,
 Akihiko Odaki <akihiko.odaki@daynix.com>,
 Mathieu Poirier <mathieu.poirier@linaro.org>, Marc Zyngier <maz@kernel.org>,
 Sven Peter <sven@svenpeter.dev>, linux-kernel@vger.kernel.org,
 Will Deacon <will@kernel.org>, asahi@lists.linux.dev,
 Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.linux.dev,
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

Before this change, the cache configuration of the physical CPU was
exposed to vcpus. This is problematic because the cache configuration a
vcpu sees varies when it migrates between vcpus with different cache
configurations.

Fabricate cache configuration from the sanitized value, which holds the
CTR_EL0 value the userspace sees regardless of which physical CPU it
resides on.

V2 -> V3:
- Corrected message for patch "Normalize cache configuration"
- Split patch "Normalize cache configuration"
- Added handling for CSSELR_EL1.TnD
- Added code to ignore RES0 in CSSELR_EL1
- Replaced arm64_ftr_reg_ctrel0.sys_val with
  read_sanitised_ftr_reg(SYS_CTR_EL0)
- Fixed vcpu->arch.ccsidr initialziation
- Added CCSIDR_EL1 sanitization
- Added FWB check
- Added a comment for CACHE_TYPE_SEPARATE
- Added MTE tag cache creation code for CLIDR_EL1 fabrication
- Removed CLIDR_EL1 reset code for reset caused by guest
- Added a comment for CCSIDR2

V2: https://lore.kernel.org/lkml/20221211051700.275761-2-akihiko.odaki@daynix.com/
V1: https://lore.kernel.org/lkml/525ff263-90b3-5b12-da31-171b09f9ad1b@daynix.com/

Akihiko Odaki (7):
  arm64/sysreg: Convert CCSIDR_EL1 to automatic generation
  arm64/sysreg: Add CCSIDR2_EL1
  arm64/cache: Move CLIDR macro definitions
  KVM: arm64: Always set HCR_TID2
  KVM: arm64: Allow user to set CCSIDR_EL1
  KVM: arm64: Mask FEAT_CCIDX
  KVM: arm64: Normalize cache configuration

 arch/arm64/include/asm/cache.h             |   9 +
 arch/arm64/include/asm/kvm_arm.h           |   3 +-
 arch/arm64/include/asm/kvm_emulate.h       |   4 -
 arch/arm64/include/asm/kvm_host.h          |   6 +-
 arch/arm64/include/asm/sysreg.h            |   1 -
 arch/arm64/kernel/cacheinfo.c              |   5 -
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h |   2 -
 arch/arm64/kvm/reset.c                     |   1 +
 arch/arm64/kvm/sys_regs.c                  | 246 +++++++++++++--------
 arch/arm64/tools/sysreg                    |  16 ++
 10 files changed, 182 insertions(+), 111 deletions(-)

-- 
2.38.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
