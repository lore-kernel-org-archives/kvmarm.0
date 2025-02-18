Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 272C426F449
	for <kvmarm@lists.linux.dev>; Tue, 18 Feb 2025 16:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739896495; cv=none; b=Xbkmr7SdSrrSGZ9Irys/6lPHOnmVRajBWzXq4DYhxjWOxsjnsyYqIYN9+tcDzLSnZkNgFD8esGrat1Nne4Mkk9m/UqTtxxbh1coRK6clyIdG7GME0ShxkKfFGyyyI7zGnmwZ8aytCn+GhU2VpsCRNxEQQTU4h1eC+5WmGsXkwD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739896495; c=relaxed/simple;
	bh=48SNocFIEyTD401Bn7uEPWmyPGgbFKE7acbIYbRpQLE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=L+5RrlyaW+yVNobUTvOgYpJlINIUXYhLFNVmEW+1IQRrGId2AE1tYprICvV6P/4NrW4YXYsNN8g19drjoz2YDEIY4nX7xggxEsGKLM0lnX+xjdec+1qWJjsP3w6XkSmCldnIqHduzYS+GCvbsN3LloS7qyRjKUoJ2xEYOT833/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FfJgHC1D; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FfJgHC1D"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739896493;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RdghYHu234rwHRoSlAkfrkrUKfnT4YJfki186RS5/GU=;
	b=FfJgHC1DTKLcp6QuQErFYRYVobOOvcGArnvnB9MTI6WXFR5NzeHiXMLkboVFPngg051dRm
	CFiRrslfTr6JTbUONLQh94ucvH7O6cAm4GUUFOA023igdQNcTZKCmFnhAjf3I2rraYsYNs
	VXoMQCl1rvDJhBfqOK7QvZGPY3jjDSs=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-534-NqrN87wFMOOOSBguaKhE8A-1; Tue, 18 Feb 2025 11:34:52 -0500
X-MC-Unique: NqrN87wFMOOOSBguaKhE8A-1
X-Mimecast-MFC-AGG-ID: NqrN87wFMOOOSBguaKhE8A_1739896491
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-439385b08d1so49596155e9.1
        for <kvmarm@lists.linux.dev>; Tue, 18 Feb 2025 08:34:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739896490; x=1740501290;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RdghYHu234rwHRoSlAkfrkrUKfnT4YJfki186RS5/GU=;
        b=teMr5eGzp4UIPcIu3eAhOk9f3UYI3J7kliXUVhJMAEHhqCXYRo5XE0+VHfNvHSKfHq
         z20tUIefZU90oCxvnb0yWnyEJi9oQU0jGyfFrGkUqgD7NHpkBWyZp0XOIeBpFeEWfZiK
         OJisHqcqU7QPxeEJZj6MPiMUfgppp2i5qACTBHbRLqyHur21epGmc999laPTKqdt3lLi
         kWou1pr0PgDQFB5+FGQ+6/r+7YkCzBx/8fnAUvnnr/T+ZtoP072OgnQ/K74eJ0ODoFCi
         X/fWGUtjO4QWsKrZ45Nvy+sdqAxAdp5IKIV4hSlX+zgBDdYL4FWNA02FQebdJWrj0+Fl
         WqUA==
X-Forwarded-Encrypted: i=1; AJvYcCXfvWGCB9TrV3KOXJoFZM0XEY8JH2EFJrzfxcoAQbCVClP9P7mrrYfQ/3khjZ5/NrMDbEJYoCE=@lists.linux.dev
X-Gm-Message-State: AOJu0YxeZg2q0jhzWNsDDxZZP9Lo5R0cr7t66H1VqBbK+uImmwipdyen
	z03Cukm5Xp1xLBzjoIeChwhNZFzl2acgMQ02+wdCpknhQYqYJ+ipsrTBWePXcH3wxvT2sZPMcVw
	IC6z2s8Z/BCh0qHWutNa1DqXkLTWcCaepZg/oLoe+lidqJb6XslVKUg==
X-Gm-Gg: ASbGncvy4dGK1tJRwaGUrhdLPT0LasMsjt77XoJm7Hskg9o/yfuXhwLpbuzJNn6jK1L
	2ODU+A78rYhJ2YViVAKPIhbMapm7tFCOcoq99Z2gdt2prtB4JCoVHtSUTQCvfzzct2OEgxgSH4z
	rXPq5dgpDbsNSpUhaTYYTM/20a9WO+VagYAUF0Owui0QSezskjW5M2mpKs04gBGCOcbPiMzomJx
	eGdkfb7voJBG3mIUP9D8E7auSg7hvlN/79K1ohsloeKPILm7nP6CUL37Zgu1Xxqi8JBd4bBl+fn
	zAzKzIHB6Ilh0L8550brucRV8Hmlo80lqy0RECSenessXN7A0/kBJvpvaBUGbeQyeqEd
X-Received: by 2002:a05:600c:3b9c:b0:439:967b:46fc with SMTP id 5b1f17b1804b1-43999d8f506mr3286525e9.8.1739896490601;
        Tue, 18 Feb 2025 08:34:50 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGr/dmaK1oQWajwLZOsOW11YMixQScvE0fX+ohPe438Pqvb/Vo3/S0ChTjcAbtFCmmO7n+NIw==
X-Received: by 2002:a05:600c:3b9c:b0:439:967b:46fc with SMTP id 5b1f17b1804b1-43999d8f506mr3286265e9.8.1739896490174;
        Tue, 18 Feb 2025 08:34:50 -0800 (PST)
