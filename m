Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4C81C47089
	for <kvmarm@archiver.kernel.org>; Thu,  1 Dec 2022 15:52:04 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2C2464B15C;
	Thu,  1 Dec 2022 10:52:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered)
	header.i=@daynix-com.20210112.gappssmtp.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DVCPIcJgZmLH; Thu,  1 Dec 2022 10:52:03 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B0C2A4B10B;
	Thu,  1 Dec 2022 10:52:01 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7038740DAE
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Dec 2022 05:49:49 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DqwoGlKJWwqP for <kvmarm@lists.cs.columbia.edu>;
 Thu,  1 Dec 2022 05:49:47 -0500 (EST)
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com
 [209.85.215.182])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A705240399
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Dec 2022 05:49:47 -0500 (EST)
Received: by mail-pg1-f182.google.com with SMTP id v3so1336050pgh.4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 01 Dec 2022 02:49:47 -0800 (PST)
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
 b=ECbdAgX9V+A1v8sRxMq4XBBm1vUUCrxpoDAS8+WsOhnrQgrxaYaGhjOkqdLQwIpUyS
 O9WrRzuCb+nTpelDkslgSH7YgXmplg2WkxgibXc7e1DZkdBOXXAzMJlHQ4q+u9/rFfK2
 EXI8XDkEdVB1PZpIy/RrM9cIdLCNh8YzEH8JZ6phZCLBFUGRuWQxPWz0fz5xzI/qBZnk
 xFwKZpSs8WSKer04ZEt6K/pHAAxKB4d0FGU0k0UlTmVV02JN6zxwOomgIRaMrTPImQO/
 LaBdOOYDZnB70RyPFe1j2OvFGdkUzRbvAxW769dAfJkrlvG8Ghtb8l1m0AjgVyl2l9WF
 ZOuA==
X-Gm-Message-State: ANoB5plPMcVd+2CZJ9zbRB5qvpTdRVxVVkEHveMj9DQym63WJxGJQ1HS
 Djtn+dH4sBPy3CSYmXjUG+06kw==
X-Google-Smtp-Source: AA0mqf6Cyu7laoCbi5JoSZv0gkqjvpvrXeXiVPp6Vj2NLBpsceZWkQJBNxO9yJFLr0IOOo439dEXsQ==
X-Received: by 2002:a63:310:0:b0:478:7e02:fa11 with SMTP id
 16-20020a630310000000b004787e02fa11mr25577pgd.222.1669891786574; 
 Thu, 01 Dec 2022 02:49:46 -0800 (PST)
Received: from fedora.flets-east.jp ([2400:4050:c360:8200:8ae8:3c4:c0da:7419])
 by smtp.gmail.com with ESMTPSA id
 4-20020a630804000000b004785a63b44bsm2320580pgi.43.2022.12.01.02.49.43
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 01 Dec 2022 02:49:46 -0800 (PST)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
To: 
Subject: [PATCH 0/3] KVM: arm64: Handle CCSIDR associativity mismatches
Date: Thu,  1 Dec 2022 19:49:11 +0900
Message-Id: <20221201104914.28944-1-akihiko.odaki@daynix.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
X-Mailman-Approved-At: Thu, 01 Dec 2022 10:52:00 -0500
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

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
