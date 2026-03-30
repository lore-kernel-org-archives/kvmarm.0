Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ED7B3242BD
	for <kvmarm@lists.linux.dev>; Mon, 30 Mar 2026 14:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774882257; cv=none; b=RmnUsyWmgBh35qFbsBVWPXMkIO8C9oBka+eQubjc2KMA9SMH0mLKJuCw02mEYVM8FRBP2TpKwrtZxHTSrnE1fWY/89NMwdqwlYKmQ+BKcgAHtrP7w9kQy5tEHi7x2Bt1gPYxML40uGVnli0oim+QFFOZH5+fJ+ISbaAyC2d0ICE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774882257; c=relaxed/simple;
	bh=be2pSVdKYs2XTtccvYTydqz5T0J6rzFdyQOTW0pLEsY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s52DEhF3oZ0ot+jXC9vRG+nyMGOIKwIFEtg89T1sFPw5hi62hfXKZtz5oOtI4PEnb3CCiEc8G+ADRB2GlY0UVyX/3KlvwjzWoMZXPZS3KyjkrLJ/xYL2IlQ8IQdkvrDmAInVGnrGudcDX5GGSNOC7bhqcvA484/UQlSw1AXpaB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oyg9MfE+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oyg9MfE+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64877C19423;
	Mon, 30 Mar 2026 14:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774882257;
	bh=be2pSVdKYs2XTtccvYTydqz5T0J6rzFdyQOTW0pLEsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oyg9MfE+vcunsCwkvYXhi6h3LKwmFgkF7BoB+L+mzyJr6qgP0THDfAxmgBJw9hYWI
	 okQ58i3nQKTMMgjc364xxb9B1Gm5vm204rvSRjo9jqdTGiohRIXyHvIcxCt0a1n4IO
	 pE4Sj+0HPeITJIGi4o3oXrtD8DEbGwcGpdEASVCQCsTeVzTqMkL10Twaik1cF0dyLZ
	 TbYnolXBHeZY/JlHcKOJ+RKndhbllPLdFU/sn6fuM5nduqeYztHWxCkyaqGVzvSFgL
	 29+7CIoP2E6uPJHOQavK2/RhLZDfQj9samhpqcPESG1WGL9EhPrYGyKPTD8sbHRT7y
	 G4cg7Z/wvTSLA==
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
Subject: [PATCH v5 38/38] drivers/virt: pkvm: Add Kconfig dependency on DMA_RESTRICTED_POOL
Date: Mon, 30 Mar 2026 15:48:39 +0100
Message-ID: <20260330144841.26181-39-will@kernel.org>
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

pKVM guests practically rely on CONFIG_DMA_RESTRICTED_POOL=y in order
to establish shared memory regions with the host for virtio buffers.

Make CONFIG_ARM_PKVM_GUEST depend on CONFIG_DMA_RESTRICTED_POOL to avoid
the inevitable segmentation faults experience if you have the former but
not the latter.

Reported-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Will Deacon <will@kernel.org>
---
 drivers/virt/coco/pkvm-guest/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/virt/coco/pkvm-guest/Kconfig b/drivers/virt/coco/pkvm-guest/Kconfig
index d2f344f1f98f..928b8e1668cc 100644
--- a/drivers/virt/coco/pkvm-guest/Kconfig
+++ b/drivers/virt/coco/pkvm-guest/Kconfig
@@ -1,6 +1,6 @@
 config ARM_PKVM_GUEST
 	bool "Arm pKVM protected guest driver"
-	depends on ARM64
+	depends on ARM64 && DMA_RESTRICTED_POOL
 	help
 	  Protected guests running under the pKVM hypervisor on arm64
 	  are isolated from the host and must issue hypercalls to enable
-- 
2.53.0.1018.g2bb0e51243-goog

