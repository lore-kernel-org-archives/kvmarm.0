Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49ECB1096F
	for <kvmarm@lists.linux.dev>; Mon,  1 Sep 2025 14:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756736178; cv=none; b=RH0NYymHIbaycTn0MFUrKg5WlUeY6P1PBTEHT0wxOSQElWoJyDg17nh7nE3VZEOhDUy90wBf0GRqC5eMn1osFLXLv3rkqxO72p+Nixcyfhv9MTXsqYAgnhsiLfXbUw99hd7zIcBjTQVv7ySVIahW91CYKMEvE4RKcy2G3T3zpXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756736178; c=relaxed/simple;
	bh=J6adxaMTbKmeAjhW+nOvDYWFj4xMGaf6efDHsjIWpX8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=oiqeh5hPuvALmgzpvOf2a50UbP65CZ9IOX3tPU0Ve+jATvty6z8/a4D1zWG4Td11vBhpvfhigyyLRKgA/I4+Z3ix1m58SDjAERxFFR5qUeKY9/432OJjorj+8W6VUgORcn7nb0W5R394BmAIu0wBb/V7vhU8HVznQQ/oLjrHi8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TXFi6YxC; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TXFi6YxC"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-248f2da72edso9184795ad.2
        for <kvmarm@lists.linux.dev>; Mon, 01 Sep 2025 07:16:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756736176; x=1757340976; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=olATEhuJ7Rj0q51m0msTdMRcBctLQkkJ/hDbLCgUHPE=;
        b=TXFi6YxCF89axylGi/LpH675mxSe8HoXm4V7V3YWr/Lc+BR5UqUDIyzAhVOUYZyoq6
         jyFyl/Xedve5Z+E1Md/MLqy33+7SCoT0NHczFjpHmsAyoK9wLGc9VUvNm6bFLhS2qDP3
         o3tP+si1b6IooVNTfaL1G5oDKpLL+PVZ915O6qtwrCisqS40X3CT5I++mCp034skaiMR
         YPwZjmEIWtgTd5zTQ95JT98AO5+eWtJ1emmg9HOxdFRRogK/6bu6hoV75KvUlq0JG3NK
         W4cLqpryEwHRhj7LTLTeR5Z+XIZW65UN2RVn4uqP+D68bg46zZ48F6Qy3OlPFjUspt0Z
         0JvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756736176; x=1757340976;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=olATEhuJ7Rj0q51m0msTdMRcBctLQkkJ/hDbLCgUHPE=;
        b=LjgJCFRqLkDX9jgHMlBatl4vUVlO8x8wgQQrJAuAOaAA3rRbHecoxGCQ2nCe4OKk/S
         kvy7WvoN79fNQoXO+hjYqIot+YBDXRwyo+3bG7OoYmiXYm5r5glIrSirWPaKNc7XYsUr
         hzrHigJmtJV/aJH1CyFUMMAbVZvHsWMIqQhxVXmOcIbWA3giK4xK/e+JlogaJKi1YOt0
         jyW3k3/3z9CHcj2pNjszY2gepLWK4yR1pK5mzgy624J3XoJcrntsdiDtaWc/u5BCjkY3
         0flCPVJo0NqV3rMkPpu5ReCKIGWkI/qr+wtDoib/rzcIZYuUzwi3+gBgG0vaDZeU9spV
         mU/A==
X-Forwarded-Encrypted: i=1; AJvYcCVgGQ4kl5AckCPzppqr8x68S5l/G0qONtoJGx6AkFsyCZr+FELxN/S7JVRSUNyRkaVasF+UlyA=@lists.linux.dev
X-Gm-Message-State: AOJu0YysWtJl7q/1c+ZCyH72HFAShm1W/leUxg0DDudfsiAr51AuvHWy
	/RScVNNuYC4pMuCZ5eymuNJIpGbr1xQbbxyVy1GqPGprrsa9S/D6aKI0
