Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89A2CC433FE
	for <kvmarm@archiver.kernel.org>; Fri,  8 Apr 2022 20:04:00 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B5D3F400CF;
	Fri,  8 Apr 2022 16:03:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HSe+TNTVuaPq; Fri,  8 Apr 2022 16:03:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 920EF4B1D8;
	Fri,  8 Apr 2022 16:03:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1A9E34B1D8
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Apr 2022 16:03:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vaRMAaH5+1Ny for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Apr 2022 16:03:55 -0400 (EDT)
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com
 [209.85.216.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C7BA64B1D5
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Apr 2022 16:03:55 -0400 (EDT)
Received: by mail-pj1-f73.google.com with SMTP id
 l2-20020a17090ad10200b001ca56de815aso5872768pju.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 08 Apr 2022 13:03:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:cc;
 bh=uL4T8x7PjGlhNU0AUZ082p/RK2qsDuZaw90ql6pSgAk=;
 b=OVGsPQrYXwHuNe31ITOhye0y5tdZdj03XTVkCx5cOcyhrwhRfEDyKUSS1JIVjLaN/o
 XqeiY7Ly5Fd4YffB7xzCjxD+MsinUrXhkz1IX7fbJ7YF7DZo8EhlMIDvzWl16oEAi5Tg
 5GF7VQRqe3GCtryeQKKxcwfbA5cFkUyRL2b2TauXhZGh+Gkt1Q31YZXFgd0l9bDLJMaQ
 /SPTq1Zz+YJuAWJM4LZCaf65GbiCLYw4hygxl3QvtvGA7UUcsg5mrpvZYjihEgGjWbPC
 qUbD6DyMRsBchsR35e+T7yn5MH9/TED3jrkIjqCb4v/veg9ZrDip6Ui6iUFahq+zA8X9
 8s2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:cc;
 bh=uL4T8x7PjGlhNU0AUZ082p/RK2qsDuZaw90ql6pSgAk=;
 b=LUTR+NBf8lEUBsnXhnpsySjceRBh02/kD+m5noWAhu28dZseG6kr+p5E5++h5ESNPp
 nZuznU7rHxbwmgtUmlBl0T5mXmDYfMzHYLMcaPsZgTHi9gyam5ZlE76bWWe9XVfax4EX
 YePxVIQbezC8HxKxB8XYMfzlUeGtM9YbHpQA/eL1RFbIAFn6qB9qtIuzYRsHdcJUBces
 56RR9eWcck/LVsbGmepcEOt4rLEfiQMDK6n4okbccT8UEN494Vz7cxsnmNAw2lR9umVa
 P/ummQtoD0OyBMPUEJRO9OhdlY69MjUP2L1TyLjcE24vSKpLSFAOCwc0D3lpGqNyCx+r
 /SdQ==
X-Gm-Message-State: AOAM530m9P2U9Hq4j1WlOD+61dg5E8vehUCtwmAHGXE7oIydVw12Cxb5
 qeXQPFnvijEf7lxmW3aCEeNjcZc36DPesaZnsg==
X-Google-Smtp-Source: ABdhPJyiunI3puMJj1X39Qi2X/Kl8I3Sm0IuMT8hRzbT/V7JmfxVLYcFkeHruDPMJTX5Vy4HLKMcgBC/SSaYRfJ+Bg==
X-Received: from kaleshsingh.mtv.corp.google.com
 ([2620:15c:211:200:f0ed:c8a:dab7:ecc2])
 (user=kaleshsingh job=sendgmr) by 2002:a17:903:216:b0:156:1e8d:a81 with SMTP
 id r22-20020a170903021600b001561e8d0a81mr20473765plh.140.1649448234615; Fri,
 08 Apr 2022 13:03:54 -0700 (PDT)
Date: Fri,  8 Apr 2022 13:03:23 -0700
Message-Id: <20220408200349.1529080-1-kaleshsingh@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.1178.g4f1659d476-goog
Subject: [PATCH v7 0/6] KVM: arm64: Hypervisor stack enhancements
From: Kalesh Singh <kaleshsingh@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, will@kernel.org,
 kvmarm@lists.cs.columbia.edu, Andrew Walbran <qwandor@google.com>,
 maz@kernel.org, Masahiro Yamada <masahiroy@kernel.org>,
 kernel-team@android.com, surenb@google.com,
 linux-arm-kernel@lists.infradead.org,
 Nick Desaulniers <ndesaulniers@google.com>, linux-kernel@vger.kernel.org,
 Changbin Du <changbin.du@intel.com>
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

This is v7 of the nVHE hypervisor stack enhancements. This version is based
on 5.18-rc1 and drops the hypervisor stack unwinding and overflow-stack
patches. These require further discussion and will be resent separately.

Previous versions can be found at: 
v6: https://lore.kernel.org/r/20220314200148.2695206-1-kaleshsingh@google.com/
v5: https://lore.kernel.org/r/20220307184935.1704614-1-kaleshsingh@google.com/
v4: https://lore.kernel.org/r/20220225033548.1912117-1-kaleshsingh@google.com/
v3: https://lore.kernel.org/r/20220224051439.640768-1-kaleshsingh@google.com/
v2: https://lore.kernel.org/r/20220222165212.2005066-1-kaleshsingh@google.com/
v1: https://lore.kernel.org/r/20220210224220.4076151-1-kaleshsingh@google.com/

Thanks,
Kalesh

-----

This series is based on 5.18-rc1 and adds stack guard pages to nVHE and pKVM
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
 arch/arm64/include/asm/kvm_mmu.h     |  4 ++
 arch/arm64/kvm/arm.c                 | 39 ++++++++++++--
 arch/arm64/kvm/handle_exit.c         | 13 ++---
 arch/arm64/kvm/hyp/include/nvhe/mm.h |  6 ++-
 arch/arm64/kvm/hyp/nvhe/host.S       | 24 +++++++++
 arch/arm64/kvm/hyp/nvhe/hyp-main.c   | 18 ++++++-
 arch/arm64/kvm/hyp/nvhe/mm.c         | 78 ++++++++++++++++++----------
 arch/arm64/kvm/hyp/nvhe/setup.c      | 31 +++++++++--
 arch/arm64/kvm/hyp/nvhe/switch.c     |  7 ++-
 arch/arm64/kvm/mmu.c                 | 70 ++++++++++++++++---------
 scripts/kallsyms.c                   |  2 +-
 12 files changed, 223 insertions(+), 70 deletions(-)


base-commit: 3123109284176b1532874591f7c81f3837bbdc17
-- 
2.35.1.1178.g4f1659d476-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
