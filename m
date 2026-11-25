Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.167
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621230;
	b=a50I9PBnY8Pv4DMNRZyLXNOWTfHo3baQDgK7K1J33FvQzBanpgx7Y78UxT1ZprA8x4Fl
	 QfF7/zPbNbvoynYwtsHHHGG+Lj1r2g1HiIaA5DpMQ+pg5iMQnPoGaYBG/LrniJvKdkFyM
	 ddtJmA+vn3l/pcs/YZ3vRb0WQiaMa9ZjcRo7hTmrHP15xpWHLonbKz38EadozofAfPTNq
	 I2zAh/PpTMdFiPH0r1SUkEeWMxDhbrc0feuDplidzcd/L4A3pvd5mAJga0Ru07G+216ze
	 252Lwy66hK6imL2SRyllWJhjEkbwpcX2+mVCwAHkU7hhEX+LNiUWIhlWbeEjb4RNKdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621230;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=4KD70GwKCbIo3iYnYiAxROa7nQMR8jUs46uCrYPzsEc=;
	b=vghdLSMK2bLDWHZoibhOWBxcW2R74XBIx9B6xrz0krF0lFgAFL0kLT8ebuoSuoR0HLN/
	 lMHZ6BIE+y4f7zmjBxde6BdLtVNMFH1s5DslQAbMV1xvjUpiAb46hddP5G8r2qPb90a1l
	 uzZxipu9v6FFGAwpb0lBWZgVv70QolqJQ5yw7zsokffjQn5xguFCfhekAxB9X0/JSh+YR
	 SO3fad6/Tk5Al1NW+NJ6rzhrZiXdnkG3Y7qbEuKduxe+KKvSHj70QD1kLo8ew2cJWkIwl
	 qSVb7GEcSQrqslgJLIRX5ZNvhUhkSJ0svovsr3tO1zZGDoo8V7VXtIAZq3JcrIfkHzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=BLj1maW0;
	arc=none smtp.remote-ip=95.215.58.167
Received: from mta1.migadu.com (out-167.mta1.migadu.com [95.215.58.167])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57E6C606B39B
	for <kvmarm@lists.linux.dev>; Wed, 25 Nov 2026 15:40:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 57E6C606B39B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=BLj1maW0
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=Ru4wsoPUBX8BwclDhrROzB4V6cI3IIahsVXty7NCsP0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795621227; v=1; x=1796226027;
 b=BLj1maW0hYMd/HYCkSc3lu+HHxonpoaNiLJZLmrKqhCi9qn6NhsVPJykaJt33Jf1J2knwXEo
 30h+lCggdkjlCskmEPkG+/6t9KdoJapuVRsOuB4CcmJ8T66xFtSLnomVuLM24962y0uJhVgRQfj
 kMzaheiPRrj8BSRXil3bEFr4=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 16cf6cf1af7bb7dd;
	Wed, 25 Nov 2026 15:40:26 +0000
X-Mizu-Trace-ID: 16cf6cf1af7bb7dd
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Fuad Tabba <tabba@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 14/20] KVM: arm64: Advertise FPMR to protected VMs
Date: Wed, 25 Nov 2026 15:39:05 +0000
Message-ID: <20261125153911.106793-15-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261125153911.106793-1-fuad.tabba@linux.dev>
References: <20261125153911.106793-1-fuad.tabba@linux.dev>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Advertise FEAT_FPMR to protected VMs, and reset FPMR to 0 as KVM does
for a non-protected vCPU. With the field set, vcpu_set_hcrx() sets
HCRX_EL2.EnFPM for them, and FPMR is switched with the rest of the FP
state.

Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/hyp/nvhe/sys_regs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
index acba7489809f3..4ba947bd3d125 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -127,6 +127,7 @@ static const struct pvm_ftr_bits pvmid_aa64pfr1[] = {
 
 static const struct pvm_ftr_bits pvmid_aa64pfr2[] = {
 	MAX_FEAT(ID_AA64PFR2_EL1, GCIE, NI),
+	MAX_FEAT(ID_AA64PFR2_EL1, FPMR, IMP),
 	FEAT_END
 };
 
@@ -828,6 +829,7 @@ static const struct sys_reg_desc_reset pvm_sys_reg_reset_vals[] = {
 	RESET_UNKNOWN(TTBR1_EL1),
 	RESET_UNKNOWN(FAR_EL1),
 	RESET_VAL(VBAR_EL1, 0x1de7ec7edbadc000ULL),
+	RESET_ZERO(FPMR),
 };
 
 void kvm_reset_pvm_sys_regs(struct kvm_vcpu *vcpu)
-- 
2.47.3

