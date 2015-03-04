From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH v9 2/5] KVM: introduce kvm_arch_intc_initialized and use it in
 irqfd
Date: Wed,  4 Mar 2015 11:14:33 +0100
Message-ID: <1425464076-20558-3-git-send-email-eric.auger@linaro.org>
References: <1425464076-20558-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9DFC047932
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Mar 2015 05:11:18 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id j7WtJIcYXykB for <kvmarm@lists.cs.columbia.edu>;
 Wed,  4 Mar 2015 05:11:17 -0500 (EST)
Received: from mail-wi0-f169.google.com (mail-wi0-f169.google.com
 [209.85.212.169])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 776474795D
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Mar 2015 05:11:17 -0500 (EST)
Received: by wiwh11 with SMTP id h11so29449721wiw.3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 04 Mar 2015 02:17:18 -0800 (PST)
In-Reply-To: <1425464076-20558-1-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, eric.auger@linaro.org, christoffer.dall@linaro.org, marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: gleb@kernel.org, andre.przywara@arm.com, pbonzini@redhat.com, linux-kernel@vger.kernel.org, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

Introduce __KVM_HAVE_ARCH_INTC_INITIALIZED define and
associated kvm_arch_intc_initialized function. This latter
allows to test whether the virtual interrupt controller is initialized
and ready to accept virtual IRQ injection. On some architectures,
the virtual interrupt controller is dynamically instantiated, justifying
that kind of check.

The new function can now be used by irqfd to check whether the
virtual interrupt controller is ready on KVM_IRQFD request. If not,
KVM_IRQFD returns -EAGAIN.

Signed-off-by: Eric Auger <eric.auger@linaro.org>
Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
Reviewed-by: Andre Przywara <andre.przywara@arm.com>

---
v7 -> v8:
- correct typo in comment
- add Andre's Reviewed-by

v6 -> v7:
- From now on, kvm_irqfd_assign calls kvm_arch_intc_initialized
  (previously introduced in subsequent patch file).
- add Christoffer's ack

v5 -> v6:
- rename function name and macro
- add kvm_arch_intc_initialized declaration in case the archi defines
  the macro
---
 include/linux/kvm_host.h | 14 ++++++++++++++
 virt/kvm/eventfd.c       |  3 +++
 2 files changed, 17 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index d12b210..ae9c720 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -700,6 +700,20 @@ static inline wait_queue_head_t *kvm_arch_vcpu_wq(struct kvm_vcpu *vcpu)
 #endif
 }
 
+#ifdef __KVM_HAVE_ARCH_INTC_INITIALIZED
+/*
+ * returns true if the virtual interrupt controller is initialized and
+ * ready to accept virtual IRQ. On some architectures the virtual interrupt
+ * controller is dynamically instantiated and this is not always true.
+ */
+bool kvm_arch_intc_initialized(struct kvm *kvm);
+#else
+static inline bool kvm_arch_intc_initialized(struct kvm *kvm)
+{
+	return true;
+}
+#endif
+
 int kvm_arch_init_vm(struct kvm *kvm, unsigned long type);
 void kvm_arch_destroy_vm(struct kvm *kvm);
 void kvm_arch_sync_events(struct kvm *kvm);
diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index 148b239..fc5f43e 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -311,6 +311,9 @@ kvm_irqfd_assign(struct kvm *kvm, struct kvm_irqfd *args)
 	unsigned int events;
 	int idx;
 
+	if (!kvm_arch_intc_initialized(kvm))
+		return -EAGAIN;
+
 	irqfd = kzalloc(sizeof(*irqfd), GFP_KERNEL);
 	if (!irqfd)
 		return -ENOMEM;
-- 
1.9.1
