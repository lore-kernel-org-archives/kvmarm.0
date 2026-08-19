Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C38A3EEAC2
	for <kvmarm@lists.linux.dev>; Wed, 19 Aug 2026 22:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787179392; cv=none; b=Q05+X477eyN31eXserrB45g8gJCdODeUzD8IpZmmxfRYA/C8kQTRjAyux7enQO93Rw3m3x/kJy/wkUoHZOC+6ZITOuQ9vti+0JLMr99AmnStpGxN/MOvBx+VWmZQpA77KU6s/ICg4OaITIVTSPZDLXhig5XDm8u47vRIFp8lpBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787179392; c=relaxed/simple;
	bh=5J3mZ5DG3X89coFj1lOxV+K0e69xR0vmOMWNHwJ/u4M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=t3UGbk91YRnaS61oqDSUOWWbeYdHx3gzRfY4E/rj3mM7rtWt9B4SWdKqt6eZ6MSYtWJx1KHd/T11DjmtVUkC+mzDg/GNsEWB4bRmYDKF7UnmpMTeUh4foWQ/iHv/lRPbEhV8/RHYwKJMhqV+KNiSIIzedE9CXYCzegjHvWVJ39A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UKF1PESI; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UKF1PESI"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-499840a2575so12127555e9.3
        for <kvmarm@lists.linux.dev>; Wed, 19 Aug 2026 15:43:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787179389; x=1787784189; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=N7MrJ4egxCjisuoRkHErVFW1wlw+AkBqP17Bfxm8jyA=;
        b=UKF1PESIvZxx9ehwf4Bk8YPvU2EdybY4nny6KKdxH2vdeZ1F9B9LsWTj6nXdtQu2nb
         6TqmKCl2z475IvOaEwqJJf8UVzuyw0gAwwex9rd08tibNFpn/aH13EvjiLolga/OK4T3
         gVhFieCrRdbVX+pB6RPCU/7i9XcFyQwLmohrR7VuVBjJlQfxXc1TjqJNh3NZWZbCTHXo
         B32HGx5YZcrb7ucxkGsfW8MoZR8Nti3f2Ma6Fbn4q65sbMKPY+4s8kBdEiW11VDjtXXL
         X8YzHrlR2Wg4W73+R0b9aTSqdm6U3QvF3fkM0IV9EHEvzgXn6sEqqoJ1vzgmZq3sHJjJ
         9ZhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787179389; x=1787784189;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=N7MrJ4egxCjisuoRkHErVFW1wlw+AkBqP17Bfxm8jyA=;
        b=LIqADfrGvqGaJXBqX5tO6UuGdh3bsctFwxMbfaZzo0078ERrqybRBg0I8sYE4NEBgr
         R9CiwUsnQhbtXupjMPvhI74NSq7Vv7vOiPzPHVXW7Ond3c/X5CuvxOUIGaV8sPMjLJjm
         w913wHd1Cb6L1KtjAuOZu3BDx6lJmPRbQNh1dj4604RYcxjSwNWZIXfk4SDNcuJT22BY
         HkMQi7Ay0t8OXjhGptqYZr4jPSQTNCmy+tV/k6ATrbeIgoz92iQPQjxRrVQnemGXxdfT
         j/eVhLsgUldanYf89JvQwgiT8tmxKq7EsPCNsyZLeRnuGobg6Vww+ox4T2adI0IQ/OyI
         Bvhw==
X-Forwarded-Encrypted: i=1; AHgh+RorfcoTcwnXLm4Y6uPiXBuHlLOPb8vsD5fRlBZonR5+LMph/ajA3QbEcDASnp33+iDzRWcAA3E=@lists.linux.dev
X-Gm-Message-State: AOJu0YxJwECKlXgHbq7I/Ed0mVmpsvJVs+q3KIRa+AVjei1BXjCrkBoE
	gecYwGTgB55O3NR++FVOGCYALPSQpxfsJf6OFLqZf8FkT3T1b9PGTm4r
