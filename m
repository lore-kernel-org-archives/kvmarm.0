Received: from mail-oo1-f74.google.com (mail-oo1-f74.google.com [209.85.161.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB2DE3859D7
	for <kvmarm@lists.linux.dev>; Wed,  8 Jul 2026 22:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783551131; cv=none; b=SxdFQSGoP/Z5onjywWTV7eNT6H5u2yO9WwnFCv2dhM3AJ43gIj47BmZDrrZLa2DiqaGXveVmPIcjMMDza1Me56R/C1000BKpV30rgxE5kHcDiwryStOsTvqBximTnqNWh2lpBA8qGPlLr+ygcULfSof2yAA1q8b/krqrYNekYR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783551131; c=relaxed/simple;
	bh=2c8XTPNphIfSHGS9kO7V0RYBdRMxPd8eKXEBM1ea3OI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZY0ZYV1GogImoBCzORuvkskO1w5osZY3yceiqfnbfNXPuzy+KG1UFsX8I8rBpHb9gMoPe26X1ZMHbKlmW90xLNNxx+9z0449QGGvcvNWRM7xDRgsxxRIq0Na1/s06dg3TRpm7H7Ktw1GSmC5kkfv5fi1gq/eRTFVm3sjAeEeTmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=j+JVwsHa; arc=none smtp.client-ip=209.85.161.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="j+JVwsHa"
Received: by mail-oo1-f74.google.com with SMTP id 006d021491bc7-6a37685f41aso544202eaf.3
        for <kvmarm@lists.linux.dev>; Wed, 08 Jul 2026 15:52:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783551129; x=1784155929; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nzHvY4Nn6plbaCF35zKiwiQUdpmfX8uqx6rHpqc+ZhY=;
        b=j+JVwsHa6geU7X366A/sRCIodXfvxYyroeERUgSOlrU3GuRMQQmQX6JmIe8ErPhpVH
         9PM5VhJFIiAP0yVm4ARUNHhdeivj168DxlEoaTtwzGMdqdWYmMRSYax1qAjiYUHP07/E
         x6ySRR6iWhB66IwzOdoDnGQQ5tjf99jEc95NBMEsPyWjEYmJdPS1GInXO6MGb03eD22k
         1wAioprVJRL3Miwm+TeN/8EMpxnRvekgr/BG1Q7DysoTifKATcqAYb+xMQgDnXR+2L0j
         ddVgR/e6A7pfTyknvq5GT/uVQuTxLPEQoncFtbdqRwccOMFzpMHGWxWGpZN91irwtJnM
         4V0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783551129; x=1784155929;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nzHvY4Nn6plbaCF35zKiwiQUdpmfX8uqx6rHpqc+ZhY=;
        b=Zrpz7cgJNWyPLKI8IWYg7MRf0NIdfxEgyxbF4zov/+05oYf4mJfLVivKHS+YEnC4gk
         eYTzfYTBy/d8yYdA9BrCuBPlIF5ckX6I2Ff9f0eZQn/bzspmq9P1O6iNM9VVj+UKu7++
         QqsYcYWQnKJMhJcrfKG/zkN13osHPV4neFfqwaeWDpdjU2Vj7ZeqppTGIGrqVAYOmo1K
         C4GttL3PL84cwcZOE4AY/MKuOVa7i+/YD/yEu4bhCdn17YdjB8scVl6v+rnhPnTB0kKx
         pPxRLxbRi3rNusNWoK+oPurPJLo29K8U+KmXVJBaR3odmpC+GvscafMG2pcSnPqFuA+F
         8+Ng==
X-Forwarded-Encrypted: i=1; AFNElJ+88Asp6tu3iHM0zfKpBsJdAEsf8oxiRto89N0kUni56jNIzFUZSxQb/OCNmAHwEPYgB3p84NY=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywx8IV2pY+qev+JTx0tQM1ut3VDCw+SHQa6iLuVr+Zd/lipnDHJ
	Pr7Rvgz+iOpddAtu2Ziwvt5E71f/7IJhMpOj+uTdIAte4LpFk0WD3sKviRMeEr4WP/58dAD/x8B
	qKQj5aktU500V2uns1KF2jNd5IA==
X-Received: from ilqn12.prod.google.com ([2002:a92:d9cc:0:b0:503:92be:9a74])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6820:2222:b0:6a1:805b:5281 with SMTP id 006d021491bc7-6a36da5e3a0mr3401844eaf.37.1783551128581;
 Wed, 08 Jul 2026 15:52:08 -0700 (PDT)
Date: Wed,  8 Jul 2026 22:51:19 +0000
In-Reply-To: <20260708225124.4130846-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260708225124.4130846-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.55.0.795.g602f6c329a-goog
Message-ID: <20260708225124.4130846-2-coltonlewis@google.com>
Subject: [PATCH 6.6 v2 1/6] arm64: sysreg: Add layout for ID_AA64MMFR4_EL1
From: Colton Lewis <coltonlewis@google.com>
To: stable@vger.kernel.org
Cc: oliver.upton@linux.dev, sashal@kernel.org, gregkh@linuxfoundation.org, 
	mizhang@google.com, catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
	james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	mark.rutland@arm.com, ahmed.genidi@arm.com, leo.yan@arm.com, 
	miguel.luis@oracle.com, dbrazdil@google.com, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
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
2.55.0.795.g602f6c329a-goog

