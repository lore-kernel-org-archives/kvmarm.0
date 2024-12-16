Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E924B20CCC5
	for <kvmarm@lists.linux.dev>; Mon, 16 Dec 2024 17:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734371905; cv=none; b=E/UbtyhCtWqDQyzk80nKUV6XJQ8yka9Q6++vby/ULsII4Qoi4XrGMUp+E4lF0loZahcvvgeJVCO++0ezIvLuj9c1vbAE0YXTadD7ae5y0V2OQjYaMdzUGf7pU8t9872gBvwThsDZY+9g/9Ck+7aqnMW85DOQCeIbSL1XHXEz+Dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734371905; c=relaxed/simple;
	bh=3XHMTTobse3q0dEwknl/B4DvUFVndatcPNdmNVk4PtU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ikerUxOAAuQNFn60beIVi9mUDKNxPyDESrStG2DMzLGMf9J3Ywv+/YwgsiSmrLaO7re4jwnpC3ZcyUxcqrFC5Scgv1kVDohllcqsEL54ayR1gxhf7kPVy0/Ov53bodGVFeWtlRKYHbW4oZNW1A0br1WOkhQeRs+zcb3g0dZ/58c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xZBbX+NE; arc=none smtp.client-ip=209.85.208.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xZBbX+NE"
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-5d3f01eeef8so3223751a12.0
        for <kvmarm@lists.linux.dev>; Mon, 16 Dec 2024 09:58:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734371902; x=1734976702; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FdcyBmRiYnupt5usNoa8YsTNzt1V3OCJZIqsaCSd/iY=;
        b=xZBbX+NE7oUYEmksWWVkPMKMm3hw/RNQjv77/JzesAQsKtpl62C7X6McNM0N40fQpZ
         TtcZ77IGRaZC/MCFlEpCMQ2/tEtiZIC/4U4Nju3+24o7WZE2nBoaK2mJQ4kHioQ1204r
         p89X7o+HRbBF4kKSGfkVB8Q5oycRMqSq3HaWZX/LH3jfvWiLNa54V848z1UjfKT2hWG9
         2TdLidLXA5vlFzGzxy0i2LpG+2cd/yKGDGAd26rw88jDgXtzZDUhaVRGgoLriNFPzAS/
         DUwnCsOfWkBJJw1W/MTw5zAvn4CgBDFyig1yZSNQynfH2jD8i9hcwjOWuQBbUgjaL5Mc
         AXbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734371902; x=1734976702;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FdcyBmRiYnupt5usNoa8YsTNzt1V3OCJZIqsaCSd/iY=;
        b=lKXDav0rQqcTAGSjfxU/mEo2DgRVfOkA+lSR7KIMWW15o9ftt8NQWao/3JwN9BtE0w
         vg7FwV0e3wYd8oDK0xBB69EzRWzA/3hkBgDQS9V4dCHnkfBkmgHYtfquU9gJCvZaAU8O
         3LhJkKbKlC7M7bu9HpwXoh3V3Oh1+Hl+lOK4Llau5kzoC9arHK9R+3ZXFTGAiGQXrzhN
         u2wf3qcfNDH+rwnYV49C1Y9VORRKVC1gDCHM6WaCL3uNGkJBQzfWYDJVSa9IjLeMSFDw
         QIa2Y08nDymmk6fP1s3DxVRkIk/u8qDr4ujugyufh7BeJL271GVSDGru4IrFJ7/KhHgD
         44qw==
X-Forwarded-Encrypted: i=1; AJvYcCU5hto6b2zXKqPYqBTWyDxoyr0DCZg7g3IoWGGZZGezLbaugZiDrc1mF+4Zs1pVxTB4O5fDoz8=@lists.linux.dev
X-Gm-Message-State: AOJu0YyFyZ7Jak8JCs7ExPluNSN7wnX+69RzQRetTFxyILPz4Bs1CW8+
	ICrTXIGZ0qTgVFqFzZvyuOyDdXLfA48GtatvHP45n+jbMw268EkAcdgJiX5z9oMfGeHEhm0bp8C
	EcmUaiQ==
X-Google-Smtp-Source: AGHT+IHpcpJq4kyenHoOx1fxav7mIvFDvXklCXubp7lwpwsMau839iNr+DB/Q2jwccyvsQCELDrIix68lHxb
X-Received: from edbfj7.prod.google.com ([2002:a05:6402:2b87:b0:5d3:e71d:9abe])
 (user=qperret job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:254e:b0:5d2:7270:6128
 with SMTP id 4fb4d7f45d1cf-5d63c3dbe25mr31398284a12.25.1734371902351; Mon, 16
 Dec 2024 09:58:22 -0800 (PST)
Date: Mon, 16 Dec 2024 17:57:53 +0000
In-Reply-To: <20241216175803.2716565-1-qperret@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241216175803.2716565-1-qperret@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241216175803.2716565-9-qperret@google.com>
Subject: [PATCH v3 08/18] KVM: arm64: Add {get,put}_pkvm_hyp_vm() helpers
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>
Cc: Fuad Tabba <tabba@google.com>, Vincent Donnefort <vdonnefort@google.com>, 
	Sebastian Ene <sebastianene@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

In preparation for accessing pkvm_hyp_vm structures at EL2 in a context
where we can't always expect a vCPU to be loaded (e.g. MMU notifiers),
introduce get/put helpers to get temporary references to hyp VMs from
any context.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h |  3 +++
 arch/arm64/kvm/hyp/nvhe/pkvm.c         | 20 ++++++++++++++++++++
 2 files changed, 23 insertions(+)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
index 24a9a8330d19..f361d8b91930 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
@@ -70,4 +70,7 @@ struct pkvm_hyp_vcpu *pkvm_load_hyp_vcpu(pkvm_handle_t handle,
 					 unsigned int vcpu_idx);
 void pkvm_put_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu);
 
+struct pkvm_hyp_vm *get_pkvm_hyp_vm(pkvm_handle_t handle);
+void put_pkvm_hyp_vm(struct pkvm_hyp_vm *hyp_vm);
+
 #endif /* __ARM64_KVM_NVHE_PKVM_H__ */
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 071993c16de8..d46a02e24e4a 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -327,6 +327,26 @@ void pkvm_put_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
 	hyp_spin_unlock(&vm_table_lock);
 }
 
+struct pkvm_hyp_vm *get_pkvm_hyp_vm(pkvm_handle_t handle)
+{
+	struct pkvm_hyp_vm *hyp_vm;
+
+	hyp_spin_lock(&vm_table_lock);
+	hyp_vm = get_vm_by_handle(handle);
+	if (hyp_vm)
+		hyp_page_ref_inc(hyp_virt_to_page(hyp_vm));
+	hyp_spin_unlock(&vm_table_lock);
+
+	return hyp_vm;
+}
+
+void put_pkvm_hyp_vm(struct pkvm_hyp_vm *hyp_vm)
+{
+	hyp_spin_lock(&vm_table_lock);
+	hyp_page_ref_dec(hyp_virt_to_page(hyp_vm));
+	hyp_spin_unlock(&vm_table_lock);
+}
+
 static void pkvm_init_features_from_host(struct pkvm_hyp_vm *hyp_vm, const struct kvm *host_kvm)
 {
 	struct kvm *kvm = &hyp_vm->kvm;
-- 
2.47.1.613.gc27f4b7a9f-goog

