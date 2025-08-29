Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79442304BC9
	for <kvmarm@lists.linux.dev>; Fri, 29 Aug 2025 09:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756461113; cv=none; b=qLB1Hr7JK4qMkEQrEIaSTeE/pd0JZmVYMclVwMEzRGRfPRb2QbwHzoH+2uS45XtRTX7JpQwU4ABXRrOIdBMQ6Gb9NfQPhNGBo3yrQs3k+efkO6WyIO1lJiPYd5x9pqq42r+nDO0ZFVkV/tmAGsEl0oZh2fQtJEUTrMR54CL1Csc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756461113; c=relaxed/simple;
	bh=oEdRYVAUDISCgs71h3yL9kgq6IcvE79B7Fa4BWc04JI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TCsEA6O1b0TRsDGARulWz9BzAitznHH+fPquscQj1b7F2I9e1a7aSdETtiixi5GHBvjD7Va2odG4avp9Cun0/7j0rA1nuZUwMI9RgjQm4GAhZHakbOQT86akGCIpgWrgcXX8tS29Ah4BTxMwlqwgi6YY5MLiRC0WIXUoJxdZfpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xRO9oKMj; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xRO9oKMj"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-45a1b0098c0so15029885e9.0
        for <kvmarm@lists.linux.dev>; Fri, 29 Aug 2025 02:51:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756461110; x=1757065910; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wUtIC/PUlgbnKWmqB1hhaXTqqtxzlLh5ui1srkbL3AQ=;
        b=xRO9oKMjHGKC/ch0nFmk1mtZmkhYDDvSDEyQTGDgABzT8zBCdqNgdePxRm12NGw/wb
         8R0yIULeGFwe4yYJTFbrCkji5KCZsKfRwQpg2L3bgh8mHSKyoOFS9PRf59WlfLYI9PjK
         q/MMN5RaEUWKp597QvzW7i8J/h87MhwzyXDQdCAwYUq4iTzaKyLyFDYPX3T5FPDuXFTS
         MvMSCBnCzbcS6s9zAhJ2eGuDnqvr8n8Hp4zpU/bIEoB8KWeHAAPLi36jl36avWmV+lZv
         rs7BCTCA7PpKx0x7ybIpNJHQBnw5ER6kditr18RklVSEiBalltSUItBIHf66Vcizxob+
         cZ0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756461110; x=1757065910;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wUtIC/PUlgbnKWmqB1hhaXTqqtxzlLh5ui1srkbL3AQ=;
        b=TBHH4PvScqGm/bfUtQOy/hY7PXOnuG9PXlh5GNhzbWu061TZfwsu0a+6sN0gck2f2f
         4qkr0tM1WAdz+gnmIkvcZxXTuIaB7Ijez4btKDA9BMV1LlC1ODjLBfI/JT3Ra+J29qp4
         tBtCvbB6ez6CoYywJRvBPDIcWxOKajKhZ09sVKiOz9oInvdERc9ffNKSRySZYZQ37GWe
         Sa6X3u3GvfcxsI3vu/6/xs9qIqzo227OZUrFP14wCUsnR3PdX1lRD/Z6r3h/qmG4MOnx
         GLR5cLvMPN+Vd7V73ET5jo+MblxJDDMy/YIYdHrpD1gZS2jyLhti6pJyR+WscNfmmtRJ
         3mzA==
X-Gm-Message-State: AOJu0Yw66NFf615fqIq8kLzJcqewIUVm7kbQjXiVpX7JgE2zM6Z/3Eu2
	3QEoHscFYQckGj/qDQtcWCfN30oHSWEGiH2UkXI2QiDccqJO2WDxn/AxcMmhjGlzmYO0BbuwABb
	HUWFcrAJEWNXco6XCrIK0Mg2qCuhMzRtrGX0NnKNEtWTPPnJhTo1xnchxY8JBRn+4rfhq3KAxV7
	LZ0cZRXNXph/6Fb1RJosSIHlo0EeQ+8I4=
X-Google-Smtp-Source: AGHT+IG4LZvprQPgXGbuTP/AJPiF0vWUOEP8YRyLeAssbzWZY1ebzdVHOewocmmnLPmpci27WwY3j7d7sg==
X-Received: from wmht1.prod.google.com ([2002:a05:600c:41c1:b0:45b:79d1:abcb])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:5491:b0:459:d9a2:e927
 with SMTP id 5b1f17b1804b1-45b51798f8fmr242471655e9.5.1756461109684; Fri, 29
 Aug 2025 02:51:49 -0700 (PDT)
Date: Fri, 29 Aug 2025 10:51:43 +0100
In-Reply-To: <20250829095143.123476-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250829095143.123476-1-tabba@google.com>
X-Mailer: git-send-email 2.51.0.338.gd7d06c2dae-goog
Message-ID: <20250829095143.123476-4-tabba@google.com>
Subject: [PATCH v3 3/3] arm64: sysreg: Add validation checks to sysreg header
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
causing its macros to be emitted twice. An Enum can contain duplicate
values for different items, which is architecturally incorrect.

Add checks to catch these errors at build time. The script now tracks
all seen Sysreg and SysregFields definitions and checks for duplicates.
It also tracks values within each Enum block to ensure entries are
unique.

Acked-by: Marc Zyngier <maz@kernel.org>
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
2.51.0.338.gd7d06c2dae-goog

