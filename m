Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCF68208C3
	for <kvmarm@lists.linux.dev>; Wed, 27 Sep 2023 09:09:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2BBDC43395;
	Wed, 27 Sep 2023 09:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1695805760;
	bh=JypXsHJ4InnnDaRcHTXpCOmOh/qZk14zMN+csAv3sVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L0sOSEmCli0cv5bClWusW9jpAKHZEyVWze2Jj+KM4gc5M5ew3sgoPGWnK95US7FtV
	 wl98R6DE7BJNax8X9JpwkvzqB0MhoG+MU5qdjDAdjqVzlnZz7xU9ELRPzHhlFOJSpS
	 Gvgvv7nvXtCTibHiFR7URTIGzFK+uJxl2416Wd4gVAEZ4hYvvu4dxzoeDO52YVRtiA
	 FJxHpSiQnemXPvRn65IbInEnzBSPRGZxqy1ij5PjjSej7fHRDdorJjMFBHMs6eqKb0
	 B8sTbWFtQTHSoZmrLolKwkTKdaVV7uYza6fh96tv8c84Xmpv+kX7NpHEHCYm3q0FBp
	 xUqmwK0P44V2A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1qlQXm-00GaLb-ND;
	Wed, 27 Sep 2023 10:09:18 +0100
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
Subject: [PATCH v3 11/11] KVM: arm64: Clarify the ordering requirements for vcpu/RD creation
Date: Wed, 27 Sep 2023 10:09:11 +0100
Message-Id: <20230927090911.3355209-12-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230927090911.3355209-1-maz@kernel.org>
References: <20230927090911.3355209-1-maz@kernel.org>
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

It goes without saying, but it is probably better to spell it out:

If userspace tries to restore and VM, but creates vcpus and/or RDs
in a different order, the vcpu/RD mapping will be different. Yes,
our API is an ugly piece of crap and I can't believe that we missed
this.

If we want to relax the above, we'll need to define a new userspace
API that allows the mapping to be specified, rather than relying
on the kernel to perform the mapping on its own.

Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 Documentation/virt/kvm/devices/arm-vgic-v3.rst | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/virt/kvm/devices/arm-vgic-v3.rst b/Documentation/virt/kvm/devices/arm-vgic-v3.rst
index 51e5e5762571..5817edb4e046 100644
--- a/Documentation/virt/kvm/devices/arm-vgic-v3.rst
+++ b/Documentation/virt/kvm/devices/arm-vgic-v3.rst
@@ -59,6 +59,13 @@ Groups:
   It is invalid to mix calls with KVM_VGIC_V3_ADDR_TYPE_REDIST and
   KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION attributes.
 
+  Note that to obtain reproducible results (the same VCPU being associated
+  with the same redistributor across a save/restore operation), VCPU creation
+  order, redistributor region creation order as well as the respective
+  interleaves of VCPU and region creation MUST be preserved.  Any change in
+  either ordering may result in a different vcpu_id/redistributor association,
+  resulting in a VM that will fail to run at restore time.
+
   Errors:
 
     =======  =============================================================
-- 
2.34.1

