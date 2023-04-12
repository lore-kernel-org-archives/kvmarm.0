Received: from out-23.mta0.migadu.com (out-23.mta0.migadu.com [91.218.175.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3965017C3
	for <kvmarm@lists.linux.dev>; Wed, 12 Apr 2023 06:27:44 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1681280862;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=+OS5wx79G82DqRgrCfJzTs9nXM1PD3+eiU8Aqdq5JR8=;
	b=pzeEMJhFRaxiTe3UdxgGr93c+R+rc9zl26TE8Wk7gbvdjwp9lr6AVcTHGIv8ZqRGTmmDXS
	JrmS1DqhAF/LgwDwW+FI1c9kuLNybAj1wuIQRz+BvCufVpWIn3JoOrZaGU5E4969XinsCB
	eP24Fu5rCYTMEZbhHfw/cVZrGyEpRCs=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	stable@vger.kernel.org
Subject: [PATCH] KVM: arm64: vgic: Don't acquire its_lock before config_lock
Date: Wed, 12 Apr 2023 06:27:33 +0000
Message-Id: <20230412062733.988229-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

commit f00327731131 ("KVM: arm64: Use config_lock to protect vgic
state") was meant to rectify a longstanding lock ordering issue in KVM
where the kvm->lock is taken while holding vcpu->mutex. As it so
happens, the aforementioned commit introduced yet another locking issue
by acquiring the its_lock before acquiring the config lock.

This is obviously wrong, especially considering that the lock ordering
is well documented in vgic.c. Reshuffle the locks once more to take the
config_lock before the its_lock. While at it, sprinkle in the lockdep
hinting that has become popular as of late to keep lockdep apprised of
our ordering.

Cc: stable@vger.kernel.org
Fixes: f00327731131 ("KVM: arm64: Use config_lock to protect vgic state")
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---

Applies to kvmarm/next. Tested with QEMU with lockdep enabled.

 arch/arm64/kvm/vgic/vgic-its.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 7713cd06104e..750e51e3779a 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -1958,6 +1958,16 @@ static int vgic_its_create(struct kvm_device *dev, u32 type)
 	mutex_init(&its->its_lock);
 	mutex_init(&its->cmd_lock);
 
+	/* Yep, even more trickery for lock ordering... */
+#ifdef CONFIG_LOCKDEP
+	mutex_lock(&dev->kvm->arch.config_lock);
+	mutex_lock(&its->cmd_lock);
+	mutex_lock(&its->its_lock);
+	mutex_unlock(&its->its_lock);
+	mutex_unlock(&its->cmd_lock);
+	mutex_unlock(&dev->kvm->arch.config_lock);
+#endif
+
 	its->vgic_its_base = VGIC_ADDR_UNDEF;
 
 	INIT_LIST_HEAD(&its->device_list);
@@ -2752,15 +2762,14 @@ static int vgic_its_ctrl(struct kvm *kvm, struct vgic_its *its, u64 attr)
 		return 0;
 
 	mutex_lock(&kvm->lock);
-	mutex_lock(&its->its_lock);
 
 	if (!lock_all_vcpus(kvm)) {
-		mutex_unlock(&its->its_lock);
 		mutex_unlock(&kvm->lock);
 		return -EBUSY;
 	}
 
 	mutex_lock(&kvm->arch.config_lock);
+	mutex_lock(&its->its_lock);
 
 	switch (attr) {
 	case KVM_DEV_ARM_ITS_CTRL_RESET:
@@ -2774,9 +2783,9 @@ static int vgic_its_ctrl(struct kvm *kvm, struct vgic_its *its, u64 attr)
 		break;
 	}
 
+	mutex_unlock(&its->its_lock);
 	mutex_unlock(&kvm->arch.config_lock);
 	unlock_all_vcpus(kvm);
-	mutex_unlock(&its->its_lock);
 	mutex_unlock(&kvm->lock);
 	return ret;
 }

base-commit: df706d5176fdd92cdfe27ee6ec4389e4cff18bed
-- 
2.40.0.577.gac1e443424-goog

