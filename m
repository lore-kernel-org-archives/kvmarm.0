Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85F002877E3
	for <kvmarm@lists.linux.dev>; Wed, 13 Aug 2025 16:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755103513; cv=none; b=gIxR1dnj3A3MEyiSm8mHmFHDQ8CRGxr4yUWZas2YxgnujWfF5F4S1VnOqlcmTAByDZgm3GPhjOEvyvUUK1ZlcVU43kHt6LgdgG1OyekdJgcPTaVjzXxRDTWJObhEBrXiwtpfgibVttSYzEQINIglET3kFWzc1LFtMfD9UoKdq1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755103513; c=relaxed/simple;
	bh=BJjEEIEz6V5k1KBNKtZFM+YUZ2EkLFZKDvXlXMmgGb0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MurI+ywdQMa4ZtOpAmOqM2Qv92JOXE2cPTDWtK8SlRCqDjyEcIac6z9uR3TWEpeNYFc7I/H0pcdVmJ+rPI+7o4w0WNjdSG4vOfw2lChLJOkvfQ3GZfnx7XjppVnm8BSdXHnvHLNDlr26HZWypLwBezdrXkjRT27GjXgAPUNafmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ce7SeIAP; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ce7SeIAP"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-3b9d41c245fso23972f8f.0
        for <kvmarm@lists.linux.dev>; Wed, 13 Aug 2025 09:45:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755103509; x=1755708309; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=GBQsfHg/ZyhTgkDWvIhH6lJQIV/CSzF6SBf+6h9QT90=;
        b=Ce7SeIAPRt0APauCGY7nAWxHrbW4Yt1+Xiin+k4jd3rB1m51X4eY2hYTELD+jCeq7q
         T7qGJsGl20p0l1q3ppNnfvtR1gAlc0dm4wBxd8tcPPtR71gAzOs59Xc8yyto64Q0LfEY
         ozIRqpuweaD0R6cIt51+TQe6G1gYp0wJ1CjFQcVU8wxerp3M/Ytj5woWa+Lo05OeAa9z
         RtGNbpphlX9csmdfOf0yPafNKRlkS3IiFswANJtjXMyu+0PEWpsU4gzxKlF3hXFIaiBW
         0duT2Wp3OZvYg9OTN7v8q4eCUpOX7GRDIx6eggImQNDT9Wc3LQA3f3ElcZqbIL2jBSf0
         SR8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755103509; x=1755708309;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GBQsfHg/ZyhTgkDWvIhH6lJQIV/CSzF6SBf+6h9QT90=;
        b=R+g49qvuxjqF5EonhkN4c3WCyd9Mqxtt+is2L88JGjDX8g8QIgbs3CPXYsfHmu0mkv
         LBaCQZH7Dhfe/Z3qMLnGmMYvhZUKL/4OvH6FA7OVve9D6GzaRIQ6Qgzxcyvf/lEmNmXL
         5/UL65b10t4SoZF8NFqhlxEAB9LGjiPdY+qbOIZWQltehdHT/3/mSaP+6+UcVx+JuvXz
         DzEyD/Ce4OuTQmLgXRl9j0v/Yq87x4darOP50lYKuFAvywzwtmwDa4MYH5wPe4QV+qQf
         NM0fhbDS53c4vXT991j4tMGqrbh5cGdnoTKwokvUTXYNc+oSYP7C7DtuduTddAiUvsKd
         8Jmg==
X-Gm-Message-State: AOJu0Yy3/pbOo6xkfBviyxo1+5LAfrLGrDBNsbTau0Yf2fuyT3aX3RiH
	QHFdLrCKG+1WWz9SuDwkom8jMDkeAwVv3YpC8dNjyDa9FhDlC8qlcKgS80OVJxiY5DzDyvm4PZO
	Ubs2cscYz1mr480HjiZOWiR/k3C112GoBhVkp3RQtmoXjXSidOdPan4LvCz92JmSjNuaMbwVzQ/
	SMN+8FmaBsFn221xB/HkAXi2fgzRcGjZs=
X-Google-Smtp-Source: AGHT+IE2tdJBgqq+pKrYLNZS8C9leJxwEsJViWMuTQXg/qqAAeOo3ObjGJvwtxU1QDM6fT8EA1U6GYZxrw==
X-Received: from wre18.prod.google.com ([2002:a05:6000:4b12:b0:3b9:95c:a591])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:1789:b0:3b7:994b:8438
 with SMTP id ffacd0b85a97d-3b9edf4433amr12720f8f.46.1755103508884; Wed, 13
 Aug 2025 09:45:08 -0700 (PDT)
Date: Wed, 13 Aug 2025 17:45:05 +0100
In-Reply-To: <20250813164506.1203851-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250813164506.1203851-1-tabba@google.com>
X-Mailer: git-send-email 2.51.0.rc0.215.g125493bb4a-goog
Message-ID: <20250813164506.1203851-2-tabba@google.com>
Subject: [PATCH v2 1/2] arm64: sysreg: Fix and tidyup sysreg field definitions
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
RCWSMASK_EL1, fix typos, and convert the only instance of spacing with
spaces to tabs (in SPMZR_EL0).

Signed-off-by: Fuad Tabba <tabba@google.com>
---
Note that NSACR_RFR isn't used in the kernel as far as I could tell, so
I didn't add a 'Fixes' tag.
---
 arch/arm64/tools/sysreg | 18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 696ab1f32a67..975dcfacbfe6 100644
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
@@ -377,8 +377,8 @@ Sysreg	SPMOVSCLR_EL0	2	3	9	12	3
 Field	63:0	P
 EndSysreg
 
-Sysreg	SPMZR_EL0       2	3	9	12	4
-Field   63:0      P
+Sysreg	SPMZR_EL0	2	3	9	12	4
+Field   63:0	P
 EndSysreg
 
 Sysreg	SPMSELR_EL0	2	3	9	12	5
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
2.51.0.rc0.215.g125493bb4a-goog

