Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE46114533D
	for <kvmarm@lists.linux.dev>; Fri, 26 Apr 2024 10:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714128605; cv=none; b=Fff0CNokyaPvhUjPwBTRlURVzOYCQuTU/lSt48esSU6bQYT5eGqCOhh0w9e31zNjvh7csuu+/j4TZ5E3n8R+9JNWTQTYvPFp9rDTw2CRwX/PfJbDF/XzvE3/yrDb0sJD5UWEontPA4OKa5BVzcXF46Tqtia4VLDCTbvIO3T8G1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714128605; c=relaxed/simple;
	bh=9tf8evFXPxZIsJtfON0tpY2q9B/4pD7lHgFXwfjZ268=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iX1R3QYOWx2OV8XI1JtL6VrR2hrCcTRoTt3bBpFknW0wt39u3DzEG28WFT/ge/aY98wiVeoqpjIPn0JIDrT3gCWpreGUujma+IPX93NzxgmErtgrfOfnhDOXPnjNrHYlVRdM4g6GTEjBpCAzDtRhhXnp88J0Q5jev3dejCtKfz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FNwpFqN6; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FNwpFqN6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714128602;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qWPuNZam4oUpFHKljOPQcZMbiol5epXIuKViics5wNw=;
	b=FNwpFqN6Z7S6g06w5Cs3mXZ0l8aAr9GhYtd8CI1bmbmcWYQo+/W/SCnaKrQevW7m+uBDpP
	+YB5nfgttIQjgiv37Qq3pI7zGYpNJE01E4ki1H5EAo1wiUN7Zi5GFT/B8ClrKv+b54kNR6
	2kIiCxH7hr411J5IaesXzbnE5fOXxDs=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-470-WPfHA3osNiu922Nc3bzj3g-1; Fri, 26 Apr 2024 06:50:01 -0400
X-MC-Unique: WPfHA3osNiu922Nc3bzj3g-1
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-6a0a5f65095so13236506d6.3
        for <kvmarm@lists.linux.dev>; Fri, 26 Apr 2024 03:50:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714128601; x=1714733401;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qWPuNZam4oUpFHKljOPQcZMbiol5epXIuKViics5wNw=;
        b=MFUGE+pLlYYQnySD1rYkPMY7QkmAl/91kx7OnAhe27OmDC3WGi9gSMD6PPDumgOYYb
         GIuMWxtHTkDSr5lzSqlII0apJj/SGAqHHySFfV8jZTunWDitcgPknml25dsZR4j4gKRj
         wINg0e7fdUr35YiA7kPRH7dvjQ0OrOisjO6yJ8eW8XPkpP0A2fo5p3kaDBnYZbRKYn8n
         BDPoPoU2XMPO7nK+E1KCzK4J9/WBzk492pomUobiGlM+ySKk9ZHCachf0IImqlrI40UU
         +38chrrJlkw5ox9n90mY1vei2a3dcmoBlizlGHS/IB+Z4Fv8rKC+hCisHy4LCkAX+SiV
         Ogdw==
X-Forwarded-Encrypted: i=1; AJvYcCXWujXLhxd1loXZsev+GlQ3Xk36HxCupw9rHgcgsNJdICKYBDzlrm7NGC5MpWAHj727uVR8LZtvTZseweHDpAYzaqjqlxsh
X-Gm-Message-State: AOJu0YzTXe2m1nMb+IsT39zesnRfbE+WVJryiGDRud/zZsmqmLadDvVT
	Zx7be0TOGLzPeexaMuNr1zSNCfhHsmVHCjmNWGSVisrRcWAHfrUqK3xr1KJyMhtsq1Q8i1Jh3pz
	H0BP9RcS2zWxcAt9Ls2o6ujRLQSrex7IHKO+qh+WU6GLFz232K8nqc6A6wnNSLQ==
