Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 272D61F462F
	for <kvmarm@lists.linux.dev>; Sat, 15 Mar 2025 09:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742029968; cv=none; b=Uzj/B6osS8NjQeqsJdnK4j9cBfsVOjPwiVC8zi2sQx39s3y2J0K3PSzzPpp8W+SdWZiORq6D/kT3q8PdTU3zWOImlSH6zKqeaahDfGd8wdo5VKyLTpRXY0pr3bui++FQnpUcQsRzgLCNcC/ay/dTOQmzTzlJEdJnob1NXtKolw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742029968; c=relaxed/simple;
	bh=pLEJhlfw3fbIq3nvqJiuw0vOJP9zyUhLd4sW/C6OrrQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=mzbMJNk62XB0RPauiB78Qlffp/KY0TLqsJ6BdrcVE1g/BUEVIxUEh4k76M/S8Nnpzv7p03kHfdDoSUTq+CIct+xu3RGRoZmxS+JVc55G71DXeQbKUbZOjGbwTmmwES0CkdnDodwF7QZkMcGK3VT+rssRCzCNFILNsuP73QOHyAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=pass smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=ibxqdmOJ; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=daynix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="ibxqdmOJ"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-22359001f1aso73397945ad.3
        for <kvmarm@lists.linux.dev>; Sat, 15 Mar 2025 02:12:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1742029966; x=1742634766; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fVQeHb+cCKo9FI3oCd5KZj2+ztmvI+IS1H6dV0Bffso=;
        b=ibxqdmOJqhn6fLu6FkYCICElHyeDC4Nzl0ZNn2v1fV2EP7T2WM8PUUxBVE1QuHwRMx
         joOII0GoHDdqrG0xKKgR7Wd3hpUCEXelPyCF4/D8LVNVE+ET11UWIFWyd9EBbGuZkGkd
         xF9oCJBbi7fpM8etgEHJEhy4a6dZjOkzqR52bd2XUAw8RaE4j4PR+fIScTN07k3ukSxZ
         0p9wlsfckKEULhQcATAlXhbB30Or/jkC1QKvbeQ7C5lfkdH0hsmRl89OZgEbG4j+1tfg
         eok7Dc5/la2Pn+UyblBx7cQzXTkf6e4+y9g7uMoZU707Aj/d9zJGay5XIPae+fxSAole
         LLbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742029966; x=1742634766;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fVQeHb+cCKo9FI3oCd5KZj2+ztmvI+IS1H6dV0Bffso=;
        b=XSXEZYJWk5v6tQ3wszcWQ95+RJpHhaG2vZZqaqvi/RQZy8VBN7nFKYVW937Wu+k6/8
         MMeyz0TpCXWqtRbM4LAPUGrMaJeyx/XaZqZZdwPDAcWdzogaaBd0eV9+MATV3xXCRJEb
         dzLlF7VgWLr2Tg74xxLhpHdsWFQRhbB4tyY9hIOGT/Y2u+MC7mIOMdqjiY5aQ6jkj9Id
         tI5i07MSO3myLHb/pa0SmfhbJx14GdVhbSH5DEywgNsczOJ9Sbba1fylneVzr87weBqM
         2k6t6XZjdYeUm1u9QMe73o8Zx+f+DMtVporv+Rb+Ui0H7oPR9k3I2SMI3m8rYcGDlV7/
         c9fQ==
X-Forwarded-Encrypted: i=1; AJvYcCWizSiYummxPcjGo85YFcf0KZtAdG8/JolGHvjAYX6Uhxj+2nZF6jMl23xqq6+b72kF5sP7f/E=@lists.linux.dev
X-Gm-Message-State: AOJu0YyRcxd8Z2lNh0y5EfDkCv5GJ/WxNqPhN+RRBYkXkJKw2ph+JmXP
	bQ1BtivGfO8oB1/W5SnsrDWt1wmyj183gyNxUOrp509x4lwJIH6BUEULmx9GmkA=
