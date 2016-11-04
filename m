From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v8 11/16] add kvm__check_vm_capability
Date: Fri,  4 Nov 2016 17:31:58 +0000
Message-ID: <20161104173203.21168-12-andre.przywara@arm.com>
References: <20161104173203.21168-1-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6CB9E4065B
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Nov 2016 13:31:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id n-RLW7rA4ywf for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 Nov 2016 13:31:38 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E5A1940460
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Nov 2016 13:31:36 -0400 (EDT)
In-Reply-To: <20161104173203.21168-1-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Will Deacon <will.deacon@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
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
index 4a76ec2..a76a25d 100644
--- a/include/kvm/kvm.h
+++ b/include/kvm/kvm.h
@@ -129,6 +129,7 @@ static inline bool host_ptr_in_ram(struct kvm *kvm, void *p)
 }
 
 bool kvm__supports_extension(struct kvm *kvm, unsigned int extension);
+bool kvm__supports_vm_extension(struct kvm *kvm, unsigned int extension);
 
 static inline void kvm__set_thread_name(const char *name)
 {
diff --git a/kvm.c b/kvm.c
index 7fa76f7..665ed14 100644
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
2.9.0
