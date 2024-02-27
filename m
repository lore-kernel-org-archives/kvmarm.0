Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1B685576B
	for <kvmarm@lists.linux.dev>; Tue, 27 Feb 2024 22:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709073786; cv=none; b=KBuUhU0SCN7YxcDxr+Mqo10QKEXv+LbA7GR01AMbo747UyCR7goPadaQK6SBNkhgzGSXBjiKW3lyjnpQU6N3MFnYDjKpnI/2/Nn/aSCX4O807Z6WOVzOsncJbS+xhuAObcop6qq4qGOTwWh2CydvMyrVGzFrdfN0PLo+uDTCL0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709073786; c=relaxed/simple;
	bh=b7WdY2py5IBarCq8Vtlyjs9yxB7vV1fd1EaY33x9Yzs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QY1oZvNqsVfaI0VgTX78OTc3MevSh6zYkPeXuH3yYNjolP00D7yxH0UPp7QQZxK39VmzImb1RlJCzcN7tT3d4wsITT2G9mWr9vVvKROb7D//wZcUNp9Q7bBO1Zwfz6Ud4XkMAfCnmi1j53Z/P9V29CellWO/Q4HAbr5c3CEZNVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=wEeKJbbJ; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="wEeKJbbJ"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709073781;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LzAjQn8FUZtv1k0S5AGRJKafgs13rhfW7HC8Y+ixwf8=;
	b=wEeKJbbJ/Z87mABec/fSVw8KlOqlQ+Rruq9Mft4B2JnvoJ9MKYhf4LvgEM5EJPWYbNQjIZ
	nAu/578hrLcRTTToWvppilSGwET1D/MFNLg88f2fQJjK5+HxyMnrr4fnCqxvI7LHfkRW2V
	jwK7yfhc2LhmWz4fr3C56ccse0Qo24Q=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 01/20] KVM: Treat the device list as an rculist
Date: Tue, 27 Feb 2024 22:42:30 +0000
Message-ID: <20240227224249.2209194-2-oliver.upton@linux.dev>
In-Reply-To: <20240227224249.2209194-1-oliver.upton@linux.dev>
References: <20240227224249.2209194-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

A subsequent change to KVM/arm64 will necessitate walking the device
list outside of the kvm->lock. Prepare by converting to an rculist.
Note that this has zero effect the destruction path, as every reader
should be protected by a valid reference on the KVM struct.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 virt/kvm/kvm_main.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index c681149c382a..a1423f8064b0 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1326,10 +1326,12 @@ static void kvm_destroy_devices(struct kvm *kvm)
 	/*
 	 * We do not need to take the kvm->lock here, because nobody else
 	 * has a reference to the struct kvm at this point and therefore
-	 * cannot access the devices list anyhow.
+	 * cannot access the devices list anyhow. Furthermore, there are no RCU
+	 * readers after the last reference is dropped, so there is no need to
+	 * defer destruction until a grace period has elapsed.
 	 */
 	list_for_each_entry_safe(dev, tmp, &kvm->devices, vm_node) {
-		list_del(&dev->vm_node);
+		list_del_rcu(&dev->vm_node);
 		dev->ops->destroy(dev);
 	}
 }
@@ -4781,7 +4783,7 @@ static int kvm_ioctl_create_device(struct kvm *kvm,
 		kfree(dev);
 		return ret;
 	}
-	list_add(&dev->vm_node, &kvm->devices);
+	list_add_rcu(&dev->vm_node, &kvm->devices);
 	mutex_unlock(&kvm->lock);
 
 	if (ops->init)
-- 
2.44.0.rc1.240.g4c46232300-goog

