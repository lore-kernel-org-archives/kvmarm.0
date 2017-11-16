From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 4/7] KVM: arm/arm64: vgic-its: Check result of allocation
 before use
Date: Thu, 16 Nov 2017 17:58:18 +0000
Message-ID: <20171116175821.26544-5-marc.zyngier@arm.com>
References: <20171116175821.26544-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 474FA406D0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Nov 2017 12:56:22 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XJq9lo6aBE3m for <kvmarm@lists.cs.columbia.edu>;
 Thu, 16 Nov 2017 12:56:21 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 32E6F49D2A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Nov 2017 12:56:21 -0500 (EST)
In-Reply-To: <20171116175821.26544-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <cdall@linaro.org>
Cc: kvm@vger.kernel.org, Kristina Martsenko <kristina.martsenko@arm.com>, AKASHI Takahiro <takahiro.akashi@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

We miss a test against NULL after allocation.

Fixes: 6d03a68f8054 ("KVM: arm64: vgic-its: Turn device_id validation into generic ID validation")
Cc: stable@vger.kernel.org # 4.8
Reported-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic/vgic-its.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 370086006838..30f7c7e6d2f4 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -821,6 +821,8 @@ static int vgic_its_alloc_collection(struct vgic_its *its,
 		return E_ITS_MAPC_COLLECTION_OOR;
 
 	collection = kzalloc(sizeof(*collection), GFP_KERNEL);
+	if (!collection)
+		return -ENOMEM;
 
 	collection->collection_id = coll_id;
 	collection->target_addr = COLLECTION_NOT_MAPPED;
-- 
2.14.2
