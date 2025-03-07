Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62224213250
	for <kvmarm@lists.linux.dev>; Fri,  7 Mar 2025 10:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741344951; cv=none; b=jVokKCuffrro8rlGzuR4zCVgqkVTVV4bQny1LPj2WhqEgO/CMzLUTe5dwCKi5pqp/lvrmm11+E2Q1KrMXjfnazaM/dsm7rUNgvACVnEqinDN4Nz1kmmGHocOGjbJjZAtZY36sHUzypTdoh5T90VS5VZPAexhwwMMy9+RX3tk9J4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741344951; c=relaxed/simple;
	bh=YkK0gICK/vMLYgGrmG2Il3cIUNO5rmXo9eTXUuoDgdE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ZWQHS8KQOazX54K5FojLNgeHLjcruzKPzXpsSCm2wtOBDtjRQHEFAkslzDneAjmRe4eZ+P+r4CvrtZktfHxEZCE1ynBpX0sjgqd81UKX4ga7HsIJCAYL6kNEt3+zSXJgjAewSbaWtyFqLYD1UG6CL60ses8nw9IuutMQeBYwl3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=pass smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=wh4JCz77; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=daynix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="wh4JCz77"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-223594b3c6dso29389235ad.2
        for <kvmarm@lists.linux.dev>; Fri, 07 Mar 2025 02:55:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1741344947; x=1741949747; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=84BQ3xuE/YOejwCkRVmGYfJqvNZTn+GmxFcneIOkJqE=;
        b=wh4JCz779MjJYWI2OwELkaxIKJdUQjKtPICPUTYTKylH65OyXXOJtyb5CAI5EADjkf
         IZEcw75TbdzXZaOPnx68FBKavm8oz94dpvM+yOBqpdsBf47hlwfIh8TDlupGewkqPQ7P
         eV3fJRWlJ7rf/XeoMNSNyM+R6fk1JwsnyErjGVn2zM3l+CrbAyIkDB+OzQzsK2LNeDsh
         bzNYok2/ExSvNrEta8uGhbN75HBzOiojx7Az4ZU86chdOrvteBZKyqk62j3tGhQP1YrP
         NIS963IiIo+TzjULkBhyC3CUYaSlKeTvCOkURlGLPP+ROznQP97rbCBFIc88gJg2nEw4
         Y7jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741344947; x=1741949747;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=84BQ3xuE/YOejwCkRVmGYfJqvNZTn+GmxFcneIOkJqE=;
        b=WBQRJvD6XRWEwadgaa/szo1xeHigPTe7EHwVDzv5kgU2J/BJATK+Yaed7WRBNS6O0d
         BHk4/Z79YPczTdgyoPww8cj8VDpPdeZh8VlZdDxbIqJXO1xpZ/vBG9Mve37Z7wyUyPiX
         ufwUYE3s4dKzsoxBy4mcB31IB4olgAp/Q6ML5WKY5nyMhNpT4pkO6pmobNHWIF+6MndI
         heFUK8WF3h4ryNys6kto7oNtdlfMiTZJdCR5ufzukrXKK/0QeBwLldb5M0bpgKa2+qx7
         9VhF8LR/TkEq+hro2ZjZS6am93wjeBKICgC74Am4r6chcPkNYNUZLY8MTgJ6WUuEGiux
         JJnA==
X-Forwarded-Encrypted: i=1; AJvYcCUfDs+ZTvoJHUXJmTnclRThImXG1BD793TqAx7BNNX8MzRi21Pt71KCdU/R216uKPm5Ok1qiA0=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw3W6MjsdivirGJ7wgew9/bGvI+g1yQOXA/RrFZpZxj2f5DpVqG
	uvRRNJG+i8Ztq8dTpaiX+g4Hc677ZQiGcEB/BxF92Vi6pzzSy4nTSzEAoQQC4y4=
X-Gm-Gg: ASbGnctoQVUL+zjjiC3OhMjn9L3cBAlt6vIjAK5lRf88LJkkqD81ojd+AGQM0nPAXK3
	7OX4ODfXDOWlM2Q3OOkM8Go6dWRybqoVZgMWRzzeorlF16Dy34ETxQ/08mnTabPTGLm3SLiJYLQ
	iYB26E0yzen1nrZVmxojpfnuaEiVXBRQ7Zad7M8OqKyK+4eeJUdoEE49JOaoCGRzy3u8zlFzOqx
	j5AElaSTffzF83K0GUkkCAZFvqruyF7Xx7Amtol33dTT/4pt3h26P1Aq01gZlAx/foZ3YUzFkYf
	c+s//JjSX8dz86fxtQSnw9hIQ8wz5I/hXYa02xs+SxvVjtU8
X-Google-Smtp-Source: AGHT+IF+CLimdfiOZ0VORULGUWByolFc/6pJXp6pWb1JSm9n2C2SEbnZP1Xs53CSe+DMcCSm/ABWvA==
X-Received: by 2002:a05:6a00:174b:b0:736:6ac4:d204 with SMTP id d2e1a72fcca58-736aaa0f48amr3972025b3a.11.1741344947618;
        Fri, 07 Mar 2025 02:55:47 -0800 (PST)
Received: from localhost ([157.82.205.237])
        by smtp.gmail.com with UTF8SMTPSA id d2e1a72fcca58-736985191cfsm3016761b3a.145.2025.03.07.02.55.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Mar 2025 02:55:47 -0800 (PST)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
Date: Fri, 07 Mar 2025 19:55:30 +0900
Subject: [PATCH v2 3/3] KVM: arm64: PMU: Set raw values from user to
 PM{C,I}NTEN{SET,CLR}, PMOVS{SET,CLR}
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250307-pmc-v2-3-6c3375a5f1e4@daynix.com>
References: <20250307-pmc-v2-0-6c3375a5f1e4@daynix.com>
In-Reply-To: <20250307-pmc-v2-0-6c3375a5f1e4@daynix.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Andrew Jones <drjones@redhat.com>, Shannon Zhao <shannon.zhao@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, devel@daynix.com, 
 Akihiko Odaki <akihiko.odaki@daynix.com>
X-Mailer: b4 0.14.2

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

Fixes: a45f41d754e0 ("KVM: arm64: Add {get,set}_user for PM{C,I}NTEN{SET,CLR}, PMOVS{SET,CLR}")
Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
---
 arch/arm64/kvm/sys_regs.c | 21 +--------------------
 1 file changed, 1 insertion(+), 20 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 51054b7befc0b4bd822cecf717ee4a4740c4a685..2f44d4d4f54112787683dd75ea93fd60e92dd31f 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1142,26 +1142,7 @@ static bool access_pmu_evtyper(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 
 static int set_pmreg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r, u64 val)
 {
-	bool set;
-
-	val &= kvm_pmu_valid_counter_mask(vcpu);
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
-
+	__vcpu_sys_reg(vcpu, r->reg) = val & kvm_pmu_valid_counter_mask(vcpu);
 	kvm_make_request(KVM_REQ_RELOAD_PMU, vcpu);
 
 	return 0;

-- 
2.48.1

