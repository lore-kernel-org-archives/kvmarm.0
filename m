From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 6/8] KVM: arm/arm64: vgic-its: Fix
 vgic_its_restore_collection_table returned value
Date: Mon, 30 Oct 2017 03:56:01 +0100
Message-ID: <20171030025603.23550-7-christoffer.dall@linaro.org>
References: <20171030025603.23550-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9AA3649D2A
 for <kvmarm@lists.cs.columbia.edu>; Sun, 29 Oct 2017 22:54:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LoowDZMa3pJ4 for <kvmarm@lists.cs.columbia.edu>;
 Sun, 29 Oct 2017 22:54:46 -0400 (EDT)
Received: from mail-wm0-f66.google.com (mail-wm0-f66.google.com [74.125.82.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C727A49D68
 for <kvmarm@lists.cs.columbia.edu>; Sun, 29 Oct 2017 22:54:45 -0400 (EDT)
Received: by mail-wm0-f66.google.com with SMTP id p75so12932857wmg.3
 for <kvmarm@lists.cs.columbia.edu>; Sun, 29 Oct 2017 19:56:17 -0700 (PDT)
In-Reply-To: <20171030025603.23550-1-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

From: Eric Auger <eric.auger@redhat.com>

vgic_its_restore_cte returns +1 if the collection table entry
is valid and properly decoded. As a consequence, if the
collection table is fully filled with valid data that are
decoded without error, vgic_its_restore_collection_table()
returns +1. This is wrong.

Let's return 0 in that case.

Fixes: ea1ad53e1e31a3 (KVM: arm64: vgic-its: Collection table save/restore)
Signed-off-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 virt/kvm/arm/vgic/vgic-its.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 76685f4c6261..6a715a6ec64e 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -2264,6 +2264,10 @@ static int vgic_its_restore_collection_table(struct vgic_its *its)
 		gpa += cte_esz;
 		read += cte_esz;
 	}
+
+	if (ret > 0)
+		return 0;
+
 	return ret;
 }
 
-- 
2.14.2
