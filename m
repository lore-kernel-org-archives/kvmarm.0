Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 496681FBE8D
	for <kvmarm@lists.linux.dev>; Thu, 13 Mar 2025 06:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741849083; cv=none; b=hanijSpO+ZYjD/nlWaL8giiJmf6PUcNL3ODhVBbAa1ivuzkfikWZhULIcX5gtHw/n4t7B2IpU7oJkj9KnYcFqXX9yYyIX/xIceOUQmE4GXW8m0TetqnkHYY0raF0b0KDifzuapmHZAs4nyXeenAVCHQK3fiGcEyfsPEEnCL7338=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741849083; c=relaxed/simple;
	bh=Nls52lkzjmJ+bhk/FuveEgJphMZM3lsoGJmXIHJqvZ8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=pnFglmQOQm3UxpEpeN8p6gfAaXFHyXw4+ehMJKTgc1PhjVL68ltoxCQCvlV1cfMa1xvm+HgBS9m4eLYLkQedhlvMiUzA26wWf6Q8G2XCMPmxJPqMnABU14N0YMA3osSoFi1kN9P33lddVWq+2BJ/VFBQ96qb/Lp7Ku12zfoS4gA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=pass smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=IZ7uV5Sf; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=daynix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="IZ7uV5Sf"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2243803b776so16867305ad.0
        for <kvmarm@lists.linux.dev>; Wed, 12 Mar 2025 23:58:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1741849082; x=1742453882; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rAMd6rGhip9Etdi0DcL12HaRjFlmNQeXSBT7tbE4ZZA=;
        b=IZ7uV5SfCDDDNI31K2if0rkDSfpP1lqAktNpNC/+7H/ua0LzFtMZ8+ZEXuoQ5ND0US
         QE+uTb0BPmNA+WD8eAvi/6EPXFYvAOi78nhv8Yw1rR4PjatDbKFSQxmSOjP8nOZir2Vh
         exT5673Br4+C/99Pvc1rE5mOwcQzK+uHfe61AzN8o74p8xXMl5caQ/jSFwxNKyt9yxmQ
         PwmqKqGAM7p2WTwJZBmvuQ5GpFJliSFb2GRo4PLuJ2XGQX/jmxpBVOy/+5aXVIo8C4PL
         21LfIXODDRohiIKhaoq7LXzRzWQFgPLhvmSu9qgo9KaOEAocrjqffvl5cIKPJWmizmdm
         182g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741849082; x=1742453882;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rAMd6rGhip9Etdi0DcL12HaRjFlmNQeXSBT7tbE4ZZA=;
        b=CzW18urgyelTaRErhUCn5UHfE2ovyZp+cDPUY4Mdp+NWaxg5KAcO1bXJuBD0HjfGkL
         j3jjD8g9uplebIgPt2l47dX1HT0WPIneSOcN8pmEPUN3VrI1utvqAq90H8jq0J1pV75M
         mdi3O2+LirxYQ3ZEqusj40+v+K5KP/SMc9M49+w7VfgkMa3LeBhC0P1S7vEG7if67bBB
         Py9Bqy7sbnIVjoHdj5GWA6cuMAW4NmzndY5I3u///Szn/koEsMiXpWlpXqIj2n3g0WLV
         yjhoT+imQOZ1+BjixT6wwNrUNUriGvXP9yKhOTlLMXTw629a9oWWSN/K5vHUtM9U5Hoo
         N69w==
X-Forwarded-Encrypted: i=1; AJvYcCUQlHwEpVO4gwFPe4WmuQJ5a3jZ7hATNp49qmTGh1dIn4RcgLcLX/9NWWvjN6s0h8ZaDfl9ioQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YzPmfj8TtcXxHXjgl7yW20dgYLWqmQtW6x5kxXhQI5L5JQuIr0b
	dTMANMRpTaU3S/yFVJ3OCH59yP+pw4aq8JHCPrq8q8YsTt0WVXrnOR4jREEfDhb8FkngkfSQ9MO
	z+RY=
X-Gm-Gg: ASbGncsyKNjM+tXbXVNABNSILJHHEQDBXQRzr21+GPenSC/4/XIlc9s9lBN/0jMhKZ+
	uVThow9TzjqpaxP34DDKyb0mPvnoWnM0bQDpQwkQZOsPfhgPa7XRIAG7/GXIg7MI4FgjEoqQHDA
	zngoZOm/7DmBSBQb7vWMi6LX/yTZZNBnFbaCZZvY+1mEOrc/iqft6d48pYBwaJA15TNrxwOvFTZ
	XdjUbWPybpHIgn07HWr3unxptNRR0jCGopL6lw35nR5DB51wULsnBpyYlvAea+Nz/0qkQilkiN5
	7vx8KPQa1uogETtQZ9p6onxg29HWvZR8bTfAn3UOqRoG9EIL
X-Google-Smtp-Source: AGHT+IGCLVrEGNjCO/QnspZOy0VKIly8ZUkVAApjFMGze7gowWxFFi+tM448yykvGdA29pKzg5pogw==
X-Received: by 2002:a17:902:d2ca:b0:216:3d72:1712 with SMTP id d9443c01a7336-22428ad53e6mr379581645ad.48.1741849081724;
        Wed, 12 Mar 2025 23:58:01 -0700 (PDT)
Received: from localhost ([157.82.205.237])
        by smtp.gmail.com with UTF8SMTPSA id d9443c01a7336-225c6bd7bb4sm6378025ad.237.2025.03.12.23.57.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Mar 2025 23:58:01 -0700 (PDT)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
Date: Thu, 13 Mar 2025 15:57:42 +0900
Subject: [PATCH v4 1/7] KVM: arm64: PMU: Set raw values from user to
 PM{C,I}NTEN{SET,CLR}, PMOVS{SET,CLR}
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250313-pmc-v4-1-2c976827118c@daynix.com>
References: <20250313-pmc-v4-0-2c976827118c@daynix.com>
In-Reply-To: <20250313-pmc-v4-0-2c976827118c@daynix.com>
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

