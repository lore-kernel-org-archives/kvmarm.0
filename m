Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D545B1BDAB9
	for <kvmarm@lists.linux.dev>; Mon, 14 Oct 2024 16:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728925100; cv=none; b=RNXrqVkmxyK8NZkXZ6rtaIJvIOf6tqWxzssUoZj0Xi1LLUgepXDf3NkWcfgPHeBV7k4Vz+YfZWXc7MDPGIFodNUBqvPTktgxAYjJbjdJ0VP6KCPTTaRWdlyEaT7XbIzSEeo/gt/GlwGAmtNQ72rK3CfxQcvUHvxWayiIpNf52XY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728925100; c=relaxed/simple;
	bh=y+k9fD9Ycx78jXFOy+rSZlxt0TEAJ7/12locmO02ZZU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XVL5xS8uyE6b8mT1oqjB317kjrUXhKodupwheX3QHTdf4kaNbLZpv7/ezjfi4UXIZXnu1xVeeoGiCHouOdIs+pUvHDvkyAe+7XN40iD4R5d/NcWUNfeJYhz1wHVNNQfhAQAfQKTW3w1jdTw5imJ7oR/2Hw65Hk8zdbl4lBcqKuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=krva02sx; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="krva02sx"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-43117570814so24661255e9.1
        for <kvmarm@lists.linux.dev>; Mon, 14 Oct 2024 09:58:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728925097; x=1729529897; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZLtUyNhFMHHs/7YTTdXbczw8uTe+QwKx7AUgeoy4qzk=;
        b=krva02sxIyvDwCNmCnEFuJ/jQp04Qw+0HqvJz/pk8SKN9hQHSrkrgYYFYeapSd/n9R
         9BKtE6S1r7YlCMPb/I7nP9JmS3PZgeV41hAAS9ezcmOjSgozFC53FpMROCA647Y1DsKz
         H1zx+zUEr2EW+G8CKfFRrsl8JXNGharOD/E080MlumuDrujJEdsNynYERk8WjikYRsvo
         cz1+rAhfeZwdUROMs6IJUNS5S0rl/+WG4Y7tx2GkJLmm2vadA+GbWbEppNE1X+G7cosK
         S2GSMc6azebuEou2gAGEh5NICI34wvUCl3Qx32dSv/vvBF1eA8BE/mWt3aqdeIRDY/13
         Tl+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728925097; x=1729529897;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZLtUyNhFMHHs/7YTTdXbczw8uTe+QwKx7AUgeoy4qzk=;
        b=xHB/VldzzxNkC2U61mKbENeWPJvNnxqofA//Idz4nfVsC9bEZmKlVam+FqeXvHlJdw
         YbYwaxTVpfu93f0aYpXyPs3Zn/CSOYOdKnmAfI8K2JPOnPbQsTpf558cvPbrnK00OBlR
         tQidppr9efrxKDVHaw1LPD8fLXfm4KnnOZ8mDmsibVdPBbwXix+D/WgxdYDZCUOtxtIs
         MHcqcQATVQr3rUW4vn1xZwxNJ/Ru5yiydpQbA3VAWt0CLd/ZRMes5zVbdMSzlDMj94h9
         O3TcQLsU/uJrP7p6akIbhAFMGgqfsGDZqwu1W123Q08WM3mcWxeKaK4mUaJnq3Ow63kP
         F6tQ==
X-Gm-Message-State: AOJu0Ywq2n7JzUYjxiuItJynPCg8O6memmUbX4oyvF2o4BRTWXUX1ZBx
	LBZtV4juZYCx1DbHvlr7svMY700Htg3izICmapFuDIabc4HwSfabAQEyA1ode93bCq9QfHKP5ta
	wBe2sxjXIm1i7UCijScwUt2/WpoCYX71D0NmI5cWgSyAQOFiG9u4xhHQSoYUkS142X962H47WPe
	ccKZ0SGDg66pA+VYi+ib3VuOCILAg=
X-Google-Smtp-Source: AGHT+IFbBSmmEEM+euu2DHz4/GzGADWD9ciMpZSbsyh9ak//0Fr1YFSKmrLYQhDbs48bQ/23b317nRYjBA==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:600c:1c96:b0:42c:a8b5:c1b with SMTP id
 5b1f17b1804b1-4311de86414mr1376015e9.2.1728925096679; Mon, 14 Oct 2024
 09:58:16 -0700 (PDT)
Date: Mon, 14 Oct 2024 17:58:07 +0100
In-Reply-To: <20241014165809.984883-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241014165809.984883-1-tabba@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241014165809.984883-3-tabba@google.com>
Subject: [PATCH v1 2/4] KVM: arm64: Move KVM_VCPU_MAX_FEATURES to the features
 it is counting
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, oliver.upton@linux.dev, catalin.marinas@arm.com, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	will@kernel.org, christoffer.dall@arm.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Move KVM_VCPU_MAX_FEATURES to the header file that has the
features it is counting. Having it there reduces the chances of
missing to update it.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_host.h | 3 ---
 arch/arm64/include/uapi/asm/kvm.h | 3 +++
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 78c068592d73..85901afeb332 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -39,9 +39,6 @@
 
 #define KVM_MAX_VCPUS VGIC_V3_MAX_CPUS
 
-#define KVM_VCPU_MAX_FEATURES 8
-#define KVM_VCPU_VALID_FEATURES	(BIT(KVM_VCPU_MAX_FEATURES) - 1)
-
 #define KVM_REQ_SLEEP \
 	KVM_ARCH_REQ_FLAGS(0, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQ_IRQ_PENDING	KVM_ARCH_REQ(1)
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 964df31da975..2d5fd0ed7dff 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -109,6 +109,9 @@ struct kvm_regs {
 #define KVM_ARM_VCPU_PTRAUTH_GENERIC	6 /* VCPU uses generic authentication */
 #define KVM_ARM_VCPU_HAS_EL2		7 /* Support nested virtualization */
 
+#define KVM_VCPU_MAX_FEATURES 8
+#define KVM_VCPU_VALID_FEATURES	(BIT(KVM_VCPU_MAX_FEATURES) - 1)
+
 struct kvm_vcpu_init {
 	__u32 target;
 	__u32 features[7];
-- 
2.47.0.rc1.288.g06298d1525-goog