X-Gm-Gg: ASbGncswuvohKgk9833Sb6OB78FM9yVXlvYARbjf63Yng2EWa+eMBNkpdP+q+KbZ4yM
	a29QuRiUaxP+ZrJjErcqEFsf1BPFvBzQZ3UDra/eOmuVy+cScIV7LtC44ltSxWtFLSa6UY7OL71
	vRFfBEZ6P+xsDuRFiYEn0PinkBMBVRg8RfOezo+SGH4EmOcB4ArN9qMz2vUbY6yixm22W6o7mFV
	7qHARPyyv1vr9OOPO8TtsK+9peuZcBpJan/LZhKq60yTTIKeEZMmeMwlPtPaA1e4uMYdGCvr1oM
	VSBfO5r2/IrrBrSoEDKaUHz5r9gheKXJYjgts93DgWF/fYC7m8hkiiC3PDSvoztcmWN4cWAptdi
	+8kiQxLitn8rjrHcFxPbRwt4=
X-Google-Smtp-Source: AGHT+IHf7G+mUAagKO2yJzD5uM1O7o4u98GK3mA53rtvl6kubMMUObA8Y6uYeXML8+HaH3iMeRvPFQ==
X-Received: by 2002:a17:902:e74f:b0:246:ed8f:c63e with SMTP id d9443c01a7336-2491be7d2a2mr85172585ad.0.1756736176486;
        Mon, 01 Sep 2025 07:16:16 -0700 (PDT)
Received: from localhost ([106.101.139.14])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-24905da1b35sm106729755ad.84.2025.09.01.07.16.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Sep 2025 07:16:16 -0700 (PDT)
From: Gyujeong Jin <wlsrbwjd7232@gmail.com>
To: maz@kernel.org,
	oliver.upton@linux.dev
Cc: joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	wlsrbwjd7232@gmail.com,
	gyutrange <wlsrbwjd643@naver.com>,
	stable@vger.kernel.org,
	DongHa Lee <gap-dev@example.com>,
	Daehyeon Ko <4ncient@example.com>,
	Geonha Lee <leegn4a@example.com>,
	Hyungyu Oh <dqpc_lover@example.com>,
	Jaewon Yang <r4mbb1@example.com>
Subject: [PATCH] KVM: arm64: nested: Fix VA sign extension in VNCR/TLBI paths
Date: Mon,  1 Sep 2025 23:15:51 +0900
Message-ID: <20250901141551.57981-1-wlsrbwjd7232@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: gyutrange <wlsrbwjd643@naver.com>

VNCR/TLBI VA reconstruction currently uses bit 48 as the sign bit,
but for 48-bit virtual addresses the correct sign bit is bit 47.
Using 48 can mis-canonicalize addresses in the negative half and may
cause missed invalidations.

Although VNCR_EL2 encodes other architectural fields (RESS, BADDR;
see Arm ARM D24.2.206), sign_extend64() interprets its second argument
as the index of the sign bit. Passing 48 prevents propagation of the
canonical sign bit for 48-bit VAs.

Impact:
- Incorrect canonicalization of VAs with bit47=1
- Potential stale VNCR pseudo-TLB entries after TLBI or MMU notifier
- Possible incorrect translation/permissions or DoS when combined
  with other issues

Fixes: 667304740537 ("KVM: arm64: Mask out non-VA bits from TLBI VA* on VNCR invalidation")
Cc: stable@vger.kernel.org
Reported-by: DongHa Lee <gap-dev@example.com>
Reported-by: Gyujeong Jin <wlsrbwjd7232@gmail.com>
Reported-by: Daehyeon Ko <4ncient@example.com>
Reported-by: Geonha Lee <leegn4a@example.com>
Reported-by: Hyungyu Oh <dqpc_lover@example.com>
Reported-by: Jaewon Yang <r4mbb1@example.com>
Signed-off-by: Gyujeong Jin <wlsrbwjd7232@gmail.com>
---
 arch/arm64/kvm/nested.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 77db81bae86f..eaa6dd9da086 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1169,7 +1169,7 @@ int kvm_vcpu_allocate_vncr_tlb(struct kvm_vcpu *vcpu)
 
 static u64 read_vncr_el2(struct kvm_vcpu *vcpu)
 {
-	return (u64)sign_extend64(__vcpu_sys_reg(vcpu, VNCR_EL2), 48);
+	return (u64)sign_extend64(__vcpu_sys_reg(vcpu, VNCR_EL2), 47);
 }
 
 static int kvm_translate_vncr(struct kvm_vcpu *vcpu)
-- 
2.43.0

