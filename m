Return-Path: <SRS0=n474=OM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45449C433F5
	for <kvmarm@archiver.kernel.org>; Wed, 22 Sep 2021 12:47:12 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BCD756120D
	for <kvmarm@archiver.kernel.org>; Wed, 22 Sep 2021 12:47:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org BCD756120D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3062B4B09C;
	Wed, 22 Sep 2021 08:47:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cKLAD6fGAxkf; Wed, 22 Sep 2021 08:47:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 08E754ACC9;
	Wed, 22 Sep 2021 08:47:10 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4FF5A406E7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Sep 2021 08:47:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wVv1doHnxQDk for <kvmarm@lists.cs.columbia.edu>;
 Wed, 22 Sep 2021 08:47:07 -0400 (EDT)
Received: from mail-qk1-f202.google.com (mail-qk1-f202.google.com
 [209.85.222.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3EE3A4024F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Sep 2021 08:47:07 -0400 (EDT)
Received: by mail-qk1-f202.google.com with SMTP id
 t18-20020a05620a0b1200b003f8729fdd04so10434505qkg.5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Sep 2021 05:47:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=yFOEbvnmLRE/MkTldpqRjjZcedskEwLRag9pY/Gsti8=;
 b=lqFiVOFnQ+0KhLoph58xwAtl+YvZwPQXFz7TkOFZ5ID33rHZ8/wh5S8eX3QOIhQI3s
 AvBhm2vjK6T/lB7ri+u4Pl81oSKqbJWOlGbpOaAMArLOz8DRgLT2whq7bHmNeBIJ+zcT
 8HmFgRKSCbVoNfjXt41sG9VIEHy+P7U4k4tkHp0OPQ70jwdeJEdrEYqdlRqHdcVyN83N
 S5YkaxfymReqcbqI1j5CnxWnBzo7oYAR4jj1cW0rbOoYiySu109OviCq05WzH2nZcnLp
 1bPohbKzJ+hJ5cd12GyXd3+GE3UCd76qxejPwwDTh1Zz8j98F8TPUhH+PLu8gIPsHuX6
 oCUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=yFOEbvnmLRE/MkTldpqRjjZcedskEwLRag9pY/Gsti8=;
 b=r6WnsgYUcKjTHuZHnz7t9aI95TOR7aVfQC7pcwQFQYeHut6QMOd/rrIuvxDmr9YQ66
 1EWw8h94FL01VDO8Q0vvTDvTFsLjaJEtAgbYJlh5K3Npw4nWVfxwHP7V6tql+U22WB+k
 Kyk7jBgCI1ak7IINcM7DS9GN+YmwMyCYbq3lqwJbkd1TQ6VKnVZ8bDJU6VkrZiKAD8kn
 E11EfE/TR7C5fOYOe+WNo626Wv4bN48jXmF3T9YfOhicIcSJG7KMkojjVl/BKewCkPM1
 1Qx6JY9q4tgliXbYeMyAwtmkuLhOaU12uM4B6ER2AYoQsUKYjJ/rRmTgItYQu+9mrUmn
 wPdw==
X-Gm-Message-State: AOAM533fvQC+2xzTYpoCybZ/jdStp1W7IKOqiAqpG3qNq/ICcclrrxIu
 hfiLWdQlb2axuPVtqASSOQoH4avy2XP0j8kLBRT33dTM6xnfQsEAp95f3rdGXlO/Zo1yluIBBwT
 kl10R8gHexegQs+vxCovBA/dKZkwwwItjQGhGoBAxK80k9Q89pAN9eiTWBvx6rS4tLck=
X-Google-Smtp-Source: ABdhPJyoWFoyStmCkS24R7d0GBY3bV8l/thty5+34iLzeNvMU3bFfF8UZu0rNinvkttL3hXSDtynpikIVA==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:ad4:5554:: with SMTP id
 v20mr36606923qvy.16.1632314826731; 
 Wed, 22 Sep 2021 05:47:06 -0700 (PDT)
Date: Wed, 22 Sep 2021 13:46:52 +0100
Message-Id: <20210922124704.600087-1-tabba@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
Subject: [PATCH v6 00/12] KVM: arm64: Fixed features for protected VMs
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kernel-team@android.com, kvm@vger.kernel.org, maz@kernel.org,
 pbonzini@redhat.com, will@kernel.org, linux-arm-kernel@lists.infradead.org
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

Hi,

Changes since v5 [1]:
- Rebase on 5.15-rc2
- Include Marc's early exception handlers in the series
- Refactoring and fixes (Drew, Marc)

This patch series adds support for restricting CPU features for protected VMs
in KVM (pKVM). For more background, please refer to the previous series [1].

This series is based on 5.15-rc2. You can find the applied series here [2].

Cheers,
/fuad

[1] https://lore.kernel.org/kvmarm/20210827101609.2808181-1-tabba@google.com/

[2] https://android-kvm.googlesource.com/linux/+/refs/heads/tabba/el2_fixed_feature_v6

Fuad Tabba (9):
  KVM: arm64: Add missing FORCE prerequisite in Makefile
  KVM: arm64: Pass struct kvm to per-EC handlers
  KVM: arm64: Add missing field descriptor for MDCR_EL2
  KVM: arm64: Simplify masking out MTE in feature id reg
  KVM: arm64: Add handlers for protected VM System Registers
  KVM: arm64: Initialize trap registers for protected VMs
  KVM: arm64: Move sanitized copies of CPU features
  KVM: arm64: Trap access to pVM restricted features
  KVM: arm64: Handle protected guests at 32 bits

Marc Zyngier (3):
  KVM: arm64: Move __get_fault_info() and co into their own include file
  KVM: arm64: Don't include switch.h into nvhe/kvm-main.c
  KVM: arm64: Move early handlers to per-EC handlers

 arch/arm64/include/asm/kvm_arm.h           |   1 +
 arch/arm64/include/asm/kvm_asm.h           |   1 +
 arch/arm64/include/asm/kvm_fixed_config.h  | 195 ++++++++
 arch/arm64/include/asm/kvm_host.h          |   2 +
 arch/arm64/include/asm/kvm_hyp.h           |   5 +
 arch/arm64/kvm/arm.c                       |  13 +
 arch/arm64/kvm/hyp/include/hyp/fault.h     |  75 ++++
 arch/arm64/kvm/hyp/include/hyp/switch.h    | 221 ++++-----
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h     |  14 +
 arch/arm64/kvm/hyp/include/nvhe/sys_regs.h |  28 ++
 arch/arm64/kvm/hyp/nvhe/Makefile           |   4 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c         |  12 +-
 arch/arm64/kvm/hyp/nvhe/mem_protect.c      |   8 +-
 arch/arm64/kvm/hyp/nvhe/pkvm.c             | 186 ++++++++
 arch/arm64/kvm/hyp/nvhe/switch.c           | 117 +++++
 arch/arm64/kvm/hyp/nvhe/sys_regs.c         | 494 +++++++++++++++++++++
 arch/arm64/kvm/hyp/vhe/switch.c            |  17 +
 arch/arm64/kvm/sys_regs.c                  |  10 +-
 18 files changed, 1257 insertions(+), 146 deletions(-)
 create mode 100644 arch/arm64/include/asm/kvm_fixed_config.h
 create mode 100644 arch/arm64/kvm/hyp/include/hyp/fault.h
 create mode 100644 arch/arm64/kvm/hyp/include/nvhe/pkvm.h
 create mode 100644 arch/arm64/kvm/hyp/include/nvhe/sys_regs.h
 create mode 100644 arch/arm64/kvm/hyp/nvhe/pkvm.c
 create mode 100644 arch/arm64/kvm/hyp/nvhe/sys_regs.c


base-commit: e4e737bb5c170df6135a127739a9e6148ee3da82
-- 
2.33.0.464.g1972c5931b-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
