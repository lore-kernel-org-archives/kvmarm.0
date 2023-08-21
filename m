Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD15B4C9E
	for <kvmarm@lists.linux.dev>; Mon, 21 Aug 2023 21:22:47 +0000 (UTC)
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-56438e966baso3995702a12.2
        for <kvmarm@lists.linux.dev>; Mon, 21 Aug 2023 14:22:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692652967; x=1693257767;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=7W2Zs0/pm7I7OHogR/tSUzcr/GJKDVTJTJBw8czH204=;
        b=p3zT+it1diA8XrOL4pxuaxQWqBQCA6sbz/0wUWEj44sZuMzpL7NzWP+kXYjUffQHJo
         kstYgT1CskbgAuGyy4kZMfKUIXlxk+tnL29GRBwKxVgEGpk3P6z5UK1Tr3mNHuUFRtbl
         4Zj+cxp2lu3MR/7wgiJeloEi+J6xd8Q5jyciEb6kU3vlV5vuzIJ6vTD/vQOmaEAfU+g0
         d8KO5ZP5NnhbnOlGO3D9wQqZuLTg1hcqeVxEEH1Z+V9tWp8Y1w+Q+ElKMBajg0VflFC3
         pmVbJeqFYaVuQe5vvKwO9uA7SZxaST3ZNMtNHTlmoGmBN12dY2CO3R2u+VeRNCM4OYYG
         J6XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692652967; x=1693257767;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7W2Zs0/pm7I7OHogR/tSUzcr/GJKDVTJTJBw8czH204=;
        b=YBYzfd3AfIIQyaYcUR/Lt3yii7mRLcZIAUNTrKBTMkJcSZ8gRqLEx/gT+mXBgar4Ur
         CftG9nZsdO2D4mFlf5y7MSqbMmodYZSUh/5TirFEXP4pIAH0Q0b89C3YOzDUGDlsQvs/
         gvLaheo5n6MVkziVeJE9Fzlv1HDIXCVCnZcU3C9ZUOPAdB1zxxbef6VqqdSGpTOx4srK
         C+IYHxPJdu8gnO1vc6hiL1T/0jRz6H+e5y7Y9SDWbcJL3Sej9XD/5oRNwAA7qJoq6uq3
         FJyz2xjGnwCmd0zeI84fEWNiBp0CDnJHtJLHUwtikPj+ilA02DkgfvU8+biBXoMY7lEh
         Siww==
X-Gm-Message-State: AOJu0Yxh963q9Te/O5sXAxVgvGATtJ76UJKWDlugw6Vu4azLjHxKvbwf
	PA4RxqUGmnp74W+OkifxvwrXcqTugt3rZthiLg==
X-Google-Smtp-Source: AGHT+IEVzZXRt8y+Ma6R9WjGxt5eCIhgyL+3uY7/hqkASZkb9M84mnZETxus4J6hL7V+d5xXL8bw+PHEff/qJQhSmQ==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a17:903:1c4:b0:1bc:7c69:925c with SMTP
 id e4-20020a17090301c400b001bc7c69925cmr3776051plh.10.1692652967025; Mon, 21
 Aug 2023 14:22:47 -0700 (PDT)
Date: Mon, 21 Aug 2023 14:22:32 -0700
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.42.0.rc1.204.g551eb34607-goog
Message-ID: <20230821212243.491660-1-jingzhangos@google.com>
Subject: [PATCH v9 00/11] Enable writable for idregs DFR0,PFR0, MMFR{0,1,2,3}
From: Jing Zhang <jingzhangos@google.com>
To: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	ARMLinux <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>
Cc: Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Fuad Tabba <tabba@google.com>, 
	Reiji Watanabe <reijiw@google.com>, Raghavendra Rao Ananta <rananta@google.com>, 
	Suraj Jitindar Singh <surajjs@amazon.com>, Cornelia Huck <cohuck@redhat.com>, 
	Shaoqin Huang <shahuang@redhat.com>, Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"

This patch series enable userspace writable for below idregs:
ID_AA64DFR0_EL1, ID_DFR0_EL1, ID_AA64PFR0_EL1, ID_AA64MMFR{0, 1, 2, 3}_EL1.
A vm ioctl is added to get feature ID register writable masks from userspace.
A selftest is added to verify that KVM handles the writings from user space
correctly.
A relevant patch from Oliver is picked from [3].

---

* v8 -> v9
  - Rebase on v6.5-rc7.
  - Don't allow writable on RES0 fields and those fields not exposed by KVM.
  - Fixed build dependency issue for system register definition generation in
    selftest.

* v7 -> v8
  - Rebase on v6.5-rc5.
  - Add reserved parameters to UAPI to get writable masks for future expansion.
  - Import system regiesters definition automatic generation from kernel to
    selftests.
  - Refactor the selftest for verifying ID register writable from userspace to
    cover all writable ID register fields.

