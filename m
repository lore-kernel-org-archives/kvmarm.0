Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.71
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034189;
	b=TRqBkSGkOHvYLITGYnaxMNkgxCVhv7wPyqhEzuP7F1EXugCgb/riAvJtIP1z5HJBVydo
	 MCgGG5FttACUHE5WUKL2kbw2qmwZmRduBbJ3zwkhAUYHzGeEhNPluLoyguGlryNDNGoTb
	 Wr7412yc+duqI30wpGTz6roN+8cb8VWo4leZnvbGtPIZCkyHwaHS3I6R09VLnRpQxdMut
	 pct/Bp6e85FVKYdsA12iwMeqzmNXZjJt8dHGN4GC3Rvj2H9DrIc8Wn6YnftvodlXjcmwK
	 0FW4eVt+QaqM6cOnWEDC7NruWzv3fdFJ/jdLgkiyniDdIFQVgyt6bo9koez7mSn6gjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034189;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=lv45tREYCt7GqWPtl8xyiubGXsrPN8dnOBdjmKX9gXA=;
	b=Ou3wWTIM+yH6EzGH/6J6alnixlfZaXeuEAP7pDKqXzwhDTv2VI3rOH6pMiFaln0nGB/Y
	 hfDYGepB+fFoOHQq0ycgs5YDY/8jK306zFZuVFFQ6YYp7BIA409/WqG20QybEo/kY4aY2
	 FwQ0jrCwQPsyYk/oqKy6qjmjZ8REO6sdMDdKGQcnAijxgAAvfE5IZdKQlSV+jmuxAmayV
	 HiAVYnZgZ4zz680+6c4eoPshoynpk/PD5ejDicVCgDR8gfIQPEnWx0NnbsaJrq8k4Fm9k
	 IHHOMLlIDRERojRogjQS7RMFC4+X28Ugc7Gf5qyHOveR3SSv1feYMQKuXaXblOhmugQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=APcggmU8;
	arc=none smtp.remote-ip=209.85.160.71
Received: from mail-oa1-f71.google.com (mail-oa1-f71.google.com [209.85.160.71])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E009460A2637
	for <kvmarm@lists.linux.dev>; Wed, 18 Nov 2026 20:36:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E009460A2637
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=APcggmU8
Received: by mail-oa1-f71.google.com with SMTP id 586e51a60fabf-49e5451d6a5so1381141fac.1
        for <kvmarm@lists.linux.dev>; Wed, 18 Nov 2026 12:36:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795034188; x=1795638988; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lv45tREYCt7GqWPtl8xyiubGXsrPN8dnOBdjmKX9gXA=;
        b=APcggmU8gyIA8KggzGIGKgnL9QWfAhGvEy0KQtpgEiUGj6/oDLnViUIM/ci07Oq1gg
         7RRcK+GhbgYkLE/Kv1KTFx+HAi64nj5Sd1DUZHIRANCREb3+X0W+/XHe5J4j0arOEGNc
         MuHULkFxUXZof+ER+SgfPH0NlKKg19MCRJOZzhkITD5a6nTWBo3I7Hlk/1W8fzpczWPp
         kLUZwjUKUT+fo00AczZAmdkd1OMaDfCvMVDvpNS2GQR8fGoj18wTOn0NEAAQ/1VryXld
         /kn4v/ezaxlwCd2M0ejDGYYspv2TKeh9XDmBKLl7xvwwaQXlMtI84h5Ryh4+CzkMwDR/
         Frlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795034188; x=1795638988;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lv45tREYCt7GqWPtl8xyiubGXsrPN8dnOBdjmKX9gXA=;
        b=NXNl6RjmG1gzXgwOgAAsM7oJBM6Cpe7XMQqdUGc7hZAv284QWtS826oa1YmsolCGNR
         2zSQAO8pC2OqH4LC3mgZFFWowY0Vv38MhpUyuYr6Usfcr0tCkUabE0rbEh9t/ZXvbZt9
         9GRYR8u9Nmn79DZrskoJGGeYdb6fKn4B5plGHGLA4Ck2Tm2LOETmeZAur3I8R4emvPvV
         fBynBYaJy/n2Bx6FbpE+yqp1oSE6DebjlWePEZ4+Z8VTEsUH/FZBGHfPLwCPOSnHvA8f
         iWnRhAbEXFUEBpS8VBF0OhiZEKoWwYvlX12zfbeQpHwdMsIGx89iCHgNRzPmlkGmdrZt
         Stuw==
