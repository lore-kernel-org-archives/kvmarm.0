Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 433DED304
	for <kvmarm@lists.linux.dev>; Tue, 14 May 2024 07:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715671394; cv=none; b=LVrg/WKlukoqSvBNrWJcrW+S1aXoAr+5Qn2cZqkW5LrcPNgtq2qqRz8TLo5KivN0vJn9sg9v3M7UACVk+Cz3XwKBKQtyfqPortC7QKZdTCxk1Il0eHPmPsm7Ljhqv4+OmRGtZLbemXQxB+t3UeALSLY5y1YC8nnfLMcbPXKoJA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715671394; c=relaxed/simple;
	bh=wY+GRzCRFH5gnq+ih1QfRxaZi4OYPpugBgelwQ2YeW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iPmPPpwtPpHzQzCVewqJccNVESr3ZWBTZq/LK1Rii40zpJG1M2MEq0EUPd31YZVauXkgJ3uFm5HAW8LA55WdyjPzNYOkGYSqktFjzvDeyQVFmRHRSQ/GOv9m5veQMO0hHIXw2NcmR5pCe3baNlXvyUTBkO6nuCeloSEjr/jfHfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BhUyRmD6; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BhUyRmD6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715671392;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qmTJtxNzwCydsCweSeZKkzPt91K1xWWXybaXzLbEATg=;
	b=BhUyRmD6QgT2D64o7OmHuN5Vvj7JNLZxhYWWmfsQ9XYnrYCQvUTY/34ABBZ+bEWwfPneIH
	x8oVcnZoGMk8SqSNVh+G9siGNAo3W0olHhTn+O0cUQ4Wt4o/xRo5rWPayE7DS6cvU6XBps
	7thxLJIiDRiI/5E3EiOiExcwy1f9/bU=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-587-0gtqT4uoONydsJVZqlyIfQ-1; Tue, 14 May 2024 03:23:11 -0400
X-MC-Unique: 0gtqT4uoONydsJVZqlyIfQ-1
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-6a0ce87adf5so50722426d6.3
        for <kvmarm@lists.linux.dev>; Tue, 14 May 2024 00:23:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715671390; x=1716276190;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qmTJtxNzwCydsCweSeZKkzPt91K1xWWXybaXzLbEATg=;
        b=C9C5FfmSPryZ/OBL+9/AbvhuNEKJ8AGap9LzhSneoOrZlNuFtY54cTizqkJ4qb41NE
         3xSYQrprFfk3MsK+8KRlBPz4eLxE9Zxmz0H9schrhKa2w1exDwvsnDih+zDWI9BdFkeJ
         2B1ZqEKOpaKBsBYKVLuqH7ZAYa/2LBX+ydLVRRnt+rLpbwWSd61hxcw8Wg0rt6iz31Tt
         BmeYkNFKMb4Zer1MnWQXvfnxUo75pSHYfNS0narMUVcHMQH6RJ360a0kqO0xlsekWHMC
         P0MlaCvYNwhongh3Dk8rb9CiPFEvhy+WSVjKvCQiK3SEitsUkT93CR89uVLyRejRcmls
         9h+A==
X-Forwarded-Encrypted: i=1; AJvYcCVemFq726mu9/oosuXEctBAsThH4QfvqdFw5sAlZbuEg3p2ROmu7XpxOtqysGquEnnBPuvTDADxopE076mg4QznKr5JP7dG
X-Gm-Message-State: AOJu0Yz+SPQISiLqo66DkAq+T1l71KE8rjHLeZS0Us7yusBzvuuYpVyF
	UB1W/lczlv1iHtU2EnkcM2t76xXKULnyxliElNsPWW4NnCed4tiPVPSi8EXXubRaaQ8HV4/a8Xt
	kY/5xmEMHfiFLGcAxp1T2euNcCWpCaKU3a1/GwLQGM6N+A9jZ+3XeDw==
