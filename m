Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.71
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794859462;
	b=JncrmSdonD/owbiN6RXdCSjMaWOvk8K7AmSvvCeF481D2cetNk89d7aTWYy4o3pbvntp
	 i6EcC9+DRec3yKlwHu6ipLsQM/yfGumCzwVnLqkDu/OuVTlwJTcebGN8aaLrPKU/HY923
	 YE5131fFkjIk+Uc8UpvgC3ZA8hncfOpIWT0RCehGcHhv1siXHsyaWSyuSuoj1aay/tAz8
	 4P2ewCT6hwcDjeitnZPlMbVUIcT6F3UjwTHHVchMLHEFJGVaMwgWgFAuj5jn286CKYA6t
	 Hxnn/QrapsSh9JO7+QCWKhIt1AwWovlBN2V1FoXFa+bW1j/c96u5pJfnvuxLXwtUH+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794859462;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:Mime-Version:
	 X-Mailer:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=9bIAYBNiz3NB6EQnZLvtp2y9CTLyvsz22fhiOVY49c0=;
	b=1JhXJ7p2/QiXiJNC4x2yuCpPuZaan4S9XJlm1xv22MTdY68+kcF/xLOgtPBw20pADo4j
	 SsaFpK4ucNQJaGfdeWpSSVYbVqcpMOE8nhI8/KWLYJMxBZAzRkB8Qka/38Iqr1Bw7f4lo
	 5U0RHPnmqoTxF4SjAXQFwIkUUexafCzQVZsIz73ZXRQ/SCN79Lg90RdnxbdFBIH7GYkxP
	 wFR1QA75bSMiY14nUn/+2aeAE7wbsWj63lDFavM3hhHA7l3Ebt1Oe5b40BfgamyUE2laU
	 oLHV/XidqR1bTsh/+yAPBkEG4F43EvtI87yTC4SX1HyK6gUoTcA0bNlwYzceIxTPXRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=hsxtMS8v;
	arc=none smtp.remote-ip=209.85.210.71
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com [209.85.210.71])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B91C606A33A
	for <kvmarm@lists.linux.dev>; Mon, 16 Nov 2026 20:04:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0B91C606A33A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=hsxtMS8v
Received: by mail-ot1-f71.google.com with SMTP id 46e09a7af769-85a6d046af0so2077871a34.2
        for <kvmarm@lists.linux.dev>; Mon, 16 Nov 2026 12:04:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794859460; x=1795464260; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=9bIAYBNiz3NB6EQnZLvtp2y9CTLyvsz22fhiOVY49c0=;
        b=hsxtMS8v2/fJilZKnj5sE7un4fPODGqCcEk15XGqAm1LvsMCmmRx3gYyF5RoVedOF1
         3jr9rBe1goQeDZTVPG19EWxEnVfSyQRURmjr8zemmz7w/naI+9lsIBVKYNZ2EH7+t4n3
         0HIKkiH9pLWE/SPqUj88KP9wp9cROTTIvPTiTptGL5ZZUWU+Biod55YqckoZrBkFgUb2
         tSr1lDbhPoe8/bepZgxrrIhTQ64YmkLmFqXI1wDDT6/J47HHjYRkhZeptLGVl272h5Ta
         +KVfBiGs8cKT1ztHBWNhvrsF3V2wV873NzP20fpxtcnoyBNT0ybfgNuti9ZZ2PICACps
         hVAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794859460; x=1795464260;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9bIAYBNiz3NB6EQnZLvtp2y9CTLyvsz22fhiOVY49c0=;
        b=zOPZN3RUNMBD5s+Zy1P91LM8/Wt0KE0ZfsZi7qSeyzKWcYR4S3c2pWqEw4Yo+Z/L66
         qVEm6lRKGaYZS506a+w8IV/CIgeawxc9KQrk0pxcXCnc3WbSjVjKW1unaZeOM5jCL06H
         +XqC/pudvi2qCm5mhPl7S8flNAVXxariwYdmDzY1/GQgO1nLcBcKY02OCOmgcvRZ53GV
         pJVfm/byS4QO13ih+YGRja2FqdnYCKCFsuofqRjm4rHXBn1jiDokObjPqNqXuaXOWzwg
         Jyot7PBVvLqdk/It/SvltK3NJxWSr1MMnoJOThS4Ue9Wl8CvS6CoT4aMrh+chZ7oErZU
         Vlhw==
X-Forwarded-Encrypted: i=1; AL+hErGfJwV4sb6LcDHpfoOYHW28FM/kQHfkB7s26U7IELQwDYoUxGt/TLAmjRB+vin+itelJsp0lZk=@lists.linux.dev
X-Gm-Message-State: APuU4Z+0M0MAgUUN6WeRjwLEPvvZDPZEgm1yaHIoUkgp7uuTn+hiV/fj
	oHlEtHHK1hzP7j35EgfP3ck9bxLmquWbux2f2/IU13RkCSKuJFvenOga15Gg7Jlun70QYZMWiiE
	5HmhRIt1jH9Tg99c0+VVB+GLjnA==
X-Received: from iodf4.prod.google.com ([2002:a05:6602:62c4:b0:9ca:727a:80b2])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:152b:b0:4e8:721f:2824 with SMTP id 5614622812f47-56e65625626mr9335826b6e.60.1794859459512;
 Mon, 16 Nov 2026 12:04:19 -0800 (PST)
Date: Mon, 16 Nov 2026 20:04:16 +0000
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
Message-ID: <20261116200418.3535619-1-coltonlewis@google.com>
Subject: [PATCH v1 0/2] KVM: arm64: Fix inverted E2H0 check for HCR_EL2.NV1
From: Colton Lewis <coltonlewis@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Fuad Tabba <fuad.tabba@linux.dev>, kvmarm@lists.linux.dev, 
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

Patch 1 restores the check in feat_nv2_e2h0_ni() to
kvm_has_feat(kvm, ID_AA64MMFR4_EL1, E2H0, NI) (E2H0 >= -1) so that
HCR_EL2.NV1 is implemented for IMP and NI and forced to RES0 for NI_NV1.
Patch 2 extends the arm64 hello_el2 selftest to verify that HCR_EL2.E2H
remains RES1 and HCR_EL2.NV1 remains RES0 across both guest EL2 writes
and userspace KVM_SET_ONE_REG writes when E2H0 is NI_NV1.

Colton Lewis (2):
  KVM: arm64: Fix inverted E2H0 check for HCR_EL2.NV1
  KVM: arm64: selftests: Verify HCR_EL2.NV1 is RES0 when E2H0 is NI_NV1

 arch/arm64/kvm/config.c                       |  3 +-
 tools/testing/selftests/kvm/arm64/hello_el2.c | 34 ++++++++++++++++---
 2 files changed, 31 insertions(+), 6 deletions(-)


base-commit: aebb7274476403040d582c61478df8f4a7bf9cd3
-- 
2.56.1.750.gf70dc682cf-goog

