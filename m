Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D7CD2FD872
	for <kvmarm@lists.linux.dev>; Thu, 17 Jul 2025 16:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752769662; cv=none; b=iLO//sV+H6Ug48SlS7QHZrRi4uvQAsw9v9E2yJQlgC5kHgF57Si+HN87wK1i/ZIbsNu7gqwuSojh/U+PCnpm36EzJ5LH3aiRQ2ohCp7nxmotyaeYFXgNi+Sw83cJmoWQ4DyEhFXymd4JeGRu1/gGhGv0zBP+mgKNrjz25xifxmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752769662; c=relaxed/simple;
	bh=DGSXIBpaZ+VliuyanNwueZCPMfss1HfDwsSY4rS1zkI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hRRTbJnjBWazncwPiwrGO/MuZzxwXhTH1hyh2MGNIJ8s5hDxhjOW3w9aLVEEE+oKM3c7jw+mU5YD2ANR69qLSQZbeUyMKsECGy+hBUS2Nw6Y9NS3bIk9PIdRuHhS8S0CB82G66M07vH66ocFd91d8jaiX+tz+1ftJx7xqBfoM90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vMya5CJn; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vMya5CJn"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-3a4f3796779so626063f8f.1
        for <kvmarm@lists.linux.dev>; Thu, 17 Jul 2025 09:27:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752769659; x=1753374459; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=81cYjGlMvTtj0w3SoYGXht/cTScIXHWu3YXSJD4H52Y=;
        b=vMya5CJn33HTrR7ADLDy/Lra0TEE3nv7rgIF8iNwlgPNIi5Lk/EU1Thi6QP0sGPGJM
         8rnxf0i3fV7HJuDsL2GGrDP/M1yISMYnqWdIV+urXqzIqR1qR3uzYMeCcMCH7r3QGmBr
         BS+zMAlmtfXqbf47VmNX2rduwAKE7h47Hqh6us35XOisTVkrg2or/aoZD9DESNsgQfFB
         G075HpV+XBVG1/eQ6FMX19Vli5Mm5iaTCJ68bBHLgmdbxeR9g+xaCVAdthSnND6QuYzL
         fdI/D/njtl6HpwepABkcV1nzbrEQvSHY8vgJSp3/gL/XgO59YS5B2sjnK8ZK4lXuTQ8Y
         OOeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752769659; x=1753374459;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=81cYjGlMvTtj0w3SoYGXht/cTScIXHWu3YXSJD4H52Y=;
        b=cTPJ4s5lz1VSQjybF6l+bnDxI7Uu/2a9inSkRO/+pgRXv9dYM3pVIvXAa4ZtKGR2vH
         P2T4FwdWjBkhtSYCgBIS5x12KZAozIgsxWHOB40NK18vZT5nt4A2OmbkUR5hGK2B6hHp
         IPhxiwjOkBHUwVbxdvgfaG6WHc2IJ+gaX1LKXGH8qlB0j4iuShc6tJUB2M89ChklYjLy
         Su/80Q4YXQHoRtPAQQbZDFhs4kD3NEK/oGX64YE0LNZrZ11jPvJwKFfznNwUOH/Y45pt
         ucokBLLHbLbFQ2ZGaFGOzrp6IlFGQwFKlj+/KF7j3DgmQPgavuehZUyn/HlacfvKpQK7
         veRA==
X-Forwarded-Encrypted: i=1; AJvYcCVffaDpgsd4WxgL4fyKkctb8w0k9q+Pg5avsoHUaKEe1o4AVhITSF0HnVC8LQs2yXSQbjjPsGY=@lists.linux.dev
X-Gm-Message-State: AOJu0YyXzBT4Kf1fgeLP/NPj8mzioMoKH9oFxxa4nXhUOjcHsn9VNgbP
	TkZS9MQxam4W0YBcdu7RPo0xxIbnWfJ0AzB1ZSqidPfLIPmmmhXq33D4atqbCyyBtRHmsXVNOY6
	Hcw==
X-Google-Smtp-Source: AGHT+IH5bmHMDd4zJafAHZwYYPcavwxGE7apj2R2grFKsJXx46AWhyZfurpkrtNa5YD+GGFrD9t1NSVLmQ==
X-Received: from wrvs4.prod.google.com ([2002:a5d:4ec4:0:b0:3b3:a665:e00e])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:adf:9d83:0:b0:3a4:f7af:db9c
 with SMTP id ffacd0b85a97d-3b60dd8d273mr5658619f8f.59.1752769659430; Thu, 17
 Jul 2025 09:27:39 -0700 (PDT)
Date: Thu, 17 Jul 2025 17:27:17 +0100
In-Reply-To: <20250717162731.446579-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250717162731.446579-1-tabba@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250717162731.446579-8-tabba@google.com>
Subject: [PATCH v15 07/21] KVM: Fix comment that refers to kvm uapi header path
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

The comment that points to the path where the user-visible memslot flags
are refers to an outdated path and has a typo.

Update the comment to refer to the correct path.

Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Shivank Garg <shivankg@amd.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 include/linux/kvm_host.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 9c654dfb6dce..1ec71648824c 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -52,7 +52,7 @@
 /*
  * The bit 16 ~ bit 31 of kvm_userspace_memory_region::flags are internally
  * used in kvm, other bits are visible for userspace which are defined in
- * include/linux/kvm_h.
+ * include/uapi/linux/kvm.h.
  */
 #define KVM_MEMSLOT_INVALID	(1UL << 16)
 
-- 
2.50.0.727.gbf7dc18ff4-goog

