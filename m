Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3730396579;
	Thu,  9 Jul 2026 00:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783558380; cv=none; b=spynph9WmZ/NJAJPwrIRZJOVoCYfRYvbgqxjQBMluXAsw1aCuz6fcYZSfI4+5f/kSZmVCCiuj/Xyto9iRuPgYW4abrZiLMLCVfzxE7OY96zY90E2MFVbaItEnXyPncY9Sfbnp+xBVhhBlvMHyAZMxzGbwPCxzSla3NvG2QQ2PZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783558380; c=relaxed/simple;
	bh=++3RupEjJl/hieRBq4Zb2DcRHMWp0Yu3DKnrxPa5BCI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=FvKCL15YKNEioO7ZezlizMvs7ZHe72c6K6z6Yp4pGg3n1DM9H9OZ+1t/+aP1ZoY4gD+C3joWoF3ElQ+ARdECzDZrMhrNfDPRABhza5sdnM9pqardNvF1Sd+jEfcaJhNFBzk7i5V3DY/iKNAIgpCmMqJxg9oqNryi7oy4Bff6ZUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DgPNJUm/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DgPNJUm/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CEF71F00A3D;
	Thu,  9 Jul 2026 00:52:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783558379;
	bh=ZRzgkCokkYWeOPF3FDrRjraYcAbGSe4f3k3UbSQ8tck=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=DgPNJUm/krhS42h9PWSRuwD5nJ2uzy/kJu9TM86brWrzXwmxi0kHClMZaj+zWU2Jk
	 4EB9dv9xyGyOZ5CmOaAd2oOLKMoXdV6OriRDWbJAttH/7eL1i1U0xE4Gq0TDKWi4M/
	 JeroJkFGC+4vO/rKxtGEl8qIPa243YZP4AoNligXDnFkMi7vYLgiKnEM116PyanRL8
	 RczWQrzUe2nPbHSLWzEXPDxpw7q3U4+n77eIkRHN2NbsN92tVIl1r+6aNtfZPaPbUP
	 XXJSxVTiuTqJ0sGUPrHR7wHCEz8qPWXCMz/tQn/xrKY7GotFN5UAq5clJFZtMtKD5r
	 a3Fagh+8epEIg==
From: Mark Brown <broonie@kernel.org>
Date: Thu, 09 Jul 2026 01:51:42 +0100
Subject: [PATCH v11 05/29] arm64/fpsimd: Determine maximum virtualisable
 SME vector length
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260709-kvm-arm64-sme-v11-5-32799f66db9d@kernel.org>
References: <20260709-kvm-arm64-sme-v11-0-32799f66db9d@kernel.org>
In-Reply-To: <20260709-kvm-arm64-sme-v11-0-32799f66db9d@kernel.org>
To: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, Will Deacon <will@kernel.org>, 
 Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <shuah@kernel.org>, Oliver Upton <oupton@kernel.org>
Cc: Dave Martin <Dave.Martin@arm.com>, Fuad Tabba <tabba@google.com>, 
 Mark Rutland <mark.rutland@arm.com>, Ben Horgan <ben.horgan@arm.com>, 
 Jean-Philippe Brucker <jpb@kernel.org>, 
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 Peter Maydell <peter.maydell@linaro.org>, 
 Eric Auger <eric.auger@redhat.com>, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.16-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1382; i=broonie@kernel.org;
 h=from:subject:message-id; bh=++3RupEjJl/hieRBq4Zb2DcRHMWp0Yu3DKnrxPa5BCI=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBqTvC9yq76eGMiMwaDMr7oe2zDUIgL1q2FX4Aq6
 Eo16wMr1deJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCak7wvQAKCRAk1otyXVSH
 0EwaB/9woeMSozzvqL+P4vTBAJ50aS146ENpqdlNNNy+A+UXyHqE932HU1lx5Z52Np7ZpkeCDSJ
 nXhP3ZLJcd+Hu1xP1TgYZ2g+59QyX6x5ZSNq0cVIigfvr5YfewJqBPKWu4ucEmMl5nnS1k70ZJF
 1ncRWZ6rqrTacCbLSOYfLkefbxHS+1mJS+TsAgyCcSz/PfTWSK/YoG/RAr9xSQrV12Kt0M3p+Vy
 vBd6QM7lvLaFqDY3sXHIFopYg9ADRIPgX23VSEd/QCs6WOhIxiX+CJ3N/NcXC/PUtbkm9kJ6rei
 LLlh+Zvir1jVl3hKfHAcNPjrQlOSjQ8smoxfz729ScHdbXln
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

As with SVE we can only virtualise SME vector lengths that are supported by
all CPUs in the system, implement similar checks to those for SVE. Since
unlike SVE there are no specific vector lengths that are architecturally
required the handling is subtly different, we report a system where this
happens with a maximum vector length of 0.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/kernel/fpsimd.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index 5c156e2a47ea..7c4e69fd3922 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -1277,6 +1277,7 @@ void __init sme_setup(void)
 	 * minimum available VL will be used.
 	 */
 	set_sme_default_vl(find_supported_vector_length(ARM64_VEC_SME, 32));
+	info->max_virtualisable_vl = vec_virtualisable_vl(info);
 
 	pr_info("SME: minimum available vector length %u bytes per vector\n",
 		info->min_vl);
@@ -1284,6 +1285,10 @@ void __init sme_setup(void)
 		info->max_vl);
 	pr_info("SME: default vector length %u bytes per vector\n",
 		get_sme_default_vl());
+
+	/* KVM decides whether to support mismatched systems. Just warn here: */
+	if (info->max_virtualisable_vl < info->max_vl)
+		pr_warn("SME: unvirtualisable vector lengths present\n");
 }
 
 void sme_suspend_exit(void)

-- 
2.47.3

