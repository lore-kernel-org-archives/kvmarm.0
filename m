Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCEA7125C1
	for <kvmarm@lists.linux.dev>; Mon, 21 Aug 2023 21:23:00 +0000 (UTC)
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-26d52dc97e3so3425053a91.2
        for <kvmarm@lists.linux.dev>; Mon, 21 Aug 2023 14:23:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692652980; x=1693257780;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hGowuOdlgc/g3u8U9EhceRoch6MKJG6leI2ZQ+fj9oY=;
        b=03bvAlvTUehe1uNIygFjSACoQV5XNjS+eQzJfURH/Y0uyMFVuiLMbXKLjkwJv+5c2y
         wO6ojiA3clpunb2gqxUvlqlsCSexjofZ/Eyspj/EnKYXhP5Ma4lHumDpsDRNxnnpQlkI
         lt7Tg4JU7TYDwCJPTiUatOnoVNZqNRnGgFVSJm4dWtkyQOpTqHxQa/FFhmoqQo85Y4Xq
         udROwtOJlZWZ3tfB5vAYhbPCRzypEQRSHtiBB6SNL4T2gt0cobUvf3KCC5UdtX6AM1Nm
         ghYVmJ3bglWMB0njGTHNPz6RQO2iWWyfQIVCbU49tN/fmZPPDffPoOwUbtWR/MZQ6blm
         549A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692652980; x=1693257780;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hGowuOdlgc/g3u8U9EhceRoch6MKJG6leI2ZQ+fj9oY=;
        b=YqFgnVEKkpTL3OW3wz+9IxwV2eSt8CozXWRaYeqI5RHRh0Xqe2+KBTI7T7MhM0V7lY
         tMe82h1UoP10KXtbyOc0psOZJ6NqRsPKGhYDYHRrNuTzGD2VbPOUD0RHXPZA4X5PDPGm
         B2OVZ3dhoqQxfZfiwu17bYkw5YSDY1xydfOIkDRQxQGlkMryy+AmrVrTZzoJ0eGniJpy
         7l4GJhOw9pm3tx9MejKx8Vf2sCINB4VG13r0x2cBejw13MdNzNSgFPMh4sql9+C0f6tG
         qWFjQrkmrZb9Yl/iBFF+Vz/SbzdE4Bh4yuPJW0tQkeO5e7vODyKqJNu0FEBMuxAkQ7YU
         c+cw==
X-Gm-Message-State: AOJu0YwUbinh7VzTE8OMG8UuWVZeMs+eXgw+qIHxYaI/u0MEGLhqR+Y+
	gVPfrgo8mJXb+4S79ZzJPGN5StLDjZ2cOoDQyQ==
X-Google-Smtp-Source: AGHT+IHWAYCWcuqlky3Jlh/tA/tztTBvpOQ6Ky5fN+7+GItW2NvM/yxfZvHjSk78Kd9MgfkgDAvMSeqcrtbGplRwbQ==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a17:90a:c690:b0:268:1dd8:33f0 with
 SMTP id n16-20020a17090ac69000b002681dd833f0mr1930362pjt.1.1692652980138;
 Mon, 21 Aug 2023 14:23:00 -0700 (PDT)
Date: Mon, 21 Aug 2023 14:22:39 -0700
In-Reply-To: <20230821212243.491660-1-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230821212243.491660-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.42.0.rc1.204.g551eb34607-goog
Message-ID: <20230821212243.491660-8-jingzhangos@google.com>
Subject: [PATCH v9 07/11] KVM: arm64: Enable writable for ID_AA64PFR0_EL1
From: Jing Zhang <jingzhangos@google.com>
To: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	ARMLinux <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>
Cc: Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Fuad Tabba <tabba@google.com>, 
	Reiji Watanabe <reijiw@google.com>, Raghavendra Rao Ananta <rananta@google.com>, 
	Suraj Jitindar Singh <surajjs@amazon.com>, Cornelia Huck <cohuck@redhat.com>, 
	Shaoqin Huang <shahuang@redhat.com>, Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"

All valid fields in ID_AA64PFR0_EL1 are writable from userspace
with this change except AMU field which isn't exposed by KVM.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/kvm/sys_regs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index cee5f879df19..bf716f646872 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2043,7 +2043,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	  .get_user = get_id_reg,
 	  .set_user = set_id_reg,
 	  .reset = read_sanitised_id_aa64pfr0_el1,
-	  .val = ID_AA64PFR0_EL1_CSV2_MASK | ID_AA64PFR0_EL1_CSV3_MASK, },
+	  .val = ~ID_AA64PFR0_EL1_AMU_MASK, },
 	ID_SANITISED(ID_AA64PFR1_EL1),
 	ID_UNALLOCATED(4,2),
 	ID_UNALLOCATED(4,3),
-- 
2.42.0.rc1.204.g551eb34607-goog

