Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41AE6261F4
	for <kvmarm@lists.linux.dev>; Fri, 26 May 2023 14:33:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63449C433AC;
	Fri, 26 May 2023 14:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685111634;
	bh=Eb4P+yvkDgqtafWekJ5k0MGdRtAE8LRnoYczU5+CLgY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U+jbSdpAnVTx8gdgO3M4sW3Ek2fLcruyosOEdOe7fjRZRa+ZxHEcQwXsjOm/iFbP2
	 TxCE651RXucpnzPekydl4mAPYIkT91kRayQoQZ9OCW89vQhrdH5epwUGW7qPMFxj1i
	 VSH05iaXKPpL1CCReAmV1iE/2bchMxOYAdRpe2Ie4nQXHtccFzMEROGpEgtWnTt8uM
	 8STSXnRusIYeJLTcOIRN/tGwqkmHobacKE7k00aFUy3+osVAU/h2EoYBfC7ceMJEeZ
	 t4kZHDjPDKbnQjBYCLab1EnGtLzA7pYtNv56bhnYkZg8bllwFH/VU94P3nhyGRa6j8
	 Qtk1IxmN3hQnQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1q2YVs-000aHS-Je;
	Fri, 26 May 2023 15:33:52 +0100
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
Subject: [PATCH v2 05/17] arm64: Don't enable VHE for the kernel if OVERRIDE_HVHE is set
Date: Fri, 26 May 2023 15:33:36 +0100
Message-Id: <20230526143348.4072074-6-maz@kernel.org>
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

If the OVERRIDE_HVHE SW override is set (as a precursor of
the KVM_HVHE capability), do not enable VHE for the kernel
and drop to EL1 as if VHE was either disabled or unavailable.

Further changes will enable VHE at EL2 only, with the kernel
still running at EL1.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kernel/hyp-stub.S | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/hyp-stub.S b/arch/arm64/kernel/hyp-stub.S
index 9439240c3fcf..5c71e1019545 100644
--- a/arch/arm64/kernel/hyp-stub.S
+++ b/arch/arm64/kernel/hyp-stub.S
@@ -82,7 +82,15 @@ SYM_CODE_START_LOCAL(__finalise_el2)
 	tbnz	x1, #0, 1f
 
 	// Needs to be VHE capable, obviously
-	check_override id_aa64mmfr1 ID_AA64MMFR1_EL1_VH_SHIFT 2f 1f x1 x2
+	check_override id_aa64mmfr1 ID_AA64MMFR1_EL1_VH_SHIFT 0f 1f x1 x2
+
+0:	// Check whether we only want the hypervisor to run VHE, not the kernel
+	adr_l	x1, arm64_sw_feature_override
+	ldr	x2, [x1, FTR_OVR_VAL_OFFSET]
+	ldr	x1, [x1, FTR_OVR_MASK_OFFSET]
+	and	x2, x2, x1
+	ubfx	x2, x2, #ARM64_SW_FEATURE_OVERRIDE_HVHE, #4
+	cbz	x2, 2f
 
 1:	mov_q	x0, HVC_STUB_ERR
 	eret
-- 
2.34.1

