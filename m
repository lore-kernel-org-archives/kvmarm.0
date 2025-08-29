Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71EF8270EBC
	for <kvmarm@lists.linux.dev>; Fri, 29 Aug 2025 09:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756461111; cv=none; b=s4qDItliO6JvWsbPcWOoXUoBCHsdIm1UEREYq+e/tS8thz+wEm8k7Nyu4GeA20t98CT3uQ+wh8C7cdDGKHv3iRk8KlqD2D2vMk02IIHzfH5IaqNvxWUEPb4/plJ62EIECeE9aGiPCDDZDQGB04MiaYTKxSrtYwt52/0Qo2FaqCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756461111; c=relaxed/simple;
	bh=+yJG1pp3qxWpE1J9ZW/LaEgk0ur9xNOUMYJ2qwshxQo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Ax1LHmLgPeP8tp2QhxjcWjjjdWx+W9X7rGPL8dkZ4aH3pX5qXc+zSrkgmdsAgt9AD6c4Up4gZItST8/4+mB0X3R0LcQ2ZbBqH4UPcfkZKWuDEabHzzC8HpZlasjjHf8XOlFKLoGBfuPMdEtgT0vx+HC2smctKbeBeVyH7jYBhYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BFvcnktM; arc=none smtp.client-ip=209.85.218.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BFvcnktM"
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-afcb732ec92so169381366b.0
        for <kvmarm@lists.linux.dev>; Fri, 29 Aug 2025 02:51:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756461108; x=1757065908; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cnfEnmf1rS4wgAw7cCMpCnyH3n29KRVvJCAj5QRuwc4=;
        b=BFvcnktMpEcac+o1frXi6E2YFDNLfmF3MBV6SdoZHfqcvw4cFcA63Lsya9KySAmmE6
         uIcMsNSKPPdWBRkYhkAzd56QJvY7oqN0A8uPq0IuqDn934G+PnjYlfg9CwACl+tSKJi6
         8fnTUsTKCUnXebqz+hnFlK7uNC0aFkVCpQlEN4863uewCTpyXGT8IE2BJpf/dv8EQN90
         WtvlFi4AMgo6tdfy5i670GcMLk0O0i8g/2XraCys25dFjlJV0IlVjwwkMFxcbcCYcAAX
         UcjzT2Z/5SRSsQMxTcAjZu/YVC9zalrVOD3HcQk0zASaqodmIIkfBKSCm6td3xMteRa4
         EBNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756461108; x=1757065908;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cnfEnmf1rS4wgAw7cCMpCnyH3n29KRVvJCAj5QRuwc4=;
        b=RP9EzXZomQ+lr2XLQQ0sFYzGT1u8KVbN0fHF8ZUwjznB9hfGJ+6LS+jHKBgd1i/oIU
         vgfh6pvCaVHyeU6RWh7rMaKI8AYpIpJfkzrFLSSmu1N0ps9IAvpQ4WlNOF8GCKF2AxrW
         iG9oMTv2mGTEeTuUQ3wj4syAno7OS7c6EEeTJr/uw4qkRgiJO+TJagQs99zkSE5OE/3Y
         9+UF2s3reC1IpOk1dZAKtstuiv3D4x9tB8nrPMX+uDG970zWVQ0QvOSU+Z9eVN8ftCUs
         UwlVK6+9GlxawiGc9CYtaoA+V5J0Z4tIImzPhjCqkCVofUTrswhKOIYG4CzUqDJSKRFJ
         5MnQ==
X-Gm-Message-State: AOJu0YxwfQdKlUjH4AYVe9hxw6wL84R6nRnMgJQjqOzMiaB7FuT5CFbs
	khAaP5F9mixZxsjYAaaNZtek1zuc5SfCcRzlTIX3zLCaUirDEKtnVi48g4vTXjPALi+HQMHNxvu
	P5/yRvl/+BX/SaDeajBmfPZtvwH8cETzwoNnDwiXTGM8kUPmNNBYL9NHWys9+QKIVlseAY2Pa+z
	BPknmTvMkZXBE/tHBZOCJH5mR2NGwBS+E=
