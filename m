Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB5C23BB661;
	Thu, 30 Jul 2026 07:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785395471; cv=none; b=gxWkqGeGP3GUkn6gQVFO/uuuo1bRU+2/6eFnsolrXKGm9kZGX/8eUQhjkius2P5FGCzXll7fk3RqOu3jMyLv4dB06Jl2kOujPhEnusn09oe+ap5bsrLqEuQlf/ims93d7v/Je6PMiNADdP1beQL8ZbvnNT/BQNawEN8SZ99ICW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785395471; c=relaxed/simple;
	bh=x2DLtgcCc+xLmDqHm9yAZAC3lIaDeJFTPupmUUEsit4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uwxD8Kg7Glvkumyoj9r3rg64oMAWakHtN6eGkwhAywlqxT+45n78pRALGKjJXmZYOIPyc3nVmx7mtMS7SKe7UD/27GjWw/ZXVQlUBAB9y4LmF9kP1p5x3AKWXJD87v5aiUKLgUSZww/d7YOI2dffkxwumIGw/Qv6HxYNFMg2W6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UgGW74N+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UgGW74N+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A03E01F0155C;
	Thu, 30 Jul 2026 07:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785395455;
	bh=mkISEBdKQXTLtBTeW4DpAIt58hfEpY8sXlqoKZXUGQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UgGW74N+qg4FqLplOWeGqE+f0OB0l6JW0dS5Z+LEWB3Eh4K9+OPdGnWoo+pN57N00
	 9N9fe8gL3RbeSR2ltLBZFp+J8x+mD8cj5l/a5j+piMa7dG2rfZjVHitbn4HdlKE287
	 nxY0+Yf9DwTD6qM397wgYZhf0tB8Qtc627f6lKjl7xfMn5HzWaGBYCOKqEA+6DxQOM
	 qbv8AfcaOeEiqrBWhsr09UetqRm0OtbbcXpgMdfkx9xBY/CMKU2fIUZ7xvv82+wW9I
	 EjGouVJHoNI/5GcAx788nwnaWE39gtmkYfgU5SJO8ZysAUuDJlrzq8EleWBBAIRiVE
	 bcNSQq9GlTCnQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wpKus-0000000AOpW-055L;
	Thu, 30 Jul 2026 07:10:54 +0000
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
Subject: [PATCH v4 26/29] KVM: arm64: Add FEAT_NV3 detection
Date: Thu, 30 Jul 2026 08:10:19 +0100
Message-ID: <20260730071022.296811-27-maz@kernel.org>
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

Now that everything is in place to engage the FEAT_NV3 fast-path,
add the detection code to cpufeature.c.

Reviewed-by: Yuan Yao <yaoyuan@linux.alibaba.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kernel/cpufeature.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index c9c124b0ccc8e..6ae1c816e2010 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -2627,6 +2627,13 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.matches = has_cpuid_feature,
 		ARM64_CPUID_FIELDS(ID_AA64MMFR4_EL1, NV_frac, NV2P1)
 	},
+	{
+		.desc = "FEAT_NV3",
+		.capability = ARM64_HAS_NV3,
+		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
+		.matches = has_cpuid_feature,
+		ARM64_CPUID_FIELDS(ID_AA64MMFR4_EL1, NV_frac, NV3)
+	},
 	{
 		.capability = ARM64_HAS_32BIT_EL0_DO_NOT_USE,
 		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
-- 
2.47.3

