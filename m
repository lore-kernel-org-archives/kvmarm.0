Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 173527483
	for <kvmarm@lists.linux.dev>; Wed,  5 Apr 2023 17:21:53 +0000 (UTC)
Received: by mail-pl1-f202.google.com with SMTP id z16-20020a170902d55000b001a06f9b5e31so21711567plf.21
        for <kvmarm@lists.linux.dev>; Wed, 05 Apr 2023 10:21:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680715312;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YZXp0/8PJTGepliQmzk6iLCbVVbymsexrmTW0hRHL+M=;
        b=XTTnAPzj7kVG9899g25zsvj+9D1iNIV9d1Jo24v6C38NNXjhfEnP1e5H4cxXfhRBF7
         b7rLGulBObZJB/MfqN+xHVqqw/2r0vWFb8H5R4i4mXlTbJPSbAkEHel4edTJvIwiVJ99
         JfKmJ0+HYF8/0ZweRaMHpKJEf3JoRYzgxXM646JGYNU/m9uZp5tsCySc3V8zYN08yXLP
         5w1Fv417CX67t84VJAVtfeDe4XNaPwvD5EwBoZaNh73QAPb7DQaTc0Wrn7OYfqzt1FvO
         zX8M24I/sLOlrJF098SFySRjZfHN/Gjzx3H7Sx2UVEq97apuH77F3DQl31XemS9y2LK5
         mNaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680715312;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YZXp0/8PJTGepliQmzk6iLCbVVbymsexrmTW0hRHL+M=;
        b=CxtbzG8LcIQzd4wLbSYqsp/dcVpmMJyDY7T5kIAVlL9z54Q1uWCxRKMLK5dcNCvLM/
         UPIiBKa8f6B4QX/KlwzOoNWWI+KQMuRvhVGyGtgP8nbknia82dDzw0G8CcD/GGoUBwbw
         et/DMhPTTThd6zIr3iufg+h3a5seLBJVxb3iBrXgV7ypu39keHyq7D4H3M64+6Ol36XL
         I8SaBvGCZiuNWXRrziDnIhXlyRZ2UJvWJwx4JwOkdxrQ8sDd0WwWcHq3dy5qgoXMsKp8
         hL2MEgdFCRcGfowUZYVxWeDjwGcQ98ScUFKAVVaj2NVMaHd4lNuSXxlYYZQnoIKkk1O9
         2z6A==
X-Gm-Message-State: AAQBX9ehuhTTpeXYSvuhgAOPBWtH9WDQ/Dxt0dJxzK41NM8T8JR1C3Pj
	/VPXmLT0Z5Sn8sxJx6UDTcItvUXdfN7k4171gw==
X-Google-Smtp-Source: AKy350YdnT5o9wS/pjdMEe/6lo2FY/3iyGIJvao+boVENo2vwZJtJU3No7oL73mE/HePZMnaS9bLUg8gsy47ERuERw==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a17:90b:e09:b0:240:228:95bd with SMTP
 id ge9-20020a17090b0e0900b00240022895bdmr2634779pjb.5.1680715312476; Wed, 05
 Apr 2023 10:21:52 -0700 (PDT)
Date: Wed,  5 Apr 2023 17:21:44 +0000
In-Reply-To: <20230405172146.297208-1-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230405172146.297208-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230405172146.297208-3-jingzhangos@google.com>
Subject: [PATCH v3 2/4] KVM: arm64: Enable writable for ID_DFR0_EL1
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

All valid fields in ID_DFR0_EL1 are writable from usrespace with this
change.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/kvm/id_regs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/id_regs.c b/arch/arm64/kvm/id_regs.c
index ca26fdabcf66..11d3a1d46ee5 100644
--- a/arch/arm64/kvm/id_regs.c
+++ b/arch/arm64/kvm/id_regs.c
@@ -548,7 +548,7 @@ const struct sys_reg_desc id_reg_descs[KVM_ARM_ID_REG_NUM] = {
 	  .set_user = set_id_dfr0_el1,
 	  .visibility = aa32_id_visibility,
 	  .reset = read_sanitised_id_dfr0_el1,
-	  .val = ID_DFR0_EL1_PerfMon_MASK, },
+	  .val = GENMASK(63, 0), },
 	ID_HIDDEN(ID_AFR0_EL1),
 	AA32_ID_SANITISED(ID_MMFR0_EL1),
 	AA32_ID_SANITISED(ID_MMFR1_EL1),
-- 
2.40.0.348.gf938b09366-goog

