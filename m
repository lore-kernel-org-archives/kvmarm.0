From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH 1/2] KVM: PPC: Move xics_debugfs_init out of create
Date: Tue,  9 Aug 2016 14:20:34 +0200
Message-ID: <20160809122035.16196-2-christoffer.dall@linaro.org>
References: <20160809122035.16196-1-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20160809122035.16196-1-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: kvm@vger.kernel.org
Cc: Andre Przywara <andre.przywara@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, Alexander Graf <agraf@suse.de>, borntraeger@de.ibm.com, paulus@ozlabs.org, kvmarm@lists.cs.columbia.edu, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

As we are about to hold the kvm->lock during the create operation on KVM
devices, we should move the call to xics_debugfs_init into its own
function, since holding a mutex over extended amounts of time might not
be a good idea.

Introduce an init operation on the kvm_device_ops struct which cannot
fail and call this, if configured, after the device has been created.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/powerpc/kvm/book3s_xics.c | 10 ++++++++--
 include/linux/kvm_host.h       |  6 ++++++
 virt/kvm/kvm_main.c            |  3 +++
 3 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_xics.c b/arch/powerpc/kvm/book3s_xics.c
index a75ba38..f2def8e 100644
--- a/arch/powerpc/kvm/book3s_xics.c
+++ b/arch/powerpc/kvm/book3s_xics.c
@@ -1341,8 +1341,6 @@ static int kvmppc_xics_create(struct kvm_device *dev, u32 type)
 		return ret;
 	}
 
-	xics_debugfs_init(xics);
-
 #ifdef CONFIG_KVM_BOOK3S_HV_POSSIBLE
 	if (cpu_has_feature(CPU_FTR_ARCH_206)) {
 		/* Enable real mode support */
@@ -1354,9 +1352,17 @@ static int kvmppc_xics_create(struct kvm_device *dev, u32 type)
 	return 0;
 }
 
+static void kvmppc_xics_init(struct kvm_device *dev)
+{
+	struct kvmppc_xics *xics = (struct kvmppc_xics *)dev->private;
+
+	xics_debugfs_init(xics);
+}
+
 struct kvm_device_ops kvm_xics_ops = {
 	.name = "kvm-xics",
 	.create = kvmppc_xics_create,
+	.init = kvmppc_xics_init,
 	.destroy = kvmppc_xics_free,
 	.set_attr = xics_set_attr,
 	.get_attr = xics_get_attr,
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 01e908a..d3c9b82 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1116,6 +1116,12 @@ struct kvm_device_ops {
 	int (*create)(struct kvm_device *dev, u32 type);
 
 	/*
+	 * init is called after create if create is successful and is called
+	 * outside of holding kvm->lock.
+	 */
+	void (*init)(struct kvm_device *dev);
+
+	/*
 	 * Destroy is responsible for freeing dev.
 	 *
 	 * Destroy may be called before or after destructors are called
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index cc081cc..ae64245 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2838,6 +2838,9 @@ static int kvm_ioctl_create_device(struct kvm *kvm,
 		return ret;
 	}
 
+	if (ops->init)
+		ops->init(dev);
+
 	ret = anon_inode_getfd(ops->name, &kvm_device_fops, dev, O_RDWR | O_CLOEXEC);
 	if (ret < 0) {
 		ops->destroy(dev);
-- 
2.9.0

