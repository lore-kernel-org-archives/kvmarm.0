Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.200
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794948340;
	b=f66xLjbe1Hm/Jyc+yfKgxuCvwq+K5W1ucIlvUQQTGKSsQNsw86zedMwg8Sl0eFB6NRCt
	 i9yWYmza4j6wx3ZpGqJkpMVb9oRIP4drC41u6Q+gvICkDgZR18rAX+npJKiNdADFAYRk4
	 UWUnnDkxZtLoiata9ulCTY2sUEU+M2oB1wT/MaD7yPo36LYxJjfJwXyZuMnpez5FhSOBE
	 2bf1kge2mx8wlrKeiVKVMr3qAj4qkW4dCoatrZqxZ5JF2355bruZiMl0Vo9QgAAMcVQSz
	 HjxishJte2bSrePaZG/j1o30davcvQ1aJUz5O5v7pRxvDFRDUzm7EoK7ITS9EDbnVLQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794948340;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=H5HOKL2EhRK71scz5F39xMdCNEmAUE6COZwQwhC/mXs=;
	b=IE7qN/Loa4/y1PoW1ZpxUlSdyPvUctt0QneWdgpnFw1sulJx1BJiw9MCeL0XAQXvxsW/
	 s3buLyB3b3tYYlOYFy6DCt0xzQQVygcfClCA3hROzPP2nJ7lc3psidunkQOenb+EtY9pQ
	 KsP2CrEUHKx1Bf+tYgqlM8SC82hQnTndufdswDjTnRbDeKPA/MQSijajB3+7J+1fKN4nF
	 Rvp/rxkHKOSQho9iURWz9iYatnVo3jtPbM5vfCpR9ESFkidz9/GYCvi61n5cVCDPub+HX
	 rXi6nqywpzBC1MfidYWlOceJ3v6Zc5hI6ez7zf0xzorl+l2hp4Gm4uZJkKOA34clbKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=FtmZXIRJ;
	arc=none smtp.remote-ip=209.85.167.200
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C700D606A88A
	for <kvmarm@lists.linux.dev>; Tue, 17 Nov 2026 20:45:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C700D606A88A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=FtmZXIRJ
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-4cc89e86e4dso175589b6e.2
        for <kvmarm@lists.linux.dev>; Tue, 17 Nov 2026 12:45:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794948339; x=1795553139; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=H5HOKL2EhRK71scz5F39xMdCNEmAUE6COZwQwhC/mXs=;
        b=FtmZXIRJd3/c5T6NgmUIw7J8jKRJYWV+poHA6MIH8cyVxib3/gpINOm8qTwZxFKU1M
         jTbyK34wFinTzSZv0vqssaqW9xJFUAg4GSNkTq5YOaDM0uS5VpmFh84s26i2qcZSwxL8
         ZfmYsmHkBohEWTk+0RvkOsUU0DdXE4Ev/jWbDqkRxBjSMl89J7nXmbipH4WzxZCBuoiF
         woQ8Rvp3levE+K3uLKVAN04L1tiFZcMQNpSUlPJzE9ffZIc304ZNdNCnMS+lFG6kP7pL
         JUbtTPl0JJFMqz0gZfp+cf2p3Ne+a+IrXCYXo96swNBFi0I6PyPv734NyUOuqnVlIwiG
         IQ0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794948339; x=1795553139;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=H5HOKL2EhRK71scz5F39xMdCNEmAUE6COZwQwhC/mXs=;
        b=gzOkhboqrpyxueKBSVPrSO0KgVD9+ZhF8Nym0ZmdfZdsrRyOOMCbPEkTonxVcGxcnZ
         z3xCL8Cr0f/fU9lAwmguoxjFOMX+xJghN62kJsVPTzfDXNd174nmWktbQQMKH0HkAVQV
         61SMCtM8xUxBbDqhL7oYWZP3E6L8/2JdoDWEIYPsaLCi+Hkk2yHYoZAkMROzgUGItVnB
         3iSM1mSSkL6nHH4OuNgwF9+GB+7ygLK+p/rOIsJ0pkB27xtJby5BflU1x0SL9xml6LVn
         DplurDh+EQbeLpGj1iVt9DfHGdkkQiM953El0o1lsYqIkiSgUPzo5iWg82CsYSxiucOt
         1mFA==
