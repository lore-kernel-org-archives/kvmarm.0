Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AC0735E53A
	for <kvmarm@lists.linux.dev>; Mon, 19 Jan 2026 12:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768826841; cv=none; b=CnWVDGGw0HX6Q8JDclOJAg3suUQucyUaqTzMFzlT8vmVFCGh7utQYcqGaZ7vBc8sZF5KScN94PFeseL28JDMJmmFRbI0J6USBTSF+0T3iFJ6D82D09b0Pl36ZdbQX9AgYVB2CXN/k7tVjU1alRPHhxIgxa0PtVjzSEYDdcF5TqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768826841; c=relaxed/simple;
	bh=8iNT4oQAeGWJG0Dr79nIPwJzjgkxNXQGMTbbi7cpd2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZKKDpWUDPcF39Q20LW4ofCa4uzM1FGa0siTTQSuh1qRu+2G6PgLtKfOlZG9PQS56XLXtNwb8kGniX3VSvx5Z3z9R2046Zf2QkT3iAJ3857Sss+HQAUIOE3rKDX90Iw04xBeX22xo+rA9qb9J4qunTtrrG1l3l1VwkgBWZKM1W9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZAQfLsbT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZAQfLsbT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D7A9C19423;
	Mon, 19 Jan 2026 12:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768826840;
	bh=8iNT4oQAeGWJG0Dr79nIPwJzjgkxNXQGMTbbi7cpd2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZAQfLsbTbX8Vxk5iZ2AIRHCZtghLQ8Y3mvrrX46JtllSvwyNmcJK/psOh4Ywh+BWW
	 yrD2FvmV1igIMzgtKybK2cuO93rpCEJxG66lLKuFBfnKz6S3t3x5Xupyhr4OTZS3lM
	 Mhe69t2ypF4z0TIM13paTzokaO2fJGZvqoAVju7N4h48jwNZWl8Bf3IKL8+TYyKTpQ
	 Cye6psd2J2BmCFnuIqxJBAPSdEHPBqXhhqxRxXVqLDHNmA9Nll8p1In5OuHdRUagRQ
	 2B1UuqyZHqBDHaw9DbkzIWRj7+KgCvXxIaY5TGx+rTr41dvVvlldaJMkDG8z+YiOJs
	 7ruhqlXoPYQFw==
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
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH v2 09/35] KVM: arm64: Prevent unsupported memslot operations on protected VMs
Date: Mon, 19 Jan 2026 12:46:02 +0000
Message-ID: <20260119124629.2563-10-will@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260119124629.2563-1-will@kernel.org>
References: <20260119124629.2563-1-will@kernel.org>
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

Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/mmu.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index f535a180fc1e..a23a4b7f108c 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -2419,6 +2419,19 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
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
2.52.0.457.g6b5491de43-goog

