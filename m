Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D29CF125C1
	for <kvmarm@lists.linux.dev>; Mon, 21 Aug 2023 21:22:56 +0000 (UTC)
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-564656d952aso3997112a12.3
        for <kvmarm@lists.linux.dev>; Mon, 21 Aug 2023 14:22:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692652976; x=1693257776;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=dCgM+uWZENhfXGRSSt7pNwhlX4F4zmpaI/T3IJmgu5o=;
        b=ME+OOxRo2wdRa9p4+icKYcj/ax6VdiNcN4Ngg7bJBna4Tq/iZNml5vlDHc7/LBxLVH
         3JLVDXMCicie0QbeU9TMQNUHqMc6HrS9vGVA2Bhlxxb+JTEBon5AQeIKjYyKGaTuAnzk
         g90dm7F92eU6VFVPVpq2jc+yOP4k4HE+ah1WPpE+lL/I6pmbt5oummmE2cR7K9I63pUy
         2kVuK1c5vaaPcEvq+eq6X/XpUllvZwGjrFacNR2JwfFCz8wT7NvOVXhn3uln8qTvM/b9
         4eqjrDBxdUHZ+Nb/DMJHqnhj+QxCmrBgbH1SAyRH6vqQAvrbABNabTPxme4PpoV6+4H9
         Gykg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692652976; x=1693257776;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dCgM+uWZENhfXGRSSt7pNwhlX4F4zmpaI/T3IJmgu5o=;
        b=WzJKJSO4kpm9OOulfqbnRsENWfDhYtQugVc+5KAggpIAj7A7LD3xOSmcig3ReMNeIv
         +RgWSRGZ6gEv5YcAUEPkd+taAxvzvS7qMFhiG9IPI9raMTD0gC8vr7KpTkho5JzjQG8R
         G6Uz5AZw/D6LM7jOm/DvLUYL303n1htiOPj0J3hQT4dLMI+Xa+6aatVLrUnEqUoajATb
         808hzzLO6DpZEoymXQe3Cj8JlJ4I/zU+mS90MGKBmnQczQ9Syo5/f0ryakcc3PRxTvdo
         //fpQps28wxtfKRHuP9ZJ9bNW2I1oziPQXIi094q7DEuypNCyAtScZ4ZOtWHDH3JqWsc
         ZMjg==
X-Gm-Message-State: AOJu0YxmArjjJbMXOCJ8Qk4EurvPH42qdYjn+FsZswtUBNvrzlbE40+Y
	ImLSXwV3XdtGu/wt+MQorAMZc02jg2QGqJ+8CA==
X-Google-Smtp-Source: AGHT+IFEbSMkpzW4xRUg9/lecmYCKElY3+Z/nNrWGKno3Wd6qYB/hxIPVKLuWctd4B12O8psBSsfZbG8NCfYHLsFjw==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a63:3488:0:b0:566:1c6:139b with SMTP
 id b130-20020a633488000000b0056601c6139bmr1238435pga.8.1692652976241; Mon, 21
 Aug 2023 14:22:56 -0700 (PDT)
Date: Mon, 21 Aug 2023 14:22:37 -0700
In-Reply-To: <20230821212243.491660-1-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230821212243.491660-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.42.0.rc1.204.g551eb34607-goog
Message-ID: <20230821212243.491660-6-jingzhangos@google.com>
Subject: [PATCH v9 05/11] KVM: arm64: Enable writable for ID_AA64DFR0_EL1 and ID_DFR0_EL1
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

All valid fields in ID_AA64DFR0_EL1 and ID_DFR0_EL1 are writable
from userspace with this change.
RES0 fields and those fields hidden by KVM are not writable.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/kvm/sys_regs.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index afade7186675..20fc38bad4e8 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1931,6 +1931,8 @@ static bool access_spsr(struct kvm_vcpu *vcpu,
 	return true;
 }
 
+#define ID_AA64DFR0_EL1_RES0_MASK (GENMASK(59, 56) | GENMASK(27, 24) | GENMASK(19, 16))
+
 /*
  * Architected system registers.
  * Important: Must be sorted ascending by Op0, Op1, CRn, CRm, Op2
@@ -2006,7 +2008,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	  .set_user = set_id_dfr0_el1,
 	  .visibility = aa32_id_visibility,
 	  .reset = read_sanitised_id_dfr0_el1,
-	  .val = ID_DFR0_EL1_PerfMon_MASK, },
+	  .val = GENMASK(31, 0), },
 	ID_HIDDEN(ID_AFR0_EL1),
 	AA32_ID_SANITISED(ID_MMFR0_EL1),
 	AA32_ID_SANITISED(ID_MMFR1_EL1),
@@ -2055,7 +2057,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	  .get_user = get_id_reg,
 	  .set_user = set_id_aa64dfr0_el1,
 	  .reset = read_sanitised_id_aa64dfr0_el1,
-	  .val = ID_AA64DFR0_EL1_PMUVer_MASK, },
+	  .val = ~(ID_AA64DFR0_EL1_PMSVer_MASK | ID_AA64DFR0_EL1_RES0_MASK), },
 	ID_SANITISED(ID_AA64DFR1_EL1),
 	ID_UNALLOCATED(5,2),
 	ID_UNALLOCATED(5,3),
-- 
2.42.0.rc1.204.g551eb34607-goog

