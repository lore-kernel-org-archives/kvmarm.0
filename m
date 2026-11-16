Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794859462;
	b=bopy+2sJCcRzYLq/8LFXFPNWwPOoSj4jqoR13FStZ5LBYxhuN5Kt6zIsQ1V2Ygf4aWJc
	 6jNznK4kPkGPShqCAoQEIbduQDS34qxrYbrzT6w1e7jtVG7eCTlPLB2gCAXiW2/GTgSiK
	 9OKO34i1vDx2WHKkoy6DQjkzvRkOlQulDwm8XhY4ZaJMqHcvAQX0NG1EZFE41rDc871Je
	 dh1ax67oO2efjNwPI5Y2974SrJlOGZLtB2MJfrAMb1hdkfFH7TL0an2VFiw1ajjOE3Qyg
	 Q1gwLHtUcxgmZF3PbM3oO+RWko3BGEUJqNzflfGD9fPHCcME5kg4myWlj6ByAl/+Glg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794859462;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=fLiUogQDb6C/5hkqgN4Zccv3qSnCF6DVX/+qKwo4uaw=;
	b=E8HNiYwz0nnKQhrafWeSzToBtg6mLY4153HCPstHpeXR0ZRCWa+Qy16m7PYbvWt9SZQ+
	 W3plKDWGVp44lOfeJ2Ch4cXiNAoQJipd3eOCwXbVkruqtQytWTpjPsoSTyRTQh7ufcR9i
	 U6rA+iHyjeUxJ1HehTKeLdZ93GRF5enFpwRfHOttfc9XK9GkQZeWME7PS0SxrEYZ7iqs8
	 IJFgtN9W5F9KqQo9C0Khl2/PhhmygFRuuR4y/MpZxsNFaUgpqCxCHPHFozJUcZCLXjdLy
	 PgA+2ejoLwUcjdGIXc/KHdF7NdQ1sQepMSwj3QakqNMSeLUX6XObl8y5YAtv5IXc5tg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=i+th2s8I;
	arc=none smtp.remote-ip=209.85.160.72
Received: from mail-oa1-f72.google.com (mail-oa1-f72.google.com [209.85.160.72])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA21D606A889
	for <kvmarm@lists.linux.dev>; Mon, 16 Nov 2026 20:04:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CA21D606A889
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=i+th2s8I
Received: by mail-oa1-f72.google.com with SMTP id 586e51a60fabf-46a5954cdfcso3719279fac.3
        for <kvmarm@lists.linux.dev>; Mon, 16 Nov 2026 12:04:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794859461; x=1795464261; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fLiUogQDb6C/5hkqgN4Zccv3qSnCF6DVX/+qKwo4uaw=;
        b=i+th2s8IjT1ZCLM/MBA8dH/x8cJRkk6V/ZIXkYS2hivBwRM+ncwyfhJC/kVwH9IPin
         RlAPB9AZoORZOwQFiRUArVokMHJal8U3vjYhQ9R1l1LplPehX7rfs/kwe3KGlVNMQ/kz
         FbUz6b9DyaS9hWfBVlIuIo6xk2ivD78XMziFBHrQ0H2NnMn1QwyoIjEjLf4T2aq/odF1
         Dfxx1GnwKiOLRWCm9hIlgtRIVSikikK9E7YUz2xJRRGuV4BgHt58r9RYirRhLy8VpwF5
         64v2jSfQKJPC1+coNDCFPnk/j5RKLyyeGOk3CJx6TAoE8ZDLrN2lCwaj/LLcjFno4U9o
         l0jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794859461; x=1795464261;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fLiUogQDb6C/5hkqgN4Zccv3qSnCF6DVX/+qKwo4uaw=;
        b=NXbg/8lWZYS+d6e+T4HFCDUnZOSgp8VRwQbh0sa7GmfaAoEeK2r7k2Vidxc0+t53dF
         ymFlnVf9EUoVBF/pRSDkrdy88mkp4pTlIGCSSZhg9M0ceV9UmmuBWn6OzOrJmOrZR+8I
         blwtd7PjuX6aD83Uel8UcoeS3+YLyZyt00/pHRBKA7Ya2k4BDnXJKqQNc3WB9t3IQcKc
         SvSC8wRcE8ahOsHN3FMnCRol35WcjjEGpXMLyAHXTk5SprW+/Ze3O5kGyUZCS2PK6fRm
         0ydu1aVOYgoxeqmtg6ygmpmHmj/oLYGER9t/D+UfeVz9qe4QPDbwlpqRJsbNHXusL4tb
         LNYg==
X-Forwarded-Encrypted: i=1; AL+hErHGgrRvpGzVnvItZViRHHIeDBPwQzcD8e/kL1qW1mK93OputyvjLnrsKLv0WOXHLYARWAFwL2o=@lists.linux.dev
X-Gm-Message-State: APuU4Z/CFUd7iDw/EKaKW6NKSMvhCCczHFakCUT7p6Tu7zNBF2HHMSD3
	uk8qFDk57gWYgDcWSw/0YZDP7z6aleT+rWmAKCtw+2DAHlwQ+wzBhwdPMsTmKGcf1r3PP6MQt16
	DiJm6E4tAw+p4e/78422tdkQS1A==
X-Received: from jacnj25-n1.prod.google.com ([2002:a05:6639:299:10b0:60b:77aa:12a3])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:4d06:b0:572:86c8:6b4c with SMTP id 5614622812f47-57286c86d22mr6304607b6e.6.1794859460579;
 Mon, 16 Nov 2026 12:04:20 -0800 (PST)
Date: Mon, 16 Nov 2026 20:04:17 +0000
In-Reply-To: <20261116200418.3535619-1-coltonlewis@google.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20261116200418.3535619-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.56.1.750.gf70dc682cf-goog
Message-ID: <20261116200418.3535619-2-coltonlewis@google.com>
Subject: [PATCH v1 1/2] KVM: arm64: Fix inverted E2H0 check for HCR_EL2.NV1
From: Colton Lewis <coltonlewis@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Fuad Tabba <fuad.tabba@linux.dev>, kvmarm@lists.linux.dev, 
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

Check kvm_has_feat(kvm, ID_AA64MMFR4_EL1, E2H0, NI) in
feat_nv2_e2h0_ni() so that HCR_EL2.NV1 is treated as implemented only
when E2H0 is IMP or NI, and forced to RES0 when E2H0 is NI_NV1.

Fixes: b2a324ff01fe ("KVM: arm64: Use HCR_EL2 feature map to drive fixed-value bits")
Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm64/kvm/config.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index adaf26ab93b85..b4f555d39f54a 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -258,7 +258,8 @@ static bool feat_nv2(struct kvm *kvm)
 
 static bool feat_nv2_e2h0_ni(struct kvm *kvm)
 {
-	return feat_nv2(kvm) && !kvm_has_feat(kvm, FEAT_E2H0);
+	return feat_nv2(kvm) &&
+	       kvm_has_feat(kvm, ID_AA64MMFR4_EL1, E2H0, NI);
 }
 
 static bool feat_rasv1p1(struct kvm *kvm)
-- 
2.56.1.750.gf70dc682cf-goog

