Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F35B712D20D
	for <kvmarm@lists.linux.dev>; Mon,  3 Jun 2024 13:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717419923; cv=none; b=q+un2nhmAoLGMF52cu285Sgvx0cfmpmZZUd/57mMbbkCZS/jLYKTPHqn7f2x5wshgFxRC1ZNRfLQ63vLTZus0E41xnS/re6SvEcb3DG2U+IuftrqJjnn7Ovt5jRx4/tLTDv8RsAO/Q1C4elL6f5UTb5sy4G1AN9DW3OrG5JSDMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717419923; c=relaxed/simple;
	bh=TJTRbI1YKquApQQ9jbhfJ+XZ0A2gQSbCs7exr8rWRMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=M1sbigywiBq+PbfHN0GBYFILYTDA+7aztpkkGkkwpD7yszao7JratepgxQAloqeDjkr/tbJQF6hVNP/CRLmTWC4eEWdgC3x/OlLXieSANHEF0vKgI1ENGQ0SPgvkpmvHMCpuz17Mae0/SzWIjrgXJk/j3MS85sOyafJHhgZO2lk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JTjS+Lwu; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JTjS+Lwu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717419921;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gwVJ1n8x5DPX1iJh7AaLYp6ZnC4UC7CFdil3T4wvPJA=;
	b=JTjS+LwuwPeo1xdDS++xJdBCCqHayCG4Nh/ccZhu7BJn/0G4AhkqGLDpC7myzu+Nd8tjBC
	b+HarQAkbfXnYfWLEzVmV7r13vNc2TwfMH/IaKpITOQ9Swkg0PLS9Rw51G7Ug/3XRtdgcX
	k9wJSmSzE+LDjeY1H2AsRi9pl9L2iz0=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-219-J3oARNfzNN-KZm2HW-e2qw-1; Mon, 03 Jun 2024 09:05:20 -0400
X-MC-Unique: J3oARNfzNN-KZm2HW-e2qw-1
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-6aedd2eec59so27841136d6.2
        for <kvmarm@lists.linux.dev>; Mon, 03 Jun 2024 06:05:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717419919; x=1718024719;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gwVJ1n8x5DPX1iJh7AaLYp6ZnC4UC7CFdil3T4wvPJA=;
        b=Ec2h68t+fPjxOxCbz2IybRyhcoxd6p8THhpUi4/4sEaNxMBWksTIVkEiqO6pMer6J/
         lETUl+qRHUTEYRHH9wVYpUdaizL+wJfe8GEDFPU/NICJYUFVtV0VZ82yDw67PwwiuB7P
         Hy2JWDL/LzTUAxowt/YB8zwOImz6q/IzqcgMhH1oWxvf1HA3SnAahiGs8XxC0QMB2Ej5
         OsHCOgg4tOFdOkxK1fYVJr2wRTnIr480tfZ+levytJ1dD8N+enbXo27YOrXjt8mVaD0Z
         YjO6Ba1PaBhpKcOSQxtmhhtx4hqyYzULpBHt5FYJiDIvcDt/ZgdYISG7/yszjfM+fQ1v
         ZmXQ==
X-Forwarded-Encrypted: i=1; AJvYcCWW1LSBrU05F7V+2IP9V7lgHIl7GERLiBcFw70fW5/rKxxJUg5cmBgsemMMRsLRSdaQJUZqwZbE/5dnONHiPpX0CnpJmFkS
X-Gm-Message-State: AOJu0Yx7hNaPCjVofhY9tbVauIjtY1YQbVWCu13Smql+YkLgmU+dNujF
	7hp2cdBz0ZknnCE/UB+ggxmis37kDBAVEEC6dRpLLdnCQH3E153p4liciuzHH8EYVu9t7sda+bA
	l/73qt1QX9a/Av+BhoaTeZhoM6QuAWuHXMD4v0PmA4h5pKGkQCoN8Bw==
X-Received: by 2002:a05:6214:3f85:b0:6ae:1055:9873 with SMTP id 6a1803df08f44-6aecd69ff0amr132249436d6.21.1717419919289;
        Mon, 03 Jun 2024 06:05:19 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFzXldOqmMa82FdbgGR14vKWcQ/hV4lzO7eHnKKTyIwxcHDOqCEim+11uqARDYIXC9iMYqEPQ==
X-Received: by 2002:a05:6214:3f85:b0:6ae:1055:9873 with SMTP id 6a1803df08f44-6aecd69ff0amr132248586d6.21.1717419918495;
        Mon, 03 Jun 2024 06:05:18 -0700 (PDT)
Received: from rh.redhat.com (p200300c93f02d1004c157eb0f018dd01.dip0.t-ipconnect.de. [2003:c9:3f02:d100:4c15:7eb0:f018:dd01])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6ae4b4179f4sm30558826d6.113.2024.06.03.06.05.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Jun 2024 06:05:18 -0700 (PDT)
From: Sebastian Ott <sebott@redhat.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Shaoqin Huang <shahuang@redhat.com>,
	Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v4 2/6] KVM: arm64: maintain per VM value for CTR_EL0
