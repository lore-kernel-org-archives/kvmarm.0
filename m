Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.200
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794948338;
	b=IEs20PjgItciKF2IYMyz/J2vgKN0NpGzrljpGp8gy07JLy6SSyRzUUOzdcKaYnY8uh7K
	 PDhcQpCz7o60mStXcH4VAX21uE83cqtb61vwh9quBPE+MuPkH8LDMvDEJTWMnjLVvVr2A
	 TwIVLcngN8nQrOZBsfcoBdE4+lJ2Ll5fHhPoYse5OgNn1MlbbeaqrdhWZpdk3X2amJFei
	 UCTpSbKLpyCXShY+KV4bFHCTYpyY4TyUlJaQOL3yv5oEU42u+U7pxF7P79LjCQPTFIeYq
	 xC5qPk7gu9pLu1iq5xwtAO4ZVb28onRdJvoqblWgFK+SmtkS3d2s57Cu+S3OOrVNfFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794948338;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:Mime-Version:
	 X-Mailer:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=b6mleucbMdhj8MjjlIVwGs8yhAGAA7tst/tBmXQB1UY=;
	b=1ADS8IHPcF5uYyhEbhCBmZ2vBKnCxCDReG/vKLzCiwuBVeRDRWyI6qidwYhX5LcWbp7R
	 zbqtV6kuXmibknCIsgDZwuYKlh1c2+FsY6GGXpbDamWyELGPdJsCFiEGhh7V8KIJ20Ux9
	 Gr1rHrjWbXEpZgnmZEVOhxrc7PZZEDF/2E7Q34IctoAFjZ2gkrmZEjm1+0XxOwQDSGwhP
	 uRYYA7jO9gXe/6KdzhMkN9VlPucqzPZI7rcJzkog+rvoCB5vdIbJ5wlnkibq49VyZSDRT
	 2e03Xg5ndQwou7cxnlHSCcsVTy8YmanGe2J/mLpDhrZn5w9R3C2Ho83AevxOeRWuH9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b="WyMX8/Qo";
	arc=none smtp.remote-ip=209.85.167.200
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE38B606A31C
	for <kvmarm@lists.linux.dev>; Tue, 17 Nov 2026 20:45:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CE38B606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=WyMX8/Qo
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-5384e381fbbso129323b6e.2
        for <kvmarm@lists.linux.dev>; Tue, 17 Nov 2026 12:45:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794948337; x=1795553137; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=b6mleucbMdhj8MjjlIVwGs8yhAGAA7tst/tBmXQB1UY=;
        b=WyMX8/QoPnV8hMMlOhnULn18Mwm1bvsCBZFaavQihOBrK5B0GxY5+hJJSsC2rpMBDV
         qkJqlEJjCUcRXTBr0kRg6taE5j+YUpt8KtM/NP+ijrcgXdcCCX0jiVKXoAtCiUP2oIi9
         2vy2xU+H+QJplWrxBfJKnA5R6sDdUf/q2L461bh+qRs0U9FZQiubmMSPcmo3ME4iAHav
         mbONbMTjJTDlcC5qo2pQThW23gNtQ0oCkIpBHxwptnvapJ67UyGPe05vkrShjZoujD8W
         1jUph6DqLMRlrP9b15FvS3qhO/cp2hi4lnBLsgKQdJZuGD/WGBICrHwCBUmiakA73uQe
         lL9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794948337; x=1795553137;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=b6mleucbMdhj8MjjlIVwGs8yhAGAA7tst/tBmXQB1UY=;
        b=xPRmtH7sc6OirUBghJJNyOXvnC9eNiyl6oYUyInMHTYQlpt6GGLEEknef581FzFBMJ
         UCUA+iIR6LF/f0Vtxy/+jSo6GsMAye+RpRwZnuhI2pACPFwH1FrRK9ckM/iEiTYSFiEi
         STBdbJPc2rKd/JTj2mbaQvQkaqtyuoSxsnmfxy9iqX7qMTD63Pf2xtcyuh9dSV4AsQ47
         OSaL4FoVbm/K7dX93aOGbxJWgkD1sHl/Q3HqZXueBg1w4QVRglZc+sYPDP0VLmxD6bRg
         raUP/NXTM+N1RJML7WuoTG/7xOTomyfUkcNcTmNAlTvLATVyRWmpTpnMDcIZRpJQUze7
         ruJw==
