Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21614253C3
	for <kvmarm@lists.linux.dev>; Mon, 17 Jul 2023 15:27:25 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-c6dd0e46a52so4068955276.2
        for <kvmarm@lists.linux.dev>; Mon, 17 Jul 2023 08:27:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689607645; x=1692199645;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=z+GoOgxgwqzG8TiJ0AXDkgFfXlL5tU7wLHV5OMoSBQw=;
        b=ADYRa1t6AtRHEcHbwJ6vPTV4QHdiGXiNBh2VvuC3GHyRATt9vkXRfOf9C1xqttp9k/
         B7wG81ICFtphg1VJqQ4BOrXJtT+ufIiCu3GFlIIs2RG4Aa8Hu1aM2KitlSnm+dN13gO4
         ZuaQVX1OHoc3o+hx3YfYg6ledLUZQumssa91UJia1zw5LhoPW/lDGcCsGmHl4gs1OrL6
         t0kqxpPh+LPkSmmesDSw/8G97Y2BUlYBAtIdD8WRcxUTdwZ6ol/rYRAJHal/lnmE08l2
         91v4s3ZBNfoI2PBp0Mx97QVRH8+tUNFdoZKhH+liRDwHoCGjEYb1JL8uRXaydFBxBipb
         NU2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689607645; x=1692199645;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=z+GoOgxgwqzG8TiJ0AXDkgFfXlL5tU7wLHV5OMoSBQw=;
        b=awG32TfYPNq+O25l/bcak1SXOAFKron/zLO2rl3dwcnMe5ofs8/dVNtacABFCRbgLr
         Z6btO3OxNuswqvwfXrHL9AJaBYXRwQMmJfHobqKCl18TI7SKdnBVk2R1HNZp/gJTnjDM
         zQnQihRD70gMN6eO2JtlBxhMIMGqsFVRn5FVOn68qL3XeIHalcSNPZ2Xz54TR6Y+aQqS
         JWOnlzpFPhe4M2XQH6t2qpBaF1dcUvc6Xzi5Fdyh+cgmyDP652mNR8YsDxhTZMTi3gdK
         0hfqI29IED5laSAKRdlGD4mVZlNGx6CauWumhLyvlF3Q/t7RYD868UmCCslDWMUUBF0B
         tXcQ==
X-Gm-Message-State: ABy/qLbl77Psp8hcl1bZK3+mnPUcXCTuVny4r1d0R1samcuYBajIMxg3
	tFx+oly6X99pkPTmyJrj3Urr5EvU3RpVFZpkAA==
X-Google-Smtp-Source: APBJJlGi+t+Jvz5YnzmYs2pb+P74IDdQheGqP83Hl+qUs/2Tdm5fbiUccEVezqIwu/5WgDEpXDFGz/Yty21s9i3pIQ==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a25:40d6:0:b0:ca1:179e:5d7d with SMTP
 id n205-20020a2540d6000000b00ca1179e5d7dmr120332yba.3.1689607644948; Mon, 17
 Jul 2023 08:27:24 -0700 (PDT)
Date: Mon, 17 Jul 2023 15:27:17 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.255.g8b1d071c50-goog
Message-ID: <20230717152722.1837864-1-jingzhangos@google.com>
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

Jing Zhang (4):
  KVM: arm64: Use guest ID register values for the sake of emulation
  KVM: arm64: Enable writable for ID_AA64PFR0_EL1
  KVM: arm64: Enable writable for ID_AA64MMFR{0, 1, 2, 3}_EL1
  KVM: arm64: selftests: Test for setting ID register from usersapce

Oliver Upton (1):
  KVM: arm64: Reject attempts to set invalid debug arch version

 arch/arm64/kvm/sys_regs.c                     |  80 +++++++--
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/aarch64/set_id_regs.c       | 163 ++++++++++++++++++
 3 files changed, 230 insertions(+), 14 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/aarch64/set_id_regs.c


base-commit: 06c2afb862f9da8dc5efa4b6076a0e48c3fbaaa5
-- 
2.41.0.255.g8b1d071c50-goog

