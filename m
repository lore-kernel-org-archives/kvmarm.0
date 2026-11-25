Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.209
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621254;
	b=K1NnWFsawOYwN/nyPB5fWCfbKHOPXWwwO3s/IR88xXBKlnt7bjSkJYop8mpVcxQ6g6BH
	 SBzOM2tJTcLSfUVXdiwo+jKqYg7dEWAtWDpR9W3SXPUc/hBg1w2rWHZDB98Rnywge7gkr
	 mhE79faLU22HmPCxxebRsaJfsEoSeSJbn5sCYxBGg5BSmz5SDeVd0vRbLmznUkS8N8Jab
	 +1Z9+ZhQnazMWpAysb8TAr5/5Toesl8dI71izj3E+YSRiFzKzCKcgpTsT4pEU+TV0oHDn
	 XY7jlq9iQnb8svNRNeSjD79MMIMUmAeooGmJiWhfw3yY6gffxVtG8c+ng/z5e+hktOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621254;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=TFaLTkdHB+5YDL5f+nojYfBbFLMj9J2+pRtPz6tMP5w=;
	b=2vYaOTOuEvWda9Y7V7HzBSepEFQWNRsuSPPE+awoid82Ku19r+da6/u8H8K87d7wzj/1
	 arduwgm+Ks8tviA7k1Atu82+93lZ78mOZal5WVPFNUY/v6ghe07hiQn1bvKv9fSt4UVSm
	 LS2oCcGhz6XIghueHLkpWZVzgfNcqTPMbX+NIIQCCyVc2TONDWu1+aAFBRMu0RkKQcy/Y
	 AQrJAjYTtxzfvlUOUnh2TEvuZXooiWA4HIk0t1m+/vWJ3HbZyx/DHPDU7+DnbxURVr8pZ
	 a3jm9EEG9qL50KGcYGkJuqAM6oTH0Nyz0/6lrLVsML27Uz9pmyVuun6mxw1IvqIz2dQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=BXiaVdjD;
	arc=none smtp.remote-ip=95.215.58.209
Received: from mta1.migadu.com (out-209.mta1.migadu.com [95.215.58.209])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ECA5606A6BF
	for <kvmarm@lists.linux.dev>; Wed, 25 Nov 2026 15:40:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1ECA5606A6BF
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=BXiaVdjD
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=tQx3hAInB2qCvf4Ddz800tK984tgyiqRxbiHM/YoGLw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795621252; v=1; x=1796226052;
 b=BXiaVdjDekymZahhXs+HONT8On8e4zJA11jxaqcRmzOJK/3a4y3CosAbL2TOWtqsWATiw3PC
 jcx3G0vwyQExTBBlPX22VRh8aouq/VFqul5G/a7fx/jwOviIZVDDbHvLno2oDnKu0MMkgUk4fWB
 F7eVKpcQnwgVf13CT8P+tDbA=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 014e2df93ab0485a;
	Wed, 25 Nov 2026 15:40:52 +0000
X-Mizu-Trace-ID: 014e2df93ab0485a
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
Subject: [PATCH v2 17/20] KVM: arm64: Advertise AFP and RPRES to protected VMs
Date: Wed, 25 Nov 2026 15:39:08 +0000
Message-ID: <20261125153911.106793-18-fuad.tabba@linux.dev>
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

Advertise FEAT_AFP and FEAT_RPRES to protected VMs. Both are controlled
through FPCR, which EL2 switches with the rest of the FP state.

Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/hyp/nvhe/sys_regs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
index 129a6b89a232d..fdf405629dfd3 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -168,6 +168,7 @@ static const struct pvm_ftr_bits pvmid_aa64mmfr1[] = {
 	MAX_FEAT(ID_AA64MMFR1_EL1, PAN, PAN3),
 	MAX_FEAT(ID_AA64MMFR1_EL1, SpecSEI, IMP),
 	MAX_FEAT(ID_AA64MMFR1_EL1, ETS, IMP),
+	MAX_FEAT(ID_AA64MMFR1_EL1, AFP, IMP),
 	MAX_FEAT(ID_AA64MMFR1_EL1, CMOW, IMP),
 	FEAT_END
 };
@@ -211,6 +212,7 @@ static const struct pvm_ftr_bits pvmid_aa64isar1[] = {
 };
 
 static const struct pvm_ftr_bits pvmid_aa64isar2[] = {
+	MAX_FEAT(ID_AA64ISAR2_EL1, RPRES, IMP),
 	MAX_FEAT_FUNC(ID_AA64ISAR2_EL1, GPA3, IMP, vm_has_ptrauth),
 	MAX_FEAT_FUNC(ID_AA64ISAR2_EL1, APA3, PAuth, vm_has_ptrauth),
 	MAX_FEAT(ID_AA64ISAR2_EL1, MOPS, IMP),
-- 
2.47.3

