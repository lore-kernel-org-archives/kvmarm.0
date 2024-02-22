Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EA9E15350F
	for <kvmarm@lists.linux.dev>; Thu, 22 Feb 2024 16:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708618303; cv=none; b=DIWPPV4M86sOPdlqvG0SUWHi/mnkOCRswIB2yh4mZdWmBk2wUduoQNI1/f4MIETqrnFbO/zrVVWArh9umto7B+APVDG7h5DvyKnqvx/Nk4h2r5JV1HT1gPPptBfN5Th0iHWhrSV6LErBkgTpJ9Z/dYmClEPG0ODHl5pwsna/UVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708618303; c=relaxed/simple;
	bh=npvYxmnOW8D70NS3ig9HnMx9N7r0Z+HXJuDOX7EAoRc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HS68a1nr0BRXsOooiDxVjFhMzF86SklZvUssDuzC1zTEYJnK6qVWIpRNJQcEKJIMO6wNpKTwB6ia40YXWyw0g4GomnYNCrr46zmgkAHOvVngOpA3UvfzNkaKUaX+2Ogc0jX4+Tnbz2axISFkpaLqBbaHy74wSDR8fI50h7OSMrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vbVCv+vg; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vbVCv+vg"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-40e4478a3afso5312755e9.1
        for <kvmarm@lists.linux.dev>; Thu, 22 Feb 2024 08:11:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708618301; x=1709223101; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rSm6/qgBZCczn9Ke4uZTyz+5iwS2nAcQPMledMHWGz8=;
        b=vbVCv+vgKmk+x3ZLwib/uIR04zpIlildYPYfq7UDUoyNViBPaL7ggoEvX0KdgYG8ZH
         WC5NI/UhsIKW9vL/0H6hPEyrJYedmIYdHAI94hu5sDGqZ3Pciipqb/fx7wtcowklILjM
         lkoaJ2HnYjxWZQSYAD9Uu5CuRiFOGJOABhKTgE3pZVBEOltEjYesxkOe7InHBW2n5iGy
         jRS0ASZEYdnVG5NSbv8ZhlZaqGooFfc2vDUSoixS6qMn9bZLYDbFtoOPnDV8M1jMk9UZ
         A3E4AJkEvTjXNiqMTlqdMNxmvhaBY8DF0jspXImz/4LGhP4dXbkZNS3qJwy81+B2Wn2Q
         EbrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708618301; x=1709223101;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rSm6/qgBZCczn9Ke4uZTyz+5iwS2nAcQPMledMHWGz8=;
        b=soGTVlRmsxND3AQVmv2rL68Zxc8qiDGVzfibNdhY2Q+/tb5a7m57SttIcEEB/5SbvZ
         VkdF4fz1ce8B9uSIuqBqU2n8Bylho0j6YL6SVqeU1fnDbsdzZisAoZSEeS5fkbcZBQGo
         S55QUvpsLHBab2qMPcD8BJDQEj+BXmFeKXNv0JKl1XlFsD9JVAJND0QoL/Vpb6BYadjw
         HSfrA7BZ9Irpbd4UROg5RrmJFHlMRN+rh0cWsnIeQyeFUK5n/t4RrLKv9HCUr2GUtDT7
         73+/0on68a+BINmWw1PaFZbRgePAElEd+4H/myd/FRnQDqFFsXNW0g8SGLzY+QRkUFNE
         2eRA==
X-Forwarded-Encrypted: i=1; AJvYcCU0BuZ7w5p/bTxn9VNqQ4KKXqW30bJY+wwSlvUau0Feu7PlqU8aQSFhyz/3kfdFFwkkHEbLk2hMbSeYbP1f598BjurdnuEu
X-Gm-Message-State: AOJu0Ywu5gQqbOx8P8I++Xry8gG5vqCpU/axaJLW11C8tLK9UlmAbYat
	NXh2YUL7OB1rzyNgY4W54Y5kMMy7TMWeFjKikJhM7Z89+swzFafzFscvpMnCTU5XAXxML5nmlw=
	=
X-Google-Smtp-Source: AGHT+IG/y8W3lb3JZO83cjx58GKuU0Lq2tsDnMqCffsClUcUdbIHBL/G3lXuTAChtYt/zyPvFkyCvnNNLw==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:600c:1e8c:b0:412:8816:3723 with SMTP id
 be12-20020a05600c1e8c00b0041288163723mr76370wmb.3.1708618300751; Thu, 22 Feb
 2024 08:11:40 -0800 (PST)
Date: Thu, 22 Feb 2024 16:10:42 +0000
In-Reply-To: <20240222161047.402609-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240222161047.402609-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.rc1.240.g4c46232300-goog
Message-ID: <20240222161047.402609-22-tabba@google.com>
Subject: [RFC PATCH v1 21/26] KVM: arm64: Mark a protected VM's memory as
 unmappable at initialization
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

A protected VM's memory is private by default and not mappable by
the host until explicitly shared by the guest. Therefore, start
off with all the memory of a protected guest as NOT_MAPPABLE.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/pkvm.c | 32 ++++++++++++++++++++++++++++++--
 1 file changed, 30 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index bfd4858a7bd1..75247a3ced3d 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -220,13 +220,41 @@ bool pkvm_is_hyp_created(struct kvm *host_kvm)
 	return READ_ONCE(host_kvm->arch.pkvm.handle);
 }
 
+static int pkvm_mark_protected_mem_not_mappable(struct kvm *kvm)
+{
+	struct kvm_memory_slot *memslot;
+	struct kvm_memslots *slots;
+	int bkt, r;
+
+	if (!IS_ENABLED(CONFIG_KVM_GENERIC_PRIVATE_MEM_MAPPABLE))
+		return 0;
+
+	slots = kvm_memslots(kvm);
+	kvm_for_each_memslot(memslot, bkt, slots) {
+		if (!kvm_slot_can_be_private(memslot))
+			continue;
+
+		r = kvm_vm_set_mem_attributes_kernel(kvm,
+			memslot->base_gfn, memslot->base_gfn + memslot->npages,
+			KVM_MEMORY_ATTRIBUTE_NOT_MAPPABLE);
+		if (r)
+			return r;
+	}
+
+	return 0;
+}
+
 int pkvm_create_hyp_vm(struct kvm *host_kvm)
 {
 	int ret = 0;
 
 	mutex_lock(&host_kvm->lock);
-	if (!pkvm_is_hyp_created(host_kvm))
-		ret = __pkvm_create_hyp_vm(host_kvm);
+	if (!pkvm_is_hyp_created(host_kvm)) {
+		if (kvm_vm_is_protected(host_kvm))
+			ret = pkvm_mark_protected_mem_not_mappable(host_kvm);
+		if (!ret)
+			ret = __pkvm_create_hyp_vm(host_kvm);
+	}
 	mutex_unlock(&host_kvm->lock);
 
 	return ret;
-- 
2.44.0.rc1.240.g4c46232300-goog

