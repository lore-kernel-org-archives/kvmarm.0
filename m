Received: from mail-oa1-f48.google.com (mail-oa1-f48.google.com [209.85.160.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EE421C3F
	for <kvmarm@lists.linux.dev>; Fri,  4 Nov 2022 15:55:18 +0000 (UTC)
Received: by mail-oa1-f48.google.com with SMTP id 586e51a60fabf-13bef14ea06so5986634fac.3
        for <kvmarm@lists.linux.dev>; Fri, 04 Nov 2022 08:55:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:message-id:date:from:content-transfer-encoding:mime-version
         :subject:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EsRuXK+4fmKPfA/tRVgMzv8PA5fByXtuRn3wY8WPk0o=;
        b=QhLbUg0kkmanGxI/mMq/aLCeYkB9OiJOFetAhZbIEcUPjZjacxTG6gK7RbfdzV0V5E
         ruic0QajsSkLV9YPOhyqnJmBOIMjgpZZ+UuJy3EGKfrHmqNITAIUexoGtAUVXhwDlcrt
         yefbCAlBYyARcf3P7VV1ECT27c/PCFkeOPkqm+WAolAFE/NUQyDkm52lwrGnGdopBmCX
         Zhx5LnB+OhZ6fKO6s0me1f4+kf9c0KSU+SFQr2nsThfAYh/mFo/ozLB4PTXgkKPVvUbj
         Jfvd/rONRogZHNHoEndz/KhLMVW8I6bfyJaRw26ts/4C+J+IpbFlwq3XnK9El7DRUnv9
         cbsQ==
X-Gm-Message-State: ACrzQf0CKb70h5xXyMcSzOwIjyONbPlGSHPb+RdOF3DT+MPrFnqvNdCl
	5zlUkhBnIfccXGLV81AZNA==
X-Google-Smtp-Source: AMsMyM7QNaapYnVKiSJDZR5Z9xD6NPozpgwYM9qlpFMIkrrlOKfLSW+YN50skL9R7U4bPspCP1TYOg==
X-Received: by 2002:a05:6870:ec90:b0:13b:b20a:ae81 with SMTP id eo16-20020a056870ec9000b0013bb20aae81mr21230053oab.77.1667577317450;
        Fri, 04 Nov 2022 08:55:17 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id 9-20020aca0d09000000b00359a9663053sm1570850oin.4.2022.11.04.08.55.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Nov 2022 08:55:16 -0700 (PDT)
Received: (nullmailer pid 1880407 invoked by uid 1000);
	Fri, 04 Nov 2022 15:55:18 -0000
Subject: [PATCH v3 0/8] perf: Arm SPEv1.2 support
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-b4-tracking: H4sIANQ1ZWMC/33NQQ6CMBAF0KuQrh1TpgLFlfcwLko7QCO2ptUmhnB3J+5c6Gryf/L+rCJT8pTFsV
 pFouKzj4GD2lXCziZMBN5xFigRpcYGTLpBvhMUDR2M5EZ5oLodUQkmg8kEQzLBzozCc1m4nH1+xPT6
 vCg1n/OPtVKDBNs1g3Y9Utvj6Uop0LKPaRIXXir4TyNrUp1CdK02Vn7pbdveeUPe4ewAAAA=
From: Rob Herring <robh@kernel.org>
Date: Fri, 04 Nov 2022 10:55:00 -0500
Message-ID: <20220825-arm-spe-v8-7-v3-0-87682f78caac@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>, Will Deacon <will@kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Mark Rutland <mark.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, Ingo Molnar <mingo@redhat.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>
Cc: kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org, James Clark <james.clark@arm.com>, Mark Brown <broonie@kernel.org>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
X-Mailer: b4 0.11.0-dev
Message-ID: <20221104155500.KBQWhx5ci9HPUD5S21NokSAwD7RbgjuIeWveUco7beM@z>

This series adds support for Arm SPEv1.2 which is part of the
Armv8.7/Armv9.2 architecture. There's 2 new features that affect the 
kernel: a new event filter bit, branch 'not taken', and an inverted 
event filter register. 

Since this support adds new registers and fields, first the SPE register 
defines are converted to automatic generation.

Note that the 'config3' addition in sysfs format files causes SPE to 
break. A stable fix e552b7be12ed ("perf: Skip and warn on unknown format 
'configN' attrs") landed in v6.1-rc1.

The perf tool side changes are available here[1].

Tested on FVP.

[1] https://lore.kernel.org/all/20220914-arm-perf-tool-spe1-2-v2-v4-0-83c098e6212e@kernel.org/

Signed-off-by: Rob Herring <robh@kernel.org>
---
Changes in v3:
- Add some more missing SPE register fields and use Enums for some 
  fields
- Use the new PMSIDR_EL1 register Enum defines in the SPE driver
- Link to v2: https://lore.kernel.org/r/20220825-arm-spe-v8-7-v2-0-e37322d68ac0@kernel.org

Changes in v2:
- Convert the SPE register defines to automatic generation
- Fixed access to SYS_PMSNEVFR_EL1 when not present
- Rebase on v6.1-rc1
- Link to v1: https://lore.kernel.org/r/20220825-arm-spe-v8-7-v1-0-c75b8d92e692@kernel.org

---
Rob Herring (8):
      perf: arm_spe: Use feature numbering for PMSEVFR_EL1 defines
      arm64: Drop SYS_ from SPE register defines
      arm64/sysreg: Convert SPE registers to automatic generation
      perf: arm_spe: Drop BIT() and use FIELD_GET/PREP accessors
      perf: arm_spe: Use new PMSIDR_EL1 register enums
      perf: arm_spe: Support new SPEv1.2/v8.7 'not taken' event
      perf: Add perf_event_attr::config3
      perf: arm_spe: Add support for SPEv1.2 inverted event filtering

 arch/arm64/include/asm/el2_setup.h |   6 +-
 arch/arm64/include/asm/sysreg.h    |  99 +++--------------------
 arch/arm64/kvm/debug.c             |   2 +-
 arch/arm64/kvm/hyp/nvhe/debug-sr.c |   2 +-
 arch/arm64/tools/sysreg            | 139 +++++++++++++++++++++++++++++++++
 drivers/perf/arm_spe_pmu.c         | 156 ++++++++++++++++++++++++-------------
 include/uapi/linux/perf_event.h    |   3 +
 7 files changed, 257 insertions(+), 150 deletions(-)
---
base-commit: 9abf2313adc1ca1b6180c508c25f22f9395cc780
change-id: 20220825-arm-spe-v8-7-fedf04e16f23

Best regards,
-- 
Rob Herring <robh@kernel.org>
