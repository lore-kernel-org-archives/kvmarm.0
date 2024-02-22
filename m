Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC767155A4E
	for <kvmarm@lists.linux.dev>; Thu, 22 Feb 2024 16:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708618301; cv=none; b=Ar0pgkLNSEgWE/d3RjLAlmrmRy/GTG5I/+HP3dG5JvmtNTB5NMPvVwanptHZWb4QcqqaOHw+dyiGFW7U0FEuKG5b9Iw+XKugxPlzrlUWX2pwTA7+0KK9hKEvybplw7SM6th+Hl7AGM1WnoIlDdZ+VkvE3yu4P7DjAB/PqJWTxyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708618301; c=relaxed/simple;
	bh=MBXw36BeBpgzLpaJ6DDMj7mANbp5a67/tbxZ56a4zsI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Z/+VJE0hnedgbDPyYLuBm5f22d9d7yZYI/kYcsEgCJjgtq8XTLMYUO1jYDEo+UojjgW4F835B7SaqNrQzXKqbkmgAHzW4XwUS8WT2MaZaRe0cFTcAZWd7f7hRz4eal1hNdGAIh4kwLh3ejppKSEZKz5hsvf39HWbuvlrqQ172oE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OKEXCZ7A; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OKEXCZ7A"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4121c06be80so42893195e9.1
        for <kvmarm@lists.linux.dev>; Thu, 22 Feb 2024 08:11:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708618298; x=1709223098; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=G3PquBHsQ9j3O8VxfhBiNpCD7E3dPFUw+j7QK93cQQM=;
        b=OKEXCZ7Az8Wx+pxlyYZtrF85ED+P3A9ezhO9HrcBDgo6YTWHtH8BCf14C5IfzltSlL
         w4ByhiHIMzxVauN54xNUpxEMegARox1un73SVmnB3UaI0k4NcHmufi3atG4GNfDkwYzk
         MOucPExDPMa0t13UJwU8xbbW76Dv1zeNl1fzQ5t1aGma/1+j8TfoNpXccGqkE1ewiGyo
         hY647sNXJMuvN7Qd9tjIaJFVI4Zu5ew4JkSzRO1otFPF0Q9tAHEieXo5Kx3ilUmraTg+
         GrzwRnnbNnIWsgXbjKDBL548PypZ4C4AgEiwYISeBdpFXnJ1LIHkz196zPEvEH4ZxhXn
         6vCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708618298; x=1709223098;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=G3PquBHsQ9j3O8VxfhBiNpCD7E3dPFUw+j7QK93cQQM=;
        b=AD9+7ELhj71QlhVg1AzYLmtfLrOFAT6uNrSzc1WuObpx0LO32K6HkdFGuqHxfsTm9d
         X3YJRrEhIF2OVH0vuN7rN+PSBF3X2jfdTEShRH+e7ZnUJMtAb5PAo+Z0seBCThSq9vkt
         gNeUj5xvikvZqVggxWA3u5dNyhQiRfuybg0vpHkGqDrj73W9/tVRUvUZ4jCqhPncIFAh
         nRLkz374iIRBHQZoWcf0HugSawzfBIvg5QgIB7I2njIXUMH2vZ/9AuAsCvmEbRZc/xmG
         LBuU9EPQPl2AV7oeP3bp8kCiTdYLp3dSJ8wGbR4XzxD6VGURrUBZvvVIbiN46OgaicET
         lCdg==
X-Forwarded-Encrypted: i=1; AJvYcCWDAwQa/ZDJvXKjPE9wKGL1SSHqzSiNeHQxFpw/NqX0LbgR0h87Mzm6aAJKoscRutcksIfdY4MlowMqa/MqDZKeeGf9wEMP
X-Gm-Message-State: AOJu0YygZfko/wVvaa8M2M3NAegF4K7jV022TCdPsq3b7lnA0bGbPa97
	yVmAARDlChYe5Y2ZCCPs2AS/vRTSiMbMjXcunYm7lIb7uEnK56xcZo90elsJLQ3P9ejmwGiBXA=
	=
