Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 001614A13AA;
	Wed, 15 Jul 2026 14:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784125919; cv=none; b=RUFm9IdZwTiN0IdC9lV3ay8dY+oVBBeS4Oawyn+aspxdlCdfLQLo/P9wTYYv9iEHyQrfauNH10Yv3HfQV63hnH+oHEn2T37IKKnWJz0lRq6d6Gb20bK/pum8WOWtOwB1VhaqS9c/x7bCT6RNGmHNvVSA3EZmqJLyQYAlQE4XmiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784125919; c=relaxed/simple;
	bh=hTHvGHo3aq13/0hCdni+YB/1LbAGuEZAjUd+4tZoURQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iovo207IGyZTK4gzgTTJXh8Es/3I3bB9+GvsciMOnpMjppMRazUqSySDnlyRcVMkTUGQW8BANOHyujVf/b019I4g1IhC1dvV/fNlO9KxHaqcB/U1Bp/r7ZVi2p+sxwzWenVTqd9mhRz/T/DuUHIK+fRq8s6chcgDCGL0D+EeQPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=AR2vGpGk; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="AR2vGpGk"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4133D1576;
	Wed, 15 Jul 2026 07:31:46 -0700 (PDT)
Received: from e122027.cambridge.arm.com (e122027.cambridge.arm.com [10.1.25.27])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4B4FA3F7B4;
	Wed, 15 Jul 2026 07:31:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784125910; bh=hTHvGHo3aq13/0hCdni+YB/1LbAGuEZAjUd+4tZoURQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AR2vGpGk/pJKe3cSknWcS3UCEVyGMxAWtRMINXoVYuQ5KnoUiu3HircLCLB7+QqRS
	 l3NnR1yUEHGBt1G8I6z0uTusataDJtdw1V5AnjVcCS7dcysd+dq64vL73OVK3VSJOu
	 RelST7tzou4LH3wGD49r4zLAwVpDqy0yuTwKEPTQ=
From: Steven Price <steven.price@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: Steven Price <steven.price@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>,
	linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Gavin Shan <gshan@redhat.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
	Emi Kisanuki <fj0570is@fujitsu.com>,
	Vishal Annapurve <vannapurve@google.com>,
	WeiLin.Chang@arm.com,
	Lorenzo Pieralisi <lpieralisi@kernel.org>
Subject: [PATCH v15 37/37] KVM: arm64: CCA: Enable realms to be created
Date: Wed, 15 Jul 2026 15:28:39 +0100
Message-ID: <20260715142841.80544-38-steven.price@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260715142841.80544-1-steven.price@arm.com>
References: <20260715142841.80544-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

All the pieces are now in place, so enable kvm_rmi_is_available when the
RMM is detected.

Signed-off-by: Steven Price <steven.price@arm.com>
---
 arch/arm64/kvm/rmi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
index 3f1c6351b71a..06cc85fb5092 100644
--- a/arch/arm64/kvm/rmi.c
+++ b/arch/arm64/kvm/rmi.c
@@ -1518,5 +1518,6 @@ void kvm_init_rmi(void)
 	if (rmm_check_features())
 		return;
 
-	/* Future patch will enable static branch kvm_rmi_is_available */
+	kvm_info("Realm guests supported\n");
+	static_branch_enable(&kvm_rmi_is_available);
 }
-- 
2.43.0

