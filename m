Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E30EB3CCF4
	for <kvmarm@lists.linux.dev>; Wed, 20 Sep 2023 18:17:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B06C4C433CC;
	Wed, 20 Sep 2023 18:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1695233859;
	bh=zwW05Zf90zWZaIrpGC3ZxgoZzeJfoKQB2bT853qaE2o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sZ2c2dIk7Md0Ddn7et6nW3tDk+3IQrr6mwsRlEkqMEYcRQtDgRoZ+IbsKATQba+iB
	 ZQuCaowoWczd2cMFqScTxI8KjdGgp6fqoiumt84yBzLwYzBuc4bKV7LmYC2/pRW+pr
	 rskzpMGYO7bnXZQl97kx51mlzlkJ9pC1dUAvDAJs5iNS+bfiSp0Oji6sI4E/cqvTnw
	 4pP3Ru/SqgEe2zmJMINVXiP+3zsweQ7uiX9U1stqY1m//mzaI1OQsXE3e6yxBSzM+q
	 +nYgshBJbqCbNDYyVJ0bBrQfvV/CXjJmqz0bdJb3owCyU+t0Vx3eUU3byNM2Q+MIgr
	 XY6knIgAnAoKw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1qj1lZ-00Ejx0-Li;
	Wed, 20 Sep 2023 19:17:37 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Xu Zhao <zhaoxu.35@bytedance.com>,
	Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v2 04/11] KVM: arm64: vgic-v2: Use cpuid from userspace as vcpu_id
Date: Wed, 20 Sep 2023 19:17:24 +0100
Message-Id: <20230920181731.2232453-5-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230920181731.2232453-1-maz@kernel.org>
References: <20230920181731.2232453-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com, shameerali.kolothum.thodi@huawei.com, zhaoxu.35@bytedance.com, eric.auger@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-kvm-device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vgic-kvm-device.c
index 212b73a715c1..82b264ad68c4 100644
--- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
+++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
@@ -345,7 +345,7 @@ int vgic_v2_parse_attr(struct kvm_device *dev, struct kvm_device_attr *attr,
 	if (cpuid >= atomic_read(&dev->kvm->online_vcpus))
 		return -EINVAL;
 
-	reg_attr->vcpu = kvm_get_vcpu(dev->kvm, cpuid);
+	reg_attr->vcpu = kvm_get_vcpu_by_id(dev->kvm, cpuid);
 	reg_attr->addr = attr->attr & KVM_DEV_ARM_VGIC_OFFSET_MASK;
 
 	return 0;
-- 
2.34.1