X-Received: by 2002:a05:6214:5b87:b0:6a0:cd69:374d with SMTP id 6a1803df08f44-6a16824151fmr150030246d6.50.1715671390223;
        Tue, 14 May 2024 00:23:10 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHJ2R7/7LcuNEr1pVh3mkLXVqAI7slnKMsvoAq1Lye2TXziw5bgVSkgrOVRGpraSzpR7RDmOA==
X-Received: by 2002:a05:6214:5b87:b0:6a0:cd69:374d with SMTP id 6a1803df08f44-6a16824151fmr150030156d6.50.1715671389920;
        Tue, 14 May 2024 00:23:09 -0700 (PDT)
Received: from rh.redhat.com (p200300c93f4cc600a5cdf10de606b5e2.dip0.t-ipconnect.de. [2003:c9:3f4c:c600:a5cd:f10d:e606:b5e2])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6a15f1ccd4esm50917516d6.97.2024.05.14.00.23.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 May 2024 00:23:09 -0700 (PDT)
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
Subject: [PATCH v3 6/6] KVM: selftests: arm64: Test writes to CTR_EL0
Date: Tue, 14 May 2024 09:22:52 +0200
Message-ID: <20240514072252.5657-7-sebott@redhat.com>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514072252.5657-1-sebott@redhat.com>
References: <20240514072252.5657-1-sebott@redhat.com>
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

Test that CTR_EL0 is modifiable from userspace, that changes are
visible to guests, and that they are preserved across a vCPU reset.

Signed-off-by: Sebastian Ott <sebott@redhat.com>
---
 .../testing/selftests/kvm/aarch64/set_id_regs.c  | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/tools/testing/selftests/kvm/aarch64/set_id_regs.c b/tools/testing/selftests/kvm/aarch64/set_id_regs.c
index a7de39fa2a0a..9583c04f1228 100644
--- a/tools/testing/selftests/kvm/aarch64/set_id_regs.c
+++ b/tools/testing/selftests/kvm/aarch64/set_id_regs.c
@@ -219,6 +219,7 @@ static void guest_code(void)
 	GUEST_REG_SYNC(SYS_ID_AA64MMFR1_EL1);
 	GUEST_REG_SYNC(SYS_ID_AA64MMFR2_EL1);
 	GUEST_REG_SYNC(SYS_ID_AA64ZFR0_EL1);
+	GUEST_REG_SYNC(SYS_CTR_EL0);
 
 	GUEST_DONE();
 }
@@ -490,11 +491,25 @@ static void test_clidr(struct kvm_vcpu *vcpu)
 	test_reg_vals[encoding_to_range_idx(SYS_CLIDR_EL1)] = clidr;
 }
 
+static void test_ctr(struct kvm_vcpu *vcpu)
+{
+	u64 ctr;
+
+	vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_CTR_EL0), &ctr);
+	ctr &= ~CTR_EL0_DIC_MASK;
+	if (ctr & CTR_EL0_IminLine_MASK)
+		ctr--;
+
+	vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_CTR_EL0), ctr);
+	test_reg_vals[encoding_to_range_idx(SYS_CTR_EL0)] = ctr;
+}
+
 static void test_vcpu_ftr_id_regs(struct kvm_vcpu *vcpu)
 {
 	u64 val;
 
 	test_clidr(vcpu);
+	test_ctr(vcpu);
 
 	vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_MPIDR_EL1), &val);
 	val++;
@@ -525,6 +540,7 @@ static void test_reset_preserves_id_regs(struct kvm_vcpu *vcpu)
 		test_assert_id_reg_unchanged(vcpu, test_regs[i].reg);
 
 	test_assert_id_reg_unchanged(vcpu, SYS_CLIDR_EL1);
+	test_assert_id_reg_unchanged(vcpu, SYS_CTR_EL0);
 
 	ksft_test_result_pass("%s\n", __func__);
 }
-- 
2.42.0

