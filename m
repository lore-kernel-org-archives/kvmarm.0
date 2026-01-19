Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F28535EDBA
	for <kvmarm@lists.linux.dev>; Mon, 19 Jan 2026 12:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768826819; cv=none; b=D8B4GhDQSX+pA30XWOhRuqzt72kWeSHwHFbfjMk++5/TuESnNB6dh/tdZEfwCetRP6Exfsk27OyFX1K1bWETpoQ1MaNX6iXgDSBzvzcAteLiYSyPiA8nHShd0r4F1XE2J5hz00DMepVZR6O/Nn22iGCeqyAuWiXs0Dm0SSdLA44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768826819; c=relaxed/simple;
	bh=NSDE7w18H5H9oBwx/Q8/XjnJ3tAfUQrVudZ00DELzrs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YcNaUuOZA7rZhzG3koaVxEM6sMVu4m60dhaTPYVgilKOC0M1ZvSNPOkMiXmmbhD1GKxgZThkKih0lxEv3lmT/nAuBM3C7iv2UI/E48vpAnREkkshC0uoXdrRnfXyqTRz5NSjR0gJIstcQpIbR2EiEHjhVlTkUEfShv3Mua3+zBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L1eeo/z2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L1eeo/z2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3689C116C6;
	Mon, 19 Jan 2026 12:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768826819;
	bh=NSDE7w18H5H9oBwx/Q8/XjnJ3tAfUQrVudZ00DELzrs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L1eeo/z2YGNrjz+jOS7LISbuNYMpx6J2DtZMfAv+Y12I0ilU6jGG7DB01ZwmVPuNv
	 eFIxGIUgkbbBJBO2Wzhfuv8PyfMmdhpItjNNbvpQkpS8o8LlZe13WIIPZfgd5T9MWK
	 Uk3XD+mH8fpyofi1FfgDZg5pmKWa/YuO+31FzBvT4norS/sl0T47AJUpG840n1p6pi
	 9DNrKymNGY//19Ht3vw/SpZe88mXz+nRvvKi9ns0f3vR06NxOcGWPlDJ8A+fyHocAy
	 7K0lcklJIJbL1KUtb7ubeC77+kWrPHoEkblLCWmZZK8SL6jZqHtFMpzlYHybg/8eNh
	 EUZYdm+AkG8ng==
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
Subject: [PATCH v2 02/35] KVM: arm64: Don't leak stage-2 page-table if VM fails to init under pKVM
Date: Mon, 19 Jan 2026 12:45:55 +0000
Message-ID: <20260119124629.2563-3-will@kernel.org>
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

If pkvm_init_host_vm() fails, we should free the stage-2 page-table
previously allocated by kvm_init_stage2_mmu().

Cc: Fuad Tabba <tabba@google.com>
Fixes: 07aeb70707b1 ("KVM: arm64: Reserve pKVM handle during pkvm_init_host_vm()")
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/arm.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 4f80da0c0d1d..6a218739621d 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -190,7 +190,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 		 */
 		ret = pkvm_init_host_vm(kvm);
 		if (ret)
-			goto err_free_cpumask;
+			goto err_uninit_mmu;
 	}
 
 	kvm_vgic_early_init(kvm);
@@ -206,6 +206,8 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 
 	return 0;
 
+err_uninit_mmu:
+	kvm_uninit_stage2_mmu(kvm);
 err_free_cpumask:
 	free_cpumask_var(kvm->arch.supported_cpus);
 err_unshare_kvm:
-- 
2.52.0.457.g6b5491de43-goog

