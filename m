Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28F6E1B2534;
	Wed, 21 Aug 2024 15:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724254847; cv=none; b=Df3u+/rxovTGxcp5PqJPaGNk+IhJdzEPEVhpSWXry7CUy8Gq5h2R8n47KG9Xox4d56SIseXzRoXhoaz+siCrbMpK9mDdfrG19VkUh3jHvlSOIkujZt4OiyzHpn3FhTfsypYficxsUHWjb0dHBQ9TWuyiNOleOEeFAgbjO/yfUDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724254847; c=relaxed/simple;
	bh=xSzUPtPHXDbo3GQ4Se0peA3NwC0SyOKLO+UI0lFXTos=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lEPMiv3TTI6kxtLcUdp1MqS1trLD5Q0ey9/335n+x0JxNU8/eZquCLHKXUE8TL+1ll01FNQuEiOLm4Jz+pRFabGNKbuN5qpaU9hbYCCCo1ILaWgnp/AHhTjnwMag5XyvYPmc+j+d/DBBuoyyRgoKCppWTyWAlIxe9xBXx9NyQiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D2D26DA7;
	Wed, 21 Aug 2024 08:41:10 -0700 (PDT)
Received: from e122027.cambridge.arm.com (e122027.cambridge.arm.com [10.1.37.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4A5653F73B;
	Wed, 21 Aug 2024 08:40:41 -0700 (PDT)
From: Steven Price <steven.price@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: Joey Gouly <joey.gouly@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>,
	linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Gavin Shan <gshan@redhat.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>,
	Steven Price <steven.price@arm.com>
Subject: [PATCH v4 27/43] arm64: rme: allow userspace to inject aborts
Date: Wed, 21 Aug 2024 16:38:28 +0100
Message-Id: <20240821153844.60084-28-steven.price@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240821153844.60084-1-steven.price@arm.com>
References: <20240821153844.60084-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Joey Gouly <joey.gouly@arm.com>

Extend KVM_SET_VCPU_EVENTS to support realms, where KVM cannot set the
system registers, and the RMM must perform it on next REC entry.

Signed-off-by: Joey Gouly <joey.gouly@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
---
 Documentation/virt/kvm/api.rst |  2 ++
 arch/arm64/kvm/guest.c         | 24 ++++++++++++++++++++++++
 2 files changed, 26 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 849ddd2735ca..08652004aa07 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -1278,6 +1278,8 @@ User space may need to inject several types of events to the guest.
 Set the pending SError exception state for this VCPU. It is not possible to
 'cancel' an Serror that has been made pending.
 
+User space cannot inject SErrors into Realms.
+
 If the guest performed an access to I/O memory which could not be handled by
 userspace, for example because of missing instruction syndrome decode
 information or because there is no device mapped at the accessed IPA, then
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 8066d3f05403..88c07c880e88 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -866,6 +866,30 @@ int __kvm_arm_vcpu_set_events(struct kvm_vcpu *vcpu,
 	bool has_esr = events->exception.serror_has_esr;
 	bool ext_dabt_pending = events->exception.ext_dabt_pending;
 
+	if (vcpu_is_rec(vcpu)) {
+		/* Cannot inject SError into a Realm. */
+		if (serror_pending)
+			return -EINVAL;
+
+		/*
+		 * If a data abort is pending, set the flag and let the RMM
+		 * inject an SEA when the REC is scheduled to be run.
+		 */
+		if (ext_dabt_pending) {
+			/*
+			 * Can only inject SEA into a Realm if the previous exit
+			 * was due to a data abort of an Unprotected IPA.
+			 */
+			if (!(vcpu->arch.rec.run->enter.flags & RMI_EMULATED_MMIO))
+				return -EINVAL;
+
+			vcpu->arch.rec.run->enter.flags &= ~RMI_EMULATED_MMIO;
+			vcpu->arch.rec.run->enter.flags |= RMI_INJECT_SEA;
+		}
+
+		return 0;
+	}
+
 	if (serror_pending && has_esr) {
 		if (!cpus_have_final_cap(ARM64_HAS_RAS_EXTN))
 			return -EINVAL;
-- 
2.34.1