X-Gm-Gg: AR+sD13jJgYMVtbREhSvJ/msn3DqiXSgz2g+VAiCH/nTiByORydDN09fKNjcvmopTv8
	E3sPguSy9wa7DrXcOp+EonLEyjluHZtLl5sxDi8A65ZQsoHZXGaWFkhr+R3aDEg98TUjxxBeAB1
	sBGXqFNm0m8zE9YrztviKgOmP774aL4L561KNDQTt8r7kGL1ESxgQQG3ScGzZvIGYywwivRVBQJ
	3o44ea3HX4DJ9vcMcQYNvQFlD/aY4yVSOmxRGmz2K8zRvHzK5z5VAvEhc5YhwFtlfTfvX78Nk0/
	chzXFIL/eWSUN6q+5OkGZvkb6htpNLDs80UaziKo1cTTTY2V9sKcELGuSq76p0vxwPyBnPSBKNf
	11HLj+NTvr2VA/l6dxdSMp08ndrBI6ikFTGWiHTyX9E8DvOvTgVKY29LuukYDSNHW8VcqiKYA/i
	OjCwqbfJMa6EW8TjiTkOKXTZH7oDUQlvFJ27NxWlKgI+Lyq723R/MmsWeSphip+QJxjb53sNgGP
	6qi+Y0RkbN7zeZ3e6O6hiQ1uZWi9swLNbBbjSQ9ildXNvFKhhSdL2LHP+cSyrFJoNlEcKZzLW3h
	BLMCfaVJEBm0azSo3tX08aMp9h+5t8R25e94ml7bru+/5YfenesiN5q16AZVnjA/HP1pesfFx6z
	7MA==
X-Received: by 2002:a05:600c:a00f:b0:499:9069:c2c9 with SMTP id 5b1f17b1804b1-499aa1b6c8dmr158647395e9.11.1787179388687;
        Wed, 19 Aug 2026 15:43:08 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a02-3100-ae9e-1d01-58d3-443d-4fa6-01cd.310.pool.telefonica.de. [2a02:3100:ae9e:1d01:58d3:443d:4fa6:1cd])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-482b1450e61sm8553317f8f.13.2026.08.19.15.43.07
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 19 Aug 2026 15:43:08 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	Fuad Tabba <tabba@google.com>,
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
Subject: [PATCH v2 4/5] KVM: arm64: selftests: Pass guest code to vm_gic_create_with_vcpus()
Date: Thu, 20 Aug 2026 00:42:28 +0200
Message-Id: <20260819224229.82948-5-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20260819224229.82948-1-kmehltretter@gmail.com>
References: <20260819224229.82948-1-kmehltretter@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Pass the guest entry point to vm_gic_create_with_vcpus(), and use
guest_code at the existing call sites. This lets tests with different guest
code reuse the common VM and VGIC setup.

Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
---
 tools/testing/selftests/kvm/arm64/vgic_init.c | 26 ++++++++++++-------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/kvm/arm64/vgic_init.c b/tools/testing/selftests/kvm/arm64/vgic_init.c
index 47e34b43afb2..91484fd4f786 100644
--- a/tools/testing/selftests/kvm/arm64/vgic_init.c
+++ b/tools/testing/selftests/kvm/arm64/vgic_init.c
@@ -73,12 +73,13 @@ static int run_vcpu(struct kvm_vcpu *vcpu)
 
 static struct vm_gic vm_gic_create_with_vcpus(u32 gic_dev_type,
 					      u32 nr_vcpus,
+					      void (*guest_fn)(void),
 					      struct kvm_vcpu *vcpus[])
 {
 	struct vm_gic v;
 
 	v.gic_dev_type = gic_dev_type;
-	v.vm = vm_create_with_vcpus(nr_vcpus, guest_code, vcpus);
+	v.vm = vm_create_with_vcpus(nr_vcpus, guest_fn, vcpus);
 	v.gic_fd = kvm_create_device(v.vm, gic_dev_type);
 
 	return v;
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
