Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.19
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621160;
	b=Zd5o9cANf0ax/ewUWhk7MUnlq/jZo5ISdPlBJ9PTglqV85HC4jJ++6YxNlzr/qK4UBjY
	 VH21mFrmOrCGNAnDbq1LqBeyhfp7SiHTkuk8V6zInfoUb7Kst2jjqsbA/V2O05csSRvZn
	 rWLezoIwPRXyPE6WWv+qatXBW/gcG/KKNfg8BHFcKoBIzUhgKEP7+Y5BRLQx9oysvykrd
	 gKq+cGFY0gBr5BYaUBTdzqhkn1VxUv7mSLBB5wCqDkn1Xgq+PeSljT/LR2TyU9BoOhkUS
	 oMuII3QYZUFpKBcr5VvLRRxHrdGyuOrUPyqAbiAEb0NB3W9Ah3X/ysJ927MRDmGxoUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621160;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=LCnVdHirYtBKX2t/3K8ljhm+P9aiBrtU685db8fTm+U=;
	b=2oM+qLiktkNdsjhV8FR5lepUzuVGNNzllNicjEnqHlZZZpsrRSMeM+BASYEOwEg7N4VN
	 DkwCPn986EOX0vRpl3O0oROkjpaV8O+l3mnoVzGUMGKiOb3ckqTAIpTQF1qkQd7mOQkuS
	 XelaTAMVd8rIbcIZ8ZSTZUtjokSFotwqTmN6s5yXaufHsNwnPOkPHNebde8rb2qJPvANH
	 noDUcoC2KguEe2w3CEzHZn3jDXGSZE4Bsb6b1I4b8X8BodtgL+roNNfyA1Su3ZNr82zSo
	 CQHg9kYKp6IEDI6z6QgSxZ0uS252vyTEPT1TYJ79G+GR8IQrVUiXkzhzdxQYQIWujlg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=wALhDrPH;
	arc=none smtp.remote-ip=95.215.58.19
Received: from mta1.migadu.com (out-19.mta1.migadu.com [95.215.58.19])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B593F606A68C
	for <kvmarm@lists.linux.dev>; Wed, 25 Nov 2026 15:39:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B593F606A68C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=wALhDrPH
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=o/SZfwEeYhSxZ5cZ93jBl6fDIchTpBEO/6emnlOmEC8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795621156; v=1; x=1796225956;
 b=wALhDrPHUWRg+PnqBIVx+mxcK8l9B5eVX7yhtcbiSL6rCAaOfbBky+29ZklmAUKpVE6l/uSW
 44X01pscOJFIM/bi3O9KlVHJPxOgE9E/lsPcaqvCb5h1OVtHFPy9Izhflf13+0gKlEKWyZPwl7y
 ep/OCYkzSH14QmG7cg87eAIQ=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id b3ce0fa6c33041ea;
	Wed, 25 Nov 2026 15:39:16 +0000
X-Mizu-Trace-ID: b3ce0fa6c33041ea
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
Subject: [PATCH v2 02/20] KVM: arm64: Don't advertise the host's MTE_frac to protected VMs
Date: Wed, 25 Nov 2026 15:38:53 +0000
Message-ID: <20261125153911.106793-3-fuad.tabba@linux.dev>
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

Protected VMs don't support MTE, so MTE_frac in their ID_AA64PFR1_EL1
doesn't apply and is RES0, as it is for a non-protected VM without MTE.

Commit 3d7ff00700d1a ("KVM: arm64: Rework specifying restricted
features for protected VMs") caps the field at NI in the pVM
restriction table. However, NI is 0xF and the clamp is unsigned, so the
cap does nothing and a protected guest sees the host's value. On a CPU
with MTE2 but without FEAT_MTE_ASYNC, that value is 0xF.

Drop the entry so that the field reads as 0 again. It was the only
entry capping an unsigned field at an NI other than 0.

Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/hyp/nvhe/sys_regs.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
index 32e82653ebf7e..e1749138f7507 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -105,7 +105,6 @@ static const struct pvm_ftr_bits pvmid_aa64pfr0[] = {
 static const struct pvm_ftr_bits pvmid_aa64pfr1[] = {
 	MAX_FEAT(ID_AA64PFR1_EL1, BT, IMP),
 	MAX_FEAT(ID_AA64PFR1_EL1, SSBS, SSBS2),
-	MAX_FEAT_ENUM(ID_AA64PFR1_EL1, MTE_frac, NI),
 	FEAT_END
 };
 
-- 
2.47.3

