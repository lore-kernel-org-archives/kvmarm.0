Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.185
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621249;
	b=pThceAo70RWe7jzt8FPgeKo8Qyxtz6MJKbMhG6lcdx1Htc6vZ6+33MqfMIqUvSlTY5vy
	 5eJHrY9WXshyrQRN/uDL/FA1g9hkp2YTpDgkNMbYDUeWSrliDrMAIB2PPJ9t3AAiegZaE
	 AmGehiTZZYekrTOb6yg5ThHlGY3xtYkHrKWDC9Yb3J0Mw4UTjnEwJtch/dBc+n0UhTuCx
	 LtmguTFmpgGmEE+9BdlJeVaQz7xt0yygQlK/ER1RaS+ZjqWlGGELOuSF8ii+hWakgZFXK
	 6A7k9MSQUS6tMC/+Ztf2Gd48bEaQyFS/J6QHksYgZvQGe+tp5PwSAdJsLucLCt0yXTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621249;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=oJyjfOujmSBUsGvM1/SgdU/YJl1D0UryFNbGYP9HTmI=;
	b=RTd8O+ngAxHuLBkIU1jR86OCViVs8xaTmSbEM2hLWD0DfElw4T3MFbPu7GmOJh4yZm58
	 bF8H+1gqTITLwEa65z8OC6VtONG6b4ZpSmPwptsFpBgbEGNNy8FoFhLp9DbFur+HuLaV3
	 OK9079niF7x0LnSHNI7bSLnjShMp2waka9pASG5B/4rH5P33xPU7zR9ClktJ92yQFzB2v
	 LuzBRyGN9NvL4nJtSXRQ4/Ah17BOd/BcLLpXkPotiYQOLfkLAofeE+5Zmb6xFuwTtVLLQ
	 RTfe8o2U3jcNHPAtKPyIK7eilZD3/W0xnNYbLrd/Rh+Vdnfx/BcGIT8d6fuLwKIROrw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=eUgwIOwS;
	arc=none smtp.remote-ip=95.215.58.185
Received: from mta1.migadu.com (out-185.mta1.migadu.com [95.215.58.185])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54A27606A31E
	for <kvmarm@lists.linux.dev>; Wed, 25 Nov 2026 15:40:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 54A27606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=eUgwIOwS
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=j1+9jq4DNPjKmn/CiJVqGm6EPhi92kwiCRK4Zpjn4qM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795621246; v=1; x=1796226046;
 b=eUgwIOwSzGaFhcaIJZSM7Euvac94ds6Ysz3w/lx8J7YPL/F4o0sqSk7dY8xOc1wHMwQcE3yC
 nv/ZiPHxv67bKxJDKhw1ZkBF2cClRdY02mCYlG5GglB7J3vtk5hwjDSrMhDubNJBDdXNGiGCLzT
 I8hFqIYYyfeRh1Lcthe+j3Ug=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id c6dde43742fe7882;
	Wed, 25 Nov 2026 15:40:45 +0000
X-Mizu-Trace-ID: c6dde43742fe7882
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
Subject: [PATCH v2 15/20] KVM: arm64: Advertise HBC, CLRBHB, RPRFM, CSSC and LUT to protected VMs
Date: Wed, 25 Nov 2026 15:39:06 +0000
Message-ID: <20261125153911.106793-16-fuad.tabba@linux.dev>
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

Advertise FEAT_HBC, FEAT_CLRBHB, FEAT_RPRFM, FEAT_CSSC and FEAT_LUT to
protected VMs, with CSSC up to CMPBR and LUT up to LUT6, as for a
non-protected VM.

Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/hyp/nvhe/sys_regs.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
index 4ba947bd3d125..2c22317a76a5e 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -213,6 +213,11 @@ static const struct pvm_ftr_bits pvmid_aa64isar2[] = {
 	MAX_FEAT_FUNC(ID_AA64ISAR2_EL1, GPA3, IMP, vm_has_ptrauth),
 	MAX_FEAT_FUNC(ID_AA64ISAR2_EL1, APA3, PAuth, vm_has_ptrauth),
 	MAX_FEAT(ID_AA64ISAR2_EL1, MOPS, IMP),
+	MAX_FEAT(ID_AA64ISAR2_EL1, BC, IMP),
+	MAX_FEAT(ID_AA64ISAR2_EL1, CLRBHB, IMP),
+	MAX_FEAT(ID_AA64ISAR2_EL1, RPRFM, IMP),
+	MAX_FEAT(ID_AA64ISAR2_EL1, CSSC, CMPBR),
+	MAX_FEAT(ID_AA64ISAR2_EL1, LUT, LUT6),
 	MAX_FEAT(ID_AA64ISAR2_EL1, ATS1A, IMP),
 	FEAT_END
 };
-- 
2.47.3

