Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D961116C84B
	for <kvmarm@lists.linux.dev>; Fri,  5 Apr 2024 12:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712318485; cv=none; b=rn2uKfv5Dt21CevdJqEqBHPh5tIf0K87wtVGP0sqycKjl62cBh+cCfNRj7XK/04UCi41OAIAACf7LCqNY/AIKM7zFoyZT6LAiRUprT3LfSEViGirzG3xuQeGFF0N3/uCYmFySeb/LKahlWVGJXCujxAsoSrUAmkQqNlpG8AO+/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712318485; c=relaxed/simple;
	bh=/0jN/zskn+pvye9zhGa9kX2fqd2uuUdTKatvYSPMGHg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fy58hdKIFz0mtmIoBmR+MN0vC39J0eoRK/cd2S8B86pP+pW8yE0BOfnojjWmfqOTNAFoeTv+IjBHcDUUZfGhDR//kGvuV8m5gzkr9+CSOaqPcNqf1wAmt0NT+lCOE8pGbJKKOcFyK0/JVgSoyrqvVNAwSAAJNysGnZ0F1XXDlaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QSfAwAk4; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QSfAwAk4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712318483;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rsSFcUbsThM5IkqFm5UZmPp81ZNMKoAIhMlsT6uF7yg=;
	b=QSfAwAk4Bvt32JZg4HFJPTbie7JG49a6KICXSkRwsuPHUbE7AYs4SBOPfLrkHZoJwMHc21
	kWYv/+ze9Kga5aZVydgW8Kb0gIi+Ef/7z2/3xIkY5QcJUGcIr+PByj+kiZXbUqDUUoPul/
	OTVhaRGr3cgnxlFEaTPukvTh1MUJ4fg=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-213-wcfTta--MZ2bUyxhcfaCuw-1; Fri, 05 Apr 2024 08:01:21 -0400
X-MC-Unique: wcfTta--MZ2bUyxhcfaCuw-1
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-43114d0421fso20747371cf.3
        for <kvmarm@lists.linux.dev>; Fri, 05 Apr 2024 05:01:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712318481; x=1712923281;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rsSFcUbsThM5IkqFm5UZmPp81ZNMKoAIhMlsT6uF7yg=;
        b=pz33xVSiZu/EKwyKCd7E20Z8Py0f3xE8Ui3N15Y3yqVho/KC1mTRbp+11DKSWnW9v+
         RFdrbgLN4tBQEyZOzVgoryFiq7Q6zpbGwbo9esMnkSUzv1YFDZ5rhiVbkmzyLqv5AWN5
         DjpFjYxyyeRG6P1/WqdncCOd0WPaQW8yOG0z8D04ow9etGfnWTRpQTleuMkHnPUwRK2s
         eqKuf5/O6gZTBcFyDa2u0Ld1lVGAoM2pWE6aFFR7p3nn51FhnYTKvg5ioKGeZ2BO3wsc
         s7WRQD/Hl8SwlpYkuOR75gG89hIO17AOJVckmK1T0eIZeKqoanU4KHGVc4o92oQvwa3U
         q/vw==
X-Forwarded-Encrypted: i=1; AJvYcCWxnYpdOLauy1g2tVPWUx42MfqaUTjHUTL+a4P4L2xCPs00YRxksFKVYpeAwQt3FkPYQW7ozmH9A2kP1DFEweSze7YgjVc6
X-Gm-Message-State: AOJu0Yysn9tHIaZrvPa6gHKgdFW/7UgLZ+tR8TgeY57b7CDJ3h9H9tPi
	ScIDDFijvgce4HYgxbS4VBj/qY2c2HZoV92aNOgv4GUShl+5NNbDg2id9Ux9gNtSYz57Uc3nkqU
	MbiBd0PT0zqO4G4aU7huur1l+3f4D9ouNddj7GdrMbUrXLFL8OWs6OA==
X-Received: by 2002:a05:622a:298f:b0:434:6094:beaa with SMTP id hd15-20020a05622a298f00b004346094beaamr1267265qtb.39.1712318480548;
        Fri, 05 Apr 2024 05:01:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFnpiinNv2C2T+YikhgYDSg8DJI+6kCRzyHodV6nkO8b80TJOicClVWNFFNXPLtsSMcu3AVIQ==
X-Received: by 2002:a05:622a:298f:b0:434:6094:beaa with SMTP id hd15-20020a05622a298f00b004346094beaamr1267234qtb.39.1712318480054;
        Fri, 05 Apr 2024 05:01:20 -0700 (PDT)
