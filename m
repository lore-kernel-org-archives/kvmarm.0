Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 173DF171A0
	for <kvmarm@lists.linux.dev>; Fri, 26 May 2023 14:33:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE7ADC4339B;
	Fri, 26 May 2023 14:33:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685111633;
	bh=6wNp/EjkCubmH4jSbimzQJEPlzEQpa08AFTUAXoa3iE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ChZ+h+1biz5GYn+nrKqEROEW40i5Jh2C2OLIBoOqR9Ht2+/jJGiO31dnOGDRO9oPP
	 HJLb0oLrBtMy5ScWVFdsLlPD2cG1lwxr2j/MD1C54BvgG1yuFvNrbMv4oKT6C7zmNT
	 J6gqRZUh67PNfO8ZL6sCYGEK56Va1KhTb8P7dY8VrD6rA44r8q/kgW7lkW/n7AfUMB
	 9Jvhb1Fy8AycoeC2bVlILM/uItqm3gBQ+IIjeRi4KQWRJywCaWBg2WCfEZTJ8J/Moo
	 YqPq6hedRQ3U9DXxjBUFCdP5xU+uFiGICa2vn+A8I15I/os5NBCXb4aVtjVv9A31/A
	 hFbDYZ286q9aQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1q2YVr-000aHS-K6;
	Fri, 26 May 2023 15:33:51 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Quentin Perret <qperret@google.com>,
	Will Deacon <will@kernel.org>,
	Fuad Tabba <tabba@google.com>
Subject: [PATCH v2 01/17] KVM: arm64: Drop is_kernel_in_hyp_mode() from __invalidate_icache_guest_page()
Date: Fri, 26 May 2023 15:33:32 +0100
Message-Id: <20230526143348.4072074-2-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230526143348.4072074-1-maz@kernel.org>
References: <20230526143348.4072074-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, qperret@google.com, will@kernel.org, tabba@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

It is pretty obvious that is_kernel_in_hyp_mode() doesn't make much
sense in the hypervisor part of KVM, and should be reserved to the
kernel side.

However, mem_protect.c::invalidate_icache_guest_page() calls into
__invalidate_icache_guest_page(), which uses is_kernel_in_hyp_mode().
Given that this is part of the pKVM side of the hypervisor, this
helper can only return true.

Nothing goes really bad, but __invalidate_icache_guest_page() could
spell out what the actual check is: we cannot invalidate the cache
if the i-cache is VPIPT and we're running at EL1.

Drop the is_kernel_in_hyp_mode() check for an explicit check against
CurrentEL being EL1 or not.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_mmu.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 27e63c111f78..c8113b931263 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -227,7 +227,8 @@ static inline void __invalidate_icache_guest_page(void *va, size_t size)
 	if (icache_is_aliasing()) {
 		/* any kind of VIPT cache */
 		icache_inval_all_pou();
-	} else if (is_kernel_in_hyp_mode() || !icache_is_vpipt()) {
+	} else if (read_sysreg(CurrentEL) != CurrentEL_EL1 ||
+		   !icache_is_vpipt()) {
 		/* PIPT or VPIPT at EL2 (see comment in __kvm_tlb_flush_vmid_ipa) */
 		icache_inval_pou((unsigned long)va, (unsigned long)va + size);
 	}
-- 
2.34.1

