Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FCCB86250
	for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 09:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713261478; cv=none; b=PZEm/tBUuIlSEUgvMtycI7hHO3cMGAw8DZqGeLgnbE6LpwIfo0nqFZ9XU/AjlkVbqYpmdrzETq9QYqwaeQkPHmRgzGiW5CiyhiGG98cQY165Q10SbkStN8UH9NcP5+WkKwSIax3flOEMjasqqz39Ir1IzscUZvyJ4ZKqvT6s3ro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713261478; c=relaxed/simple;
	bh=W5brc/6wDAHh1Igast3oV83FdsC2mFDy6ZDYdpXveA8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nqsATIfWTzld9TWYmrxuNP9n0P9PZXlWUdjKzZwF6J72urnwgqLFinpieTqm6/AN+K88RlETCnyZTOWpm6e17RS4QrWKUD6CvkbLC3QWJ3Svi+YK0+G8dyMqlTex8H0xve8S3x5jfmPTlDutoFuV/lWw/8bWhMHspiYj9BvaDaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kCqxn1vo; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kCqxn1vo"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6187588d2a7so80598447b3.0
        for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 02:57:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713261476; x=1713866276; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4V+t7GvYUls303k8y9cgJc5uRLMwl8YFYoiO9HFBCmg=;
        b=kCqxn1vooKChzf+50GLYMGa8T1NXcbP3KSUTjMTQoIWBi1MchwPdiY5XIy+nFSBjHT
         CY/gqfWD7LVN69igj+CKDxBM5l124NSpVlUdevwJTPwoYXTHoPKF5IhajnlJV3GYLOOH
         RcgqsqShSVZ7c+WNoEhyLkiH+y2mpQV1IBdUTFM5Sf5Lym2lOBAjXBNdpwQKTlrJFucw
         dunHHQMOT9yb00+aMSCTtk841UXCtXlmPD4dv476rW78L3hon9I9hpZ+axV6+K2vqKvb
         IKbJMOKqIt5mqQIqROgzbLeVGo13O6VZrzpNlaPiQSkdoS/jwJFt5+m/sqboldq3Jra2
         aKJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713261476; x=1713866276;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4V+t7GvYUls303k8y9cgJc5uRLMwl8YFYoiO9HFBCmg=;
        b=pVHkRxWmXhs9vloZor/RVmEtKjXzSqmf9ooNkp9/p8J6EDutAS06nn5wn/VhHmaAmO
         mSpchZthHdJbm5J6nGau7Eo1qbZQ2MP7wuNWKC3Rj926N4wt01RMQVBkl+O5oKZI+0Rx
         33NLOTN0WAn9UkGnZpNnx7lyGK3XgXiOqcc3JNL/DLpOffMZy/ukpA6BvqUOLM8xkjMi
         PImto+9MidCUNRsNNm79ptSAbFv2Kmq0OyQUIAP17w4nXM/BcuDobDPGU9BUrFyintdB
         eB3WvRNYxYGBjwhQ//REau6FzRNlVCNhL08lhV/LqTMzHrtaEzUXAdef5vzn91UhObN0
         onIA==
X-Gm-Message-State: AOJu0YxN/MCxNi6MalwXRakjAJuwSPfTK6ruuXhvxnjSEIOCMNWtN1PN
	FwLGnlw+VUdSjSBTYHlYIX57ykTQt8ontr5TgDAlHCvcr/WiuErrLIOQVjRytF/uzeI0krBDQr7
	aUv9VUuAa1Ff2Y7YcdsonRUd5bCL0u5ESlgQ0mS0GQz3QODf9I/HvTgVCaRZ9SEPDt4B80xGKwt
	3+jgkuYLE3EDKAhQis/Y/wqYQd51A=
X-Google-Smtp-Source: AGHT+IFSQlyM0a48gDT3r90JqXnKl9cLNzN4SnhGh3/3uNBENGMoAqMmHzQmkfkDo3a37HTUD9UgUfpcDQ==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:6902:18d5:b0:ddd:7581:13ac with SMTP id
 ck21-20020a05690218d500b00ddd758113acmr4052193ybb.2.1713261476356; Tue, 16
 Apr 2024 02:57:56 -0700 (PDT)
Date: Tue, 16 Apr 2024 10:56:24 +0100
In-Reply-To: <20240416095638.3620345-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240416095638.3620345-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.683.g7961c838ac-goog
Message-ID: <20240416095638.3620345-34-tabba@google.com>
Subject: [PATCH v2 33/47] KVM: arm64: Document the KVM/arm64-specific calls in hypercalls.rst
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
2.44.0.683.g7961c838ac-goog

