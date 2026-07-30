Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C2A1390CB7;
	Thu, 30 Jul 2026 07:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785395456; cv=none; b=FkfIzZwflaYiGUHt72wlT/dG2C9CA5ggWw1hTor06UeUHdmGpFQVA4ofGxsTFjvvMsXY9l1PFU96IMnDhxuOqK+nNrrzZYwWPfk6pQqCxXaE4m7OrvgyZ0b3X0GN/Zh632N6qrLpUiFX1Z/Vig4KngHexsANEeH/nevcMxDfSv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785395456; c=relaxed/simple;
	bh=Irah+PadLzYNreyWrL9/KP7/XTf98UCFdHV1fXwmNRw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OAH/ebjD3PkDQjCRzfj55eGFvcpKlK3MH8jCwn/PTqF2XpO3nPpkme9p6YQfeh285Md4uQaIIKfaC+zGmV7nFaGpdux1KzbQyyIuFohOozyir6TN5cm2uMXrV4ZexeR8iomTIdKHad9cXi8/85+RI8K/1ePltfDaZ+Ipm+G3orw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BSHbh99N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BSHbh99N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CE211F000E9;
	Thu, 30 Jul 2026 07:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785395450;
	bh=iOnrRfQe8JkETVZDmjV9EvPQTRH5bPfEGXwyCXiiPF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BSHbh99NGA02Td/bKG0/cqv/sMGO0n56yKm7Mz0SxDQd0N8Ep0U+8DsoCTgLJXKkf
	 rfiLWuNy5L+7VqT6ZiGXrEmRX5SQmBzgmpaMNR9yv2Z+cWKSmZsMXnt1CRKghj67og
	 Jlz783Kh+MXgRk8xuVZchrCavdEz4gAoZMyyBNWJhNRH88eTN2NwsXeLfKn4fNFSI3
	 6Sp4KJTrkMIVy/fBAsFDWt33fV498qv5BJbjYOa47Sot2WO4t+I7uLggFZH9aDHZDa
	 Y4Fc3+ECVeaC2ZRbY5F0D4fPgIq+dDoxUG1io9TGQGL0cJPM59FXj37ZVh2rd85xhv
	 IXt+aAXsA56tw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wpKum-0000000AOpW-2Bhh;
	Thu, 30 Jul 2026 07:10:48 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Yao Yuan <yaoyuan@linux.alibaba.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Vladimir Murzin <vladimir.murzin@arm.com>
Subject: [PATCH v4 01/29] arm64: sysreg: Emit RESx/UNKN values for Mapping/Fields definitions
Date: Thu, 30 Jul 2026 08:09:54 +0100
Message-ID: <20260730071022.296811-2-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260730071022.296811-1-maz@kernel.org>
References: <20260730071022.296811-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, yaoyuan@linux.alibaba.com, weilin.chang@arm.com, vladimir.murzin@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

The sysreg file is using the Mapping or Fields qualifiers to indicate
that a given encoding is only a mapping to a particular register (or
an instance of a more generic register definition).

As a result, we don't output any definition, and instead expect
the canonical definitions to be used.

This works rather well for individual fields, but creates problems
for macros that refer to more generic classes of bits such as RESx.

Relax the above rule by emitting the RESx and UNKN values for Mapping
and Fields qualifiers as well.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/tools/gen-sysreg.awk | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/tools/gen-sysreg.awk b/arch/arm64/tools/gen-sysreg.awk
index 86860ab672dc7..53844f5c5e525 100755
--- a/arch/arm64/tools/gen-sysreg.awk
+++ b/arch/arm64/tools/gen-sysreg.awk
@@ -228,7 +228,7 @@ $1 == "EndSysreg" && block_current() == "Sysreg" {
 }
 
 # Currently this is effectivey a comment, in future we may want to emit
-# defines for the fields.
+# defines for the fields. We do emit RESx and UNKN values in any case.
 ($1 == "Fields" || $1 == "Mapping") && block_current() == "Sysreg" {
 	expect_fields(2)
 
@@ -239,9 +239,9 @@ $1 == "EndSysreg" && block_current() == "Sysreg" {
 	print ""
 
 	next_bit = -1
-	res0 = null
-	res1 = null
-	unkn = null
+	res0 = $2 "_RES0"
+	res1 = $2 "_RES1"
+	unkn = $2 "_UNKN"
 
 	next
 }
-- 
2.47.3

