Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795094770;
	b=oeL87gHelwEcm8cSaqj29OxMRO1recycBPbYiyfWgzl9Y/R+JM37lbQ8Ke/rIabzPugT
	 RMTPQKtaPSaPltoCjPBdJXR898f+R8Bb0XAen9IuQz7O3mb8pqc34YQArqAd/6yPfvHfX
	 66/6FCKJbSFDukKpXmpZMI2ebB+noYMyC2ncDAMI1mBdofDLfJI4R0cbRr8RJgcGrGvNq
	 WtBoXL0y51ozhPO/qVWdcqZ4AM1GNsV9zo5XTqOlQkoUlsOifHEDvxlNuZqV4XhQxMzaC
	 QnbgP5pbeSoAm6IJcHKIakuSz2p/umFoVcfyrfFkMcxJNZMcUUGtaGWQUBIyRM3A1ZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795094770;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer;
	bh=ntk4mAK9p6PJOEu3vzXljUNzscjCYNCzCNuBX536B0c=;
	b=F/NHncyCf/2Tpw+x3eij43SqyUhmE66gAGLy+HqK8tIWHmXn8Gp8fjKLdKJ7f16VqRpp
	 +HUGE53O8GA2t5mHW3ga0S1m4HS58ONGeM8+wUpeBgtlOoFY3VctTVUgjMHzoPq3XvLgK
	 MBh4JDV6X6d8wCf2E8EbUQ7/rzQrUPfuVJiRoADJsO9BJUh6f5kb9havQXOlWTk5LIDzN
	 0wNacOBFpa6lFOjh3IOM+fL59v2XDlYV5dePRGhaakf5xGj5wwSnpIU7z9trxq7IitYxM
	 H7+5xhBtYKxKkMXBSBMRtdWXmU4NxsfDjHTB3wC/s0oiPkA3O1MZFqopBNfg8vOh/Nw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=pereq.eu;
	spf=pass smtp.mailfrom=cryspen.com;
	dkim=pass header.d=pereq.eu header.i=@pereq.eu header.a=rsa-sha256 header.s=google header.b=Uzl8fCzD;
	arc=none smtp.remote-ip=209.85.221.50
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2347606A320
	for <kvmarm@lists.linux.dev>; Thu, 19 Nov 2026 13:26:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E2347606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pereq.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cryspen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pereq.eu header.i=@pereq.eu header.a=rsa-sha256 header.s=google header.b=Uzl8fCzD
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-49a92144733so1071612f8f.0
        for <kvmarm@lists.linux.dev>; Thu, 19 Nov 2026 05:26:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pereq.eu; s=google; t=1795094768; x=1795699568; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ntk4mAK9p6PJOEu3vzXljUNzscjCYNCzCNuBX536B0c=;
        b=Uzl8fCzD6ReBkohzBmyRsE1+SrY8h6P7dbDGCUYAPaQyI7ewhJ71pz0TOtUHqwzK2w
         aHS93vHISh9hQJ5hkPL5Swp26ZzDwn57d+NmrHo7d2he0m6o/oXW5PTmPM2ISOdrSeP/
         lkzk/zy9jLoKgiNtVpdNVy/jxHeTwB7NYwxQ8nnEyvoeLBi+0V6AMnYhQQPdy/3gaYAh
         JskuNx2x5bOyBW7VGYgmIEoU028b50oYIqQXsPFjrlx9nHjJ74ji5X2WbeW9tfhupYAn
         +bwYOVSmFHjTv8Eg5Ulp7Cwhj5Mpv0XykS6H5JoKxSvI1fXPtHdGZECKGWmIYj0TVa2C
         zRNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795094768; x=1795699568;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ntk4mAK9p6PJOEu3vzXljUNzscjCYNCzCNuBX536B0c=;
        b=ewlE2QDfYKldCkgx99ZVEZ0B1GoY1O8/4w6ExzN/65vKug8xevgU+Fw317xVX0DrTC
         FHlDMRjkF5ggmxixaJOR3W8kK+mSkiwpSWF35xFinOP1v0Ce28uqYolIN0g+0q28ipX7
         dYGkqF7/1k/jdVLmeUWFv7QaTagzYxifckn7OnS87/M7okcSAbbyeG0S6bvJnn0g0/S8
         O4UiWdm2LQBqtbic/ZKeC1OiGctBSs/n7LEhxTVXs1xJ6f6TclBY9YnbODeDWG6i8RJb
         De27pzAGBVhDSm5TDoy49kG9KlNqkVA0Etrz1s1T/Rw9N0UpE/rd5xAzO6G7RUgajgqe
         +jgg==
