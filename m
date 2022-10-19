Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53F96C4332F
	for <kvmarm@archiver.kernel.org>; Wed, 19 Oct 2022 19:11:30 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AA2AA4B8D2;
	Wed, 19 Oct 2022 15:11:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id o4rbnOo62nqg; Wed, 19 Oct 2022 15:11:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B1CC24B8F7;
	Wed, 19 Oct 2022 15:11:27 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A7BDD4B8BF
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Oct 2022 15:11:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GQunRl7sBzxu for <kvmarm@lists.cs.columbia.edu>;
 Wed, 19 Oct 2022 15:11:25 -0400 (EDT)
Received: from mail-oa1-f45.google.com (mail-oa1-f45.google.com
 [209.85.160.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6D1894B8A0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Oct 2022 15:11:25 -0400 (EDT)
Received: by mail-oa1-f45.google.com with SMTP id
 586e51a60fabf-1326637be6eso21814199fac.13
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Oct 2022 12:11:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:message-id:date:from:content-transfer-encoding:mime-version
 :subject:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=8HWbMi0BhU5RSsaj3t9gz8sb2tRhVv6F39wL/nVJWCs=;
 b=MSb+gEdjDLk4FMepENFsFo/lLlVSvKUir/Id5gHqDZqd8rleTAOEMTFsZ6Hx7IE03A
 ChR37xQnh22z6FmPbOxbARhg+TjIbdgUH4lT9qf3mSkLmzo1XHNGxg15lnWJflDykb+8
 pVxtWAEUdqs8oP12RUIt+XeLvgGgSYvQ8vWY0AbJWzFlA12AD0HWnQ2KflAluhStH4p3
 tP/WeoeVI5CjBj2BDen95LdEsacJl8CfXEf/dPvjyf1iuPSiodmxmrUgDx5SEhDHQsXo
 hLfM3fAvpk/pua/C+/dWSkyGNfPMsxVp8/RpB6uzJI5kJGKlaObq7aYUS3/r/SycidMM
 83ww==
X-Gm-Message-State: ACrzQf2+0doX2UeQuFsdpgPdkyzbD08GhodQhMdQeURxJFc5g/+ju4uk
 SGyLtfQX7OtXUcjIHbYnqw==
X-Google-Smtp-Source: AMsMyM6L+gye/LwLSUbTwvcqYD3FLUzUB3vYmZL9Im4PgtcEfWLLmd/KydKz+OoIOnaMZdgD5mTlwg==
X-Received: by 2002:a05:6870:9688:b0:132:9c55:72 with SMTP id
 o8-20020a056870968800b001329c550072mr6180621oaq.104.1666206684576; 
 Wed, 19 Oct 2022 12:11:24 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net.
 [66.90.144.107]) by smtp.gmail.com with ESMTPSA id
 q10-20020a056830018a00b006618f1fbb84sm7348116ota.80.2022.10.19.12.11.23
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 19 Oct 2022 12:11:24 -0700 (PDT)
Received: (nullmailer pid 3420895 invoked by uid 1000);
 Wed, 19 Oct 2022 19:11:25 -0000
Subject: [PATCH v2 0/7] perf: Arm SPEv1.2 support
MIME-Version: 1.0
X-b4-tracking: H4sIANtLUGMC/3WNzQrCMBCEX6Xs2ZV0tb8n30M8pO2mCdZENhqQknc3ePc0fAPfzA6RxXGEsdpBOL
 nogi9Ahwpmq/3K6JbCQIpI9dSglgfGJ2PqsUPDi1FnrltDJyjKpCPjJNrPtkj+vW2ltC6+gnx+F6ku
 cf2zlmpUOHfN1C8DcTvQ5c7ieTsGWeGWc/4CRvTey64AAAA=
From: Rob Herring <robh@kernel.org>
Date: Wed, 19 Oct 2022 14:11:23 -0500
Message-Id: <20220825-arm-spe-v8-7-v2-0-e37322d68ac0@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>, James Morse <james.morse@arm.com>,
 Ingo Molnar <mingo@redhat.com>, Mark Rutland <mark.rutland@arm.com>,
 Marc Zyngier <maz@kernel.org>, Suzuki K Poulose <suzuki.poulose@arm.com>,
 Will Deacon <will@kernel.org>, Alexandru Elisei <alexandru.elisei@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Oliver Upton <oliver.upton@linux.dev>, Jiri Olsa <jolsa@kernel.org>
X-Mailer: b4 0.11.0-dev
Cc: linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
 Mark Brown <broonie@kernel.org>, kvmarm@lists.linux.dev,
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
Changes in v2:
- Convert the SPE register defines to automatic generation
- Fixed access to SYS_PMSNEVFR_EL1 when not present
- Rebase on v6.1-rc1
- Link to v1: https://lore.kernel.org/r/20220825-arm-spe-v8-7-v1-0-c75b8d92e692@kernel.org

---
Rob Herring (7):
      perf: arm_spe: Use feature numbering for PMSEVFR_EL1 defines
      arm64: Drop SYS_ from SPE register defines
      arm64/sysreg: Convert SPE registers to automatic generation
      perf: arm_spe: Drop BIT() and use FIELD_GET/PREP accessors
      perf: arm_spe: Support new SPEv1.2/v8.7 'not taken' event
      perf: Add perf_event_attr::config3
      perf: arm_spe: Add support for SPEv1.2 inverted event filtering

 arch/arm64/include/asm/el2_setup.h |   6 +-
 arch/arm64/include/asm/sysreg.h    |  99 +++------------------------
 arch/arm64/kvm/debug.c             |   2 +-
 arch/arm64/kvm/hyp/nvhe/debug-sr.c |   2 +-
 arch/arm64/tools/sysreg            | 116 +++++++++++++++++++++++++++++++
 drivers/perf/arm_spe_pmu.c         | 136 ++++++++++++++++++++++++-------------
 include/uapi/linux/perf_event.h    |   3 +
 7 files changed, 224 insertions(+), 140 deletions(-)
---
base-commit: 9abf2313adc1ca1b6180c508c25f22f9395cc780
change-id: 20220825-arm-spe-v8-7-fedf04e16f23

Best regards,
-- 
Rob Herring <robh@kernel.org>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
