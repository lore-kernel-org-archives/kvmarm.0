Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C53A289E06
	for <kvmarm@lists.linux.dev>; Fri, 27 Mar 2026 14:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774620061; cv=none; b=utrMUle0I87N7FMKaB00Fc0sXfnk7KdG3OiwRhCHmlodjW8TNXUYWpWYVB/Neg39GPkfxI8JmqA3QJz5gmhw13QTnsstixt7vQIBkMhd5TKNvnNQFIbll5ICaeO7PAzR4zOPZnNCq013Zzzip+TCiyRzBjBWUJagmKk8rPqZzRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774620061; c=relaxed/simple;
	bh=QaZdw+cKvQLXGdg14aZy7asM3jAbDolMGcxEF/Z3CVE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k+rQHa+k2yUaawH8I4dj+djAgFL8bX0OhiN5AZ+OI1Ai2Ij2wFjucDvp1q7OYzrqIsf7SAF496UIw6KV2jauQaIPDFV3IPlhO8G6wG3LU8RehOFYPRhW1/QMpyoIfuulwv5ls71aZGZOAc3rhjtdAZOhHnpCRP74siQ4w17B3nY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ycz1wOij; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ycz1wOij"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3481BC19423;
	Fri, 27 Mar 2026 14:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774620060;
	bh=QaZdw+cKvQLXGdg14aZy7asM3jAbDolMGcxEF/Z3CVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ycz1wOijK9lypWq44ZhQ9nW3bypsyhNMcXmAI5YlT4qlcAQdrDVI7SS9wwUnApkGb
	 w70OH21mudmIycY4muSteKOFiWaaDUAcKqckHo8c73d3Tq8ed7ciy6bWDqkFzDLScy
	 m2vPPZesIsuM1KKbTU7gs8JqpobCkm2iIZzpdyZjUitAAB+S4Hk/0cHjXvcQkNVYpK
	 zaQCicTkpJzWEC8yKYxksM5dsROxhgEblujUu/6Ffw1vg7oqG37cwzaakZXOb7rZc7
	 JH76+hOol4xN5JkK/VNSBDPcIxsu5xDzIdv4dPjKqHbfOz5h4hBpj344VJj0p1MRKV
	 QLAwWKsWSHp2A==
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
Subject: [PATCH v4 03/38] KVM: arm64: Move handle check into pkvm_pgtable_stage2_destroy_range()
Date: Fri, 27 Mar 2026 14:00:02 +0000
Message-ID: <20260327140039.21228-4-will@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260327140039.21228-1-will@kernel.org>
References: <20260327140039.21228-1-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When pKVM is enabled, a VM has a 'handle' allocated by the hypervisor
in kvm_arch_init_vm() and released later by kvm_arch_destroy_vm().

Consequently, the only time __pkvm_pgtable_stage2_unmap() can run into
an uninitialised 'handle' is on the kvm_arch_init_vm() failure path,
where we destroy the empty stage-2 page-table if we fail to allocate a
handle.

Move the handle check into pkvm_pgtable_stage2_destroy_range(), which
will additionally handle protected VMs in subsequent patches.

Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Fuad Tabba <tabba@google.com>
Tested-by: Mostafa Saleh <smostafa@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/pkvm.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index d7a0f69a9982..7797813f4dbe 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -329,9 +329,6 @@ static int __pkvm_pgtable_stage2_unmap(struct kvm_pgtable *pgt, u64 start, u64 e
 	struct pkvm_mapping *mapping;
 	int ret;
 
-	if (!handle)
-		return 0;
-
 	for_each_mapping_in_range_safe(pgt, start, end, mapping) {
 		ret = kvm_call_hyp_nvhe(__pkvm_host_unshare_guest, handle, mapping->gfn,
 					mapping->nr_pages);
@@ -347,6 +344,12 @@ static int __pkvm_pgtable_stage2_unmap(struct kvm_pgtable *pgt, u64 start, u64 e
 void pkvm_pgtable_stage2_destroy_range(struct kvm_pgtable *pgt,
 					u64 addr, u64 size)
 {
+	struct kvm *kvm = kvm_s2_mmu_to_kvm(pgt->mmu);
+	pkvm_handle_t handle = kvm->arch.pkvm.handle;
+
+	if (!handle)
+		return;
+
 	__pkvm_pgtable_stage2_unmap(pgt, addr, addr + size);
 }
 
-- 
2.53.0.1018.g2bb0e51243-goog

