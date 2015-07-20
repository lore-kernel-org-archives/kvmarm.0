From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH 09/14] add kvm__check_vm_capability
Date: Mon, 20 Jul 2015 14:02:11 +0100
Message-ID: <1437397336-21385-10-git-send-email-andre.przywara@arm.com>
References: <1437397336-21385-1-git-send-email-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1437397336-21385-1-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: will.deacon@arm.com, marc.zyngier@arm.com
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, eric.auger@linaro.org, Pavel Fedin <p.fedin@samsung.com>
List-Id: kvmarm@lists.cs.columbia.edu

KVM capabilities can be per-VM, in this case the ioctl should be
issued on the VM file descriptor, not on the system fd.
Since this feature is guarded by a (system) capability itself, wrap
the call into a function of its own.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 include/kvm/kvm.h |  1 +
 kvm.c             | 28 ++++++++++++++++++++++++++++
 2 files changed, 29 insertions(+)

diff --git a/include/kvm/kvm.h b/include/kvm/kvm.h
index 754e029..325e3b7 100644
--- a/include/kvm/kvm.h
+++ b/include/kvm/kvm.h
@@ -125,6 +125,7 @@ static inline bool host_ptr_in_ram(struct kvm *kvm, void *p)
 }
 
 bool kvm__supports_extension(struct kvm *kvm, unsigned int extension);
+bool kvm__supports_vm_extension(struct kvm *kvm, unsigned int extension);
 
 static inline void kvm__set_thread_name(const char *name)
 {
diff --git a/kvm.c b/kvm.c
index 78dd7c0..04327b9 100644
--- a/kvm.c
+++ b/kvm.c
@@ -93,6 +93,34 @@ const char *kvm__get_dir(void)
 	return kvm_dir;
 }
 
+bool kvm__supports_vm_extension(struct kvm *kvm, unsigned int extension)
+{
+	static int supports_vm_ext_check = 0;
+	int ret;
+
+	switch (supports_vm_ext_check) {
+	case 0:
+		ret = ioctl(kvm->sys_fd, KVM_CHECK_EXTENSION,
+			    KVM_CAP_CHECK_EXTENSION_VM);
+		if (ret <= 0) {
+			supports_vm_ext_check = -1;
+			return false;
+		}
+		supports_vm_ext_check = 1;
+		/* fall through */
+	case 1:
+		break;
+	case -1:
+		return false;
+	}
+
+	ret = ioctl(kvm->vm_fd, KVM_CHECK_EXTENSION, extension);
+	if (ret < 0)
+		return false;
+
+	return ret;
+}
+
 bool kvm__supports_extension(struct kvm *kvm, unsigned int extension)
 {
 	int ret;
-- 
2.3.5

