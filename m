Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.70
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794948339;
	b=fdobBlQLu/hyiraBvUOBnjG0owUTKKSNQFWPVLJQufw6RxYSAvF80v0RqoM2Nc2Ohxvg
	 Y5KO0XsAuzu1FEDQeXvllbEDr0YWsUQhlkm2C3gjCON/37keUUyuhSCRRZy6ZIjZCw/SP
	 hU2slZ/9NKO8zd3DSPwAi06Pw3J5NEIZM/gy8mNiwWpoAJSrlqgKGNF9GWLYvhKU24sjl
	 yAtcDHyzlSLWKKeH5FNnUEJsGlVddHZPuhAXxEYApN3tLi3qxSEKmthzdh5GYQPd1/7/C
	 vGXqYXQTac+AmuHemsuyfjOrPYQMSPbmsKCUEFRPA6kK3BPD7FllCLvuzhjKb6YWhng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794948339;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=HGXQysssI9IIITPAFgPzUZG2M/Bh6Ayigq869gs8CCY=;
	b=YH8MWcZWi1xxoEhkABx3vUOmnehRU7c/hzIORp1pwiZyvBfA2GOqrvHsFBmtrbylp26b
	 MRecyZYC24y8N6eUhECoMJ+iSHK1XTxVJMM27Afoj2p/Wku8XSrxNmtjU6cLZ/xZUY8I0
	 tea9sTze2DSG4kgEjtbcraAubMZBfnk03/dNfl1igEgqNUbYcuzKvjVKQmNlKqPWHYXWA
	 L2TShHt1B+xCc9y+i6QnW4I93eUVzWQJFB7Wl22rnSoKWaPb0QqzwN3Xkyi+RR9zf2daS
	 KWn4DQUjCoCPr9ghgO2lggujugw+wwfsLInqqMwish/jKb4bJgD0rliZRRk6JRIX2rw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Bbi2+DpG;
	arc=none smtp.remote-ip=209.85.210.70
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com [209.85.210.70])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5526606A334
	for <kvmarm@lists.linux.dev>; Tue, 17 Nov 2026 20:45:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B5526606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Bbi2+DpG
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-8626dd59f73so239785a34.1
        for <kvmarm@lists.linux.dev>; Tue, 17 Nov 2026 12:45:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794948338; x=1795553138; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HGXQysssI9IIITPAFgPzUZG2M/Bh6Ayigq869gs8CCY=;
        b=Bbi2+DpGNrg7mt9ChfF48bYp/DToSyeBXDWCMx0Ce/IZW6+Z+dVMBCJsCjM6V8eG11
         A18TA4zmPwE187fVqip3C5KrmjRsnf3wkXr5bqHs0iAP+zmP7z9m2u7MPRo59fNQzAHp
         ozjrqrSPYaWXdExF/DF0fY/qHBjE9uQ32QW5AF1QetQcEo0gufLR0JmmP2AgKi+AocUF
         U/4c6eLpaNxzVmeSXb6hUZV0zvJEucIT0yPwDIZzl7cyECnCDoLToNfL6eAkvU2aVNa2
         XCAvHeSD0tBLU3L50uKMMzt6EVNcJRcgK6KEOrQmjW47p1sWE/uUk7OD5azqx6zQFHcJ
         BJ8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794948338; x=1795553138;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HGXQysssI9IIITPAFgPzUZG2M/Bh6Ayigq869gs8CCY=;
        b=Vrrf6o6qC9xG5shpu2M/o7Ul6++idnIrIhI6EuW6d9bwBvmm2RokXn5duQ9NUcrRDs
         8mLxDEmB84Sm0IfNsqv5aL+cjpxTAiuu4SYxT72DSteGGqggSynpzAQgN5N0AouyQMgh
         c9OJJfyxMQ0Vvz4qzI+ab7Cc+vxWKyy2Qib/pGPPml8UXe1wVB63cP/luAkl0oyI3yiq
         XI8RQZmgWsVr5ksHRL+ihJ0zDGtT+2UaXeX+nx5vRVjoQs7wyL2+CpP2zLIGXKIkgagz
         9XTZhZse0+OAmeQ0cBZE5OAxPTqleFX3vheIAtB3Q3A8A0z7p2bbDR41c0RWGa173CPf
         9hCA==
X-Forwarded-Encrypted: i=1; AL+hErFKpZy/OMtP1ot3RWiYjjfRk2Re18LGhkXantG4Aqp+T6yIpVPt1iazv6sJ0aFPYsCv7qrF1R4=@lists.linux.dev
X-Gm-Message-State: APuU4Z/kZe8ODD6c3IQr6xEHI9Ss9KN5ijqN2QBlq0Vdq0cozqWwbzNJ
	5T4rcVrhd2RX4OEWh1Z4F70u9aTNvO4F5f8Mkzc9tcz71XjLl9xEUPjxFOMwunXuFlJ4Y04q/Lh
	8KsK1DqWPLSH/mOeN1gJTgB3T5g==
