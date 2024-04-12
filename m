Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F1E784A39;
	Fri, 12 Apr 2024 08:44:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712911451; cv=none; b=kIxg9u7BPK1KDHCqLiGZvx8nWv26M+bWB6MqjyqTDfT8ZLMyFo5UazTj6mzOHLFP3EDOLzZiSXBt0DT3+xXOOLpkQmpB7EZqFopx8/pjPr6WRZIj8mmnPiiSAsxc2VpV8t9rI+dWZSrt1/4aXtOTx3K7Udz+XVOARCXLDK2+JDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712911451; c=relaxed/simple;
	bh=+/EYSelihAXpErospJh6KWpMk2w0Em/EAZY6R3tdOlw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fzZbGOLfqLuEEb3EETrGcJhAqYHsSUTICipHbew5/YAYt76bmfyg9VlNn3k8PCLMtYeTYcXUWDL33ctvHlOw6mhLa5F10swFpTyXH6Ze8iJGU0ERRwnjmM7NtS1NqPmKqmeFq0l5b1SroQKihqWDUS4Lb60HcMEnh9Otjr7vix0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 54FCF113E;
	Fri, 12 Apr 2024 01:44:39 -0700 (PDT)
Received: from e112269-lin.cambridge.arm.com (e112269-lin.cambridge.arm.com [10.1.194.51])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id ED2313F6C4;
	Fri, 12 Apr 2024 01:44:07 -0700 (PDT)
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
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Subject: [PATCH v2 22/43] KVM: arm64: Handle realm VCPU load
Date: Fri, 12 Apr 2024 09:42:48 +0100
Message-Id: <20240412084309.1733783-23-steven.price@arm.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240412084309.1733783-1-steven.price@arm.com>
References: <20240412084056.1733704-1-steven.price@arm.com>
 <20240412084309.1733783-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When loading a realm VCPU much of the work is handled by the RMM so only
some of the actions are required. Rearrange kvm_arch_vcpu_load()
slightly so we can bail out early for a realm guest.

Signed-off-by: Steven Price <steven.price@arm.com>
---
 arch/arm64/kvm/arm.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index e92afb3835f6..4fd58a1d3351 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -512,10 +512,6 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 
 	kvm_vgic_load(vcpu);
 	kvm_timer_vcpu_load(vcpu);
-	if (has_vhe())
-		kvm_vcpu_load_vhe(vcpu);
-	kvm_arch_vcpu_load_fp(vcpu);
-	kvm_vcpu_pmu_restore_guest(vcpu);
 	if (kvm_arm_is_pvtime_enabled(&vcpu->arch))
 		kvm_make_request(KVM_REQ_RECORD_STEAL, vcpu);
 
@@ -524,6 +520,15 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	else
 		vcpu_set_wfx_traps(vcpu);
 
+	/* No additional state needs to be loaded on Realmed VMs */
+	if (vcpu_is_rec(vcpu))
+		return;
+
+	if (has_vhe())
+		kvm_vcpu_load_vhe(vcpu);
+	kvm_arch_vcpu_load_fp(vcpu);
+	kvm_vcpu_pmu_restore_guest(vcpu);
+
 	if (vcpu_has_ptrauth(vcpu))
 		vcpu_ptrauth_disable(vcpu);
 	kvm_arch_vcpu_load_debug_state_flags(vcpu);
-- 
2.34.1