Received: from rh.redhat.com (p200300c93f4c24001316a1e598258370.dip0.t-ipconnect.de. [2003:c9:3f4c:2400:1316:a1e5:9825:8370])
        by smtp.gmail.com with ESMTPSA id fb17-20020a05622a481100b00434383f2518sm679808qtb.87.2024.04.05.05.01.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Apr 2024 05:01:19 -0700 (PDT)
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
Subject: [PATCH 2/4] KVM: arm64: maintain per VM value for CTR_EL0
Date: Fri,  5 Apr 2024 14:01:06 +0200
Message-ID: <20240405120108.11844-3-sebott@redhat.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240405120108.11844-1-sebott@redhat.com>
References: <20240405120108.11844-1-sebott@redhat.com>
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
 arch/arm64/include/asm/kvm_host.h |  1 +
 arch/arm64/kvm/sys_regs.c         | 22 +++++++++++++++-------
 2 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 9e8a496fb284..481216febb46 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -318,6 +318,7 @@ struct kvm_arch {
 
 	/* PMCR_EL0.N value for the guest */
 	u8 pmcr_n;
+	u64 ctr_el0;
 
 	/* Iterator for idreg debugfs */
 	u8	idreg_debugfs_iter;
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 131f5b0ca2b9..4d29b1a0842d 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -215,13 +215,21 @@ void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, int reg)
 /* CSSELR values; used to index KVM_REG_ARM_DEMUX_ID_CCSIDR */
 #define CSSELR_MAX 14
 
+static u64 kvm_get_ctr_el0(struct kvm *kvm)
+{
+	if (kvm->arch.ctr_el0)
+		return kvm->arch.ctr_el0;
+
+	return read_sanitised_ftr_reg(SYS_CTR_EL0);
+}
+
 /*
  * Returns the minimum line size for the selected cache, expressed as
  * Log2(bytes).
  */
-static u8 get_min_cache_line_size(bool icache)
+static u8 get_min_cache_line_size(struct kvm *kvm, bool icache)
 {
-	u64 ctr = read_sanitised_ftr_reg(SYS_CTR_EL0);
+	u64 ctr = kvm_get_ctr_el0(kvm);
 	u8 field;
 
 	if (icache)
@@ -248,7 +256,7 @@ static u32 get_ccsidr(struct kvm_vcpu *vcpu, u32 csselr)
 	if (vcpu->arch.ccsidr)
 		return vcpu->arch.ccsidr[csselr];
 
-	line_size = get_min_cache_line_size(csselr & CSSELR_EL1_InD);
+	line_size = get_min_cache_line_size(vcpu->kvm, csselr & CSSELR_EL1_InD);
 
 	/*
 	 * Fabricate a CCSIDR value as the overriding value does not exist.
@@ -283,7 +291,7 @@ static int set_ccsidr(struct kvm_vcpu *vcpu, u32 csselr, u32 val)
 	u32 i;
 
 	if ((val & CCSIDR_EL1_RES0) ||
-	    line_size < get_min_cache_line_size(csselr & CSSELR_EL1_InD))
+	    line_size < get_min_cache_line_size(vcpu->kvm, csselr & CSSELR_EL1_InD))
 		return -EINVAL;
 
 	if (!ccsidr) {
@@ -1862,7 +1870,7 @@ static bool access_ctr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	if (p->is_write)
 		return write_to_read_only(vcpu, p, r);
 
-	p->regval = read_sanitised_ftr_reg(SYS_CTR_EL0);
+	p->regval = kvm_get_ctr_el0(vcpu->kvm);
 	return true;
 }
 
@@ -1882,7 +1890,7 @@ static bool access_clidr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
  */
 static u64 reset_clidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 {
-	u64 ctr_el0 = read_sanitised_ftr_reg(SYS_CTR_EL0);
+	u64 ctr_el0 = kvm_get_ctr_el0(vcpu->kvm);
 	u64 clidr;
 	u8 loc;
 
@@ -1935,7 +1943,7 @@ static u64 reset_clidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 static int set_clidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 		      u64 val)
 {
-	u64 ctr_el0 = read_sanitised_ftr_reg(SYS_CTR_EL0);
+	u64 ctr_el0 = kvm_get_ctr_el0(vcpu->kvm);
 	u64 idc = !CLIDR_LOC(val) || (!CLIDR_LOUIS(val) && !CLIDR_LOUU(val));
 
 	if ((val & CLIDR_EL1_RES0) || (!(ctr_el0 & CTR_EL0_IDC) && idc))
-- 
2.42.0

