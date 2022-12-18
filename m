Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19377806
	for <kvmarm@lists.linux.dev>; Sun, 18 Dec 2022 05:15:24 +0000 (UTC)
Received: by mail-pj1-f44.google.com with SMTP id k88-20020a17090a4ce100b00219d0b857bcso6090912pjh.1
        for <kvmarm@lists.linux.dev>; Sat, 17 Dec 2022 21:15:24 -0800 (PST)
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
        b=4+nA9SQn+y2XL+sOi0pqQjajYzT3aFWddExp83RNjlXe8TVLYGnk97NKMEklxWtOTK
         hsm1fU2jEdyzl3ONddquS3WvVhqNyqpF9chLD55WPbaFqPKQZN4+dPQzb2xhWgpHiSBV
         149GaZz3jka+rLMULbO7Sio3npUPTlkoj3seMD0i3xQ/wwmknqDTpufSyfWFS8Y4qdLk
         8BrffXmJWhNS8IfFWgatHPmn3wncAWzyg6RB60JYREaARzksm30g7wVlnj0iZf0cEnB+
         ky/UWqSS6g0E4/pjaUiGF66iZRqdBw4v2OLgpGxCYTb8NdxXmT3R31VBVzEnYw8yAiVx
         V3nQ==
X-Gm-Message-State: ANoB5pkLOqX2jII+iBGXgLpYO5ufEQm5zSTNimzuBc118GJOqflhe5W6
	Vc+XUs/SNfI1FPbXFDtH7Zn+PA==
X-Google-Smtp-Source: AA0mqf72YV5edT4kAgOZXEWT3kE8W12UBWocuqS2BFj9Nm3zqofKc8b75dDfMhucuQYOpxQGxpjPjQ==
X-Received: by 2002:a17:90b:4a8c:b0:219:e763:1d21 with SMTP id lp12-20020a17090b4a8c00b00219e7631d21mr39250867pjb.5.1671340524491;
        Sat, 17 Dec 2022 21:15:24 -0800 (PST)
Received: from fedora.flets-east.jp ([2400:4050:c360:8200:8ae8:3c4:c0da:7419])
        by smtp.gmail.com with ESMTPSA id b1-20020a17090a6ac100b002139459e121sm7002417pjm.27.2022.12.17.21.15.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Dec 2022 21:15:23 -0800 (PST)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
To: 
Cc: Marc Zyngier <maz@kernel.org>,
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
Subject: [PATCH v3 0/7] KVM: arm64: Normalize cache configuration
Date: Sun, 18 Dec 2022 14:14:05 +0900
Message-ID: <20221218051412.384657-1-akihiko.odaki@daynix.com>
X-Mailer: git-send-email 2.38.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Message-ID: <20221218051405.6sesSEYsTMxJxYqSArhp4fuz88zvUFVnWe4QtaxwIVE@z>

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

