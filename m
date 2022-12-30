Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34ADBC3DA7C
	for <kvmarm@archiver.kernel.org>; Fri, 30 Dec 2022 09:55:05 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B89994B3E5;
	Fri, 30 Dec 2022 04:55:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered)
	header.i=@daynix-com.20210112.gappssmtp.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vYD8Q84irH9j; Fri, 30 Dec 2022 04:55:03 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9E7794B4D7;
	Fri, 30 Dec 2022 04:55:03 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 584064B3E5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Dec 2022 04:55:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dLcspJVyz8+n for <kvmarm@lists.cs.columbia.edu>;
 Fri, 30 Dec 2022 04:55:01 -0500 (EST)
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com
 [209.85.216.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0BB6A4B286
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Dec 2022 04:55:01 -0500 (EST)
Received: by mail-pj1-f49.google.com with SMTP id
 o8-20020a17090a9f8800b00223de0364beso25336471pjp.4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Dec 2022 01:55:00 -0800 (PST)
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
 b=4kZxJU7mYr85YvpaLWuQ4b9nL2iwSZFYswyyVrK4MaIXjxMBZygDc0nop3JhlDY/ek
 gCczhmb0wOx7JXqrhoffShx2R0ZidxSetAdM9jI5oMEF6s2e/cHvA/MaP5LuhU9D0RfL
 WRp5I7gUalqwPSbMlvfjTmGu1nE8FdfblJ/ISeQH68Jv1tYH+9KSrKX3EOB3XZzXwv0Q
 AE86ISHenImlsRK+eWBxOwOZujaPrh9LlN3uhdMnnEIkqu6U5KvlYVAV4FlSp27Aub33
 eYMXo4I4vorpzTxFwBsjUpFXPFDvcuIim/sQPhCpFLnsJTb7qIyVQ6xNZ0d5wVMLlQIY
 y0/w==
X-Gm-Message-State: AFqh2kqYchBPEHLnv7SBi2dOkDQiwObJV0nsj/xiQw7cL3g9uMxsHv7Q
 NsiAy0mNXWZGHdvAJ+QsRNQ+Vg==
X-Google-Smtp-Source: AMrXdXt/fAe2lXnpbEVPcBDmkZY6Wl4VVcSk141fejrUaMn53mFyxFW3jXXtZ/DXOfhybJVp3n0G3w==
X-Received: by 2002:a17:903:2312:b0:192:8c7f:2654 with SMTP id
 d18-20020a170903231200b001928c7f2654mr16330645plh.0.1672394099989; 
 Fri, 30 Dec 2022 01:54:59 -0800 (PST)
Received: from fedora.flets-east.jp ([2400:4050:c360:8200:8ae8:3c4:c0da:7419])
 by smtp.gmail.com with ESMTPSA id
 b7-20020a170902650700b00189c536c72asm14487719plk.148.2022.12.30.01.54.55
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 30 Dec 2022 01:54:59 -0800 (PST)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
To: 
Subject: [PATCH v5 0/7] KVM: arm64: Normalize cache configuration
Date: Fri, 30 Dec 2022 18:54:45 +0900
Message-Id: <20221230095452.181764-1-akihiko.odaki@daynix.com>
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

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
