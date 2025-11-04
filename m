Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB15B2EC54B
	for <kvmarm@lists.linux.dev>; Tue,  4 Nov 2025 12:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762261153; cv=none; b=NJZ0Xhi8DrQhXJ8l4POjsMaCy2DXxmvKnR//dYKcsZQ53ABNRRPE/Ad/v23+YpDEwEKlEO7dnvvICpCQzVLSSNWHduUAkCKFhnQL2RzRUXSBWMS9iO3bzMPivLiT9UdrSLNtWHTQiELKUvHZBXJbTK5gu+euQ8yR36hx4UM+Izk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762261153; c=relaxed/simple;
	bh=zXwiGBu1Wa3pxrKFg8GSbAxcPJTyKlGWFLpR/NOyQGA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tRVMFVacSUpZyFQkzSLPdbuAQM+Ehw3VftI45f4A1NOCd3iX0NF7XHs4XLh8yS2796JI3peZWn3mO//RK/2sgynkV3RMs0T5/6qZOMWoilFxbgAXIweAppnznHfzB8gnA5Mv1JNQDm4IsHI9Rs9rQ/Cnv89xf1nZhMdyh2M8nwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YLaSbfv/; arc=none smtp.client-ip=209.85.218.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YLaSbfv/"
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-b7067f229b8so437636866b.2
        for <kvmarm@lists.linux.dev>; Tue, 04 Nov 2025 04:59:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762261150; x=1762865950; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=LJJKUukmtYQaIR/sVFEBxkRB48geEpUtcVd8LHPTx8U=;
        b=YLaSbfv/u1X2FvVf/jc1eOT+YeMmPsvud+tWyy1PnXDvrCx3GIpQPbyXtIOPIRgzRA
         RmMpVWW+B+hmVUm9Q1opuIJQfRBrcNKRxh4CxrliLUdP2y40E6cNJdZLanCDQJwxGKH0
         3tBHNgUCJ+fbK6q/2vVEXFX4NmFb7EWHLJx9viEZwGX5SV4psEZrhcETgA12JXCsru5w
         AFFfP9/5SaWcRT3Krgmm83/JAO3n7cfGlIC5BZ052OxYwcnIg/5SdRTAo3WmERj4q6J8
         Ix+UQNzzM5/dr0xg11tmIQuihVzAoA/UjarXZl+KFsLfiqb9yIYVNNkQ6RmXFvJIKGyt
         RV7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762261150; x=1762865950;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LJJKUukmtYQaIR/sVFEBxkRB48geEpUtcVd8LHPTx8U=;
        b=cEd9HvO5IN7TWzYio/me+fSdxPc1MbYKhQtMtg7ji33WOHCnTnClD09MYoa4Jvb37I
         5Cb2siz1W0N6lmVBtCTfypxwP/FjKToJ4BMbhiVBlM1HnRLDmfQFESGCvMPL2zmjcLkh
         8LUFqiJSS+//WA7olV0VtAgBegOsGZ0BxtbzT3hXSpGOD5rTxs+c76kE9zQK2kr1UTSx
         /jpmKdhvtanKfW/zyF66Qzfwu3otxmuzMR0Up8pZEfcCRT6lXzPPqthByafTM3IRvopH
         GnMPWIpZEGN6GubxgEPl/AOw7oVKiHsmHNSfOlP5ec/d4b9jEwSqE1t+AyCvtfj43TwQ
         zryQ==
X-Gm-Message-State: AOJu0YxkdazD+oEpeOGnJcqPk3qzomhLiut8T1Xymrk9pgt6QoPD79st
	iF37KocjSmOor8Ex4pG8nM1eDiC2XMsI6nvPPR7qMVaqYY5WOGjbNtwg+IGCSMhIKTcjtNYHHk+
	e62Cr77o+CGIw+R+lIMwZOs/UUD+u5rFHWJukDgOVSFbcZmEO3hxOxIG/Q1kA1LU4kWXVLNGaPn
	DeOOIQxsDn8dfVL+V3Bf/R8K7M+GVLLQM=
X-Google-Smtp-Source: AGHT+IEOdP9iyZ5It5atgbSWlljHc9y9jZHiLNUJy7POzcoGzX1zV2NPRsvVKQQy6yVLSjs2DTh56cEzgw==
X-Received: from edrv26.prod.google.com ([2002:aa7:d65a:0:b0:640:6b4f:f86b])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:3e11:b0:b64:8464:68cb
 with SMTP id a640c23a62f3a-b70700d1daamr1861128866b.10.1762261149824; Tue, 04
 Nov 2025 04:59:09 -0800 (PST)
Date: Tue,  4 Nov 2025 12:59:01 +0000
In-Reply-To: <20251104125906.1919426-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251104125906.1919426-1-tabba@google.com>
X-Mailer: git-send-email 2.51.2.997.g839fc31de9-goog
Message-ID: <20251104125906.1919426-4-tabba@google.com>
Subject: [PATCH v1 3/8] KVM: arm64: Enable LS64 instructions when supported by guest
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, will@kernel.org, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, vladimir.murzin@arm.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

The FEAT_LS64* family (FEAT_LS64, FEAT_LS64_V, FEAT_LS64_ACCDATA)
enables support for LD64B, ST64B, and their variants. If a guest is
advertised these features, KVM should not trap accesses to these
instructions to EL2.

This is controlled by the HCRX_EL2_EnASR, HCRX_EL2_EnALS, and
HCRX_EL2_EnAS0 bits. When clear, these bits trap the corresponding
instructions. KVM did not set them, which would cause guest-supported
instructions to trap.

This also created a state mismatch for nested virtualization, which
validates its own HCRX_EL2 value against the features advertised in the
guest's ID_AA64ISAR1_EL1 (in handle_other()).

Fix this by checking for each FEAT_LS64* variant in
vcpu_set_hcrx() and setting the corresponding HCRX_EL2 enable
bit if the guest supports the feature.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_emulate.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 3fc62808c548..7880e8290a20 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -691,6 +691,15 @@ static inline void vcpu_set_hcrx(struct kvm_vcpu *vcpu)
 		if (!kvm_has_feat(kvm, ID_AA64PFR1_EL1, NMI, IMP))
 			vcpu->arch.hcrx_el2 |= HCRX_EL2_TALLINT;
 
+		if (kvm_has_feat(kvm, ID_AA64ISAR1_EL1, LS64, LS64_V))
+			vcpu->arch.hcrx_el2 |= HCRX_EL2_EnASR;
+
+		if (kvm_has_feat(kvm, ID_AA64ISAR1_EL1, LS64, LS64))
+			vcpu->arch.hcrx_el2 |= HCRX_EL2_EnALS;
+
+		if (kvm_has_feat(kvm, ID_AA64ISAR1_EL1, LS64, LS64_ACCDATA))
+			vcpu->arch.hcrx_el2 |= HCRX_EL2_EnAS0;
+
 		if (kvm_has_tcr2(kvm))
 			vcpu->arch.hcrx_el2 |= HCRX_EL2_TCR2En;
 
-- 
2.51.2.997.g839fc31de9-goog

