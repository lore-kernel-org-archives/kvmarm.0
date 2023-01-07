Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F9B91842
	for <kvmarm@lists.linux.dev>; Sat,  7 Jan 2023 09:46:39 +0000 (UTC)
Received: by mail-pj1-f46.google.com with SMTP id n12so3892392pjp.1
        for <kvmarm@lists.linux.dev>; Sat, 07 Jan 2023 01:46:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=nDiSSUCXyfTxgSY9w0A6cnWBkOKJja5kzfazSGhDk+s=;
        b=Ip9Fl0k1pj40UoY+CGobxiY7Cb+1N2wjCHxGSMm+/IGkJbHoHvYlHh9isCjXM6EYbS
         uYU63Wve+S4jpifnghRtL7kd3WflrBwh3ewvMkoPRgWyadCiC/fK8XtXA9ABONYlraHH
         H5+qiphc39Pcnh5CPLvVweuQB6KVkf62uqYq4VP+3A9IzulQJBBeRToU4TMkrupx6yG1
         gY3IhrlZ8V1zCR8JXMja5X1cV0jUZ2U8FjERPU1meMnTd8SBruQNkYFYuxV3KO23FQQQ
         ElMN75eyjKeoaEgs84MOvHjxLXbZGa1jMV2iWjz0TDxOIu7m7T0XnEleWV6dJxbEIhqc
         W1eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nDiSSUCXyfTxgSY9w0A6cnWBkOKJja5kzfazSGhDk+s=;
        b=ShgfLorlQUa3v53NujsgbvEOGDwDLPCUXaCTYR5QF+BuGYNw9Pqxy6g3w5tIfFyhoG
         z6VykoEpHrDfY85Q+uddTKk2FpIb+vKilAyRUxlIpZDEgRoxPmo9+iz1OZZZkoJesqYR
         QvR84Lv98XKOQDJkJ8EvYrG0lobF/f2QK+G/j6LfRZEWsntFI2G97JsU5a/9n6T2TI65
         NFqYlKvJW1F69EKmiSRHiSguw8q1SYWSTcBpI18BG63NOn+Qt1HeG7wFvgqG43k0Deje
         lFZRZWtI26hYX23Tgq/zUdQ+Fnoff8rcj149JVZTRtt0nsd0RRNo4rveYlfirNMqS7Kl
         CVhQ==
X-Gm-Message-State: AFqh2kpUYg+w5CrgvvDC53AGGVpjHkDw/luwUlbZItVFYZ+9JK1LDlib
	nohMFfpsihGqPfUpzhvTrhCCnQ==
X-Google-Smtp-Source: AMrXdXvo+rexBnZY1QlfA2EAy1F/HDKl7+wrHDMpE1Bhi7y2UBror3BjgD1EIrqM70vva4yt50Esag==
X-Received: by 2002:a17:902:f78d:b0:192:ae36:f760 with SMTP id q13-20020a170902f78d00b00192ae36f760mr32857238pln.47.1673084799038;
        Sat, 07 Jan 2023 01:46:39 -0800 (PST)
Received: from fedora.flets-east.jp ([2400:4050:a840:1e00:d54:e521:8bac:7bed])
        by smtp.gmail.com with ESMTPSA id n9-20020a170902d2c900b00183c6784704sm2263449plc.291.2023.01.07.01.46.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Jan 2023 01:46:38 -0800 (PST)
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
Subject: [PATCH v6 0/7] KVM: arm64: Normalize cache configuration
Date: Sat,  7 Jan 2023 18:46:22 +0900
Message-Id: <20230107094629.181236-1-akihiko.odaki@daynix.com>
X-Mailer: git-send-email 2.38.1
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
 arch/arm64/kvm/sys_regs.c                  | 263 +++++++++++++--------
 arch/arm64/tools/gen-sysreg.awk            |  20 +-
 arch/arm64/tools/sysreg                    |  17 ++
 11 files changed, 219 insertions(+), 112 deletions(-)

-- 
2.38.1

