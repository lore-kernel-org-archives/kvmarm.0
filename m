Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 198F4212D9E
	for <kvmarm@lists.linux.dev>; Fri,  7 Mar 2025 10:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741344945; cv=none; b=dzaHr8ZZ/MpfhTv5MmVdi4t3vY8UHY1hDBpp4nWqDef3+ncuRrq6oQdSogxVjPJeH2OrYTTsb1uP0lK+FEi7qtsRv9hChACTKsO1JiTeCQUf6dD0jcmq157MvmDiqCcjRpe663oEoWBZvtYaOtAtzJN9WEVEB72QQn64lHn4VnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741344945; c=relaxed/simple;
	bh=JTuqG6l6qjIX+SUzFlgt+HussqtRooAlWSw54eqLKxc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=PAohhwFUrEXUUDrZDlAzTs/vxEPfNpOM3KkFSl20k9ll5lyCTASPsotqpYGXmWTZqP2MUhsvRF8d0XcRwKpqZr01YyVjQThybPkE0AndZeW9PTSrnzw1ch13ssz1GNnpWSyfnPlqf2aHdDOpWQdcp2JwkxUU2nS181EAnCkT5zU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=pass smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=Zm+ax47C; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=daynix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="Zm+ax47C"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-22355618fd9so30708975ad.3
        for <kvmarm@lists.linux.dev>; Fri, 07 Mar 2025 02:55:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1741344943; x=1741949743; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aFXBjMpQQucibqgokFHkSZnj9y5cZChrzp1Sa0fcrAc=;
        b=Zm+ax47C0915DaBvB61gBXdQLlaI9tEpUDZmJVrVHPJHYc1NENyjdKyQ6MqehmjXmK
         hGUjAX5cXP63Tm7SbIsREYUvu4RQLUIqmOkA9KJlKRHEbBSXj8C5HD42M7hZFbCM2MKS
         7z/iOGYN5Xd+qUZpnB3JqsRMm8L9GWKlY5xDB/2JlwtERyDG1PB+AUbYhgUHYLcAIKMk
         kdgSnNkhfFDGnrBYjYOR97cuxr6d6VnaQTVA+WkLXAmNwTzfqIpTbHOlCPOz4CzH+5q2
         fDwP5goDelplNb+s6Ptf07/GrlqgVdzM+S3YHYEhd5NzNP1prtQimm+HIET5Jbb38Ut1
         4lVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741344943; x=1741949743;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aFXBjMpQQucibqgokFHkSZnj9y5cZChrzp1Sa0fcrAc=;
        b=sw8dEXoE8/Vyz/G7XNxFe0jpSHtfWYBaD8wGP6rR0Ybxev9lOBmbqh9in1lpqRtPEp
         cl1K6k20zv+AZykHhRlJTFTEEkvQaqcBmKQjG/E4x23RooUrrg9kSL3zznnPMkp+iYZJ
         ThwPETmZe5LOpwkSWCuKeg5iBThTf2y5MWP31NrlhmxOsJwNx4SzNbpg626E4wxswcnX
         Njw3vuDorH6t1z6XHOzamZ0/INyP/TsBvWmikmPhN9Yzv7GBAxCH7DdI5Du5i9GoONSY
         fDeoY6+m9Kiu7HYK5TmppWf6d3jyk25CG18sP9bTXRNbt4/1grDxmZlYz0PFZhKM8YpA
         oP3g==
X-Forwarded-Encrypted: i=1; AJvYcCXxCVu/J8Bvy7jbKrkeYZN3kuFzCGdGwB2pFV295G3UEya0/X00CuXpME7waloR0tnvOU5fNlA=@lists.linux.dev
X-Gm-Message-State: AOJu0YzDm4VF8Ss2Zclo/sprrBu3OTchv46ihoODjI3uQvoOW6be+K39
	F7AJSF+6LWyB3ij4NetpaIjMqux7kAdT6HrdDzWrABZhYNOwMDYw/X2X29ZisK4=
