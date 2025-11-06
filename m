Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 405503191D3
	for <kvmarm@lists.linux.dev>; Thu,  6 Nov 2025 14:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762440264; cv=none; b=VX2wGe4mMInM2YQ3R/eB1VJjPRSkXe6l+JLbNDeFyErlDhW0uqPtinkw417vmVAf2TuSf5u7EaIr3FMbSb38MfdFj0L1RzxdZRdl/+q23frxM5b98Q2iku55qbquA/dxDoadmVkDI8yxBaAWJVedhrU03sXfeVZmalRWbmSLNVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762440264; c=relaxed/simple;
	bh=ZEqN0UPvK3HCK09MSfR+qkub5GZsyBTz/VhtlYBy2S4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=saYhjrWea7W6G/SjS5JSMSShicACFiwDO5QaXk38H6pNNoCEjVbXLal640UTCFQOSD1wolAGLOktEWpFR9S6z45/4laFVuZA+LnBR5gfnHAn0b7+XVmwjGSYeG6Sj+2pJ2guS9Nhm6CpKlpIdW4bG/uAIiHsP7iBdyo9G4GBlBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OzT2nXNo; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OzT2nXNo"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-471001b980eso8138845e9.1
        for <kvmarm@lists.linux.dev>; Thu, 06 Nov 2025 06:44:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762440260; x=1763045060; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hQotLZ7bYQhnw+F+e2EgZGDV56Lv1I3QeSzBHAS6ry4=;
        b=OzT2nXNoiczHLv3Hja5+2tkDEw9aakJ7ngnyb/0LREobCmG4cl0laQ5RHVhzfvbpaH
         VrIrVc4Tb/cgoFGfGkm+pSGeOn7EVj71JuUihriRKC107T1ExpOhfCSzAiNJ94t1W7Cz
         +bMRW+UguoWoD5NOcLiuER1BLaw5X6ORsRO8iIOvz4E2/hTCSkMcmnL5cZZ3hOVzB1fk
         KMjIDDLFNJN7PusZDk1zG+rYsvRue0YK1ahJ4b5B6VIaiw/dNV/sCNiaMuCK3PeE5g7U
         7/urGaJNS6YFtm9E+MTqvImSEYao4tCTXWZuTugv6XgyX4KQ8q11WNrp1v8OWWxUo8rQ
         fcHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762440260; x=1763045060;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hQotLZ7bYQhnw+F+e2EgZGDV56Lv1I3QeSzBHAS6ry4=;
        b=CYGHQTCetfSRNb6End3eW6bnHAbWCE6wk9pqwr90pzc+HmtKQ+finvF9G1fqjzDz9D
         mm9BLYFcYpOw1IrKvykypA3cWOCe1suT6urh7fVhhPR0y6w/NLsgFkspxRdH2yyCCk0b
         dFTeMFsRK94/vdMx6SPTSW2PunfTvPd/8NzLO0+wvGZ1+p/ZOZQ1ecI0jNfzGNyuI5Pr
         3z1smgP7IKOnxeLAUInEvjxRAc8zLWPORz64/twHOrKzaOL9bnuGQxswLbxNELfj4pq4
         bca89akwcmRn6j30KdRIBLC7Ie0aYcHJJC+Rgs85CY1zJmRFzsTDtcE6giDvzDKBdv3p
         Z3LA==
X-Gm-Message-State: AOJu0Yy7aeUD3WW2OnId2WyJM/8qlS+Ilw6ENjp34ZvfhHIqgVa/TYRz
	lmvldIrcOMWjtL7Rm1E0Wh0RqPy2IP/YO4gnGnD7skRQx19YcKb/hXtF1IcTXc5EsaPG2lA0S1j
	QQxNtFeAnqGKkwXpJLda20LORddN1tziScMFOWz74dWJbMUT683UP8NKiQ50iEmIaDg64ukJTPY
	gfunaqRrKDrHp/JbXLgSgfPPrrWh8OXfg=
X-Google-Smtp-Source: AGHT+IG54VtmRITeyRodrpFjnkmMn9aKcd2SfV26fNYyANDC22/WKNUNo00I7Z8tR3a3z6jTuMfxSnvpDw==
X-Received: from wmfu16.prod.google.com ([2002:a05:600c:1390:b0:46f:aa50:d716])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:5291:b0:471:9da:5232
 with SMTP id 5b1f17b1804b1-4775cdc8eb1mr74506725e9.15.1762440260497; Thu, 06
 Nov 2025 06:44:20 -0800 (PST)
Date: Thu,  6 Nov 2025 14:44:14 +0000
In-Reply-To: <20251106144418.2847443-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251106144418.2847443-1-tabba@google.com>
X-Mailer: git-send-email 2.51.2.1041.gc1ab5b90ca-goog
Message-ID: <20251106144418.2847443-3-tabba@google.com>
Subject: [PATCH v2 2/5] KVM: arm64: Fix Trace Buffer trap polarity for
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

