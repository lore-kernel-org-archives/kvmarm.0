Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CAD17E
	for <kvmarm@lists.linux.dev>; Wed, 21 Dec 2022 20:40:25 +0000 (UTC)
Received: by mail-pg1-f172.google.com with SMTP id r18so11130130pgr.12
        for <kvmarm@lists.linux.dev>; Wed, 21 Dec 2022 12:40:25 -0800 (PST)
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
        b=Pt4EpwyDLzJfW9IhXG+J53pBwURZuqHo7D3UtGc3c18dM5Gdhzbx3GdpsUtdte5ilr
         7WpBJtAGKLqDuNkPpUPYsp2YKm/SsMHF/BT9SexFLidHFFVT7aLHSto4vdNvqOq3oGit
         PQohnO4WFWfQDCw7yY4UuWjUQD59jdc2JtTACLUYntoMaLfDUqtD90DtttZ2E7XmV7W1
         gN58XTwEJdj5WX6isGpgt9nqE8WHBoWROvFDY/0ZuMvHzhbG4wFhK8roa6woQjNjIOyj
         Qj2HbzIhPwgyQYpJCw1bDej2rC9c4flkgIVNxCy4oOrZt7EawMsP0II7IinvgyWMrvP1
         qIXQ==
X-Gm-Message-State: AFqh2kqP3xZ+Zn0dcXaDiALXj9BcpgrZP6YKCnZV/+AAIpLXbvsrUJGJ
	vw4gOK5myveAY36QalyfVCFkFw==
X-Google-Smtp-Source: AMrXdXs2wb7SfTWVOx0D5KHi10IfGT9eumUAALKjwFYtEgDmphXRkUTVayIt5zwFZw6zsdsFbsyt9g==
X-Received: by 2002:a05:6a00:1d9d:b0:566:900d:5af2 with SMTP id z29-20020a056a001d9d00b00566900d5af2mr3772325pfw.34.1671655224959;
        Wed, 21 Dec 2022 12:40:24 -0800 (PST)
Received: from fedora.flets-east.jp ([2400:4050:c360:8200:8ae8:3c4:c0da:7419])
        by smtp.gmail.com with ESMTPSA id r4-20020aa79884000000b005763c22ea07sm11017784pfl.74.2022.12.21.12.40.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Dec 2022 12:40:24 -0800 (PST)
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
Subject: [PATCH v4 0/7] KVM: arm64: Normalize cache configuration
Date: Thu, 22 Dec 2022 05:40:09 +0900
Message-ID: <20221221204016.658874-1-akihiko.odaki@daynix.com>
X-Mailer: git-send-email 2.38.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Message-ID: <20221221204009.9KiLhI2rTm7eqfKDNklIX7gCioc4QGBOrZw2NC_Mi2k@z>

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

