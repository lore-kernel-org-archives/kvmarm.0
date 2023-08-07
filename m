Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54FDC11C8F
	for <kvmarm@lists.linux.dev>; Mon,  7 Aug 2023 16:22:24 +0000 (UTC)
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-55c04f5827eso3127228a12.1
        for <kvmarm@lists.linux.dev>; Mon, 07 Aug 2023 09:22:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691425343; x=1692030143;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xxutBbfGAJNlYXBOxeWHmgbZQPEyXZB54Uqq0kRAHGs=;
        b=eEeluUifPz1M9tVSAEOgeKTv2NRp0MPldGadBVLWH/1lhBXDgQmYbzuZJHMpExY2Ko
         8zql+LqyGqEE6iXv4QmtPmy13ZM278jyBqh8jaITa82qbrl1pDuwXovMpYjPyAaED6xg
         XswWphpTe0Y153oTV+cUmV1aFqExLDudWao2L4EOlgJ+eF0h4XooUr9fZXsoTL3EqM72
         V2zY1K8l/FSq/H1ct34ti6unDBX0pRqM1gVtZvaofWJ5mONF0a3c2idyA+c91/P5y3b5
         mhN6vF2ZmhTBaag9UtqC3WRZ0g77PsGOh6hNVvEbGA7UkbOyHMw02W/Ow4vV2eRxJoCp
         nphw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691425343; x=1692030143;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xxutBbfGAJNlYXBOxeWHmgbZQPEyXZB54Uqq0kRAHGs=;
        b=SLzdSCEN2kmUzHcX6xf4lTn1hEsNbBGDXo7+mWws5aDJqI3weyP1AK8p8FrLPUaMXi
         UGiCdJ7LVOldhjJJHhuZGDoMIxGEN4+ohKXKLZbdtFcOE0izKzn0kIriDIF1ybQTHXmu
         lzjeEgM6xg4nTh79nQyCpX1K6yCvvMjDMONNsRxNKATIfSZ4HlGNnEfrJIFlZi8kxeeu
         8bIB69w3hxdj4gNwbgKiAKF+NXXOUKbl9W/LzI6njlJ63yVh/QNm6gIvBqz4QK8w0rep
         7zJUs/uzhfTVebLTr+zB/QyhIZbVgZUGEb48odADH5b3175YD4krpfkCGrHmDHJyFKX6
         u1yA==
X-Gm-Message-State: AOJu0YwF0/GNSozlFAQKNT7AFfk/8I5889dsL5FE+CoGvQ8yYD+Vua9R
	OYU4T8GNlQXwh7UfqXU782GHxV5a92X7up9yHg==
X-Google-Smtp-Source: AGHT+IG89VBNktN7XA1gkTE5xVbgGz8iasHHKTacDRwZZyNk+t4M2tS4x4zckgIQ/EwT9AkYrTdbks6AEBAQCcWudg==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a17:903:22c2:b0:1b9:e338:a8b7 with
 SMTP id y2-20020a17090322c200b001b9e338a8b7mr41785plg.5.1691425343669; Mon,
 07 Aug 2023 09:22:23 -0700 (PDT)
Date: Mon,  7 Aug 2023 09:22:03 -0700
In-Reply-To: <20230807162210.2528230-1-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230807162210.2528230-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.41.0.585.gd2178a4bd4-goog
Message-ID: <20230807162210.2528230-6-jingzhangos@google.com>
Subject: [PATCH v8 05/11] KVM: arm64: Enable writable for ID_AA64DFR0_EL1 and ID_DFR0_EL1
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
index afade7186675..5f6c2be12e44 100644
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

