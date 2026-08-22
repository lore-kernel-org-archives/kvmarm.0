Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 291A43B9D83
	for <kvmarm@lists.linux.dev>; Sat, 22 Aug 2026 09:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787392449; cv=none; b=JZZPW/4b+/gCG+DMDTUgUNrLufUGQ6qkUGtSOrjz45NJb8bMkzvOMAnyEZdM/81uLStKajtBVHuU53o7VDIKa5kyBT/acyXXNopnJ/odj39/4rn8QVqi9KucjCfWxlk+DFWgmXpxc7Rdk+ub6k/prqrcc6i9k9F7W9cVgBGuL6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787392449; c=relaxed/simple;
	bh=x1giPFDv/gONXuicCcEUE5OwuiGeHJuokCnsgSDm8JE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hWRBzLiHZow2RO4FtrDiX2iMj6o9SJv9+EkUCgid5d+l9DAtTMr+y8ekKbE9c6Rcz5RIjUv92os6IBTbbtAXRnDpU87uT/3XAmEHkXfrX9iqVleZrlp+3ynY7aOmMR5sSbN6h0lqQiWNQH8Xdl0PMtnPWPKKJLFM9PAQiIKSREY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=adPehZ/j; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="adPehZ/j"
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-69c600f76ccso3194485a12.0
        for <kvmarm@lists.linux.dev>; Sat, 22 Aug 2026 02:54:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787392443; x=1787997243; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IJR++uOi5dTiSKJhpV6uor7RZpeZqCuTfsiFF6sw6hM=;
        b=adPehZ/jore95rxeSZTlzsNTxxCDMqbXiPWnB1t+0dQj2ZqYDofu1c7ZFVxK4m33UH
         qU9AiOhXPS42MARsnnOf+IOhn+DI3kGhSMjmpGhLS/CoXDQgZdB1b4cmk+lF3P1drIAg
         GAFYODdIrv302SjwjIyAXg0hdOE4PwGSDPvUmnkY0Zxb5qE1NAYfT+E+HRIgraine2bt
         X4JDmj3YXI5O/Zp4OHkkmVZ0AUbSZQ/0+tUet6kmkJbYUH9pe88SCaZA6rsOVkff+Ii8
         74uQOhH2pyMgocCnILPQD5vyUnlgHKGdn4T0m5nJpK9irFKWIGrojNonD0N8C5pmunDs
         lIhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787392443; x=1787997243;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=IJR++uOi5dTiSKJhpV6uor7RZpeZqCuTfsiFF6sw6hM=;
        b=TCmQd/nc+g/TxNK8W0Zro3C3lTH3kgxi51J3Qee3rT+PbVhKGIro96v9m2OcrUFQ8a
         0qfS7+Mr17whvjKd8Wh99OEAiy4qJOXbqPT5eKVSo+6+ZgplwEeP+m5kaIMxy8M2Mchh
         IixNaEavpFCvHBoVkbO4mYl8lsAzXieKnsh04NtIMC9TBTBj8JSmR/UUpacgMe6anxHL
         FgA8rhexrBIY3R012+uG1DL8DOLY5OtaP9MFqe/8iwkK+4NjQm6Gy+S7D65s+yMuR+EU
         4J+GXMCjpz4VyO2EWu58fZiSHoOcGXW3TTw2G41NGpQCnmT1PD7ogFo1gHo4XO6xc9rs
         EL6w==
X-Forwarded-Encrypted: i=1; AHgh+RqexCCHUrkh2X9kAuYRB5JXb78sw2Cd3bv1tj5K1rpOt5jEKapnzVZuOWRGJMhOV3N1nVeZ6F8=@lists.linux.dev
X-Gm-Message-State: AFuF++n6n9qY4QPZLJUcENPNyCruLIYH9Np/n5wIjvV7ugvA60ri1b9P
	EfQ1eWwMSDh/FlQtU46mr6p5mfVucC9lCeRP2cy6aSCYZzuBGBGnsYeQ
