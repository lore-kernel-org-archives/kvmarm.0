Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.250
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794213168;
	b=y/V7iopYswy2gc5Vejd9eRwEwkmvS91+H+U3ZDCh3cauObamSOYi2Vc715W/iEJfETiz
	 AnjtNBdfImX3WOAHUkNd8USU29/pMKOkfJrDa4cR0P6l0NGND+oVF0Efjcwrxy/mAbmmW
	 nTU4gW+XCT8oWOWHjDWYo/Hgdh2kOpHUW7PgkNPaGk0RaGaBw2Vlcp1u5TzjAUCGOdXhR
	 eAB2MREbjlKeABHXdprNv8AGINbGZUBpAcjqSoUyh0PR+psnSjacZQUN8gP1Axu7KPZBf
	 wSCyeg7uJXD7zIooQBHqUZZWjwiVGpMQUGsEBWZEQA7jz/WQ0Ri4E3IDEoOLKOvtmGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794213168;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=bo1WlELU8ik+Rr+Abdwa067G5JksNkxTfxKiETgF/pA=;
	b=3AguTd5Z8MJVxadHzjeg+8slXa+RyiixixJtaWbk3+B/xAyJFShaqny7QQU2ZA0RnE6r
	 trBelEETbVYLlBjYfqFRCCBrjSKtyuC73QsiuT9YcOUQOulIZ3BvN8wqQKVewG+JRTBvg
	 fqKew3+FiJqGryS/k7hut0Fx7Cdm+RZ1s0/8IPwFnq//ds+FlN1Ux/Sv3QLUO8tsQp2th
	 nfo8ShKiBA/AW4qX4XkM1XeMJ4uOa4/rJJRcegU17zOoUE46SHqvjTqu9/+wPn4u7Imyx
	 szPHHaHBg/6wFCDrVwxhjpoDP3yk8V1AbXomF5IFHW9tF0lJl3+KimjtW5oxiwhS9eQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=S9jMCK95;
	arc=none smtp.remote-ip=95.215.58.250
Received: from mta1.migadu.com (out-250.mta1.migadu.com [95.215.58.250])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B623B606EE94
	for <kvmarm@lists.linux.dev>; Mon,  9 Nov 2026 08:32:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B623B606EE94
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=S9jMCK95
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=W7dlvw4NdcdYKD2+I77uCjjseY0CwzVUAyYBCfePwsI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794213166; v=1; x=1794817966;
 b=S9jMCK95QtcoMLf+7bXj5kUxvWLP+RKC3Y6fSEZhcv58cQDtKU+0kt+GkJkWHatYSbGK6KJg
 IlMykHYdMLqNAxO8qrnGq2hAky39aOsP1i4a8dvo1yfJClM/VQTaVgrJVJY2tDxyGad1qRxefYG
 LQn5WdLi51Kxu1L9Zo+JDv4k=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 909104da5cd6237e;
	Mon, 09 Nov 2026 08:32:45 +0000
X-Mizu-Trace-ID: 909104da5cd6237e
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
Subject: [PATCH 13/16] KVM: arm64: Advertise AFP and RPRES to protected VMs
Date: Mon,  9 Nov 2026 08:32:02 +0000
Message-ID: <20261109083205.806619-14-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261109083205.806619-1-fuad.tabba@linux.dev>
References: <20261109083205.806619-1-fuad.tabba@linux.dev>
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
index 73ef47a8e687b..08805c7e4e5a7 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -169,6 +169,7 @@ static const struct pvm_ftr_bits pvmid_aa64mmfr1[] = {
 	MAX_FEAT(ID_AA64MMFR1_EL1, PAN, PAN3),
 	MAX_FEAT(ID_AA64MMFR1_EL1, SpecSEI, IMP),
 	MAX_FEAT(ID_AA64MMFR1_EL1, ETS, IMP),
+	MAX_FEAT(ID_AA64MMFR1_EL1, AFP, IMP),
 	MAX_FEAT(ID_AA64MMFR1_EL1, CMOW, IMP),
 	FEAT_END
 };
@@ -212,6 +213,7 @@ static const struct pvm_ftr_bits pvmid_aa64isar1[] = {
 };
 
 static const struct pvm_ftr_bits pvmid_aa64isar2[] = {
+	MAX_FEAT(ID_AA64ISAR2_EL1, RPRES, IMP),
 	MAX_FEAT_FUNC(ID_AA64ISAR2_EL1, GPA3, IMP, vm_has_ptrauth),
 	MAX_FEAT_FUNC(ID_AA64ISAR2_EL1, APA3, PAuth, vm_has_ptrauth),
 	MAX_FEAT(ID_AA64ISAR2_EL1, MOPS, IMP),
-- 
2.47.3

