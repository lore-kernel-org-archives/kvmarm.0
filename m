Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70F283DFC6C
	for <kvmarm@lists.linux.dev>; Thu,  4 Jun 2026 11:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780571902; cv=none; b=XDtIqd5Ox+C7qIhn99tw6WHutrE0uyao/7sUlUrGkw9ntRv+GGyvsIiScI1wxCrW5MnZRlE2pTdh3vrt3sVvhyNxIV+H3z9GjzjC+aCnJa3YPCh0D6YV4mGVF9oW+LQzaOHVcqTKEQeh33U7BhOU3y5bzOc/bcsLRVivlJCEGVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780571902; c=relaxed/simple;
	bh=oQQYnWM9INdi1ZTbqVbL5h4zBW7u4UBNoYl/OHAg2tQ=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=eaGpVKy+FJmDx8G/rCaenlZQ0kDYwRz7rjI1X+wazNdfADnj5czNA7r1qrO0M08wF3YBdqzU/yhgAgQnTWmAsTxvqcAS+TQqq4vj5xm9YqQKstC3bWMdzJNnm8L1X6yU8FVA3sDk2fUly0j/pQWz/R5Rw9l5WM0S4a6iveywiCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kGgInaQ5; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kGgInaQ5"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-8422524cb38so180584b3a.0
        for <kvmarm@lists.linux.dev>; Thu, 04 Jun 2026 04:18:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780571901; x=1781176701; darn=lists.linux.dev;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=E754gsHGdqu9cYnGBXFWaqxUdZJy8hipJqDVrahb1e4=;
        b=kGgInaQ53foTsz4FhAuCqm/3s5RXgVpH4ShcIBR36i5g6EsVWLVqV+TroaqCb+e9hK
         VuaBUV+RDsOXm8tqJiKoLBPWhmKLLYGjYmQFC+/iJ+oVaCVz6nPntKV9xNpWRO/E/INJ
         aVYnXYDNRQmbyk1p1FzLjWIbnGCKufiZVYUGjnCtulK/gw4AljVta5f99fJgzMi4Ix97
         IGvBo+uqjBpeJEeJ9c/vuNOeIJCpxnzXlmenc2WPT1ZX5gePbssu3SVj29yLXEVC74yd
         tldEjr9Y08+L6xpfQSOeikBygOHSLzVLlPmgR+JDg5yf68aMZNjMwekFNlgZPe8Z8zcG
         WbDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780571901; x=1781176701;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=E754gsHGdqu9cYnGBXFWaqxUdZJy8hipJqDVrahb1e4=;
        b=fHJJTEDSciJJFHZ/oO1THi8+MLqT3LpDtjGyqT37LT4ZNCJLnLxMRQ4husnyzDGO9f
         zokg9trW0EtGbZBer6s6/WuVWa15A6uU6HvC2h8IMGO4yb2GqaJRXsXgUZHKZxJyOc01
         ii/wf5k0wS4aTPcgmXIbKYvbbgkAvlsxGfejqM0dXLWKEmYSvJNGddm8NFC69FJtIV5A
         bs1VazgMYxxyT7mh7/P9ISEXi90nr2mn2la4hiUIbi99pm716vsFfaA1eds6CUmsHEqc
         GEWrWlqoDVah0m/UpIGPVGufUI51K8gB0D5orUVcnhOZ+8r1UBMl+7b3jSn6QiO8qQAb
         xORQ==
X-Forwarded-Encrypted: i=1; AFNElJ/VEwb+7snj8jwKh9GkFLa93htic3F7z10PzhyJEvu01gsoz+u8TO0/SzgRtuJ+c8BHKosc+YA=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy+ZFJVaKG1sRC++S3QUCHHoq3m38RzLEP43OrgsDztgrk8mOWY
	IUoq76CaC+ZM+AbG5RjZm72k4Gujs/puwGv077h9C7ih0cKH/UHjHKLY
