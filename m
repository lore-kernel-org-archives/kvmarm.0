Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.69
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034188;
	b=D9Kyz3JZrhFNXY4H/qLMz65oaAxazjaTzBSOEuTKSpOVJ0QljsSRUJiz5Z8r+9XlDRvU
	 nbILyXEp0z9wpAY7CmrfCgUMawyAeABF1ikzfhNz3TtGNYvz3dv6rkKLsOtbc04kodC5M
	 DPDmPgBVbJRPAitsPXEPR3q0xP89ab30pWgeO4oF0mK4/wFhOsPjiu/TfX0Z/G22D/QZc
	 d40d1kdpU2BfC/e23YieIQRSl1MbzP1hmQ8F1vRnROh5S+QMSePgCk0TsbPpWfZj5AziJ
	 mMC3ugXftCRplsvOnf6xn1pDW6ZYRXgvPyKmN2AxzAyTwyqTcfb2v9PfE6vycqbVuNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034188;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:Mime-Version:
	 X-Mailer:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=Qy1Eigf44guJ94H2Vo/9twz2OBsSX8Dgz4PNAs3gw1s=;
	b=q7ZO6ZmnWY5A1P/8jewWi/d3E/qT3mVU/MRId+cPQwB+ERmFE+fm7y7a5dc5AoED9wfb
	 2VNYnPgZ5SVQLWssOwXW5WsB5Sl91f0QJgv2W0grbfX317MZt+iAV0KmiYTkoMjyff5E3
	 UlDqE8mK9g/eeT8LS6n/1h+6z1jpOT2jI+FoiN0cFkP95ISTyVDmBzHVkUQQD22G1rhX3
	 Ae29bSdSFpxM5DVATUXXbwX4Wt2WJxaFyVrSqEgGckJ/AJiLaZ/ZOhvuGZbPlAnoNzUkU
	 OZN5dMJBfIrvLwvyEVQbtK3iLlqqlv8v9Bmtv3+Dc7TnHMHBpfPey2tuASoO6D3ud0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Htho9D8D;
	arc=none smtp.remote-ip=209.85.210.69
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com [209.85.210.69])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D44260A2605
	for <kvmarm@lists.linux.dev>; Wed, 18 Nov 2026 20:36:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1D44260A2605
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Htho9D8D
Received: by mail-ot1-f69.google.com with SMTP id 46e09a7af769-862a8fcc3caso1471851a34.1
        for <kvmarm@lists.linux.dev>; Wed, 18 Nov 2026 12:36:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795034187; x=1795638987; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Qy1Eigf44guJ94H2Vo/9twz2OBsSX8Dgz4PNAs3gw1s=;
        b=Htho9D8DxfNiGcaaNdnWBvfDgaznu+SIPDjc/janVAIK1zOjauXHy/KxtAWFV1N+Ca
         dm5JzylqWZXC4+/a+M3NQxBMc+LN4mGOzAXBqke92EYvC+ZDm8B2JhZDx1IRfqWvyp0l
         MsngWDk+T4ESLGApr36vg3s+GSRSGmtlSI0C09Dg0/KWS02DiaEZepMg9ulzGms9lD5v
         8HHyhIN3w0New55HeFrtTUzVwbsaYXVrNo1eCXLbK/BQJSjksq2e0S8gmmPQ6FJWeqmR
         RadB/sXzblv03ybAEb4NPcx7DyokyaP4IG80lJmrAfSMpUg482BIbbi7Jywdy/rjRcoK
         GTyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795034187; x=1795638987;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Qy1Eigf44guJ94H2Vo/9twz2OBsSX8Dgz4PNAs3gw1s=;
        b=m0eJ07CE+ad72GksXJ+I46PtGl1OtStwQkak5n7JXiZV0w6BDiB66pRYad+Mq1dBEZ
         2eycroqGuUb0p0zkiQmRBl9wI1IIgSyIactwfr2dgzvRm9dweXi8EIsmstnhE6QklKVA
         GiF0iJUxW3xQ6qamGZ24DBncbp2r1ZIaH5E2dCs6wZdbZykSU40mb4FxlriLF85l3emH
         BRtWvYbDchbqyeMCR4aqleocc/aZge6RcKrfTo9OaP1E33pq7yrEVCB6AAVyNsxRm6BH
         yepw+STCrevFwJAIDQ9LnM0nR7nNjqrIv25LgeCKC6UobDJ/1DOZ8NFYSELDTwuU+5cH
         R6Ig==
