From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v3 07/10] limit number of VCPUs on demand
Date: Wed, 17 Jun 2015 12:21:58 +0100
Message-ID: <1434540121-21283-8-git-send-email-andre.przywara@arm.com>
References: <1434540121-21283-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B408755D05
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Jun 2015 07:11:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zzfgZm46jhLx for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Jun 2015 07:11:24 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F8AC55CFC
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Jun 2015 07:11:20 -0400 (EDT)
In-Reply-To: <1434540121-21283-1-git-send-email-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: will.deacon@arm.com, marc.zyngier@arm.com
Cc: penberg@kernel.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Currently the ARM GIC checks the number of VCPUs against a fixed
limit, which is GICv2 specific. Don't pretend we know better than the
kernel and let's get rid of that explicit check.
Instead be more relaxed about KVM_CREATE_VCPU failing with EINVAL,
which is the way the kernel communicates having reached a VCPU limit.
If we see this and have at least brought up one VCPU already
successfully, then don't panic, but limit the number of VCPUs instead.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 arm/gic.c     |  6 ------
 arm/kvm-cpu.c | 11 +++++++++--
 kvm-cpu.c     |  7 +++++++
 3 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/arm/gic.c b/arm/gic.c
index 99f0d2b..05f85a2 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -84,12 +84,6 @@ int gic__create(struct kvm *kvm)
 {
 	int err;
 
-	if (kvm->nrcpus > GIC_MAX_CPUS) {
-		pr_warning("%d CPUS greater than maximum of %d -- truncating\n",
-				kvm->nrcpus, GIC_MAX_CPUS);
-		kvm->nrcpus = GIC_MAX_CPUS;
-	}
-
 	/* Try the new way first, and fallback on legacy method otherwise */
 	err = gic__create_device(kvm);
 	if (err)
diff --git a/arm/kvm-cpu.c b/arm/kvm-cpu.c
index 7780251..c1cf51d 100644
--- a/arm/kvm-cpu.c
+++ b/arm/kvm-cpu.c
@@ -47,12 +47,19 @@ struct kvm_cpu *kvm_cpu__arch_init(struct kvm *kvm, unsigned long cpu_id)
 	};
 
 	vcpu = calloc(1, sizeof(struct kvm_cpu));
-	if (!vcpu)
+	if (!vcpu) {
+		errno = ENOMEM;
 		return NULL;
+	}
 
 	vcpu->vcpu_fd = ioctl(kvm->vm_fd, KVM_CREATE_VCPU, cpu_id);
-	if (vcpu->vcpu_fd < 0)
+	if (vcpu->vcpu_fd < 0) {
+		if (errno == EINVAL) {
+			free(vcpu);
+			return NULL;
+		}
 		die_perror("KVM_CREATE_VCPU ioctl");
+	}
 
 	mmap_size = ioctl(kvm->sys_fd, KVM_GET_VCPU_MMAP_SIZE, 0);
 	if (mmap_size < 0)
diff --git a/kvm-cpu.c b/kvm-cpu.c
index 5d90664..7a9d689 100644
--- a/kvm-cpu.c
+++ b/kvm-cpu.c
@@ -222,11 +222,18 @@ int kvm_cpu__init(struct kvm *kvm)
 	for (i = 0; i < kvm->nrcpus; i++) {
 		kvm->cpus[i] = kvm_cpu__arch_init(kvm, i);
 		if (!kvm->cpus[i]) {
+			if (i > 0 && errno == EINVAL)
+				break;
 			pr_warning("unable to initialize KVM VCPU");
 			goto fail_alloc;
 		}
 	}
 
+	if (i < kvm->nrcpus) {
+		kvm->nrcpus = i;
+		printf("  # The kernel limits the number of CPUs to %d\n", i);
+	}
+
 	return 0;
 
 fail_alloc:
-- 
2.3.5