X-Google-Smtp-Source: AGHT+IHsDcMPrhyfskuHWFsChUiLRK+WvCOQw9Iq8m/qVJIKUtbjFtk2SJhvrDDesYXcYxLK1intdRRcKQ==
X-Received: from ejcva5.prod.google.com ([2002:a17:907:d005:b0:afe:c85f:e152])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:6d04:b0:afe:ea4f:6225
 with SMTP id a640c23a62f3a-afeea4f6735mr443173366b.39.1756461104699; Fri, 29
 Aug 2025 02:51:44 -0700 (PDT)
Date: Fri, 29 Aug 2025 10:51:41 +0100
In-Reply-To: <20250829095143.123476-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250829095143.123476-1-tabba@google.com>
X-Mailer: git-send-email 2.51.0.338.gd7d06c2dae-goog
Message-ID: <20250829095143.123476-2-tabba@google.com>
Subject: [PATCH v3 1/3] arm64: sysreg: Fix and tidy up sysreg field definitions
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, will@kernel.org, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, vdonnefort@google.com, qperret@google.com, 
	sebastianene@google.com, keirf@google.com, smostafa@google.com, 
	tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Fix the value of ID_PFR1_EL1.Security NSACR_RFR to be 0b0010, as per
DDI0601/2025-06, which wasn't correctly set when introduced in commit
1224308075f1 ("arm64/sysreg: Convert ID_PFR1_EL1 to automatic generation").

While at it, remove redundant definitions of CPACR_EL12 and
RCWSMASK_EL1 and fix some typos.

Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Acked-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
Note that NSACR_RFR isn't used in the kernel as far as I could tell, so
I didn't add a 'Fixes' tag.
---
 arch/arm64/tools/sysreg | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 696ab1f32a67..f1a012ee0db6 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -31,7 +31,7 @@
 # Mapping	<name_EL1>
 # EndSysreg
 
-# Where multiple system regsiters are not VHE aliases but share a
+# Where multiple system registers are not VHE aliases but share a
 # common layout, a SysregFields block can be used to describe the
 # shared layout:
 
@@ -54,7 +54,7 @@
 #
 # In general it is recommended that new enumeration items be named for the
 # feature that introduces them (eg, FEAT_LS64_ACCDATA introduces enumeration
-# item ACCDATA) though it may be more taseful to do something else.
+# item ACCDATA) though it may be more tasteful to do something else.
 
 Sysreg	OSDTRRX_EL1	2	0	0	0	2
 Res0	63:32
@@ -474,7 +474,7 @@ EndEnum
 Enum	7:4	Security
 	0b0000	NI
 	0b0001	EL3
-	0b0001	NSACR_RFR
+	0b0010	NSACR_RFR
 EndEnum
 UnsignedEnum	3:0	ProgMod
 	0b0000	NI
@@ -2528,10 +2528,6 @@ Field	17:16	ZEN
 Res0	15:0
 EndSysreg
 
-Sysreg	CPACR_EL12      3	5	1	0	2
-Mapping	CPACR_EL1
-EndSysreg
-
 Sysreg	CPACRALIAS_EL1  3	0	1	4	4
 Mapping	CPACR_EL1
 EndSysreg
@@ -2576,10 +2572,6 @@ Sysreg	PFAR_EL12	3	5	6	0	5
 Mapping	PFAR_EL1
 EndSysreg
 
-Sysreg	RCWSMASK_EL1	3	0	13	0	3
-Field	63:0	RCWSMASK
-EndSysreg
-
 Sysreg	SCTLR2_EL1      3	0	1	0	3
 Res0    63:13
 Field   12      CPTM0
-- 
2.51.0.338.gd7d06c2dae-goog

