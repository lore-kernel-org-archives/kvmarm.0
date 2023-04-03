Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 011097E
	for <kvmarm@lists.linux.dev>; Mon,  3 Apr 2023 00:37:26 +0000 (UTC)
Received: by mail-yb1-f202.google.com with SMTP id 8-20020a250508000000b00b7c653a0a4aso19446426ybf.23
        for <kvmarm@lists.linux.dev>; Sun, 02 Apr 2023 17:37:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680482246;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=7cbkKDYMk+VvT0sZcvXM38Hovglc7Ib8g99EWCrwY8c=;
        b=p3KcxgWW4f/5Zh38+7KQO1Ua2tlTD3GFa5IiommfGPumeywuZB56OGE2Sm3Gg8KtOs
         DVw+a6q3PbfhCGIEQXuk4/kJPHTfowjYfiBhjkwS+oRdkexXorj/RXOLxZrm1negFJS5
         EdIJVhXDbBL4qcFWsl6opQCMzf9c5NwrV81m7drR/EwA+pefSHG4EOaeZl3wrBwlXFgI
         ODu8X4C50h8/x3cbBIUHrnTLugQoUJWN+Qq6oTTYF4J2vM0EXdvaVyHEJGLtn8Jnn6zH
         uhuGuLFUlX9XUQNyarsZ0H7kpMXV3b+QXh+ce0U+PNz3+OJiT5g0Fv12vHnOHXbrmm7g
         H/zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680482246;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7cbkKDYMk+VvT0sZcvXM38Hovglc7Ib8g99EWCrwY8c=;
        b=3lHdnq8zpKolE6H3uaaXG0dqM/muMSu7spJSxW8lYWPk10rj/ZNqIU6Op7ihq3mDhE
         ketFYiXujpbEmMhmvZCRWw/YUI4IE7F93sHYImqCtA9R4K4FJ7Px4X4QzgZyvQpIK8TV
         iOC/lSrIRtkUqtmc6tutI+zD8d574eU5kRLzaLxiCdqTg3z7E5gdx7b9vZSN4Av/UUXC
         Ic+tM5o+qmdbOVVL7yCx3SGb+u/YgrfupBy8P6kUi3jkzXVZ2J6Z9fw+LQTbbbV0Icw2
         Jd0WqxezvTKQtWTg3iKF6cEpj4uBpk819tzgTBlvjn99iHA30E9JIIH7LU9GeFs+1AtI
         fjQQ==
X-Gm-Message-State: AAQBX9c23O/az+ilhLmd/I+gRb1bMjbjHF0QgdEqSjjsDT/SSldGQ3Df
	unAq40xL3feue6QxA2iVG7C/WjsTxdPwatDe7A==
X-Google-Smtp-Source: AKy350ad/EeyiNhWuRLhO4Zw2rF2u3v9HNXTPPROAH2x+Andj0LdaNnvp3Qch0+QUfKMPzbj0KuRy0LBjqwLON7Emg==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a05:6902:722:b0:a09:314f:a3ef with
 SMTP id l2-20020a056902072200b00a09314fa3efmr22360648ybt.12.1680482245950;
 Sun, 02 Apr 2023 17:37:25 -0700 (PDT)
Date: Mon,  3 Apr 2023 00:37:21 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230403003723.3199828-1-jingzhangos@google.com>
Subject: [PATCH v2 0/2] Enable writable for ID_AA64DFR0_EL1 and ID_DFR0_EL1
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

This patch series is based on a previous patch series which adds the
infrastructure to allow enabling writable from userspace for CPU ID register
easily. That patch series is at [1].

---

* v1 -> v2
  - Rebase on latest patch series [1] of enabling writable ID register.

[1] https://lore.kernel.org/all/20230402183735.3011540-1-jingzhangos@google.com
[v1] https://lore.kernel.org/all/20230326011950.405749-1-jingzhangos@google.com

---

Jing Zhang (2):
  KVM: arm64: Enable writable for ID_AA64DFR0_EL1
  KVM: arm64: Enable writable for ID_DFR0_EL1

 arch/arm64/kvm/id_regs.c | 79 +++++++++++++++++++++-------------------
 1 file changed, 42 insertions(+), 37 deletions(-)


base-commit: 921048c77a673221e27f4777a82661248465bad0
-- 
2.40.0.348.gf938b09366-goog

