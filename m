Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 857E52D662F;
	Sat, 21 Mar 2026 21:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774128278; cv=none; b=ZzzoS/8boC+6n38xcDc3MKcb7Srdw7PIWvlcoDR2Uk6ZWkPSW8hdwPYKMSVQEm3zeDjzMeQm2U9zYh2hlT6zaixINYHEIezxcWZUX8WmjyC+Aur04/ah9yfgqA5tfDfFWWa6Z5+PoIkU1FN2zDRMb6ZoYh8LVaUqJiD3WB6ekpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774128278; c=relaxed/simple;
	bh=WQrWlxVg8SmXK8lkMbKrshFoo5+NBp6RYI0FqhBZNwI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h/3XSG3xdW/9RD7VOsp20Utb36stnek0hf8R3gZKaqOHgGQFyO+w9k8gE9wNxwoQY+8XZhEtm3sq4ZRpTPI3wV+irR0XZzVJqJRAFO6OJBW5Lz5hdGUzlfaNLTvwlKB7W31dA+pBFs9//XTLkMk8DlTFHWNnLoNMOj4E5orLh7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eVLxuQhu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eVLxuQhu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55C15C2BCB1;
	Sat, 21 Mar 2026 21:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774128278;
	bh=WQrWlxVg8SmXK8lkMbKrshFoo5+NBp6RYI0FqhBZNwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eVLxuQhuEcX1p7sqe9QYw/2blkhng8bVeDps796WgTk6wU8ZFu50SW/QHKsrB/N24
	 rXub3JS26UCNb3FNsDQ1ec7RDa2Lr2pCq3zfbTDorNTKSMwpYUl7nRWLmXKwMPRvvy
	 f1gsiOWOGqU5VzcZVSMNQ/LSyTgSdirUhdqkmSRhrMJOU2pZB0ZvFfMedFW2JfDfl6
	 Xpc+BD5yOQW1lPb1wvanxFvp6G61SIiWvbgoUd2Ar8pivFyvHlJ3xXA7oW3HqR5vsA
	 O6v4O3auASO1SU7+dUwdarnrS/ePbryuu7YTcd0Gj4NPBWxuqaAhYBg04src41soYx
	 +LEKHaV8HGnIA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1w43oC-00000004NPB-17gK;
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
Subject: [PATCH 2/5] KVM: arm64: pkvm: Simplify BTI handling on CPU boot
Date: Sat, 21 Mar 2026 21:24:16 +0000
Message-ID: <20260321212419.2803972-3-maz@kernel.org>
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

In order to perform an indirect branch to kvm_host_psci_cpu_entry()
on a BTI-aware system, we first branch to a 'BTI j' landing pad,
and from there branch again to the target.

While this works, this is really not required:

- BLR works with 'BTI c' and 'PACIASP' as the landing pad

- Even if LR gets clobbered by BLR, we are going to restore the
  host's registers, so it is pointless to try and avoid touching
  LR

Given the above, drop the veneer and directly call into C code.
If we were to come back from it, we'd directly enter the error
handler.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/host.S     | 10 ----------
 arch/arm64/kvm/hyp/nvhe/hyp-init.S |  9 +++++----
 2 files changed, 5 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/host.S b/arch/arm64/kvm/hyp/nvhe/host.S
index eef15b374abb0..465f6f1dd6414 100644
--- a/arch/arm64/kvm/hyp/nvhe/host.S
+++ b/arch/arm64/kvm/hyp/nvhe/host.S
@@ -291,13 +291,3 @@ SYM_CODE_START(__kvm_hyp_host_forward_smc)
 
 	ret
 SYM_CODE_END(__kvm_hyp_host_forward_smc)
-
-/*
- * kvm_host_psci_cpu_entry is called through br instruction, which requires
- * bti j instruction as compilers (gcc and llvm) doesn't insert bti j for external
- * functions, but bti c instead.
- */
-SYM_CODE_START(kvm_host_psci_cpu_entry)
-       bti j
-       b __kvm_host_psci_cpu_entry
-SYM_CODE_END(kvm_host_psci_cpu_entry)
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-init.S b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
index 5d00bde092010..55e0dce65dc56 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-init.S
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
@@ -213,12 +213,13 @@ SYM_CODE_START_LOCAL(__kvm_hyp_init_cpu)
 	mov	x0, x28
 	bl	___kvm_hyp_init			// Clobbers x0..x2
 
-	/* Leave idmap. */
+	/* Leave idmap -- using BLR is OK, LR is restored from host context */
 	mov	x0, x29
-	ldr	x1, =kvm_host_psci_cpu_entry
-	br	x1
+	ldr	x1, =__kvm_host_psci_cpu_entry
+	blr	x1
 
-	// The core booted in EL1. KVM cannot be initialized on it.
+	// The core booted in EL1, or the C code unexpectedly returned.
+	// Either way, KVM cannot be initialized on it.
 1:	wfe
 	wfi
 	b	1b
-- 
2.47.3

