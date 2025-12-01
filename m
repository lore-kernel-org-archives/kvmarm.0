Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E83AA333452
	for <kvmarm@lists.linux.dev>; Mon,  1 Dec 2025 18:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764613284; cv=none; b=M6/g4tgSEetm68hs9AMd1Dp+4E5sNzQZ8uJLRwUBS5asKUhfkB9yvw9Y3HfWXnZf/+CKdVbyETYixv7hpXFeSCb2er5wEfVkQ/8iHtDtfEhtkuxaveHkNY0ylInlJnRP0slbKEn/hU2k/UswsOndGbIhf+x5xC3fUDNF3mKNCGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764613284; c=relaxed/simple;
	bh=7vOZlkn7KxLEHBeqTq+/468rlp4RUVKGCfWwdJqKCH0=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=TcdqywBZ0FpQjh4AmWpHiiLfGY7iwbGiHiG1WO8F7WdJzQXOXZOS0IxhnaeA6yQ4pkGhIt3dflqfbqKOSZCithFtTGsrK2hIvoA8Eu9mZTUVFH8EROmrEs/odsWZ4gTXn9muTlWxkxe/picCH4W5emCKsd09cdAMHTvqW2c+DaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JkB/4v1h; arc=none smtp.client-ip=209.85.218.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JkB/4v1h"
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-b7689ad588fso458868866b.3
        for <kvmarm@lists.linux.dev>; Mon, 01 Dec 2025 10:21:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764613281; x=1765218081; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:from:to:cc:subject:date:message-id:reply-to;
        bh=odX/ox3aZ6OfRTd6Iy2+oa0/EpTihBm90P4xNQBVkvs=;
        b=JkB/4v1hTVElVaXWtFFx9BvpyIlN3YyHr3O4wPxoJRjQsrQOttoEBsT3LjH27bOBE/
         qNXrWcr1FQUceBAFJUaIjW5vQ3i8+QCehZp/Xm1qDX+3ouKF3CXRf3JgT4qd9wd+nS1e
         3LhkfCy40N3H7fKPLxzDQbmWl7HLTWdihC1BJaaVUdfybsBdYVnW7ywHYvFwGqiub6MK
         4HaNqU3LNvl+NOmDCB0ybmUwv4sMqwg6nEkQE7zQqBZc49UXz5vLD9E9UPje3PyLhntk
         beOu1Ahm7jAG9cnl3XhWr0S94kuYVqSeelbndIZf6pHqo94YleVVsqmgcECVuoSR/x36
         FZ9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764613281; x=1765218081;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=odX/ox3aZ6OfRTd6Iy2+oa0/EpTihBm90P4xNQBVkvs=;
        b=ITKF6dO0c2u4mnnEFYa+ly9AKtX0dO7udjWMLpidATP6JpcPSnYOw1i/JwyXU7hUlB
         0ebxjTlZAkSP2bx0eis6zwj/c3kzpZZ1TZwvus4wp+qlsDxQUDXZZPDs2Q8Q1A0mC9wI
         XRMlhk3ac6ufDVk1hl19NQfrWkd6hbKmrRnnxB0jLC/y4g1TQIRTPO2XJbey9la42Q/s
         +HdX1hnSd51pBsGa/W521L6Wey++dz/EFIDALd7hfLOSoPD6OW61CM4h0Q8DrRw8Ss1J
         MXweKtKjA/mEgg1j68rkxiKNQDjHnqsvCAFUgDqq3wu230HcwQEPLmQ1oJRhIhEncEx7
         H5Ig==
X-Forwarded-Encrypted: i=1; AJvYcCX7ZRnSfc92rh33hxjxV4x+WRfgdyW1STU4B5zp75NPeH3DQgDQxWJn12mvBJfveFb74axDFm8=@lists.linux.dev
X-Gm-Message-State: AOJu0YyWxwEAP2Oho3J+dHu9yt2DW7icUd0gibRSO/yNkJ0WeXSZ1O5z
	h0AcapUXUq4kIoPj+Lt/IAg6Wb4uAkZP7x/fqFcvtkXTfw+w253Say2+Pg5nu1LFIc6qhH4Roi5
	wGw==
X-Google-Smtp-Source: AGHT+IHh8EB3gV32tWgbXZNPjCoJvYZ5NAK7xEFvEDfY8RzeyPbORY5fp6hyi+V7tHYcCNBQoIRQPJhBGw==
X-Received: from ejclg11.prod.google.com ([2002:a17:907:180b:b0:b73:69d2:27b7])
 (user=ptosi job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:9610:b0:b73:870f:fa2b
 with SMTP id a640c23a62f3a-b7671596300mr4237213466b.27.1764613281291; Mon, 01
 Dec 2025 10:21:21 -0800 (PST)
Date: Mon, 01 Dec 2025 18:21:09 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIAJTcLWkC/x3MMQqAMAxA0atIZgNtQEGvIg4lpjaDVVJQQby7x
 fEN/z9QxFQKjM0DJqcW3XOFbxvgFPIqqEs1kKPOk/MYbMOyMTPuVxar5oS8RBoiUXB9hJoeJlH vfzvN7/sBPmjymGYAAAA=
X-Change-Id: 20251201-arm-smccc-owner-arch-cdf29f22a06f
X-Mailer: b4 0.14.2
Message-ID: <20251201-arm-smccc-owner-arch-v1-1-71f7d75f97a4@google.com>
Subject: [PATCH] KVM: arm64: Use ARM_SMCCC_OWNER_ARCH in place of 0
From: "=?utf-8?q?Pierre-Cl=C3=A9ment_Tosi?=" <ptosi@google.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	"=?utf-8?q?Pierre-Cl=C3=A9ment_Tosi?=" <ptosi@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Trivial change to use the appropriate self-documenting macro.

Signed-off-by: Pierre-Cl=C3=A9ment Tosi <ptosi@google.com>
---
 arch/arm64/kvm/hypercalls.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index 58c5fe7d757274d9079606fcc378485980c6c0f8..3e7fdbcc6411f658f5cec818bfa=
d2e97711d37a7 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -126,14 +126,17 @@ static bool kvm_smccc_test_fw_bmap(struct kvm_vcpu *v=
cpu, u32 func_id)
 #define SMC32_ARCH_RANGE_BEGIN	ARM_SMCCC_VERSION_FUNC_ID
 #define SMC32_ARCH_RANGE_END	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,		\
 						   ARM_SMCCC_SMC_32,		\
-						   0, ARM_SMCCC_FUNC_MASK)
+						   ARM_SMCCC_OWNER_ARCH,	\
+						   ARM_SMCCC_FUNC_MASK)
=20
 #define SMC64_ARCH_RANGE_BEGIN	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,		\
 						   ARM_SMCCC_SMC_64,		\
-						   0, 0)
+						   ARM_SMCCC_OWNER_ARCH,	\
+						   0)
 #define SMC64_ARCH_RANGE_END	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,		\
 						   ARM_SMCCC_SMC_64,		\
-						   0, ARM_SMCCC_FUNC_MASK)
+						   ARM_SMCCC_OWNER_ARCH,	\
+						   ARM_SMCCC_FUNC_MASK)
=20
 static int kvm_smccc_filter_insert_reserved(struct kvm *kvm)
 {

---
base-commit: 7d0a66e4bb9081d75c82ec4957c50034cb0ea449
change-id: 20251201-arm-smccc-owner-arch-cdf29f22a06f

Best regards,
--=20
Pierre-Cl=C3=A9ment Tosi <ptosi@google.com>

