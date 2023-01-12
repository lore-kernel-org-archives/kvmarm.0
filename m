Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A3738476
	for <kvmarm@lists.linux.dev>; Thu, 12 Jan 2023 19:22:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02B62C433EF;
	Thu, 12 Jan 2023 19:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1673551333;
	bh=qX6kFn4drXf+CIvAA1Y06km8c3x99tuygfzIwXioExs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lXR2PMNBj2rqaNQLIIn7vjusVUQmauGJSMmzEU8v6jJ4RQFGyFWEwHSJzK9NxYUXK
	 1wfy9nu0NUM1WLdHwPz6LY7SJlvKObj7opYtk9Rkk8BjXw+U4+O4ZiYw7OMHIXv9QE
	 wOox0rhDKwlFCM5RJNaoFcVLORA8IG6FVaTaixkxA3fr3R+CAOmXckemJELkonOCUW
	 Api8BpZiXN7Tia6/Gb+zXGdGDH22xCRFQD+woj2frT8NLd3HRDf3Rc8Vmd07AI1PTU
	 h0fBohRKAdJ58aX5LmIHwTYLTZwqeSRfkAKhAQznlRCh5vbyOG2FYYhC8yFSVIyqiJ
	 9uagdh2vw6DoQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1pG375-001IWu-53;
	Thu, 12 Jan 2023 19:19:47 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Alexandru Elisei <alexandru.elisei@arm.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Chase Conklin <chase.conklin@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Jintack Lim <jintack@cs.columbia.edu>,
	Russell King <rmk+kernel@armlinux.org.uk>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v7 31/68] KVM: arm64: nv: Only toggle cache for virtual EL2 when SCTLR_EL2 changes
Date: Thu, 12 Jan 2023 19:18:50 +0000
Message-Id: <20230112191927.1814989-32-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230112191927.1814989-1-maz@kernel.org>
References: <20230112191927.1814989-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, alexandru.elisei@arm.com, andre.przywara@arm.com, chase.conklin@arm.com, christoffer.dall@arm.com, gankulkarni@os.amperecomputing.com, jintack@cs.columbia.edu, rmk+kernel@armlinux.org.uk, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

From: Christoffer Dall <christoffer.dall@linaro.org>

So far we were flushing almost the entire universe whenever a VM would
load/unload the SCTLR_EL1 and the two versions of that register had
different MMU enabled settings.  This turned out to be so slow that it
prevented forward progress for a nested VM, because a scheduler timer
tick interrupt would always be pending when we reached the nested VM.

To avoid this problem, we consider the SCTLR_EL2 when evaluating if
caches are on or off when entering virtual EL2 (because this is the
value that we end up shadowing onto the hardware EL1 register).

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_mmu.h | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index e4a7e6369499..2890d57bec30 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -115,6 +115,7 @@ alternative_cb_end
 #include <asm/cache.h>
 #include <asm/cacheflush.h>
 #include <asm/mmu_context.h>
+#include <asm/kvm_emulate.h>
 #include <asm/kvm_host.h>
 
 void kvm_update_va_mask(struct alt_instr *alt,
@@ -192,7 +193,15 @@ struct kvm;
 
 static inline bool vcpu_has_cache_enabled(struct kvm_vcpu *vcpu)
 {
-	return (vcpu_read_sys_reg(vcpu, SCTLR_EL1) & 0b101) == 0b101;
+	u64 cache_bits = SCTLR_ELx_M | SCTLR_ELx_C;
+	int reg;
+
+	if (vcpu_is_el2(vcpu))
+		reg = SCTLR_EL2;
+	else
+		reg = SCTLR_EL1;
+
+	return (vcpu_read_sys_reg(vcpu, reg) & cache_bits) == cache_bits;
 }
 
 static inline void __clean_dcache_guest_page(void *va, size_t size)
-- 
2.34.1

