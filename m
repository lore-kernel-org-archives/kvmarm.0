Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0774D7E101
	for <kvmarm@lists.linux.dev>; Tue, 23 Apr 2024 15:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713884806; cv=none; b=DqPeYimS+knrUCy8Xxg9mVOTW9yN9a4fwMtnDIfBzQ42SvdhPFnqMyP0Tz1+/FEA1X8TYDVjztUeeiUr2cHNGdZQyazzf+WRsq8ptLU6qthVQgueYgm6kl/7g549jPPs/PGvMbH19+nZZdXwvQ9RiDfSf6QtBaJT16PPlXer3cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713884806; c=relaxed/simple;
	bh=cCHQF0XVk5G3P4NxbSCwArUmCPI5JTZZRwEAsaFGE2M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DXkGZjMwm92QvXg9Dc1vgcuILunkwBX98+N+PZqcm8ELUieJKuapngoDIi+uDzJ2xQLq5V4fuom07DAHJd5XHDxcUxkjnqt4srfuIfsYzPRJ9T5RHYO6yFVXHVVrQ/QGydVPDneZ9S7pWENbOwgrvkfgofbVmR/A/ysY6i4ewAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=f5tc/iBz; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="f5tc/iBz"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-61891efba06so104058457b3.0
        for <kvmarm@lists.linux.dev>; Tue, 23 Apr 2024 08:06:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713884803; x=1714489603; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/ptNcBsi0GBuHpcbC0xku8AtWG11nDZkJ3K0I8TGeeA=;
        b=f5tc/iBzNqDvbIkZyOzl+jHmOnSBACUSSem9qsvFxj08iQowFCcW5oOY2XfEkF/+HI
         e3Ts3xKd9u6c9DEyQN8jHcN7P8jPzaTbYTWr+UFxeL15WHGtiacpF1JFf9y1i6R+8cMR
         Q137qmqVVOXGwKMERc2CBJLYYkKg4KGpgN0ZiXtDTU8yB0fzL1aRckKsO3iB4KTAOML4
         BjVF0fFcTicaXSy9MiK0ajLylOYPzj6Sw4SQMmKlTRpfvmdCZ0j8FGvBm7p8RQYb6u2a
         DFOzDYu9DzVA56+WYli1FN9rv5FuZ8P8bYAjXffnXWXHIjHZ34Puk3t+X+NAP7NNhihs
         ykHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713884803; x=1714489603;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/ptNcBsi0GBuHpcbC0xku8AtWG11nDZkJ3K0I8TGeeA=;
        b=fXVQHPWK5uaPvER5zGyjro+ABvgVFWi4ZwwZw9TPPHiiKNdcJdDtAJs8+rOtqdIkCB
         Jy+CL/Cnqf/OEXa8P5aIff0WlJteirccLfhtqMIrOpDsSrLFJ7ZwHFZgeUESoyL78YjA
         sSIK20aOz/vv/3SIarnM/9fM6Qisvu+Wc022AS1AsgI+sDN02jqB9xVgvU0C/jvvOnSt
         +XD1i63iURDGmkr4ulMZv9QOv5sBCfysRTBuz1aXH1xylyBdKvV2Bn0+T1QFH9PyiRNV
         Er0s9Xa1/WDXzCNiwQ6bmTo4eGbfE1X3EyPvCxbr2xcof7As4+MGDDuVcJMGZFDS6ob6
         /KNA==
X-Gm-Message-State: AOJu0YxFqFtRs2/gDCkRUWskWQdYX4KiDyMgDEgaskxS4LIKy5RHZVzc
	zsAq2cQL3fJ4uEaP3osfwLjld3DteeP8uxUU7U9WovBATtSx/Y0W96ffcpMZxKSxgWpTtKOPLtA
	/xFBYLW6zAkf4jrJH7IXu4rbbZSRNbxFs/17LKum5pcSlYEFYkWYt4kzU6Omyf7+sZlGTuTpraS
	wcc8fpTnxtC1aXrrsbqz7OkMvrQMk=
X-Google-Smtp-Source: AGHT+IFFevVb9sJU6JXl1dGAPAzd4w8KOhx5dN69GbR7lsN/5QTnbPNdXphbEMn2D1TYZxbpICyxWmihug==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a0d:ee42:0:b0:615:27b6:7624 with SMTP id
 x63-20020a0dee42000000b0061527b67624mr3091339ywe.6.1713884802993; Tue, 23 Apr
 2024 08:06:42 -0700 (PDT)
Date: Tue, 23 Apr 2024 16:05:35 +0100
In-Reply-To: <20240423150538.2103045-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240423150538.2103045-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
Message-ID: <20240423150538.2103045-28-tabba@google.com>
Subject: [PATCH v4 27/30] KVM: arm64: Document the KVM/arm64-specific calls in hypercalls.rst
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