X-Forwarded-Encrypted: i=1; AL+hErFUagTRZAaldehM41sR98xe5kBcTjvQqIbfxmySt+WDFg+eRYKhnwN+IZXi4M5qSXkYyl7SRBI=@lists.linux.dev
X-Gm-Message-State: APuU4Z+yGX46CDKQOu+y4T18sdgy6siSwS7m59w+2qrOBVZhucxiXTg1
	ZImsgqgXsOd2YfhkqIrh2t+HbI7qOmYiJCL4PE4Ue5baaD79mh3Rcgmx6r0FlKzAxLg=
X-Gm-Gg: AZFdTZetatNWahNN3zuxHfA4vpEEBUIhDU6qyjQ4cAsYNMg2T5yFpRr2u+lEaQvdOri
	yd9UH0f6/zQCb/P15+FxJJwYynAjxPl0TxE/UzIMVxoY5xewTDQwDrdQoXYQi0T1KGJze4JWGSh
	Yhdu0eS2LVo5qCbq2n+hUqXnW0TpenLcK3gI/i1Vxwz73ZunEk2hdsQpjieCdixHG6swjNB6J3y
	W/fFFixf4maeSr8lkyGh/aN5WOxK9cVkdjBtQrMWXYvN1uNEdB12WXLIFj1JkNpxCxkwTQYgJ8C
	1O/8pZTDBL9h24Ma28yEE4pVXDx48qKClRANLsurdP69Bp1enMrlIuIqFd9hKIEmvWsiuLA4gvD
	MT/qvMAm5brPWnRD3YQlgP12PWgLa4mju6spCf3y8r6PXQnhDEU1L3+0Dw/fXWsUvCDMUt7IjO2
	0A/m/mNGouH/+bQWemNFM9hK6wKdgFfUuqfJ9lCyVHC7+qK6fQlpM1qwrlQ4z0sf4S3cuFiLW42
	UfZURY1ZlyUEACoufDbnSW9PC4kjkMDhaw3C6fUQD0iImMHt9ghjitT60MO8XssXXFZSCPaDGc1
	djUYginlHB4w0ek7Qio=
X-Received: by 2002:a05:6000:2210:b0:4a7:790c:4a56 with SMTP id ffacd0b85a97d-4a7790c4b2fmr10368485f8f.33.1795094768046;
        Thu, 19 Nov 2026 05:26:08 -0800 (PST)
Received: from localhost ([2c0f:3d00:6be:8900:ce5e:9212:ea4b:f30])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4a6573baa9fsm11452563f8f.57.2026.11.19.05.26.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2026 05:26:07 -0800 (PST)
From: Dan Carpenter <dan@pereq.eu>
Date: Thu, 19 Nov 2026 16:25:36 +0300
Subject: [PATCH v2 3/4] KVM: arm64: nv: Clear hidden TCR2 bits for nested
 guests
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261119-nv-tcr2-v2-3-3deb1a6cdba8@pereq.eu>
References: <20261119-nv-tcr2-v2-0-3deb1a6cdba8@pereq.eu>
In-Reply-To: <20261119-nv-tcr2-v2-0-3deb1a6cdba8@pereq.eu>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
 Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
 Steffen Eiden <seiden@linux.ibm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Mark Rutland <mark.rutland@arm.com>, Jintack Lim <jintack.lim@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 Dan Carpenter <dan@pereq.eu>, Karthik Bhargavan <karthik@pereq.eu>, 
 =?utf-8?q?Cl=C3=A9ment_Blaudeau?= <clement@cryspen.com>, 
 stable@vger.kernel.org
X-Mailer: b4 0.16.0

The previous patch added traps for TCR2_EL1 writes on VMs that have
FEAT_TCR2 but not FEAT_S1PIE or FEAT_S1POE.  This patch extends that
fix to cover nested virtualization.

The bug is that a KVM can hide the PIE and POE bits in TCR2_EL1 but a VM
can still write to them.  It obviously makes no sense to hide a register
from the VM but still allow writes. The implication of this bug is a
small information leak because a VM can determine the permission bits of
another VM's page tables.

The previous patch trapped writes to TCR2_EL1 but nested virtualization
is more complicated because we have to deal with TCR2_EL2 as well.  A
trapped TCR2_EL1 write has to go to either TCR2_EL2 or TCR2_EL1 depending
on who made it.  With nested virtualization the hidden bits can reach the
hardware in three ways:

- A guest hypervisor at vEL2 writes its TCR2_EL2.
- An L2 writes its own TCR2_EL1.
- An L1 writes its L2's TCR2_EL1 in the VNCR page, which KVM loads as is.

To fix this, remove the vcpu_has_nv() check in __compute_hfgwtr() so that
these writes are trapped too.  When the guest hypervisor is at vEL2,
update TCR2_EL2 and TCR_EL2 instead of L2's registers.  Also clear the
hidden bits in __sysreg_restore_el1_state() when it loads a guest's
TCR2_EL1.