X-Gm-Gg: ASbGncujnoHzPerEk6xn8NSff4qP8Pi51CYirOGS9K+xmIFydy1YxXEfcQU/IRqnUSg
	lj8x9l+zAa3sHmpZKunTZQNFWuBSwk6NxhtsAlkIS4NhjCW+TDXWadkRejabayV+VC82HmkY7Oz
	8V4q5vupzyEt70vPrZVoFcMVBnTKE+hah44IQGMrQISpyLqVQl50PEukT1JWjsFD4jQUlTpEdhQ
	a/aJY3v0DjK9g2FEi+ON2GBig+8gVyugqz5hkd7QV9lQrVQgez6L4Lo41KaSSCKpq8sCZRwR2xS
	nmSqMuw+DgIhoip7E5VYfXu14ytciOij17EJ9rT84rNGeJS+
X-Google-Smtp-Source: AGHT+IGQ8Gz6JOShy4dRcyVD/SiQ18YggMiPkdBJ/XbTFh26anmZdWe+vf8X98ZKiGLO7S3+Q3G5dQ==
X-Received: by 2002:a17:902:e750:b0:223:90ec:80f0 with SMTP id d9443c01a7336-225e0a6b3f8mr76818965ad.22.1742029966450;
        Sat, 15 Mar 2025 02:12:46 -0700 (PDT)
Received: from localhost ([157.82.205.237])
        by smtp.gmail.com with UTF8SMTPSA id d9443c01a7336-225c6bd4a8fsm40925235ad.234.2025.03.15.02.12.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 15 Mar 2025 02:12:46 -0700 (PDT)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
Date: Sat, 15 Mar 2025 18:12:10 +0900
Subject: [PATCH v5 1/5] KVM: arm64: PMU: Set raw values from user to
 PM{C,I}NTEN{SET,CLR}, PMOVS{SET,CLR}
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250315-pmc-v5-1-ecee87dab216@daynix.com>
References: <20250315-pmc-v5-0-ecee87dab216@daynix.com>
In-Reply-To: <20250315-pmc-v5-0-ecee87dab216@daynix.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Andrew Jones <andrew.jones@linux.dev>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, devel@daynix.com, 
 Akihiko Odaki <akihiko.odaki@daynix.com>, stable@vger.kernel.org
X-Mailer: b4 0.15-dev-edae6

Commit a45f41d754e0 ("KVM: arm64: Add {get,set}_user for
PM{C,I}NTEN{SET,CLR}, PMOVS{SET,CLR}") changed KVM_SET_ONE_REG to update
the mentioned registers in a way matching with the behavior of guest
register writes. This is a breaking change of a UAPI though the new
semantics looks cleaner and VMMs are not prepared for this.

Firecracker, QEMU, and crosvm perform migration by listing registers
with KVM_GET_REG_LIST, getting their values with KVM_GET_ONE_REG and
setting them with KVM_SET_ONE_REG. This algorithm assumes
KVM_SET_ONE_REG restores the values retrieved with KVM_GET_ONE_REG
without any alteration. However, bit operations added by the earlier
commit do not preserve the values retried with KVM_GET_ONE_REG and
potentially break migration.

Remove the bit operations that alter the values retrieved with
KVM_GET_ONE_REG.

Cc: stable@vger.kernel.org
Fixes: a45f41d754e0 ("KVM: arm64: Add {get,set}_user for PM{C,I}NTEN{SET,CLR}, PMOVS{SET,CLR}")
Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
Acked-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 21 ++-------------------
 1 file changed, 2 insertions(+), 19 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 82430c1e1dd0..ffee72fd1273 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1051,26 +1051,9 @@ static bool access_pmu_evtyper(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 
 static int set_pmreg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r, u64 val)
 {
-	bool set;
-
-	val &= kvm_pmu_accessible_counter_mask(vcpu);
-
-	switch (r->reg) {
-	case PMOVSSET_EL0:
-		/* CRm[1] being set indicates a SET register, and CLR otherwise */
-		set = r->CRm & 2;
-		break;
-	default:
-		/* Op2[0] being set indicates a SET register, and CLR otherwise */
-		set = r->Op2 & 1;
-		break;
-	}
-
-	if (set)
-		__vcpu_sys_reg(vcpu, r->reg) |= val;
-	else
-		__vcpu_sys_reg(vcpu, r->reg) &= ~val;
+	u64 mask = kvm_pmu_accessible_counter_mask(vcpu);
 
+	__vcpu_sys_reg(vcpu, r->reg) = val & mask;
 	return 0;
 }
 

-- 
2.48.1

