Received: from zg8tmja5ljk3lje4ms43mwaa.icoremail.net (zg8tmja5ljk3lje4ms43mwaa.icoremail.net [209.97.181.73])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 722A21F8672
	for <kvmarm@lists.linux.dev>; Wed,  8 Jan 2025 10:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.97.181.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736332779; cv=none; b=B4k6v4J7Nd3bp3Zun37o6PBzy3GOGUuyi51nRPo02pAL4WoW4NY1QbHxE22ZKPkb3Si7fWxbYa4TxOvp9JhAWkWle3s5V8Vrmw278PwAJ28UWoX25JZXnGex9eGSHh3K5Py/rmV6BL6Glqdft6EaLYDT5VjRK5yR9rL7m0o71d4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736332779; c=relaxed/simple;
	bh=acjrDcMoWJ6xJU2TZ8b9tLNtluFVD24/dSWz3yTk7Ak=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=a05U9UmNIQHWeO1yaxDslciX4nbW8Whw2YHtMjK82KISQLGGpz6EH2zYbW5TzhFEnWmarGlli8T5BsTZp6RK4F6FiQGKgT80CmXBYTZBt7/DOj6l3VbFxJPfF4uZQP79WJfgkIv+R5GsGPMjxosr8zbU3UbE56H0+JwifED8qbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=phytium.com.cn; spf=pass smtp.mailfrom=phytium.com.cn; arc=none smtp.client-ip=209.97.181.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=phytium.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=phytium.com.cn
Received: from prodtpl.icoremail.net (unknown [10.12.1.20])
	by hzbj-icmmx-7 (Coremail) with SMTP id AQAAfwD3_mrcVX5nRLpJAA--.29104S2;
	Wed, 08 Jan 2025 18:39:24 +0800 (CST)
Received: from localhost.localdomain (unknown [219.142.137.151])
	by mail (Coremail) with SMTP id AQAAfwCXs6nZVX5nWEsHAA--.11445S3;
	Wed, 08 Jan 2025 18:39:23 +0800 (CST)
From: Zhiyuan Dai <daizhiyuan@phytium.com.cn>
To: maz@kernel.org,
	oliver.upton@linux.dev,
	catalin.marinas@arm.com
Cc: joey.gouly@arm.com,
	uzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Zhiyuan Dai <daizhiyuan@phytium.com.cn>
Subject: [PATCH] KVM: arm64: vgic: Update some comments to improve the code readability
Date: Wed,  8 Jan 2025 18:39:19 +0800
Message-ID: <20250108103919.66572-1-daizhiyuan@phytium.com.cn>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAfwCXs6nZVX5nWEsHAA--.11445S3
X-CM-SenderInfo: hgdl6xpl1xt0o6sk53xlxphulrpou0/
Authentication-Results: hzbj-icmmx-7; spf=neutral smtp.mail=daizhiyuan
	@phytium.com.cn;
X-Coremail-Antispam: 1Uk129KBjvdXoWrtw4kuFy7JFW7urykGw1ftFb_yoWDJFb_Z3
	4Iqw43XayvkF12qFWq93y3u34Ig3yUJry5Wr1rZFWUJa4DZr45KF4DXF43Wr45XrWYgrsx
	KrZxC3yfAr1xWjkaLaAFLSUrUUUU8b8apTn2vfkv8UJUUUU8wcxFpf9Il3svdxBIdaVrnU
	Uv73VFW2AGmfu7jjvjm3AaLaJ3UjIYCTnIWjDUYxBIdaVFxhVjvjDU0xZFpf9x0zRUUUUU
	UUUU=

This patch updates the comments in the vgic_v3_queue_sgi function
to improve the readability of the code.

Signed-off-by: Zhiyuan Dai <daizhiyuan@phytium.com.cn>
---
 arch/arm64/kvm/vgic/vgic-mmio-v3.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
index ae4c0593d114..f3b328373869 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
@@ -1040,8 +1040,13 @@ static void vgic_v3_queue_sgi(struct kvm_vcpu *vcpu, u32 sgi, bool allow_group1)
 			irq->pending_latch = true;
 			vgic_queue_irq_unlock(vcpu->kvm, irq, flags);
 		} else {
-			/* HW SGI? Ask the GIC to inject it */
 			int err;
+
+			/*
+                        * With GICv4.1, vSGI can be directly injected.
+                        * So let's pretend that they are HW interrupts,
+                        * tied to a host IRQ.
+                        */
 			err = irq_set_irqchip_state(irq->host_irq,
 						    IRQCHIP_STATE_PENDING,
 						    true);
-- 
2.25.1

