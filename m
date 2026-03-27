Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D76E23EF675
	for <kvmarm@lists.linux.dev>; Fri, 27 Mar 2026 14:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774620080; cv=none; b=XDXGxx6za9dwLnOr6wdlGidZEhkdC6B8T7QoLRJnQF+II8tZQLVcMFYZer5kWRAbG8bBA/Dc6nxOK3p8/oFsxXMl0ubYWpvXXifFgeGGWeYl2mg6ZP4wRAd/JmmhcRNMiDF+0m4F5YH6lfyO5lAkNyJKSRVb+oHZ1QHm30HwyHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774620080; c=relaxed/simple;
	bh=ytSwSbutDYnmNQD/WJcRI42GxQWEkV8O9WbKsVxsWAc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ptXfnT9vd7+ZiMD9sX+eBuNi+xYqLEgQc1Llz2N93NOHQa/3k3IJDq+EfWSIPba9EdOym216JzygbLpL4qgCh9ZZVVNJQihwrVe5EwlWREzuXFOIEIxxtm3ZG8AMyJP3sGQlfvQm9lewkQsjmz7BbyPNZBdcsyDwu7ABGQp8G0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pgsY3W6l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pgsY3W6l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1729C2BCB1;
	Fri, 27 Mar 2026 14:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774620080;
	bh=ytSwSbutDYnmNQD/WJcRI42GxQWEkV8O9WbKsVxsWAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pgsY3W6l72r3Ktoy08b2ty2QUdicC4H5HATTm3GIMJfbBw7gzPAlfk/MoICuTP5Wt
	 1CuTMwOSsUCQjy8KPk6nx0bUQ49PTmic25FjqpcIJePAMSj1I7K/JeJnrcPt3jd6yR
	 PSinKgiBJgAxO5SRj/vcSpEYPoP4A8M3g61mT2MnXdfMCZ7TXwiggh2dSqVHEp7q1B
	 BV4sETlYGDTWdggybJb87QHMTSV8DYmTtPK4GFfI0kxgAvBb7zfY4JQjzqCX6ZeUVv
	 EQmExHk6KZo2y8ld+5vwCX7baPTFTuXtUt0152az68ro8MuKWJOsoLzGU5qo0bAZOA
	 LXm6ryHFEH4Bg==
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
Subject: [PATCH v4 09/38] KVM: arm64: Prevent unsupported memslot operations on protected VMs
Date: Fri, 27 Mar 2026 14:00:08 +0000
Message-ID: <20260327140039.21228-10-will@kernel.org>
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

Protected VMs do not support deleting or moving memslots after first
run nor do they support read-only or dirty logging.

Return -EPERM to userspace if such an operation is attempted.

Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Fuad Tabba <tabba@google.com>
Tested-by: Mostafa Saleh <smostafa@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/mmu.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

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
-- 
2.53.0.1018.g2bb0e51243-goog

