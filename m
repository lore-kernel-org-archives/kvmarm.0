Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3C5A41B372
	for <kvmarm@lists.linux.dev>; Tue, 31 Mar 2026 15:51:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774972295; cv=none; b=rnqqvK9rfHiPk7++WBGoF5/Q2dan2I2usfNZZRpa+c3pk8i9fKV1bw+wFLvP4SQE7LQCBoaqxyDRva+XiuU4zwljWCYJSUKaJGrmX126xn7LGYXIWbkQ/jBP5z9jTG5gH3C5RP3mr6YsNSvs1t6/T1IZXig1DIvjkbLhneZWoqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774972295; c=relaxed/simple;
	bh=Jnvgq2pegetUjGhytI/QZI4LtPSB8jg7KrJ5nmPTBf0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BGJ13xu3/8JsWohHDGb3nlitHktWYpOdsCIJjovDi/fgtueUrzt66kTNzrlpM4nS8LAFBTg9iu9Ihxz1iNNGPqKYktLKqEfDQ2hn0+INnltuuIHA+lfdUuwEoWVKh0+8+qP/pwHY47yrcYzNRAiJB8sXzduAmhyy2g4mEhtaYZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Vm7PaAYQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Vm7PaAYQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71BDCC19424;
	Tue, 31 Mar 2026 15:51:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774972295;
	bh=Jnvgq2pegetUjGhytI/QZI4LtPSB8jg7KrJ5nmPTBf0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vm7PaAYQuiVvieD+rjDmaDmoT4LLOScZiZKiUpSSOeMjjYn5ZPFQn+regAxdhMgex
	 gd7v5781pr8h4/EM+LM+Im1fMAg3O4uCA0YNYMBeGDWXSlvGGmCoG3ODiOgJA1OO9N
	 F+1+r1dt3WgBTP+8uiwb3gWr0yyKbRDC7M2zNTq5CdBF9Mmg/KLSLor4hE3LSAFBB9
	 EGErZmdKzuMVNML7vqu5NDki9VBfSd4H9YCrXyWNpNf70RzkRrAum4z5Z2sbJrwdOP
	 MNMofIBji9KZ1Z/7Dtma4kNhwvD+wXrPdzwnb+BN9VHKC0km4C+Z22eG4vCNVFxgjQ
	 ZTA9oSijZqpog==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.linux.dev
Cc: linux-arm-kernel@lists.infradead.org,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Quentin Perret <qperret@google.com>,
	Fuad Tabba <tabba@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Mostafa Saleh <smostafa@google.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PATCH 2/3] KVM: arm64: Allow get_pkvm_hyp_vm() to take a reference to a dying VM
Date: Tue, 31 Mar 2026 16:50:54 +0100
Message-ID: <20260331155056.28220-3-will@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260331155056.28220-1-will@kernel.org>
References: <20260331155056.28220-1-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Now that completion of the teardown path requires a refcount of zero for
the target VM, we can allow get_pkvm_hyp_vm() to take a reference on a
dying VM, which is necessary to unshare pages with a non-protected VM
during the teardown process itself.

Note that vCPUs belonging to a dying VM cannot be loaded and pages can
only be reclaimed from a protected VM (via
__pkvm_reclaim_dying_guest_page()) if the target VM is in the dying
state.

Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/pkvm.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 3fd3b930beeb..b955da0e50bc 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -309,14 +309,8 @@ struct pkvm_hyp_vm *get_pkvm_hyp_vm(pkvm_handle_t handle)
 
 	hyp_spin_lock(&vm_table_lock);
 	hyp_vm = get_vm_by_handle(handle);
-	if (!hyp_vm)
-		goto unlock;
-
-	if (hyp_vm->kvm.arch.pkvm.is_dying)
-		hyp_vm = NULL;
-	else
+	if (hyp_vm)
 		hyp_page_ref_inc(hyp_virt_to_page(hyp_vm));
-unlock:
 	hyp_spin_unlock(&vm_table_lock);
 
 	return hyp_vm;
-- 
2.53.0.1118.gaef5881109-goog

