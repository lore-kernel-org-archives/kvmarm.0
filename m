Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D199200C6
	for <kvmarm@lists.linux.dev>; Fri,  9 Jun 2023 16:22:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13C88C433A1;
	Fri,  9 Jun 2023 16:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686327731;
	bh=jTsm32MCUnOGraMWZ9kT4/kHOKFUxtgEvgqjHx4EAyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q2sHLaqpJbyUUpm0EgO0nZkz7wyxYIVstwAFSUqjeafV3YVsyg1VhJaiFZrIAkIuh
	 wKMMrvlmrnZHgWubmM6ztT0kvgm2IAdICtdnNy2HbVqjGl71r+QnEcW7HB/tD8BeQ2
	 r2SJoG16aXoWfZlSUNauYKhLEu6neWfxNxYDJHoPefA/+58aqTiGwArBEX7UJxjxYf
	 Eg5SDqVXmFXfnBOvIJSHMiRdy1vRxR4rCDdUXrtEPohowhSaUa+JIFQGbSIE8kQHr1
	 Wtor3w7kbKl2qR96mxtWokN07MenmNTR3ACN4UZu/mRDQTfhB8buEJjm10GimFp7ZE
	 ssv9JDTU5Tyag==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1q7esK-0048L7-RF;
	Fri, 09 Jun 2023 17:22:08 +0100
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
Subject: [PATCH v3 02/17] arm64: Prevent the use of is_kernel_in_hyp_mode() in hypervisor code
Date: Fri,  9 Jun 2023 17:21:45 +0100
Message-Id: <20230609162200.2024064-3-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230609162200.2024064-1-maz@kernel.org>
References: <20230609162200.2024064-1-maz@kernel.org>
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

Using is_kernel_in_hyp_mode() in hypervisor code is a pretty bad
mistake. This helper only checks for CurrentEL being EL2, which
is always true.

Make the compilation fail if using the helper in hypervisor context
Whilst we're at it, flag the helper as __always_inline, which it
really should be.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/virt.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/virt.h b/arch/arm64/include/asm/virt.h
index 4eb601e7de50..21e94068804d 100644
--- a/arch/arm64/include/asm/virt.h
+++ b/arch/arm64/include/asm/virt.h
@@ -110,8 +110,10 @@ static inline bool is_hyp_mode_mismatched(void)
 	return __boot_cpu_mode[0] != __boot_cpu_mode[1];
 }
 
-static inline bool is_kernel_in_hyp_mode(void)
+static __always_inline bool is_kernel_in_hyp_mode(void)
 {
+	BUILD_BUG_ON(__is_defined(__KVM_NVHE_HYPERVISOR__) ||
+		     __is_defined(__KVM_VHE_HYPERVISOR__));
 	return read_sysreg(CurrentEL) == CurrentEL_EL2;
 }
 
-- 
2.34.1

