Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCC055427F9;
	Tue, 22 Sep 2026 14:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790086704; cv=none; b=u1MmbB/S/IG+NVY4x8eZq0ipDjKwwc61OCiR3YBq0mi6dglCwa7Q1uPywWjWhWt1kR3sS2bC/g8OtQ3D4F1IyAeEaSi2K3srbWVbPymHGNEaYV4/kLBvVlawkW0ky4BiICadtWuXgm3a3SnEZ3HZupoWgeqSl7RCfBIVh54ZHq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790086704; c=relaxed/simple;
	bh=FkM4itvypge8Pbdv2hNT3etSW8HCq6WaKSFba5FDN3g=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=HKIl2XxlomB5EH8lbX93syzaX1QWYdz8MRfBZxfXGOthLNmeT5She/HWl6pL7eYmgjhJhtdWXvsHBqLf0wVkf0oUsgav2pbMrydsVlxRCbwET8VlsNqD78lFLESjcwZgDoPBL8fgigVplNZ8KboQ4dpc/WNfQIb/FFlun+xtYw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WCX+1zzi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WCX+1zzi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41CFD1F00898;
	Tue, 22 Sep 2026 14:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790086702;
	bh=IltVU/Tm8cDWFzMWlzQM5EZpC+rhcddrPgEAjZb7DaQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=WCX+1zziOqvwnSDV0CrvCAt9PRPizag4cgOjWKj/kGemqc/tQZ7EHtnsGB9+0zVFT
	 6FxbvPriCQ+57wp1Qrbx8YHOSY64EC2bY1LiUjWxhAUOOHWs2hxJ2Z0oPBlVjOYANF
	 E4Rz3r5hIDuNqXQ/5cMcG/2rQv3oC4XL4/Vdhn3l8xRb62RedMmWrAlLudNSIehcZl
	 tz5v8M0mXwnBw9SP451CY79iP56g4eRSyiT+HahWrE/k+wdXB7z119Skbxr9zNcn6u
	 YcGGO46LjaAAH358HOhZl2yGf+/RjZle2uuomOCRdZ1vLeeO2ozxlkigBCXeWPYUvs
	 GLl+gpHO+ZcGA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 22 Sep 2026 15:17:56 +0100
Subject: [PATCH v3 02/14] arm64: Add ESR fault helpers
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260922-kvm-arm-prefault-v3-2-787bd3bc7e3f@kernel.org>
References: <20260922-kvm-arm-prefault-v3-0-787bd3bc7e3f@kernel.org>
In-Reply-To: <20260922-kvm-arm-prefault-v3-0-787bd3bc7e3f@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
 Steffen Eiden <seiden@linux.ibm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, Paolo Bonzini <pbonzini@redhat.com>, 
 Jonathan Corbet <corbet@lwn.net>, Mark Rutland <mark.rutland@arm.com>, 
 Fuad Tabba <fuad.tabba@linux.dev>, Randy Dunlap <rdunlap@infradead.org>, 
 Fuad Tabba <fuad.tabba@linux.dev>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, Jack Thomson <jackabt@amazon.com>, 
 Jack Thomson <jackabt.amazon@gmail.com>, 
 Alexandru Elisei <alexandru.elisei@arm.com>, 
 Vincent Donnefort <vdonnefort@google.com>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Sean Christopherson <seanjc@google.com>, 
 Claudio Imbrenda <imbrenda@linux.ibm.com>, 
 Leo Soares Passos <Leo.Bras@arm.com>, Wei-Lin Chang <weilin.chang@arm.com>, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2048; i=ljs@kernel.org;
 h=from:subject:message-id; bh=FkM4itvypge8Pbdv2hNT3etSW8HCq6WaKSFba5FDN3g=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLI29Uk0PzCI5K5XY7D60CleH2wneruGS2ZxXuSNv+dve
 7476OTTUcrCIMbFICumyPL8i/j+IJGweZ0X/N1g5rAygQxh4OIUgIkkZzEynOi/PuFDxl/FWtml
 B6sfu628rrh6USmDlbDt4U9uXVkcsxn+6eV8SFpYtpy3Tijj5/YEdaGjov9uRiV4bn4rsbcn9t0
 9TgA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14

Add helper functions which operate directly on an ESR value rather than
trying to access the register itself.

These mirror equivalent KVM vCPU wrappers in kvm_emulate.h and allow those
wrappers and KVM's stage-2 fault handling to operate on a plain ESR value.

This is needed to later generate a synthetic fault for the stage-2 page
table pre-faulting mechanism.

No functional change intended.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 arch/arm64/include/asm/esr.h | 44 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
index f816f5d77f1a..9c0205983d9a 100644
--- a/arch/arm64/include/asm/esr.h
+++ b/arch/arm64/include/asm/esr.h
@@ -437,6 +437,50 @@
 #ifndef __ASSEMBLER__
 #include <asm/types.h>
 
+static __always_inline u8 esr_get_ec(unsigned long esr)
+{
+	return ESR_ELx_EC(esr);
+}
+
+static __always_inline bool esr_trap_is_iabt(unsigned long esr)
+{
+	return esr_get_ec(esr) == ESR_ELx_EC_IABT_LOW;
+}
+
+static __always_inline bool esr_abt_is_s1ptw(unsigned long esr)
+{
+	return esr & ESR_ELx_S1PTW;
+}
+
+/* Always check for S1PTW *before* using this. */
+static __always_inline bool esr_dabt_is_write(unsigned long esr)
+{
+	return esr & ESR_ELx_WNR;
+}
+
+static __always_inline bool esr_dabt_is_cm(unsigned long esr)
+{
+	return esr & ESR_ELx_CM;
+}
+
+static __always_inline bool esr_abt_is_exec_fault(unsigned long esr)
+{
+	return esr_trap_is_iabt(esr) && !esr_abt_is_s1ptw(esr);
+}
+
+static __always_inline bool esr_abt_is_sea(unsigned long esr)
+{
+	switch (esr & ESR_ELx_FSC) {
+	case ESR_ELx_FSC_EXTABT:
+	case ESR_ELx_FSC_SEA_TTW(-1) ... ESR_ELx_FSC_SEA_TTW(3):
+	case ESR_ELx_FSC_SECC:
+	case ESR_ELx_FSC_SECC_TTW(-1) ... ESR_ELx_FSC_SECC_TTW(3):
+		return true;
+	default:
+		return false;
+	}
+}
+
 static inline unsigned long esr_brk_comment(unsigned long esr)
 {
 	return esr & ESR_ELx_BRK64_ISS_COMMENT_MASK;

-- 
2.55.0

