Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F14431F707F
	for <kvmarm@lists.linux.dev>; Mon, 21 Oct 2024 18:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729534481; cv=none; b=c6XuVXiC32lMab1jhvoxO8ixPLO1IuzV/hYu4ppJhh82+8kEGxn3UpUrs/RKalGKAEANTClv+8wN+uL7PzCdIfwHZ5evWbxmOV/5Gjz1isZqfSEI58GqTZjSTw+blZg7zn/Ky3tS/w2lDfbEHvuEJdO2rVl/+WRZkCwT2GHnZN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729534481; c=relaxed/simple;
	bh=Kl5tVxl8qYANnVpLWO7nEiJyHaPidpv8qU5ilno6mVI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=IszQ/cB+fq6CP6J8A/h1kdC0CGEucbQ1zOASgClnupScQOYmcCWHk0TLybxE6EvbUtUTGsaL1PZB0cD0anBkjyDWHrvq70IwWev1ZSsbziZE+yuy7KVnNAqS0il8K1yKhgnXF/I0+WTm/CFpVyYm/DEhizxlke1W5YNWNn6QPkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gIl+DF+S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gIl+DF+S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 708F4C4CEC3;
	Mon, 21 Oct 2024 18:14:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729534480;
	bh=Kl5tVxl8qYANnVpLWO7nEiJyHaPidpv8qU5ilno6mVI=;
	h=From:To:Cc:Subject:Date:From;
	b=gIl+DF+SHiDp336BQrrQVE70piZ2lUrAhYb0JuOYLvCquJx7J+SO1dCJkgFZK2r/q
	 xZY1TZP5kcCl6JA37Pkpp6JBTnTnDhnD0xoyDGBBB1F5w+HSjigYvs2LZDZKUursTX
	 1mR8JxXZ2BoQUdkmLzHqLaFTwtpeLAgtku3fR91jyPsH1EslzC062XSEi4femOrVo2
	 yShzIBATTF4jnLmoCFG4PpOCZdJGVxJUzHDhrI2xfFisdrLcbvmTm+5FexqpQS3X70
	 x1vnq5Eqmote+qUbCxV35sg1cEjZnmqNbVVjC3CMSy8jbElflsoxN+cjbmKaNCrHk6
	 Q3Ra3Jk1XvISg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1t2wvN-005WM0-Uk;
	Mon, 21 Oct 2024 19:14:38 +0100
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH] arm64: Add command-line override for ID_AA64MMFR0_EL1.ECV
Date: Mon, 21 Oct 2024 19:14:34 +0100
Message-Id: <20241021181434.1052974-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, will@kernel.org, catalin.marinas@arm.com, oliver.upton@linux.dev
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

It appears that relatively popular hardware out there implements
the CNTPOFF_EL2 variant of FEAT_ECV, advertises it via ID_AA64MMFR0_EL1,
but cannot be bothered to set SCR_EL3.ECVEn to 1.

You would probably think that "this is fine, EL3 will take the
trap on access to CNTPOFF_EL2 and flip the ECVEn bit", as that's
what a semi-decent firmware implementation would do.

But no. None of that. This particular implementation takes the trap,
considers its purpose in life, decides that it has none, and *RESETS*
the system.

Yes, x1e001de, I'm talking about you.

In order to allow this machine to be promoted slightly above the
level of a glorified door-stop, add a new "id_aa64mmfr0.ecv" override.
allowing the kernel to pretend this option was never there.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kernel/pi/idreg-override.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm64/kernel/pi/idreg-override.c b/arch/arm64/kernel/pi/idreg-override.c
index 29d4b6244a6f6..fbc37b2733e20 100644
--- a/arch/arm64/kernel/pi/idreg-override.c
+++ b/arch/arm64/kernel/pi/idreg-override.c
@@ -38,6 +38,15 @@ struct ftr_set_desc {
 
 #define FIELD(n, s, f)	{ .name = n, .shift = s, .width = 4, .filter = f }
 
+static const struct ftr_set_desc mmfr0 __prel64_initconst = {
+	.name		= "id_aa64mmfr0",
+	.override	= &id_aa64mmfr0_override,
+	.fields		= {
+		FIELD("ecv", ID_AA64MMFR0_EL1_ECV_SHIFT, NULL),
+		{}
+	},
+};
+
 static bool __init mmfr1_vh_filter(u64 val)
 {
 	/*
@@ -196,6 +205,7 @@ static const struct ftr_set_desc sw_features __prel64_initconst = {
 
 static const
 PREL64(const struct ftr_set_desc, reg) regs[] __prel64_initconst = {
+	{ &mmfr0	},
 	{ &mmfr1	},
 	{ &mmfr2	},
 	{ &pfr0 	},
-- 
2.39.2

