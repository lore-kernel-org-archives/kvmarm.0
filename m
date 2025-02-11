Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 960C428EA
	for <kvmarm@lists.linux.dev>; Tue, 11 Feb 2025 00:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739232596; cv=none; b=bHIPmL0qSfAM3fsijcpQYUu5AWPSInhVW3LIL0O2KDJ/n7XTQLJbnz4GEn+CaNfIcukHO5m2GDAJkxXjCBZWUCxiaHqQ6rtzvSsy71AL87H4fxI/1uR5aU1QvmkaXg2IWuE37OfbPfIU0PPbWcaB8SDMVkS6P+Upe92ON7BUxnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739232596; c=relaxed/simple;
	bh=t3dqqISyLKzv9/bJKFTaeu9lKpC56B3XEJprW68cUcA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=U1OD+jfHZLMvepb9wALCxHO21w++FoyNaZ9d43cxayKKmBz5Tl9nesidL6aoytXqiCQwZMaQ/VHt+0EhzGvwTpwLqQXwIIP8m7YmhZeiQ8T8PVFxUi4Cf1Ft30WVvrEZg10+EmLIPD5U9J/7lVtNYmfX99pluZJL2SzG3oOjDkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=is57R7QE; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="is57R7QE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739232593;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yzGbC0ypbw1NU4jMljSKqdqWfQ9LORCBGxC9rZKevfg=;
	b=is57R7QEsIB0oBMkwzU8f3SX6OL7Fp1Bg6C3LfK1KbBuH4VanLt5q9lnePuG/2lANo6fQp
	exhSWs0dSmemu7RGtZfJ+alY+gQe4JP3C0TijG8HzGCrJKwHTAf1c4Vl9ivXd/rulaw3aS
	3VB2R6s8Gb1qbjKiP+rZRYBVtMze+As=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-556-rxU9z2ZwPoCLLQlMQjJc6g-1; Mon,
 10 Feb 2025 19:09:48 -0500
X-MC-Unique: rxU9z2ZwPoCLLQlMQjJc6g-1
X-Mimecast-MFC-AGG-ID: rxU9z2ZwPoCLLQlMQjJc6g
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BECC31800983;
	Tue, 11 Feb 2025 00:09:44 +0000 (UTC)
Received: from starship.lan (unknown [10.22.65.174])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 006BA19560A3;
	Tue, 11 Feb 2025 00:09:38 +0000 (UTC)
From: Maxim Levitsky <mlevitsk@redhat.com>
To: kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Jing Zhang <jingzhangos@google.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	linux-arm-kernel@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>,
	linux-kernel@vger.kernel.org,
	Randy Dunlap <rdunlap@infradead.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	kvm-riscv@lists.infradead.org,
	Ingo Molnar <mingo@redhat.com>,
	linux-riscv@lists.infradead.org,
	Joey Gouly <joey.gouly@arm.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	kvmarm@lists.linux.dev,
	Alexander Potapenko <glider@google.com>,
	x86@kernel.org,
	Sean Christopherson <seanjc@google.com>,
	Anup Patel <anup@brainfault.org>,
	Kunkun Jiang <jiangkunkun@huawei.com>,
	Atish Patra <atishp@atishpatra.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 3/3] RISC-V: KVM: switch to kvm_lock/unlock_all_vcpus
Date: Mon, 10 Feb 2025 19:09:17 -0500
Message-Id: <20250211000917.166856-4-mlevitsk@redhat.com>
In-Reply-To: <20250211000917.166856-1-mlevitsk@redhat.com>
References: <20250211000917.166856-1-mlevitsk@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

use kvm_lock/unlock_all_vcpus instead of riscv's own
implementation.

Note that this does introduce a slight functional change - now vCPUs are
unlocked in the same order they were locked and not in the opposite order.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/riscv/kvm/aia_device.c | 36 +++---------------------------------
 1 file changed, 3 insertions(+), 33 deletions(-)

diff --git a/arch/riscv/kvm/aia_device.c b/arch/riscv/kvm/aia_device.c
index 39cd26af5a69..32354e47c7d8 100644
--- a/arch/riscv/kvm/aia_device.c
+++ b/arch/riscv/kvm/aia_device.c
@@ -12,36 +12,6 @@
 #include <linux/kvm_host.h>
 #include <linux/uaccess.h>
 
-static void unlock_vcpus(struct kvm *kvm, int vcpu_lock_idx)
-{
-	struct kvm_vcpu *tmp_vcpu;
-
-	for (; vcpu_lock_idx >= 0; vcpu_lock_idx--) {
-		tmp_vcpu = kvm_get_vcpu(kvm, vcpu_lock_idx);
-		mutex_unlock(&tmp_vcpu->mutex);
-	}
-}
-
-static void unlock_all_vcpus(struct kvm *kvm)
-{
-	unlock_vcpus(kvm, atomic_read(&kvm->online_vcpus) - 1);
-}
-
-static bool lock_all_vcpus(struct kvm *kvm)
-{
-	struct kvm_vcpu *tmp_vcpu;
-	unsigned long c;
-
-	kvm_for_each_vcpu(c, tmp_vcpu, kvm) {
-		if (!mutex_trylock(&tmp_vcpu->mutex)) {
-			unlock_vcpus(kvm, c - 1);
-			return false;
-		}
-	}
-
-	return true;
-}
-
 static int aia_create(struct kvm_device *dev, u32 type)
 {
 	int ret;
@@ -52,8 +22,8 @@ static int aia_create(struct kvm_device *dev, u32 type)
 	if (irqchip_in_kernel(kvm))
 		return -EEXIST;
 
-	ret = -EBUSY;
-	if (!lock_all_vcpus(kvm))
+	ret = kvm_lock_all_vcpus(kvm);
+	if (ret)
 		return ret;
 
 	kvm_for_each_vcpu(i, vcpu, kvm) {
@@ -65,7 +35,7 @@ static int aia_create(struct kvm_device *dev, u32 type)
 	kvm->arch.aia.in_kernel = true;
 
 out_unlock:
-	unlock_all_vcpus(kvm);
+	kvm_unlock_all_vcpus(kvm);
 	return ret;
 }
 
-- 
2.26.3

