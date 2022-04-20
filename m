Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5CF9C433EF
	for <kvmarm@archiver.kernel.org>; Wed, 20 Apr 2022 21:43:36 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 14CFE4B18F;
	Wed, 20 Apr 2022 17:43:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id oEn72mDqXydC; Wed, 20 Apr 2022 17:43:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1135A4B1A0;
	Wed, 20 Apr 2022 17:43:32 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 189FF4B192
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Apr 2022 17:43:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id U7+nkwjMAi8F for <kvmarm@lists.cs.columbia.edu>;
 Wed, 20 Apr 2022 17:43:29 -0400 (EDT)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C87A14B18F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Apr 2022 17:43:29 -0400 (EDT)
Received: by mail-yb1-f201.google.com with SMTP id
 a16-20020a056902057000b00641c83f82f5so2621801ybt.22
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Apr 2022 14:43:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:cc;
 bh=+ofVstgby+3VUZOCrqyBENIw0S2XGlsTcYhm1RZdUZ8=;
 b=V7/nRf1aqIhn3GrpHT/lkZMBo6WJCgvRWtI4hC60Tae7j51kV7NX/30fPVFIT1ZkRi
 UKsROxDen1kXaLPU9eDlOYdcjYnozYuA1MnCV5aibXYS3U3bKc+BUjEJwkVwRxaK3hCB
 GGSVcC3uywSpPEm1PDWOTeFyI7qJnBk/oLORu10hqRdBr9k0nt570qWwaznIFNr2gmiw
 8XjMBScKKSOI1Y+1Y77BNZ7MLZTkTJ13fqOIjHBAd6Rfx4XFYzh/TGqiQ6vNll2ZiYoS
 WRm5geb+q+v1x1QVSZEjNHe3dtSRAg2v4RqdKtcocsQgYo32gQqVgraqx9QT36kUhGkB
 Rg2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:cc;
 bh=+ofVstgby+3VUZOCrqyBENIw0S2XGlsTcYhm1RZdUZ8=;
 b=hvLEXIeY1ialZYens6+0yKr+m13mvKp2QL5mFsiH3zYYyE1tLl+iDI0Nx98l3xiQ82
 J7eGSda8mfbcfWii+A2NvSEtiTMym3jTcgDhrNq7vcxwYw58b+nKSfwa/fYVtxM37+vu
 yI3HPgwAXEk2OIl4UKTJXYNGxmJAmEgRLDbq6UBuMj/ANNZZSSmDaM9da2Dy32LmOAw4
 5qsmJzOZZs/sg4m8FZ2QfYUcNxxIipDeXwvPrdQmdc6qjiXwOodUWle1YpBfIY1w7klQ
 +9CTviYVa6uhkxGjLbjIP1RlLFdKIjp+/JhxyD2sKrz8lZprWp7muSAb+9eh4+46lRxK
 OCRQ==
X-Gm-Message-State: AOAM531AyFwkyr5n297AX222q5K7VFqPzrxP/ORyXaLB4sLW5p41jtFA
 tXZipHC4psTos62L2z9DO5kjdyYibFkMqk7v0A==
X-Google-Smtp-Source: ABdhPJynQJ6HrTNIms4xwX26QBfSuJVgQPazfDGqbIdwuqV/+SEBOChc4CyWeC3dRM3VwPtqGh5RY3jW3hVs31ZLaw==
X-Received: from kaleshsingh.mtv.corp.google.com
 ([2620:15c:211:200:2a20:cec4:8f41:cd6f])
 (user=kaleshsingh job=sendgmr) by 2002:a81:478b:0:b0:2ea:da8c:5c21 with SMTP
 id u133-20020a81478b000000b002eada8c5c21mr23887312ywa.189.1650491008962; Wed,
 20 Apr 2022 14:43:28 -0700 (PDT)
Date: Wed, 20 Apr 2022 14:42:51 -0700
Message-Id: <20220420214317.3303360-1-kaleshsingh@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [PATCH v8 0/6] KVM: arm64: Hypervisor stack enhancements
From: Kalesh Singh <kaleshsingh@google.com>
Cc: kernel-team@android.com, Catalin Marinas <catalin.marinas@arm.com>,
 will@kernel.org, maz@kernel.org, Masahiro Yamada <masahiroy@kernel.org>,
 linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 Nathan Chancellor <nathan@kernel.org>, Changbin Du <changbin.du@intel.com>,
 linux-arm-kernel@lists.infradead.org, surenb@google.com
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

Hi all,

This is v8 of the nVHE hypervisor stack enhancements. This version is based
on 5.18-rc3.

Previous versions can be found at: 
v7: https://lore.kernel.org/r/20220408200349.1529080-1-kaleshsingh@google.com/
v6: https://lore.kernel.org/r/20220314200148.2695206-1-kaleshsingh@google.com/
v5: https://lore.kernel.org/r/20220307184935.1704614-1-kaleshsingh@google.com/
v4: https://lore.kernel.org/r/20220225033548.1912117-1-kaleshsingh@google.com/
v3: https://lore.kernel.org/r/20220224051439.640768-1-kaleshsingh@google.com/
v2: https://lore.kernel.org/r/20220222165212.2005066-1-kaleshsingh@google.com/
v1: https://lore.kernel.org/r/20220210224220.4076151-1-kaleshsingh@google.com/

Thanks,
Kalesh

-----

This series is based on 5.18-rc3 and adds stack guard pages to nVHE and pKVM
hypervisor; and symbolization of hypervisor addresses.

The guard page stack overflow detection is based on the technique used by
arm64 VMAP_STACK. i.e. the stack is aligned such that the 'stack shift' bit 
of any valid SP is 1. The 'stack shift' bit can be tested in the exception
entry to detect overflow without corrupting GPRs.


Kalesh Singh (6):
  KVM: arm64: Introduce hyp_alloc_private_va_range()
  KVM: arm64: Introduce pkvm_alloc_private_va_range()
  KVM: arm64: Add guard pages for KVM nVHE hypervisor stack
  KVM: arm64: Add guard pages for pKVM (protected nVHE) hypervisor stack
  KVM: arm64: Detect and handle hypervisor stack overflows
  KVM: arm64: Symbolize the nVHE HYP addresses

 arch/arm64/include/asm/kvm_asm.h     |  1 +
 arch/arm64/include/asm/kvm_mmu.h     |  3 ++
 arch/arm64/kvm/arm.c                 | 37 +++++++++++--
 arch/arm64/kvm/handle_exit.c         | 13 ++---
 arch/arm64/kvm/hyp/include/nvhe/mm.h |  6 ++-
 arch/arm64/kvm/hyp/nvhe/host.S       | 24 +++++++++
 arch/arm64/kvm/hyp/nvhe/hyp-main.c   | 18 ++++++-
 arch/arm64/kvm/hyp/nvhe/mm.c         | 78 ++++++++++++++++++----------
 arch/arm64/kvm/hyp/nvhe/setup.c      | 31 +++++++++--
 arch/arm64/kvm/hyp/nvhe/switch.c     |  7 ++-
 arch/arm64/kvm/mmu.c                 | 68 ++++++++++++++++--------
 scripts/kallsyms.c                   |  3 +-
 12 files changed, 220 insertions(+), 69 deletions(-)


base-commit: b2d229d4ddb17db541098b83524d901257e93845
-- 
2.36.0.rc0.470.gd361397f0d-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
