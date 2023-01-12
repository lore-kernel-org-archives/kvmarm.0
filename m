Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3150C386
	for <kvmarm@lists.linux.dev>; Thu, 12 Jan 2023 02:39:07 +0000 (UTC)
Received: by mail-pl1-f174.google.com with SMTP id b17so11304405pld.7
        for <kvmarm@lists.linux.dev>; Wed, 11 Jan 2023 18:39:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=k83D4cHet6xxSauwnXBAG2POGQDSG6eAKHoaOWKO0ZM=;
        b=HBHPRSkefxSL8v/u0WI3RXGK8TGWvBs9nWl0eAN6b2r3P/L5A0AHOW8k+WNlNXljiA
         xcBm7wjPg/EbuBJAaGK6fXmY1J99aLHf2ygMD4Ckkm5bZqFjjM6jm6yr1tg9BHpFyBU0
         r3SZWa5xMt7w6fSPXq70t5UyNqDOUpXK5fucMnX+sRjFj6OGzvUeZKRJtYA4imZdpC15
         RiJw9c0KYYLbr6ilHj99I/BGqslESPEHZM66/T1Uxls26qk4KKAZzb4XrwUYzsiXMGct
         N7ocX5rmVHAANjUVEMpylwE/OwUabgBkdVPmqiw4HmJxTNN7/PpzCgckFbi7PsfJA76L
         wbMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=k83D4cHet6xxSauwnXBAG2POGQDSG6eAKHoaOWKO0ZM=;
        b=ITJzkR6DD/BXNZvjrXRakGjT8ya/dUM/a47nu4v98TXreZxmI+2tBjQFT1UlgLex4y
         YYjXZRs2tBT2ExMMpyZif7mTbVX27oneP7MlG6mMFHtCZC0/lpCwYmHO6Rl/zB7oyRCU
         06ZFV0dUnhItUgB0WT2UqtMds4P0kTgnIrSITaa71l82b+dA170i+2Ou3K+Ef+rJOvDe
         0vEiw2xRtvXfk0oO4TGenmjwRHJn2kRZS6VELGlwCHWM2gDueMLI0w67dQI7MgKpuJeg
         YuyaA4MZGwACOMaAvgW3CkjgzmF5gtt65+0QGlqFF/Ij34CmGwECQlkByuyq3HyL8DLh
         b/eQ==
X-Gm-Message-State: AFqh2kp8Z5/RAZHUENWswC5dUBSALvuU3rw3Ah0DoJLeNHgSnI/Bzz/e
	BuRFe9swhoTrtVdtWZ7JX6+pnrpImrSl0Ywq
X-Google-Smtp-Source: AMrXdXuarUuj+dnpfbLqlXdbjMkbC9/UcAPU+8TqzLcL101PU3o/EcvUpOQA1ixTQMd2bjFz7Yttag==
X-Received: by 2002:a17:902:c102:b0:192:8e05:1505 with SMTP id 2-20020a170902c10200b001928e051505mr57871834pli.31.1673491146515;
        Wed, 11 Jan 2023 18:39:06 -0800 (PST)
Received: from fedora.flets-east.jp ([2400:4050:a840:1e00:d54:e521:8bac:7bed])
        by smtp.gmail.com with ESMTPSA id w7-20020a1709027b8700b001944b1285easm2310331pll.198.2023.01.11.18.39.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jan 2023 18:39:05 -0800 (PST)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
To: 
Cc: Mark Brown <broonie@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev,
	kvmarm@lists.cs.columbia.edu,
	linux-arm-kernel@lists.infradead.org,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	James Morse <james.morse@arm.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	asahi@lists.linux.dev,
	Alyssa Rosenzweig <alyssa@rosenzweig.io>,
	Sven Peter <sven@svenpeter.dev>,
	Hector Martin <marcan@marcan.st>,
	Akihiko Odaki <akihiko.odaki@daynix.com>
Subject: [PATCH v7 0/7] KVM: arm64: Normalize cache configuration
Date: Thu, 12 Jan 2023 11:38:45 +0900
Message-Id: <20230112023852.42012-1-akihiko.odaki@daynix.com>
X-Mailer: git-send-email 2.39.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Before this change, the cache configuration of the physical CPU was
exposed to vcpus. This is problematic because the cache configuration a
vcpu sees varies when it migrates between vcpus with different cache
configurations.

Fabricate cache configuration from the sanitized value, which holds the
CTR_EL0 value the userspace sees regardless of which physical CPU it
resides on.

V6 -> V7:
- Make the code to determine cache line more readable.
  Based on Oliver Upton's suggestion.

V5 -> V6:
- Add a comment to get_min_cache_line_size()

V4 -> V5:
- Noted why cache level existence check is unnecessary when fabricating
  CCSIDR_EL1 value.
- Removed FWB check. It is necessary as CLIDR_EL1.{LoUU, LoIUS} on the
  host are {0, 0} if FWB is enabled, and such a CLIDR_EL1 value sets
  the IDC bit of the sanitized CTR_EL0 value, which is already checked.
- Removed UNDEF injection when reading CCSIDR_EL1 with an invalid
  CSSELR_EL1 value.
- Added a check for CLIDR_EL1.{LoUU,LoC,LoUIS} values set from the
  userspace.

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
 arch/arm64/kvm/sys_regs.c                  | 274 +++++++++++++--------
 arch/arm64/tools/gen-sysreg.awk            |  20 +-
 arch/arm64/tools/sysreg                    |  17 ++
 11 files changed, 230 insertions(+), 112 deletions(-)

-- 
2.39.0

