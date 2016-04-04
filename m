From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH v4 2/7] KVM: kvm_host: add devid in
 kvm_kernel_irq_routing_entry
Date: Mon,  4 Apr 2016 10:47:32 +0200
Message-ID: <1459759657-7402-3-git-send-email-eric.auger@linaro.org>
References: <1459759657-7402-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E498E407A5
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Apr 2016 04:47:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EleYzauXBXzp for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Apr 2016 04:47:46 -0400 (EDT)
Received: from mail-lb0-f175.google.com (mail-lb0-f175.google.com
 [209.85.217.175])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E274F411BE
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Apr 2016 04:47:45 -0400 (EDT)
Received: by mail-lb0-f175.google.com with SMTP id vo2so150137840lbb.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 04 Apr 2016 01:49:01 -0700 (PDT)
In-Reply-To: <1459759657-7402-1-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, eric.auger@linaro.org, christoffer.dall@linaro.org, marc.zyngier@arm.com, andre.przywara@arm.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: pbonzini@redhat.com, Manish.Jaggi@caviumnetworks.com, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

Extend kvm_kernel_irq_routing_entry to transport the device id
field, devid. A new flags field makes possible to indicate the
devid is valid. Those additions are used for ARM GICv3 ITS MSI
injection.

Signed-off-by: Eric Auger <eric.auger@linaro.org>

---
v2 -> v3:
- add flags

v1 -> v2:
- replace msi_msg field by a struct composed of msi_msg and devid

RFC -> PATCH:
- reword the commit message after change in first patch (uapi)
---
 include/linux/kvm_host.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 861f690..461e480 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -309,7 +309,11 @@ struct kvm_kernel_irq_routing_entry {
 			unsigned irqchip;
 			unsigned pin;
 		} irqchip;
-		struct msi_msg msi;
+		struct {
+			struct msi_msg msi;
+			u32 flags;
+			u32 devid;
+		};
 		struct kvm_s390_adapter_int adapter;
 		struct kvm_hv_sint hv_sint;
 	};
-- 
1.9.1
