Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14870C4332F
	for <kvmarm@archiver.kernel.org>; Sun, 11 Dec 2022 05:17:30 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 75C2D4BDBC;
	Sun, 11 Dec 2022 00:17:30 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered)
	header.i=@daynix-com.20210112.gappssmtp.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lhrogV5umVVo; Sun, 11 Dec 2022 00:17:29 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 54BF14BDAF;
	Sun, 11 Dec 2022 00:17:29 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A08C04BDAF
 for <kvmarm@lists.cs.columbia.edu>; Sun, 11 Dec 2022 00:17:27 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Wbdlgn02+jS2 for <kvmarm@lists.cs.columbia.edu>;
 Sun, 11 Dec 2022 00:17:26 -0500 (EST)
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com
 [209.85.210.170])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7E6124BDAC
 for <kvmarm@lists.cs.columbia.edu>; Sun, 11 Dec 2022 00:17:26 -0500 (EST)
Received: by mail-pf1-f170.google.com with SMTP id c13so6433370pfp.5
 for <kvmarm@lists.cs.columbia.edu>; Sat, 10 Dec 2022 21:17:26 -0800 (PST)
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
 b=eFYFhYO9tnwAkcBOSs6jYSZmFpvCJ534dXaLPpaLs2L5CPos2Y+xlFsW4OucEXPpIE
 rRqtuiajMTLRLVMxFz0QA/zTse9mNXCOte9NPHgs2CokYT3TTFkQomhpg5W8yT+CteAK
 ESXTGvc1e72ORSrZF+GbvjxW9yZM7tXs7I8u7WT9vV0q6NzWDSn+BcbohcELfwMAO5tO
 jlsX9tXW7r8lAStKfagIrK2aVbKNcNDfgoBKBy5Jo0JLY4jkJyAOhtzG1b9bZqVGdgxh
 hU0nbIyxLbL7U3k2v/1Zx1gIUhyDKj/YKYxpMaTfNatGQnBfVj++b+ZztKC+/YSmmbru
 SEdQ==
X-Gm-Message-State: ANoB5pnBneXCRgbw7+nvrGpg0OQ6Jn4vHKuyv4BDs5v2BWIYocJhLyvl
 4/QdaiqHrMwEd/176pn9uJzXvA==
X-Google-Smtp-Source: AA0mqf6ROckMAbfbisK6rGjhVdzEf/yVRLrsZe5jClX/LxHWmHcqbWN4KyQJGM1sOsD4rukXuxv6tA==
X-Received: by 2002:aa7:904e:0:b0:56b:a2f8:1d0f with SMTP id
 n14-20020aa7904e000000b0056ba2f81d0fmr9918822pfo.0.1670735845341; 
 Sat, 10 Dec 2022 21:17:25 -0800 (PST)
Received: from fedora.flets-east.jp ([2400:4050:c360:8200:8ae8:3c4:c0da:7419])
 by smtp.gmail.com with ESMTPSA id
 f125-20020a623883000000b00575d90636dcsm3463684pfa.6.2022.12.10.21.17.21
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sat, 10 Dec 2022 21:17:25 -0800 (PST)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
To: 
Subject: [PATCH 0/3] KVM: arm64: Normalize cache configuration
Date: Sun, 11 Dec 2022 14:16:57 +0900
Message-Id: <20221211051700.275761-1-akihiko.odaki@daynix.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Cc: Alyssa Rosenzweig <alyssa@rosenzweig.io>, Hector Martin <marcan@marcan.st>,
 Akihiko Odaki <akihiko.odaki@daynix.com>,
 Mathieu Poirier <mathieu.poirier@linaro.org>, Marc Zyngier <maz@kernel.org>,
 Sven Peter <sven@svenpeter.dev>, linux-kernel@vger.kernel.org,
 Will Deacon <will@kernel.org>, asahi@lists.linux.dev,
 Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.linux.dev,
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

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
