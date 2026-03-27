Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08B302DF155
	for <kvmarm@lists.linux.dev>; Fri, 27 Mar 2026 14:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774620058; cv=none; b=gfHB45DpGKrPm8il0sRPcydeYVhgJFGzjmyCDaUTqjHR4X2+h3Wuca+VV8ob+E4UcZTxx6GIXWRQJjm2rWUCyyiHLUV5YIfZ1ymvZaMH8oC0yOL+v9RE+o2N8lSs0bN7QcpAYh2OGTfpxQ01AtBx4qGNfbsaSI1pgVz5yE85q5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774620058; c=relaxed/simple;
	bh=oRXTTRgczig8LPFqQrC03P5UVc2knZV/Mhzu7vhCAjE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Slo7Ykj/rKIyQWNu/m7JbJ9llJzagcR7nbZICCy3Nl70cDb+SH0Mg9MwzlZoIcQAHoASWGn9mvuFfVFhJtbj+rQSUtrUM7KOGq4EpppSuiBpV/22GMUnzUnOuP+PfDYR1VMiP8xAIU0+w2/yTysLC85KKzknzvfYYqPkZ7oY9gE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LyT4x2Mt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LyT4x2Mt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2D3FC19423;
	Fri, 27 Mar 2026 14:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774620057;
	bh=oRXTTRgczig8LPFqQrC03P5UVc2knZV/Mhzu7vhCAjE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LyT4x2MtThRTkNGlwHzJo3ABU02F9J6U8oITwVZKm/c73NHOlsXvQCay7G9ixkyRO
	 5fXzcQpgxPEgNXTzF2EpUk90b4ESxaHHawHtmYsFIB8LgL83ixJNKjs5BFWcOIIxm1
	 3Z3/VLlE5Ge1KQ8BPY8Zr2BnQoPeVA7soKjK3D7eRHYGBL1dIRLFgDWrAdp60H8BlJ
	 yVk4MQbIfJ7pMhPZOWYLWTOYpMyIT02cw3MYHrZhyz1Fln6MoIeg6AamDgoT0pMNiP
	 qpWxDFDi2LOQgKCyvMPyypJ/BLlk3O+IdtV2ZA4qbiVw2fa+X+qLDTIhXu0vXnnsaa
	 Cv5rUtnkXbUZA==
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
Subject: [PATCH v4 02/38] KVM: arm64: Don't leak stage-2 page-table if VM fails to init under pKVM
Date: Fri, 27 Mar 2026 14:00:01 +0000
Message-ID: <20260327140039.21228-3-will@kernel.org>
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