X-Gm-Gg: ASbGncsvOQc0LIDYdOpDS6kZhL6e99WclBGxTp00Yfwf/vL7b8s1BsgM878vn20UItv
	/OLgus/kPzWwFOHdXcxE6XqPkeIQs3Rvo7kMuCBgfqNIqfi5wx/9dW+eX3dL8cqzm3zsvUbQdPC
	D38Z3cM9YUKOyiGQeVanJAN0S6nrBvQw6huPOyXJwMoCZHABAZzXqPmEYD34LvIg/6SWnm9N7va
	yucPJPmCDFv5iv5linXiecKcwZEejQxThI6CzA6AQP5qVpNGVcRs1NqhQXAHn2yzSWahkGDzlQU
	tEqv1f4NkxQis7nRJ3CdCq962JoeZOEUJ5kLtGGSrk2AT9lM
X-Google-Smtp-Source: AGHT+IEoXfkwPsJZHGHUH2StrQHAqmGfaA3Jdeh6jSgOLkAwNCLg5rn0a7T5je10X9eqSxa+av8pdw==
X-Received: by 2002:a05:6a20:1590:b0:1f3:47cf:514b with SMTP id adf61e73a8af0-1f544acd2b0mr5322641637.3.1741344943258;
        Fri, 07 Mar 2025 02:55:43 -0800 (PST)
Received: from localhost ([157.82.205.237])
        by smtp.gmail.com with UTF8SMTPSA id d2e1a72fcca58-736ab812cb0sm1257087b3a.164.2025.03.07.02.55.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Mar 2025 02:55:42 -0800 (PST)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
Date: Fri, 07 Mar 2025 19:55:29 +0900
Subject: [PATCH v2 2/3] KVM: arm64: PMU: Reload when user modifies
 registers
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250307-pmc-v2-2-6c3375a5f1e4@daynix.com>
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

Commit d0c94c49792c ("KVM: arm64: Restore PMU configuration on first
run") added the code to reload the PMU configuration on first run.
Trigger the code when a user modifies a PMU register instead so that
PMU configuration changes made by users will be applied also after the
first run.

Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
---
 arch/arm64/kvm/pmu-emul.c | 3 ---
 arch/arm64/kvm/sys_regs.c | 5 +++++
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 1402cce5625bffa706aabe5e6121d1f3817a0aaf..04eb3856b96576fad5afc8927c8916ff9738f9d7 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -888,9 +888,6 @@ int kvm_arm_pmu_v3_enable(struct kvm_vcpu *vcpu)
 		   return -EINVAL;
 	}
 
-	/* One-off reload of the PMU on first run */
-	kvm_make_request(KVM_REQ_RELOAD_PMU, vcpu);
-
 	return 0;
 }
 
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 27418dac791df9a89124f867879e899db175e506..51054b7befc0b4bd822cecf717ee4a4740c4a685 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1162,6 +1162,8 @@ static int set_pmreg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r, u64 va
 	else
 		__vcpu_sys_reg(vcpu, r->reg) &= ~val;
 
+	kvm_make_request(KVM_REQ_RELOAD_PMU, vcpu);
+
 	return 0;
 }
 
@@ -1322,6 +1324,8 @@ static int set_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
 		val |= ARMV8_PMU_PMCR_LC;
 
 	__vcpu_sys_reg(vcpu, r->reg) = val;
+	kvm_make_request(KVM_REQ_RELOAD_PMU, vcpu);
+
 	return 0;
 }
 
@@ -4276,6 +4280,7 @@ void kvm_reset_sys_regs(struct kvm_vcpu *vcpu)
 	}
 
 	set_bit(KVM_ARCH_FLAG_ID_REGS_INITIALIZED, &kvm->arch.flags);
+	kvm_make_request(KVM_REQ_RELOAD_PMU, vcpu);
 }
 
 /**

-- 
2.48.1

