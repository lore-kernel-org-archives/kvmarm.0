Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28AE04EA376;
	Wed, 13 May 2026 13:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778678545; cv=none; b=nmFqekLvAm7/vIrOly6PJsRq6/+IwpJzB4yXaFe59vpTbPJshujB2CWF0NlF8ZtSnkP273nlObGfg3BZqkLkR3/nWf0TXFXHrTIzcL+a9X34BQevEO2Y3OR5eoEvCFjoFq0TMWruf1/GFXtd9kPbBXLgO+P1QQmAbYLix0DWzmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778678545; c=relaxed/simple;
	bh=eok25BDeoLj6gOHUD3x6S8D2ek6b9vtNLxIxndavmhE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jqZSV+oD7fdoiackKChRpw/7KqUPk6s4TZz1+/e/CGhZgDnenqK2EvkbV3wYgYKhIBk9ww7w+M5NNmY6z0YHwMZdXo1XU/Yq8MAN3DM/15QMRHlx9OMYHJgZ8J4iGcGkrDw2kxmgGssS5yTI255TRe/Fo5h/o0otbC4Jgj/mccg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=SHPTvQLJ; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="SHPTvQLJ"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4DD351596;
	Wed, 13 May 2026 06:22:18 -0700 (PDT)
Received: from e122027.arm.com (unknown [10.57.68.187])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 623273F836;
	Wed, 13 May 2026 06:22:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1778678543; bh=eok25BDeoLj6gOHUD3x6S8D2ek6b9vtNLxIxndavmhE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SHPTvQLJ03T34H/be+unDmG/7vXC1BPvAtsdoh+ECoI43ruDRV0mO1hw7fl2im0aE
	 YpU2rTihIIxbz0l4ufOZuPFnR3+hdYGXqErQAsbrNF0/cJH335KZHY/w8VNJNkgZ7B
	 A+QJC7QdvbyUKjMe62dFGUu715HYRAJ24Y8TIcTA=
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
	Lorenzo.Pieralisi2@arm.com
Subject: [PATCH v14 44/44] arm64: RMI: Enable realms to be created
Date: Wed, 13 May 2026 14:17:52 +0100
Message-ID: <20260513131757.116630-45-steven.price@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260513131757.116630-1-steven.price@arm.com>
References: <20260513131757.116630-1-steven.price@arm.com>
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
index 732cecb11355..67c1d1526b07 100644
--- a/arch/arm64/kvm/rmi.c
+++ b/arch/arm64/kvm/rmi.c
@@ -1396,5 +1396,6 @@ void kvm_init_rmi(void)
 	if (rmm_check_features())
 		return;
 
-	/* Future patch will enable static branch kvm_rmi_is_available */
+	kvm_info("Realm guests supported");
+	static_branch_enable(&kvm_rmi_is_available);
 }
-- 
2.43.0

