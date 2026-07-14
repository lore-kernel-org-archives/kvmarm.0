Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5165E353A93;
	Tue, 14 Jul 2026 09:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784020611; cv=none; b=J+yrOGNf7wV1DH6Pt/YwtC/O4Rj6eeYQUJzHXkJi3X8ES7CbR75prtXpnNpq873EI8HOP5Q1ZuF8azRlEVBfuMsDysq8ZoERC7+m8XQB4GcOY607TFbvxJMtikfsM7LQrRq0VRUAbBIYKL5ggX1bHUI1f+RvmfRznvqgItQlQOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784020611; c=relaxed/simple;
	bh=etB1t/Jsz/3VAMQWA59DJSYR3ZvZWtHnl2p9vlqiIB0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oSGohXgutbxsYtkvy9zWsqfvMwgOliJZVafg7LcNdNVldzCWgAAVs14f9OvQN+GBlGQNcz5UJegGQa3PP4rcNwt/pJXFp4UEd58F229n1MpWy0Lcua26DcPk+7P6XTyc0Waettgz2m4QlQEKFDmchowy3GFfLcxxpl2tSfih3GU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bfqAFx58; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bfqAFx58"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 092781F00A3A;
	Tue, 14 Jul 2026 09:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784020609;
	bh=AAaWVXp7htB6pd1cjG1QCcAG4F8gffJDPJKffSqmwRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bfqAFx58D65QoCsmBid/IstNDUEF/sXxfESOrC04DMvT9OFKrbVUneeDKn6GJ6Sl6
	 3j0wCoxsLmWSk+Wr/aLLluLOBUAPRLSoSN9n5r9mX85Cu38GV/pu9G9veaZsT3sD+7
	 UOc2ZdGr+BOHthIBTsTOOjZP0Ay3nMwPYJ6hlmOTzpSGAG8YGq9oMssgH3iAggfkLF
	 39dZZAcWCfwlnfgIk0ZojqiQCerGcouIE6IsltswcvioUUOVud/HDc9ba1o9WDar4L
	 p/8HTiixnqLKq/QgPEBgZuTunq+wRm151dlr347DAp0K5bRVz3qPkpSPzY2D0DrX0b
	 kZsQvRTOsePlQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wjZFv-00000004ny1-0mTa;
	Tue, 14 Jul 2026 09:16:47 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v2 01/28] arm64: sysreg: Emit RESx/UNKN values for Mapping/Fields definitions
Date: Tue, 14 Jul 2026 10:16:14 +0100
Message-ID: <20260714091641.1970822-2-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260714091641.1970822-1-maz@kernel.org>
References: <20260714091641.1970822-1-maz@kernel.org>
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
index 86860ab672dc7..e099f7d3b2833 100755
--- a/arch/arm64/tools/gen-sysreg.awk
+++ b/arch/arm64/tools/gen-sysreg.awk
@@ -228,7 +228,7 @@ $1 == "EndSysreg" && block_current() == "Sysreg" {
 }
 
 # Currently this is effectivey a comment, in future we may want to emit
-# defines for the fields.
+# defines for the fields. "Mapping" does emit the RESx/UNKN definitions.
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

