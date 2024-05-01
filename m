Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F098CBE71
	for <kvmarm@lists.linux.dev>; Wed,  1 May 2024 16:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714581249; cv=none; b=qh1vUddLxZxuTHD+mjw2GMdUMtlN2OUM+Uy1CFlwq+SdA7/xLyeZ3RhMYzocLoFmcI2dxPNWugwlQVhf7gj75D0f9QcpNzpvVg5k3zhE9d/bIOx9fl36tAg2EolOExKR4N+gkA/TRJeWhOx6BjlshpLEwGPdjzf6Iw1jjfbwRXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714581249; c=relaxed/simple;
	bh=zqLa/sCvSK7SMwwaQAzL9RSCgjQ1JYfXXSvbUh4TT1M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dK5ttDLndMBNB0YMAKvEMioZ2NHt9Mawi6Tmw4wuxr9TwaDP/Q5vcYUFYTW8F6UN8Mf/O84wwUVU/qQUN+PFGw6SC499QW9sVT9ptvEKB7fbux0PE556fBIbwUE70Na9KVkGsXf+2KoVoD7XZdgWUxCTW8rkBGxQCZXdC2CVutw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rtPlmTfC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rtPlmTfC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61DB2C4AF1A;
	Wed,  1 May 2024 16:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714581248;
	bh=zqLa/sCvSK7SMwwaQAzL9RSCgjQ1JYfXXSvbUh4TT1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rtPlmTfCHmmCqqWA4SFP+Ks+x731jXj79jyWKNF1nAdMT/yeOP8EcztGJVXagdPLE
	 WHIg+hy1JxZobuYubFw/RAVdFFrAhOEkhz6jhbBUSJR3PB13VWrehoBgSwatiHS2U3
	 CWZhlAIoH8B2hjllEnbmMIY+v/5/9nRM6izCm1n7B83SE66BU+OzmEQvnQ8Q2W5ETy
	 U2n26nwJymoZEL0HyQHyLtg4lhhBjOSScPjS6G+9JmftlhfLcUHnv2Drta4IhzFFiY
	 NYtDHfKls2lSGVHSlZP6lN//Alc9XMTWkJ3cq4ka/H5YYfrhmk+TCojVpc+UMZriIf
	 3cRyFgGSIj6Wg==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.linux.dev
Cc: linux-arm-kernel@lists.infradead.org,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 2/2] KVM: arm64: Use hVHE in pKVM by default on CPUs with VHE support
Date: Wed,  1 May 2024 17:34:00 +0100
Message-Id: <20240501163400.15838-3-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20240501163400.15838-1-will@kernel.org>
References: <20240501163400.15838-1-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The early command line parsing treats "kvm-arm.mode=protected" as an
alias for "id_aa64mmfr1.vh=0", forcing the use of nVHE so that the host
kernel runs at EL1 with the pKVM hypervisor at EL2.

With the introduction of hVHE support in ad744e8cb346 ("arm64: Allow
arm64_sw.hvhe on command line"), the hypervisor can run using the EL2+0
translation regime. This is interesting for unusual CPUs that have VH
stuck to 1, but also because it opens the possibility of a hypervisor
"userspace" in the distant future which could be used to isolate vCPU
contexts in the hypervisor (see Marc's talk from KVM Forum 2022 [1]).

Repaint the "kvm-arm.mode=protected" alias to map to "arm64_sw.hvhe=1",
which will use hVHE on CPUs that support it and remain with nVHE
otherwise.

[1] https://www.youtube.com/watch?v=1F_Mf2j9eIo
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kernel/pi/idreg-override.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/pi/idreg-override.c b/arch/arm64/kernel/pi/idreg-override.c
index 39c9253fcf23..c20549e43a77 100644
--- a/arch/arm64/kernel/pi/idreg-override.c
+++ b/arch/arm64/kernel/pi/idreg-override.c
@@ -210,7 +210,7 @@ static const struct {
 	char	feature[FTR_ALIAS_OPTION_LEN];
 } aliases[] __initconst = {
 	{ "kvm_arm.mode=nvhe",		"arm64_sw.hvhe=0 id_aa64mmfr1.vh=0" },
-	{ "kvm_arm.mode=protected",	"id_aa64mmfr1.vh=0" },
+	{ "kvm_arm.mode=protected",	"arm64_sw.hvhe=1" },
 	{ "arm64.nosve",		"id_aa64pfr0.sve=0" },
 	{ "arm64.nosme",		"id_aa64pfr1.sme=0" },
 	{ "arm64.nobti",		"id_aa64pfr1.bt=0" },
-- 
2.45.0.rc0.197.gbae5840b3b-goog

