Received: from mta0.migadu.com (out-122.mta0.migadu.com [91.218.175.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 710134A0152
	for <kvmarm@lists.linux.dev>; Mon, 31 Aug 2026 16:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.122
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788194104; cv=none; b=BWTWKww6Zdv/tGaizKpuJWVbJ/+1ceAVzqLuCKsLREwgmdJlPKxYnInj5z6PYGx2BRTHmOwMV2ftI4X92lMkK3YKbpRdoKKRCyqD9VKs9sn2sU2YWrwFTavbWSdFB71MEHXsn2QuvCWbhhhoSMWRbLkPDggfXHRdOoOTMlu5lDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788194104; c=relaxed/simple;
	bh=U/axjWQAfQSFNwOk+gQLgXnGQvfOgoP7MHtzfv1LyiQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=U4Gi8p6SWvLzkS038oGqEw4Lt2as97QrhPK3fCbB/fPF9ihrBWF/CUSQ/KFJra55zLH6hud0yNmkinZGd8EYdlscEMBF5DI8vgv4ewtsHF3bO4aAg/Mm3RnZg5If5gcfQk1dn/O87kiAFevkKIfJ1BE3a9DrjnRoUWvAVW2bAnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Ei3HO2TI; arc=none smtp.client-ip=91.218.175.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Ei3HO2TI"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=U/axjWQAfQSFNwOk+gQLgXnGQvfOgoP7MHtzfv1LyiQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788194100; v=1; x=1788798900;
 b=Ei3HO2TICRTj7admtDmRqxINvc44J6WV/8zT9R7q6lwWCLXd7kOWEDBVJUuXDBVObnMXfVid
 8gYe93I1xrGjaMaEVFNtX/Sta5zYn8NwKD4jt3v9rf+rsQCTSy6CdqcCDVXmQ1w4QT4NOADooE/
 BTTXjheF1kU0WBFxiIsns4aY=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id d1286ff7c0158266;
	Mon, 31 Aug 2026 16:35:00 +0000
X-Mizu-Trace-ID: d1286ff7c0158266
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Quentin Perret <qperret@google.com>,
	Fuad Tabba <tabba@google.com>
Subject: [PATCH 14/17] KVM: arm64: Pend a protected guest's SError with HCR_EL2.VSE only
Date: Mon, 31 Aug 2026 17:34:18 +0100
Message-Id: <20260831163421.272420-15-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260831163421.272420-1-fuad.tabba@linux.dev>
References: <20260831163421.272420-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

kvm_inject_serror_esr() emulates the exception entry when
serror_is_masked() reads PSTATE.A clear, but the host has no view of a
protected guest's PSTATE.A, and an emulated entry never reaches the
guest: the SError is lost. Set VSE instead and let the guest's own
PSTATE.A mask it.

Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/inject_fault.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
index d6c4fc16f8795..b88098a7e756c 100644
--- a/arch/arm64/kvm/inject_fault.c
+++ b/arch/arm64/kvm/inject_fault.c
@@ -378,8 +378,11 @@ int kvm_inject_serror_esr(struct kvm_vcpu *vcpu, u64 esr)
 	 *
 	 * As we're emulating the SError injection we need to explicitly populate
 	 * ESR_ELx.EC because hardware will not do it on our behalf.
+	 *
+	 * The host does not see a protected guest's PSTATE.A: leave the
+	 * vSError to HCR_EL2.VSE below, which the guest masks itself.
 	 */
-	if (!serror_is_masked(vcpu)) {
+	if (!vcpu_is_protected(vcpu) && !serror_is_masked(vcpu)) {
 		pend_serror_exception(vcpu);
 		esr |= FIELD_PREP(ESR_ELx_EC_MASK, ESR_ELx_EC_SERROR) | ESR_ELx_IL;
 		vcpu_write_sys_reg(vcpu, esr, exception_esr_elx(vcpu));
-- 
2.39.5

