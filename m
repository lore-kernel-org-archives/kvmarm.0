From: Christoffer Dall <cdall@kernel.org>
Subject: [PULL 06/19] KVM: arm/arm64: vgic-its: Check result of allocation
 before use
Date: Mon,  4 Dec 2017 15:03:35 +0100
Message-ID: <20171204140348.21965-4-cdall@kernel.org>
References: <20171204135637.21620-1-cdall@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E36FC49D93
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Dec 2017 09:00:54 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Rd7RNKsx49LP for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Dec 2017 09:00:49 -0500 (EST)
Received: from mail-wr0-f193.google.com (mail-wr0-f193.google.com
 [209.85.128.193])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4067E49D35
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Dec 2017 09:00:49 -0500 (EST)
Received: by mail-wr0-f193.google.com with SMTP id v22so17414618wrb.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 04 Dec 2017 06:03:56 -0800 (PST)
In-Reply-To: <20171204135637.21620-1-cdall@kernel.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, stable@vger.kernel.org, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Marc Zyngier <marc.zyngier@arm.com>

We miss a test against NULL after allocation.

Fixes: 6d03a68f8054 ("KVM: arm64: vgic-its: Turn device_id validation into generic ID validation")
Cc: <stable@vger.kernel.org> # 4.8
Reported-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 virt/kvm/arm/vgic/vgic-its.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index cb2d0a2dbe5a..8e633bd9cc1e 100644
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
