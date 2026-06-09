Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67B644C77CF
	for <kvmarm@lists.linux.dev>; Tue,  9 Jun 2026 18:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781031322; cv=none; b=iIC72JYW0FLrAbJbxw2LWN1MvPfERxl5Q7ugIUlvX4z5KhP0PpidudqkD+yqM341MzZut3nwN8hipBE7bIk+AFkQoFuK88ZeQz0Rjn40L/ZlNQy1s7xHlMDkbFh3qvOD8nkqvknFq9aJ2ELs27zCKqbn8b085JDsop6hCK1hNIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781031322; c=relaxed/simple;
	bh=fFUSn+NJTOcCcdCLMbNVvNQcRWGIa/Fozz8nBls8ofA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e7PNfFasOKXbdTeMFxMhP79hsIlbe72jo8JUG6bvWXN4tLBolqHyzeHLhY29M/sH92MUK0UKH4i1ffkWxwppONJnBgHvXVIh046GKdNG1gJLGDpmnMEUJc6jBmSGlzZ+oSAfgcdi3YIooPl+T6/iCCWSnY1Ke20ndBnS6l0Q4CE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P2eWaFAm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P2eWaFAm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6A731F00899;
	Tue,  9 Jun 2026 18:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781031321;
	bh=WSYXEQ1MLDegeWyUeLAgpn2EZJeWOqTX55YEjc0LPCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P2eWaFAm0uc6FrXcqMjPR1ZJYrEQnQrs0094SozzT8hkjlhDoicGGDVp5nFxVWOgv
	 nfhXK/30RmTSj2Dy6D+sIebpWy2rohem1Vk3jRaC65OcqQ0b39NsbFhBIlhvAnliqm
	 5I7hJbWhTbXpzD9cmORcPoTz6r15iO+5TClEQ6bp4g+4vXyBjZQcbmFpBwtU4sVrmK
	 n+tUfh/I0ui8sxqC2qfCIQ47gA++5qbMAJ3FkWtXh/5mDuRAMEtkvAzXlJuyv2VWp0
	 SNSnuVAgIRZw4nHX0jP64Oj6AeML3Aefuncvr/J5hMHgAimA8PH0p/LLjyx9I7uMyc
	 M2AKxdS7sqWIw==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH RESEND v2 5/5] KVM: arm64: nv: Mark VM as bugged for unexpected VNCR abort
Date: Tue,  9 Jun 2026 11:55:14 -0700
Message-ID: <20260609185514.746507-6-oupton@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260609185514.746507-1-oupton@kernel.org>
References: <20260609185514.746507-1-oupton@kernel.org>
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

