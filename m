Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C6FC1117
	for <kvmarm@lists.linux.dev>; Thu,  1 Dec 2022 10:49:47 +0000 (UTC)
Received: by mail-pg1-f180.google.com with SMTP id 62so1308328pgb.13
        for <kvmarm@lists.linux.dev>; Thu, 01 Dec 2022 02:49:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=foBGF6JlnonEt7u87TDzA6BdrpBeBHRT3WfaCgQwD4w=;
        b=pGFrHYoSXyP+05btXeBT3GDPA3BBMxmoFjzQZdLLbgcGtRtd7Y/ed5g89sJ1Ko2BPl
         w/8U2Gtv0tPTKbIoyyXc0HC34rPREN8tpEVZ/Qtoy8EeMjUkcOed+O4vgW6MMT3hG2Tb
         tO9d9Tl7iu01SE4eUZGMehhVYLEiufve+6A3CwtlCYfgpP/KxK/0YZh41SA3Qd/K0L0p
         nljgnw7gJjidBiRqpmEM674grrj/teo9cmJEC8loX80WVe6FUFnf0OGBf/zgJL2lXACi
         RkyW+dL8owebIelG/XFn8Kfi64VfgOBe21NgfHGMBM72tOVxpHAQkbIbXMQ3GtPimpw/
         ZP5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=foBGF6JlnonEt7u87TDzA6BdrpBeBHRT3WfaCgQwD4w=;
        b=dl6f627ZdcXgTQamZAbgp9OpainbqO8SYljt4bzijna0LrlKCuwDNTdnhyw1x92Mzq
         NZRPgeLVfK04bfo9GE4ejyRDsqAX6uxFwCK+xbGX/PPVdTac+n0vI/Y7bBDurbuGgqBI
         SWaOhxFrNLLo8BoCKaeHszRlJQIvGRaBcBiEE27VijzFdZpVxD5SLEHr/QHgk9LbYs3C
         7aH1NgPiwcun90e5ETxNJuP9qM8t3sEc8dzgxm+vJXAy8h/zv39MSWX5JwBnmJaZTI4Y
         9VhHHcqdWo19f0gGIuGssImMUbS07KKQyfXgbr4VRy/XvyIplV7ehBMtJzcyQd0Kinas
         4dog==
X-Gm-Message-State: ANoB5pnCkMBbXUPdao5cnOb2FH5/7Dr5Ehei/7kyxNcS7ZkQHJMLKLFQ
	z9N5kfgACN4kqzefN4kw0+9xDw==
X-Google-Smtp-Source: AA0mqf6Cyu7laoCbi5JoSZv0gkqjvpvrXeXiVPp6Vj2NLBpsceZWkQJBNxO9yJFLr0IOOo439dEXsQ==
X-Received: by 2002:a63:310:0:b0:478:7e02:fa11 with SMTP id 16-20020a630310000000b004787e02fa11mr25577pgd.222.1669891786574;
        Thu, 01 Dec 2022 02:49:46 -0800 (PST)
Received: from fedora.flets-east.jp ([2400:4050:c360:8200:8ae8:3c4:c0da:7419])
        by smtp.gmail.com with ESMTPSA id 4-20020a630804000000b004785a63b44bsm2320580pgi.43.2022.12.01.02.49.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 02:49:46 -0800 (PST)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
To: 
Cc: linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev,
	kvmarm@lists.cs.columbia.edu,
	linux-arm-kernel@lists.infradead.org,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	James Morse <james.morse@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	asahi@lists.linux.dev,
	Alyssa Rosenzweig <alyssa@rosenzweig.io>,
	Sven Peter <sven@svenpeter.dev>,
	Hector Martin <marcan@marcan.st>,
	Akihiko Odaki <akihiko.odaki@daynix.com>
Subject: [PATCH 0/3] KVM: arm64: Handle CCSIDR associativity mismatches
Date: Thu,  1 Dec 2022 19:49:11 +0900
Message-ID: <20221201104914.28944-1-akihiko.odaki@daynix.com>
X-Mailer: git-send-email 2.38.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Message-ID: <20221201104911.YSM_cqWbanHQgzAdhv7BekCb0UW2WMfZiTAjlFog4pk@z>

M2 MacBook Air has mismatched CCSIDR associativity bits, which makes the
bits a KVM vCPU sees inconsistent when migrating.

It also makes QEMU fail restoring the vCPU registers because QEMU saves
and restores all of the registers including CCSIDRs, and if the vCPU
migrated among physical CPUs between saving and restoring, it tries to
restore CCSIDR values that mismatch with the current physical CPU, which
causes EFAULT.

Trap CCSIDRs if there are CCSIDR value msimatches, and override the
associativity bits when handling the trap.

Akihiko Odaki (3):
  KVM: arm64: Make CCSIDRs consistent
  arm64: errata: Check for mismatched cache associativity
  KVM: arm64: Handle CCSIDR associativity mismatches

 arch/arm64/include/asm/cache.h       |  3 ++
 arch/arm64/include/asm/cpu.h         |  1 +
 arch/arm64/include/asm/cpufeature.h  |  8 +++++
 arch/arm64/include/asm/kvm_emulate.h | 10 ++++--
 arch/arm64/include/asm/sysreg.h      |  7 ++++
 arch/arm64/kernel/cacheinfo.c        |  4 +--
 arch/arm64/kernel/cpu_errata.c       | 52 ++++++++++++++++++++++++++++
 arch/arm64/kernel/cpufeature.c       |  4 +++
 arch/arm64/kernel/cpuinfo.c          | 30 ++++++++++++++++
 arch/arm64/kvm/sys_regs.c            | 50 ++++++++++++++------------
 arch/arm64/tools/cpucaps             |  1 +
 11 files changed, 144 insertions(+), 26 deletions(-)

-- 
2.38.1

