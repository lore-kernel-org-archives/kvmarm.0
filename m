Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A80837B3E1
	for <kvmarm@lists.linux.dev>; Wed, 12 Nov 2025 09:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762939257; cv=none; b=OhtRzeGKh+sydbx955MDi2ab3tycQOxVQC2X+nhLAVSm1rW33o48s+5yjuLXlrLt9IABnynTgXjugwUvUdgW1NwvOpGHclrE1vCl+tq1miIOA3IpSS/GCielMe/p5FC+AJqwxUeVukVjqFEIoB085Ufqx1QZ2ka3dyd/spkQLbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762939257; c=relaxed/simple;
	bh=ZEqN0UPvK3HCK09MSfR+qkub5GZsyBTz/VhtlYBy2S4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Zxlq1KmLd7SDsef5M72J8YBZP2FP+ZlEkf8EYl/D2bE3rKlAz22MAWDHx/nWRrQwift6mBna5K9LAp44CLQh80K0thWJ/gBBlB3NIu6bHtR6o055ufzWCelOrALKvjgtJVjojTdAMIVeC7TIEfVlfKrzF/ZF6lT9iCPvi2lQ7n0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=igKpxhbp; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="igKpxhbp"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4777b59119dso5171045e9.2
        for <kvmarm@lists.linux.dev>; Wed, 12 Nov 2025 01:20:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762939254; x=1763544054; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hQotLZ7bYQhnw+F+e2EgZGDV56Lv1I3QeSzBHAS6ry4=;
        b=igKpxhbp7muUci+ABwJxu4uugJXIZuhkjy64wRV4E+jyGgCy6w8g6retljvWUllFV6
         Ii0UsPeWpcVN6p9T9CH04GMUalOc3UsGOQ83LxjBpjjdnOuY3SQd5ThpO0yxFBAmDMcu
         DB247gouAHpX15K2AGItM6xeIA15JHZqbc4BhJ2ErhRUjIyvAuLVz+HhfkI6rVkJMsHb
         QP63jHHZHzWdpyn1eaboPjDUn5cTyfPo2uLy3kTDQ/+hBJPwtiIKB8iY0iOXdiX5umrh
         sQUrDLqs/Ow7F/PxXr7Gal7t3anz012vF4+pgyEy8k6Y2i2N+RxHtGoBqgK1tvsZn1P5
         Y3mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762939254; x=1763544054;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hQotLZ7bYQhnw+F+e2EgZGDV56Lv1I3QeSzBHAS6ry4=;
        b=xFIctGYu43kIE0+5XICZT4TGc1WxBM1Gia/yEoXi8TA6he6Ze59IK5fEy5FL3Av9j6
         r7qYEU1cr54AYXAiN8dxP/dtaHf1xYIyyRWhnesEd/WJiFGcvKAsJiGd/Wvet3MsJmvS
         rEEhG+bB1bH4sz21NmWNfBMn9WDvaXeoQoJiRP00KWWgn5wMO6hxnDSH7IklsDN52goW
         gbgt68/ixGGC3t3xYx9IxLHl28lWVCEEXtKrKtZHQ3cx+xcGjSM++OHtGwDlYba5iCdm
         1e5GFAFMJIElEwmNK8mvNQ/7moVTzw1TYfYF48JJr2tf7lPj5zx32FlLLAhz4rddKcdo
         HDUQ==
X-Gm-Message-State: AOJu0Yw5IjtAnS9HMViduPtVSnibuvecF9zSrNRB979Qi1IsDWTwsCio
	qbDPoOo9rIU9xlvqUJP5PnKh9iRUuukfmzgbGjd+nLBUZV/rzLYBR2++KcE0OG5W+LXNkxCanff
	5DAHNeT1ryeiSKFgCYu8FdKC6tpccl4izfpZdY8PkF9E3x6uc2w8219omXRxK9YAiQ42uOAWkyo
	cfnSY8R81F+aciURR4x5visF+4OwbWDtg=
X-Google-Smtp-Source: AGHT+IEdhQH8jlroYKYvxsaYTlWqQTwHspf9KNTFXBGWy9dvL6TNub1QcuZfnvQ1vjy2EWftQq8lAjgPlA==
X-Received: from wmqu15.prod.google.com ([2002:a05:600c:19cf:b0:477:1022:3342])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4583:b0:477:54cd:200e
 with SMTP id 5b1f17b1804b1-477870718c2mr21893365e9.1.1762939253822; Wed, 12
 Nov 2025 01:20:53 -0800 (PST)
Date: Wed, 12 Nov 2025 09:20:45 +0000
In-Reply-To: <20251112092051.1376245-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251112092051.1376245-1-tabba@google.com>
X-Mailer: git-send-email 2.51.2.1041.gc1ab5b90ca-goog
Message-ID: <20251112092051.1376245-3-tabba@google.com>
Subject: [PATCH v4 2/8] KVM: arm64: Fix Trace Buffer trap polarity for
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
2.51.2.1041.gc1ab5b90ca-goog

