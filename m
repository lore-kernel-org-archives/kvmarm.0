Return-Path: <SRS0=Ht+8=K5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A605FC47082
	for <kvmarm@archiver.kernel.org>; Thu,  3 Jun 2021 18:34:02 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1F464613B1
	for <kvmarm@archiver.kernel.org>; Thu,  3 Jun 2021 18:34:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1F464613B1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A36AC4B0BA;
	Thu,  3 Jun 2021 14:34:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IMx1S7jaFC0h; Thu,  3 Jun 2021 14:34:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 895FB4B0E8;
	Thu,  3 Jun 2021 14:34:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6698A4B0E8
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Jun 2021 14:33:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rSPpe7waKE+y for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Jun 2021 14:33:58 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 494DA4B0BA
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Jun 2021 14:33:58 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id B93CF613B8;
 Thu,  3 Jun 2021 18:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1622745237;
 bh=mTX1Gfilu39wfuOraE/ww5xMJ6bnVmsdjqCBug2xBWM=;
 h=From:To:Cc:Subject:Date:From;
 b=agvkfBC8twP+tZhCehKLs0SBWL16nvksI3UyUQj6xm1GIZPhO5HpmerqqHpATH39L
 NmrM/4dVMYBwnX58Ev1uVxlzuEfSy5kjFYRO8sdwV33yvzyTCr0rLV/5t8Odss5sVb
 752IfXNj6esCtWQgOVnjeAHmIsik6f95ttIVL0G+Qssa/HNGGKVhnShf+MGkCj1GBd
 rarZ3CMi78hBXCJOu81PQzciTGS7s7mOa6zFMe3b+IePp+WXzo/q6uUIfSgD8yS8wK
 s0KbvW9sO119NYEqXiAeHdizNEQCIHmR98fuz4qzZ6DZ0GDdViHYjod2WfTweEGn6q
 4AC0QbPYZa3LQ==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 0/4] kvm/arm64: Initial pKVM user ABI
Date: Thu,  3 Jun 2021 19:33:43 +0100
Message-Id: <20210603183347.1695-1-will@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 linux-arm-kernel@lists.infradead.org, Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Will Deacon <will@kernel.org>
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

Hi folks,

These patches implement support for userspace to request a "Protected VM"
using KVM on arm64 when configured in Protected Mode (see the existing
kvm-arm.mode=protected command-line option).

The final patch documents the new ABI and its behaviour, so I won't
reproduce that here. Please go and have a look there instead!

Note that this series _doesn't_ implement the actual isolation of guest
memory; it's more about setting the groundwork for subsequent patches
and getting feedback on the user-facing side of things. The final patch
is marked RFC accordingly.

Cheers,

Will

Cc: Marc Zyngier <maz@kernel.org>
Cc: James Morse <james.morse@arm.com>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com> 
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Christoffer Dall <christoffer.dall@arm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com> 
Cc: Fuad Tabba <tabba@google.com>
Cc: Quentin Perret <qperret@google.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: David Brazdil <dbrazdil@google.com>
Cc: kvm@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org

--->8

Will Deacon (4):
  KVM: arm64: Ignore 'kvm-arm.mode=protected' when using VHE
  KVM: arm64: Extend comment in has_vhe()
  KVM: arm64: Parse reserved-memory node for pkvm guest firmware region
  KVM: arm64: Introduce KVM_CAP_ARM_PROTECTED_VM

 .../admin-guide/kernel-parameters.txt         |   1 -
 Documentation/virt/kvm/api.rst                |  69 ++++++++
 arch/arm64/include/asm/kvm_host.h             |  10 ++
 arch/arm64/include/asm/virt.h                 |   3 +
 arch/arm64/include/uapi/asm/kvm.h             |   9 +
 arch/arm64/kernel/cpufeature.c                |  10 +-
 arch/arm64/kvm/Makefile                       |   2 +-
 arch/arm64/kvm/arm.c                          |  24 +--
 arch/arm64/kvm/mmu.c                          |   3 +
 arch/arm64/kvm/pkvm.c                         | 156 ++++++++++++++++++
 include/uapi/linux/kvm.h                      |   1 +
 11 files changed, 267 insertions(+), 21 deletions(-)
 create mode 100644 arch/arm64/kvm/pkvm.c

-- 
2.32.0.rc0.204.g9fa02ecfa5-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
