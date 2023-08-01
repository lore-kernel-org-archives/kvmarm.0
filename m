Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B938C1ADC7
	for <kvmarm@lists.linux.dev>; Tue,  1 Aug 2023 15:20:21 +0000 (UTC)
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-267f00f6876so3693364a91.3
        for <kvmarm@lists.linux.dev>; Tue, 01 Aug 2023 08:20:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690903221; x=1691508021;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5CnHym/u4lCc+2ZRHUcKoPxTfNqi1z6j2L8Et7c5ypg=;
        b=ITQmxLoYmO8h9hfwALbwL2rbBiAv0WLTDqVVXqQ68Kx3CrRI2YuJDvikKqxD98orlv
         asBoUJOWDE/bC378g+AcV7451TxIqgjUWQoongTCjB6tBtusYCGinPnTxb8547akp1iy
         7xfjc5EQNTUSFk/UM3dVuwC9GH3YS8wLhgVdHaJ1rj+9Z0dOK9ZsPNHXPZkaJ+wIm1zI
         pflTA6JfCQ5Cn1EKiIj4ULclDADFcWUGls/+h1FWcEC574Su2y04w9J8m81XMUW0eBGx
         whjUwbBD1KqWHEUQm8NzZIKN4o6U5CQYuyrnQnuU87g9I+ZajU9x2fLC8hsIjBTegaEa
         FOvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690903221; x=1691508021;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5CnHym/u4lCc+2ZRHUcKoPxTfNqi1z6j2L8Et7c5ypg=;
        b=ZP2T5PU43SD5GzEVENO8c5Ny8TQ5WHYGS5DTNMQiK+qkm/Jg47AhDShPJqP2M0C3Yf
         OGzxGE29cwLph+3t1QQlBcq0fx8qntjC9DHKrggQVrdIKHy4pzREj/FXT2ter95Sh+Kq
         GtE/RHT2KNsys5VecWohcwtGnTHocC5tWe/lWtzzHqe7jTebfIqC7WVR9kUETHhowj2W
         uRv6u8sjdBY4KsSy+gQF8Yqsd2434eDhqtTCn4guJIApDh+Nhy74K4Yfrnj31WQF0/T5
         AHQhcbzRY9Rbq5ZRA+Y/c5zoQ85iRQp7zeFGRzJkmOLhD3WZv8LtOORqfVlJf6HaNEMf
         f6vw==
X-Gm-Message-State: ABy/qLaA+S1d8eRS8pL9CsqHkjlDrnvetgJ9y696yKcjit8maLMpI561
	4DBbYWQZvM1KlhSIP7ZZQ9oJZk4y69m9kdmNkg==
X-Google-Smtp-Source: APBJJlEnPwgkTgMCnI54ZmtyPE3ZmqrSTb8N+c2ZmA4uLAPIPk28sPLKkYPRVyGSa7M9V2JcblPYsgrU4Lh3MjT/iQ==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a17:902:da83:b0:1b3:c62d:71b5 with
 SMTP id j3-20020a170902da8300b001b3c62d71b5mr60476plx.0.1690903221091; Tue,
 01 Aug 2023 08:20:21 -0700 (PDT)
Date: Tue,  1 Aug 2023 08:20:01 -0700
In-Reply-To: <20230801152007.337272-1-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230801152007.337272-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.41.0.585.gd2178a4bd4-goog
Message-ID: <20230801152007.337272-6-jingzhangos@google.com>
Subject: [PATCH v7 05/10] KVM: arm64: Enable writable for ID_AA64DFR0_EL1 and ID_DFR0_EL1
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

All valid fields in ID_AA64DFR0_EL1 and ID_DFR0_EL1 are writable
from usrespace with this change.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/kvm/sys_regs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 7fcbc317f100..2183cd3af472 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2006,7 +2006,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	  .set_user = set_id_dfr0_el1,
 	  .visibility = aa32_id_visibility,
 	  .reset = read_sanitised_id_dfr0_el1,
-	  .val = ID_DFR0_EL1_PerfMon_MASK, },
+	  .val = GENMASK(63, 0), },
 	ID_HIDDEN(ID_AFR0_EL1),
 	AA32_ID_SANITISED(ID_MMFR0_EL1),
 	AA32_ID_SANITISED(ID_MMFR1_EL1),
@@ -2055,7 +2055,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	  .get_user = get_id_reg,
 	  .set_user = set_id_aa64dfr0_el1,
 	  .reset = read_sanitised_id_aa64dfr0_el1,
-	  .val = ID_AA64DFR0_EL1_PMUVer_MASK, },
+	  .val = GENMASK(63, 0), },
 	ID_SANITISED(ID_AA64DFR1_EL1),
 	ID_UNALLOCATED(5,2),
 	ID_UNALLOCATED(5,3),
-- 
2.41.0.585.gd2178a4bd4-goog

