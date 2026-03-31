Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2D19285CBA
	for <kvmarm@lists.linux.dev>; Tue, 31 Mar 2026 15:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774972298; cv=none; b=d6P86G4kIJvZ5cGR3Zt7GN6sMZA5js2ZzMUMPyMhVInlIKKT5gH+C4Squ3Jy9m4AUaXSLzolS/vJrFAnd5ulxBjCY4D/gU3m7RQ1yhrnWYTuqco8dkQFmYmG87tLKxaEhKNFT2VvSNqZNpurwADLXOLUQys1WvwcSm71Pcj6Y0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774972298; c=relaxed/simple;
	bh=GL1xt9IrccrXv3S/Wi41bhBc0pdwWweVffmPPWUmVYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ToNtQCraWSNvmruigRLTN7ypuG9wMEoeJAZ6DfePDIkaoZe8y8NN3qMrnTsHgOxw/2zBB7goal/r33WKrUIe2vatQ8XHskpwFDkd/9PWXs7oILz5Ro6y5nH6Vglxae0kJK1VqL4x5eBMWcwPCvhnrs+KquOB4E0A33v3eECuk7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k+JdlVkF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k+JdlVkF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3936C2BCB1;
	Tue, 31 Mar 2026 15:51:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774972298;
	bh=GL1xt9IrccrXv3S/Wi41bhBc0pdwWweVffmPPWUmVYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k+JdlVkF4Yy9bwV1wbUwaYJnX0dGFMhaXiUE7SGeQQY08XYvCOEPeA+AxWj1FaUVa
	 RxrAzaFZnwQNsksh7370CzSDaitvvKfn1yGoVJU/0E4Q6e7Xqan3slrjCzyMOUSVOf
	 ig3aA/+dE+yqwTU7UUJYLJuUU4XFVULh2CABNJuoblwgEx+sFoYS8yOVmr9vi92O6e
	 UpaCzZhTH5orTbF/Z/qXMkiH5ujnw2CrvTvM32bhQYCc0xSOr/01P6UD+Afvn8PHRP
	 IrN5+EgMnUOWNvnhDgBHaSEWVMRELhSh0fU3ssgrqsxQwjm1pDt9Q/Y2AiCPGrePxh
	 3Xt3OFzLbg7eg==
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
Subject: [PATCH 3/3] KVM: arm64: Don't hold 'vm_table_lock' across guest page reclaim
Date: Tue, 31 Mar 2026 16:50:55 +0100
Message-ID: <20260331155056.28220-4-will@kernel.org>
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

Now that the teardown of a VM cannot be finalised as long as a reference
is held on the VM, rework __pkvm_reclaim_dying_guest_page() to hold a
reference to the dying VM rather than take the global 'vm_table_lock'
during the reclaim operation.

Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/pkvm.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index b955da0e50bc..7ed96d64d611 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -918,15 +918,16 @@ teardown_donated_memory(struct kvm_hyp_memcache *mc, void *addr, size_t size)
 
 int __pkvm_reclaim_dying_guest_page(pkvm_handle_t handle, u64 gfn)
 {
-	struct pkvm_hyp_vm *hyp_vm;
+	struct pkvm_hyp_vm *hyp_vm = get_pkvm_hyp_vm(handle);
 	int ret = -EINVAL;
 
-	hyp_spin_lock(&vm_table_lock);
-	hyp_vm = get_vm_by_handle(handle);
-	if (hyp_vm && hyp_vm->kvm.arch.pkvm.is_dying)
-		ret = __pkvm_host_reclaim_page_guest(gfn, hyp_vm);
-	hyp_spin_unlock(&vm_table_lock);
+	if (!hyp_vm)
+		return ret;
 
+	if (hyp_vm->kvm.arch.pkvm.is_dying)
+		ret = __pkvm_host_reclaim_page_guest(gfn, hyp_vm);
+
+	put_pkvm_hyp_vm(hyp_vm);
 	return ret;
 }
 
-- 
2.53.0.1118.gaef5881109-goog

