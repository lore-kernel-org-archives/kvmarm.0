Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2559D3242BD
	for <kvmarm@lists.linux.dev>; Mon, 30 Mar 2026 14:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774882138; cv=none; b=NEShxa/lcfEE7rUYdEuP5sOmctkS1HhbCSV5ywU7jNLGF1AnBHMybZ0wkynE/Vykr0cE02cyOB/whrO4fq7tMEn2czc9EodtstcT+4WFaaiEyOio7ADT7d//SQc1RPQPvLE3pk/AQk5AFKaGBPzkMNbuuqOmVT5aWUl5EBD1mI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774882138; c=relaxed/simple;
	bh=oRXTTRgczig8LPFqQrC03P5UVc2knZV/Mhzu7vhCAjE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZtkAPOFfEUR+7aQtEevhJibfVVk36VArBW/K0nSN/CvMWYPZGHp9pXsqZEVoP2DL136S5ATiSD2ezM6xC8vDrbkFaABD+hOyDrpp2tAF9AyaVAvBi8VoDHXa6qTyj57y73FaLKdZgaHLLl7l9k1xxtBpcd5vjORUsjFnZEgj8vQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eDBXnG1P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eDBXnG1P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12D6CC19423;
	Mon, 30 Mar 2026 14:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774882137;
	bh=oRXTTRgczig8LPFqQrC03P5UVc2knZV/Mhzu7vhCAjE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eDBXnG1PUBCdKhvKgQX/Mf9I6ls8gCEkG+DBMBNpnM2HpXs0w7QtWMhsCnKRyQro5
	 wZSat0IyjPoKNVJB6k71+YkAS3yxqnXR7TEe7BaXIL8qZN0jN1jwOYwMS8Vv3jKTz4
	 SBNmGO+FAPcy6KpSCI7w0nXDmK0V0c9suw7PdbvP9/8iPWImNWBtPEK+6LtQjoxSdy
	 ZB3gqaQD0K472ZQlFYyQiOsG/FGM29neD4UzwMGN5uWZg2YXHXbLx6yx3hParOQSXd
	 10+jmU+sB9ext2NdYbx0JVY4dgnu7VhcqLNEcl0eZS4Zqx8iQwEAWlm7BTOXUvQuLj
	 moIec/rcVoylA==
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
Subject: [PATCH v5 02/38] KVM: arm64: Don't leak stage-2 page-table if VM fails to init under pKVM
Date: Mon, 30 Mar 2026 15:48:03 +0100
Message-ID: <20260330144841.26181-3-will@kernel.org>
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

If pkvm_init_host_vm() fails, we should free the stage-2 page-table
previously allocated by kvm_init_stage2_mmu().

Cc: Fuad Tabba <tabba@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Fuad Tabba <tabba@google.com>
Tested-by: Mostafa Saleh <smostafa@google.com>
Fixes: 07aeb70707b1 ("KVM: arm64: Reserve pKVM handle during pkvm_init_host_vm()")
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/arm.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 410ffd41fd73..3589fc08266c 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -236,7 +236,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 		 */
 		ret = pkvm_init_host_vm(kvm);
 		if (ret)
-			goto err_free_cpumask;
+			goto err_uninit_mmu;
 	}
 
 	kvm_vgic_early_init(kvm);
@@ -252,6 +252,8 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 
 	return 0;
 
+err_uninit_mmu:
+	kvm_uninit_stage2_mmu(kvm);
 err_free_cpumask:
 	free_cpumask_var(kvm->arch.supported_cpus);
 err_unshare_kvm:
-- 
2.53.0.1018.g2bb0e51243-goog

