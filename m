Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21AFBC433EF
	for <kvmarm@archiver.kernel.org>; Mon, 14 Mar 2022 06:22:21 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7969649EC0;
	Mon, 14 Mar 2022 02:22:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id TV5aY1B3Cmkg; Mon, 14 Mar 2022 02:22:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E8CD49E44;
	Mon, 14 Mar 2022 02:22:20 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7F17849E37
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Mar 2022 02:22:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mHF1ibJssyBn for <kvmarm@lists.cs.columbia.edu>;
 Mon, 14 Mar 2022 02:22:18 -0400 (EDT)
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com
 [209.85.216.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2130C40BED
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Mar 2022 02:22:18 -0400 (EDT)
Received: by mail-pj1-f74.google.com with SMTP id
 m14-20020a17090a4d8e00b001bf2d4926c5so13105618pjh.3
 for <kvmarm@lists.cs.columbia.edu>; Sun, 13 Mar 2022 23:22:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=6PVulGo8PUqZzVS4FQCQESr0wP4UDOtzRfsUiSpPSzU=;
 b=NMTHcfQ//XkUn0hFLjVC8DV6m2SeAkUsxvrHVx1PDOK7/ZDB4u/CaWkMUe1eUX1KUu
 oeWxc0jrL5ItjthiRDO8371DRjwU6H4tDrgeZRHvcnJ9TQaUJ5dYy73EDcbbJ+OJamsp
 u/gnzwiwxo27r86aAstrIVXL2wUXwb4D2Q7P3FwPRgBjiatwul1mp8Zp8Q+CKD2TbQNp
 J44/0PEURgqLrP49oTQJ9ozS6cl6V9/u1udMFKsqYilq+o+qVUQcozRCnco1kamSOAn0
 jDpWAaZEsrJ3rZQ/lXmprnstFDU7dRHMa1id9zxWeOfUTNaE38HJoTarnCJWj6itYWDX
 tcyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=6PVulGo8PUqZzVS4FQCQESr0wP4UDOtzRfsUiSpPSzU=;
 b=R/8sHEjNlGV3FwJv05T9xsaOa7F7xdGNqQyLkVmBtqRRwBve6kiO1Msq6hphi1MZCZ
 Ps09MvPJkEdugEguJjgNXFj8qrGDOdNELVYzmU321r4VKeDQwb+oGeXlMxePM9vVvN1D
 S9IugeSNY8z7FDk2pgln1X6sQO0ldh3Qj5IF1JFstfjiVaR4WC2jtHhl7sn5crZp2Eq+
 n3+Ra/Piua3kRaMuHMg/qAl+RXz6uEesDXdmm4gu5b8H91RItXvvm7zhLBCN7YLWxfDe
 CElyGL6FJHXYI7vsGNHKkct5AGoDjzwBUr/rBFFmdGptjw8DF8dvl3Sp7NCSGnC+2l09
 zlrg==
X-Gm-Message-State: AOAM5325CXy7h9GtRZjGGKesxgSZD3M/hJkAfbcmz40xSEqKZxQ01pQb
 R8R9v9F48Ff7J0xmZA+1wOfl/HB+TCU=
X-Google-Smtp-Source: ABdhPJxsAV1KsLam10OQrLQ3Mk1lzfy04OADsgT2PIWmgxVOee5D2EHoQAqFiUQHfbSsA2dOXD3LguvkztI=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a05:6a00:b8e:b0:4f7:c63c:f2fd with SMTP id
 g14-20020a056a000b8e00b004f7c63cf2fdmr4623111pfj.8.1647238936995; Sun, 13 Mar
 2022 23:22:16 -0700 (PDT)
Date: Sun, 13 Mar 2022 23:19:56 -0700
Message-Id: <20220314061959.3349716-1-reijiw@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH v4 0/3] KVM: arm64: mixed-width check should be skipped for
 uninitialized vCPUs
From: Reiji Watanabe <reijiw@google.com>
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Peter Shier <pshier@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
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

KVM allows userspace to configure either all EL1 32bit or 64bit vCPUs
for a guest.  At vCPU reset, vcpu_allowed_register_width() checks
if the vcpu's register width is consistent with all other vCPUs'.
Since the checking is done even against vCPUs that are not initialized
(KVM_ARM_VCPU_INIT has not been done) yet, the uninitialized vCPUs
are erroneously treated as 64bit vCPU, which causes the function to
incorrectly detect a mixed-width VM.

This series will fix this problem by introducing a new VM flag that
indicates the guest needs to be configured with all 32bit or 64bit
vCPUs and checking vcpu's register width against the new flag at
the vcpu's KVM_ARM_VCPU_INIT (instead of against other vCPUs'
register width).

Patch-1 introduces a new field 'flags' for kvm_arch (authored by Marc [1]).
The flags will replace a set of booleans for VM features.

Patch-2 introduces KVM_ARCH_FLAG_EL1_32BIT and
KVM_ARCH_FLAG_REG_WIDTH_CONFIGURED bits for kvm->arch.flags and
uses them to check vcpu's register width to fix the problem.

Patch-3 introduces a selftest that can test non-mixed-width vCPUs (all
64bit vCPUs or all 32bit vcPUs) can be configured, and mixed-width
vCPUs cannot be configured.

The series is based on v5.17-rc7.

v4:
  - Use different implementation of vcpu_el1_is_32bit() depending on
    the context. [Marc]
  - Rename kvm_register_width_check_or_init() to kvm_set_vm_width(), and
    call it from kvm_rest_vcpu() instead of from kvm_vcpu_set_target()
  - Remove vcpu_allowed_register_width(), and does the same checking
    in kvm_set_vm_width() instead.

v3: https://lore.kernel.org/all/20220303035408.3708241-1-reijiw@google.com/
  - Introduced 'flags' to kvm_arch, and use bits of the flags for
    a set of booleans for VM feature.
  - Changed 'el1_reg_width' to two bits of 'flags' of kvm_arch.

v2: https://lore.kernel.org/all/20220118041923.3384602-1-reijiw@google.com/
  - Introduced 'el1_reg_width' for kvm_arch and use it to check vcpu's
    register width against the flag at the vcpu's KVM_ARM_VCPU_INIT.

v1: https://lore.kernel.org/all/20220110054042.1079932-1-reijiw@google.com/

[1] https://lore.kernel.org/all/20210715163159.1480168-2-maz@kernel.org/

Marc Zyngier (1):
  KVM: arm64: Generalise VM features into a set of flags

Reiji Watanabe (2):
  KVM: arm64: mixed-width check should be skipped for uninitialized
    vCPUs
  KVM: arm64: selftests: Introduce vcpu_width_config

 arch/arm64/include/asm/kvm_emulate.h          |  27 ++--
 arch/arm64/include/asm/kvm_host.h             |  21 ++-
 arch/arm64/kvm/arm.c                          |   5 +-
 arch/arm64/kvm/mmio.c                         |   3 +-
 arch/arm64/kvm/reset.c                        |  64 ++++++---
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/aarch64/vcpu_width_config.c | 125 ++++++++++++++++++
 8 files changed, 209 insertions(+), 38 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/aarch64/vcpu_width_config.c

-- 
2.35.1.723.g4982287a31-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
