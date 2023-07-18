Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0784BC8CD
	for <kvmarm@lists.linux.dev>; Tue, 18 Jul 2023 16:45:27 +0000 (UTC)
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-577323ba3d5so102117907b3.0
        for <kvmarm@lists.linux.dev>; Tue, 18 Jul 2023 09:45:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689698727; x=1692290727;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=6AIDMbL3hEpqRvQeU0o8z9v91gj2Rs+jacVKOsuLanM=;
        b=GwJyCXzwR8CEZmqyx6/IbWlPjPDJ1FxZpeRJ3wqbqbOG/gJxyrN8HyggeYgPZ+Rv/m
         O3+vWONnwCm9msB1wWpFjzvdhvvWrFyfdsnmkcKymePAWa2+lVtm7aYQpith7CDZ72+n
         cBC4tXR59cAoilvguYVbzQ2QIR9KqbrJjMP19RBlLOmLM0KRzACHF2Uc/9r7gDqBvOZo
         lVVGgjsKNEVqh6pHHqWlwBxSfpU6Ro9ZuHOVCDyb9gQeJjSejHvMvkrrzOdOQbELcIoG
         kYhOwIjV+dtZQUEXh7a5HQreKIu+SIj8WH7HH9+4Zit/4rmOicw/wBB8WQ08vPEu5F+/
         mfwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689698727; x=1692290727;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6AIDMbL3hEpqRvQeU0o8z9v91gj2Rs+jacVKOsuLanM=;
        b=XNp2zh4vgawpkasiXh1ap1ieNRBWmPk8J6/17y28euxOxAQRQ4T5OH8Qa1AnxMCZlF
         jQ87IlVfHp10vXPyy7RyhQcEwfNK4qzKAUvIXOPpcVhebWtytz314a/WNO6tKQYYFklL
         co2AzfBSxIr0fVxejdf6o/TYel6c3i6FFTynye7I4HB/oUcBvjHJNA2MI/oroD5Z9HQv
         ii6ngDhUqp+0/72ujn1bzC/aypzM3FYzkcDLD2iNPxS47kp/6/BAq9xJ7O5MvR1vFh/L
         KyBWARuNYcREeT5OafScrWb7X1/UXwdA4MP7DKING/VES3ZkISQpGwiJcLwOTE0r/FXe
         n5Tg==
X-Gm-Message-State: ABy/qLZiaKqFdMEkMPHaDdJ7kQX9zauHpSPGHcQWFJFKYPhjtwwAqC9s
	SPtnRftSx9XMTaQAYry13WY9mwaQ73N43FYzLg==
X-Google-Smtp-Source: APBJJlEE7YSo1kc58LaaioaXSeeq2+jodtyrKh2yayZZUrizGXuZuzM/qR6D7wkKJGnhlEDKp80fvQgvXoMdys1aaQ==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a05:690c:3003:b0:577:6462:24c3 with
 SMTP id ey3-20020a05690c300300b00577646224c3mr216939ywb.4.1689698726826; Tue,
 18 Jul 2023 09:45:26 -0700 (PDT)
Date: Tue, 18 Jul 2023 16:45:16 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.255.g8b1d071c50-goog
Message-ID: <20230718164522.3498236-1-jingzhangos@google.com>
Subject: [PATCH v6 0/6] Enable writable for idregs DFR0,PFR0, MMFR{0,1,2, 3}
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

It is based on v6.5-rc1 which contains infrastructure for writable idregs.

A selftest is added to verify that KVM handles the writings from user space
correctly.

A relevant patch from Oliver is picked from [3].

---

* v5 -> v6
  - Override the type of field AA64DFR0_EL1_DebugVer to be FTR_LOWER_SAFE by the
    discussion of Oliver and Suraj.

* v4 -> v5
  - Rebase on v6.4-rc1 which contains infrastructure for writable idregs.
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

---

Jing Zhang (5):
  KVM: arm64: Use guest ID register values for the sake of emulation
  KVM: arm64: Enable writable for ID_AA64DFR0_EL1 and ID_DFR0_EL1
  KVM: arm64: Enable writable for ID_AA64PFR0_EL1
  KVM: arm64: Enable writable for ID_AA64MMFR{0, 1, 2, 3}_EL1
  KVM: arm64: selftests: Test for setting ID register from usersapce

Oliver Upton (1):
  KVM: arm64: Reject attempts to set invalid debug arch version

 arch/arm64/kvm/sys_regs.c                     |  84 +++++++--
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/aarch64/set_id_regs.c       | 163 ++++++++++++++++++
 3 files changed, 232 insertions(+), 16 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/aarch64/set_id_regs.c


base-commit: 06c2afb862f9da8dc5efa4b6076a0e48c3fbaaa5
-- 
2.41.0.255.g8b1d071c50-goog

