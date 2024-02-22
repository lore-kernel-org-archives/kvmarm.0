Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 695DE157E61
	for <kvmarm@lists.linux.dev>; Thu, 22 Feb 2024 16:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708618311; cv=none; b=X3TtvbCu+Tn4wSN273t1lqge8+j+NUcuorqNb9h4V+isytQG7Z5eXpp0kDVUsc0jiHhsPdMdKjWjO+/nwoZlvBaukGsDlaa7B3NdccN4MKwJ4qoCRvKwJFGzG3m+fUm0mknUjw5IIiA3cSh1VNZ/yjdq0Y/WeEMU90fNVbbFm7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708618311; c=relaxed/simple;
	bh=YBrnDawp6bZyspGI2hQIDfJydD0jLTVmORqgm+VO2Dc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BHN9Lz5NiuatszXEfkJ0Zir1pxNyBViHr0gK9Damw56nI9dvDf72STD0/B90jp4H/C+Yge7JCoHzy4RJSxEFY7DaFCn8c0XalCqmfdd0q2OCH3RrOtUwn1kdv5z0SG6H3L9uobft9BgQDkexLoX8sr6vyizryFPgZRPnpWRkMWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XHIYgSUJ; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XHIYgSUJ"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4107469e8adso47493925e9.1
        for <kvmarm@lists.linux.dev>; Thu, 22 Feb 2024 08:11:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708618308; x=1709223108; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5VlGMXUi+EcDrZF93FlIfCnuiGyO6s7T7F5mtKL+TKk=;
        b=XHIYgSUJ2Pw2DskVaxQuwoDP8t2vC+zLc+3PqcjlBQskzRcRNNlCTz5sf77mde2nKi
         MwjvUFAvgdd158Y9oNdtYFvyo73WAIdZGwsEwzS6BNJb2Cc+99F5a7FZqW4qOKECNlvr
         pEm7VQpWW3TnLKKV8vIqC2FzYFf6jywjDS8q0bSvr5vsAy4WtyoQsEkg8/ql7bTXnHGC
         QRHkNesceioV1UhgZwXwg33GRzMk2JPQpdo5XtUikgyzZAs3NDfMMQgAfeqfCgtlmViY
         w/e9bwiBKERuNpNyd+Z9YBTgarwGf8pX1wYz8rf5iKk7qybhfl5WTzkrhO11T8/O33zz
         HttA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708618308; x=1709223108;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5VlGMXUi+EcDrZF93FlIfCnuiGyO6s7T7F5mtKL+TKk=;
        b=ed4NJ8BsKjAC7S0GHBYENC+77D/Y2g58cITHAEyL/+ONtpmidM/fOjQ/jUuvwpE4Fm
         41k83olLoVl2/n3qcANxvrCh9pGv1UXM/1RocmR0xKHKFcA1J+bSnu9q6EJ9/3l4hvC6
         qm1ijaj2WXTO+5LV5RsKPffxMDqN18QbWAzKAq5QUn1cUB1eb2ZDwiHcc8PkrvNeUomx
         czXD5eF/Hw1bTRJVEFKnUmyuMHLELnttVAmtK8JtY1YmRxfOHoXsf7ycJyJwi+uEeK5v
         0BU46I1W7IMmO/szENOw3QnpbbxbTni8YcrffcUX0nXfV8kyFAKexPSsemPZgNZcn+2V
         ZZBw==
X-Forwarded-Encrypted: i=1; AJvYcCW/9hyJ4q0VjWh60oP3dT+D82RWF4kzDQfPn0JxFPBYGHbiI8OYoNnEBGC/1Pkeevi37s723TrIkhnulq1WmPRZiZIkN4OZ
X-Gm-Message-State: AOJu0YxmzylAgAoPf/sADNonYUSG9bRNnSL8HavtyFNrarkzLQoq2OVM
	XQDQ8BDy+KEdCljiKUNht92nSWoXUdmuqRGzqQlPLXV9D9wpbV8BHpNsIBtYAjUDVtbCZkCJXA=
	=
X-Google-Smtp-Source: AGHT+IEZh2i3xVzr5RH5C6aQFHYNaDDdKkTq/43Sh9IabnzDwlWzdxlyZWTjikkcJwda9jyKXlIPkxXZ7w==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:600c:11:b0:412:5cf8:4d81 with SMTP id
 g17-20020a05600c001100b004125cf84d81mr157882wmc.1.1708618307680; Thu, 22 Feb
 2024 08:11:47 -0800 (PST)
Date: Thu, 22 Feb 2024 16:10:45 +0000
In-Reply-To: <20240222161047.402609-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240222161047.402609-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.rc1.240.g4c46232300-goog
Message-ID: <20240222161047.402609-25-tabba@google.com>
Subject: [RFC PATCH v1 24/26] KVM: arm64: Add handlers for kvm_arch_*_set_memory_attributes()
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

pKVM doesn't need to do anything specific, but the functions need
to be implemented since guestmem expects them.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/mmu.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 570b14da16b1..36de5748fb0a 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -2386,3 +2386,19 @@ void kvm_toggle_cache(struct kvm_vcpu *vcpu, bool was_enabled)
 
 	trace_kvm_toggle_cache(*vcpu_pc(vcpu), was_enabled, now_enabled);
 }
+
+#ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
+
+bool kvm_arch_pre_set_memory_attributes(struct kvm *kvm,
+					struct kvm_gfn_range *range)
+{
+	return false;
+}
+
+bool kvm_arch_post_set_memory_attributes(struct kvm *kvm,
+					 struct kvm_gfn_range *range)
+{
+	return false;
+}
+
+#endif /* CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES */
-- 
2.44.0.rc1.240.g4c46232300-goog

