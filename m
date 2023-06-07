Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1647C182AE
	for <kvmarm@lists.linux.dev>; Wed,  7 Jun 2023 19:45:57 +0000 (UTC)
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-65a971d7337so711509b3a.1
        for <kvmarm@lists.linux.dev>; Wed, 07 Jun 2023 12:45:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686167157; x=1688759157;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=aPgsero69xFwJck0QKcCtV9CkkDCHybrauN68WHLy4A=;
        b=0A1Gsrces1skjswFsF50lVK2JnRk4tWOxR3MV+vcU6MJ2VWsqnwLTGQTi5DUD6N4Tm
         AJqBBH8FlWGmBNje8EQDCdql8N3cksHKiTRBxIhvaymhDkRV8zNLBNn/G+nYmvsbgjnZ
         STTQwiqz1grZqjk7XeQRIoJ9XdKxKpuVTPPtNCwpCQWABAytR+77MQ0Vg5vGq06osEQh
         yqPq+QKph9ugRXDTZshpK9pQZscYfiSAPtLYluUenFItsEid0QoRfBEDAUKbjR0ORjGX
         gxnSOzJ1nxT82tsjGK4RviJ/p8RCpLY8HZyW3jKypnYe4mWIITRS9pgrQfKMurJns8qv
         b74w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686167157; x=1688759157;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aPgsero69xFwJck0QKcCtV9CkkDCHybrauN68WHLy4A=;
        b=F2byWnaEiMpQaNUdcf95DbcZN9Dvs70YfVY9EXEwPDu6dUdI8RYgqYDiW9rv2bkZZp
         PAQUDg7kuS5DAr2SCuzZoD1RppCHXX4gIkCuya/x6LQUUfYZ9XqJlar4s/yrGgBp3hJl
         Vbs9CXuVvdb9oP1aJ0F5ruIzK61kZ1LxzfkcqPu1okiIuZh8rhFkd9BgWjKFTXrXqtU9
         YWKgJOjROCsadcthFEmZyZA/tQzD+zNDyQ9DlkFyXja1Jopu5TbNTcgDSp8oygig1qAh
         LVyC0RcRhvWki996qh1Dbgc7Hc2N46FI6g7GzkvJT+bRUH+Lc2gQqyjXA3YB71BHEJRK
         DIyQ==
X-Gm-Message-State: AC+VfDwZbVY/jAVAilc/NRO7XUjwapobBnEY8/P6VyU6gYGBJKVwV26P
	tffz59L6niFt5dpoUfWuNB7CXJ9YXiaPXSrPug==
X-Google-Smtp-Source: ACHHUZ6Jdfp4KijOKoJc8iKkNnAT7j0Cg3mZuagkHodcduTq2g3SvL98qNbl8Vxb4j+cbgqMwwZpEe1BEtzg62RjVg==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a05:6a00:2e0e:b0:64f:5406:d5a2 with
 SMTP id fc14-20020a056a002e0e00b0064f5406d5a2mr25720pfb.0.1686167157264; Wed,
 07 Jun 2023 12:45:57 -0700 (PDT)
Date: Wed,  7 Jun 2023 19:45:50 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230607194554.87359-1-jingzhangos@google.com>
Subject: [PATCH v4 0/4] Enable writable for idregs DFR0,PFR0, MMFR{0,1,2}
From: Jing Zhang <jingzhangos@google.com>
To: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	ARMLinux <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@google.com>
Cc: Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Fuad Tabba <tabba@google.com>, 
	Reiji Watanabe <reijiw@google.com>, Raghavendra Rao Ananta <rananta@google.com>, 
	Suraj Jitindar Singh <surajjs@amazon.com>, Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"


This patch series enable userspace writable for below idregs:
ID_AA64DFR0_EL1, ID_DFR0_EL1, ID_AA64PFR0_EL1, ID_AA64MMFR{0, 1, 2}_EL1.

It is based on below series [2] which add infrastructure for writable idregs.

---

* v3 -> v4
  - Rebase on v11 of writable idregs series at [2].

* v2 -> v3
  - Rebase on v6 of writable idregs series.
  - Enable writable for ID_AA64PFR0_EL1 and ID_AA64MMFR{0, 1, 2}_EL1.

* v1 -> v2
  - Rebase on latest patch series [1] of enabling writable ID register.

[1] https://lore.kernel.org/all/20230402183735.3011540-1-jingzhangos@google.com
[2] https://lore.kernel.org/all/20230602005118.2899664-1-jingzhangos@google.com

[v1] https://lore.kernel.org/all/20230326011950.405749-1-jingzhangos@google.com
[v2] https://lore.kernel.org/all/20230403003723.3199828-1-jingzhangos@google.com
[v3] https://lore.kernel.org/all/20230405172146.297208-1-jingzhangos@google.com

---

Jing Zhang (4):
  KVM: arm64: Enable writable for ID_AA64DFR0_EL1
  KVM: arm64: Enable writable for ID_DFR0_EL1
  KVM: arm64: Enable writable for ID_AA64PFR0_EL1
  KVM: arm64: Enable writable for ID_AA64MMFR{0, 1, 2}_EL1

 arch/arm64/kvm/sys_regs.c | 78 +++++++++++++++++++++++++++++++++------
 1 file changed, 67 insertions(+), 11 deletions(-)


base-commit: 01b532e41af091a48287dd45f763db4b887bcdfc
-- 
2.41.0.rc0.172.g3f132b7071-goog