X-Received: by 2002:a05:6214:246d:b0:69f:6b0d:3f62 with SMTP id im13-20020a056214246d00b0069f6b0d3f62mr3254499qvb.55.1714128600778;
        Fri, 26 Apr 2024 03:50:00 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFJyH5OHPJ7TR40RC5KizCF/4egd908tGs6YVstwmK3Jxz72fvFPFvoPA1KvhVgGxDZ+ojbww==
X-Received: by 2002:a05:6214:246d:b0:69f:6b0d:3f62 with SMTP id im13-20020a056214246d00b0069f6b0d3f62mr3254486qvb.55.1714128600530;
        Fri, 26 Apr 2024 03:50:00 -0700 (PDT)
Received: from rh.redhat.com (p200300c93f4cc600a5cdf10de606b5e2.dip0.t-ipconnect.de. [2003:c9:3f4c:c600:a5cd:f10d:e606:b5e2])
        by smtp.gmail.com with ESMTPSA id vv26-20020a05620a563a00b007907b57aa1fsm3888019qkn.12.2024.04.26.03.49.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Apr 2024 03:50:00 -0700 (PDT)
From: Sebastian Ott <sebott@redhat.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH v2 3/6] KVM: arm64: maintain per VM value for CTR_EL0
Date: Fri, 26 Apr 2024 12:49:47 +0200
Message-ID: <20240426104950.7382-4-sebott@redhat.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240426104950.7382-1-sebott@redhat.com>
References: <20240426104950.7382-1-sebott@redhat.com>
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

In preparation for CTR_EL0 emulation maintain a per VM for this
register and use it where appropriate.

Signed-off-by: Sebastian Ott <sebott@redhat.com>
---
 arch/arm64/include/asm/kvm_host.h |  2 ++
 arch/arm64/kvm/sys_regs.c         | 15 ++++++++-------
 2 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 696acba883c1..0c84cdb11c97 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -340,6 +340,8 @@ struct kvm_arch {
 #define KVM_ARM_ID_REG_NUM	(IDREG_IDX(sys_reg(3, 0, 0, 7, 7)) + 1)
 	u64 id_regs[KVM_ARM_ID_REG_NUM];
 
+	u64 ctr_el0;
+
 	/* Masks for VNCR-baked sysregs */
 	struct kvm_sysreg_masks	*sysreg_masks;
 
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index ac366d0b614a..1488b93050d4 100644
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
@@ -1862,7 +1862,7 @@ static bool access_ctr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	if (p->is_write)
 		return write_to_read_only(vcpu, p, r);
 
-	p->regval = read_sanitised_ftr_reg(SYS_CTR_EL0);
+	p->regval = vcpu->kvm->arch.ctr_el0;
 	return true;
 }
 
@@ -1882,7 +1882,7 @@ static bool access_clidr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
  */
 static u64 reset_clidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 {
-	u64 ctr_el0 = read_sanitised_ftr_reg(SYS_CTR_EL0);
+	u64 ctr_el0 = vcpu->kvm->arch.ctr_el0;
 	u64 clidr;
 	u8 loc;
 
@@ -1935,8 +1935,8 @@ static u64 reset_clidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 static int set_clidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 		      u64 val)
 {
-	u64 ctr_el0 = read_sanitised_ftr_reg(SYS_CTR_EL0);
 	u64 idc = !CLIDR_LOC(val) || (!CLIDR_LOUIS(val) && !CLIDR_LOUU(val));
+	u64 ctr_el0 = vcpu->kvm->arch.ctr_el0;
 
 	if ((val & CLIDR_EL1_RES0) || (!(ctr_el0 & CTR_EL0_IDC) && idc))
 		return -EINVAL;
@@ -3509,6 +3509,7 @@ static void kvm_reset_id_regs(struct kvm_vcpu *vcpu)
 		return;
 
 	lockdep_assert_held(&kvm->arch.config_lock);
+	kvm->arch.ctr_el0 = read_sanitised_ftr_reg(SYS_CTR_EL0);
 
 	/* Initialize all idregs */
 	while (is_id_reg(id)) {
-- 
2.42.0

