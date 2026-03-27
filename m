Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 631F6227599
	for <kvmarm@lists.linux.dev>; Fri, 27 Mar 2026 14:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774620176; cv=none; b=C96xFu2OMjWx8yHu5xvrfTnODkUcb1FnunlqeZd5C940IBDQhUwPui6ECXzHgtqLmhPhuIoahrFiVpg+1QTIX6EGdVKFzaEeAFv1Es0fXsgxHmDTVKBcCk7twF462pVUJfnmk+9HCur8pR1U2woTWDg6vdmbFvDrFeke6d4Y2Bk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774620176; c=relaxed/simple;
	bh=be2pSVdKYs2XTtccvYTydqz5T0J6rzFdyQOTW0pLEsY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MU33FmsYXohASuMZdyxcDQtlLHOeLpnTDtxy41hP5LT72pa54JiRMT21roP2BVByhIKdX+2AFZJ6mdoHDhhMC6Ku1vVN+yjjbc7LGaEClTjjjDA+p6g8x0n7WBvbBcgBjixXjeK+Ls1ZPi+E/pTRTPuzjht6ndIpJyLIUBLBjl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rM+S9W/t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rM+S9W/t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5826CC19423;
	Fri, 27 Mar 2026 14:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774620176;
	bh=be2pSVdKYs2XTtccvYTydqz5T0J6rzFdyQOTW0pLEsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rM+S9W/tuRvb49c7BWCDLqctBJVkG6x3Rqu7RZ6S1RkyEF6i9xr/aZLoqvQ8uaL03
	 iqpS+QZluJYiuIXV7f0ljEE3GHEXcFsUDE0AaeFqy4Xt0+885WI5W0Ob9ptNepEmbo
	 liFiT+uUIiwNo3faRMQTvJAAW8K4/IjxX+0N9hp7otssMqPp1lYJFaCsbd9s6w1HS9
	 ERWNIUdlJmtt3TXcEmKGAkbF2Rwzn+28zrd1F1taFzsClWdVchdE/8w+xeSJa1qddA
	 d/KAAufqvZJukOxQEgmt0jmJWO7UifVtrA8K2oDUPA7LGEY5uKfN2xHZyGAduFHOA9
	 fY3VrYssZWg0Q==
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
Subject: [PATCH v4 38/38] drivers/virt: pkvm: Add Kconfig dependency on DMA_RESTRICTED_POOL
Date: Fri, 27 Mar 2026 14:00:37 +0000
Message-ID: <20260327140039.21228-39-will@kernel.org>
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

