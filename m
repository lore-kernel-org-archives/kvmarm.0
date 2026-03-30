Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A691324B23
	for <kvmarm@lists.linux.dev>; Mon, 30 Mar 2026 14:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774882161; cv=none; b=RYw+gyX3x8kTKlYSQfn072GtOVbvS+/mjfpmVcV46XOyFCt4Q5PfJip+orhARalrMC8umGmg4dJlz81znxuXBnQeJR5j6CHAsv0ZFNuGt1F4+2KiBfm8PNCJVPOiwvIfZfGGZhn/4o4YGgAGjiMoB4dn9a0jlGfvf+gIa+vUUJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774882161; c=relaxed/simple;
	bh=7P+uzxldFf+9qg+nRD40JCugsSDrZRwu1jtKYArToK8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z8nZ3H0Or+2/tTy4q5nIrcyRr02fFhHOdxLUhBNAkfVk5pR3ksjaJcKfiqZEeIrXyQC4bBxL57L3tdtKyeQyhe1Oz2xHROq2U2GyDk5t9OTGaOk7amRIFCsoQUDZWFzJBkJfZCx9LroOGWN14GBcA7FMq0iVS1PM7CNbhfsyYSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VMeOEdH2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VMeOEdH2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41056C2BCB1;
	Mon, 30 Mar 2026 14:49:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774882161;
	bh=7P+uzxldFf+9qg+nRD40JCugsSDrZRwu1jtKYArToK8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VMeOEdH2h+jUvGV7ydQh9oSm/Dj1t2ykqHJYdjyvymnP3dDB/nxB++AdjPzaWCHlq
	 OXBDjpVwU4hKwy7zMgh8H8dMSRofvftFiAMVTexSWcEGMrvp1diz52/JiDZoLFevqe
	 3YAZhO/uUOy5bBbQN+6Peg+D5eZ6r9tDoogKbIcdTFA3bOJ3mZkNl0vhBt0+uSW2Cb
	 FulM8Gy/h5nKWvwz0qdUqtHQLcxGD0PPtWokTLZLUj3oXo/vaTqc+mnbYXSkw4JzVz
	 gm2qVysFx9KbOxomjdEMSujIh3gQNxai9mVJweAFIXxMi9yj6797dRyy9uv/yZdhW6
	 3TuEttyqW1h/w==
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
Subject: [PATCH v5 09/38] KVM: arm64: Prevent unsupported memslot operations on protected VMs
Date: Mon, 30 Mar 2026 15:48:10 +0100
Message-ID: <20260330144841.26181-10-will@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260330144841.26181-1-will@kernel.org>
References: <20260330144841.26181-1-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Protected VMs do not support deleting or moving memslots after first
run nor do they support read-only or dirty logging.

Return -EPERM to userspace if such an operation is attempted.

Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Fuad Tabba <tabba@google.com>
Tested-by: Mostafa Saleh <smostafa@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/mmu.c  | 13 +++++++++++++
 arch/arm64/kvm/pkvm.c |  6 ++++++
 2 files changed, 19 insertions(+)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 5e7821fe0fc4..b3cc5dfe5723 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -2414,6 +2414,19 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 	hva_t hva, reg_end;
 	int ret = 0;
 
+	if (kvm_vm_is_protected(kvm)) {
+		/* Cannot modify memslots once a pVM has run. */
+		if (pkvm_hyp_vm_is_created(kvm) &&
+		    (change == KVM_MR_DELETE || change == KVM_MR_MOVE)) {
+			return -EPERM;
+		}
+
+		if (new &&
+		    new->flags & (KVM_MEM_LOG_DIRTY_PAGES | KVM_MEM_READONLY)) {
+			return -EPERM;
+		}
+	}
+
 	if (change != KVM_MR_CREATE && change != KVM_MR_MOVE &&
 			change != KVM_MR_FLAGS_ONLY)
 		return 0;
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index dd93dfdfe52d..94b70eb80aa8 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -192,10 +192,16 @@ int pkvm_create_hyp_vm(struct kvm *kvm)
 {
 	int ret = 0;
 
+	/*
+	 * Synchronise with kvm_arch_prepare_memory_region(), as we
+	 * prevent memslot modifications on a pVM that has been run.
+	 */
+	mutex_lock(&kvm->slots_lock);
 	mutex_lock(&kvm->arch.config_lock);
 	if (!pkvm_hyp_vm_is_created(kvm))
 		ret = __pkvm_create_hyp_vm(kvm);
 	mutex_unlock(&kvm->arch.config_lock);
+	mutex_unlock(&kvm->slots_lock);
 
 	return ret;
 }
-- 
2.53.0.1018.g2bb0e51243-goog

