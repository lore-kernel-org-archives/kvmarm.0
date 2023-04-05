Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E891F7470
	for <kvmarm@lists.linux.dev>; Wed,  5 Apr 2023 17:21:49 +0000 (UTC)
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-545dd1a1e31so312517367b3.22
        for <kvmarm@lists.linux.dev>; Wed, 05 Apr 2023 10:21:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680715309;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=D3r10cm7fAHZK5D31KGbqV3r9nbkx+Y20r9KdjeSnd0=;
        b=jo7pPq5qM5gLK0AVnmUwM02HwmbJ7YlsjF4FrMFjqynY3C1W0CeRsJRPj+VXoMZk7K
         H1tiodbzp6ix7sqbBsp61kgk38NmwbO07JNngeJcAYpvtun0UJ6IFp9MQASMzK9p+i3Y
         MNGLPpqgxUQroCivjZrOsMij2MbnJeBZ1XaIIrpxQ/0/iOVghrAD0R4f9Cmna7Y4TytA
         HOc5sC5gZ47CMrIIzxdYFLt8mThsVazQFkf5fDoIUx4KkedqlNY4MDKfo7hYk1iS9ckx
         I2CJ0EyLXoj94dEzk63MN84NX+SegVGLZXQlyH/aoHm05+plfepLCccEf5ct/9H6eQZe
         lVVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680715309;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=D3r10cm7fAHZK5D31KGbqV3r9nbkx+Y20r9KdjeSnd0=;
        b=S0+wYiyz0js7bH5GB2jDUIwlzrKMGyUIr9l1MYYjcOd/Ntx/f8ZHFXHEFEqbmat82P
         95wPvbgE/FSBHqH9BDJNOErj8RwVHQdoStdUm9chYm7GXqmcFDo6U07Vmvm5c1YD00H4
         yKW1PUw9ScMTlgwTIcQX+kNvqAOETTJsFz/woClgYpUNGBmoGbd7C9jMcnwfxmxgyYY/
         CWogvlyJ2H9yUUNoe6vgEoe+ycQ2+Kbdin/58xWm9VPLI3giuctsuf2bEXjXRSs/v6VW
         Pes/Kpc8RWEiX8FJDqZ3vgp1/PpnJKCgWzq0krvGHkx8oOeefZfZkK9DfOeVNqAslrvr
         breQ==
X-Gm-Message-State: AAQBX9eABbe+CbhEUfuE29AQ82LhAoMG6/V8ey41+mD/i4n9BMN6iDYG
	1kZ31PQ02VdQxmqcVylDgriTTe65jPOFlWVerA==
X-Google-Smtp-Source: AKy350ZsmL1wjm9wtYxtsRzrT48NB3/lrdHktGDRLEsJ5qmBrnGhsSqr30Yge03JnFunnf6+baS9bp4bGcu3LsycFA==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a25:d412:0:b0:b8b:e931:7762 with SMTP
 id m18-20020a25d412000000b00b8be9317762mr767239ybf.13.1680715308829; Wed, 05
 Apr 2023 10:21:48 -0700 (PDT)
Date: Wed,  5 Apr 2023 17:21:42 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230405172146.297208-1-jingzhangos@google.com>
Subject: [PATCH v3 0/4] Enable writable for idregs DFR0,PFR0, MMFR{0,1,2}
From: Jing Zhang <jingzhangos@google.com>
To: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	ARMLinux <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@google.com>
Cc: Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Fuad Tabba <tabba@google.com>, 
	Reiji Watanabe <reijiw@google.com>, Raghavendra Rao Ananta <rananta@google.com>, 
	Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"

This patch series enable userspace writable for below idregs:
ID_AA64DFR0_EL1, ID_DFR0_EL1, ID_AA64PFR0_EL1, ID_AA64MMFR{0, 1, 2}_EL1.

It is based on below series which add infrastructure for writable idregs:
https://lore.kernel.org/all/20230404035344.4043856-1-jingzhangos@google.com

---

* v2 -> v3
  - Rebase on v6 of writable idregs series.
  - Enable writable for ID_AA64PFR0_EL1 and ID_AA64MMFR{0, 1, 2}_EL1.

* v1 -> v2
  - Rebase on latest patch series [1] of enabling writable ID register.

[1] https://lore.kernel.org/all/20230402183735.3011540-1-jingzhangos@google.com
[v1] https://lore.kernel.org/all/20230326011950.405749-1-jingzhangos@google.com
[v2] https://lore.kernel.org/all/20230403003723.3199828-1-jingzhangos@google.com

---

Jing Zhang (4):
  KVM: arm64: Enable writable for ID_AA64DFR0_EL1
  KVM: arm64: Enable writable for ID_DFR0_EL1
  KVM: arm64: Enable writable for ID_AA64PFR0_EL1
  KVM: arm64: Enable writable for ID_AA64MMFR{0, 1, 2}_EL1

 arch/arm64/kvm/id_regs.c | 68 ++++++++++++++++++++++++++++++++++------
 1 file changed, 58 insertions(+), 10 deletions(-)


base-commit: 8ee379b1b7b23b0cffdfc988cbe94108188f68b5
-- 
2.40.0.348.gf938b09366-goog

