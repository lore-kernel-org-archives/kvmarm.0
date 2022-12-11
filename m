Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F33961365
	for <kvmarm@lists.linux.dev>; Sun, 11 Dec 2022 05:17:25 +0000 (UTC)
Received: by mail-pf1-f171.google.com with SMTP id x66so6436603pfx.3
        for <kvmarm@lists.linux.dev>; Sat, 10 Dec 2022 21:17:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=0kPiXJlVEAGiE46bEmtCKOJ4JxdjDvz4UZE+PugYkgI=;
        b=zD/O2nzY7tL6eshwIf3CeY/YAQIm1xVj5/Js/pKlVUvQWsGxQvosSXAL5bONw8IRja
         NA3S79/dHcWpJuvuy9trw6RuKm57YDQCUNFpPvtYLZhGO3nfFMIvpKzeGx8mjTPJk5gq
         hw+7ezvQrKhSUi9CIBPtmx5dqGx8b4Zr7z+xZLP2OUafjrWtcGD8PRS4P8yU7dKvr6Jv
         UbbqVz0qPUqc4J5QhHhE7EjNOtQ744qnzQYQZf3qc8NljImI96wFoAZ++URfZ7JtOOme
         i8w/sViehDGjCh8JEOb2IPC1RIyIsa1SCr8haVzrurKIBxrloDk0D0MMtViqlg2ivnDO
         D2tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0kPiXJlVEAGiE46bEmtCKOJ4JxdjDvz4UZE+PugYkgI=;
        b=n3tNs3TBA3Xwsomqt88qN4OOfce6896wxRSBEHeiKd8/XKJ1g8vbZ78e4tuvIHXyYV
         Ua60VUL9EUlaLajPyJNlRFhv881O2CSfZHTnw5JTx8ivLI9ryREV3bMeKwZInTwtc8l8
         plRm2mS+Yhf4mLHlhiujreilyIUAtzkbi/IbItBH7gIQnnFQLRBJNAM2aR78ZzQFshNS
         Hj4mDQJUoCkzN9jugllvCm4nl8zvmLCEbS3q9PZLF6xpxguXEyT00PuouqqgzmTGNlkq
         bwPIm2c2dlVJMwsZcpw23iCU8fc4ElXc+Xcxbucb0Nhpu4u1ZUfAQbvpYvMuEmVGxHje
         PVww==
X-Gm-Message-State: ANoB5pnbvTxq9SVoQTzb2i7JlyQA/fHDQif+1hIFzXnVsRKA00RNxdoG
	7LzK17nHNT40YsKC6FRygVkilg==
X-Google-Smtp-Source: AA0mqf6ROckMAbfbisK6rGjhVdzEf/yVRLrsZe5jClX/LxHWmHcqbWN4KyQJGM1sOsD4rukXuxv6tA==
X-Received: by 2002:aa7:904e:0:b0:56b:a2f8:1d0f with SMTP id n14-20020aa7904e000000b0056ba2f81d0fmr9918822pfo.0.1670735845341;
        Sat, 10 Dec 2022 21:17:25 -0800 (PST)
Received: from fedora.flets-east.jp ([2400:4050:c360:8200:8ae8:3c4:c0da:7419])
        by smtp.gmail.com with ESMTPSA id f125-20020a623883000000b00575d90636dcsm3463684pfa.6.2022.12.10.21.17.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Dec 2022 21:17:25 -0800 (PST)
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
Subject: [PATCH 0/3] KVM: arm64: Normalize cache configuration
Date: Sun, 11 Dec 2022 14:16:57 +0900
Message-ID: <20221211051700.275761-1-akihiko.odaki@daynix.com>
X-Mailer: git-send-email 2.38.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Message-ID: <20221211051657.azTXjEMYMj_zs5wdRF3rpCTBFpCMyPduOcwbkmKhzpw@z>

Before this change, the cache configuration of the physical CPU was
exposed to vcpus. This is problematic because the cache configuration a
vcpu sees varies when it migrates between vcpus with different cache
configurations.

Fabricate cache configuration from arm64_ftr_reg_ctrel0.sys_val, which
holds the CTR_EL0 value the userspace sees regardless of which physical
CPU it resides on.

HCR_TID2 is now always set as it is troublesome to detect the difference
of cache configurations among physical CPUs.

CSSELR_EL1 is now held in the memory instead of the corresponding
phyisccal register as the fabricated cache configuration may have a
cache level which does not exist in the physical CPU, and setting the
physical CSSELR_EL1 for the level results in an UNKNOWN behavior.

CLIDR_EL1 and CCSIDR_EL1 are now writable from the userspace so that
the VMM can restore the values saved with the old kernel.

Akihiko Odaki (3):
  arm64/sysreg: Add CCSIDR2_EL1
  arm64/cache: Move CLIDR macro definitions
  KVM: arm64: Normalize cache configuration

 arch/arm64/include/asm/cache.h             |   6 +
 arch/arm64/include/asm/kvm_arm.h           |   3 +-
 arch/arm64/include/asm/kvm_emulate.h       |   4 -
 arch/arm64/include/asm/kvm_host.h          |   6 +-
 arch/arm64/kernel/cacheinfo.c              |   5 -
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h |   2 -
 arch/arm64/kvm/reset.c                     |   1 +
 arch/arm64/kvm/sys_regs.c                  | 232 ++++++++++++---------
 arch/arm64/tools/sysreg                    |   5 +
 9 files changed, 153 insertions(+), 111 deletions(-)

-- 
2.38.1