Fixes: 58627b722ee2 ("KVM: arm64: Make PIR{,E0}_EL1 UNDEF if S1PIE is not advertised to the guest")
Fixes: b86c9bea6349 ("KVM: arm64: Save/restore POE registers")
Cc: stable@vger.kernel.org
Signed-off-by: Dan Carpenter <dan@pereq.eu>
---
v2: This is a new patch
---
 arch/arm64/kvm/config.c                    |  2 +-
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h | 10 +++++++++-
 arch/arm64/kvm/sys_regs.c                  | 19 ++++++++++++++++++-
 3 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index f756f7c4fdf8..8bde0a5eafb6 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -1898,7 +1898,7 @@ static void __compute_hfgwtr(struct kvm_vcpu *vcpu)
 		*vcpu_fgt(vcpu, HFGWTR_EL2) |= HFGWTR_EL2_TCR_EL1;
 
 	/* The CPU acts on hidden TCR2_EL1 bits, so trap writes to clear them */
-	if (!vcpu_has_nv(vcpu) && kvm_has_tcr2(vcpu->kvm) &&
+	if (kvm_has_tcr2(vcpu->kvm) &&
 	    (!kvm_has_s1pie(vcpu->kvm) || !kvm_has_s1poe(vcpu->kvm)))
 		*vcpu_fgt(vcpu, HFGWTR_EL2) |= HFGWTR_EL2_TCR_EL1;
 }
diff --git a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
index 4a008c8a696b..d6e8bab14ed3 100644
--- a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
+++ b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
@@ -261,7 +261,15 @@ static inline void __sysreg_restore_el1_state(struct kvm_cpu_context *ctxt,
 	write_sysreg_el1(ctxt_sys_reg(ctxt, TTBR0_EL1),	SYS_TTBR0);
 	write_sysreg_el1(ctxt_sys_reg(ctxt, TTBR1_EL1),	SYS_TTBR1);
 	if (ctxt_has_tcrx(ctxt)) {
-		write_sysreg_el1(ctxt_sys_reg(ctxt, TCR2_EL1),	SYS_TCR2);
+		u64 tcr2 = ctxt_sys_reg(ctxt, TCR2_EL1);
+
+		if (ctxt_is_guest(ctxt)) {
+			if (!ctxt_has_s1pie(ctxt))
+				tcr2 &= ~TCR2_EL1_PIE;
+			if (!ctxt_has_s1poe(ctxt))
+				tcr2 &= ~(TCR2_EL1_POE | TCR2_EL1_E0POE);
+		}
+		write_sysreg_el1(tcr2, SYS_TCR2);
 
 		if (ctxt_has_s1pie(ctxt)) {
 			write_sysreg_el1(ctxt_sys_reg(ctxt, PIR_EL1),	SYS_PIR);
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 3899702d438b..e4a3beac6ec9 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -624,6 +624,23 @@ static bool access_tcr2_el1(struct kvm_vcpu *vcpu,
 	if (!kvm_has_s1poe(vcpu->kvm))
 		p->regval &= ~(TCR2_EL1_POE | TCR2_EL1_E0POE);
 
+	if (is_hyp_ctxt(vcpu) && vcpu_el2_e2h_is_set(vcpu)) {
+		vcpu_write_sys_reg(vcpu, p->regval, TCR2_EL2);
+		return true;
+	}
+
+	return access_vm_reg(vcpu, p, r);
+}
+
+static bool access_tcr_el1(struct kvm_vcpu *vcpu,
+			   struct sys_reg_params *p,
+			   const struct sys_reg_desc *r)
+{
+	if (is_hyp_ctxt(vcpu) && vcpu_el2_e2h_is_set(vcpu)) {
+		vcpu_write_sys_reg(vcpu, p->regval, TCR_EL2);
+		return true;
+	}
+
 	return access_vm_reg(vcpu, p, r);
 }
 
@@ -3512,7 +3529,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_SMCR_EL1), undef_access },
 	{ SYS_DESC(SYS_TTBR0_EL1), access_vm_reg, reset_unknown, TTBR0_EL1 },
 	{ SYS_DESC(SYS_TTBR1_EL1), access_vm_reg, reset_unknown, TTBR1_EL1 },
-	{ SYS_DESC(SYS_TCR_EL1), access_vm_reg, reset_val, TCR_EL1, 0 },
+	{ SYS_DESC(SYS_TCR_EL1), access_tcr_el1, reset_val, TCR_EL1, 0 },
 	{ SYS_DESC(SYS_TCR2_EL1), access_tcr2_el1, reset_val, TCR2_EL1, 0,
 	  .visibility = tcr2_visibility },
 

-- 
2.53.0

