Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CA78201106
	for <kvmarm@lists.linux.dev>; Wed,  9 Oct 2024 15:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728489006; cv=none; b=HOvGMxLV/2Y1Fc+ZWEEqmKhmBLIU9nXWPBjSLDWVvgGeloYwRD+NsURZj9w0GD2M2o4wgJvKuzsnz7cmsGTYv8N26Psl9lyK8PiBNIo+yYBPgn643k4Pc4a1TWLG8sRnpH5ADvsQnnWribvEJX7E2CZfCR6vgIHlO7reU6QO1cw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728489006; c=relaxed/simple;
	bh=yMjqrBBrs5fD7ztP9Hd+ZjDB2ceAdIl8KOqv0sYfMVY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PxTz26s2GjTTDnsguPZKF7ySGAbqAxE42Q0Y8O/DNsSK2uTfEXYPO2qUXDebtlI0ZtYG3fY2Eogx4oNobc/q59P+bzTfJs4rYK76uJknw4+PnZJFtd/Omi54ZrFiJT8H4XCJ3Yl0qQmtQ64PVEzKXn18GMy3DL0CaaaZULmnr9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AGkUy/Zn; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AGkUy/Zn"
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-71e026caf8bso4522390b3a.2
        for <kvmarm@lists.linux.dev>; Wed, 09 Oct 2024 08:50:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728489004; x=1729093804; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=x0cgmo92qPc8MR1y7gAJGg1sCyN/CNSLMfDMg1eW/5U=;
        b=AGkUy/Zn096F0k53ErQMXZVtMHnaiTj5kuuSE40ptQmKKNjaBjQhn6+9vrnwyKgQRl
         EBI9eZvVG03WHPo1OMupj0MM2UKTphVSXUWkMrxhCOWvbkFuqJ6q9FP29ghwgKb93BAY
         T1SBWVl7SHRK5FGMDxA5jqIbneNuOGg2aONStf++xxYzqfGNocC2eFgfaOMWC3LblFVg
         sIq7Sm5Rim5k25uGzQM+wNDvX/juPWwz4T7H/HSwoCLSwuMM9KzCY+J11H9a3YR6UMYC
         Z17Uhar3DutXahnhOzaGkKqmZw3UWE5aLCPc3BGfUg+F0m5rxXf3KjPnWXnojwBufGUk
         ev6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728489004; x=1729093804;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=x0cgmo92qPc8MR1y7gAJGg1sCyN/CNSLMfDMg1eW/5U=;
        b=vRy8Xi+5R5NB9JoR9O63Yd+S6QHYPoRGftf6oh6BMF3Hs/UF3Z4Bcv6iNvW/Z2Mn5P
         i1XQcyz5Ixb3Zal7D9zUuxTEE96GziVMrF2rkvPHzUVtCJ7HJTlrSsOdFeQD0bNDJMkI
         tr7wDGs3Xj/XWRcPEB/pjUu7rG9hUzCSHI/Yu0FSq3/gOtEeAfKBDBJzqcZh3MDi0//J
         o971ZHQTyX5UMgVpiv0KrY9CKuT7vpIO+hIzd/nGEaD1/w+HW1eDnRRGi6f3BCMd9f37
         UoKUyShueuYu2CuDBfpJTmJpTlpdvFMnf+MHbves9+XdMM6iE30wruSbruhzbZFS73+u
         /F7Q==
X-Forwarded-Encrypted: i=1; AJvYcCXzvcWNS32r/gnoHTt8vzQT/PTw0NTU7EGAyDu32Xq5DVFkdTWa4I4gKvU2g1escie8zUQ5itQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YxBXVYD+Walozoih8+KpZjrh5ENrkQ3stgww0KFzQ9wJqYfGoPi
	A7MR687wHxUhZDiOtEviwpkmkiyUr2i/qA/U3Gxk0LoS11VuXqnmtIUWdE+JT1fhH1fvova87Me
	umw==
X-Google-Smtp-Source: AGHT+IERUBPfneULnJ59z0o0A04D0VCwsGKXUdX4SfWVGxtKdYKWNTs8AEtFgRMkbcfSQG42khoM/WAQWlQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:4fcf:b0:71d:fb06:e79b with SMTP id
 d2e1a72fcca58-71e1daa9410mr6141b3a.0.1728489003716; Wed, 09 Oct 2024 08:50:03
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  9 Oct 2024 08:49:43 -0700
In-Reply-To: <20241009154953.1073471-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241009154953.1073471-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc0.187.ge670bccf7e-goog
Message-ID: <20241009154953.1073471-5-seanjc@google.com>
Subject: [PATCH v3 04/14] KVM: selftests: Assert that vcpu_{g,s}et_reg() won't truncate
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Paolo Bonzini <pbonzini@redhat.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, Andrew Jones <ajones@ventanamicro.com>, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

Assert that the register being read/written by vcpu_{g,s}et_reg() is no
larger than a uint64_t, i.e. that a selftest isn't unintentionally
truncating the value being read/written.

Ideally, the assert would be done at compile-time, but that would limit
the checks to hardcoded accesses and/or require fancier compile-time
assertion infrastructure to filter out dynamic usage.

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/include/kvm_util.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 287a3ec06df4..4c4e5a847f67 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -707,6 +707,8 @@ static inline uint64_t vcpu_get_reg(struct kvm_vcpu *vcpu, uint64_t id)
 	uint64_t val;
 	struct kvm_one_reg reg = { .id = id, .addr = (uint64_t)&val };
 
+	TEST_ASSERT(KVM_REG_SIZE(id) <= sizeof(val), "Reg %lx too big", id);
+
 	vcpu_ioctl(vcpu, KVM_GET_ONE_REG, &reg);
 	return val;
 }
@@ -714,6 +716,8 @@ static inline void vcpu_set_reg(struct kvm_vcpu *vcpu, uint64_t id, uint64_t val
 {
 	struct kvm_one_reg reg = { .id = id, .addr = (uint64_t)&val };
 
+	TEST_ASSERT(KVM_REG_SIZE(id) <= sizeof(val), "Reg %lx too big", id);
+
 	vcpu_ioctl(vcpu, KVM_SET_ONE_REG, &reg);
 }
 
-- 
2.47.0.rc0.187.ge670bccf7e-goog

