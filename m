Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BF05AD26
	for <kvmarm@lists.linux.dev>; Mon, 17 Jul 2023 15:27:31 +0000 (UTC)
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-55fe85f4d84so733823a12.0
        for <kvmarm@lists.linux.dev>; Mon, 17 Jul 2023 08:27:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689607650; x=1692199650;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=htAmYufdlwdQkrnMh1FolzMt6QFv3wnBH4tKRrY9pOY=;
        b=xI4T3zbduc9TmspWmtT7V+gA6ugWZAAXy1otlcIBxe0tTGAJHFf+HNXTr3zOhJazgQ
         wogmZtoIA1HRneuOOjzTdGgdRvLVw+ra8Q6vHx8HiEPmjL8jaBISb8CBk4rXpYnrO0Va
         16jjVVQEW/iriFANkcG1oXGPt0F74hEZ82PDRen8tPrhC1+zKLJqrrsHZreWEb/IwhAD
         FPylSgbTKfFZUqxFqiG1HZ8Oy/7qTIsdsi7ptbILW73X3x32RpUwOJVTiyPR15oisUXH
         qe+B9A+iVJcDCYTwY+LmQosm90heOj4JQuYnfAdqXgpo9+ckScHz9MkubZdyTy1n7MQR
         iCZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689607650; x=1692199650;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=htAmYufdlwdQkrnMh1FolzMt6QFv3wnBH4tKRrY9pOY=;
        b=dTFz+LO7hAhbaJfzbdAKeOLpfjsYIS22B2S4Y1gHVn2CdGH7EAgPX2gVoyXXQ0GH0G
         3p8tHoJbe76e8S9a6zJTN4Et/k/2WUtEyweUgQrKGVQJAZhtSxRbCpx0sVDU+u4cCODz
         uZOPoAiUqsM7gwKSEIW9zQwGd7/wAkiCsOv4RLFA3/ePg0Q1VGVj9RsyRGJWo2ObGU1s
         03d3DoR8CkOJ8Zkr6Hb32/cmqGjSg9YVUvUovQjOI3GwjH7UviC8llGeNGFLdz7t+Xpg
         BsAaVj76tx/f8f8uFSbUJUrH/izzZeG91YaHlkkigJp1f7N/F/L2jFFVjLvgFOovJSOY
         tU/A==
X-Gm-Message-State: ABy/qLZTJqjMmSK4A9xTy876H+yDBJPSANgiGzVJ+1lSZSgDUvxIlM1W
	gEOm+159ND7evFDMBYEQiElOah2u+VjdOpWxSg==
X-Google-Smtp-Source: APBJJlE41/UjvsOG1TZzYJvdATulWzSMytTnqO57v82maNIOWtlfxzc2uU+pqpIqGecJ69SQhQSekQZWgk8UhJbyIQ==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a63:e403:0:b0:55b:4410:aafb with SMTP
 id a3-20020a63e403000000b0055b4410aafbmr118243pgi.3.1689607650529; Mon, 17
 Jul 2023 08:27:30 -0700 (PDT)
Date: Mon, 17 Jul 2023 15:27:20 +0000
In-Reply-To: <20230717152722.1837864-1-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230717152722.1837864-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.41.0.255.g8b1d071c50-goog
Message-ID: <20230717152722.1837864-4-jingzhangos@google.com>
Subject: [PATCH v6 3/5] KVM: arm64: Enable writable for ID_AA64PFR0_EL1
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
index 053d8057ff1e..fab525508510 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2042,7 +2042,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	  .get_user = get_id_reg,
 	  .set_user = set_id_reg,
 	  .reset = read_sanitised_id_aa64pfr0_el1,
-	  .val = ID_AA64PFR0_EL1_CSV2_MASK | ID_AA64PFR0_EL1_CSV3_MASK, },
+	  .val = GENMASK(63, 0), },
 	ID_SANITISED(ID_AA64PFR1_EL1),
 	ID_UNALLOCATED(4,2),
 	ID_UNALLOCATED(4,3),
-- 
2.41.0.255.g8b1d071c50-goog