Date: Mon,  3 Jun 2024 15:05:03 +0200
Message-ID: <20240603130507.17597-3-sebott@redhat.com>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240603130507.17597-1-sebott@redhat.com>
References: <20240603130507.17597-1-sebott@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

In preparation for CTR_EL0 emulation maintain a per VM value for this
register and use it where appropriate.

Signed-off-by: Sebastian Ott <sebott@redhat.com>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
---
 arch/arm64/include/asm/kvm_host.h |  2 ++
 arch/arm64/kvm/sys_regs.c         | 21 ++++++++++++++-------
 2 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 212ae77eefaf..1259be5e2f3e 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -331,6 +331,8 @@ struct kvm_arch {
 #define KVM_ARM_ID_REG_NUM	(IDREG_IDX(sys_reg(3, 0, 0, 7, 7)) + 1)
 	u64 id_regs[KVM_ARM_ID_REG_NUM];
 
+	u64 ctr_el0;
+
 	/* Masks for VNCR-baked sysregs */
 	struct kvm_sysreg_masks	*sysreg_masks;
 
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 41741bf4d2b2..0213c96f73f2 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -219,9 +219,9 @@ void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, int reg)
  * Returns the minimum line size for the selected cache, expressed as
  * Log2(bytes).
  */
-static u8 get_min_cache_line_size(bool icache)
+static u8 get_min_cache_line_size(struct kvm *kvm, bool icache)
 {
-	u64 ctr = read_sanitised_ftr_reg(SYS_CTR_EL0);
+	u64 ctr = kvm->arch.ctr_el0;
 	u8 field;
 
 	if (icache)
@@ -248,7 +248,7 @@ static u32 get_ccsidr(struct kvm_vcpu *vcpu, u32 csselr)
 	if (vcpu->arch.ccsidr)
 		return vcpu->arch.ccsidr[csselr];
 
-	line_size = get_min_cache_line_size(csselr & CSSELR_EL1_InD);
+	line_size = get_min_cache_line_size(vcpu->kvm, csselr & CSSELR_EL1_InD);
 
 	/*
 	 * Fabricate a CCSIDR value as the overriding value does not exist.
@@ -283,7 +283,7 @@ static int set_ccsidr(struct kvm_vcpu *vcpu, u32 csselr, u32 val)
 	u32 i;
 
 	if ((val & CCSIDR_EL1_RES0) ||
-	    line_size < get_min_cache_line_size(csselr & CSSELR_EL1_InD))
+	    line_size < get_min_cache_line_size(vcpu->kvm, csselr & CSSELR_EL1_InD))
 		return -EINVAL;
 
 	if (!ccsidr) {
@@ -1886,7 +1886,7 @@ static bool access_ctr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	if (p->is_write)
 		return write_to_read_only(vcpu, p, r);
 
-	p->regval = read_sanitised_ftr_reg(SYS_CTR_EL0);
+	p->regval = vcpu->kvm->arch.ctr_el0;
 	return true;
 }
 
@@ -1906,7 +1906,7 @@ static bool access_clidr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
  */
 static u64 reset_clidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 {
-	u64 ctr_el0 = read_sanitised_ftr_reg(SYS_CTR_EL0);
+	u64 ctr_el0 = vcpu->kvm->arch.ctr_el0;
 	u64 clidr;
 	u8 loc;
 
@@ -1959,8 +1959,8 @@ static u64 reset_clidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 static int set_clidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 		      u64 val)
 {
-	u64 ctr_el0 = read_sanitised_ftr_reg(SYS_CTR_EL0);
 	u64 idc = !CLIDR_LOC(val) || (!CLIDR_LOUIS(val) && !CLIDR_LOUU(val));
+	u64 ctr_el0 = vcpu->kvm->arch.ctr_el0;
 
 	if ((val & CLIDR_EL1_RES0) || (!(ctr_el0 & CTR_EL0_IDC) && idc))
 		return -EINVAL;
@@ -3557,6 +3557,13 @@ void kvm_reset_sys_regs(struct kvm_vcpu *vcpu)
 	struct kvm *kvm = vcpu->kvm;
 	unsigned long i;
 
+	if (!kvm_vcpu_initialized(vcpu))
+		/*
+		 * Make sure CTR_EL0 is initialized before registers
+		 * that depend on it are reset.
+		 */
+		kvm->arch.ctr_el0 = read_sanitised_ftr_reg(SYS_CTR_EL0);
+
 	for (i = 0; i < ARRAY_SIZE(sys_reg_descs); i++) {
 		const struct sys_reg_desc *r = &sys_reg_descs[i];
 
-- 
2.42.0

