Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.217
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621256;
	b=3c2sw6oxMZ/2Jq8tnuwogAV33yLhw4aB3FG4hPeNMP34fNGlDpZaui2F3yu/Zug41lC+
	 3rzgaXuOXnNwBfKVHuXNrNytbu/TjzzB7RlY6rd+FGOYrQnHx1iiduuAe50iU4vhniBPB
	 t8iuqvUDXl9FYqZ1S0EMpPzlTh9WMyO2XBe5B6Dgiyx4SxncuVjzQtZKCfdA7KudHmosa
	 kY3o3dqLL03JkNa/7bfYeMdJBif+UCjLEVhs2EV2+/oGUGAPruoz+SkWtd29E/j3dCzcH
	 5VWBknF7SCEO9983KUjO8HZtOHJeGsQta2A+7F42ZWlwukZzjfaadWf5gk4Mqjefkvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621256;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=KckL5gT/cZCh8aqKHeG36wBG6xN/CeWQhPwBIStZpLc=;
	b=jiqdCceKdKua8t/KjdmD/WxcxJFWxddQwknV/wPQyq1b5MGgXLSOpPNiwMJpmhwkIZ6c
	 gOBIbr7HxwQBgEnpVmgL30JrnadaXSyqZ0zFjETCB2gjhRh9X4u1b9UA90pAttBKS3v6x
	 NcrgjnYDbKBKvweAAQdu0mAVamZCQ8TRuINe5MsKVsO91hpNqBba18n3kemKRz+qFGIrg
	 VsHK+EsWS5Sf8S88EwoI9nyIh8V5VSNjpLkLVHlpukvc5xZ3TJtftHcZJAzDblhPy3LYP
	 LAsUKd8/eionf6enLg1TV/JrPFxBIBQ6BqOroD02oRQerGgBsfvps1Y8FSyaq8mkdqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=p1aEF8MK;
	arc=none smtp.remote-ip=95.215.58.217
Received: from mta1.migadu.com (out-217.mta1.migadu.com [95.215.58.217])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1883D60A3826
	for <kvmarm@lists.linux.dev>; Wed, 25 Nov 2026 15:40:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1883D60A3826
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=p1aEF8MK
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=zJwtMQBlLjNrOfYjaZ/GDzfZnTT6tgmTp26QYSfx10c=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795621254; v=1; x=1796226054;
 b=p1aEF8MKpF/vDVBF2nu4R3oguXjEkwI5pDIdmHrVR4TTIS2V4Y/1U0VGedx1lLFGcDTIJTwF
 btPlFaxLaxyET7bcNb4lx1w/tnGDr7LUgPUt69rwied0uoMWl4DWqWZfINXSNfzPVXKqM0t7SH9
 iLAp+u6hfObY5tgBJXeJkDJM=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 6162857881d00979;
	Wed, 25 Nov 2026 15:40:53 +0000
X-Mizu-Trace-ID: 6162857881d00979
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Fuad Tabba <tabba@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 18/20] KVM: arm64: Advertise ECBHB, TIDCP1, TTST and LVA to protected VMs
Date: Wed, 25 Nov 2026 15:39:09 +0000
Message-ID: <20261125153911.106793-19-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261125153911.106793-1-fuad.tabba@linux.dev>
References: <20261125153911.106793-1-fuad.tabba@linux.dev>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Advertise FEAT_ECBHB, FEAT_TIDCP1, FEAT_TTST and FEAT_LVA to protected
VMs, capping VARange at LVA, since LVA3 requires FEAT_D128. TIDCP1's
control, SCTLR_EL1.TIDCP, is switched with the rest of SCTLR_EL1.

Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/hyp/nvhe/sys_regs.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
index fdf405629dfd3..dc7c70ac46f2a 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -169,7 +169,9 @@ static const struct pvm_ftr_bits pvmid_aa64mmfr1[] = {
 	MAX_FEAT(ID_AA64MMFR1_EL1, SpecSEI, IMP),
 	MAX_FEAT(ID_AA64MMFR1_EL1, ETS, IMP),
 	MAX_FEAT(ID_AA64MMFR1_EL1, AFP, IMP),
+	MAX_FEAT(ID_AA64MMFR1_EL1, TIDCP1, IMP),
 	MAX_FEAT(ID_AA64MMFR1_EL1, CMOW, IMP),
+	MAX_FEAT(ID_AA64MMFR1_EL1, ECBHB, IMP),
 	FEAT_END
 };
 
@@ -177,6 +179,8 @@ static const struct pvm_ftr_bits pvmid_aa64mmfr2[] = {
 	MAX_FEAT(ID_AA64MMFR2_EL1, CnP, IMP),
 	MAX_FEAT(ID_AA64MMFR2_EL1, UAO, IMP),
 	MAX_FEAT(ID_AA64MMFR2_EL1, IESB, IMP),
+	MAX_FEAT(ID_AA64MMFR2_EL1, VARange, 52),
+	MAX_FEAT_ENUM(ID_AA64MMFR2_EL1, ST, 48_47),
 	MAX_FEAT(ID_AA64MMFR2_EL1, AT, IMP),
 	MAX_FEAT(ID_AA64MMFR2_EL1, IDS, IMP),
 	MAX_FEAT(ID_AA64MMFR2_EL1, TTL, IMP),
-- 
2.47.3

