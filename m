Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C130A125C1
	for <kvmarm@lists.linux.dev>; Mon, 21 Aug 2023 21:22:58 +0000 (UTC)
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1bef53ee9a8so42514495ad.0
        for <kvmarm@lists.linux.dev>; Mon, 21 Aug 2023 14:22:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692652978; x=1693257778;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0Gl7xTSJXiv4/axuMn6kp2mV+4Fk1KiUUIgvbh7eheo=;
        b=K3Pwq0bXvrKKoxq17uKY6PPEy//Kahe1n6Kr2lkLQP0YejL8SYoTG+LL2ToHaaOzD3
         5/iaDGVN1sWGM48ozuRhey0SXURdcbdrZuB9mvXdtHAawWbjw56KAFNIDDoE6TulFdHt
         Kvy6nakQh8f4YV3k2MqPK3nDtSnbsLnNr1cdkrDZbMgUc/L/s+fVl/NfAkZfmQI1N1G4
         kBLL8To++3JN811vCM7jRuR3/SJdoPJ2vfi/pDICuViL8SGSkDiT4UBX7QZj755h6Zzg
         Cx8bZQKE7clKxDIVCEjjVLIwxqJij61DSDL/qMQAiobSjl08atjsyw1R5SypNcZBFvR6
         yq3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692652978; x=1693257778;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0Gl7xTSJXiv4/axuMn6kp2mV+4Fk1KiUUIgvbh7eheo=;
        b=MmxbxZCGKrFcH602leIgekeanIIovSf2MyUe/jVTRDS/wMqt8Qinf7OwA9+5rbdUwF
         kD8VI0aOoTe2aMfIBI/ruB5U2Sui5o4CMWszrfLdOErDN4DK1xsw00fUHwBUuznVuBvD
         9tgaZJzDXsXw6j/eHjflJsI6orJNUNcRh+u7VmCPAJLjse6vNA0nA3E64ROoMiYkMACp
         7+ByTYaP628MDl58odoL1ee2opDYbzg/ZoLZRFKpDGYyS+MWUuqScG4KXN3lwQi9wpak
         Uh5ib+9t0AEVxers1O4ql918E0JYnDiALrQ8KFtl0i8OzoxVgCTfUkGt12WRH61AIrCW
         hYZg==
X-Gm-Message-State: AOJu0Yx0bztMbqcpCVvjXB+FPq3ytdZZaMoycg9MHOf7NLRG9lDGd4WZ
	Y7/2aend6a4jjFH2osaMrCRVoGytC6nnD1by3g==
X-Google-Smtp-Source: AGHT+IF9FbTQRPdiHLCbnz33sY6UbDj9S6Y26IR0MYTkI5YWtozk6eb4WUf0X+aSfF3eceyT5iizkkBpkhREQrbrwA==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a17:903:41d0:b0:1bb:c7c6:3462 with
 SMTP id u16-20020a17090341d000b001bbc7c63462mr3891383ple.8.1692652978227;
 Mon, 21 Aug 2023 14:22:58 -0700 (PDT)
Date: Mon, 21 Aug 2023 14:22:38 -0700
In-Reply-To: <20230821212243.491660-1-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230821212243.491660-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.42.0.rc1.204.g551eb34607-goog
Message-ID: <20230821212243.491660-7-jingzhangos@google.com>
Subject: [PATCH v9 06/11] KVM: arm64: Bump up the default KVM sanitised debug
 version to v8p8
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

From: Oliver Upton <oliver.upton@linux.dev>

Since ID_AA64DFR0_EL1 and ID_DFR0_EL1 are now writable from userspace,
it is safe to bump up the default KVM sanitised debug version to v8p8.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/kvm/sys_regs.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 20fc38bad4e8..cee5f879df19 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1489,8 +1489,7 @@ static u64 read_sanitised_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
 {
 	u64 val = read_sanitised_ftr_reg(SYS_ID_AA64DFR0_EL1);
 
-	/* Limit debug to ARMv8.0 */
-	val = ID_REG_LIMIT_FIELD_ENUM(val, ID_AA64DFR0_EL1, DebugVer, IMP);
+	val = ID_REG_LIMIT_FIELD_ENUM(val, ID_AA64DFR0_EL1, DebugVer, V8P8);
 
 	/*
 	 * Only initialize the PMU version if the vCPU was configured with one.
@@ -1550,6 +1549,8 @@ static u64 read_sanitised_id_dfr0_el1(struct kvm_vcpu *vcpu,
 	if (kvm_vcpu_has_pmu(vcpu))
 		val |= SYS_FIELD_PREP(ID_DFR0_EL1, PerfMon, perfmon);
 
+	val = ID_REG_LIMIT_FIELD_ENUM(val, ID_DFR0_EL1, CopDbg, Debugv8p8);
+
 	return val;
 }
 
-- 
2.42.0.rc1.204.g551eb34607-goog