X-Gm-Gg: Acq92OFaRYCaN41E5tQw0u+wGk/5vh/fSS3qH5h3loXsrgdPLA3OpgN9tlL9KjjqIwu
	oSw1orStAe3akygSb3toBV+7M9zxhz54ZI0GQPU5QHaH5spV+9auLLEcoSDw9Sk/hH7ezzxLNgr
	J3pwxw5U0UurltpmHFTbveI6y5CWn4s5zwveAfWVxYjbgai+8xpDwQNg4EaSsll77+ZJCx0TgRP
	yb/i9ryyEQn3fAZWSEIl9KVEMzu3rJqAYYTj20RC24+VgSdjHiz4YCdfKhKVYq9al+cGEWg71Y1
	2c+f3X27hVNWkVVEzxWdYydVCmScC4LIWVSUm6rq89ZiJByXD+2LAJr7mAcAuKlMyr3y3aok1j8
	PJaRyi9h08TlqVlSF72YsWvrodiKH1mHenF7cWrUAZ6y3sh/tSYfmyUSzDE6RX2BGlKEYZyZIQn
	y3yCYGjsKEzrnB9OYNKk0lv1sWGk+8PSMYXfWw+GnOwgMI7Zp4vYSpAA==
X-Received: by 2002:a05:6a00:3e12:b0:842:672e:7b5d with SMTP id d2e1a72fcca58-84284e32751mr7351126b3a.17.1780571900576;
        Thu, 04 Jun 2026 04:18:20 -0700 (PDT)
Received: from v4bel ([58.123.110.97])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-842828fa877sm5963698b3a.51.2026.06.04.04.18.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jun 2026 04:18:20 -0700 (PDT)
Date: Thu, 4 Jun 2026 20:18:16 +0900
From: Hyunwoo Kim <imv4bel@gmail.com>
To: maz@kernel.org, oupton@kernel.org, joey.gouly@arm.com,
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	imv4bel@gmail.com
Subject: [PATCH] KVM: arm64: Sanitise host vCPU fields in flush_hyp_vcpu()
Message-ID: <aiFe-CXo-XVTFz1g@v4bel>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

flush_hyp_vcpu() copies the host vCPU context and vGIC state into the
hyp's private vCPU on every run. ctxt_to_vcpu() expects a guest context
to have a NULL __hyp_running_vcpu, which is only ever set on the host
context, so that it resolves the vCPU via container_of(). The vGIC list
register save and restore expect used_lrs to stay within the number of
implemented list registers. While this is generally the case,
flush_hyp_vcpu() copies both fields verbatim from the host vCPU and
enforces neither expectation.

Fix by clearing __hyp_running_vcpu and clamping used_lrs after the copy.

Fixes: be66e67f1750 ("KVM: arm64: Use the pKVM hyp vCPU structure in handle___kvm_vcpu_run()")
Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
---
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 06db299c37a89..ef9318ff0c25e 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -7,6 +7,7 @@
 #include <hyp/adjust_pc.h>
 #include <hyp/switch.h>
 
+#include <asm/arch_gicv3.h>
 #include <asm/pgtable-types.h>
 #include <asm/kvm_asm.h>
 #include <asm/kvm_emulate.h>
@@ -128,6 +129,9 @@ static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
 
 	hyp_vcpu->vcpu.arch.ctxt	= host_vcpu->arch.ctxt;
 
+	/* A guest context must keep a NULL __hyp_running_vcpu. */
+	hyp_vcpu->vcpu.arch.ctxt.__hyp_running_vcpu = NULL;
+
 	hyp_vcpu->vcpu.arch.mdcr_el2	= host_vcpu->arch.mdcr_el2;
 	hyp_vcpu->vcpu.arch.hcr_el2 &= ~(HCR_TWI | HCR_TWE);
 	hyp_vcpu->vcpu.arch.hcr_el2 |= READ_ONCE(host_vcpu->arch.hcr_el2) &
@@ -139,6 +143,13 @@ static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
 
 	hyp_vcpu->vcpu.arch.vgic_cpu.vgic_v3 = host_vcpu->arch.vgic_cpu.vgic_v3;
 
+	/* Bound the host-provided used_lrs by the implemented list registers. */
+	if (static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
+		hyp_vcpu->vcpu.arch.vgic_cpu.vgic_v3.used_lrs =
+			min_t(unsigned int,
+			      hyp_vcpu->vcpu.arch.vgic_cpu.vgic_v3.used_lrs,
+			      (read_gicreg(ICH_VTR_EL2) & 0xf) + 1);
+
 	hyp_vcpu->vcpu.arch.pid = host_vcpu->arch.pid;
 }
 
-- 
2.43.0

