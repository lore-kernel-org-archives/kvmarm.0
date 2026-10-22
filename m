Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.230
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792663408;
	b=BhaoAOQ9xthptg/StvJa/v9T8FLanZliCqcDc2dDWIMNJBM1D7uS54DpCP/5Z1Kv3P1f
	 NfJFtzthP1KXdiNDs1dauEiI8mk5zkGlbyKpN8D2AbapSFmmJBRzZB0NvZM8lJ3qU1PlR
	 3+YZWt0+WtlS2RUCmW1w7qirZBs3McY7G2IXeK/Ai/q9TJgwJn6Jr3ajhwHzQfo3zuOq+
	 Bxt2lnTmj4YduULf6HiYzUoSTCXX4jxLjTLbHTZqpF8ogj72BjbZ/lSPQf3w6/+33JFHV
	 9q/kmsR633KlVkzQ2UXHOOLCWavOr9flYq5OsciCuFqdsni3E9WQf5ky67n6Ut8B/VQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792663408;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=tytNRA2x/cdXQgb+WGb9wUkqID3jyg9++uqej4viFWA=;
	b=LhMqzk+6ksuMLAlZUGtYl5N78ftw2q+kgaDN5RepQqr6HEF6dCXZ8Irc8smBPLDHvVeZ
	 QWJk3ozv71F7qMD+4c62XFhL0T5H3m8xVScIRGLnv6j/d49DSckpuETO3rhzx9u9Qta0k
	 6TPzuReoD7Gd4CcNkHqS7/Wo5lWP+DXPWUGwL9QF5xw3A7gtsiqrw79TKRa18aM5Ooa2H
	 JyxyOun2RlBqHj+4LrJB+2IdNIuaLz3jVdSu5bwzcy0lg/m25G5gxMM3EOs90aiDgf5ca
	 EDrh5N2Zl4ueiRjjKIFtJSFhBzPEn+kPa5TVGKbCTpA3ottaLrBtneuso95W6mOZqJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=wtk2tfok;
	arc=none smtp.remote-ip=95.215.58.230
Received: from mta1.migadu.com (out-230.mta1.migadu.com [95.215.58.230])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36B10606A330
	for <kvmarm@lists.linux.dev>; Thu, 22 Oct 2026 10:03:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 36B10606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=wtk2tfok
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=bdwUyWR/ogB0uruaLKskLrPi9QHrdsAZ7cDFPYUW9pg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792663405; v=1; x=1793268205;
 b=wtk2tfok5DtBnkyhCxjarl+rdNrbWxaw0zgeTVXX5yy8E2cuEb/99lvOMktpGjXG8J7EZTTy
 bg1c+GRjmsR49oOige7EXjMJX5sPG1WvlEBZE3G99e7u2PSI/+nOqZwamt61pyDbnTEOIurVOqb
 tLoHOQjWAxXblrJLzQ5B+KD0=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id f968876e0cbfdf44;
	Thu, 22 Oct 2026 10:03:25 +0000
X-Mizu-Trace-ID: f968876e0cbfdf44
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
	Fuad Tabba <tabba@google.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: arm64: nv: Don't WARN when L1 sets IMO and FMO differently
Date: Thu, 22 Oct 2026 11:03:19 +0100
Message-ID: <20261022100319.3046476-1-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.47.3
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

When L1 runs L2 with only one of IMO and FMO set in its HCR_EL2,
vgic_state_is_nested() WARNs that this isn't supported. KVM then runs
L2 as if both bits were set.

However, IMO and FMO are independent bits, so any L1 can trigger the
WARN, which panics a host running with panic_on_warn.

Drop the WARN.

Fixes: 146a050f2d8c4 ("KVM: arm64: nv: Nested GICv3 emulation")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/all/20260714235020.2F4151F000E9@smtp.kernel.org/
Cc: stable@vger.kernel.org
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
I dropped the WARN rather than demoting it to a print, the same way
e6e3e0022ef8f ("KVM: arm64: timer: Drop warning on failed interrupt
signalling") dropped one that was loud and easy to trigger from
userspace.

Tested on QEMU with kvm-arm.mode=nested. A reproducer of mine sets
L1's HCR_EL2 to IMO=1, FMO=0, TGE=0 through KVM_SET_ONE_REG and starts
the vCPU at EL1. The host WARNs on the first KVM_RUN without this
patch, and not with it.

Based on kvmarm/fixes (c5b7894f1a26b), which has the HCR_EL2_* rename.

 arch/arm64/kvm/vgic/vgic-v3-nested.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-v3-nested.c b/arch/arm64/kvm/vgic/vgic-v3-nested.c
index 82bfc4d4f122f..c70e06c46a7a5 100644
--- a/arch/arm64/kvm/vgic/vgic-v3-nested.c
+++ b/arch/arm64/kvm/vgic/vgic-v3-nested.c
@@ -121,9 +121,6 @@ bool vgic_state_is_nested(struct kvm_vcpu *vcpu)
 
 	if (is_nested_ctxt(vcpu)) {
 		xmo = __vcpu_sys_reg(vcpu, HCR_EL2) & (HCR_EL2_IMO | HCR_EL2_FMO);
-		WARN_ONCE(xmo && xmo != (HCR_EL2_IMO | HCR_EL2_FMO),
-			  "Separate virtual IRQ/FIQ settings not supported\n");
-
 		return !!xmo;
 	}
 

base-commit: c5b7894f1a26b5cc942be1cd11b15c3876c837a1
-- 
2.47.3

