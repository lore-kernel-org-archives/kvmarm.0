Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6B5D482C7
	for <kvmarm@lists.linux.dev>; Fri, 19 Apr 2024 08:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713513655; cv=none; b=oHGNEg4RNoFbxvlLeHM1+MIx5gwdJXQbFD0eeMFtFxdcSl6XIhZ8f7KvvxiPQ59JnLReQvbaCzqlctKCz567j7qffcCvk1ZQbp9dX9xOjwZb+q4D1ncU0QAAh4fYuR2ioMmDEn5ydx3U6DSMHlSrrXoWgH+yNt7pWcKQ5SGiXaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713513655; c=relaxed/simple;
	bh=cCHQF0XVk5G3P4NxbSCwArUmCPI5JTZZRwEAsaFGE2M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cR9MDcQUh0u/yhhXA7I0fKqmRrLxbvj68VURksJ3xXkGDAn77gRTupuVB1ozZeIhWVPtNg52I7fAGz/YtaZvFdyptWQADG2H6pWyGv6jrviFtq8P/RoIyxuvYixxFdqkuE3A9u5mPeJ69IFvtvPxaMi2cWC0N6c2y3KJ2MusDoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4eZteQLG; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4eZteQLG"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-de4717cd857so2168991276.0
        for <kvmarm@lists.linux.dev>; Fri, 19 Apr 2024 01:00:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713513652; x=1714118452; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/ptNcBsi0GBuHpcbC0xku8AtWG11nDZkJ3K0I8TGeeA=;
        b=4eZteQLGM7fhGzIagDTKq3fZSZOI1vT53pASAfJ1c7i6FVxxmmHIrARA7fPvK2dHfc
         +22EqBoyTExjtMKBJgkHJ1h3j2luSQGuwQdoLtqzhSJXO6sdTkOahU6lxIno31cojoFY
         3G2Uj9ETDxPsEIXBB/02qE9zTPKeiITnG9SWuYxoIrJEUh4HwFrK7y2RWAomeJ2aJowy
         CuCcqDHfVaq5WVnJZVl4/+fMF9+AIHVz0QQMZ4LSrWUBhKF4rxx1V+arAm04gBGo0NC3
         NNP/nzL+vhOYRbc0ZP5/vJXlVe8c8tq7fWQNahsHa5DdFo5WlYjOsGbsA6UlBURc7XtX
         mEfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713513652; x=1714118452;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/ptNcBsi0GBuHpcbC0xku8AtWG11nDZkJ3K0I8TGeeA=;
        b=hpskzZfatHeg7wx3I/YGT5BEyQnQtKTKerIGKpr2HzL2S/67HvX/eKBjJMi+1JxtHj
         G5i/uZEcajcj5iQvSiciQkKQLb1wO8uv39p7j6qbFO1f4xRfYXvmp8WYXFI93puNiNys
         4OfIbHojUSsHOAHRfIauV2zKrbM8ycbEeIsTq8L40KIqT/CFIlGCMnxvLQqb/rXi2OQ1
         PJfayuX4iFZ9ew3wXW7gwfN7TIM5h4cKS6M2RxE2oTKKG+0jBUiTSFUmYz4tFWC2Cax7
         tYg4QiOE7N7yA3hzujYsHueIqQU1nNuRfxEzOzjiHURMUFStZSRzMIWputHxSjy31z3z
         tTlQ==
X-Gm-Message-State: AOJu0Yy6SLLBALtHVgfnXVVXyUQqQF5dTE8yu6OpBwwYC3a5pOzvy3o2
	LI8Bp+XefC+jksAPTyQDpVD0QPKnc+tEM0xVrd8Al8RSCUjpRyHB+wgMk065/hGuQGRWeoCfabA
	zBpN8fGRUhtHOnKzPY2f7w+rUHVbqJnAoYMkr4EoMBXy+6DqtqOy6rqsEmG1bLLulu8ge16Z5iZ
	wADsLd1Kf0p+ByIBZbmx3MCm0AdcA=
