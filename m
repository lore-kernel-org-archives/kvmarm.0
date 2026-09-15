Received: from mta0.migadu.com (out-191.mta0.migadu.com [91.218.175.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E673498920
	for <kvmarm@lists.linux.dev>; Tue, 15 Sep 2026 08:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789461895; cv=none; b=TRM4k6U2W/ObeSAB80U+3+746HL48czmZGekscMFrq6FzXbWJc0nQ8eLHgkcUAhL/0Eym7Pb/AgKrFi+MzcSB4eODBJ+w5KIcqSE65F9mg5q8adHjCBg0y/e7x8PazXIkC9w1mJ/2BP+iPQDQpEWpz6Et+qpQmy6GN66I99/ObU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789461895; c=relaxed/simple;
	bh=bSEkY03asFd7ncFCJXorUGr/EvrnfLd1LZhh/lJlyYA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=E3CsBefFAGEYae6Mhkfjd1CGH/EmbbTe4NlWnAujIiY7AabOFJ66MZYAjTAgjvNZ/FCWbM96R4Vorp24IEg47A/IYFKd4oB36fbz3YXQNbvFrPxalDyx6F7DsM6FmbAAk0YLtkSbKM205QsL+rXFgZQgFCX+AKdkwFvpvpHBu8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=EezWVo4o; arc=none smtp.client-ip=91.218.175.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="EezWVo4o"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=bSEkY03asFd7ncFCJXorUGr/EvrnfLd1LZhh/lJlyYA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789461887; v=1; x=1790066687;
 b=EezWVo4ojNYwRbqRZ9QVKaV/VvM4F7cetwiZhl4pWHApYZeli8SwJcUsKC3MiXJBUdtF5mpN
 Co9Fl/tT/ezz6qBcsetMBkdW69exvfzc6db1H5Qh/nwWXLdbaMHXXr4/ENx6bC06ZYmlUI5GYYn
 hq/WdrpGC8/M8sRZqLEHXRpc=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 08fbd8a02e04e0fe;
	Tue, 15 Sep 2026 08:44:47 +0000
X-Mizu-Trace-ID: 08fbd8a02e04e0fe
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Sean Christopherson <seanjc@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Will Deacon <will@kernel.org>,
	Fuad Tabba <tabba@google.com>,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-doc@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] KVM: arm64: Fix references to the non-existent VCPU_RUN ioctl
Date: Tue, 15 Sep 2026 09:44:40 +0100
Message-Id: <20260915084441.3846947-3-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260915084441.3846947-1-fuad.tabba@linux.dev>
References: <20260915084441.3846947-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There is no VCPU_RUN ioctl. The one that enters the guest is KVM_RUN,
so refer to it by that name.

Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 Documentation/virt/kvm/arm/pkvm.rst | 2 +-
 arch/arm64/kvm/arm.c                | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/arm/pkvm.rst b/Documentation/virt/kvm/arm/pkvm.rst
index 514992a79a833..18d8afe36ebce 100644
--- a/Documentation/virt/kvm/arm/pkvm.rst
+++ b/Documentation/virt/kvm/arm/pkvm.rst
@@ -67,7 +67,7 @@ largely due to the lack of MMU notifiers:
   then it will either return ``-EFAULT`` or forcefully reclaim the
   memory pages. Reclaimed memory is zeroed by the hypervisor and a
   subsequent attempt to access it in the pVM will return ``-EFAULT``
-  from the ``VCPU_RUN`` ioctl().
+  from the ``KVM_RUN`` ioctl().
 
 CPU state isolation
 -------------------
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 8b080804bc90b..a18ec13bd6677 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1263,7 +1263,7 @@ static int noinstr kvm_arm_vcpu_enter_exit(struct kvm_vcpu *vcpu)
  * kvm_arch_vcpu_ioctl_run - the main VCPU run function to execute guest code
  * @vcpu:	The VCPU pointer
  *
- * This function is called through the VCPU_RUN ioctl called from user space. It
+ * This function is called through the KVM_RUN ioctl called from user space. It
  * will execute VM code in a loop until the time slice for the process is used
  * or some emulation is needed from user space in which case the function will
  * return with return value 0 and with the kvm_run structure filled in with the
-- 
2.39.5

