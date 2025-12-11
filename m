Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ADBD26CE2D
	for <kvmarm@lists.linux.dev>; Thu, 11 Dec 2025 10:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765450035; cv=none; b=RcFrgd2/Wp9Owzk1D+HB1qzwFLgD17fypqGaE9H0fTMH3V8tGNhnc9sJH9uFrjgt9vFTA7njQQCrjLx9Mcx5AN3JUqnDINNplcTaOffSW7kkqWF87qc3wwuMsGol2EtNWOuuG3vxNM6BYfyv0MxSsDR0HH4PFYG1SMu8PQNFgEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765450035; c=relaxed/simple;
	bh=iw8UzExvu9qTdnOXeAd92q/Aufrzrg/uELJciyEqEQQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hu0UK4TnNxBUIIvHuL6dJ/p7541famBaR5tLNhxVsrFEWQoQay2TbjUlcjOd4Lo6ZL1Sp8AGCEMrOoEyOC1B+k/Ruz3j5ChcWVfQsXCNXpSnmkP8pKpLEg0wEabWwlA8H1NKMGWby85jNnahDVL29/cEU448ofKbiqG6CAre4fQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=R+SyKsq3; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="R+SyKsq3"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-47921784b97so4894815e9.0
        for <kvmarm@lists.linux.dev>; Thu, 11 Dec 2025 02:47:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765450032; x=1766054832; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=kkwoqFxFyD3NTqkLTtawAgSOr5TM3pE6TGLZ488viKo=;
        b=R+SyKsq3OynyEv2cxkA69/zhGXh28kr/7TdSj51WpQ+3sTwVDf8uLQ+j3aVmP1F0yY
         WlYXFUzg6IwlIgsODW7XksmQ3Ny26pX0hgV/n9E/trVS00+U5aYyOUbE3ZtsGwpflSrO
         Fso4dUIBC1UfkXnv3rrTbxEnA8ppQl/LHxWH6Ply3z/8XVeGLjv8MiVHuNUV9U7zmM6/
         1gj67oM+4JmX71cL4rkHzAxqEDNXpDTnu/MALpu46Yc0bXlvoZ1yd8egs84P6lDBObgT
         iW5G49o2hHUNSyPbrpS8sVm8Tga2sL6G4egP98ks0fmtjMVOIBx/E9C3T7ly1XkDQJ4j
         vO9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765450032; x=1766054832;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kkwoqFxFyD3NTqkLTtawAgSOr5TM3pE6TGLZ488viKo=;
        b=ahEAQtJDxB5wLeQppURoqhezZBXdi6FW8vNqolnSJy/f49gFZsmWrO6A+ZkKrEAulI
         d8bysMJN6ZipdAD37NDOCKX++NHwfABfOJD2jJL2TDY4a5/sDzANJsRc2mhl8SxdhLJK
         qCXe2G8aSXqtlziXCN/Fvw5Q1UWfnMELF2h3ra5QAf8bEUehM27dQ6WshriY4Al7yfh5
         Jorl+yAYRGMHc8nlGe0d3P6Xs2zqHAGs23NEnyLbQTX06SLvl9LTGtsBzIrtAtfsi+RN
         KN65Ib7aDSIqtRc8W8C1GYexEnm7nNodG5XBQWBaAlv1idwbN9HKkjI4mV1vQbedK96m
         CuhA==
X-Gm-Message-State: AOJu0Yxn98kgBwK1epVB0weh0yzc5az4oxQ9zazqVPNvU5Xz6BOaEwHo
	75gNgzG+itOiL6yN1fREWxG3k/5JdvBpp0wIf4Dj575QNEP1Fmsm5I+zM1nSLefPDzCEpPoHnZi
	PtHpSrWhS+m9JLVptiU2Z36c/jSnT/ASIlKpMk/DcVJhyGd9aISKOLADyRXKj1peXgbv9e/N1hw
	YurBdo5PU8oj/zomwymeKQz6VHwW93Om8=
X-Google-Smtp-Source: AGHT+IFUK9qOhltxBwj/CqkUNy38yNFCB7+W2fU+SCaB3Rn2njvoxByJe2i60UDZ3pAyc0yyl1XO+MzqSQ==
X-Received: from wmhf26.prod.google.com ([2002:a7b:cc1a:0:b0:477:a0a1:eae8])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:33a9:b0:477:af74:ed64
 with SMTP id 5b1f17b1804b1-47a86a55951mr21200815e9.27.1765450032433; Thu, 11
 Dec 2025 02:47:12 -0800 (PST)
Date: Thu, 11 Dec 2025 10:47:02 +0000
In-Reply-To: <20251211104710.151771-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251211104710.151771-1-tabba@google.com>
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <20251211104710.151771-3-tabba@google.com>
Subject: [PATCH v6 2/9] KVM: arm64: Fix Trace Buffer trap polarity for
 protected VMs
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, will@kernel.org, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, vladimir.murzin@arm.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

The E2TB bits in MDCR_EL2 control trapping of Trace Buffer system
register accesses. These accesses are trapped to EL2 when the bits are
clear.

The trap initialization logic for protected VMs in pvm_init_traps_mdcr()
had the polarity inverted. When a guest did not support the Trace Buffer
feature, the code was setting E2TB. This incorrectly disabled the trap,
potentially allowing a protected guest to access registers for a feature
it was not given.

Fix this by inverting the operation.

Fixes: f50758260bff ("KVM: arm64: Group setting traps for protected VMs by control register")
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/pkvm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 8d06a246dfd1..f6f8996c4f97 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -118,7 +118,7 @@ static void pvm_init_traps_mdcr(struct kvm_vcpu *vcpu)
 		val |= MDCR_EL2_TTRF;
 
 	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, TraceBuffer, IMP))
-		val |= MDCR_EL2_E2TB_MASK;
+		val &= ~MDCR_EL2_E2TB_MASK;
 
 	/* Trap Debug Communications Channel registers */
 	if (!kvm_has_feat(kvm, ID_AA64MMFR0_EL1, FGT, IMP))
-- 
2.52.0.223.gf5cc29aaa4-goog

