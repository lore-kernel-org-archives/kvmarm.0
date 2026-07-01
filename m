Received: from mail-oi1-f201.google.com (mail-oi1-f201.google.com [209.85.167.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73AA23A71AD
	for <kvmarm@lists.linux.dev>; Wed,  1 Jul 2026 20:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782938626; cv=none; b=TJiRKEvvUMhQRR1cLJe/QfZT3ENqNZkpMoVNEQczjXG9lhzufM+Krzvol4DS3nPyyGu3ppxsHP/E0eJER217mGkn1h5joysYteUsy1RdwNm0cHW0pfNUQ5VrcGd7TxhQXMPMhPd1xk+IQte2wFPF/yKDMl8xLS5+UvGKLzGn9uE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782938626; c=relaxed/simple;
	bh=1acKOSk89/R4YH+6/5rOgEyjBwdxqSvOEzpk+Qa5HYA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gfipya2Pay6s1ltnpHlw8MAOH5QiVVtjtEuw54SkKWYpGAq6BT4Clzg60UV4oy2VaREQAMTCwr4oeJKLIAgpTWaoE9IQoGaTW8GnvFdsAEvI5dy0jfQ79XB/QyBpswYomLZO89qZ1KIi58FXYv7wxQ1GkjNVCVSfyt0Asqbkp2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZQ/P9PEK; arc=none smtp.client-ip=209.85.167.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZQ/P9PEK"
Received: by mail-oi1-f201.google.com with SMTP id 5614622812f47-485fdae1db3so1161024b6e.1
        for <kvmarm@lists.linux.dev>; Wed, 01 Jul 2026 13:43:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782938624; x=1783543424; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9r7V4xxqwcAsYX7tRzKjXAt0hIG9LvsN2CbJq3Hl88s=;
        b=ZQ/P9PEKBGAAunFvOg81x73ATN89k+xHeVfVoLqtL5QGN5fQqQ9S9KS430Bbmjfs4y
         LLfxCTIEFEL6dap/cpMRem/XGjZtdlEtdI/PryHVECse/s07xEX9vK0S6IpdUW0+ZUU9
         qqL42ZlcR4rMSG/IHjnalgjl8Uo7TkgHOcBMmsiTJfPeeYtnbC73hxz0hz9VtXnJdmUY
         AKvbB0Z6RK4oPEmro/XU+rl2TpmlfvcYyB7OJDt/weUfwIQMaZNdNcZIwjfN1MsIh1Yy
         OIHU5fRM4zI8D0c+Vo1EFGeQhCvkpNp8iFvMOooa/REgw/biet/H58xHjp2AztTVhK4T
         76Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782938624; x=1783543424;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9r7V4xxqwcAsYX7tRzKjXAt0hIG9LvsN2CbJq3Hl88s=;
        b=g5jwPSCZMON34tfOSww8JP61o/Y65gIP/r51vIIwuS5ncVd1SmUYG7ZpGLZLkIG1h0
         eU6S7IjmEZHRpQfoJHiD/Lih7fxZnYILHZAGLq0EINaf1tt6zID8MDHc6/X7T+xZTG3c
         +GARyw8h5EKVxNaAqL2sQFVxky7D0BZUAh2FmIcqBdaVHXmYGoiC2vlE3VKRCFGny28L
         RobOcNif2f9zx8RalLcg6e0eKvOQF1NtOVMZOFALqN8O2ZVT0A3VsX67qvqdDVnYVBrl
         rwKxg7SGVqENUgmt4psilfagI8xnbXrcL0Z8fn+GA8OYQyNEmaxxKVBoyEsQwXMAb838
         A9Zg==
X-Forwarded-Encrypted: i=1; AFNElJ8s9AQFyH3VMnZcmrESQJFtw3qFHuCffE2t86lhIv4a4WBdgMKtM6vgFYERDjPr0upbESNZ5b8=@lists.linux.dev
X-Gm-Message-State: AOJu0YzmBTZ9CBlXZBN9NxzcFhVqMLJ3aBTejUHEePQ5+BDNthnQMuGs
	wuTHIJDcgVKc1EKtokPfv+bqtg8l4ZytY/qUtE4JKOy9uRcYL1iVmEDvZ6m7CJVlXCkySMsnUh9
	/h4DaoN2O0gcVnZpV53XI4xmCKg==
X-Received: from iohg8-n2.prod.google.com ([2002:a05:6602:a648:20b0:996:4a61:aebf])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:320e:b0:495:e54a:dbcf with SMTP id 5614622812f47-4960ef97c18mr2326318b6e.31.1782938624299;
 Wed, 01 Jul 2026 13:43:44 -0700 (PDT)
Date: Wed,  1 Jul 2026 20:43:38 +0000
In-Reply-To: <20260701204342.2654385-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260701204342.2654385-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.55.0.rc2.803.g1fd1e6609c-goog
Message-ID: <20260701204342.2654385-2-coltonlewis@google.com>
Subject: [PATCH 1/5] arm64: sysreg: Add layout for ID_AA64MMFR4_EL1
From: Colton Lewis <coltonlewis@google.com>
To: stable@vger.kernel.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Mingwei Zhang <mizhang@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Miguel Luis <miguel.luis@oracle.com>
Content-Type: text/plain; charset="UTF-8"

From: Marc Zyngier <maz@kernel.org>

[ Upstream commit cfc680bb04c54e61faa51a34d8383a0aa25b583f ]

ARMv9.5 has infroduced ID_AA64MMFR4_EL1 with a bunch of new features.
Add the corresponding layout.

This is extracted from the public ARM SysReg_xml_A_profile-2023-09
delivery, timestamped d55f5af8e09052abe92a02adf820deea2eaed717.

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Miguel Luis <miguel.luis@oracle.com>
Link: https://lore.kernel.org/r/20240122181344.258974-5-maz@kernel.org
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/tools/sysreg | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 76ce150e7347e..f7180d391f829 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -1669,6 +1669,43 @@ UnsignedEnum	3:0	TCRX
 EndEnum
 EndSysreg
 
+Sysreg	ID_AA64MMFR4_EL1	3	0	0	7	4
+Res0	63:40
+UnsignedEnum	39:36	E3DSE
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+Res0	35:28
+SignedEnum	27:24	E2H0
+	0b0000	IMP
+	0b1110	NI_NV1
+	0b1111	NI
+EndEnum
+UnsignedEnum	23:20	NV_frac
+	0b0000	NV_NV2
+	0b0001	NV2_ONLY
+EndEnum
+UnsignedEnum	19:16	FGWTE3
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	15:12	HACDBS
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+UnsignedEnum	11:8	ASID2
+	0b0000	NI
+	0b0001	IMP
+EndEnum
+SignedEnum	7:4	EIESB
+	0b0000	NI
+	0b0001	ToEL3
+	0b0010	ToELx
+	0b1111	ANY
+EndEnum
+Res0	3:0
+EndSysreg
+
 Sysreg	SCTLR_EL1	3	0	1	0	0
 Field	63	TIDCP
 Field	62	SPINTMASK
-- 
2.55.0.rc2.803.g1fd1e6609c-goog

