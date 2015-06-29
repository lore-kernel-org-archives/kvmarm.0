From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH 2/7] KVM: kvm_host: add kvm_extended_msi
Date: Mon, 29 Jun 2015 17:37:12 +0200
Message-ID: <1435592237-17924-3-git-send-email-eric.auger@linaro.org>
References: <1435592237-17924-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9385F569D9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Jun 2015 11:26:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OWwv4Z7okdml for <kvmarm@lists.cs.columbia.edu>;
 Mon, 29 Jun 2015 11:26:40 -0400 (EDT)
Received: from mail-wi0-f170.google.com (mail-wi0-f170.google.com
 [209.85.212.170])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C7B0E569D7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Jun 2015 11:26:40 -0400 (EDT)
Received: by wiar9 with SMTP id r9so8127121wia.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Jun 2015 08:37:50 -0700 (PDT)
In-Reply-To: <1435592237-17924-1-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, eric.auger@linaro.org, linux-arm-kernel@lists.infradead.org, marc.zyngier@arm.com, christoffer.dall@linaro.org, andre.przywara@arm.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: pbonzini@redhat.com, p.fedin@samsung.com, linux-kernel@vger.kernel.org, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

Add a new kvm_extended_msi struct to store the additional device ID
specific to ARM. kvm_kernel_irq_routing_entry union now encompasses
this new struct.

Signed-off-by: Eric Auger <eric.auger@linaro.org>

---

RFC -> PATCH:
- reword the commit message after change in first patch (uapi)
---
 include/linux/kvm_host.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index ad45054..e1c1c0d 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -304,6 +304,13 @@ struct kvm_s390_adapter_int {
 	u32 adapter_id;
 };
 
+struct kvm_extended_msi {
+	u32     address_lo;     /* low 32 bits of msi message address */
+	u32     address_hi;     /* high 32 bits of msi message address */
+	u32     data;           /* 16 bits of msi message data */
+	u32	devid;		/* out-of-band device ID */
+};
+
 struct kvm_kernel_irq_routing_entry {
 	u32 gsi;
 	u32 type;
@@ -317,6 +324,7 @@ struct kvm_kernel_irq_routing_entry {
 		} irqchip;
 		struct msi_msg msi;
 		struct kvm_s390_adapter_int adapter;
+		struct kvm_extended_msi ext_msi;
 	};
 	struct hlist_node link;
 };
-- 
1.9.1
