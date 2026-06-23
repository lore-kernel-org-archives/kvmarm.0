Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83F0D395ADE
	for <kvmarm@lists.linux.dev>; Tue, 23 Jun 2026 21:13:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782249199; cv=none; b=CKdVFD+UxwD/cYIfB6CLR9JXtPn8nxitlb6NTvfUJ33ECHASNXH2C2VIrTqgLr9xE3xGhtbm3RenPZqsas6x6wCPdIpxDWceNObAWr127yyEbdZeJG87Ww5+inbFjfYbP17qDZ4FqeHbv5cy+n0Oefw4L/0K4dH8mc6fmV4SIx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782249199; c=relaxed/simple;
	bh=j2gygtqvldRVS5ZORG3Ynuz5+TBkktR8982im3aZeCE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VqXyEpDNizeZKKHJimR9I75uLGNQZ58fc299h24/78LLrzQ8Mlhf1C1a2oRVCqXZrjEgRPXoD39sWekpBKhFt+hy+7vkjswGxfnOjVNtRf+HxXK1wmv1qLJwYwfXy7Hbk5hRdgvllPJLVdHqi3O/A2l7NIXfE3Ufr0OcgpUbeYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X1fiE8st; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X1fiE8st"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33BBC1F000E9;
	Tue, 23 Jun 2026 21:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782249198;
	bh=BtVmuVIbBQpBL9xe/Ff9TSPSXp4HwbOWh1/q1fYT8s4=;
	h=From:To:Cc:Subject:Date;
	b=X1fiE8st9T6BH+8F5Q5Pd66iul3I1vICSSFrITl9HVhjl7kJ3tNGtg69FO8Cmcyq6
	 M0J2BcNcdX/nvSK/MI8BJ70vs3rMMHYNHLfz9at+yMHo5KHlpxvrysxuED9+SRXH55
	 7vBy2qXvj01u3q73ZAYrYDcbS/gheL/TMOCJ+3Qt7e+MzMGvC8RcAwuAt7Qz7LPi+r
	 y+HULnEXt9+NYbsZdvGoRwNErwwYDMNndLbdDEqQkytuveIESxiTpYbi8r11X3HCuo
	 88WnCQWK1XElauLMP5a4yxtH6jcKZMMwNJ04dZq9qbLaKFAElOrCtarf3Opz4un59S
	 W1rd9fjQTWRzQ==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Oliver Upton <oupton@kernel.org>,
	Sashiko <sashiko-bot@kernel.org>
Subject: [PATCH] KVM: arm64: nv: Check RW permissions for insn abort due to S1PTW
Date: Tue, 23 Jun 2026 14:13:10 -0700
Message-ID: <20260623211310.1529760-1-oupton@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Permission faults reported as instruction aborts with S1PTW set are due
to missing read/write permissions for the table walk, not execute
permissions on the output of translation.

Check for S1PTW before evaluating execute permissions, falling through
to the RW permission check otherwise.

Fixes: fd276e71d1e7 ("KVM: arm64: nv: Handle shadow stage 2 page faults")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/kvmarm/20260623190607.7106B1F000E9@smtp.kernel.org/
Signed-off-by: Oliver Upton <oupton@kernel.org>
---
 arch/arm64/kvm/nested.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 94df26de6990..713fc44f362d 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -918,7 +918,7 @@ int kvm_s2_handle_perm_fault(struct kvm_vcpu *vcpu, struct kvm_s2_trans *trans)
 	if (!kvm_vcpu_trap_is_permission_fault(vcpu))
 		return 0;
 
-	if (kvm_vcpu_trap_is_iabt(vcpu)) {
+	if (kvm_vcpu_trap_is_iabt(vcpu) && !kvm_vcpu_abt_iss1tw(vcpu)) {
 		if (vcpu_mode_priv(vcpu))
 			forward_fault = !kvm_s2_trans_exec_el1(vcpu->kvm, trans);
 		else

base-commit: d098bb75d14fde2f12155f1a95ec0168160867ce
-- 
2.47.3

