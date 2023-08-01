Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 778E94DC64
	for <kvmarm@lists.linux.dev>; Tue,  1 Aug 2023 15:20:12 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-d052f49702dso6567331276.3
        for <kvmarm@lists.linux.dev>; Tue, 01 Aug 2023 08:20:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690903211; x=1691508011;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=9bccqF6ZETP6L8iCBAyZklNgWPnV99usCe2NbK3B7qU=;
        b=ni12vwrh4WCyCOzKlXXO+IyaWmPJIcRzAgoQsvsnGMs2wj7MJfruA43KZbkSsda12h
         GR1ZwNeGk0z7aWVT9P/e8VvlOTyYaGRKSJP8dDLq2m/jMoMLJalDZXftU2oUL7s98ws4
         BdSxyKpKgIsO1MnuRdqXsW2naV/FmLSbL+gtr7GIcmVZI1xHKg9L96WSEpBEEhax/pUh
         Q71yVF65mgCp9lMt5f+0hvoCCc2ilGayVZGBiBPofVEN+jYqcoSQ4mm2W+5dmEOC3qaX
         3yj0jm4eumJBnSio/SvZ2R86AZoJkSTVJNgLMYi7nWXKKDaP+vWMwDG3GoH+XdIrwBWw
         5m2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690903211; x=1691508011;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9bccqF6ZETP6L8iCBAyZklNgWPnV99usCe2NbK3B7qU=;
        b=NixwuyFShwSNNBvjUY0p8KtdKyHYe6gzqG0JMrt3ktLVjbjMz1VFDP1II713CxcJRn
         LMq9fFTfmBqH14ipWdKLP3wiYpsPFYO7D3NnemdEyYfgq27ebDDLMECVBOIg4ubcAbUr
         8nW3u5ieGQhRb7vaiYmfqMJU/oQSIUwP3U4iKTyVQuNSh2DFVtFpmQTFC8VVMn4iSpCQ
         RKTQ30qB0dAXqIfJZ/MQreBigtuIoSmxACtGPuBpRDe4qy41e81S5vT+bVJ7ygI50PVy
         +JV5wmiIbu4DQ0VPY51Yn5CkHdqobMHy56zCm2ctlHdyS0b1l50Khk6TBNOJfmI+FQC8
         14Kw==
X-Gm-Message-State: ABy/qLYM4po+BsIR9uJEL6yR94fCIEcx5sHSgSYUpdh7HFZQgDk0whuh
	Jzoerb3MFE19NamsYHiFxzO0OjEnF7OX8WQMhA==
X-Google-Smtp-Source: APBJJlE0Wc30ZjJoWXKkO+YDWTlvYE845ycMEBcUTKdlvCemAbv8pSUYmrcxJ54JJWoniJy4wnFQXWxFzyQzHR5teg==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a05:6902:70b:b0:c6c:6122:5b69 with
 SMTP id k11-20020a056902070b00b00c6c61225b69mr106675ybt.8.1690903211311; Tue,
 01 Aug 2023 08:20:11 -0700 (PDT)
Date: Tue,  1 Aug 2023 08:19:56 -0700
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.585.gd2178a4bd4-goog
Message-ID: <20230801152007.337272-1-jingzhangos@google.com>
Subject: [PATCH v7 00/10] Enable writable for idregs DFR0,PFR0, MMFR{0,1,2,3}
From: Jing Zhang <jingzhangos@google.com>
To: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	ARMLinux <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>
Cc: Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Fuad Tabba <tabba@google.com>, 
	Reiji Watanabe <reijiw@google.com>, Raghavendra Rao Ananta <rananta@google.com>, 
	Suraj Jitindar Singh <surajjs@amazon.com>, Cornelia Huck <cohuck@redhat.com>, 
	Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"

This patch series enable userspace writable for below idregs:
ID_AA64DFR0_EL1, ID_DFR0_EL1, ID_AA64PFR0_EL1, ID_AA64MMFR{0, 1, 2, 3}_EL1.
A vm ioctl is added to get feature ID register writable masks from userspace.
A selftest is added to verify that KVM handles the writings from user space
correctly.
A relevant patch from Oliver is picked from [3].
It is based on v6.5-rc4 which contains infrastructure for writable idregs.

---

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

---

Jing Zhang (8):
  KVM: arm64: Allow userspace to get the writable masks for feature ID
    registers
  KVM: arm64: Document KVM_ARM_GET_FEATURE_ID_WRITABLE_MASKS
  KVM: arm64: Use guest ID register values for the sake of emulation
  KVM: arm64: Enable writable for ID_AA64DFR0_EL1 and ID_DFR0_EL1
  KVM: arm64: Enable writable for ID_AA64PFR0_EL1
  KVM: arm64: Refactor helper Macros for idreg desc
  KVM: arm64: Enable writable for ID_AA64MMFR{0, 1, 2, 3}_EL1
  KVM: arm64: selftests: Test for setting ID register from usersapce

Oliver Upton (2):
  KVM: arm64: Reject attempts to set invalid debug arch version
  KVM: arm64: Bump up the default KVM sanitised debug version to v8p8

 Documentation/virt/kvm/api.rst                |  26 +++
 arch/arm64/include/asm/kvm_host.h             |   2 +
 arch/arm64/include/uapi/asm/kvm.h             |  25 +++
 arch/arm64/kvm/arm.c                          |   3 +
 arch/arm64/kvm/sys_regs.c                     | 191 ++++++++++++------
 include/uapi/linux/kvm.h                      |   2 +
 tools/arch/arm64/include/uapi/asm/kvm.h       |  25 +++
 tools/include/uapi/linux/kvm.h                |   2 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/aarch64/set_id_regs.c       | 191 ++++++++++++++++++
 10 files changed, 408 insertions(+), 60 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/aarch64/set_id_regs.c


base-commit: 5d0c230f1de8c7515b6567d9afba1f196fb4e2f4
-- 
2.41.0.585.gd2178a4bd4-goog