X-Forwarded-Encrypted: i=1; AL+hErFDn2TbbUKPuElL4FGyVp3jtVHiUBYChNpmlof+87jdbdJ70f6NZ7JWuV5OTP4N8nPPYT0wG2c=@lists.linux.dev
X-Gm-Message-State: APuU4Z9YK+oJdaoRO37tjOmwDF5ss9Y2nv6sFtrSBJ6Hl09Ofs/250MM
	yuU3WwDa6v3szs4kx5022nr44LOj9Zzv90ay/fDB3WbuznhAYd8MhhqP4WzWNDG2ashRGPLAXBM
	s/okM2lnt7T8j4XGV2xvScFp9OQ==
X-Received: from iobmp24-n1.prod.google.com ([2002:a05:6602:a2d8:10b0:9c7:7f8f:934f])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:3096:b0:4e5:a74e:d6c0 with SMTP id 5614622812f47-57743d4c1e9mr1010823b6e.64.1794948338500;
 Tue, 17 Nov 2026 12:45:38 -0800 (PST)
Date: Tue, 17 Nov 2026 20:45:35 +0000
In-Reply-To: <20261117204535.4036191-1-coltonlewis@google.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20261117204535.4036191-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.56.1.750.gf70dc682cf-goog
Message-ID: <20261117204535.4036191-3-coltonlewis@google.com>
Subject: [PATCH v2 2/2] KVM: arm64: selftests: Verify HCR_EL2.NV1 is RES0 when
 E2H0 is NI_NV1
From: Colton Lewis <coltonlewis@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>
Cc: Leonardo Bras <leo.bras@arm.com>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Fuad Tabba <fuad.tabba@linux.dev>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

In a VHE-only EL2 guest (KVM_ARM_VCPU_HAS_EL2 without
KVM_ARM_VCPU_HAS_EL2_E2H0), KVM advertises ID_AA64MMFR4_EL1.E2H0 as
NI_NV1, making HCR_EL2.E2H RES1 and HCR_EL2.NV1 RES0.

Extend hello_el2 to attempt clearing HCR_EL2.E2H and setting HCR_EL2.NV1
from userspace via KVM_SET_ONE_REG, verifying that HCR_EL2.E2H remains
RES1 and HCR_EL2.NV1 is masked to RES0.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 tools/testing/selftests/kvm/arm64/hello_el2.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/tools/testing/selftests/kvm/arm64/hello_el2.c b/tools/testing/selftests/kvm/arm64/hello_el2.c
index bbe6862c6ab16..5910497f8fbe4 100644
--- a/tools/testing/selftests/kvm/arm64/hello_el2.c
+++ b/tools/testing/selftests/kvm/arm64/hello_el2.c
@@ -45,6 +45,7 @@ int main(void)
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
 	struct ucall uc;
+	u64 hcr;
 
 	TEST_REQUIRE(kvm_check_cap(KVM_CAP_ARM_EL2));
 
@@ -66,6 +67,13 @@ int main(void)
 		TEST_FAIL("Unhandled ucall: %ld\n", uc.cmd);
 	}
 
+	hcr = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_HCR_EL2));
+	vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_HCR_EL2),
+		     (hcr & ~HCR_EL2_E2H) | HCR_EL2_NV1);
+	hcr = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_HCR_EL2));
+	TEST_ASSERT(hcr & HCR_EL2_E2H, "HCR_EL2.E2H should be RES1");
+	TEST_ASSERT(!(hcr & HCR_EL2_NV1), "HCR_EL2.NV1 should be RES0");
+
 	kvm_vm_free(vm);
 	return 0;
 }
-- 
2.56.1.750.gf70dc682cf-goog

