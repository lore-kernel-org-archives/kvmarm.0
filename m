Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.93
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794214139;
	b=Pdme0DV4mjUaR3gsnwIuAoz05KNNu6AGtYs9GPYJYsGqKFFcX29nkauy1HhwcXeiOREM
	 s+cYUQ8bLuGEhjdueVsWGuWjcGKMxgUq2SgcQEPeYirQ9dTCS3vYmlTKKVa1O+1VcZhtL
	 ZPjBD80mCLDCAA2vt93mASxm68Cd6xZFJuA/SNmREUlwQF24ZE3xvo0on76Hcv0srcCjt
	 uOKWSzyRGZKGFaSaj+S0kQlzAXhRQ7UTHLuijl2ePr/D0dohUibKpqssRhnt1EtBVGiMi
	 m2mHk+8cuLdKbsd2dW8qkXOPpx7VVqeSS7fXeRVi543TJUTIWt5TQ9QCTr6J51rj8pw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794214139;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=9EDiuahpoC5a8fdBVjn+7UwWB1qVxtY459zTXN5uFBc=;
	b=MQSiiffOzyPiMn3v28YOHM+jJYgxZ+b56qmU4D/KcTJ9CKZ4ajufb4R1DmleSoqdNP3J
	 mfpuSgTjvEWQWT3E+Db/1bwkU9qdcykIdb2Sv9y14lc09eA/z7Nr9iN80t6a1rP5G0XOT
	 sjy0TLYit+jqRZQm4uYc/HxCsoR7P56Z93pmDW1PwSrsbGW2kjTCVkAjdLvQFoBOac6qu
	 L4S7wnc9OlZ0HD3DL7GgyNdDoEXp7OEIvKuVRoDmzQ7QULUIGwHErWZ+qUNWDK/I3DfwS
	 P7fUGpsoSFP6EMsrHwglEHHbqAX7CcrvF+HkmfEnz/6wtoQuwCFzrxTfW2LlCF67sqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=OVTA8fO2;
	arc=none smtp.remote-ip=95.215.58.93
Received: from mta1.migadu.com (out-93.mta1.migadu.com [95.215.58.93])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC2D6606A330
	for <kvmarm@lists.linux.dev>; Mon,  9 Nov 2026 08:48:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CC2D6606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=OVTA8fO2
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=zpKaD0TgIJfqXkuMLyaymhMm6AH9D97hWArAafrSB6U=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794214135; v=1; x=1794818935;
 b=OVTA8fO2db6kSbUDBfFOjmMwKtrQjIsG2RBYYC8jUjo03QtD+wmw4iYcdu/Et/04kKkwkAFL
 Teyb9DficA2hNOq2/K4BAqVcWk7OMvmvbFQ7n50XC0zN/glAMPDBjm9ztcBG58i+N6LFR4E1se0
 NhPJKQSiHRgaAQw4Vm0+/bCs=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 9a819a32ecff5883;
	Mon, 09 Nov 2026 08:48:55 +0000
X-Mizu-Trace-ID: 9a819a32ecff5883
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Quentin Perret <qperret@google.com>,
	Fuad Tabba <tabba@google.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 01/19] KVM: arm64: Hide generic ptrauth from protected VMs without ptrauth
Date: Mon,  9 Nov 2026 08:48:36 +0000
Message-ID: <20261109084854.840576-2-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261109084854.840576-1-fuad.tabba@linux.dev>
References: <20261109084854.840576-1-fuad.tabba@linux.dev>
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

A protected VM without the ptrauth vCPU features shouldn't have pointer
authentication in its ID registers. Commit 3d7ff00700d1 ("KVM: arm64:
Rework specifying restricted features for protected VMs") gated APA,
API, APA3 and GPA3 on vm_has_ptrauth(), but left GPA and GPI capped
at IMP. So generic authentication is advertised to a protected guest
without ptrauth, and PACGA UNDEFs.

Gate GPA and GPI on vm_has_ptrauth() too.

Fixes: 3d7ff00700d1 ("KVM: arm64: Rework specifying restricted features for protected VMs")
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/hyp/nvhe/sys_regs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
index 32e82653ebf7e..e5502d5651b05 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -157,8 +157,8 @@ static const struct pvm_ftr_bits pvmid_aa64isar1[] = {
 	MAX_FEAT(ID_AA64ISAR1_EL1, JSCVT, IMP),
 	MAX_FEAT(ID_AA64ISAR1_EL1, FCMA, IMP),
 	MAX_FEAT(ID_AA64ISAR1_EL1, LRCPC, LRCPC3),
-	MAX_FEAT(ID_AA64ISAR1_EL1, GPA, IMP),
-	MAX_FEAT(ID_AA64ISAR1_EL1, GPI, IMP),
+	MAX_FEAT_FUNC(ID_AA64ISAR1_EL1, GPA, IMP, vm_has_ptrauth),
+	MAX_FEAT_FUNC(ID_AA64ISAR1_EL1, GPI, IMP, vm_has_ptrauth),
 	MAX_FEAT(ID_AA64ISAR1_EL1, FRINTTS, IMP),
 	MAX_FEAT(ID_AA64ISAR1_EL1, SB, IMP),
 	MAX_FEAT(ID_AA64ISAR1_EL1, SPECRES, COSP_RCTX),
-- 
2.47.3