X-Received: from ilnd10.prod.google.com ([2002:a92:d78a:0:b0:543:4359:a143])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:bc9:b0:574:524d:f242 with SMTP id 5614622812f47-5773c52675fmr1094757b6e.26.1794948337558;
 Tue, 17 Nov 2026 12:45:37 -0800 (PST)
Date: Tue, 17 Nov 2026 20:45:34 +0000
In-Reply-To: <20261117204535.4036191-1-coltonlewis@google.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20261117204535.4036191-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.56.1.750.gf70dc682cf-goog
Message-ID: <20261117204535.4036191-2-coltonlewis@google.com>
Subject: [PATCH v2 1/2] KVM: arm64: Fix inverted E2H0 check for HCR_EL2.NV1
From: Colton Lewis <coltonlewis@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>
Cc: Leonardo Bras <leo.bras@arm.com>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Fuad Tabba <fuad.tabba@linux.dev>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

ID_AA64MMFR4_EL1.E2H0 is a signed 4-bit field where:
  - 0b0000 (IMP, 0): FEAT_E2H0 is implemented.
  - 0b1111 (NI, -1): FEAT_E2H0 is not implemented, except HCR_EL2.NV1
    is implemented.
  - 0b1110 (NI_NV1, -2): Neither HCR_EL2.E2H == 0 nor HCR_EL2.NV1 is
    implemented, and HCR_EL2.NV1 is RES0.

Prior to commit b2a324ff01fe ("KVM: arm64: Use HCR_EL2 feature map to
drive fixed-value bits"), kvm_init_nv_sysregs() marked HCR_EL2.NV1 as
RES0 when !kvm_has_feat(kvm, ID_AA64MMFR4_EL1, E2H0, NI), i.e., when the
signed E2H0 field is less than NI (-1), which matches NI_NV1 (-2).

When converting HCR_EL2 to the feature map, feat_nv2_e2h0_ni() was
written as !kvm_has_feat(kvm, FEAT_E2H0), where FEAT_E2H0 checks
E2H0 >= IMP (0). This inverted the condition: feat_nv2_e2h0_ni()
evaluates to true when E2H0 < 0 (including NI_NV1), leaving HCR_EL2.NV1
writable instead of RES0 for VHE-only nested guests where KVM advertises
ID_AA64MMFR4_EL1.E2H0 = NI_NV1.

Check kvm_has_feat(kvm, ID_AA64MMFR4_EL1, E2H0, NI) so that HCR_EL2.NV1
is treated as implemented only when E2H0 is IMP or NI, and forced to
RES0 when E2H0 is NI_NV1. Rename the helper from feat_nv2_e2h0_ni() to
feat_nv2_nv1_not_res0() to clearly reflect what it tests.

Fixes: b2a324ff01fe ("KVM: arm64: Use HCR_EL2 feature map to drive fixed-value bits")
Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm64/kvm/config.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index adaf26ab93b85..a975ac73ed876 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -256,9 +256,10 @@ static bool feat_nv2(struct kvm *kvm)
 		kvm_has_feat(kvm, ID_AA64MMFR2_EL1, NV, NV2));
 }
 
-static bool feat_nv2_e2h0_ni(struct kvm *kvm)
+static bool feat_nv2_nv1_not_res0(struct kvm *kvm)
 {
-	return feat_nv2(kvm) && !kvm_has_feat(kvm, FEAT_E2H0);
+	return feat_nv2(kvm) &&
+	       kvm_has_feat(kvm, ID_AA64MMFR4_EL1, E2H0, NI);
 }
 
 static bool feat_rasv1p1(struct kvm *kvm)
@@ -1034,7 +1035,7 @@ static const struct reg_bits_to_feat_map hcr_feat_map[] = {
 		   HCR_EL2_NV2		|
 		   HCR_EL2_NV,
 		   feat_nv2),
-	NEEDS_FEAT(HCR_EL2_NV1, feat_nv2_e2h0_ni), /* Missing from JSON */
+	NEEDS_FEAT(HCR_EL2_NV1, feat_nv2_nv1_not_res0), /* Missing from JSON */
 	NEEDS_FEAT(HCR_EL2_API		|
 		   HCR_EL2_APK,
 		   feat_pauth),
-- 
2.56.1.750.gf70dc682cf-goog

