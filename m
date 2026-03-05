Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E597F1C5D5E
	for <kvmarm@lists.linux.dev>; Thu,  5 Mar 2026 14:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772721855; cv=none; b=BN/B08LHhGhT+RrO9GViKzjY6WRSq4+tAHnWZYAkWSkhYNNytbG/cHV3YxaEF90/aFVoeFmIGhNAv2tsWN7Z+eqXcWCSMKvBzQMm3oJ+CPTvlaYgAW8rELZG1FMU11QTH0d8rNt4G/CCChx7XNqAxVSIaXkYmuJJLYRt2LP+Zm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772721855; c=relaxed/simple;
	bh=c9Fpr1Thyeh86mf/IzfwmmsmZmZJ43SuIK2fQQSl31M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tsK/XzEenNeEhcIkqO9wp45Yp/odfC8ZUJ7ylr+lZnAdFwulzsRUBoFtbo51UAnLuLi+hkYj1BcCnbdeasMJEQar8ZZnw2jc9YYQt212/Tm73WV5c/p0+Dn7GXSykc9GNNV3ErU1ttDvtMxHh+9R50wcczCVPUn3NvhJaSOhukI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p1OCncZl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p1OCncZl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A428DC19423;
	Thu,  5 Mar 2026 14:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772721854;
	bh=c9Fpr1Thyeh86mf/IzfwmmsmZmZJ43SuIK2fQQSl31M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p1OCncZlCb2IbW/XDaHO+OHThv5nJBpCClo52khj2+5pE0g5FtF+R1vMucV9dFoGJ
	 ePFIV4ey+Cx6uT+BOzWo2RvPBluY4CPt/0Xl38C0aVkMGzDSUTANPHiqyhsmGkF/j2
	 sfIVZUQv6G/DLLV391Ui7q5CHLaw8Vp/Y3BQ02rn3mYC74sKbTXv4ZiVt0B7GJ77k8
	 PCkG7gsO6xhel5yOUqhBmWhlxPc24Qj7DvsiSgcEiWuu5S0u9NOnsjSYgEkYX7qchG
	 S5095qghVnaC/AWneOI6cYMtAvslJXF7QJARakypeksql46yHiKt816unkLNiv+xzL
	 B/btBTPytKNCQ==
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
Subject: [PATCH v3 01/36] KVM: arm64: Don't leak stage-2 page-table if VM fails to init under pKVM
Date: Thu,  5 Mar 2026 14:43:14 +0000
Message-ID: <20260305144351.17071-2-will@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260305144351.17071-1-will@kernel.org>
References: <20260305144351.17071-1-will@kernel.org>
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
2.53.0.473.g4a7958ca14-goog

