Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 931AC14A08E
	for <kvmarm@lists.linux.dev>; Sat,  7 Dec 2024 19:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733598488; cv=none; b=gRFOn1ROMqVfH3CLRWXtjvjkR0bFYUxrq5q3HURDAsWOyqjU2BpoWC6Xu+qH5CnF99/EnYUSwOOdnajA5DSB7q4QghFe89NACH9aDzs/jtaoIKd+gJeHWhoHXz3i5spgDkeSImKYUaWOJ22+VWxWSIzdVhkKCLE0BKc5YHnPNd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733598488; c=relaxed/simple;
	bh=ieCSJY6ovtV+5BP0KLjpV97miFo9w2jKSQmZAKncuJk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dY14H/A/WQQaxZbZhSTgC3bkPO1JDONNUavlwlr0ntMFFIZobAeE1voz/Z3pz1Z+hmPe34ygfS12E443f/F6fqwuhL5NWQpq9KCdY3SR85I8tR7tfYCABoTM7tgx9MTiLclqo4yY66BsUtq0mMjwRy6jlfSSr13R4Ua5Ao6c6nI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mDstrgRc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mDstrgRc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E789C4CEE0;
	Sat,  7 Dec 2024 19:08:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733598488;
	bh=ieCSJY6ovtV+5BP0KLjpV97miFo9w2jKSQmZAKncuJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mDstrgRc3DVnIPMquH9SUR5DmN++/RW9bLlH+EXnQNm1tPZjG/GQmwRUuD92yMN5Y
	 /sZT5Qeu6XmbZ7Ur/xO29B5aGMrog2esOHQMsd/2dP/G6SxIO+E6Kw0cMuCjq7GoGm
	 H2uV0V/DDrXYM0F5h3jTTgBUx4/2ydMw7befQBC16Lsjh+M6ta0VcvmlG/dgkP7g1o
	 QZkuVHrncM9M4kEHlycnZWII0OW34n/jIJHAfTG6Y2dLHSkR1K5QtLpCbrtrHc3cv7
	 nGGeGH8Wf8FFR0PFDwC2xGzTrpmHbe2SiivkHx/hL4INnUAAD5OCBuJpXNw6/lBPlK
	 uZkMDzqLlbQRg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tK09u-001TOc-3X;
	Sat, 07 Dec 2024 19:08:06 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 1/4] arm64/sysreg: Allow a 'Mapping' descriptor for system registers
Date: Sat,  7 Dec 2024 19:07:37 +0000
Message-Id: <20241207190740.2607673-2-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20241207190740.2607673-1-maz@kernel.org>
References: <20241207190740.2607673-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, joey.gouly@arm.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

*EL02 and *_EL12 system registers are actually only accessors for
EL0 and EL1 registers accessed from EL2 when HCR_EL2.E2H==1. They
do not have fields of their own.

To that effect, introduce a 'Mapping' entry, describing which
system register an _EL12 register maps to.

Implementation wise, this is handled the same was as Fields,
which ls only a comment.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/tools/gen-sysreg.awk | 2 +-
 arch/arm64/tools/sysreg         | 7 +++++++
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/tools/gen-sysreg.awk b/arch/arm64/tools/gen-sysreg.awk
index d1254a056114e..1a2afc9fdd42e 100755
--- a/arch/arm64/tools/gen-sysreg.awk
+++ b/arch/arm64/tools/gen-sysreg.awk
@@ -206,7 +206,7 @@ END {
 
 # Currently this is effectivey a comment, in future we may want to emit
 # defines for the fields.
-/^Fields/ && block_current() == "Sysreg" {
+(/^Fields/ || /^Mapping/) && block_current() == "Sysreg" {
 	expect_fields(2)
 
 	if (next_bit != 63)
diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index b081b54d6d227..b6846c601df6c 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -38,6 +38,13 @@
 # Fields	<fieldsname>
 # EndSysreg
 
+# For register names indicating a cross-EL access (*_EL12, *EL02),
+# a Mapping entry describes the register it actually accesses:
+
+# Sysreg 	<name_EL12>	<op0> 	<op1>	<crn>	<crm>	<op2>
+# Mapping	<name_EL1>
+# EndSysreg
+
 # For ID registers we adopt a few conventions for translating the
 # language in the ARM into defines:
 #
-- 
2.39.2

