Received: from out-37.mta0.migadu.com (out-37.mta0.migadu.com [91.218.175.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCCCFBA3E
	for <kvmarm@lists.linux.dev>; Tue,  4 Apr 2023 15:41:14 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1680622872;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YzSfwFGm8NO+I2M2r6JMUYH/IVd8zU67wvMoeXElqlg=;
	b=wfjh+QZj8yrfZvl6bX9alH2NG2TQ6UTuNyERlyxlL8Q3HbEam9N6u/h4KfvQDSLrb6o1Ih
	3JtvPgIgwxFXleaK8+zKbXKhRvQmXVViWKbK74zsxKY7s1c5XPJpQa4nXr5fY9OtaFJYhT
	ICLO3rlOUHC2v8uyVKvU/+kYKud888k=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Sean Christopherson <seanjc@google.com>,
	Salil Mehta <salil.mehta@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v3 03/13] KVM: arm64: Add vm fd device attribute accessors
Date: Tue,  4 Apr 2023 15:40:40 +0000
Message-Id: <20230404154050.2270077-4-oliver.upton@linux.dev>
In-Reply-To: <20230404154050.2270077-1-oliver.upton@linux.dev>
References: <20230404154050.2270077-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

A subsequent change will allow userspace to convey a filter for
hypercalls through a vm device attribute. Add the requisite boilerplate
for vm attribute accessors.

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/arm.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 3bd732eaf087..b6e26c0e65e5 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1439,11 +1439,28 @@ static int kvm_vm_ioctl_set_device_addr(struct kvm *kvm,
 	}
 }
 
+static int kvm_vm_has_attr(struct kvm *kvm, struct kvm_device_attr *attr)
+{
+	switch (attr->group) {
+	default:
+		return -ENXIO;
+	}
+}
+
+static int kvm_vm_set_attr(struct kvm *kvm, struct kvm_device_attr *attr)
+{
+	switch (attr->group) {
+	default:
+		return -ENXIO;
+	}
+}
+
 long kvm_arch_vm_ioctl(struct file *filp,
 		       unsigned int ioctl, unsigned long arg)
 {
 	struct kvm *kvm = filp->private_data;
 	void __user *argp = (void __user *)arg;
+	struct kvm_device_attr attr;
 
 	switch (ioctl) {
 	case KVM_CREATE_IRQCHIP: {
@@ -1479,6 +1496,18 @@ long kvm_arch_vm_ioctl(struct file *filp,
 			return -EFAULT;
 		return kvm_vm_ioctl_mte_copy_tags(kvm, &copy_tags);
 	}
+	case KVM_HAS_DEVICE_ATTR: {
+		if (copy_from_user(&attr, argp, sizeof(attr)))
+			return -EFAULT;
+
+		return kvm_vm_has_attr(kvm, &attr);
+	}
+	case KVM_SET_DEVICE_ATTR: {
+		if (copy_from_user(&attr, argp, sizeof(attr)))
+			return -EFAULT;
+
+		return kvm_vm_set_attr(kvm, &attr);
+	}
 	default:
 		return -EINVAL;
 	}
-- 
2.40.0.348.gf938b09366-goog

