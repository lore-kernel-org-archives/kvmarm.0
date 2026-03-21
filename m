Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 987042D8795;
	Sat, 21 Mar 2026 21:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774128278; cv=none; b=DrN6RAq+XziOJH4Nih9YkQIWiOA28g8XkCRVRlWlFI4RUgJsR47cOS2e0a2nnQYLkeVaQHGONh2XwFJk0la6dFkxYvUUOVnfxcXnxRZWyZglwcU4VPw28nCpwih1Ie5ZoIehua58oJukf8kZUH2jvExt1XU0RjV69nNIzsZksE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774128278; c=relaxed/simple;
	bh=563KpVrS+TBFZhl7NDTIVcn4JaQQA/lY4T69GmEGAJQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k1VuQVgXyVvuPH+kqo4Q6fT8mkFG76aW1ZI4iHGvNXDKBfCqU6QskknRk1aeBWmMe2wy4q8KpKLGPwc3R5MiOYVCJvYLFqlOIcQWb3pYHBvx+VvRlCy/UPkLX10GVJbPf8J6CBUtuqfIrkr1t+Bawb7nahDS/JZAPgtQV+nvAdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KaxzJYJv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KaxzJYJv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E13FC4AF09;
	Sat, 21 Mar 2026 21:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774128278;
	bh=563KpVrS+TBFZhl7NDTIVcn4JaQQA/lY4T69GmEGAJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KaxzJYJvUQ9i86qn3WyL7zPGIeenArehJKCmcRaLjCCdI4n/CchImuOdIdFuAJ4eE
	 xQjdbMEzv+Ef6eI8J6ocjZwBk9U9NqX49lc2kx74FXvPDBT3H7JWhWe9KqAxKaEilO
	 i94n525sEKGlVTGxr3U2nwHH7c1aVE9WKI5oKVPpSwfGhPnIFQ/kfBFAG8s918p7s5
	 zYhJKTKYOUy/VuW/vmKG8JvO2VmZMtW1R/aatuCGKl1vI104iDmoZOxy8Lr0iSY4r1
	 tnFYaVTVBmaIU5hA+Q9Nvt1gfVMkL5gHmttwvQPs6oMESg+nYJzTWSs2LRn+woIYcn
	 l6KBvRPrdQiqA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1w43oC-00000004NPB-01kj;
	Sat, 21 Mar 2026 21:24:36 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Fuad Tabba <tabba@google.com>,
	Will Deacon <will@kernel.org>,
	Mostafa Saleh <smostafa@google.com>,
	Quentin Perret <qperret@google.com>
Subject: [PATCH 1/5] KVM: arm64: pkvm: Move error handling to the end of kvm_hyp_cpu_entry
Date: Sat, 21 Mar 2026 21:24:15 +0000
Message-ID: <20260321212419.2803972-2-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260321212419.2803972-1-maz@kernel.org>
References: <20260321212419.2803972-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, tabba@google.com, will@kernel.org, smostafa@google.com, qperret@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

We currently handle CPUs having booted at EL1 in the middle of
the kvm_hyp_cpu_entry function. Not only this adversely affects
readability, but this is also at a bizarre spot should more
error handling be added (which we're about to do).

Move the WFE/WFI loop to the end of the function and fix a comment.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/hyp-init.S | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-init.S b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
index 0d42eedc7167c..5d00bde092010 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-init.S
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
@@ -201,14 +201,9 @@ SYM_CODE_START_LOCAL(__kvm_hyp_init_cpu)
 	/* Check that the core was booted in EL2. */
 	mrs	x0, CurrentEL
 	cmp	x0, #CurrentEL_EL2
-	b.eq	2f
-
-	/* The core booted in EL1. KVM cannot be initialized on it. */
-1:	wfe
-	wfi
-	b	1b
+	b.ne	1f
 
-2:	msr	SPsel, #1			// We want to use SP_EL{1,2}
+	msr	SPsel, #1			// We want to use SP_EL2
 
 	init_el2_hcr	0
 
@@ -222,6 +217,11 @@ SYM_CODE_START_LOCAL(__kvm_hyp_init_cpu)
 	mov	x0, x29
 	ldr	x1, =kvm_host_psci_cpu_entry
 	br	x1
+
+	// The core booted in EL1. KVM cannot be initialized on it.
+1:	wfe
+	wfi
+	b	1b
 SYM_CODE_END(__kvm_hyp_init_cpu)
 
 SYM_CODE_START(__kvm_handle_stub_hvc)
-- 
2.47.3

