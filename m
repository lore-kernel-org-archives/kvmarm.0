Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B02ED3F7A8B
	for <kvmarm@lists.linux.dev>; Tue, 31 Mar 2026 15:51:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774972292; cv=none; b=j3lu9mfapPcQKl/8YlUuj68T1ZMd+S+exb72M5udYKBIx+w3Kr+ND8UCdtLbj5Y3z0qSTZ7niolZMssDWMJ2bPHzAWihh08G1VHpcCwUn9u0wfym9e7Ccl+FzaGySoCAufV0lMyVadWYy1ipbt/pdtif22vNoTeu2O9WokeppWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774972292; c=relaxed/simple;
	bh=2M1SXzxRJkZCmnKmHuROBofVvlwQ52Jmw/W1lvRR9U0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lvEIY9tCAOMeYpb9xFG1zWTZO7vCeLOcTmwOvewAfAvHVmNF02DxtjjW+oNf9JNJZRhioU1wB08qxjlX6EmvjNd1XM9gxviSuO2ue1R0N9ZuvUx42IRt7bDZrNjZH2p2+UuUas4hvFyoMbFq+9rupFS/0o3mZc3YMcAy3HrSYgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sGP9aANq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sGP9aANq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31799C19423;
	Tue, 31 Mar 2026 15:51:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774972291;
	bh=2M1SXzxRJkZCmnKmHuROBofVvlwQ52Jmw/W1lvRR9U0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sGP9aANqLHoRiD8xitb8BBFzgEOaPt0Tn72k02TBOMq8WGw5uI+Gtqn0c9pNj8SeV
	 UqIPmiGPL4Piwt5Tlftb9B4kgm1WoP++9+s6SZZI4Yz7GqmjFEzNbSsVdido9pQHfO
	 2aBG31uuz6lhP2210c4xtcs9hrc9BLdFlMjwnB3wUjA4sXwjgcHp8DGQOvNWCTCp/Q
	 yJWpy9kp/APQVOHRL6sdWi02g3M6F/LCxHXlYbl+ZEjN2Dym8ZYWellCS4wt2zhvgB
	 EeJmdAj7FjfwVH/03oCalM4hFGyfUM6T4h5wYrTnTtQHK0jMQGtk/FuF85R3QGfVth
	 Y5D7QCQ0nivjA==
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
Subject: [PATCH 1/3] KVM: arm64: Prevent teardown finalisation of referenced 'hyp_vm'
Date: Tue, 31 Mar 2026 16:50:53 +0100
Message-ID: <20260331155056.28220-2-will@kernel.org>
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

Destroying a 'hyp_vm' with an elevated referenced count in
__pkvm_finalize_teardown_vm() is only going to lead to tears.

In preparation for allowing limited references to be acquired on dying
VMs during the teardown process, factor out the handle-to-vm logic for
the teardown path and reuse it for both the 'start' and 'finalise'
stages of the teardown process.

Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/pkvm.c | 32 ++++++++++++++++++--------------
 1 file changed, 18 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 8b906217c4c3..3fd3b930beeb 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -936,20 +936,27 @@ int __pkvm_reclaim_dying_guest_page(pkvm_handle_t handle, u64 gfn)
 	return ret;
 }
 
+static struct pkvm_hyp_vm *get_pkvm_unref_hyp_vm_locked(pkvm_handle_t handle)
+{
+	struct pkvm_hyp_vm *hyp_vm;
+
+	hyp_assert_lock_held(&vm_table_lock);
+
+	hyp_vm = get_vm_by_handle(handle);
+	if (!hyp_vm || hyp_page_count(hyp_vm))
+		return NULL;
+
+	return hyp_vm;
+}
+
 int __pkvm_start_teardown_vm(pkvm_handle_t handle)
 {
 	struct pkvm_hyp_vm *hyp_vm;
 	int ret = 0;
 
 	hyp_spin_lock(&vm_table_lock);
-	hyp_vm = get_vm_by_handle(handle);
-	if (!hyp_vm) {
-		ret = -ENOENT;
-		goto unlock;
-	} else if (WARN_ON(hyp_page_count(hyp_vm))) {
-		ret = -EBUSY;
-		goto unlock;
-	} else if (hyp_vm->kvm.arch.pkvm.is_dying) {
+	hyp_vm = get_pkvm_unref_hyp_vm_locked(handle);
+	if (!hyp_vm || hyp_vm->kvm.arch.pkvm.is_dying) {
 		ret = -EINVAL;
 		goto unlock;
 	}
@@ -971,12 +978,9 @@ int __pkvm_finalize_teardown_vm(pkvm_handle_t handle)
 	int err;
 
 	hyp_spin_lock(&vm_table_lock);
-	hyp_vm = get_vm_by_handle(handle);
-	if (!hyp_vm) {
-		err = -ENOENT;
-		goto err_unlock;
-	} else if (!hyp_vm->kvm.arch.pkvm.is_dying) {
-		err = -EBUSY;
+	hyp_vm = get_pkvm_unref_hyp_vm_locked(handle);
+	if (!hyp_vm || !hyp_vm->kvm.arch.pkvm.is_dying) {
+		err = -EINVAL;
 		goto err_unlock;
 	}
 
-- 
2.53.0.1118.gaef5881109-goog