X-Forwarded-Encrypted: i=1; AL+hErFgDG+yNemJkwToiQNe7hdDBJ9bLQnRPmq/GxPUKyGLi9g0h/O+QTEC8e6Drztco2UpTqjuQPw=@lists.linux.dev
X-Gm-Message-State: APuU4Z8dEdW2LMFFlbreNtmcTfXRVj1KTjQ5r0zcYdj2m+V86Xd2iier
	od1DabcTzuwyXmFtwXNaXh9tkFsLs5Gw4ne4+az0T9mEO4yOItmfjIS/97Mj1J2MSNH6RvVbyhP
	FHeyrMwiSuVyv3F9cD5q2lGXrkA==
X-Received: from iobmr18-n1.prod.google.com ([2002:a05:6602:a552:10b0:9d0:5c4f:1583])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:1925:b0:574:c5e0:3d1c with SMTP id 5614622812f47-5773f0526e9mr5231001b6e.25.1795034186651;
 Wed, 18 Nov 2026 12:36:26 -0800 (PST)
Date: Wed, 18 Nov 2026 20:36:23 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.1.708.g77570a6a1d-goog
Message-ID: <20261118203625.743428-1-coltonlewis@google.com>
Subject: [PATCH v3 0/2] KVM: arm64: Force HCR_EL2.NV1 to RES0 unconditionally
From: Colton Lewis <coltonlewis@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>
Cc: Leonardo Bras <leo.bras@arm.com>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Fuad Tabba <fuad.tabba@linux.dev>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

When commit b2a324ff01fe ("KVM: arm64: Use HCR_EL2 feature map to drive
fixed-value bits") migrated HCR_EL2 fixed-bit masking to hcr_feat_map[],
feat_nv2_e2h0_ni() was written as !kvm_has_feat(kvm, FEAT_E2H0). Because
ID_AA64MMFR4_EL1.E2H0 is a signed 4-bit field where IMP is 0, NI is -1,
and NI_NV1 is -2, !kvm_has_feat(kvm, FEAT_E2H0) evaluates to true when
E2H0 < 0 (including NI_NV1), leaving HCR_EL2.NV1 writable instead of
RES0 for VHE-only nested guests where KVM advertises E2H0 = NI_NV1.

KVM never supports a configuration where HCR_EL2.NV1 is non-RES0
(limit_nv_id_reg() exposes either VHE-only EL2 with E2H0 = NI_NV1 where
E2H0 is not userspace-writable, or FEAT_E2H0 without FEAT_VHE or
FEAT_NV).

Patch 1 drops feat_nv2_e2h0_ni() and marks HCR_EL2.NV1 unconditionally
RES0 using NEEDS_FEAT_FLAG(HCR_EL2_NV1, FORCE_RESx).
Patch 2 extends the arm64 hello_el2 selftest to verify via
KVM_SET_ONE_REG and KVM_GET_ONE_REG that HCR_EL2.E2H remains RES1 and
HCR_EL2.NV1 remains RES0 when E2H0 is NI_NV1.

Changes in v3:
- Drop feat_nv2_nv1_not_res0() and force HCR_EL2.NV1 to RES0
  unconditionally via NEEDS_FEAT_FLAG(HCR_EL2_NV1, FORCE_RESx) (Marc).
- Add Suggested-by: Marc Zyngier <maz@kernel.org> on patch 1.
- Add a comment in hello_el2.c explaining why RESx enforcement is
  checked from userspace rather than inside the guest (Oliver).
- Link to v2: https://lore.kernel.org/r/20261117204535.4036191-1-coltonlewis@google.com

Tested under QEMU 11.1.2 TCG (arm64, kvm-arm.mode=nested): hello_el2
fails with "HCR_EL2.NV1 should be RES0" on unpatched v7.4-rc3 and passes
with this series applied, with no check_feature_map() warnings at boot.

Changes in v2:
- Rename feat_nv2_e2h0_ni() to feat_nv2_nv1_not_res0() (Leonardo).
- Drop the guest EL2 MSR/MRS HCR_EL2 check in hello_el2 (Marc).
- Link to v1: https://lore.kernel.org/r/20261116200418.3535619-1-coltonlewis@google.com

Colton Lewis (2):
  KVM: arm64: Force HCR_EL2.NV1 to RES0 unconditionally
  KVM: arm64: selftests: Verify HCR_EL2.NV1 is RES0 when E2H0 is NI_NV1

 arch/arm64/kvm/config.c                       |  7 +------
 tools/testing/selftests/kvm/arm64/hello_el2.c | 15 +++++++++++++++
 2 files changed, 16 insertions(+), 6 deletions(-)


base-commit: aebb7274476403040d582c61478df8f4a7bf9cd3
-- 
2.56.1.750.gf70dc682cf-goog
