Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80A4C419302;
	Mon,  3 Aug 2026 13:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785764771; cv=none; b=UnR3Qs+Hp+tri6Up95XwRGG7RB+FiHeNVTDAkYYgEPM9yUhDcvZs+/NLBnUAMCFXVIfqNDNZuD7hv9HNBFGtdqRXzFrRr67LtXyR832g1z0oQnnvwS9w/2nY+wOeczRyzQ4gDnO/e5To52bjnLUS+TCGi7avt4/HgKe+K4+EldI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785764771; c=relaxed/simple;
	bh=CzDXgxOuepxzu+QGvZRaCZEmtV4jtA47VV79b/Le9OU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RfuzhBxBLC2NWgBnn4FJLaWuG4uFoe7omsUvtrQS0Rsn+Jq8RS8kqF6jRw/Ik0tri7semkyufOgeojFZZZ9B/BfkHgqjPGZ/twmlT9OkswuKAj/qxohB1nZR78YCi7I+5FqPwHmmFEqid4n9jH7WD4J6eHDjRe0ufPl3bzwUjDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=NYqxGDxy; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="NYqxGDxy"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B87191655;
	Mon,  3 Aug 2026 06:46:05 -0700 (PDT)
Received: from e122027.cambridge.arm.com (e122027.cambridge.arm.com [10.1.25.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CF2AB3F66F;
	Mon,  3 Aug 2026 06:46:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785764769; bh=CzDXgxOuepxzu+QGvZRaCZEmtV4jtA47VV79b/Le9OU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NYqxGDxysx6UdyDzvxP/Xv5joe9UD6endoboLrwwEK1v+Rf39naqjpmrJacfzmPnz
	 MfV/rAtSkaj1j6ke0cqNbWX6msfj067eDNiXuvILizBUH5nLQXeaiO+Xlw4aMbI3v9
	 Jri+KHjpNBec5BJgL5FI76wASDvQfgwBg6BRMqoI=
From: Steven Price <steven.price@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: Steven Price <steven.price@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>,
	linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Gavin Shan <gshan@redhat.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
	Emi Kisanuki <fj0570is@fujitsu.com>,
	Vishal Annapurve <vannapurve@google.com>,
	WeiLin.Chang@arm.com,
	Lorenzo Pieralisi <lpieralisi@kernel.org>
Subject: [PATCH v16 24/45] KVM: arm64: Expose support for private memory
Date: Mon,  3 Aug 2026 14:43:40 +0100
Message-ID: <20260803134403.80630-25-steven.price@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260803134403.80630-1-steven.price@arm.com>
References: <20260803134403.80630-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Select KVM_GENERIC_MEMORY_ATTRIBUTES and provide the necessary support
functions.

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
---
Changes since v14:
 * Switch to guest_memfd in-place memory conversion and drop support
   for KVM_VM_MEMORY_ATTRIBUTES.
Changes since v13:
 * Also update documentation to show that KVM_CAP_MEMORY_ATTRIBUTES is
   used on arm64.
Changes since v12:
 * Only define kvm_arch_has_private_mem() when
   CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES is set to avoid build issues
   when KVM is disabled.
Changes since v10:
 * KVM_GENERIC_PRIVATE_MEM replacd with KVM_GENERIC_MEMORY_ATTRIBUTES.
Changes since v9:
 * Drop the #ifdef CONFIG_KVM_PRIVATE_MEM guard from the definition of
   kvm_arch_has_private_mem()
Changes since v2:
 * Switch kvm_arch_has_private_mem() to a macro to avoid overhead of a
   function call.
 * Guard definitions of kvm_arch_{pre,post}_set_memory_attributes() with
   #ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES.
 * Early out in kvm_arch_post_set_memory_attributes() if the WARN_ON
   should trigger.
---
 arch/arm64/include/asm/kvm_host.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 15d42d1993bb..146c52f867c0 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1510,6 +1510,8 @@ struct kvm *kvm_arch_alloc_vm(void);
 
 #define vcpu_is_protected(vcpu)		kvm_vm_is_protected((vcpu)->kvm)
 
+#define kvm_arch_has_private_mem(kvm) ((kvm)->arch.is_realm)
+
 int kvm_arm_vcpu_finalize(struct kvm_vcpu *vcpu, int feature);
 bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu);
 
-- 
2.43.0

