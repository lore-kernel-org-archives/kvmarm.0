Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A30D81953A2
	for <kvmarm@lists.linux.dev>; Thu, 19 Dec 2024 17:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734629640; cv=none; b=p3pk2shNdKP/q9BP0URaDbh17+QLyyupherFCGpKFKbm596j2+IHCSoSHM5PfjXKkwLmBOuRjKW5/sn6OIjzMB/OJHDqNZmAPBR5aHry1P7xExHhgvdPpYqGzHrqfn0JqAvpQAwYljEisCjuNWpHntJB+eSYlzwCV0weEUEEakM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734629640; c=relaxed/simple;
	bh=U56i2WXsnIsJr7tkVTslgQGtPhVuhDr/tiC3IyFjrJM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=SJXK+TwLwumEA7qxGgAEzBZ4HLf7LB11R9jFVxiHx57nWtXSMkGo50vBFRPK1xoZzwfJvgnVOIidK9N/+cWeR91KLVMr3DkBifNICanAJfOy+bHy5uDB9mXRu4c81NWDoK7BB0YOj2maKQGeF6pTixhqPFY9ZwOOE8e9bnEmg/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dcHv8K3/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dcHv8K3/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 333EEC4CECE;
	Thu, 19 Dec 2024 17:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734629640;
	bh=U56i2WXsnIsJr7tkVTslgQGtPhVuhDr/tiC3IyFjrJM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dcHv8K3/4VXnAFYhzkqzKh4G8HAJd2mqFzy2O2hvlgTiVZfx9D6AGTEkcX49IfuPh
	 vTQEcVvYXbdiQ0amtd/r6XaKzW+/MGW1iJoObvWIWVPMWG7b5kXE85e6v0Z4i65CJ5
	 Gu5sRz4aFuaakvEN5sMvh7szDZWUnSkGgVO2NA1fcY7wTz25p01729WMkfY29YJX4R
	 hKjheB4/zgIQLnIAvkGvOaN/OTRqZeJO5VqF8lY6lDOcFsz7pYaaHQcgtR0WJQN5Ik
	 GIgFt31iA7TeYViDWkz1Och2g7n14oJjMrAicvkW1zL8Uw2UmEM7gr7A29GlKtYxvu
	 RK3RJQrQYbfug==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tOKPO-005Lao-E7;
	Thu, 19 Dec 2024 17:33:58 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v2 1/4] arm64/sysreg: Allow a 'Mapping' descriptor for system registers
Date: Thu, 19 Dec 2024 17:33:47 +0000
Message-Id: <20241219173351.1123087-2-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20241219173351.1123087-1-maz@kernel.org>
References: <20241219173351.1123087-1-maz@kernel.org>
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

Acked-by: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Mark Brown <broonie@kernel.org
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/tools/gen-sysreg.awk |  2 +-
 arch/arm64/tools/sysreg         | 12 ++++++++++--
 2 files changed, 11 insertions(+), 3 deletions(-)

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
index b081b54d6d227..da3f02cdf1052 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -24,8 +24,16 @@
 #	...
 # EndEnum
 
-# Alternatively if multiple registers share the same layout then
-# a SysregFields block can be used to describe the shared layout
+# For VHE aliases (*_EL12, *_EL02) of system registers, a Mapping
+# entry describes the register the alias actually accesses:
+
+# Sysreg 	<name_EL12>	<op0> 	<op1>	<crn>	<crm>	<op2>
+# Mapping	<name_EL1>
+# EndSysreg
+
+# Where multiple system regsiters are not VHE aliases but share a
+# common layout, a SysregFields block can be used to describe the
+# shared layout:
 
 # SysregFields	<fieldsname>
 # <field>
-- 
2.39.2

