Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA4DA33DEC2
	for <kvmarm@lists.linux.dev>; Thu, 18 Jun 2026 23:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781826134; cv=none; b=vAtvJWPIashZnYhEUNIiO3gGXpwRKy/QQj5i6cHuCz5QKa0oN2YaO8mRZqFsBPYvjj7/Bsdl6T71u/dAWoYpsvyw/DrbMASshHyKhPGk1qSBtIlfKiDPxR6kQulfb00IybDM/ed49UHt/Bu9OmC9izIPRrmNWQoomWfLuV0Ijcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781826134; c=relaxed/simple;
	bh=FJcYRGox67HMe4ICyPfvIK5iFL0a9o4zbG90LSKYom0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hA2g6D/LngMj7C//FtqYm46vi+6/xrb7d7ryfG/StXvVEKY8G3MDm+22Po72epHfF7Aauzn+UfQYae6h7BT5MSasPrp72Xm8vSBVo3AGpVXyVQmJhjWgLNI2z2cPzbGoSi3FqnfAJOq0ZltlQHh9QbvYO7SevuGR+Lz4zEcDrz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bqUbH3IN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bqUbH3IN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B0011F00A3F;
	Thu, 18 Jun 2026 23:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781826133;
	bh=QNMnRr2V5+H2EvkVyyuavw+g/p9OwFy4w4Q4aYDh8VM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bqUbH3INsbMaQVvVUUxpFp8DivBvfXLbrbEQQ6QC17VmzK9DwNL+UBj3fdS7/fy0l
	 V7sDw+HnRSRrgv8s72r23W3/girYlNFon7RRI0buXdp9W+v5WXeioP03GrzV5sGcjz
	 +mYdD32YoiYHIfSH4PKE1dMLxwvc04UHqguRcCfd9ASpTcolzs3kBvEMZpLqE3jQ/y
	 YpL/JNXj/r17MqSsx8M4fFujLzDZ0/pUiCo3u2kzb8xmuYo2A34MlQYUwDSX/G2nug
	 8lRkImXMyvZIJ+EL9d5R2JeiGWaOFW2LknRrvV4j3j/EYMG5OAmSF4ESmmjQIYPs3H
	 bd/avgYhTwjdQ==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH v3 5/5] KVM: arm64: nv: Mark VM as bugged for unexpected VNCR abort
Date: Thu, 18 Jun 2026 16:42:06 -0700
Message-ID: <20260618234207.1063941-6-oupton@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260618234207.1063941-1-oupton@kernel.org>
References: <20260618234207.1063941-1-oupton@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

KVM is unlikely to resolve an unexpected VNCR abort, meaning that
returning to the guest will likely leave the vCPU stuck in an abort
loop. Bug the VM and exit to userspace instead.

Signed-off-by: Oliver Upton <oupton@kernel.org>
---
 arch/arm64/kvm/nested.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index d4c9a9b05e3f..94df26de6990 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1491,8 +1491,8 @@ int kvm_handle_vncr_abort(struct kvm_vcpu *vcpu)
 		return kvm_handle_guest_sea(vcpu);
 
 	if (!esr_fsc_is_translation_fault(esr) && !esr_fsc_is_permission_fault(esr)) {
-		WARN_ONCE(1, "Unhandled VNCR abort, ESR=%llx\n", esr);
-		return 1;
+		KVM_BUG(1, vcpu->kvm, "Unhandled VNCR abort, ESR=%llx\n", esr);
+		return -EIO;
 	}
 
 	ret = kvm_translate_vncr(vcpu, &is_gmem);
-- 
2.47.3

