Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8384B1FD782
	for <kvmarm@lists.linux.dev>; Wed, 18 Dec 2024 19:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734550883; cv=none; b=ljDRA/zd1ceRSdkdDQ8vvJDkCTTLtUnAlSsXBHb4ZANqmIanAMNz9SW7B/11kC3cir4A4xi8gW8nhR9GHe5Cfu5Ax1VuKmUU+FzueQdn1WYfKueKWOWyuk/AQfjrsc0k8w6zp01bcVh4NGkAYKHO7Y89pMvgtrruT6FjR8Qbzqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734550883; c=relaxed/simple;
	bh=pTKSZGfKbHMfdbY9ycSSpCBR5mIPbTPmtiVO7h+ymp4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HqudMHKy/i5ciNukUzlkRTG5SB30KKaS1OnxcFHIygCjRThbcpH8jAqktFI2kZubHJOPQjs8VvsugtZuiuoPM9WM6o6+sPnr3eQyTJ4xqyTa6sTfq/vRKAqeJAboI9bwRjF37SlJpRhpE+WAie8dUStvrpcMalXYx8u9FxwQCe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=N2dSBtsR; arc=none smtp.client-ip=209.85.218.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="N2dSBtsR"
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-aa6a1595fdaso795266b.0
        for <kvmarm@lists.linux.dev>; Wed, 18 Dec 2024 11:41:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734550880; x=1735155680; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=BiT706MC/v/5WfOS1GqIiRFWN/xkPeYitBY7QIGoTso=;
        b=N2dSBtsRKnj0wMpyauHp5ccE2k8t2ObqFPyNAfjQ3bmnWdk7aWGi1hL1wtcRmrGxPP
         eJ7VIM0uaFKcVZ6x1hj7siCN7DzcIOLwUqTPY/ILxptEuPUzex2hUnFpqaf7GEEn2RkM
         oDDcZd8OhDk17OxuuxipQp5X3HZUUKYdRF6KvhQVb1NLGadVMVSydNR9yUGWRqV/IF4d
         dGPtkz3eIiexuiVVPBLJsqF+XE9kqw5WHnda1r9z4QFoqI5xjj0RDBzxRatwF8vt0mBa
         Fv+iXc/X2C+tyf4yrG4HzoaVP1zuKSR9AHNsMBH1NcoXwrVvEC8E4PEQHxmWDwn7LxH5
         G2qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734550880; x=1735155680;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BiT706MC/v/5WfOS1GqIiRFWN/xkPeYitBY7QIGoTso=;
        b=h35Ip7/1H9DH31vPsgfG71WaF7UAdFXDwRXe22Tc0w8IakZZZhdQaIgk7cUcEcfbNs
         odVC5NSKNL5TEY1vmEjw4G+nm595PWLlSShzqSkf5Gk8z/3HY/IxZIUUUwE3JaQrvLTN
         c85KOjYrhLGFlh5Z7GoPC43WgQd9lvYv5/Oq7DkH7EMRrRIYu02cmGE74IH41/zbHdlW
         OgLnDj6uyyEUL3UNRCuiNKKdEddhbrvSqQWdbAfao6sY8nhanYcMbezZpP6BZIJJTF9Q
         RyPDmR96SiKtUO3+65+GqZMFTX+BQpPB97uC6vJSKQRTAs5WE7owcfxDzidxx1e67vKy
         kNfQ==
X-Forwarded-Encrypted: i=1; AJvYcCVP64cFTHd/qiHcJ2dq9jEMB0g2/WE3YMiUJUXc4ZlhN6moRLW7q3RcJTbeSrjYfpC9nfpl7Uk=@lists.linux.dev
X-Gm-Message-State: AOJu0YwnOV/m4EPV+tb/LJ6vLBfqSh2NsKm5P/1oZILbHV8Uy5ai6eHL
	HRFbx8m7IpeQd6/UdDavYjPUFMW07RYYchfulsU/Je+2L5/WZJgkaVeANyrKekOo9+1POPOejO0
	j1jyo7g==
X-Google-Smtp-Source: AGHT+IFWzxNIIarybqKCC1vLUo+KqgKX+4fV6W/RAvufSsLnQ/TfrAjnGZxwfp1b7qx032X10zEJNqov2L7r
X-Received: from ejctz5.prod.google.com ([2002:a17:907:c785:b0:aab:9ac0:2adc])
 (user=qperret job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:7ba2:b0:aab:76bd:5f8e
 with SMTP id a640c23a62f3a-aac07b905fdmr61154666b.53.1734550880082; Wed, 18
 Dec 2024 11:41:20 -0800 (PST)
Date: Wed, 18 Dec 2024 19:40:49 +0000
In-Reply-To: <20241218194059.3670226-1-qperret@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241218194059.3670226-1-qperret@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241218194059.3670226-9-qperret@google.com>
Subject: [PATCH v4 08/18] KVM: arm64: Add {get,put}_pkvm_hyp_vm() helpers
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

Tested-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
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

