Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E073572667;
	Tue,  8 Sep 2026 16:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788884601; cv=none; b=rT0hp8BWyJUgArwwdvjFfOvxU6VepdiitVL4yw7TPsXmLk2KaSzldsnt2GTdg5tAzZIpvP10FMFdUbw1mXelkCJxn9Y15qwT5ced0SE6opXm5vnl3xbD6UAl543NnxBhAROLyzcYwd5ck685vXw65Du3zD9rWMiZvcIj660G4Ew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788884601; c=relaxed/simple;
	bh=CgnhUkjRCuK5Hn3XRTDM/Af/LZ4kv2s2gn1J+cXjimM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=meZhLiJmH+CnmK3R4Dc3weRUpZil6941qKB9r1d7o60SaC6z0noNl83o2rzeMkHxbd3zzMe22sEZY+ja2p2wciEA/hDjSROaCJGnJSFuIbo8ldA5fM4SeMUcnEdAO6Hhf/AO1CoCTVnAWmfJn6sI0kLkbYDDTWUBalmHlhz3Y6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=vfFLvsGB; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="vfFLvsGB"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E6C791476;
	Tue,  8 Sep 2026 09:23:13 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 526EB3F7B4;
	Tue,  8 Sep 2026 09:23:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788884597; bh=CgnhUkjRCuK5Hn3XRTDM/Af/LZ4kv2s2gn1J+cXjimM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vfFLvsGBSaN2oezQYfkot3Y+FXdmwUIVuwYRthDibzcWmcx2Frlxv4hVZczohPmB/
	 y4mjeTNNINippo3RnXpp+1FIM87EkCd6qbR8ywk2NgCHN7lLREQf5b2ji+VIf666KR
	 9V0EM0n9MnrdzvudZDiIvBAezfm9jn1NPqQ+uDmY=
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: maz@kernel.org,
	will@kernel.org,
	catalin.marinas@arm.com,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	steven.price@arm.com,
	aneesh.kumar@kernel.org,
	oupton@kernel.org,
	gshan@redhat.com,
	joey.gouly@arm.com,
	tabba@google.com,
	yuzenghui@huawei.com,
	linux-coco@lists.linux.dev,
	gankulkarni@os.amperecomputing.com,
	sdonthineni@nvidia.com,
	alpergun@google.com,
	fj0570is@fujitsu.com,
	WeiLin.Chang@arm.com,
	lpieralisi@kernel.org,
	enju.kohei@fujitsu.com,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v17 08/20] KVM: arm64: coco:  Add a helper to check if a VM is confidential compute guest
Date: Tue,  8 Sep 2026 17:22:11 +0100
Message-ID: <20260908162223.1683432-9-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260908162223.1683432-1-suzuki.poulose@arm.com>
References: <20260908162223.1683432-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Both protected VMs and Realms are additionally secured by the trusted hypervisor
guarantees. Add a helper to detect if a given VM is a coco guest. Base this off
the ordering of the VM flavor type.

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arch/arm64/include/asm/kvm_host.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 824a3383409c8..020aef5a1b698 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -316,6 +316,7 @@ enum kvm_arm_vm_flavor {
 	VM_NVHE,
 	VM_VHE,
 	VM_PKVM,		/* Normal guests on PKVM */
+	MARKER(__VM_CONFIDENTIAL),
 	VM_PROTECTED_PKVM,	/* Protected VM */
 	VM_REALM,		/* CCA */
 	VM_FLAVOR_MAX,
@@ -1524,9 +1525,11 @@ struct kvm *kvm_arch_alloc_vm(void);
 
 #define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS_RANGE
 
+#define kvm_vm_is_confidential(kvm)	((kvm)->arch.vm_flavor >= __VM_CONFIDENTIAL)
 #define kvm_vm_is_protected(kvm)	((kvm)->arch.vm_flavor == VM_PROTECTED_PKVM)
 #define kvm_vm_is_realm(kvm)		((kvm)->arch.vm_flavor == VM_REALM)
 
+#define vcpu_is_confidential(vcpu)	kvm_vm_is_confidential((vcpu)->kvm)
 #define vcpu_is_protected(vcpu)		kvm_vm_is_protected((vcpu)->kvm)
 #define vcpu_is_rec(vcpu)		kvm_vm_is_realm((vcpu)->kvm)
 
-- 
2.43.0