X-Google-Smtp-Source: AGHT+IG3uRMzqed+NAJJMLrXwyaGKk412dZclo7Ci6WEFDtEoRQ6bzgr6Ckva/W5ALsgvkgPrZSsALatvg==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:6902:c10:b0:dbd:b165:441 with SMTP id
 fs16-20020a0569020c1000b00dbdb1650441mr389872ybb.0.1713513651866; Fri, 19 Apr
 2024 01:00:51 -0700 (PDT)
Date: Fri, 19 Apr 2024 08:59:40 +0100
In-Reply-To: <20240419075941.4085061-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240419075941.4085061-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
Message-ID: <20240419075941.4085061-31-tabba@google.com>
Subject: [PATCH v3 30/31] KVM: arm64: Document the KVM/arm64-specific calls in hypercalls.rst
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com, smostafa@google.com
Content-Type: text/plain; charset="UTF-8"

From: Will Deacon <will@kernel.org>

KVM/arm64 makes use of the SMCCC "Vendor Specific Hypervisor Service
Call Range" to expose KVM-specific hypercalls to guests in a
discoverable and extensible fashion.

Document the existence of this interface and the discovery hypercall.

Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 Documentation/virt/kvm/arm/hypercalls.rst | 46 +++++++++++++++++++++++
 Documentation/virt/kvm/arm/index.rst      |  1 +
 2 files changed, 47 insertions(+)
 create mode 100644 Documentation/virt/kvm/arm/hypercalls.rst

diff --git a/Documentation/virt/kvm/arm/hypercalls.rst b/Documentation/virt/kvm/arm/hypercalls.rst
new file mode 100644
index 000000000000..17be111f493f
--- /dev/null
+++ b/Documentation/virt/kvm/arm/hypercalls.rst
@@ -0,0 +1,46 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+===============================================
+KVM/arm64-specific hypercalls exposed to guests
+===============================================
+
+This file documents the KVM/arm64-specific hypercalls which may be
+exposed by KVM/arm64 to guest operating systems. These hypercalls are
+issued using the HVC instruction according to version 1.1 of the Arm SMC
+Calling Convention (DEN0028/C):
+
+https://developer.arm.com/docs/den0028/c
+
+All KVM/arm64-specific hypercalls are allocated within the "Vendor
+Specific Hypervisor Service Call" range with a UID of
+``28b46fb6-2ec5-11e9-a9ca-4b564d003a74``. This UID should be queried by the
+guest using the standard "Call UID" function for the service range in
+order to determine that the KVM/arm64-specific hypercalls are available.
+
+``ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID``
+---------------------------------------------
+
+Provides a discovery mechanism for other KVM/arm64 hypercalls.
+
++---------------------+-------------------------------------------------------------+
+| Presence:           | Mandatory for the KVM/arm64 UID                             |
++---------------------+-------------------------------------------------------------+
+| Calling convention: | HVC32                                                       |
++---------------------+----------+--------------------------------------------------+
+| Function ID:        | (uint32) | 0x86000000                                       |
++---------------------+----------+--------------------------------------------------+
+| Arguments:          | None                                                        |
++---------------------+----------+----+---------------------------------------------+
+| Return Values:      | (uint32) | R0 | Bitmap of available function numbers 0-31   |
+|                     +----------+----+---------------------------------------------+
+|                     | (uint32) | R1 | Bitmap of available function numbers 32-63  |
+|                     +----------+----+---------------------------------------------+
+|                     | (uint32) | R2 | Bitmap of available function numbers 64-95  |
+|                     +----------+----+---------------------------------------------+
+|                     | (uint32) | R3 | Bitmap of available function numbers 96-127 |
++---------------------+----------+----+---------------------------------------------+
+
+``ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID``
+----------------------------------------
+
+See ptp_kvm.rst
diff --git a/Documentation/virt/kvm/arm/index.rst b/Documentation/virt/kvm/arm/index.rst
index d28d65122290..ec09881de4cf 100644
--- a/Documentation/virt/kvm/arm/index.rst
+++ b/Documentation/virt/kvm/arm/index.rst
@@ -9,6 +9,7 @@ ARM
 
    fw-pseudo-registers
    hyp-abi
+   hypercalls
    pvtime
    ptp_kvm
    vcpu-features
-- 
2.44.0.769.g3c40516874-goog

