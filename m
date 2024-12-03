Received: from mail-lj1-f201.google.com (mail-lj1-f201.google.com [209.85.208.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C6791E3764
	for <kvmarm@lists.linux.dev>; Tue,  3 Dec 2024 10:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733222278; cv=none; b=rxh/Vzl9zoKBuy2rPw04JymmTKRGW4q0suBn8cYcAeW2VcMzPFrtB4OMDvg5xZVyyuWxi+oPcWlHNuSZszPQEpy4WY4ENBOtzzDRdvJmHFb5jmhE2L9FfrTS0BZCYM3sKNYGREMRcFMniirg2RdSKuqo0jkPwa/9Uz3GXSc4NYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733222278; c=relaxed/simple;
	bh=IuYyF+ZnGppO8PAFBi7Chs+i2+5hGe6b9QeErqyYhmE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YKzTBwmhuAA3O+tWG921EEid91Thc+wrnRP0qf1whtIZ3Bzk4RJ2uVunCDpIGT/KvFd4h4I1uOU03GDz1FpWHjy43PIMs1qqpRfYl42AOPHe7jEwirn5r5leZbIyDcTnlqQZljNBdlGY/4yWkDGRztucyJH5r8Od+wmikwnDfco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KddYoUi2; arc=none smtp.client-ip=209.85.208.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KddYoUi2"
Received: by mail-lj1-f201.google.com with SMTP id 38308e7fff4ca-2ffd18cf7c8so31461221fa.2
        for <kvmarm@lists.linux.dev>; Tue, 03 Dec 2024 02:37:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733222274; x=1733827074; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=BRZ2cEpW+rSNUfUs/q11EvB+KMkExBUSGtmow/HBwh4=;
        b=KddYoUi2nI7EvRaAfN0wE5/gw+ov0NV8rPjQ/263J2S+Z+9YgHFeDVet12OYX4eFm7
         c7crqj5QvAyiMfVTRejCtpTUo4puxZyHtds5F4pS3ZJ9UxRu7qJQW0zFrY77bqqe7O2M
         +S7Dy5Ac9KCgKpuJLhNzrYXDgAxKPtdWS5NvPfggrHZVqEViigv53DAh6JF26BDWsV6n
         /xw1nzXUO7OsvxdbzXiJTCZT/Yb6aqd4EI376j2Eh2U6ylh3RnbJNufCFprpmNlR0q4m
         BFefAGNi00ppjMW0eKjBfRTY6ZVkuv43pNfc3tkkhofeu/IMygc40d3UZFTWmT/zLe2a
         vh0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733222274; x=1733827074;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BRZ2cEpW+rSNUfUs/q11EvB+KMkExBUSGtmow/HBwh4=;
        b=MFYSaM8Q1MQ0HGG5qfQVlwX0fG4SNm/qFYTR+k4DDeDg5O3iGkjf+0fKbAVuYhyQzk
         xW9I7b1wIoUMzP6YfflkRfw976h77ndZP44PphUDJW8E5RuB3YOrLY8jfGjE3838tN2t
         m8znrTYzvdWW9eWua7E52NA06wygx53TZGzBlW2UC6FXrOJnNjXKPgZDt2AJ5uX31P5y
         nmPiQq+UgynOPN00QsVxs+/+MGdNNeN1PhsCQpyzZdE9XREQmaPRbsQMfq7Vxwjq/On8
         0x9mqWth8iQHd7BbBGiBtKS7ySkDKvd23YWKx1oqBCpNrV5KxK7z+/YpMWFOCKWHEB4L
         FaQQ==
X-Forwarded-Encrypted: i=1; AJvYcCWLNFVrX6nA7QFM/vgaz+wVADXnZsBFdIADyrhamj/aVTfh08+rwOnDMosD4Tsy0z20kBl+FzM=@lists.linux.dev
X-Gm-Message-State: AOJu0YwXX9GWO0/M0svjksTTdQp3GeOjCaeX1fh0nFiYvjOrxGlM7U7P
	WQgP2uE/j/QCZVOvuDvtrsD7RgcMtoY9wFqs5RdAs7kdU/UV7FGie39VjaqJ1vlSK4XdKn3/RGQ
	Y0eiqiQ==
X-Google-Smtp-Source: AGHT+IEj8AuZHCZpDYFglBJG72MANHTDv565iypJfWiYGscbgWwh2Qi7NN2thjRyh4mSRHfuIeZ5D8lm4Rqv
X-Received: from edxz12.prod.google.com ([2002:aa7:cf8c:0:b0:5cf:ac1b:14fa])
 (user=qperret job=prod-delivery.src-stubby-dispatcher) by 2002:a2e:b890:0:b0:2ff:8e69:77ef
 with SMTP id 38308e7fff4ca-30009c0d863mr13033771fa.1.1733222274568; Tue, 03
 Dec 2024 02:37:54 -0800 (PST)
Date: Tue,  3 Dec 2024 10:37:25 +0000
In-Reply-To: <20241203103735.2267589-1-qperret@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241203103735.2267589-1-qperret@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241203103735.2267589-9-qperret@google.com>
Subject: [PATCH v2 08/18] KVM: arm64: Add {get,put}_pkvm_hyp_vm() helpers
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
index 01616c39a810..4db88bedf8d5 100644
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
2.47.0.338.g60cca15819-goog

