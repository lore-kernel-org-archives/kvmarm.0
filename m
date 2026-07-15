Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A14348AE06;
	Wed, 15 Jul 2026 14:31:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784125868; cv=none; b=GZUhaxVOgV4WXc8RVaJt9aaaDljrC8kDuVKV3TZCSJOK+mgO9TLRpFnrl7OiI+nPwx3rHekyC82chRJkqfa+n7r1Bvs1K/jjKq/6J33e59je0XgteFlu/bvWBbJ+nPF3g+7ArYZGkXZgGZWhJUg/K+KVCC/wi5y6UExyxXguBSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784125868; c=relaxed/simple;
	bh=tgn8iDXNgu5mVAiBC+c6ImZ3Rk5yLqEv8Ic4zHNhfuI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=orTw0/EwqAsuBPHgLPNpGdXnalsy0LX/L5fMPrNj1Hda5CvudiLbb+w8aDya8oC6VxIyMv1NenDnTH6zjipTvJ+5t9M2iEjM2Occxnzs83+Ybcu5hj5azpAr9KlqX/sMK2eH6vMTcLtFtebTV+D0TRkxQh6w7roY5NU1xqXbPUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=pY3uiBwd; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="pY3uiBwd"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CF59615A1;
	Wed, 15 Jul 2026 07:30:59 -0700 (PDT)
Received: from e122027.cambridge.arm.com (e122027.cambridge.arm.com [10.1.25.27])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 28EA83F7B4;
	Wed, 15 Jul 2026 07:31:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784125864; bh=tgn8iDXNgu5mVAiBC+c6ImZ3Rk5yLqEv8Ic4zHNhfuI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pY3uiBwduwz5KkvvYe2YfDc5v1QEM6FcojmNtmLTtOTMV3cFNw2y4y0azEUZamzQo
	 3xULvBDMQzPcp/81zFxALrSOvNF+LDRp0MkdyT7pBtX7pbqDVCSI0n/GQRxg21i+Js
	 d8ybD/xbyb7m2/8ttm8Qkx6y3DS0hwlrycwTnqp8=
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
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
	Emi Kisanuki <fj0570is@fujitsu.com>,
	Vishal Annapurve <vannapurve@google.com>,
	WeiLin.Chang@arm.com,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Steven Price <steven.price@arm.com>
Subject: [PATCH v15 27/37] KVM: arm64: CCA: Allow userspace to inject aborts
Date: Wed, 15 Jul 2026 15:28:29 +0100
Message-ID: <20260715142841.80544-28-steven.price@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260715142841.80544-1-steven.price@arm.com>
References: <20260715142841.80544-1-steven.price@arm.com>
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
Reviewed-by: Gavin Shan <gshan@redhat.com>
---
 Documentation/virt/kvm/api.rst |  2 ++
 arch/arm64/kvm/guest.c         | 24 ++++++++++++++++++++++++
 2 files changed, 26 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index e39d146b34a3..85bec9b4f021 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -1314,6 +1314,8 @@ User space may need to inject several types of events to the guest.
 Set the pending SError exception state for this VCPU. It is not possible to
 'cancel' an Serror that has been made pending.
 
+User space cannot inject SErrors into Realms.
+
 If the guest performed an access to I/O memory which could not be handled by
 userspace, for example because of missing instruction syndrome decode
 information or because there is no device mapped at the accessed IPA, then
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 3e970c4f6214..5469c9a97fad 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -827,6 +827,30 @@ int __kvm_arm_vcpu_set_events(struct kvm_vcpu *vcpu,
 	u64 esr = events->exception.serror_esr;
 	int ret = 0;
 
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
+			if (!(vcpu->arch.rec.run->enter.flags & REC_ENTER_FLAG_EMULATED_MMIO))
+				return -EINVAL;
+
+			vcpu->arch.rec.run->enter.flags &= ~REC_ENTER_FLAG_EMULATED_MMIO;
+			vcpu->arch.rec.run->enter.flags |= REC_ENTER_FLAG_INJECT_SEA;
+		}
+
+		return 0;
+	}
+
 	/*
 	 * Immediately commit the pending SEA to the vCPU's architectural
 	 * state which is necessary since we do not return a pending SEA
-- 
2.43.0

