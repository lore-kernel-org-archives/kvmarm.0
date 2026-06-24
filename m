Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DE3D3E1211
	for <kvmarm@lists.linux.dev>; Wed, 24 Jun 2026 20:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782332693; cv=none; b=J2F0Lj5/fViLGdh0YTux2+sxo20ahCjxEkqD39XTDwK2blp7jRtDFjxeWJ8CNGv+ac94dfGR3kUqdd4hbgfQpZXpQbemwbTJL4xNwNVaIMiU+5vBSVsxrwCKvVtmYTQ5nFtl/A3N9Y/tGlhq9JjXJT2bvoz4m3K2an4ItKTER9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782332693; c=relaxed/simple;
	bh=18TKsJavpU9X7NadjzWn6LrgfHKR8VC+NqHLGOV90WE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KS1jn+Gg1Hn4Jnyjgfo+Gz9apH8/PmaCgVfRkWkc3JF01YLsMiL98NlAhaHlpsfP+ToiQsPSiBK9aeYKJCZ58eVvxZ4eGUCoDG14i+dHr2gKkmKcRQWFetyi4UHKUExASLFnipc3GNSoydJjuXvwnqMSuomBWqUWfg3A05MGaIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JoC//UvT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JoC//UvT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 348D11F00AC4;
	Wed, 24 Jun 2026 20:24:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782332692;
	bh=s3G84a/oxwLWENFiNTy3n6V69Ynr5hp0i235v/ytEVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JoC//UvTW6J/NsQ/dFOkfWu/yOn488EGwohNiLiFpvjlecJNIA4spONWD1HD8GPRG
	 2wMGEV71TkpQk+80vW3RPfbTRM2jwAQLg44pobM3uHBFOgndFr/q4UU6pkkofTwVoW
	 C3+VTCIveTSWS0zxpyGupv5Sjjj73aU1DNu4FnfumSMubfE+b00edBbpmmSI/VgRem
	 wZMqyG/SXETOnbUHrmHcbR8wHAv7slZVtOQswZ63QQoqK5wVZ1wbvvJGRR4yUP9nKN
	 W2JEpPjLEQlTVjpTlGLB1l3OJLuppudYYphzJPOkx+t62hmJH3/3kG3Tnv4uIDOBOa
	 kGLzTTHxmVG5Q==
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
Subject: [PATCH v2 2/2] KVM: arm64: nv: Treat S1PTW permission faults specially
Date: Wed, 24 Jun 2026 13:24:46 -0700
Message-ID: <20260624202446.1698535-3-oupton@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260624202446.1698535-1-oupton@kernel.org>
References: <20260624202446.1698535-1-oupton@kernel.org>
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

As there's no way to directly tell which of the two permissions failed,
evaluate both and forward the fault to the L1 hypervisor if either
fails.

Fixes: fd276e71d1e7 ("KVM: arm64: nv: Handle shadow stage 2 page faults")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/kvmarm/20260623190607.7106B1F000E9@smtp.kernel.org/
Signed-off-by: Oliver Upton <oupton@kernel.org>
---
 arch/arm64/kvm/nested.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 94df26de6990..4c9123cb2e1c 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -911,6 +911,7 @@ void kvm_vcpu_put_hw_mmu(struct kvm_vcpu *vcpu)
  */
 int kvm_s2_handle_perm_fault(struct kvm_vcpu *vcpu, struct kvm_s2_trans *trans)
 {
+	bool write_fault = kvm_is_write_fault(vcpu);
 	bool forward_fault = false;
 
 	trans->esr = 0;
@@ -918,14 +919,27 @@ int kvm_s2_handle_perm_fault(struct kvm_vcpu *vcpu, struct kvm_s2_trans *trans)
 	if (!kvm_vcpu_trap_is_permission_fault(vcpu))
 		return 0;
 
-	if (kvm_vcpu_trap_is_iabt(vcpu)) {
+	/*
+	 * S1PTW permission faults do not provide sufficient syndrome information
+	 * to determine if the fault was for read or write permissions. Perform a
+	 * read permission check and an optional write permission check, relying
+	 * on the fact that:
+	 *
+	 *  - The table walker at minimum requires read permission
+	 *
+	 *  - The L1 hypervisor also needs to deal with the architecture and
+	 *    cannot directly infer the failing permission from the fault context
+	 */
+	if (kvm_vcpu_abt_iss1tw(vcpu)) {
+		forward_fault = !trans->readable;
+		if (write_fault)
+			forward_fault |= !trans->writable;
+	} else if (kvm_vcpu_trap_is_iabt(vcpu)) {
 		if (vcpu_mode_priv(vcpu))
 			forward_fault = !kvm_s2_trans_exec_el1(vcpu->kvm, trans);
 		else
 			forward_fault = !kvm_s2_trans_exec_el0(vcpu->kvm, trans);
 	} else {
-		bool write_fault = kvm_is_write_fault(vcpu);
-
 		forward_fault = ((write_fault && !trans->writable) ||
 				 (!write_fault && !trans->readable));
 	}
-- 
2.47.3

