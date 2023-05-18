Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 717C711CA9
	for <kvmarm@lists.linux.dev>; Thu, 18 May 2023 10:43:21 +0000 (UTC)
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-3f435658d23so18132405e9.3
        for <kvmarm@lists.linux.dev>; Thu, 18 May 2023 03:43:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1684406599; x=1686998599;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EqMiraT0jqWXcG+bHXqX5wyZGJiYv/CtF/7EGjq6y84=;
        b=jA4vgF+XhGJz1pU33vcmktcFLwlg+qKve8S8DUZDR8UtUKBGghS0eASMONnpB8IL3w
         bH6bzweB/XRjyXHEjWzkvDFyiITfosx2uMMsUvWf//QOtMXNQlAtvq+BTGWipGOuIvAV
         +V8W5IJhakzGcZBjYADbDD2LZtPD5mipbfTKLCnmVwp+kJhHjrpJ0pY/dnT36AOhWYSk
         zOkdATE2VE5bsE5+LTaipSqptLRtE1bJ9g+XtswoaQVsb16/8tp8Mq5AivJVGTphQme2
         2QH919F3a5FpXMvDhNahH3iED5cNlXhlk9tSnblOJVJuTOSXGwHWEAfbZ6Gtb7A/XJwo
         LRKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684406599; x=1686998599;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EqMiraT0jqWXcG+bHXqX5wyZGJiYv/CtF/7EGjq6y84=;
        b=GbU+NBggbPey1QfM/cA/H/ri9ESOPz5EQDDellQh5Srp3E1OEbDB43YExR6YiZI/ci
         66XSWCK0Porl8vaM42YpDJP36/I/xY7PZ2lcPjxlycd4O7tefynJQwvBpp0T7v35SlLG
         WqY6h2oyoB5aiqgcDCA2HTdXIedAsh3XMPxd9GD6Mj1QOafAbwJ5+6R82H9V1Fu2qd4Z
         u+qgo//1zODqqXTvi79QmgSeOm7KM+LfBl91ThVPgyy0gLsGluC1tobGgWUivpwDuAkv
         DdruobKDb9RET+dAA9IRvb+KFhfKw13fVE2hWxv5VDaYiYUOuW7mHJdrY5KMDTfDS06W
         MLPg==
X-Gm-Message-State: AC+VfDxPkdQUS7/rncW9bQp5OBeg+rRyOHlKh5SlwqQhdYR4CGP7uSo0
	8qV9HnayREF24lGej1mm/lXJs2Wwyqv4ilbzTH8=
X-Google-Smtp-Source: ACHHUZ6bkkbpOef0ohkRZKtvgvCAeY+yKD673LpiPyqGMA4k4a3ar9LyLAQXKTwinmgx/f4w7uUfpw==
X-Received: by 2002:a05:600c:ca:b0:3f4:9bee:b9c with SMTP id u10-20020a05600c00ca00b003f49bee0b9cmr1269896wmm.18.1684406599643;
        Thu, 18 May 2023 03:43:19 -0700 (PDT)
Received: from localhost.localdomain (5750a5b3.skybroadband.com. [87.80.165.179])
        by smtp.gmail.com with ESMTPSA id f6-20020a1c6a06000000b003f427cba193sm4880523wmc.41.2023.05.18.03.43.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 May 2023 03:43:19 -0700 (PDT)
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: oliver.upton@linux.dev,
	maz@kernel.org
Cc: james.morse@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [PATCH 2/4] KVM: arm64: vgic: Wrap vgic_its_create() with config_lock
Date: Thu, 18 May 2023 11:09:16 +0100
Message-Id: <20230518100914.2837292-3-jean-philippe@linaro.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230518100914.2837292-1-jean-philippe@linaro.org>
References: <20230518100914.2837292-1-jean-philippe@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

vgic_its_create() changes the vgic state without holding the
config_lock, which triggers a lockdep warning in vgic_v4_init():

[  358.667941] WARNING: CPU: 3 PID: 178 at arch/arm64/kvm/vgic/vgic-v4.c:245 vgic_v4_init+0x15c/0x7a8
...
[  358.707410]  vgic_v4_init+0x15c/0x7a8
[  358.708550]  vgic_its_create+0x37c/0x4a4
[  358.709640]  kvm_vm_ioctl+0x1518/0x2d80
[  358.710688]  __arm64_sys_ioctl+0x7ac/0x1ba8
[  358.711960]  invoke_syscall.constprop.0+0x70/0x1e0
[  358.713245]  do_el0_svc+0xe4/0x2d4
[  358.714289]  el0_svc+0x44/0x8c
[  358.715329]  el0t_64_sync_handler+0xf4/0x120
[  358.716615]  el0t_64_sync+0x190/0x194

Wrap the whole of vgic_its_create() with config_lock since, in addition
to calling vgic_v4_init(), it also modifies the global kvm->arch.vgic
state.

Fixes: f00327731131 ("KVM: arm64: Use config_lock to protect vgic state")
Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 arch/arm64/kvm/vgic/vgic-its.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 750e51e3779a3..5fe2365a629f2 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -1936,6 +1936,7 @@ void vgic_lpi_translation_cache_destroy(struct kvm *kvm)
 
 static int vgic_its_create(struct kvm_device *dev, u32 type)
 {
+	int ret;
 	struct vgic_its *its;
 
 	if (type != KVM_DEV_TYPE_ARM_VGIC_ITS)
@@ -1945,9 +1946,12 @@ static int vgic_its_create(struct kvm_device *dev, u32 type)
 	if (!its)
 		return -ENOMEM;
 
+	mutex_lock(&dev->kvm->arch.config_lock);
+
 	if (vgic_initialized(dev->kvm)) {
-		int ret = vgic_v4_init(dev->kvm);
+		ret = vgic_v4_init(dev->kvm);
 		if (ret < 0) {
+			mutex_unlock(&dev->kvm->arch.config_lock);
 			kfree(its);
 			return ret;
 		}
@@ -1960,12 +1964,10 @@ static int vgic_its_create(struct kvm_device *dev, u32 type)
 
 	/* Yep, even more trickery for lock ordering... */
 #ifdef CONFIG_LOCKDEP
-	mutex_lock(&dev->kvm->arch.config_lock);
 	mutex_lock(&its->cmd_lock);
 	mutex_lock(&its->its_lock);
 	mutex_unlock(&its->its_lock);
 	mutex_unlock(&its->cmd_lock);
-	mutex_unlock(&dev->kvm->arch.config_lock);
 #endif
 
 	its->vgic_its_base = VGIC_ADDR_UNDEF;
@@ -1986,7 +1988,11 @@ static int vgic_its_create(struct kvm_device *dev, u32 type)
 
 	dev->private = its;
 
-	return vgic_its_set_abi(its, NR_ITS_ABIS - 1);
+	ret = vgic_its_set_abi(its, NR_ITS_ABIS - 1);
+
+	mutex_unlock(&dev->kvm->arch.config_lock);
+
+	return ret;
 }
 
 static void vgic_its_destroy(struct kvm_device *kvm_dev)
-- 
2.40.0