X-Gm-Gg: AR+sD12w7bga6W4bx8gM/aHVUzaxcx7IAeKTOelI83IZIiEo7kkGLnAbetcqQ6JJ7sK
	1E+4v+bgMSV7SCJ8TvBDKdiqH0VlTAp237ZymRbs2qDGWw03RQSotbV4yl5VukjUEaE2cHY7NGL
	UB4UQLwmSE9LlPGjlyZH3LrYgfVZVtAl2WDPQSD4YKlt0+Ti8C+QIZWSOLd6ENiWFneZnXcUYfA
	oS1l/9E20VFCJxjiJ8Qe8ziVo4bTtMofGG0K/l569gQ0JNusGRmsLjO5LRu0bFW3VpDYywcbKMQ
	EGBnTVS7X85iCmxPEhAyX6j5w29yNPRF9sLvvExWGrl39O+YWTy1NbB9lVx4nG/F6bTJ3k9vzvP
	Dsd9A8mH/OXK0TI+3PLPUN5Ee8DEZ6rN5aQO60pPgT2Iq7301ocYZtWlYFCUtxZvtGvOjqTZQCF
	uppbBEaO88o2p7skFFwrlhRWDKrFvhUEmSwNdSH0R6EEkv7vW74aiQjEm+93OQrUU8gaLL/gpda
	HAsDExlTqVLAha4ui8JvFDiRmw9TkQ3L5JnbUlgaIcuJwJpcqgdoE0yCLwzlGVTyifees3a/WKl
	YD6lRBED9aTpYhrSZy4/m6470EeUTpeNMQ1Nj7bNK5tdDowHpSQuUY9YHLRWD2V60cBB
X-Received: by 2002:a05:6402:21dc:b0:6a3:fee5:adcf with SMTP id 4fb4d7f45d1cf-6a42f14d952mr13251775a12.1.1787392443344;
        Sat, 22 Aug 2026 02:54:03 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a02-3100-a0f5-8c01-3de3-cd62-aa6f-2fb0.310.pool.telefonica.de. [2a02:3100:a0f5:8c01:3de3:cd62:aa6f:2fb0])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a3ff0c327asm11151586a12.8.2026.08.22.02.54.02
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 22 Aug 2026 02:54:02 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	Eric Auger <eric.auger@redhat.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH v3 4/5] KVM: arm64: selftests: Pass guest code to vm_gic_create_with_vcpus()
Date: Sat, 22 Aug 2026 11:53:45 +0200
Message-Id: <20260822095346.53882-5-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20260822095346.53882-1-kmehltretter@gmail.com>
References: <20260822095346.53882-1-kmehltretter@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Pass the guest-code address to vm_gic_create_with_vcpus(), and use
guest_code at the existing call sites. This lets tests with different guest
code reuse the common VM and VGIC setup while retaining the void *
interface of vm_create_with_vcpus().

Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
---
 tools/testing/selftests/kvm/arm64/vgic_init.c | 24 ++++++++++++-------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/kvm/arm64/vgic_init.c b/tools/testing/selftests/kvm/arm64/vgic_init.c
index 47e34b43afb2..84aa97204b7f 100644
--- a/tools/testing/selftests/kvm/arm64/vgic_init.c
+++ b/tools/testing/selftests/kvm/arm64/vgic_init.c
@@ -73,6 +73,7 @@ static int run_vcpu(struct kvm_vcpu *vcpu)
 
 static struct vm_gic vm_gic_create_with_vcpus(u32 gic_dev_type,
 					      u32 nr_vcpus,
+					      void *guest_code,
 					      struct kvm_vcpu *vcpus[])
 {
 	struct vm_gic v;
@@ -338,7 +339,7 @@ static void test_vgic_then_vcpus(u32 gic_dev_type)
 	struct vm_gic v;
 	int ret, i;
 
-	v = vm_gic_create_with_vcpus(gic_dev_type, 1, vcpus);
+	v = vm_gic_create_with_vcpus(gic_dev_type, 1, guest_code, vcpus);
 
 	subtest_dist_rdist(&v);
 
@@ -359,7 +360,8 @@ static void test_vcpus_then_vgic(u32 gic_dev_type)
 	struct vm_gic v;
 	int ret;
 
-	v = vm_gic_create_with_vcpus(gic_dev_type, NR_VCPUS, vcpus);
+	v = vm_gic_create_with_vcpus(gic_dev_type, NR_VCPUS, guest_code,
+				     vcpus);
 
 	subtest_dist_rdist(&v);
 
@@ -411,7 +413,8 @@ static void test_v3_new_redist_regions(void)
 	u64 addr;
 	int ret;
 
-	v = vm_gic_create_with_vcpus(KVM_DEV_TYPE_ARM_VGIC_V3, NR_VCPUS, vcpus);
+	v = vm_gic_create_with_vcpus(KVM_DEV_TYPE_ARM_VGIC_V3, NR_VCPUS,
+				     guest_code, vcpus);
 	subtest_v3_redist_regions(&v);
 	kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
 			    KVM_DEV_ARM_VGIC_CTRL_INIT, NULL);
