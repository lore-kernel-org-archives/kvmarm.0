Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E883D241696
	for <kvmarm@lists.linux.dev>; Wed, 12 Mar 2025 11:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741780578; cv=none; b=UVRLF51qdqGPt5qdYl7mlmY5UVxLMcvM7cKrvmJWx8/qgRbKlVatGrcDz4fXKwsJv0a8d3K+69OFYAunIg26R/C8MjFp/fVhe1HD4vCGc8ex3d9oaPfdSpy1nHeM/BSyI8Sz0okLtn8RvZ/aw9LQF8/2Tg0DJ90RZwdiCowgwZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741780578; c=relaxed/simple;
	bh=Nls52lkzjmJ+bhk/FuveEgJphMZM3lsoGJmXIHJqvZ8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=dQh/8v7b7BRzyCTzOshuxKoi+7oALtHjMdbXTniXe1FbI+2pVOu8hoymVyaCnC6hoM4gfkDD280t+LMBUQOePI/zsCpPpkvIdntqadT8ax8Jg54AxBC56cyhPe/kV0q2fJAp5w2tGUu4eE+FU9jqxxhSkhfHnxCR9P0Rw20kRas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=pass smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=XTSwwO+O; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=daynix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="XTSwwO+O"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-22435603572so79190455ad.1
        for <kvmarm@lists.linux.dev>; Wed, 12 Mar 2025 04:56:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1741780574; x=1742385374; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rAMd6rGhip9Etdi0DcL12HaRjFlmNQeXSBT7tbE4ZZA=;
        b=XTSwwO+OpdBkEk1TQpK2ZL0gxO7dj8pz96G8SVrGhinoIS0GV3my/mflhfOw9ffFAV
         OPTaitKkcK6LZvBp1SrVakvJfNd+Kl7gqZJz/eYPvNFMSR/Ec5LASS7nbttwjHOXskpA
         V/hFyyopjTUUoSe+X7F/tqU0SyVGoloeDQBQ6dd7zxjNMoAs27VH4Ssjt8Yeq+7UgUMv
         FxQeHqIsRBzEvA83eEJ7F4zNec8+UcY12GuVZ2DDd5+K5g6jV/cRBEGvHKYZrKwo6r+/
         yn46olG35LRNzV9K9WfgkhHIR4y0M3GV85Rv38RT/qxaXEMRgWBbXNktNYhXdRcGkfF9
         59Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741780574; x=1742385374;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rAMd6rGhip9Etdi0DcL12HaRjFlmNQeXSBT7tbE4ZZA=;
        b=E5VcuHXpiq8polWF3XYmmUQCESXIZarRlnsEadNmS0C5jy9pXi/rtaeST9XlisZo3i
         KN2sd6rWw8VHNar7IkPzCQ5HjdiMrkzJ5EIQAnL/uzr2mheHiepX6caSOMFxDOhxU/P8
         DJoYfTJ6ok/Xi6GWsrkVH5QSQ0rgGYxyqiORpSOt1QtAF/eSE1xZ5oHmRhP3GaHl6A4H
         i8BDJhIpF00CPfxZAyyYD7sOEnEVEFW0hl+Uyrwce3ERNvy414aWIC0hd5BVpoR6AKOU
         9otB+q/OGc4AxSsQWarkeG6mXdkXONZD5oLwVLmBLUt4XrIZIr54aRqBSEf42C8V5DSZ
         XhOg==
X-Forwarded-Encrypted: i=1; AJvYcCVt/IOgPfFwKysVD+Ogx03If0h++Ndo3rOqRW83IyByzAnkkyBBjFs9DPpLXAXtY8cN9bg85lc=@lists.linux.dev
X-Gm-Message-State: AOJu0YzDzwjuaLV5rF27qEfGbXdKpwDzUgKZ8HxiacOV0TJi6x4z8+mr
	iq99Tnlz+98KojdJJ9I5cteW2+pEGX2A+HCWFgQGpav9UCz6ZCEtiRoM1eVq4+E=
X-Gm-Gg: ASbGncunL2/reu2XE18zN8UNWkown8KhIwGJ2/RC0E7bxeBVc6rbubUtoG/BJ9F329v
	miPgkrFedSy5/llxU9VKpKlCSNr6hRlDAaGnPwrpjzZ+IGPXcmZYHKEJX+pqhkGXoIriNJ2yqOP
	uw6hy3j3+eBpSxwHzfmWyJzZVL/6C4maOmXvtzLOuXO2azjBDP2VQMCG4630V4wvC9Gx7mIBeeJ
	9lZdPvHMwciSSqUezR/eDbtHWaoUyO+u912CYgjyYu/yd8fZdJO0oO6bEOwrOa+cuK/eqdX895a
	t6t9rB+puYrkK1Ps4TuiQ5bNcWrZhAc8+/5DTnIqv+rnOmQX
X-Google-Smtp-Source: AGHT+IGVJsaOES3D6e5IgzEgtMMcyBt78uD5r1dUvwmlCbFQdHU9CycZp7wTmKosTDLuCPhOfc8eNw==
X-Received: by 2002:a17:902:e812:b0:211:e812:3948 with SMTP id d9443c01a7336-2242850b42amr315559235ad.0.1741780574197;
        Wed, 12 Mar 2025 04:56:14 -0700 (PDT)
Received: from localhost ([157.82.205.237])
        by smtp.gmail.com with UTF8SMTPSA id d2e1a72fcca58-73699da011asm11973015b3a.84.2025.03.12.04.56.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Mar 2025 04:56:13 -0700 (PDT)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
Date: Wed, 12 Mar 2025 20:55:55 +0900
Subject: [PATCH v3 1/6] KVM: arm64: PMU: Set raw values from user to
 PM{C,I}NTEN{SET,CLR}, PMOVS{SET,CLR}
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250312-pmc-v3-1-0411cab5dc3d@daynix.com>
References: <20250312-pmc-v3-0-0411cab5dc3d@daynix.com>
In-Reply-To: <20250312-pmc-v3-0-0411cab5dc3d@daynix.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Andrew Jones <drjones@redhat.com>, Shannon Zhao <shannon.zhao@linaro.org>
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
 arch/arm64/kvm/sys_regs.c | 21 +--------------------
 1 file changed, 1 insertion(+), 20 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 42791971f758..0a2ce931a946 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1126,26 +1126,7 @@ static bool access_pmu_evtyper(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 
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
 	return 0;
 }
 

-- 
2.48.1

