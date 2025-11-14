Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83F0B3054F5
	for <kvmarm@lists.linux.dev>; Fri, 14 Nov 2025 11:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763118718; cv=none; b=femtFxxgi3MW8/GA+VB7FB2ZVaBJhSWdZuX8h7hTRnVYaO7OkFjfofQQ+ooIg2YU2KFSQRA2r/6X82qnsPhGqG3tvKdNs1aRGWTtTxtKnA44coVej+uN9FNiDEZvZkBf+JqWUg3KodMUEqFgbdJyzrPCrjTduvjhlwc+n4MLmQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763118718; c=relaxed/simple;
	bh=qqY/9nEU8JfC3zBaFynTGqR9lQHhYb0zLTrGgkhqxM4=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=TT0+uzweX4eFs4B37Vl79+icn13phBOVaOvq3gB5RCy451MlYsqS+PXutKLr6xkRLXEhxD9b2LqAaQGD8mpsIpzZi4ZXT9MGYDhYw5t90cxMBYPZU1f/vt6iswszjHvf8xzD6AIYYVo0+ywZUdanDQjYHsYuNGl30tU5wb9o78M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--korneld.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EI1OZDGx; arc=none smtp.client-ip=209.85.218.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--korneld.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EI1OZDGx"
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-b70b3297664so158156966b.1
        for <kvmarm@lists.linux.dev>; Fri, 14 Nov 2025 03:11:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763118715; x=1763723515; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tQcSzEpSwA6ZBpPi/rTINYX4HBb66yNmYZWYgUBx7xg=;
        b=EI1OZDGxOvdLpWJsZyx8HpKRrbKS/IiT2Doi8sPyLNe1xzvOHGFkkX/g3r+Qg45efD
         7COQIIz5oEdyTVPi9JpTyMIfkm0nBp+AwGccdQwyAMdCiCRwEHZ2yvyLraVzFqpPQLpj
         Jpb1AeSU/KT8r0ypqDTLGPhZGETyTHMEn82cH0PUh+X1g589NwMo/bYIjY8d4CNHsKVs
         MsXjqyekXHi80M8oReQHCREi6Z0Mx7ULGz+1btXKVxNtzef/ANZjRnzmCvZ1Wd0+w5jw
         uNZu7jDMKdhCFa0jGbm268fgiIb4wTqeXyvqDSqCWKN48b0oEy4zIjynUt/qmrQDmkfD
         3/PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763118715; x=1763723515;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tQcSzEpSwA6ZBpPi/rTINYX4HBb66yNmYZWYgUBx7xg=;
        b=sE2EA/aOXtAzx5IHrSr5KgyQpb93PxF4Z2d61Q78MYzq9ofG4X+duET5NBeOoBUnYl
         bbElnXumHJ77u0kpk49Etp9WbVDgj55TZ9Ihl3Ac1QvM56YZLUza55cOYUtbbkvuXB7O
         vzvVSeufQQm7wtLZqZ5f6JfamfGSqUF7BqUYrjJUcciwGZVQ+/Jh/KpHS58CPq8/uG3f
         QsPHgC3AmhhXwJXboIP8LGonLzd07ujA/LCfPNxhFLX7KcjXEXiXH3rQLwhCOa4ugJhb
         VlKl+5JZ7XVS01fmUEqdSDugbIXjC4UsENxia+mpwg6PwHPt08m6vZqwf+UIC0q+5FOt
         KJpg==
X-Forwarded-Encrypted: i=1; AJvYcCVb/ZF1UOI6021cgWrp9MxUVA44s6+iU1fAecH1HlbO4MRZfy3Kig/6LQzLRiCzGJEjABtrhzM=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyt/nsjZ5KdnUgZu53bOFjka8Q0UT9uB+BFguQfUtvB8a49cuOH
	3FOKhVW5CyMaXXMywBCg32pWWwQ2XnGXYtcEfmRsqiYbrGvPAnPt2dGTbQAhow+1x4tlLpKab7S
	8NZOdG4sBag==
