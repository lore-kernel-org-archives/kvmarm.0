Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F8C7288CB7
	for <kvmarm@lists.linux.dev>; Wed, 13 Aug 2025 16:45:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755103513; cv=none; b=kxecVIr2hcSn46SIHjwwrsbNUS7lXQEZWMZrFKhOqomiuCF5CK51guTker2/RwDr+X30G8XG4/c9fKzEFa9KqKMqUeYoVQj5Sbta8P8mWvYIw7tyNpf8rCpt2FneBJsZt8ySSYwqcULOqwtHXL/mtUvYb1SdWAeD/A3CjDX9bAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755103513; c=relaxed/simple;
	bh=INFQkvd7Z9WsIBct3De5UH7q4C3opQyrd0zFYOSH2Xc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RM+5myenCwmJewOckFXCTOSBPktizXCMIHG5CETXqj1wJ7pW4Rfe3bmvuVThAoOeKtxs7lPK19DE/4Y0EOrsmsVXgbHWdrFFlSwYAHqqKlvbuz5sfcxtz2NQxdmsu0hwGYbPdds/H0RLwMeD/HvIlcBSCzc54gruMSyCxIl1ZXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Qm7iluWe; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Qm7iluWe"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-459dfbece11so35313795e9.2
        for <kvmarm@lists.linux.dev>; Wed, 13 Aug 2025 09:45:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755103510; x=1755708310; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2sp3aPSAtyo6I6rR6nNXHOeKvBEwtpMGHhEmiY/HzQI=;
        b=Qm7iluWeC9zDDaYpBC0dY0i5bRWwcRcfTk3IivQ4f5h78xBZnTcQ8VcxGvZZgasaei
         pRggivWGD9svN5RiIMfcsgcCY0BuPjqmtahq2nZvHr4i9ncxoqPkcUIDkbWmzrOKgQ5Q
         rhuCza7vW4lAEiL2C/9lFH/f+Uu9o+ntf2Y/IxXBv028lI1Q68CmtS9ypczTCSQJmbKx
         lqPiXaNauKKS3+KEcb4JyOZfiewRSIdvRCqeb0HwrFG8dakEyLpsguvY3hD6Xp6Sb6FG
         g0DhuBnsHGOngnW3lxHtkZozuLXW+LU6oSErXoiPMYtFLnk5t/Ypx+Fw9COidXdx9Cbv
         YBSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755103510; x=1755708310;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2sp3aPSAtyo6I6rR6nNXHOeKvBEwtpMGHhEmiY/HzQI=;
        b=EkxGHLZa9LXz0ZDPtvzxBmmdGw5dUlr23rCt7hWhOkNmtenSV9jROb8VM97WKvhLKQ
         kiXs9VsacZeegQKwAtmCgwYipzcHFOgtUDGlScrEI/2X8SZO5CbJFqQgsmhC1OjZ2Mrm
         5fZwlnuacWh806v4DsyQB1Tidpx2/Doh6EqA1D6a7GBkKcp5clvtKU0/Jjtp9BlDh7yG
         5XOqxwtroB9epZo5ZuGZFVBhbWoWrjryRgniyClHduP402x0HoIcpq1chqeVLuvRY3aH
         5VWmSVD6vh0yvw+4wC3o8Yl56QMOcNEPy/HujXyJ0D3nuTheeKCnm3XvT7TA3hRxl+98
         79qw==
X-Gm-Message-State: AOJu0Yzsn6x2vJavfd6ZT3qXbCf5QKbO4zdDi2sF2+lBxPpszt/JejVj
	QJp2wINE3B0Pc1SwTOaKUNYWS3GMxtTiOiZ+iOSEISduCATZMynNkuq1ZyOaWrMUBG/qkNEz8Bt
	4JGe21sblrxut13ketMA30yB1BMUAYX/bJSnt3ebI7ZiAeZNTWGM1x6hXZuN+RHVDzdEj068/da
	3bpuTJmCV7pePM0UuBxdGPIEXRffGve3I=
