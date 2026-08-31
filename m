Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3404C3CC7F3
	for <kvmarm@lists.linux.dev>; Mon, 31 Aug 2026 08:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788163833; cv=none; b=sXTy8OXTgZXozcvO6GNIceaT74UVgqeOo+Z0HEyjPAe1O1slTbYw7qY+h+JqNH1aCpJYk99OQkxS1sOmpZdOznYteIIjr9ghRpCcZv1CvQtCneXZQBGHsy6lu5uyKgavMqeRkUvpLAHncAHWieRdDrTgvCiwZsYw5/EqsPrvSHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788163833; c=relaxed/simple;
	bh=QaFutOje1lyg823tSWBbhoOBYa9TMEFhpNTqa16R5ow=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pl5ghniwIVj90AWCHWrLvLx/bgbRCgkd2vTzveDh0SwwYweb/BtHViMCZT2zgkNRWhbxZPDGz47pyIO6ESDUW93Y+k3y4Bs9ek5khPgNUaLUfM+c7PenDEHvV3EKA6ZnMzYziYN28gWfu4AgMINOI9ngvTDjd7eHfVe7irxIGB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=oS8JayXP; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oS8JayXP"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-499ac87c92bso28945435e9.1
        for <kvmarm@lists.linux.dev>; Mon, 31 Aug 2026 01:10:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788163824; x=1788768624; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7d5RXYEUOuzc4V23hC9MU0bXZ0pxNQetgcVjvcKaM1c=;
        b=oS8JayXPuZ4UPfK043dQOVqTDyvAWLzbGar+5lFObE5fwCaiH+jKSgoraifm0+jlj6
         qisFqRUFTvKAXRNqEQxVsjWDDU6zqKvWeYgZBN1OnasAwQiml9jhxz65g3oxAgKy9y2l
         9PQUakYWPmYoab88JMGtMBslMsGmAei2X/CMNRRs367o6xQkC/xobYioHNpDYYkVhXGm
         iixAVhzDhc8SQKBMA3WeAiFhN+m4eNEwi/iNM0Acb2XE/M3dlwTj99Lf74B+Rlq+8fui
         ZB+PgJCh8gjngK8/2v4+OuDpWTkb04zJhD7NJnYqKofAMANn8ppQYObVCIAszgFYrY15
         bgwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788163824; x=1788768624;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=7d5RXYEUOuzc4V23hC9MU0bXZ0pxNQetgcVjvcKaM1c=;
        b=XRphtqQHXjMoOyDlV8YQf3I3RsQcC29QWdkgVhNDaxdXtnqAinEunED9Zjg14+ZpOi
         7VjQr3GD/1O7446UTFqoc9oOF5ZJDmpSVn2/lxGFKSyUdKGviASCENvhi+gZ0CmDM1fz
         skSF9hbRivVD0ycbkyH7iIR3r4zAIYlaTN22+7v8AQUtThiEvILBRpuf3Oz3uJcjowZ4
         1aeiXv5UEDYY97Z6pr0DZqbTTyAEswWaDgI9Nsps7BuASlOhrdaN+OFgluASIQfwzd5z
         PjMbCZmw9sBfgsuV9J+i77gmIcaXRNRaLJs7oKnjPzK0BGbPwmtCtn5DJ1byHk+Hfonu
         HFow==
X-Forwarded-Encrypted: i=1; AHgh+RowRtMA1fugd7qRWoMkwGHMRhEq1shkA4BWCuQF4Vr/WeypZPlveXlCoOU8vnLe0OIS0/X3UjI=@lists.linux.dev
X-Gm-Message-State: AFuF++mkjF5mNAxf0Bg2jPCwGwTY91JwFzTcNrkX6vgCpzZTUkiyRkSO
	cyEKq5b9hmnv1HnnCPLGxztM6eRZnx8tyUD4WY9nKmYUn4oG9tSQTKai
X-Gm-Gg: AR+sD11s/6n7+fYZQR2cR9Fx//G5g//VC1Js5nEXHMi6eovx0XZaIxS/jYAEr9LwIhO
	6Jfbupa6H7tt6hl2QA64RJIFvJabWfKgYj/cv/arS/ticziVTWFpqPGKNgRpmyUZws2sdUcx0LJ
	bh18ep2xd/rhemxLEdtmVFmYF/bsoMcIC++P4+CatwO69HIhJiZPsu2gwiF9Rw9Fjg4E7acpl0B
	bLUq5861XRGRHGiWKY/IFtS+R9OnGW4olhJLWaEUiulVI+858GJSfvmIdShZyAhnb/NtQZHNp1k
	5tTI34WuACLDP/P2+8HOwjHlUJRWmfpuIewsmA8Fw9HhN9GAYpmA3NxhLYYkiBGARB7AHoH4p+8
	enPjX9BHESjaVeIh3qHkGBCma5ytX4AYEeptOD1j5Td6Gx1xVThS8CaDn0wbmOf5hFDQqrYBQBJ
	F0T9x2VyYH+/Oe8Fkvt0NwgUFVN9sBQA/F9RY4bgtVXjUY5NAkiAyBvQud/xLRaPjrP6YljrfgW
	59O6mSKvcttZvu+Ukpxl3RwBTnXepGCk3ICtthJ95dopJ8LVw360jx9UU7IrSiqhK7E6PhM7XQ+
	VRC6RM6PZQFDCXhZREfo8/gX9zRUyia5VGjdWEO7l9uQ7/Lqf3S/0QZ/oYDapidKPf+qTMUEyO0
	ULpDZsw==
X-Received: by 2002:a05:600c:354b:b0:495:4d88:e630 with SMTP id 5b1f17b1804b1-49b91c4fb4amr349472475e9.10.1788163823703;
        Mon, 31 Aug 2026 01:10:23 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a02-3100-acb9-0201-68d0-34d2-ad1a-175a.310.pool.telefonica.de. [2a02:3100:acb9:201:68d0:34d2:ad1a:175a])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49b95013d06sm370393515e9.12.2026.08.31.01.10.21
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 31 Aug 2026 01:10:23 -0700 (PDT)
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
Subject: [PATCH v4 3/4] KVM: arm64: selftests: Pass guest code to vm_gic_create_with_vcpus()
Date: Mon, 31 Aug 2026 10:10:03 +0200
Message-Id: <20260831081005.41346-4-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20260831081005.41346-1-kmehltretter@gmail.com>
References: <20260831081005.41346-1-kmehltretter@gmail.com>
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
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
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
