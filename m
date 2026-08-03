Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52F8541378D;
	Mon,  3 Aug 2026 13:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785764873; cv=none; b=OaoMWGriEDT1M9wP4kc9SI9IzIBoRopbjLBeLEG73YbBDicfE3O6ZHPs7rb77z8jR1wo0Rd/QPIj01gZ9dLlnPm+ZGESVhp7mohLv9fJ3Y9g9KIQBNeUgaTB7XIJNz1TEFg3iFEGWYzWa5Oi7JIW0J91KEV/2cmmACCOjKVis+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785764873; c=relaxed/simple;
	bh=QnE3jwjHNmpdPreZ13KHzHAPGae+2/Nd+IwbjiYeo94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZQ9DB/MhTcGUilAKBzJ8rzWZ+wunxPPELJdfsC9mPsqP0gP2Ju7NOvi4qNNZBiVNEWkyzIWnA4UoLL4MvuaIyhGilF6cSdn47e2pOv8i+/XHNFUdttAyS7WUcFcDlXfVduYH2tOMl1M9lh2AOqd2vIuVb5wAFBlJNgw6pJZ9Krk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Cf9Ke1ba; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Cf9Ke1ba"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C59B91476;
	Mon,  3 Aug 2026 06:47:47 -0700 (PDT)
Received: from e122027.cambridge.arm.com (e122027.cambridge.arm.com [10.1.25.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id ED9273F66F;
	Mon,  3 Aug 2026 06:47:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785764871; bh=QnE3jwjHNmpdPreZ13KHzHAPGae+2/Nd+IwbjiYeo94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cf9Ke1bagJBW0N8q+wEcwjaspUtxNKe+/HsAhtisu5RMDOw2ZUFrvOQLNS/Bhu5My
	 Z7vabVyu/g5HFt88pDKF+y9uk8xMYmHx8UjononARJkoZfwedm+mHbKeKld8quc6WZ
	 PsbeRh759wKxW22DoIhydh7YB7pqO2Or8O++qP8Q=
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
Subject: [PATCH v16 45/45] KVM: arm64: CCA: Enable realms to be created
Date: Mon,  3 Aug 2026 14:44:01 +0100
Message-ID: <20260803134403.80630-46-steven.price@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260803134403.80630-1-steven.price@arm.com>
References: <20260803134403.80630-1-steven.price@arm.com>
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
index 0f66a0e970cd..c242dfc2c7a6 100644
--- a/arch/arm64/kvm/rmi.c
+++ b/arch/arm64/kvm/rmi.c
@@ -1556,5 +1556,6 @@ void kvm_init_rmi(void)
 	if (rmm_check_features())
 		return;
 
-	/* Future patch will enable static branch kvm_rmi_is_available */
+	kvm_info("Realm guests supported\n");
+	static_branch_enable(&kvm_rmi_is_available);
 }
-- 
2.43.0

