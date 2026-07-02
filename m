Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A694718DB37;
	Thu,  2 Jul 2026 16:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783008182; cv=none; b=etoZctJe/g9932g+G7sc3ng1vaB65HO/SasnHCyQfKuGlLx2j7KxBi77bFst/BPVM2v+mN6HlAi+zVByUp8kEWNaxSAcFwxuIcU1Rn3r6Ac5Amm++nPWltmF6JMmRCEWYtKC9+WwY/IYJcPgd0LzzOW2WgQtYcCgCHsuxtD4mmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783008182; c=relaxed/simple;
	bh=zw+gb60mVbA0TNw0zvmfKB6yjhMHk4JyoPSFzMKvURA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CautNCg5O8ldu7T6vXp28J8lnNt3RCgVPIGpONnzMqYt/8hMrDkOUdOpVQj+2D2V2Pd56Rb9jVHi5UQaZrFNiIayo31pFoXeNsLsHs8Z177PVEfBwrYAbbm3DZ6cbbSVZmdoX78pc+dye6SBxZKXauvX54sn7BW5STHQ7drWuhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KlrCelUn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KlrCelUn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67D8B1F000E9;
	Thu,  2 Jul 2026 16:03:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783008180;
	bh=RvPGrV8NE4JxDz89/TlgY36u3wEzVwPRYMNH7LCnBU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KlrCelUnYJZceEN21WvSOb/jRMKU06rbbjMSh3Mlqrh1HmoLYJG8EKqCSbtuKg0xc
	 YJ7/98/qtH94SIS/EvIlhZ6vQo2ZKrEpD2fghuWeoAclJgHMdrhMynEB/ZFyPFQqoU
	 euHESnDvzGpqJvvgN1rRGaNm4GMDMAK0iwUAjVMi+ZrOgZ44AQX5blMlYjxjeZ8W6g
	 k7z5H4obH8FiG6k1snzoZQDvYFjctrNV8bbXYW8uh4kQlbxHMVr7tMRid7H4BrhPtX
	 uxU/fCJUa4Q7KCOwfjpdZ2Ue+VxVq0Qod8bvPLvk5CkCQVky2lKB5Za7JB+OTX2/Eu
	 PHxnRKH/ZJZiA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wfJsQ-00000000ojd-1JvR;
	Thu, 02 Jul 2026 16:02:58 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 01/28] arm64: sysreg: Emit RESx/UNKN values for Mapping definitions
Date: Thu,  2 Jul 2026 17:02:21 +0100
Message-ID: <20260702160248.1377250-2-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260702160248.1377250-1-maz@kernel.org>
References: <20260702160248.1377250-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

The sysreg file is using the Mapping qualifier to indicate that
a given encoding is only a mapping to a particular register.
As a result, we don't output any definition, and instead expect
the canonical definitions to be used.

This works rather well for individual fields, but creates problems
for macros that refer to more generic classes of bits such as RESx.

Relax the above rule by emitting the RESx and UNKN values for Mapping
qualifiers as well.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/tools/gen-sysreg.awk | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/tools/gen-sysreg.awk b/arch/arm64/tools/gen-sysreg.awk
index 86860ab672dc7..d7f7ceb768fe5 100755
--- a/arch/arm64/tools/gen-sysreg.awk
+++ b/arch/arm64/tools/gen-sysreg.awk
@@ -228,7 +228,7 @@ $1 == "EndSysreg" && block_current() == "Sysreg" {
 }
 
 # Currently this is effectivey a comment, in future we may want to emit
-# defines for the fields.
+# defines for the fields. "Mapping" does emit the RESx/UNKN definitions.
 ($1 == "Fields" || $1 == "Mapping") && block_current() == "Sysreg" {
 	expect_fields(2)
 
@@ -239,9 +239,15 @@ $1 == "EndSysreg" && block_current() == "Sysreg" {
 	print ""
 
 	next_bit = -1
-	res0 = null
-	res1 = null
-	unkn = null
+	if ($1 == "Mapping") {
+		res0 = $2 "_RES0"
+		res1 = $2 "_RES1"
+		unkn = $2 "_UNKN"
+	} else {
+		res0 = null
+		res1 = null
+		unkn = null
+	}
 
 	next
 }
-- 
2.47.3

