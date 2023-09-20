Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70BDA3CCFC
	for <kvmarm@lists.linux.dev>; Wed, 20 Sep 2023 18:17:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 483EEC433C8;
	Wed, 20 Sep 2023 18:17:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1695233861;
	bh=BhrGPjTzb1HfZms6GPV9c/Mt5fFofX2+GjOb7zqmwKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qV24xbPWZxDb4nvt2qzscOXLlLVm7+emVDxxk/BJExwCk4tbk5Fqum8vcQ03IgD2o
	 rBBxHFqnpLvTHBf6qC+Q0CLpG4aTbaVgl+6ylqE/YeoqbdnwdJFaqByhFuCw/04k9D
	 YiQ8FOzsdLsVvHqDgaPp7fUVfC5cam+3bTVDnJX5tNStu167diiAawsTMKK7wlYpA0
	 cEEAFUYyaiSnwbuDDG8eWeUpT3prpB/qca6wWwH8c6e/YdxGVi4V3AqE7JhEXATsx0
	 BqNc0YAxB0f2stRy7PxXQEVA1AT6a++RUJvPQ5rkWqiuuqM8sd5BuLNmx72+BJrVaj
	 ob7i0uHTDp9Vg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1qj1lb-00Ejx0-EI;
	Wed, 20 Sep 2023 19:17:39 +0100
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
Subject: [PATCH v2 11/11] KVM: arm64: Clarify the ordering requirements for vcpu/RD creation
Date: Wed, 20 Sep 2023 19:17:31 +0100
Message-Id: <20230920181731.2232453-12-maz@kernel.org>
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

It goes without saying, but it is probably better to spell it out:

If userspace tries to restore and VM, but creates vcpus and/or RDs
in a different order, the vcpu/RD mapping will be different. Yes,
our API is an ugly piece of crap and I can't believe that we missed
this.

If we want to relax the above, we'll need to define a new userspace
API that allows the mapping to be specified, rather than relying
on the kernel to perform the mapping on its own.

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

