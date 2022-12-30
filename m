Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95E791FD4
	for <kvmarm@lists.linux.dev>; Fri, 30 Dec 2022 09:55:00 +0000 (UTC)
Received: by mail-pl1-f173.google.com with SMTP id d15so21373102pls.6
        for <kvmarm@lists.linux.dev>; Fri, 30 Dec 2022 01:55:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=2HDTeomnMfOdczuT9/F20bMQlAjaFMXCpRqH1kdgIVY=;
        b=P9Ljo6kGW+xXABlWTHQolBfJ92OlshrKeGbeNt/GrqH7QUYhjfdCECOnQT6TSUHFt0
         BVmVAq9orDdtalAj8cJy59Toe8NUXr9mGDh5YSq6U1hQ4izys8arYQcQqgrYPJ+4oGUv
         tfh8nq+ILIaVR6vyApuEdCU+iykOlI1TNZoH4EmL3i6GAEoB/f93QGDdJYs7qpx+xeO+
         MCRrEDYCS5hmzgdV4mkghCCVsttFUg698w4d2Tf3VrgLBGjy+lqA+OzLmYca/7Ukj0tU
         1SInCBY3SYEfYv27cTfv2QjJSvZOLF+bC/YDogY+/KIVKqRZfkRIz9G1a6largSAZw1Q
         rHcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2HDTeomnMfOdczuT9/F20bMQlAjaFMXCpRqH1kdgIVY=;
        b=nlfmnPJkEemFUGtD4H3an+TT8O0FBjngYMiJ01pXMXmR1psqZcRhae9vUTBV76OcPq
         FPeNoWbWOHDJ+PfrUAg7K22Ywn+aGym1vOa7tmoy+p3ZJX4l4vebKEhTCjV0//B02a9a
         5AEk9eTNQTmpWj0U2hl6hBc90yinudg22doK7o9K3zmbTlxIHIfd6/wmk2wxTWsf6dWK
         kvMZEjHaMtwzZJwnr30aD4/IO4DSBxKWHE8dq5+Q6xiya1vX+hhWEsDAG3AwIaMwrbn5
         W7By8to3V9V0ZMqv4SyYeO1rWQo5vcPgDfXfR6ZWdD7XlgtLcwFsiVPOJz71VetxJtoJ
         6kYg==
X-Gm-Message-State: AFqh2krtSLM+U43Et4Y1QBYLygLbcQvoINQ+MtH3eCgk89nai53o2RaQ
	/Eg/brGhq9ovGLYbQBBYS2pjuQ==
X-Google-Smtp-Source: AMrXdXt/fAe2lXnpbEVPcBDmkZY6Wl4VVcSk141fejrUaMn53mFyxFW3jXXtZ/DXOfhybJVp3n0G3w==
X-Received: by 2002:a17:903:2312:b0:192:8c7f:2654 with SMTP id d18-20020a170903231200b001928c7f2654mr16330645plh.0.1672394099989;
        Fri, 30 Dec 2022 01:54:59 -0800 (PST)
Received: from fedora.flets-east.jp ([2400:4050:c360:8200:8ae8:3c4:c0da:7419])
        by smtp.gmail.com with ESMTPSA id b7-20020a170902650700b00189c536c72asm14487719plk.148.2022.12.30.01.54.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Dec 2022 01:54:59 -0800 (PST)
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
Subject: [PATCH v5 0/7] KVM: arm64: Normalize cache configuration
Date: Fri, 30 Dec 2022 18:54:45 +0900
Message-ID: <20221230095452.181764-1-akihiko.odaki@daynix.com>
X-Mailer: git-send-email 2.38.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Message-ID: <20221230095445.j2GoT5o6WaxFSPJvtpFx0l3UPkvKf3iWE5WlLh-7pwM@z>

Before this change, the cache configuration of the physical CPU was
exposed to vcpus. This is problematic because the cache configuration a
vcpu sees varies when it migrates between vcpus with different cache
configurations.

Fabricate cache configuration from the sanitized value, which holds the
CTR_EL0 value the userspace sees regardless of which physical CPU it
resides on.

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
 arch/arm64/kvm/sys_regs.c                  | 256 +++++++++++++--------
 arch/arm64/tools/gen-sysreg.awk            |  20 +-
 arch/arm64/tools/sysreg                    |  17 ++
 11 files changed, 212 insertions(+), 112 deletions(-)

-- 
2.38.1

