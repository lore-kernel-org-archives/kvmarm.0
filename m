Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE5F96A009
	for <kvmarm@lists.linux.dev>; Mon,  4 Nov 2024 13:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730727152; cv=none; b=pNnwJVcIRjdbUv8LCkKcjblObV34QdSVTy0vjCyOL3G+NjxR/V30xBuAR3RWIBPcHmx/i1eSrhcLuJMwX4dNwiT4p4dvM2Yp1yzBqxheLlyujNbLYMlqYgDgxowwQB5TfwIcENlnHtPMfQ0Gjd3uEYjvBGOvcRGbxC6QzpKI3ys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730727152; c=relaxed/simple;
	bh=2zzcr8dahGRVDNl3wZ1YqXvn1JcqJa8MzblIuk2DUSc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Ov+7kaLqwoakzQqmMwokulG0rAsQnDgLjvCU7VvcjH68m1j50QiuIyRSVjZVTH8XZxZBoZuLAjs0xhV2lHJ0TSh8dZqx4i+qBYJxfln4X8GBSW0J52yTF2A4VWf+Ge+O7X0HbeNGa/JAcohUzXKGlyg1VdgVQnxPpo4Zeeqvk6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ALlbgIaH; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ALlbgIaH"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6e32b43e053so61927077b3.1
        for <kvmarm@lists.linux.dev>; Mon, 04 Nov 2024 05:32:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730727150; x=1731331950; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PBItirLg5Oir0h+eEpcfLT0BceEfQcKCnavoc0LgXGQ=;
        b=ALlbgIaHYl7oLhlM6pmELoctJBApYeAXyfrcR+ayItarxmKKYY0xwiqhIIfOStPnkJ
         r1Auw/Xtae/XpR5rfuAJr0izpQZTqKuXn9ONgUdLKTMmTvZUReXAZMFqKQNZicODHde8
         uzpjEf9KhkFrmEpbN41VFtHHxc9eCu0CltCjwlzznqUmAin2DIkFkAQ7LDc/s2g7aYNy
         ig8wBizKoCl2MNHMnchm13W4NYF7K1EUDuMHAzzjaBOfO1DyraLcw5XehB+D0m6BnRTI
         URtSpNufwJhFC4W+3hVYQAd9JWdAGl8/gZNJjhMUG6UtBtnRJKwyTYKUJC9tJp4jcqN7
         vjAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730727150; x=1731331950;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PBItirLg5Oir0h+eEpcfLT0BceEfQcKCnavoc0LgXGQ=;
        b=xF2umUlHAqSgcC284iNQ8CMXUVk8FSdnkGnyu1SKHCWO8CvCN0R7JA/0HEf6MNyTnv
         h3nVM6qkX7kPp/Tml3uWyj2lWgGeGUQsQEmad4d71q28WZET8THw+aaHA9GRbC43OCsY
         SVZDrtHB6xAMFEZAarexhgcv/JdhfQj20OjPzAMt8hGFL5IyaxMd8RF7liXXDz2IPv9p
         sbPw+KO2ttxnxq/Ui/uWBB0hUJ68QJvLymXeybQAHj0Znu15inTGDQTh5cNRRlsffUae
         GAzI4N8mI3Xz6x9GOG2UAG3JeXUVXCVjgklhYCEccfIpz/NKa951DU1LiRaK6HBTwwKw
         kIkA==
X-Forwarded-Encrypted: i=1; AJvYcCXwYxh2UPVJq5WvyxfDSPRQ7+aKSjbdz7idc0rWqcIVmF/EmTVBBjbsmquQrDELBCUf2fv87CQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YzAEyIbhm1bb984PajmGMwISRgIedVx8RMLlb1b8L+qlITfyGV3
	3yOtBro8mZzGgOaA+t66TAqdr7ij926Ce/HRcSlryal4H4P7ovDtuIFSr2NIUMsChpL4txaLv2b
	yl1QlTg==
X-Google-Smtp-Source: AGHT+IFvrgh3CVf1TWze2me+UFlYP3CJE1J8M2LCwjOfq5XmD1MuK3gwOqhUj0cOzAZs1ZrUlVldZRwY5pmA
X-Received: from big-boi.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:129])
 (user=qperret job=sendgmr) by 2002:a25:2bc9:0:b0:e27:3e6a:345 with SMTP id
 3f1490d57ef6-e33026dcafemr8506276.10.1730727149901; Mon, 04 Nov 2024 05:32:29
 -0800 (PST)
Date: Mon,  4 Nov 2024 13:31:55 +0000
In-Reply-To: <20241104133204.85208-1-qperret@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241104133204.85208-1-qperret@google.com>
X-Mailer: git-send-email 2.47.0.163.g1226f6d8fa-goog
Message-ID: <20241104133204.85208-10-qperret@google.com>
Subject: [PATCH 09/18] KVM: arm64: Introduce {get,put}_pkvm_hyp_vm() helpers
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
introduce get/put helpers to gettemporary references to hyp VMs from
any context.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h |  3 +++
 arch/arm64/kvm/hyp/nvhe/pkvm.c         | 20 ++++++++++++++++++++
 2 files changed, 23 insertions(+)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
index 6940eb171a52..be52c5b15e21 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
@@ -77,4 +77,7 @@ struct pkvm_hyp_vcpu *pkvm_load_hyp_vcpu(pkvm_handle_t handle,
 void pkvm_put_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu);
 struct pkvm_hyp_vcpu *pkvm_get_loaded_hyp_vcpu(void);
 
+struct pkvm_hyp_vm *get_pkvm_hyp_vm(pkvm_handle_t handle);
+void put_pkvm_hyp_vm(struct pkvm_hyp_vm *hyp_vm);
+
 #endif /* __ARM64_KVM_NVHE_PKVM_H__ */
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 9ed2b8a63371..d242da1ec56a 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -317,6 +317,26 @@ struct pkvm_hyp_vcpu *pkvm_get_loaded_hyp_vcpu(void)
 	return __this_cpu_read(loaded_hyp_vcpu);
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
 static void unpin_host_vcpu(struct kvm_vcpu *host_vcpu)
 {
 	if (host_vcpu)
-- 
2.47.0.163.g1226f6d8fa-goog