X-Google-Smtp-Source: AGHT+IHSkTxAvev72EiizIpa601N7yiEbIYtlzv/L++w8V6rBQLkl95wQlGjod9UkIaNfBEXvNzWjE/1PQ==
X-Received: from wmby11-n2.prod.google.com ([2002:a05:600c:c04b:20b0:458:6799:d779])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:3b23:b0:456:eab:6344
 with SMTP id 5b1f17b1804b1-45a165c4f74mr36679425e9.15.1755103509761; Wed, 13
 Aug 2025 09:45:09 -0700 (PDT)
Date: Wed, 13 Aug 2025 17:45:06 +0100
In-Reply-To: <20250813164506.1203851-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250813164506.1203851-1-tabba@google.com>
X-Mailer: git-send-email 2.51.0.rc0.215.g125493bb4a-goog
Message-ID: <20250813164506.1203851-3-tabba@google.com>
Subject: [PATCH v2 2/2] arm64: sysreg: Add validation checks to sysreg header
 generation script
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, will@kernel.org, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, vdonnefort@google.com, qperret@google.com, 
	sebastianene@google.com, keirf@google.com, smostafa@google.com, 
	tabba@google.com
Content-Type: text/plain; charset="UTF-8"

The gen_sysreg.awk script processes the system register specification in
the sysreg text file to generate C macro definitions. The current script
will silently accept certain errors in the specification file, leading
to incorrect header generation.

For example, a Sysreg or SysregFields can be accidentally duplicated,
causing its macros to be emitted twice. Or an Enum can contain duplicate
values for different items, which is architecturally incorrect.

Add checks to catch these errors at build time. The script now tracks
all seen Sysreg and SysregFields definitions and checks for duplicates.
It also tracks values within each Enum block to ensure entries are
unique.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/tools/gen-sysreg.awk | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/arch/arm64/tools/gen-sysreg.awk b/arch/arm64/tools/gen-sysreg.awk
index f2a1732cb1f6..bbbb812603e8 100755
--- a/arch/arm64/tools/gen-sysreg.awk
+++ b/arch/arm64/tools/gen-sysreg.awk
@@ -122,6 +122,10 @@ $1 == "SysregFields" && block_current() == "Root" {
 	res1 = "UL(0)"
 	unkn = "UL(0)"
 
+	if (reg in defined_fields)
+		fatal("Duplicate SysregFields definition for " reg)
+	defined_fields[reg] = 1
+
 	next_bit = 63
 
 	next
@@ -162,6 +166,10 @@ $1 == "Sysreg" && block_current() == "Root" {
 	res1 = "UL(0)"
 	unkn = "UL(0)"
 
+	if (reg in defined_regs)
+		fatal("Duplicate Sysreg definition for " reg)
+	defined_regs[reg] = 1
+
 	define("REG_" reg, "S" op0 "_" op1 "_C" crn "_C" crm "_" op2)
 	define("SYS_" reg, "sys_reg(" op0 ", " op1 ", " crn ", " crm ", " op2 ")")
 
@@ -284,6 +292,8 @@ $1 == "SignedEnum" && (block_current() == "Sysreg" || block_current() == "Sysreg
 	define_field(reg, field, msb, lsb)
 	define_field_sign(reg, field, "true")
 
+	delete seen_enum_vals
+
 	next
 }
 
@@ -297,6 +307,8 @@ $1 == "UnsignedEnum" && (block_current() == "Sysreg" || block_current() == "Sysr
 	define_field(reg, field, msb, lsb)
 	define_field_sign(reg, field, "false")
 
+	delete seen_enum_vals
+
 	next
 }
 
@@ -309,6 +321,8 @@ $1 == "Enum" && (block_current() == "Sysreg" || block_current() == "SysregFields
 
 	define_field(reg, field, msb, lsb)
 
+	delete seen_enum_vals
+
 	next
 }
 
@@ -320,6 +334,8 @@ $1 == "EndEnum" && block_current() == "Enum" {
 	lsb = null
 	print ""
 
+	delete seen_enum_vals
+
 	block_pop()
 	next
 }
@@ -329,6 +345,10 @@ $1 == "EndEnum" && block_current() == "Enum" {
 	val = $1
 	name = $2
 
+	if (val in seen_enum_vals)
+		fatal("Duplicate Enum value " val " for " name)
+	seen_enum_vals[val] = 1
+
 	define(reg "_" field "_" name, "UL(" val ")")
 	next
 }
-- 
2.51.0.rc0.215.g125493bb4a-goog

