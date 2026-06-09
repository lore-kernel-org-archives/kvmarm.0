Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5379136680F
	for <kvmarm@lists.linux.dev>; Tue,  9 Jun 2026 18:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781031129; cv=none; b=eyfxk683jhrN/CdL4lEtbQ/PYelV6lUBqjToCgc96A7jgKiLWVJfMW/DIlLPQEPh/+0UIxTJ9CzxS7XrcgpT8Y1XP/89XbTQCFimAnCQt2eqKOsx07ZuTg25IZVc/75MDGOnveTBi/p+6N/mnvbWhMvhYf0Yq87Sc1/wKY21/ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781031129; c=relaxed/simple;
	bh=fFUSn+NJTOcCcdCLMbNVvNQcRWGIa/Fozz8nBls8ofA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZEv7r5NHGlj0Ltl2c5fUjAtk58CVfW1LBVWv+b4FiK/Zny6SZ/EQaoUjvtiI8NtvpHlGGfBkDXkW9fGm29rsblgn0mbLaBbxZ5TzX1xHToxQ8NEJosWgprLFzFLLxlQPTOkHJP5hQDQe9NLGn/Yi3zznsZMzSrOD++ENyGJ8n9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b9woWbgg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b9woWbgg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DEBE1F00893;
	Tue,  9 Jun 2026 18:52:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781031128;
	bh=WSYXEQ1MLDegeWyUeLAgpn2EZJeWOqTX55YEjc0LPCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b9woWbggasR2v0NmFOhKRB8krO/6/8sbrs4KmC5RRxHrrDjCiNy0NlnoKSkfg9geN
	 eB+Hf8FaUEib1852qdXctqQxk53eiRQUpqjVQXW9BNv6Gunb+68Zb7mLqRJb3/Sn87
	 zCvPd1gZ89BetK+VPh5F8gj02TOaSjjoECdf0rKaIFyuzhQI666qP3SpZHI5lmVvAV
	 Elh42K1Jdw+arpz5LBVbl32xyZIlfJOCi8l/00jYISrEX41qyuu2UoDPI8BAi2M0FU
	 kgpM8LH8m/f2v/E+TjoiYpFT0XWB/3VdP2r+O0Xewuox+YrFaODzYRfZWu9pJ+No39
	 MUqf0X5CqW4bg==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH v2 5/5] KVM: arm64: nv: Mark VM as bugged for unexpected VNCR abort
Date: Tue,  9 Jun 2026 11:52:04 -0700
Message-ID: <20260609185204.745929-9-oupton@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260609185204.745929-1-oupton@kernel.org>
References: <20260609185204.745929-1-oupton@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

KVM is unlikely to resolve an unexpected VNCR abort, meaning that
returning to the guest will likely leave the vCPU stuck in an abort
loop. Bug the VM and exit to userspace instead.

Signed-off-by: Oliver Upton <oupton@kernel.org>
---
 arch/arm64/kvm/nested.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index a6bd60856fc3..e9bd4991f7a0 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1484,8 +1484,8 @@ int kvm_handle_vncr_abort(struct kvm_vcpu *vcpu)
 		return kvm_handle_guest_sea(vcpu);
 
 	if (!esr_fsc_is_translation_fault(esr) && !esr_fsc_is_permission_fault(esr)) {
-		WARN_ONCE(1, "Unhandled VNCR abort, ESR=%llx\n", esr);
-		return 1;
+		KVM_BUG(1, vcpu->kvm, "Unhandled VNCR abort, ESR=%llx\n", esr);
+		return -EIO;
 	}
 
 	ret = kvm_translate_vncr(vcpu, &is_gmem);
-- 
2.47.3