X-Google-Smtp-Source: AGHT+IGnWVB505G2W650/nXNH2n0iR9oY27m/GdXw2nME7uc6d5UvqI4cEORymAa2S62GvJ0zkxb/mKrP/Ib
X-Received: from ejcvi2.prod.google.com ([2002:a17:907:d402:b0:b73:7326:8548])
 (user=korneld job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:6d20:b0:b45:66f6:6a0a
 with SMTP id a640c23a62f3a-b736793d74dmr217106466b.44.1763118714892; Fri, 14
 Nov 2025 03:11:54 -0800 (PST)
Date: Fri, 14 Nov 2025 11:11:53 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIAHgOF2kC/x3MQQqAIBBA0avIrBNSDKWrRIjUWEOkohGBdPek5
 Vv8X6FgJiwwsgoZbyoUQ4PoGCy7CxtyWptB9nIQQiiejvu0FOiyIXrvuFuM6QelUUsNrUoZPT3 /cZrf9wNy+DuXYQAAAA==
X-Change-Id: 20251114-pkvm_init_noffa-ac880547e727
X-Mailer: b4 0.14.2
Message-ID: <20251114-pkvm_init_noffa-v1-1-87a82e87c345@google.com>
Subject: [PATCH] KVM: arm64: Fix error checking for FFA_VERSION
From: "=?utf-8?q?Kornel_Dul=C4=99ba?=" <korneld@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Cc: Bartlomiej Grzesik <bgrzesik@google.com>, Tomasz Nowicki <tnowicki@google.com>, 
	Sebastian Ene <sebastianene@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	"=?utf-8?q?Kornel_Dul=C4=99ba?=" <korneld@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

According to section 13.2 of the DEN0077 FF-A specification, when
firmware does not support the requested version, it should reply with
FFA_RET_NOT_SUPPORTED(-1). Table 13.6 specifies the type of the error
code as int32.
Currently, the error checking logic compares the unsigned long return
value it got from the SMC layer, against a "-1" literal. This fails due
to a type mismatch: the literal is extended to 64 bits, whereas the
register contains only 32 bits of ones(0x00000000ffffffff).
Consequently, hyp_ffa_init misinterprets the "-1" return value as an
invalid FF-A version. This prevents pKVM initialization on devices where
FF-A is not supported in firmware.
Fix this by explicitly casting res.a0 to s32.

Signed-off-by: Kornel Dul=C4=99ba <korneld@google.com>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index 58b7d0c477d7fce235fc70d089d175c7879861b5..ab1e53bd4ceeea431fc30a87548=
2ed1523b01ab5 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -792,7 +792,7 @@ static void do_ffa_version(struct arm_smccc_1_2_regs *r=
es,
 			.a0 =3D FFA_VERSION,
 			.a1 =3D ffa_req_version,
 		}, res);
-		if (res->a0 =3D=3D FFA_RET_NOT_SUPPORTED)
+		if ((s32)res->a0 =3D=3D FFA_RET_NOT_SUPPORTED)
 			goto unlock;
=20
 		hyp_ffa_version =3D ffa_req_version;
@@ -943,7 +943,7 @@ int hyp_ffa_init(void *pages)
 		.a0 =3D FFA_VERSION,
 		.a1 =3D FFA_VERSION_1_2,
 	}, &res);
-	if (res.a0 =3D=3D FFA_RET_NOT_SUPPORTED)
+	if ((s32)res.a0 =3D=3D FFA_RET_NOT_SUPPORTED)
 		return 0;
=20
 	/*

---
base-commit: 6fa9041b7177f6771817b95e83f6df17b147c8c6
change-id: 20251114-pkvm_init_noffa-ac880547e727

Best regards,
--=20
Kornel Dul=C4=99ba <korneld@google.com>

