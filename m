From: Eric Auger <eric.auger@linaro.org>
Subject: [RFC v2 1/4] linux-headers: Update KVM header for KVM-VFIO
 FORWARD/UNFORWARD
Date: Mon,  4 May 2015 13:49:55 +0100
Message-ID: <1430743798-8839-2-git-send-email-eric.auger@linaro.org>
References: <1430743798-8839-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 449CD4F787
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 May 2015 08:41:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YtUqqcfgaMH4 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 May 2015 08:41:25 -0400 (EDT)
Received: from mail-wi0-f180.google.com (mail-wi0-f180.google.com
 [209.85.212.180])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 184DC4F786
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 May 2015 08:41:24 -0400 (EDT)
Received: by widdi4 with SMTP id di4so120155418wid.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 04 May 2015 05:50:06 -0700 (PDT)
In-Reply-To: <1430743798-8839-1-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, eric.auger@linaro.org, qemu-devel@nongnu.org, alex.williamson@redhat.com
Cc: kvmarm@lists.cs.columbia.edu, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

Integrate updated KVM-VFIO API related to forwarded IRQ

Update the kvm header according to the header found in
http://git.linaro.org/people/eric.auger/linux.git
branch 4.1-rc1_forward

Signed-off-by: Eric Auger <eric.auger@linaro.org>
---
 linux-headers/linux/kvm.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/linux-headers/linux/kvm.h b/linux-headers/linux/kvm.h
index b96d978..95fea92 100644
--- a/linux-headers/linux/kvm.h
+++ b/linux-headers/linux/kvm.h
@@ -999,6 +999,9 @@ struct kvm_device_attr {
 #define  KVM_DEV_VFIO_GROUP			1
 #define   KVM_DEV_VFIO_GROUP_ADD			1
 #define   KVM_DEV_VFIO_GROUP_DEL			2
+#define  KVM_DEV_VFIO_DEVICE			2
+#define   KVM_DEV_VFIO_DEVICE_FORWARD_IRQ			1
+#define   KVM_DEV_VFIO_DEVICE_UNFORWARD_IRQ			2
 
 enum kvm_device_type {
 	KVM_DEV_TYPE_FSL_MPIC_20	= 1,
@@ -1018,6 +1021,15 @@ enum kvm_device_type {
 	KVM_DEV_TYPE_MAX,
 };
 
+struct kvm_vfio_dev_irq {
+	__u32	argsz;		/* structure length */
+	__u32	fd;		/* file descriptor of the VFIO device */
+	__u32	index;		/* VFIO device IRQ index */
+	__u32	start;		/* start of subindex range */
+	__u32	count;		/* size of subindex range */
+	__u32	gsi[];		/* gsi, ie. virtual IRQ number */
+};
+
 /*
  * ioctls for VM fds
  */
-- 
1.8.3.2
