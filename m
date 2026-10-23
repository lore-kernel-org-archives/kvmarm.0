Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792789010;
	b=QU0aZy17thUvc0fT3JKcOp0CI65YC7zKlNzASjw9d6+lo+5B45WD0Pnk36nnLem7Bi6g
	 f5mQl2CAm3e6O6UwYNzudThd9xRdWPbMMwAMTWiYU1vzZx00YD8d/ejbnmStLXLoBMSez
	 mgPW9czCAdj2KGAqLcgQjCi1m8boI9Jb4rqxtf1ScA8b0UxirvBmcnBGE9qrasy9cx2NY
	 kc2FwvCteTuNdZPLMlMpAPt5h0OWZhwpT8vqXUaTv3TG/hy1DJe2ie0hbqnKXnyab8mRh
	 MCX1LvtVb4EDRkwnCCLVFhfokRpsVeKczcwhs1L7Zy/7YUxSM3ZlNiAUlQwoEPI3WTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792789010;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=wdoDgkpqvfrRPadKgSQzPh0ji1X/m/kQoQfnBmOEsTI=;
	b=hm8v0mqKG/bZ+6hX1mRvjcouQlwDMn0QyplR0NAoD+48Cn2XOln8xfviEBKHr1ADfu5X
	 JhphicR9Y3HSaIO2+MBd5appyyC3BOvMsblGXzgByWPoxWpBOF0+/AgzuJlILS658kCiI
	 Kvn+Yw3/PCHBUc2TeAdF2uYomDDHaLMaLyZXgwDdAKZabfHqmiY551HpBjEOyZ6mH2ipA
	 SMxctNVleBM3uesy26d/fkWvAfRDWCa6xPyJ+lP+j1fBfZKpYX4DwVO34syqb5zAL65Pe
	 W5qZaSj8t8tmD7AtaoqiuDSYVojUOjzyrdDy0Wju9sJ9EJAi3uih/nAX9IRPmdINlWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WWrPqLa4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65CC1606A328
	for <kvmarm@lists.linux.dev>; Fri, 23 Oct 2026 20:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WWrPqLa4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FA3F1F031E2;
	Fri, 23 Oct 2026 20:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792789010;
	bh=wdoDgkpqvfrRPadKgSQzPh0ji1X/m/kQoQfnBmOEsTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WWrPqLa4Sr9VGiu2N3BIEihFbBB3o2sgo/tN7cANfg59OJRZAMwewH+5G02dQlHJx
	 405q+VQMzimpmsWyGqqTI9dDQaE3qQ3uxjnrS7Mh4enzJb3uHSl8Qgc3Aj7Jo05Ckd
	 gU+Yr2RRv+qN0LQ9ACUQJX6wdOxiw0enlBovBP3OtpCGVGO9i6mF91QgVZD6EHBpBt
	 yoFucJ0BSMeLcieOY5DH4JYE/xWgT5IHGuw3hAijZwbhW2zRMLY3IKEKOwEQn6qVKG
	 QMNB+KncB2mx7ZlBrozMHkymslsyLi25r9Ovp/c5HvMgnVQX6UvMV2+wk8+iP+rwpq
	 qB3f+NfdruUqQ==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Leonardo Bras <leo.bras@arm.com>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH v2 18/28] KVM: arm64: nv: Emulate CMOs via writable-clean translations as NOPs
Date: Fri, 23 Oct 2026 13:56:00 -0700
Message-ID: <20261023205610.1044532-19-oupton@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261023205610.1044532-1-oupton@kernel.org>
References: <20261023205610.1044532-1-oupton@kernel.org>
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

Virtualizing FEAT_HAFDBS for an L1 hypervisor has a pretty large
architectural deficiency by way of cache maintenance instructions.
CMOs (e.g. DC IVAC) require write permission but do not set the dirty
state on the descriptor.

There's no way to shadow a writable-clean translation in such a way that
these CMOs pass the permission check and subsequent writes generate a
permission fault. Worse yet, data aborts taken on CMOs do not have
sufficient syndrome information to perform instruction emulation and
trapping all CMOs is unpalatable.

So what do we do? Absolutely nothing. Treat CMOs to writable-clean
translations as NOPs in anticipation of KVM only exposing FEAT_HAFDBS
when the VM is fully coherent (FEAT_S2FWB, CTR_EL0.{DIC,IDC}={1,1}, no
noncoherent DMA).

Signed-off-by: Oliver Upton <oupton@kernel.org>
---
 arch/arm64/kvm/mmu.c    |  4 ++++
 arch/arm64/kvm/nested.c | 20 ++++++++++++++++++++
 2 files changed, 24 insertions(+)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 7b29be33a1ea..a21b674a1981 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -2548,6 +2548,10 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 		}
 
 		ret = kvm_s2_handle_perm_fault(vcpu, &nested_trans);
+		if (ret == -EAGAIN) {
+			ret = 1;
+			goto out_unlock;
+		}
 		if (ret) {
 			esr = nested_trans.esr;
 			kvm_inject_s2_fault(vcpu, esr);
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 7dda95d37925..46fcc75f4c20 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1150,6 +1150,26 @@ int kvm_s2_handle_perm_fault(struct kvm_vcpu *vcpu, struct kvm_s2_trans *trans)
 	} else {
 		bool write_fault = kvm_is_write_fault(vcpu);
 
+		/*
+		 * Plug your nose for a moment.
+		 *
+		 * Writable-clean translations are shadowed using a read-only
+		 * mapping so KVM can set the dirty state on the L1 descriptor
+		 * before installing a writable mapping.
+		 *
+		 * Certain cache maintenance instructions require a write
+		 * permission check but leave the translation in a writable-clean
+		 * state, meaning KVM is on the hook to emulate CMOs that use a
+		 * writable-clean translation.
+		 *
+		 * "Emulate" the CMO as a NOP, as KVM only exposes FEAT_HAFDBS
+		 * when FEAT_S2FWB is present and the I-cache is coherent.
+		 */
+		if (kvm_vcpu_dabt_is_cm(vcpu) && trans->writable && !trans->dirty) {
+			kvm_incr_pc(vcpu);
+			return -EAGAIN;
+		}
+
 		forward_fault = ((write_fault && !trans->writable) ||
 				 (!write_fault && !trans->readable));
 	}
-- 
2.47.3

