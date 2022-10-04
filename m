Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B45883D8A
	for <kvmarm@lists.linux.dev>; Tue,  4 Oct 2022 15:42:42 +0000 (UTC)
Received: by mail-wm1-f73.google.com with SMTP id y15-20020a1c4b0f000000b003b47578405aso3688375wma.5
        for <kvmarm@lists.linux.dev>; Tue, 04 Oct 2022 08:42:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date;
        bh=WWVFqgTWQ8azi8GP+rBbYb12Qu9xWjqzGv+CBZNgnNI=;
        b=oBoEqzDio3nthQUeORwSc9WqF78dq3gSRCADIdTK4NdWKqLEsBPU2JwA1vCmZkUVuv
         el5KvOgAJcF9TjbnNc12of/1cAuIoS5HEabUiOkhoq8H2DyBgBA1dElxP47hVaDV+nE2
         /9cDFIXxTw8pptszy5hWYfNZh7lWhc5pFIZfQl3IHXOZsCAt/KoCjFJIlmOFcmkC3dZn
         svG465k/9ngQ4cJ2OQ3tu6AwbprWZJMycIG8OJ1LZAV3uqSKeLQeGzpGkJEB5eHAnVd1
         MX/Ah6RV4u4WVfQGqRHdsT08gTri7KH8HXnAqN3FCMOKlFVFFULAEuijckgcHhAUeI3E
         pr1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date;
        bh=WWVFqgTWQ8azi8GP+rBbYb12Qu9xWjqzGv+CBZNgnNI=;
        b=6aIe/hsL71UglbGyYN+mX4olAII6lenT5VCT6lW5mIoUG0b1uiv+CETjzIltxcxvn0
         m5d9Rh/uTRx0Q6olK9tlrZABs9ILrPT1pG3csOhR9Wsq0yUewNxLCk9u/z4CUIJtIqIs
         WU8wA0MIZrWYJAsEgbnBM3V280TlcDuRTpt/Md5XxG/HEWlrK3UnVgRFsNh90lGIJurG
         bKmGIIoKVlRDvUXBeZmKww9PwYWrf/gBc5kuBFSEnQz8V27AOpFE0QlYxz/xrTC9QG5w
         ZD6Sk7mkqJ0anVYXgpZVlW1WG4iwM9yhMKyz1O6bVdmCun/kAeR1cmq4pSx1MZolSHva
         nehw==
X-Gm-Message-State: ACrzQf2DG6YElsAuLceMaMOURCd2MpxNolPgHZK7p1AXw/uL3VOYsOSP
	kGW5VFZjI1ztpLOLwLnMkUNOQyGVaEkDa1zF
X-Google-Smtp-Source: AMsMyM4Ksa4T0ArbfPMDLZVlL5cHxR1tviks7FEOUK08OSlqKrb5KWwNP7bKMDffZ41Q+zvTqKilvIy1hcZ2MllU
X-Received: from vdonnefort.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:2eea])
 (user=vdonnefort job=sendgmr) by 2002:a05:600c:3483:b0:3b4:99f4:1191 with
 SMTP id a3-20020a05600c348300b003b499f41191mr251856wmq.147.1664898160929;
 Tue, 04 Oct 2022 08:42:40 -0700 (PDT)
Date: Tue,  4 Oct 2022 16:42:16 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20221004154216.2833636-1-vdonnefort@google.com>
Subject: [PATCH] KVM: arm64: Enable stack protection and branch profiling for VHE
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oliver.upton@linux.dev
Cc: james.morse@arm.com, alexandru.elisei@arm.com, suzuki.poulose@arm.com, 
	will@kernel.org, catalin.marinas@arm.com, qperret@google.com, 
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

For historical reasons, the VHE code inherited the build configuration from
nVHE. Now those two parts have their own folder and makefile, we can
enable stack protection and branch profiling for VHE.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/kvm/hyp/Makefile b/arch/arm64/kvm/hyp/Makefile
index 687598e41b21..a38dea6186c9 100644
--- a/arch/arm64/kvm/hyp/Makefile
+++ b/arch/arm64/kvm/hyp/Makefile
@@ -5,9 +5,6 @@
 
 incdir := $(srctree)/$(src)/include
 subdir-asflags-y := -I$(incdir)
-subdir-ccflags-y := -I$(incdir)				\
-		    -fno-stack-protector		\
-		    -DDISABLE_BRANCH_PROFILING		\
-		    $(DISABLE_STACKLEAK_PLUGIN)
+subdir-ccflags-y := -I$(incdir)
 
 obj-$(CONFIG_KVM) += vhe/ nvhe/ pgtable.o
diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index b5c5119c7396..48f6ae7cc6e6 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -10,6 +10,9 @@ asflags-y := -D__KVM_NVHE_HYPERVISOR__ -D__DISABLE_EXPORTS
 # will explode instantly (Words of Marc Zyngier). So introduce a generic flag
 # __DISABLE_TRACE_MMIO__ to disable MMIO tracing for nVHE KVM.
 ccflags-y := -D__KVM_NVHE_HYPERVISOR__ -D__DISABLE_EXPORTS -D__DISABLE_TRACE_MMIO__
+ccflags-y += -fno-stack-protector	\
+	     -DDISABLE_BRANCH_PROFILING	\
+	     $(DISABLE_STACKLEAK_PLUGIN)
 
 hostprogs := gen-hyprel
 HOST_EXTRACFLAGS += -I$(objtree)/include
-- 
2.38.0.rc1.362.ged0d419d3c-goog