* v6 -> v7
  - Rebase on v6.5-rc4.
  - Add a vm ioctl to get feature ID register writable masks from userspace.
  - Split the change for debug version in ID_{AA64}DFR0_EL1.
  - Addressed some bugs in selftest.

* v5 -> v6
  - Override the type of field AA64DFR0_EL1_DebugVer to be FTR_LOWER_SAFE by the
    discussion of Oliver and Suraj.

* v4 -> v5
  - Rebase on v6.5-rc1 which contains infrastructure for writable idregs.
  - Use guest ID registers values for the sake of emulation.
  - Added a selftest to verify idreg userspace writing.

* v3 -> v4
  - Rebase on v11 of writable idregs series at [2].

* v2 -> v3
  - Rebase on v6 of writable idregs series.
  - Enable writable for ID_AA64PFR0_EL1 and ID_AA64MMFR{0, 1, 2}_EL1.

* v1 -> v2
  - Rebase on latest patch series [1] of enabling writable ID register.

[1] https://lore.kernel.org/all/20230402183735.3011540-1-jingzhangos@google.com
[2] https://lore.kernel.org/all/20230602005118.2899664-1-jingzhangos@google.com
[3] https://lore.kernel.org/kvmarm/20230623205232.2837077-1-oliver.upton@linux.dev

[v1] https://lore.kernel.org/all/20230326011950.405749-1-jingzhangos@google.com
[v2] https://lore.kernel.org/all/20230403003723.3199828-1-jingzhangos@google.com
[v3] https://lore.kernel.org/all/20230405172146.297208-1-jingzhangos@google.com
[v4] https://lore.kernel.org/all/20230607194554.87359-1-jingzhangos@google.com
[v5] https://lore.kernel.org/all/20230710192430.1992246-1-jingzhangos@google.com
[v6] https://lore.kernel.org/all/20230718164522.3498236-1-jingzhangos@google.com
[v7] https://lore.kernel.org/all/20230801152007.337272-1-jingzhangos@google.com
[v8] https://lore.kernel.org/all/20230807162210.2528230-1-jingzhangos@google.com

---

Jing Zhang (9):
  KVM: arm64: Allow userspace to get the writable masks for feature ID
    registers
  KVM: arm64: Document KVM_ARM_GET_REG_WRITABLE_MASKS
  KVM: arm64: Use guest ID register values for the sake of emulation
  KVM: arm64: Enable writable for ID_AA64DFR0_EL1 and ID_DFR0_EL1
  KVM: arm64: Enable writable for ID_AA64PFR0_EL1
  KVM: arm64: Refactor helper Macros for idreg desc
  KVM: arm64: Enable writable for ID_AA64MMFR{0, 1, 2, 3}_EL1
  KVM: arm64: selftests: Import automatic system register definition
    generation from kernel
  KVM: arm64: selftests: Test for setting ID register from usersapce

Oliver Upton (2):
  KVM: arm64: Reject attempts to set invalid debug arch version
  KVM: arm64: Bump up the default KVM sanitised debug version to v8p8

 Documentation/virt/kvm/api.rst                |   29 +
 arch/arm64/include/asm/kvm_host.h             |    2 +
 arch/arm64/include/uapi/asm/kvm.h             |   26 +
 arch/arm64/kvm/arm.c                          |    7 +
 arch/arm64/kvm/sys_regs.c                     |  207 +-
 include/uapi/linux/kvm.h                      |    1 +
 tools/arch/arm64/include/.gitignore           |    1 +
 tools/arch/arm64/include/asm/gpr-num.h        |   26 +
 tools/arch/arm64/include/asm/sysreg.h         |  839 ++----
 tools/arch/arm64/tools/gen-sysreg.awk         |  336 +++
 tools/arch/arm64/tools/sysreg                 | 2497 +++++++++++++++++
 tools/testing/selftests/kvm/Makefile          |   15 +-
 .../selftests/kvm/aarch64/aarch32_id_regs.c   |    4 +-
 .../selftests/kvm/aarch64/debug-exceptions.c  |   12 +-
 .../selftests/kvm/aarch64/page_fault_test.c   |    6 +-
 .../selftests/kvm/aarch64/set_id_regs.c       |  448 +++
 .../selftests/kvm/lib/aarch64/processor.c     |    6 +-
 17 files changed, 3739 insertions(+), 723 deletions(-)
 create mode 100644 tools/arch/arm64/include/.gitignore
 create mode 100644 tools/arch/arm64/include/asm/gpr-num.h
 create mode 100755 tools/arch/arm64/tools/gen-sysreg.awk
 create mode 100644 tools/arch/arm64/tools/sysreg
 create mode 100644 tools/testing/selftests/kvm/aarch64/set_id_regs.c


base-commit: 706a741595047797872e669b3101429ab8d378ef
-- 
2.42.0.rc1.204.g551eb34607-goog