X-Forwarded-Encrypted: i=1; AL+hErEEJODR21daq5IAKawmAW7xFp+h871A+Ehyw4WTEzFGcKbmAswNKvJheE6PGw1eucsgYSSxLEY=@lists.linux.dev
X-Gm-Message-State: APuU4Z/X0SJ7PbpLPnpAWyz4Wtp/Z+y/lH8NRX8VJUCrHGg4SooH1EFX
	cIBR9pnRriRAACzIljGP2kLVq7snp7r+qYoPVgfF4R6rbiAQNmhr9NHcLGK7sf6J5qD5Us670qD
	Qcn607JeBZ5iTMwgWRjNtjJNZgg==
X-Received: from ilrb6.prod.google.com ([2002:a92:dcc6:0:b0:547:9c99:d6d5])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:f13:b0:573:399d:d487 with SMTP id 5614622812f47-57742f41c5emr4038906b6e.65.1795034187562;
 Wed, 18 Nov 2026 12:36:27 -0800 (PST)
Date: Wed, 18 Nov 2026 20:36:24 +0000
In-Reply-To: <20261118203625.743428-1-coltonlewis@google.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20261118203625.743428-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.56.1.708.g77570a6a1d-goog
Message-ID: <20261118203625.743428-2-coltonlewis@google.com>
Subject: [PATCH v3 1/2] KVM: arm64: Force HCR_EL2.NV1 to RES0 unconditionally
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

When commit b2a324ff01fe ("KVM: arm64: Use HCR_EL2 feature map to drive
fixed-value bits") converted HCR_EL2 to hcr_feat_map[], feat_nv2_e2h0_ni()
was written as !kvm_has_feat(kvm, FEAT_E2H0), where FEAT_E2H0 checks
E2H0 >= IMP (0). This inverted the condition: feat_nv2_e2h0_ni() evaluates
to true when E2H0 < 0 (including NI_NV1), leaving HCR_EL2.NV1 writable
instead of RES0 for VHE-only nested guests where KVM advertises
ID_AA64MMFR4_EL1.E2H0 = NI_NV1.

In practice, KVM cannot handle HCR_EL2.NV1 being non-RES0 in any
configuration: limit_nv_id_reg() exposes either VHE-only EL2 with
ID_AA64MMFR4_EL1.E2H0 = NI_NV1 (and E2H0 is not userspace-writable), or
FEAT_E2H0 without FEAT_VHE or FEAT_NV. Checking E2H0 in a feature helper
is therefore unnecessary.

Drop feat_nv2_e2h0_ni() and mark HCR_EL2_NV1 as an unconditional RES0 bit
using NEEDS_FEAT_FLAG(HCR_EL2_NV1, FORCE_RESx) in hcr_feat_map[] (shared
by HCR_EL2 and NVHCR_EL2). Because HCR_EL2_NV1 is not part of the
architectural HCR_EL2_RES0 mask, check_feat_map() accounts for it as an
implementation-defined FORCE_RESx bit.

Fixes: b2a324ff01fe ("KVM: arm64: Use HCR_EL2 feature map to drive fixed-value bits")
Suggested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm64/kvm/config.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index adaf26ab93b85..2e81f45dc9921 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -256,11 +256,6 @@ static bool feat_nv2(struct kvm *kvm)
 		kvm_has_feat(kvm, ID_AA64MMFR2_EL1, NV, NV2));
 }
 
-static bool feat_nv2_e2h0_ni(struct kvm *kvm)
-{
-	return feat_nv2(kvm) && !kvm_has_feat(kvm, FEAT_E2H0);
-}
-
 static bool feat_rasv1p1(struct kvm *kvm)
 {
 	return (kvm_has_feat(kvm, ID_AA64PFR0_EL1, RAS, V1P1) ||
@@ -1034,7 +1029,7 @@ static const struct reg_bits_to_feat_map hcr_feat_map[] = {
 		   HCR_EL2_NV2		|
 		   HCR_EL2_NV,
 		   feat_nv2),
-	NEEDS_FEAT(HCR_EL2_NV1, feat_nv2_e2h0_ni), /* Missing from JSON */
+	NEEDS_FEAT_FLAG(HCR_EL2_NV1, FORCE_RESx), /* Missing from JSON, RES0 as an IMPDEF choice */
 	NEEDS_FEAT(HCR_EL2_API		|
 		   HCR_EL2_APK,
 		   feat_pauth),
-- 
2.56.1.750.gf70dc682cf-goog

