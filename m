Return-Path: <SRS0=1z46=PW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81D4FC433EF
	for <kvmarm@archiver.kernel.org>; Wed,  3 Nov 2021 06:27:16 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E88B660240
	for <kvmarm@archiver.kernel.org>; Wed,  3 Nov 2021 06:27:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org E88B660240
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2C11A4B10A;
	Wed,  3 Nov 2021 02:27:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XAGRJdaL9-q7; Wed,  3 Nov 2021 02:27:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A3AE4B101;
	Wed,  3 Nov 2021 02:27:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2B7214B0F5
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Nov 2021 02:27:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bl4-Lru7pRLd for <kvmarm@lists.cs.columbia.edu>;
 Wed,  3 Nov 2021 02:27:10 -0400 (EDT)
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com
 [209.85.210.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8A0534A19F
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Nov 2021 02:27:10 -0400 (EDT)
Received: by mail-pf1-f201.google.com with SMTP id
 r2-20020a627602000000b00480f8ce37abso836715pfc.8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 02 Nov 2021 23:27:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=nOpE9XVDgQOIo/EJs2jaMDIMC2kgYNF2JDnFhdJTdr4=;
 b=alR/PVozPXxI+DTzgB9UiN0rnqOz8EhyWoNbPB3LJLbK9Af6UePyRp74QzL8TTmQbs
 1FPjSYevscpHUsmHkDMbj/iJblVmwQ8Szd3K27rlrrwIoPFaxAdG/pyQNTmexiyhhHPA
 VZnKbNJEtDzYrdi5So9pVrC0IvI3JW+MtO9AcipNN1V6UqO8SdG93YW1goR/zB5F5CFa
 e+9OIlnUrdWSqJuh1c4jfWQ6TEWZdjmDPbqM7dG/ovFsnxUvj5CA3RwTdAkTogKr2LLn
 eNN4WzzWMwJipvU9QtOT1/lD2jXZ+s4nFBdN/f8+sX7yU4i3E+YLOwolhALblWKIKpjG
 IV4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=nOpE9XVDgQOIo/EJs2jaMDIMC2kgYNF2JDnFhdJTdr4=;
 b=q54pkEOJN5VsSQubzuolzp5yaMpHc9DqRAWIcxK1G0gd8Z9enYmUVbg7LCKsWvCOnv
 0DtBluQEQAZTjenu4dyNJs8AnDqkt9PXbO9Upph+YfF1Bnu0XJGdYcnF2LyY+Fv96ZSB
 0zxi8G24x3I06ToXg8zn0yVx6VhKU12cjAAYan+Ch+SnzhHokYqkHAt1sypserxUHNyv
 Jj6iRReYS3vRHUuULVqU7HG7gc+qn6VTi3WYUmkXeWkIIAVi5ltsskiUpm2i7DXHbMc5
 uMKJdo4R7C1UklYODt54Yq62gEegzZ82i6MlT9mAo8UWC+cqSN8bD5rSHoqnwQZzzW1n
 W7Nw==
X-Gm-Message-State: AOAM530r4P0ExqQ2B6PoJSmyPaeUX0Bcj4myqVB325vFNS4p5EzxLsy1
 2SDwYjo7h2cTs4lRINginHIThOIuZ5U=
X-Google-Smtp-Source: ABdhPJyAcuKAnRL2nqwyBBddlsT73iHPXL9DpaQ7c+DPjyAlP13VWMhR1DxTmZ4CAAgmV7tDs21sykbK9OU=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:902:e5ce:b0:142:780:78db with SMTP id
 u14-20020a170902e5ce00b00142078078dbmr9392206plf.12.1635920829651; Tue, 02
 Nov 2021 23:27:09 -0700 (PDT)
Date: Tue,  2 Nov 2021 23:24:52 -0700
Message-Id: <20211103062520.1445832-1-reijiw@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [RFC PATCH v2 00/28] KVM: arm64: Make CPU ID registers writable by
 userspace
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

In KVM/arm64, values of ID registers for a guest are mostly same as
its host's values except for bits for feature that KVM doesn't support
and for opt-in features that userspace didn't configure.  Userspace
can use KVM_SET_ONE_REG to a set ID register value, but it fails
if userspace attempts to modify the register value.

This patch series adds support to allow userspace to modify a value of
ID registers (as long as KVM can support features that are indicated
in the registers) so userspace can have more control of configuring
and unconfiguring features for guests.
The patch series affects both VHE or non-VHE including protected VMs
for now but should be changed not to affect for protected VMs, which
will have a different way of configuring ID registers [1] based on
its different requirements.
There was a patch series that tried to achieve the same thing [2].
A few snippets of codes in this series were inspired by or came from [2].

The initial value of ID registers for a vCPU will be the host's value
with bits cleared for unsupported features and for opt-in features that
were not configured. So, the initial value userspace can see (via
KVM_GET_ONE_REG) is the upper limit that can be set for the register.
Any requests to change the value that conflicts with opt-in features'
configuration will fail.

When a guest tries to use a CPU feature that is not exposed to the guest,
trapping it (to emulate a real CPU's behavior) would generally be a
desirable behavior (when it's possible with no or little side effects).
The later patches in the series add codes for this.  Only features that
can be trapped independently will be trapped by this series though.

The series is based on v5.15 with the patch series [3] applied.

v2:
  - Remove unnecessary line breaks. [Andrew]
  - Use @params for comments. [Andrew]
  - Move arm64_check_features to arch/arm64/kvm/sys_regs.c and
    change that KVM specific feature check function.  [Andrew]
  - Remove unnecessary raz handling from __set_id_reg. [Andrew]
  - Remove sys_val field from the initial id_reg_info and add it
    in the later patch. [Andrew]
  - Call id_reg->init() from id_reg_info_init(). [Andrew]
  - Fix cpuid_feature_cap_perfmon_field() to convert 0xf to 0x0
    (and use it in the following patches).
  - Change kvm_vcpu_first_run_init to set has_run_once to false
    when kvm_id_regs_consistency_check() fails.
  - Add a patch to introduce id_reg_info for ID_AA64MMFR0_EL1,
    which requires special validity checking for TGran*_2 fields.
  - Add patches to introduce id_reg_info for ID_DFR1_EL1 and
    ID_MMFR0_EL1, which are required due to arm64_check_features
    implementation change.
  - Add a new argument, which is a pointer to id_reg_info, for
    id_reg_info's validate()

v1: https://lore.kernel.org/all/20211012043535.500493-1-reijiw@google.com/

[1] https://lore.kernel.org/kvmarm/20211010145636.1950948-1-tabba@google.com/
[2] https://lore.kernel.org/kvm/20201102033422.657391-1-liangpeng10@huawei.com/
[3] https://lore.kernel.org/kvmarm/20211007233439.1826892-1-rananta@google.com/

Reiji Watanabe (28):
  KVM: arm64: Add has_reset_once flag for vcpu
  KVM: arm64: Save ID registers' sanitized value per vCPU
  KVM: arm64: Introduce struct id_reg_info
  KVM: arm64: Keep consistency of ID registers between vCPUs
  KVM: arm64: Make ID_AA64PFR0_EL1 writable
  KVM: arm64: Make ID_AA64PFR1_EL1 writable
  KVM: arm64: Make ID_AA64ISAR0_EL1 writable
  KVM: arm64: Make ID_AA64ISAR1_EL1 writable
  KVM: arm64: Make ID_AA64MMFR0_EL1 writable
  KVM: arm64: Hide IMPLEMENTATION DEFINED PMU support for the guest
  KVM: arm64: Make ID_AA64DFR0_EL1 writable
  KVM: arm64: Make ID_DFR0_EL1 writable
  KVM: arm64: Make ID_DFR1_EL1 writable
  KVM: arm64: Make ID_MMFR0_EL1 writable
  KVM: arm64: Make MVFR1_EL1 writable
  KVM: arm64: Make ID registers without id_reg_info writable
  KVM: arm64: Add consistency checking for frac fields of ID registers
  KVM: arm64: Introduce KVM_CAP_ARM_ID_REG_WRITABLE capability
  KVM: arm64: Use vcpu->arch cptr_el2 to track value of cptr_el2 for VHE
  KVM: arm64: Use vcpu->arch.mdcr_el2 to track value of mdcr_el2
  KVM: arm64: Introduce framework to trap disabled features
  KVM: arm64: Trap disabled features of ID_AA64PFR0_EL1
  KVM: arm64: Trap disabled features of ID_AA64PFR1_EL1
  KVM: arm64: Trap disabled features of ID_AA64DFR0_EL1
  KVM: arm64: Trap disabled features of ID_AA64MMFR1_EL1
  KVM: arm64: Trap disabled features of ID_AA64ISAR1_EL1
  KVM: arm64: Activate trapping of disabled CPU features for the guest
  KVM: arm64: selftests: Introduce id_reg_test

 Documentation/virt/kvm/api.rst                |    8 +
 arch/arm64/include/asm/cpufeature.h           |    2 +-
 arch/arm64/include/asm/kvm_arm.h              |   32 +
 arch/arm64/include/asm/kvm_host.h             |   18 +-
 arch/arm64/include/asm/sysreg.h               |    2 +
 arch/arm64/kvm/arm.c                          |   31 +-
 arch/arm64/kvm/debug.c                        |   13 +-
 arch/arm64/kvm/hyp/vhe/switch.c               |   14 +-
 arch/arm64/kvm/reset.c                        |    4 +
 arch/arm64/kvm/sys_regs.c                     | 1236 ++++++++++++++--
 include/uapi/linux/kvm.h                      |    1 +
 tools/arch/arm64/include/asm/sysreg.h         |    1 +
 tools/testing/selftests/kvm/.gitignore        |    1 +
 tools/testing/selftests/kvm/Makefile          |    1 +
 .../selftests/kvm/aarch64/id_reg_test.c       | 1296 +++++++++++++++++
 15 files changed, 2508 insertions(+), 152 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/aarch64/id_reg_test.c

-- 
2.33.1.1089.g2158813163f-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
