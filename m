Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40C15408F8
	for <kvmarm@lists.linux.dev>; Sat, 10 Jun 2023 06:15:41 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-bb2202e0108so3155095276.1
        for <kvmarm@lists.linux.dev>; Fri, 09 Jun 2023 23:15:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686377740; x=1688969740;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=+DLblTLkyid4xi77mptvky8xPiYLH98cRQBJONV33+M=;
        b=5trV4LUBPAk2oZ2MNDsq0hNSHwU9CDjeR+EXZeul7HOMAixCsZXeusHHWFB76Pw3qi
         hYeZDf/LgRGUK5pCQFEUzwhfsYUiKm0fEQh6LGGGtZi+chULiJc8ZjICCjm1JHc5aCiB
         YMYKQgtHwPSm60jtVtIIFU5sfyE+CFz6aun2E0Rb8ALC0FqD8pDTsCcxeU9qXtBOHhi1
         cDuWxl2keBkONTHkDOrDQ3/yPOloujM8T09AbD2Nq9tAGTqDnd1kHrseHSRlCr7xZVVx
         7thnf51PBcHtBD3bcjkK/uzXxDPEWXT92OPqp4DMVLC4nCEpq8oKouP4gjtq4TFUpIOI
         w09A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686377740; x=1688969740;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+DLblTLkyid4xi77mptvky8xPiYLH98cRQBJONV33+M=;
        b=daWV6NdLXs68wDEs20bNX8k/YScbTmzqQfSMD+hTmDw+UnsNFR/8VZErzRQXRp+zc1
         IZIRpbx3kzZw6Nu+YB+E+yXsiCXrzg2kpQpzwMMpwMf+SObZDZ3rsyW2yb6VdJjrZvu5
         6m4hxVcM8J4hg1WSG9Uk4+kzFMxJ3Nx7Qo7MljF6R0nwiCqZDFKnfUjawdKQzN9QhYv7
         DI8Fa8l3Y8XjVPshjMVQcrhsztcUnsSt00A9q5snqL1jnwfFSQcnniS3cP/64A35eeBI
         +FNhDXPvFMpw3RLSBjdjHf2u1C8GecUjYwtLiOqhw1XWnZJxWI+BiktpHM5Z6GwbhlPC
         gy6Q==
X-Gm-Message-State: AC+VfDyuK5bfwaamHdu1ZX7bipwk/Muluz8hR+j1jExwO6BgRc2d2lEc
	ZSfghcdU9LKGFemY9WUNoCQgkM9xMcE=
X-Google-Smtp-Source: ACHHUZ4WAaaRBANzh1YtIO3Ah8WyAfBy7JqoJgzUoXbqmI3wb/BNso2nkXQfZadKKhNUquplRIS9fKP8yrQ=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a05:6902:1085:b0:ba8:918a:ceec with SMTP id
 v5-20020a056902108500b00ba8918aceecmr971640ybu.4.1686377740149; Fri, 09 Jun
 2023 23:15:40 -0700 (PDT)
Date: Fri,  9 Jun 2023 23:15:18 -0700
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
Message-ID: <20230610061520.3026530-1-reijiw@google.com>
Subject: [PATCH 0/2] KVM: arm64: PMU: Disallow vPMU on non-uniform PMUVer systems
From: Reiji Watanabe <reijiw@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Jing Zhang <jingzhangos@google.com>, Raghavendra Rao Anata <rananta@google.com>, 
	Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"

On systems where the PMUVer is not uniform across all PEs,
KVM currently does not advertise PMUv3 to the guests,
even if userspace successfully runs KVM_ARM_VCPU_INIT with
KVM_ARM_VCPU_PMU_V3.

In such systems, KVM should either disallow userspace from
configuring vPMU, or advertise PMUv3 to the guest.
This series addresses this inconsistent behavior by implementing
the former, as such systems would be extremely uncommon and
unlikely to even use KVM (according to Marc [1]).

The series is based on v6.4-rc5.

[1] https://lore.kernel.org/all/874jnqp73o.wl-maz@kernel.org/

Reiji Watanabe (2):
  KVM: arm64: PMU: Introduce pmu_v3_is_supported() helper
  KVM: arm64: PMU: Disallow vPMU on non-uniform PMUVer systems

 arch/arm64/kvm/arm.c      |  1 +
 arch/arm64/kvm/pmu-emul.c |  6 +-----
 arch/arm64/kvm/sys_regs.c |  2 +-
 include/kvm/arm_pmu.h     | 18 ++++++++++++++++++
 4 files changed, 21 insertions(+), 6 deletions(-)


base-commit: 9561de3a55bed6bdd44a12820ba81ec416e705a7
-- 
2.41.0.162.gfafddb0af9-goog

