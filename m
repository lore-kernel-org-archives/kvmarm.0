Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 737FEC4332F
	for <kvmarm@archiver.kernel.org>; Wed, 21 Dec 2022 20:40:30 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C67474B858;
	Wed, 21 Dec 2022 15:40:29 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered)
	header.i=@daynix-com.20210112.gappssmtp.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wCVbU+Oir8Ny; Wed, 21 Dec 2022 15:40:28 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8D4824B91F;
	Wed, 21 Dec 2022 15:40:28 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 75CA64B8FD
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Dec 2022 15:40:27 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MeAbK6YAIxAw for <kvmarm@lists.cs.columbia.edu>;
 Wed, 21 Dec 2022 15:40:26 -0500 (EST)
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com
 [209.85.210.181])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 159E94B858
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Dec 2022 15:40:26 -0500 (EST)
Received: by mail-pf1-f181.google.com with SMTP id c13so11510884pfp.5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Dec 2022 12:40:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=daynix-com.20210112.gappssmtp.com; s=20210112;
 h=content-transfer-encoding:mime-version:message-id:date:subject:cc
 :to:from:from:to:cc:subject:date:message-id:reply-to;
 bh=46KJ5714UULj+WdfQJdjJQGrRLK9Woox/C1y7Qhoy2g=;
 b=b7pzq/wrJe+N+sYe0BI4+oHft0dyRVTtGA/7MXQ9g7N85VS0xZRYMon3Sb3oXzkJm9
 7dMZnXr5DNUuug64ZrjUUWKQwsrX9ErROhWl/859Rw2hS5lCOrid3gjRl+tIHv70KOk7
 qMijkbXr9o2A4KspnQapBxQCJvcXHDil02e0tZjkHILGyQaG5IhLCMXq8d9/k7gNlbWO
 sDXeBldQxtbCbhspG3r9DnJvC4hEULpPr8QBJT2tSX/xdN6wGGewBE0V9eBG4faitRhk
 r/ivw40L42LGGY8d8Dw0z8eX+uVhBG5K+SsbxCt4tyO6kv0AL0xYCH5zWQmnXCaYLv7m
 mUGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:message-id:date:subject:cc
 :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=46KJ5714UULj+WdfQJdjJQGrRLK9Woox/C1y7Qhoy2g=;
 b=qcaIviIG7aGQOtJw7NQHM11Krh5yNKTlBZUXlOHVLo/o9TPMOrjcQiA6MS9jD113CW
 exE+Ta4cnW2EUUigadxAyJGqABV+x5dZgdgUcidZdWJtgDpMagS+lBfcUZWrvIH4/1oD
 KDek2Lu6IkmdVRuJ2URoi+QT5zgUc0aCiQN3JIZOFQ7OFbYdgJv3PEGhXc6ZvSVdrk6z
 HbkrGxKeL/BYIbHLMA4cHgVRWe3J8w+1FHAQvFqKQ8iQgXCvZnuLkdEzxErsKSH0c3Vq
 lss9JXJWkRAPBPkoakeLuw1LLK+NURZahg4axaXvmB4GCIyON8Yg56Bu/6NcVurtvibK
 e0tw==
X-Gm-Message-State: AFqh2kpwX4023sKeMO4eDIIIDM8jlT6mP1zf0w1sWda2UyfGC3/GKSGp
 sDRHvaKkn5y2tw75f07Ra3h4QQ==
X-Google-Smtp-Source: AMrXdXs2wb7SfTWVOx0D5KHi10IfGT9eumUAALKjwFYtEgDmphXRkUTVayIt5zwFZw6zsdsFbsyt9g==
X-Received: by 2002:a05:6a00:1d9d:b0:566:900d:5af2 with SMTP id
 z29-20020a056a001d9d00b00566900d5af2mr3772325pfw.34.1671655224959; 
 Wed, 21 Dec 2022 12:40:24 -0800 (PST)
Received: from fedora.flets-east.jp ([2400:4050:c360:8200:8ae8:3c4:c0da:7419])
 by smtp.gmail.com with ESMTPSA id
 r4-20020aa79884000000b005763c22ea07sm11017784pfl.74.2022.12.21.12.40.20
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 21 Dec 2022 12:40:24 -0800 (PST)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
To: 
Subject: [PATCH v4 0/7] KVM: arm64: Normalize cache configuration
Date: Thu, 22 Dec 2022 05:40:09 +0900
Message-Id: <20221221204016.658874-1-akihiko.odaki@daynix.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Cc: Alyssa Rosenzweig <alyssa@rosenzweig.io>, Hector Martin <marcan@marcan.st>,
 Akihiko Odaki <akihiko.odaki@daynix.com>,
 Mathieu Poirier <mathieu.poirier@linaro.org>, Marc Zyngier <maz@kernel.org>,
 Sven Peter <sven@svenpeter.dev>, linux-kernel@vger.kernel.org,
 Will Deacon <will@kernel.org>, Mark Brown <broonie@kernel.org>,
 asahi@lists.linux.dev, Catalin Marinas <catalin.marinas@arm.com>,
 kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

V3 -> V4:
- Implemented UNKNOWN system register definition for CCSIDR_EL1
- Added a comment about the relation between CCSIDR_EL1 and FEAT_CCIDX
- Squashed "Normalize cache configuration" and "Allow user to set
  CCSIDR_EL1"
  The intermediate state between them did not make much sense.
- Introduced FIELD_GET to extract CCSIDR_EL1_LineSize.

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

Akihiko Odaki (6):
  arm64/sysreg: Convert CCSIDR_EL1 to automatic generation
  arm64/sysreg: Add CCSIDR2_EL1
  arm64/cache: Move CLIDR macro definitions
  KVM: arm64: Always set HCR_TID2
  KVM: arm64: Mask FEAT_CCIDX
  KVM: arm64: Normalize cache configuration

Marc Zyngier (1):
  arm64: Allow the definition of UNKNOWN system register fields

 arch/arm64/include/asm/cache.h             |   9 +
 arch/arm64/include/asm/kvm_arm.h           |   3 +-
 arch/arm64/include/asm/kvm_emulate.h       |   4 -
 arch/arm64/include/asm/kvm_host.h          |   6 +-
 arch/arm64/include/asm/sysreg.h            |   1 -
 arch/arm64/kernel/cacheinfo.c              |   5 -
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h |   2 -
 arch/arm64/kvm/reset.c                     |   1 +
 arch/arm64/kvm/sys_regs.c                  | 240 ++++++++++++---------
 arch/arm64/tools/gen-sysreg.awk            |  20 +-
 arch/arm64/tools/sysreg                    |  17 ++
 11 files changed, 196 insertions(+), 112 deletions(-)

-- 
2.38.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