X-Forwarded-Encrypted: i=1; AL+hErFmPP4X0d3F8wSM7tRN3Ca58Yxc1aW8w8N4GCnWQIRiYEoKr3kzo3/VEZdnlgaec9S3f0xmeCw=@lists.linux.dev
X-Gm-Message-State: APuU4Z8r7LJ87Ujst5LyQkqegVcF37sJe3m3A5ygRnmIrTYGE+Du/LTL
	+sbGRfC0XR07Uwcf6TkAiU1cWVt961UYDO+0tnpGyTAr1j6VXb39S3SNyULKAtgSdXAFa3s6vFm
	CKmxoydXDN96RT78hVwN5bsu9Dg==
X-Received: from jajg7.prod.google.com ([2002:a02:c547:0:b0:61f:ecf1:1cac])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:1387:b0:4c3:e93e:e331 with SMTP id 5614622812f47-5774113234amr977571b6e.30.1794948336458;
 Tue, 17 Nov 2026 12:45:36 -0800 (PST)
Date: Tue, 17 Nov 2026 20:45:33 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.1.750.gf70dc682cf-goog
Message-ID: <20261117204535.4036191-1-coltonlewis@google.com>
Subject: [PATCH v2 0/2] KVM: arm64: Fix inverted E2H0 check for HCR_EL2.NV1
From: Colton Lewis <coltonlewis@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>
Cc: Leonardo Bras <leo.bras@arm.com>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Fuad Tabba <fuad.tabba@linux.dev>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

When commit b2a324ff01fe ("KVM: arm64: Use HCR_EL2 feature map to drive
fixed-value bits") migrated HCR_EL2 fixed-bit masking to hcr_feat_map,
feat_nv2_e2h0_ni() was written as !kvm_has_feat(kvm, FEAT_E2H0). Because
ID_AA64MMFR4_EL1.E2H0 is a signed 4-bit field where IMP is 0, NI is -1,
and NI_NV1 is -2, !kvm_has_feat(kvm, FEAT_E2H0) tests E2H0 < 0 and
returns true for NI_NV1 (-2), leaving HCR_EL2.NV1 writable instead of
RES0 for VHE-only nested guests (and conversely treating HCR_EL2.NV1 as
RES0 when E2H0 is IMP).

Patch 1 restores the check to kvm_has_feat(kvm, ID_AA64MMFR4_EL1, E2H0,
NI) (E2H0 >= -1) so that HCR_EL2.NV1 is implemented for IMP and NI and
forced to RES0 for NI_NV1, and renames the helper from
feat_nv2_e2h0_ni() to feat_nv2_nv1_not_res0().
Patch 2 extends the arm64 hello_el2 selftest to verify via
KVM_SET_ONE_REG and KVM_GET_ONE_REG that HCR_EL2.E2H remains RES1 and
HCR_EL2.NV1 remains RES0 when E2H0 is NI_NV1.

Changes in v2:
- Rename feat_nv2_e2h0_ni() to feat_nv2_nv1_not_res0() to match the
  condition it checks (Leonardo).
- Drop the guest EL2 MSR/MRS HCR_EL2 check in hello_el2, as RESx
  read-back from the guest is not architecturally guaranteed to return
  the effective value and ID_AA64MMFR4_EL1 reads do not necessarily
  trap without FEAT_FGT (Marc).
- Link to v1: https://lore.kernel.org/r/20261116200418.3535619-1-coltonlewis@google.com

Colton Lewis (2):
  KVM: arm64: Fix inverted E2H0 check for HCR_EL2.NV1
  KVM: arm64: selftests: Verify HCR_EL2.NV1 is RES0 when E2H0 is NI_NV1

 arch/arm64/kvm/config.c                       | 7 ++++---
 tools/testing/selftests/kvm/arm64/hello_el2.c | 8 ++++++++
 2 files changed, 12 insertions(+), 3 deletions(-)


base-commit: aebb7274476403040d582c61478df8f4a7bf9cd3
-- 
2.56.1.750.gf70dc682cf-goog