X-Google-Smtp-Source: AGHT+IFHt8ljAgUFsumQUx43edqLPoztEr5s7k3xHUmGMWApCiCTFox1L/DuSqvEX2oWzicoQqDqguGfpg==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a7b:c2aa:0:b0:411:ea5e:615a with SMTP id
 c10-20020a7bc2aa000000b00411ea5e615amr248951wmk.1.1708618298281; Thu, 22 Feb
 2024 08:11:38 -0800 (PST)
Date: Thu, 22 Feb 2024 16:10:41 +0000
In-Reply-To: <20240222161047.402609-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240222161047.402609-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.rc1.240.g4c46232300-goog
Message-ID: <20240222161047.402609-21-tabba@google.com>
Subject: [RFC PATCH v1 20/26] KVM: arm64: Track sharing of memory from
 protected guest to host
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com, 
	mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com, 
	wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Track memory being explicitly shared by the guest to the host,
and update the NOT_MAPPABLE attribute accordingly.  This would
allow shared memory to be mapped by the host, and enable us to
ensure that unshared memory is not mappable by the host.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hypercalls.c | 30 ++++++++++++++++++++++++++++--
 1 file changed, 28 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index b08e18128de4..56fb4fa70eec 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -163,6 +163,32 @@ static int kvm_vcpu_exit_hcall(struct kvm_vcpu *vcpu, u32 nr, u32 nr_args)
 	return 0;
 }
 
+static int kvm_vcpu_handle_xshare(struct kvm_vcpu *vcpu, u32 nr)
+{
+	if (IS_ENABLED(CONFIG_KVM_GENERIC_PRIVATE_MEM_MAPPABLE)) {
+		u64 mask = vcpu->kvm->arch.hypercall_exit_enabled;
+		gfn_t gfn = vcpu_get_reg(vcpu, 1) >> PAGE_SHIFT;
+		unsigned long attributes = 0;
+		int ret;
+
+		if (!(mask & BIT(nr)))
+			goto err;
+
+		if (nr == ARM_SMCCC_KVM_FUNC_MEM_UNSHARE)
+			attributes = KVM_MEMORY_ATTRIBUTE_NOT_MAPPABLE;
+
+		ret = kvm_vm_set_mem_attributes_kernel(vcpu->kvm, gfn, gfn + 1, attributes);
+		if (ret)
+			goto err;
+	}
+
+	return kvm_vcpu_exit_hcall(vcpu, nr, 3);
+
+err:
+	smccc_set_retval(vcpu, SMCCC_RET_INVALID_PARAMETER, 0, 0, 0);
+	return 1;
+}
+
 #define SMC32_ARCH_RANGE_BEGIN	ARM_SMCCC_VERSION_FUNC_ID
 #define SMC32_ARCH_RANGE_END	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,		\
 						   ARM_SMCCC_SMC_32,		\
@@ -411,9 +437,9 @@ int kvm_smccc_call_handler(struct kvm_vcpu *vcpu)
 		val[0] = SMCCC_RET_SUCCESS;
 		break;
 	case ARM_SMCCC_VENDOR_HYP_KVM_MEM_SHARE_FUNC_ID:
-		return kvm_vcpu_exit_hcall(vcpu, ARM_SMCCC_KVM_FUNC_MEM_SHARE, 3);
+		return kvm_vcpu_handle_xshare(vcpu, ARM_SMCCC_KVM_FUNC_MEM_SHARE);
 	case ARM_SMCCC_VENDOR_HYP_KVM_MEM_UNSHARE_FUNC_ID:
-		return kvm_vcpu_exit_hcall(vcpu, ARM_SMCCC_KVM_FUNC_MEM_UNSHARE, 3);
+		return kvm_vcpu_handle_xshare(vcpu, ARM_SMCCC_KVM_FUNC_MEM_UNSHARE);
 	case ARM_SMCCC_TRNG_VERSION:
 	case ARM_SMCCC_TRNG_FEATURES:
 	case ARM_SMCCC_TRNG_GET_UUID:
-- 
2.44.0.rc1.240.g4c46232300-goog

