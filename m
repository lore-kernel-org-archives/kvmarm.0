Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0E124519B3;
	Mon, 14 Sep 2026 12:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789388804; cv=none; b=RXMUhe5oohFU2/SMoQnd7Xu49McWDWGwFEv2eGOLdMAWWldCE2FwJ6lhx34w0lkGqVk/UCz8zpibmzKwTlhMu/xRvKVsTtzq65DZMbYZjnI4YIAh7jk/SpAid3xHdH6oTv/5YyeMz1oz7pwBJ8XV3SMB/JOBiRK+IevHf0G3Bg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789388804; c=relaxed/simple;
	bh=FkM4itvypge8Pbdv2hNT3etSW8HCq6WaKSFba5FDN3g=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=UEXOJkPWBMBrzEc8AvKhsnpqulfre8kmdxCF/zdB6PCqC6TyrwJGzopYJEUATZTyiD3byzyi0DGB1joOYe7yDYQK0QzfbvKyWIIx+n4FSBlJgnYqPA90zfjhmm7qAjdWIJ5FuJKfS54BVFMcT5ZM7UPJTtIl6cEcACASJVEFNZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=evBgVX9f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="evBgVX9f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F11201F00893;
	Mon, 14 Sep 2026 12:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789388802;
	bh=IltVU/Tm8cDWFzMWlzQM5EZpC+rhcddrPgEAjZb7DaQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=evBgVX9fcgctqjU/P4XLiikqSwC3qJATbp1xuK0PDwxm6u/W7htpP8UpqTrCABPzI
	 qMP8MUGiPYv1A/E8mgbWkRakxNRFRrF1ms8HdfeRnR6lnvHNNRnBLQ1edf8Wp1fQoy
	 Irbl3a3yeoeErjBBDfodEwVP0JOnMTE416m0/CF7duUHBzy2oEK0zO8SMgtsejoVOT
	 dxpHB+/RP9NwrsHoQWOIIFMCHmns3Dj5kuD8U8LR5/bsqCYAGPVK9FpeZbZtZClqfS
	 GOLRYyV00Vti9L39D31cytbIKFH2sIf3+IsnVAYPvFiYhfgLgYo/xG7qs6S4XTrHmX
	 2ZP6iUNJMrNxg==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Mon, 14 Sep 2026 13:26:12 +0100
Subject: [PATCH v2 01/13] arm64: Add ESR fault helpers
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260914-kvm-arm-prefault-v2-1-26fb47f74b73@kernel.org>
References: <20260914-kvm-arm-prefault-v2-0-26fb47f74b73@kernel.org>
In-Reply-To: <20260914-kvm-arm-prefault-v2-0-26fb47f74b73@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Oliver Upton <oupton@kernel.org>, Fuad Tabba <tabba@google.com>, 
 Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, Paolo Bonzini <pbonzini@redhat.com>, 
 Jonathan Corbet <corbet@lwn.net>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, Jack Thomson <jackabt@amazon.com>, 
 Jack Thomson <jackabt.amazon@gmail.com>, 
 Alexandru Elisei <alexandru.elisei@arm.com>, 
 Vincent Donnefort <vdonnefort@google.com>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Sean Christopherson <seanjc@google.com>, 
 Claudio Imbrenda <imbrenda@linux.ibm.com>, 
 Leo Soares Passos <Leo.Bras@arm.com>, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2048; i=ljs@kernel.org;
 h=from:subject:message-id; bh=FkM4itvypge8Pbdv2hNT3etSW8HCq6WaKSFba5FDN3g=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLKWP/8SOunBN559SX9WX5hiINcvMcuk9NwJpzN8690FV
 KMFtnFO7yhlYRDjYpAVU2R5/kV8f5BI2LzOC/5uMHNYmUCGMHBxCsBEjNYw/He+Jlh/cNXL/lW+
 xUvsxPgnK5YtLT/xbodZUeC9debPl7oyMnw85LPo450cJbagUvHrrWGBG632f1XerR52Qmd9wdI
 5N7kA
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