@@ -422,7 +425,8 @@ static void test_v3_new_redist_regions(void)
 
 	/* step2 */
 
-	v = vm_gic_create_with_vcpus(KVM_DEV_TYPE_ARM_VGIC_V3, NR_VCPUS, vcpus);
+	v = vm_gic_create_with_vcpus(KVM_DEV_TYPE_ARM_VGIC_V3, NR_VCPUS,
+				     guest_code, vcpus);
 	subtest_v3_redist_regions(&v);
 
 	addr = REDIST_REGION_ATTR_ADDR(1, 0x280000, 0, 2);
@@ -436,7 +440,8 @@ static void test_v3_new_redist_regions(void)
 
 	/* step 3 */
 
-	v = vm_gic_create_with_vcpus(KVM_DEV_TYPE_ARM_VGIC_V3, NR_VCPUS, vcpus);
+	v = vm_gic_create_with_vcpus(KVM_DEV_TYPE_ARM_VGIC_V3, NR_VCPUS,
+				     guest_code, vcpus);
 	subtest_v3_redist_regions(&v);
 
 	ret = __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
@@ -608,7 +613,8 @@ static void test_v3_redist_ipa_range_check_at_vcpu_run(void)
 	int ret, i;
 	u64 addr;
 
-	v = vm_gic_create_with_vcpus(KVM_DEV_TYPE_ARM_VGIC_V3, 1, vcpus);
+	v = vm_gic_create_with_vcpus(KVM_DEV_TYPE_ARM_VGIC_V3, 1, guest_code,
+				     vcpus);
 
 	/* Set space for 3 redists, we have 1 vcpu, so this succeeds. */
 	addr = max_phys_size - (3 * 2 * 0x10000);
@@ -641,7 +647,8 @@ static void test_v3_its_region(void)
 	u64 addr;
 	int its_fd, ret;
 
-	v = vm_gic_create_with_vcpus(KVM_DEV_TYPE_ARM_VGIC_V3, NR_VCPUS, vcpus);
+	v = vm_gic_create_with_vcpus(KVM_DEV_TYPE_ARM_VGIC_V3, NR_VCPUS,
+				     guest_code, vcpus);
 	its_fd = kvm_create_device(v.vm, KVM_DEV_TYPE_ARM_VGIC_ITS);
 
 	addr = 0x401000;
@@ -684,7 +691,8 @@ static void test_v3_nassgicap(void)
 	u32 typer2;
 	int ret;
 
-	vm = vm_gic_create_with_vcpus(KVM_DEV_TYPE_ARM_VGIC_V3, NR_VCPUS, vcpus);
+	vm = vm_gic_create_with_vcpus(KVM_DEV_TYPE_ARM_VGIC_V3, NR_VCPUS,
+				      guest_code, vcpus);
 	kvm_device_attr_get(vm.gic_fd, KVM_DEV_ARM_VGIC_GRP_DIST_REGS,
 			    GICD_TYPER2, &typer2);
 	has_nassgicap = typer2 & GICD_TYPER2_nASSGIcap;
-- 
2.39.5 (Apple Git-154)

