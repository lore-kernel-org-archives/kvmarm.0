Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 486104DC7C
	for <kvmarm@lists.linux.dev>; Tue,  1 Aug 2023 15:20:26 +0000 (UTC)
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-55c964d031aso5634985a12.1
        for <kvmarm@lists.linux.dev>; Tue, 01 Aug 2023 08:20:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690903225; x=1691508025;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=f1iJwrUwzrr4LImgyPThesTLhstaE6VPmgVvDL2bXp0=;
        b=5gd7OaRBrRYmMMIOxe18B8NXMNA1PK1Vvk4zSEoSg9JQcQOfWjTweZXq40eI9c+L1N
         Pjiy2HD7ipih05DuZXxzwty4Zw4J8+YSCFDSyWhYQhA/eRCTC3NQm/LNPt3/lxoIqT/H
         yEdDVYoCx3+f6eh5fJ3LuJn0o/Km7f1yoe+NQ9khAuuY1oAei/RTPdKYNFD0OwONNvvb
         kbXnJ3CRoz/wqDo4SV2g5RL02zHpUNdBV4qR9IumhIJdoJlaT5U/0IAW7sgDaA00TRO2
         /GMyXkKsKtW8TNrQmuN0DxVxyEryPcHsKqI8SVdchgkvx3neZaCiwBlrlr7BGR0ut5s5
         DjDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690903225; x=1691508025;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=f1iJwrUwzrr4LImgyPThesTLhstaE6VPmgVvDL2bXp0=;
        b=BZ4ubzWvAHCOBVwosGfYRf6cstLpSXUfGcGJI4N7521WmgjEEs8ivm0H/OxPSYqycZ
         DKO0t4BJPU6lUBe7Owq/gE4a383LEi3cEbdF+uGfa7QI6L3dD94K+cDmwRcFp3clGTV+
         Sz74Vc5hI+Zu6O4MJE3uCZBKjPF4anIIilFVGD3HD4O738QYcK3GVWURaZ9INcxIkHD7
         0DqSOKAvgajk4GR1ie/yMyEVq9LUTzLb0mZxkk9A2qKjFmXNRK4w6TUY9LCOkBMutf/9
         S+lbW0sc/eJhGFjmn1cKCROPUYyPOjwyXurVOgzS6BmklYR8jjIvRuWqCfR8/gs9LDVe
         osFg==
X-Gm-Message-State: ABy/qLZTxWxZSl7U/F/1CzKNom7tYZGmEwbKa1dQ5ogR4CC+OD1I8aqU
	ZgEtxgvOTUMpSebhjBOqpHwX09xAqyoVvhovPg==
X-Google-Smtp-Source: APBJJlGHdElaUhiJW+cJ/Bn2gO8XjYZHEO/Zt8CW/zpfo34kurpBDGJ2kXAnPcGIqggba9Ii19yPInx1FB+5h5bOeg==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a63:6dcf:0:b0:563:8dc4:c851 with SMTP
 id i198-20020a636dcf000000b005638dc4c851mr62368pgc.9.1690903225626; Tue, 01
 Aug 2023 08:20:25 -0700 (PDT)
Date: Tue,  1 Aug 2023 08:20:03 -0700
In-Reply-To: <20230801152007.337272-1-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230801152007.337272-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.41.0.585.gd2178a4bd4-goog
Message-ID: <20230801152007.337272-8-jingzhangos@google.com>
Subject: [PATCH v7 07/10] KVM: arm64: Enable writable for ID_AA64PFR0_EL1
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

All valid fields in ID_AA64PFR0_EL1 are writable from usrespace
with this change.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/kvm/sys_regs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 5a886ccb33fa..0a406058abb9 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2041,7 +2041,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	  .get_user = get_id_reg,
 	  .set_user = set_id_reg,
 	  .reset = read_sanitised_id_aa64pfr0_el1,
-	  .val = ID_AA64PFR0_EL1_CSV2_MASK | ID_AA64PFR0_EL1_CSV3_MASK, },
+	  .val = GENMASK(63, 0), },
 	ID_SANITISED(ID_AA64PFR1_EL1),
 	ID_UNALLOCATED(4,2),
 	ID_UNALLOCATED(4,3),
-- 
2.41.0.585.gd2178a4bd4-goog

