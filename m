Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 841C9110B
	for <kvmarm@lists.linux.dev>; Thu,  2 Mar 2023 05:50:43 +0000 (UTC)
Received: by mail-yb1-f202.google.com with SMTP id a137-20020a25ca8f000000b0091b90b20cd9so2977322ybg.6
        for <kvmarm@lists.linux.dev>; Wed, 01 Mar 2023 21:50:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=K3JIxiC0M77Pk7ywc3uQ/jzPAxcPYJAhKiYM9zf/wCk=;
        b=jtb5+/An/yu3T9m7m/98dfEoSfuJeWhdUaRVOkoGjRKDvvstUFT30gKnyCyPqji8bu
         r1SKTDK+uCcJwQdfJWLgq+f1XJfKKzkkCEw5xIUD2aYGbcdXPNRPscejOngrX+2zjXw2
         EOyUIU2i36AqfQpsykEPTMZUOTBER32Skq7/LQ027yvSPNTax/FK6RBq4yZI/F5NAgJH
         Or3F/CKKOQQxblmFknMTwfV/8DUie08mPTvPu/whwZxDHKj9urdpJcesJhwgiqxarYD7
         G1CmC6TabyRzkso/6vItQ6+qDNwWmLUYoEV8MwmOXzIjKSMTqbBH7FgtiwresKIPm9Xy
         Oq4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=K3JIxiC0M77Pk7ywc3uQ/jzPAxcPYJAhKiYM9zf/wCk=;
        b=h4XodrT29LCDp2r2V8bnhYtTGWPW3540nEfziOBlbKrP5EsIlvfLIitoX3fQvz+Z8L
         S89LKAxsd2gphukuPorZvIkq9VuhPj4IlEmSiKlv3z3ldLtc2K53JtNDPgsLTqgYlmpK
         9GDsA3XLKno8oiH75qZz3axYU7/6hqAYYKH0hy0QwdKB+0wYRqZajxKFyTRrom6KzGSy
         dbqC+ZrvSPHhVp5WHgfrkURE9h7h7vg3+jxEadPkHHkRGrU8+RXICPyIsSl6QiGJDCq0
         dh3w7dE7eP6DXBRXSto1wuFgCRXUNLC2phy8cDbvtbrQRTCleZzYemhr3V9mtV3GSZEC
         tuaA==
X-Gm-Message-State: AO0yUKXV9dIrmJiCqC7HNU3de0W8A5iZfW6Xl2mJdtyiO1ilq1lgY9eG
	oGOzqyws0EmPUP701PmlMX3JFV7buP4=
X-Google-Smtp-Source: AK7set9c8XVwEZFWDGh+9kXnrdAHO4gC875qJEsTWGDCD3+FYSzJT6DG3+/6LXrhQag+NTWGMPw4lFdcm8Y=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a5b:211:0:b0:91d:98cd:bfe4 with SMTP id
 z17-20020a5b0211000000b0091d98cdbfe4mr4832176ybl.10.1677736242502; Wed, 01
 Mar 2023 21:50:42 -0800 (PST)
Date: Wed,  1 Mar 2023 21:50:31 -0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.2.722.g9855ee24e9-goog
Message-ID: <20230302055033.3081456-1-reijiw@google.com>
Subject: [PATCH 0/2] KVM: arm64: PMU: Preserve vPMC registers properly on migration
From: Reiji Watanabe <reijiw@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Ricardo Koller <ricarkol@google.com>, 
	Jing Zhang <jingzhangos@google.com>, Raghavendra Rao Anata <rananta@google.com>, 
	Will Deacon <will@kernel.org>, Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"

The series fixes two problems in preserving vPMU counter (vPMC)
registers (PMCCNTR_EL0/PMEVCNTR<n>_EL0) during migration.

One of the problems is that KVM may not return the current values
of the vPMC registers for KVM_GET_ONE_REG.

The other one might cause KVM to reset the vPMC registers on the
first KVM_RUN on the destination. This is because userspace might
save PMCR_EL0 with PMCR_EL0.{C,P} bits set on the source, and
restore it on the destination.

See patch-1 and patch-2 for details on these issues respectively.

The series is based on v6.2.

Reiji Watanabe (2):
  KVM: arm64: PMU: Fix GET_ONE_REG for vPMC regs to return the current
    value
  KVM: arm64: PMU: Don't save PMCR_EL0.{C,P} for the vCPU

 arch/arm64/kvm/pmu-emul.c |  4 +++-
 arch/arm64/kvm/sys_regs.c | 21 +++++++++++++++++++--
 2 files changed, 22 insertions(+), 3 deletions(-)


base-commit: c9c3395d5e3dcc6daee66c6908354d47bf98cb0c
-- 
2.39.2.722.g9855ee24e9-goog

