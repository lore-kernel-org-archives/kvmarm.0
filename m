Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793025890;
	b=OusUqsjvnWSv2vP+GmYCA33kjIxARbvClCDXb3tCb3TzFHYXk43QUR8H1zuPeUDR4Byk
	 Qixom4TqiRd2Y+GSEoREvamWZzuJ0gTqVHGOm2uQDIujYj7yr9KeoKI1x08iCNvMpjGBp
	 suWcbfptabEbnBFYHPCmi1oQOioiAYrTDmK/AzSeTzTDcqO7HIMMMvQBsApIkG9BXcPpY
	 5EI+MOTd4jeF/c6hswvunJmW2076wN8m8FVXa+zcfWTgWatF6NRmofvSOLkzQz5l5ZoBk
	 ghtHMvlJfqTsZM+iYr0Ooktfcxj5WP/h78PWb4hvLILM2Mm1pdge78Yb2UHFjrGtgkA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793025890;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 X-Developer-Signature:X-Developer-Key:Content-Transfer-Encoding;
	bh=kxE4A0VSnxahND1X2MPTQwXDknQ6I/xJGaQ331/gno0=;
	b=Q9oWcRjnwATjRSJQR543pO9dAJw7ri/TTHdwexFwKoaZh/zB7ucispvFI1ulFBP1HmdU
	 1rFYFYQGDmTBRtuuuAsX9gmY2PERe1FCeBS4WtViyy341XdqE4BiiCugxYVUGzelqbbEF
	 TUBtg446L3a91t8dxXR5KGNNH3f9FGP0zNXBYx9nUN8ZsXko1o1iwIQYnvk/J2ZutPIaf
	 Z/qyPZSxSfRWD/mzJ+Xtn0GuldLg3mv4F2gLzYna4SsuCIkdXSTj7c4UWTZ7c/NRE/siB
	 pqVi6xWAqHHmaLYnvB/gznnfKVZVZ6sZXjdkIa1erJy7qcS0GRGN/43w1LUHG/XOS2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=Lvj66Pft;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16330606A32A
	for <kvmarm@lists.linux.dev>; Mon, 26 Oct 2026 14:44:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 16330606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=Lvj66Pft
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 52B4C2944;
	Mon, 26 Oct 2026 07:44:45 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 799A23F7B4;
	Mon, 26 Oct 2026 07:44:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793025888; bh=OkxornoEoZZzTD9JkMHL7VjKUUICLPzAPrCszeD7jDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lvj66Pft/b5dAog1VNhauP81Y+dBkss0Lvw+CzO+pCycppBi5sy4gTTaBlqAGbn8u
	 3oInMG+TTxS4/aDUJXK+N/RnL8/3ov8j/t2yr5FX+MzGXIcqj56kBmsQPWH5BRfraV
	 QdwjMZGTefzsx9bywG/PhA++h1lgFKnKfcpTRPmU=
From: Leonardo Bras <leo.bras@arm.com>
To: Oliver Upton <oupton@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Leonardo Bras <leo.bras@arm.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Tian Zheng <zhengtian10@huawei.com>
Cc: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH v2 3/3] KVM: arm64: Add KVM_REQ_RELOAD_STAGE2
Date: Mon, 26 Oct 2026 14:44:09 +0000
Message-ID: <20261026144413.441566-4-leo.bras@arm.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261026144413.441566-1-leo.bras@arm.com>
References: <20261026144413.441566-1-leo.bras@arm.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1971; i=leo.bras@arm.com; h=from:subject; bh=OkxornoEoZZzTD9JkMHL7VjKUUICLPzAPrCszeD7jDM=; b=owGbwMvMwCX2pizjszvTwvWMp9WSGLLup1swN6SWyZ98NceO75vTdPtfvz9p/dwxSSRZdtGCH 2ZfJE8Hd5SyMIhxMciKKbLIPpq/iuf7lIwjV34sgJnDygQyhIGLUwAmIqzOyNBscHTbxGOu4U5b BbJWWE9PfGV07GlN4NvFtb2H7aV8WVIZGY4JyLM7Xr3/RH3p/7cpE/Rz7wvq3Vvn/lptt8C3Hay bXrAAAA==
X-Developer-Key: i=leo.bras@arm.com; a=openpgp; fpr=36E6C95AE0F111CC5B6F4D2E688C33F8A0C5B0C5
Content-Transfer-Encoding: 8bit

Add a vcpu request to exit guest, reload Stage2, and then come back to
guest.

This will be used on future patches that enable HDBSS, as they may need to
change VTCR bits for enabling/disabling the feature when the vcpus are
still running.

On non-VHE systems, just skip this request as Stage2 is being reloaded
on every guest entry.

Signed-off-by: Leonardo Bras <leo.bras@arm.com>
---
 arch/arm64/include/asm/kvm_host.h |  2 ++
 arch/arm64/kvm/arm.c              | 10 ++++++++++
 2 files changed, 12 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index cd9b9d2462f9..86a4d6e50934 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -53,10 +53,12 @@
 #define KVM_REQ_RESYNC_PMU_EL0		KVM_ARCH_REQ(7)
 #define KVM_REQ_NESTED_S2_UNMAP		KVM_ARCH_REQ(8)
 #define KVM_REQ_GUEST_HYP_IRQ_PENDING	KVM_ARCH_REQ(9)
 #define KVM_REQ_MAP_L1_VNCR_EL2		KVM_ARCH_REQ(10)
 #define KVM_REQ_VGIC_PROCESS_UPDATE	KVM_ARCH_REQ(11)
+#define KVM_REQ_RELOAD_STAGE2 \
+	KVM_ARCH_REQ_FLAGS(12, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 
 #define KVM_DIRTY_LOG_MANUAL_CAPS   (KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE | \
 				     KVM_DIRTY_LOG_INITIALLY_SET)
 
 #define KVM_HAVE_MMU_RWLOCK
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 0576c2022ef5..d311637e0b13 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1173,10 +1173,20 @@ static int check_vcpu_requests(struct kvm_vcpu *vcpu)
 			return kvm_vcpu_suspend(vcpu);
 
 		if (kvm_dirty_ring_check_request(vcpu))
 			return 0;
 
+		/* Non-vhe systems already reload Stage2 on guest entry */
+		if (kvm_check_request(KVM_REQ_RELOAD_STAGE2, vcpu) &&
+		    has_vhe()) {
+			unsigned long flags;
+
+			local_irq_save(flags);
+			__load_stage2(vcpu->arch.hw_mmu);
+			local_irq_restore(flags);
+		}
+
 		check_nested_vcpu_requests(vcpu);
 	}
 
 	return 1;
 }
-- 
2.56.0