Received: from rh.redhat.com (p200300f6af0e4d00dda53016e366575f.dip0.t-ipconnect.de. [2003:f6:af0e:4d00:dda5:3016:e366:575f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4396b5267eesm85091845e9.0.2025.02.18.08.34.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Feb 2025 08:34:49 -0800 (PST)
From: Sebastian Ott <sebott@redhat.com>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Cc: Cornelia Huck <cohuck@redhat.com>,
	Eric Auger <eric.auger@redhat.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 4/4] KVM: selftests: arm64: Test writes to MIDR,REVIDR,AIDR
Date: Tue, 18 Feb 2025 17:34:43 +0100
Message-ID: <20250218163443.32836-5-sebott@redhat.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250218163443.32836-1-sebott@redhat.com>
References: <20250218163443.32836-1-sebott@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: wskiiPJgljKes4YEFS7peZ8FzivNbuJ1VX6u6e31HHY_1739896491
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Assert that MIDR_EL1, REVIDR_EL1, AIDR_EL1 are writable from userspace,
that the changed values are visible to guests, and that they are
preserved across a vCPU reset.

Signed-off-by: Sebastian Ott <sebott@redhat.com>
---
 .../testing/selftests/kvm/arm64/set_id_regs.c | 32 +++++++++++++++----
 1 file changed, 26 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/arm64/set_id_regs.c b/tools/testing/selftests/kvm/arm64/set_id_regs.c
index 217541fe6536..d719c2ab1e31 100644
--- a/tools/testing/selftests/kvm/arm64/set_id_regs.c
+++ b/tools/testing/selftests/kvm/arm64/set_id_regs.c
@@ -230,6 +230,9 @@ static void guest_code(void)
 	GUEST_REG_SYNC(SYS_ID_AA64MMFR2_EL1);
 	GUEST_REG_SYNC(SYS_ID_AA64ZFR0_EL1);
 	GUEST_REG_SYNC(SYS_CTR_EL0);
+	GUEST_REG_SYNC(SYS_MIDR_EL1);
+	GUEST_REG_SYNC(SYS_REVIDR_EL1);
+	GUEST_REG_SYNC(SYS_AIDR_EL1);
 
 	GUEST_DONE();
 }
@@ -609,18 +612,31 @@ static void test_ctr(struct kvm_vcpu *vcpu)
 	test_reg_vals[encoding_to_range_idx(SYS_CTR_EL0)] = ctr;
 }
 
-static void test_vcpu_ftr_id_regs(struct kvm_vcpu *vcpu)
+static void test_id_reg(struct kvm_vcpu *vcpu, u32 id)
 {
 	u64 val;
 
+	val = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(id));
+	val++;
+	vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(id), val);
+	test_reg_vals[encoding_to_range_idx(id)] = val;
+}
+
+static void test_vcpu_ftr_id_regs(struct kvm_vcpu *vcpu)
+{
 	test_clidr(vcpu);
 	test_ctr(vcpu);
 
-	val = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_MPIDR_EL1));
-	val++;
-	vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_MPIDR_EL1), val);
+	test_id_reg(vcpu, SYS_MPIDR_EL1);
+	ksft_test_result_pass("%s\n", __func__);
+}
+
+static void test_vcpu_non_ftr_id_regs(struct kvm_vcpu *vcpu)
+{
+	test_id_reg(vcpu, SYS_MIDR_EL1);
+	test_id_reg(vcpu, SYS_REVIDR_EL1);
+	test_id_reg(vcpu, SYS_AIDR_EL1);
 
-	test_reg_vals[encoding_to_range_idx(SYS_MPIDR_EL1)] = val;
 	ksft_test_result_pass("%s\n", __func__);
 }
 
@@ -647,6 +663,9 @@ static void test_reset_preserves_id_regs(struct kvm_vcpu *vcpu)
 	test_assert_id_reg_unchanged(vcpu, SYS_MPIDR_EL1);
 	test_assert_id_reg_unchanged(vcpu, SYS_CLIDR_EL1);
 	test_assert_id_reg_unchanged(vcpu, SYS_CTR_EL0);
+	test_assert_id_reg_unchanged(vcpu, SYS_MIDR_EL1);
+	test_assert_id_reg_unchanged(vcpu, SYS_REVIDR_EL1);
+	test_assert_id_reg_unchanged(vcpu, SYS_AIDR_EL1);
 
 	ksft_test_result_pass("%s\n", __func__);
 }
@@ -675,13 +694,14 @@ int main(void)
 		   ARRAY_SIZE(ftr_id_aa64isar2_el1) + ARRAY_SIZE(ftr_id_aa64pfr0_el1) +
 		   ARRAY_SIZE(ftr_id_aa64pfr1_el1) + ARRAY_SIZE(ftr_id_aa64mmfr0_el1) +
 		   ARRAY_SIZE(ftr_id_aa64mmfr1_el1) + ARRAY_SIZE(ftr_id_aa64mmfr2_el1) +
-		   ARRAY_SIZE(ftr_id_aa64zfr0_el1) - ARRAY_SIZE(test_regs) + 2 +
+		   ARRAY_SIZE(ftr_id_aa64zfr0_el1) - ARRAY_SIZE(test_regs) + 3 +
 		   MPAM_IDREG_TEST;
 
 	ksft_set_plan(test_cnt);
 
 	test_vm_ftr_id_regs(vcpu, aarch64_only);
 	test_vcpu_ftr_id_regs(vcpu);
+	test_vcpu_non_ftr_id_regs(vcpu);
 	test_user_set_mpam_reg(vcpu);
 
 	test_guest_reg_read(vcpu);
-- 
2.42.0

