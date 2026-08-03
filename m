Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32B1636CE19;
	Mon,  3 Aug 2026 23:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785798831; cv=none; b=c1M8bQnatvHz9mXBmXA4kKjqYmG0r5BaDbA1S/O4NlS2DwVIevs8olDBs9GSFiVsfRmfWJLzOn4qIoWQd8ieIMfXgFNSH6FvIqkuwVsXTo+GbvvCamfmthxk6rqsouPIeYNPqYCQAal5enXVFVQsgvAK+q6rEcLaHgZf8v8lUCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785798831; c=relaxed/simple;
	bh=DZmwxJP+W8fGWvn/wOKVMifNip3avlrIAIcelKvVs+o=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=lt92YJYtQgri4NEHRIi2trqio3NmehTQGroAu4gxCnyvV6hSNIwnBpIHmZGu3RyvKu+8qXKeHLPiHzAXjIuqdojggEC1J5XtH+4kiS+bTUwMpnqiNhg1VsTueUtTtxvLxkl7czAgqj8bQKVHOGpw85hjnkMbp6ARfuUldQIFtgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bMmg+SyI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bMmg+SyI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61E861F00A3D;
	Mon,  3 Aug 2026 23:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785798828;
	bh=MWKdz3JjvBdWuvOM6XAtmb0QINEsI1qn45G5e91+shs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=bMmg+SyIYkQotwqndKPnGAM5LzydfefBsa7HQ6mWc4Nqa+55HgPBPObG7Zr8bnuPt
	 eo18e+JEDq8jyhmEvk0zhrblYNjRFiHC5n/sG3iIxs5tH9voJeHEBC050mMowAI3sI
	 fkZt0wDRz1aRY/K/WNPE+iqp4tyPRXc56Nc47yfk7cljj3+CLr07QtVzPHPerc2HZL
	 bxVmDK16nogajsTkcIN+Tkb4J9wlo4Oo3aT8aXIEL9pHNlYMWnFpHheAWXE+jk2ETZ
	 elY8vlXTx7ILOVaex6QcBtjIhGrSwH1mbYJ+/LC86XnB5nZRodoq1PhjkUX/cg+6tV
	 Yrpp+sI6NCuQQ==
From: Mark Brown <broonie@kernel.org>
Date: Mon, 03 Aug 2026 23:56:46 +0100
Subject: [PATCH v18 01/14] arm64/gcs: Ensure FGTs for EL1 GCS instructions
 are disabled
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260803-arm64-gcs-v18-1-fd8c40f5ad88@kernel.org>
References: <20260803-arm64-gcs-v18-0-fd8c40f5ad88@kernel.org>
In-Reply-To: <20260803-arm64-gcs-v18-0-fd8c40f5ad88@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Shuah Khan <shuah@kernel.org>, Fuad Tabba <tabba@google.com>, 
 Oliver Upton <oupton@kernel.org>
Cc: Peter Maydell <peter.maydell@linaro.org>, 
 linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
 kvmarm@lists.linux.dev, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.16-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=906; i=broonie@kernel.org;
 h=from:subject:message-id; bh=DZmwxJP+W8fGWvn/wOKVMifNip3avlrIAIcelKvVs+o=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBqcSCaY5vmoCebOz+50MafMkleZZx0nmawOTK6f
 WZjtGmb/meJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCanEgmgAKCRAk1otyXVSH
 0ObQB/4rLPRCuyyEUJqVXMlIJCDtlyScXBoSu42kR26SMPfPpzjW67SeYMd7/jJucvagyxeDESt
 ydaNDDgzEr9sgMINY1YbAXjzTQu7zn6FmuQ7vS9v0hVpzgU4mdOpxpqFuZ1yq+97G30XufY6xap
 gwtYiomMJc63RZ7fECW7utdhNGeCwHrq+atUjZYpLKpj+j4MrZMm2QHfyBCuoM7LXMCV8XEqKxt
 wBtlH5C9XKnbFuUa1X7G3IvX0x150pwcA4nFUb7zMlrU082hjKbonn+QsPj6tXBlARnX+an3orG
 k0CvfWEUIzhmvwVQ19ux4o4kJvLCTdhf1+YsDmS7aTNma6b2
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

The initial EL2 setup for GCS did not include disabling of EL1 usage of
GCS instructions, also disable these traps.

Fixes: ff5181d8a2a8 ("arm64/gcs: Provide basic EL2 setup to allow GCS usage at EL0 and EL1")
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/include/asm/el2_setup.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el2_setup.h
index aa8ec9df8024..d308c6e6757d 100644
--- a/arch/arm64/include/asm/el2_setup.h
+++ b/arch/arm64/include/asm/el2_setup.h
@@ -393,6 +393,11 @@
 	orr	x0, x0, #HFGRTR_EL2_nGCS_EL1_MASK
 	orr	x0, x0, #HFGRTR_EL2_nGCS_EL0_MASK
 
+	/* Disable traps of GCS instructions at EL1 */
+	orr	x2, x2, #HFGITR_EL2_nGCSEPP_MASK
+	orr	x2, x2, #HFGITR_EL2_nGCSSTR_EL1_MASK
+	orr	x2, x2, #HFGITR_EL2_nGCSPUSHM_EL1_MASK
+
 .Lskip_gce_fgt_\@:
 
 .Lset_fgt_\@:

-- 
2.47.3

