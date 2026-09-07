Received: from mta0.migadu.com (out-104.mta0.migadu.com [91.218.175.104])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F2004156FB
	for <kvmarm@lists.linux.dev>; Mon,  7 Sep 2026 07:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.104
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788764530; cv=none; b=Zg/6h90Z2rSjhXOc+vZCbhb0PipjdPImq+eMDTCIKiThLmh1kl06RGPaaQadkXZ1LZUy23EWQsCUypSdRiCZJEymoWk+DNk5iEJunKtbtZz5KQyqeRQ76heAUH1mBBMfcRykwXDPBmjYzAwsloHrSARQ3TeESRp/2Y79md4/ruY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788764530; c=relaxed/simple;
	bh=4rBBnTKsVt+UNDbaByl3o+wf1nAc8VgqLVJ0fBMEElU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FXcuqC+5eK++GxxRdSdtNiG0yg3GmYS9dcQAVT8J4Ue+KG17vdvtawlUfPIDcMNcBGBBJ6hMnpz4K+eX0nNksNP+oXsvm6j5nscbHNBPmCHYoXJ/7TVp9603IyfzH/6D3csZQm25hIQO8uBpwhohxv/PX0BeVd0ll+yWJ82OqYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xnzj2TFm; arc=none smtp.client-ip=91.218.175.104
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xnzj2TFm"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=4rBBnTKsVt+UNDbaByl3o+wf1nAc8VgqLVJ0fBMEElU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788764524; v=1; x=1789369324;
 b=xnzj2TFmQpMviOUUInBFglPIZm8ksJ9/NnnZWGs5YTj7AsZjbtZMSE4CzDz4pSyt9o6RTsmK
 9KyfuDeAta7Z8Copdju+cvySOCcQ6lYQUTVWEZovWNQgqcWXq2U0/5K6LN9FobOVTC5kq2zunSG
 X6aLg/wkQW2tD4XbvJWt4dK0=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id ef192164074fc80d;
	Mon, 07 Sep 2026 07:02:04 +0000
X-Mizu-Trace-ID: ef192164074fc80d
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Quentin Perret <qperret@google.com>,
	Fuad Tabba <tabba@google.com>
Subject: [PATCH v2 16/17] KVM: arm64: Advertise the capabilities that protected VMs support
Date: Mon,  7 Sep 2026 08:00:01 +0100
Message-Id: <20260907070002.3333525-17-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260907070002.3333525-1-fuad.tabba@linux.dev>
References: <20260907070002.3333525-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

kvm_pkvm_ext_allowed() denies every capability it doesn't name, so a
protected VM reports 0 for interfaces it implements: KVM_CHECK_EXTENSION
denies KVM_CAP_ONE_REG while KVM_{GET,SET}_ONE_REG stage the guest's
boot state.

Allow the capabilities that work for a protected guest under the
restrictions the preceding patches add, the vGIC and the I/O bus being
host-managed.

Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/include/asm/kvm_pkvm.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
index 5fec511eca733..ee3ab505b01f7 100644
--- a/arch/arm64/include/asm/kvm_pkvm.h
+++ b/arch/arm64/include/asm/kvm_pkvm.h
@@ -41,6 +41,15 @@ static inline bool kvm_pkvm_ext_allowed(struct kvm *kvm, long ext)
 	case KVM_CAP_ARM_VM_IPA_SIZE:
 	case KVM_CAP_ARM_PTRAUTH_ADDRESS:
 	case KVM_CAP_ARM_PTRAUTH_GENERIC:
+	case KVM_CAP_ONE_REG:
+	case KVM_CAP_MP_STATE:
+	case KVM_CAP_VCPU_EVENTS:
+	case KVM_CAP_VCPU_ATTRIBUTES:
+	case KVM_CAP_IMMEDIATE_EXIT:
+	case KVM_CAP_IOEVENTFD:
+	case KVM_CAP_IRQFD_RESAMPLE:
+	case KVM_CAP_ARM_IRQ_LINE_LAYOUT_2:
+	case KVM_CAP_ARM_INJECT_SERROR_ESR:
 		return true;
 	case KVM_CAP_ARM_MTE:
 		return false;
-- 
2.39.5

