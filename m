Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75CC32DE70B
	for <kvmarm@lists.linux.dev>; Tue, 15 Jul 2025 09:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752572077; cv=none; b=r3ZtEZFlb9zGm80u+UMBziHGFzvYSiPg7x9uFXCRJgpdJfWam5VAeZhcjiy5Q39nWKfZNum1LvChCxF8vw5hYq+tl5XCPwIqlk708HEZt+N4UW9Vrb4h25cPEO0Gj0uCRGmHLMUwgAD50Xi5XWOGCDwU0/QC/ODL5pUtb01Q9gs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752572077; c=relaxed/simple;
	bh=s81rdo6xJig6RnBs9z2MASUF9cmSxvjSWz88FGej91E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=iCBxEynl4e/AQgSwvXGjQJzXZqi587eTVAsTgkCJi9shL05Qygc9BdyxgTLgQguGiwJYD/3HK6DFEkCCbzx+y+yh1XpD/c58gBv106XcsveT8ZG2cm64KgxcKT7ky1nmNYV1QSHGtk+wJB+fOJTSMmCoI5tb7L/wz31TnhrnTk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NGmyMW5q; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NGmyMW5q"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-45626532e27so4606675e9.1
        for <kvmarm@lists.linux.dev>; Tue, 15 Jul 2025 02:34:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752572074; x=1753176874; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9qSAaCs5u3stWdE7jpelRBQbwP+260qm4giQezY97SA=;
        b=NGmyMW5q5qj3OVQzueprJJccLdcufAIt0m1UGhg4sLCGtS450Ds60UsfpW1y4IAVxz
         22ZdM3PNHCyQFNwQ95JSeLnnKd/zx1O8WkD7FgTgTCtpEecIPArX4/LKtmLKQmvDV9h0
         ZC9YMgWzhayoyhXF3WfqW83ELj6Hxy4WH5GPbzbEHzHpi4ZVfJmCsIgXAZD8i+oZvZ/m
         nHok0KuxIeSLzOiKeCK6dKQyvc799JCPScOMkkdqD7/FNNfhXTMVWerk3UjRyRS//6+x
         Cfc30Qq8NZW0M7cNIxek2GYRFl8AEjSfrOP0kwautbHtJzjsrs1Ju8KuertB54+YhfUw
         pDnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752572074; x=1753176874;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9qSAaCs5u3stWdE7jpelRBQbwP+260qm4giQezY97SA=;
        b=ol4TpmMDeImK9AM3BXLtEwax214J6FGVBDi33f3WiX2g32GgobBbbpou/NNOgMHzn/
         dD9OzPKN1XSGhBuW143wluuI3e4c45cvUXJ9VMQLtZW77bHvAQuSlbHUrrUhnyQNGuC0
         ws1lGuHQhtk4TnlezjN0uW55NJcyqrzojD3AHl93xVbiW7ISg/1GMFs97zrNGGFPZXqy
         qUTpx1NlHUJeANpCfZ/w9SV0bem2nv/LC3FZVp9g1Ldwny08P7nw2SkIJNGp05RsUg/I
         tRZVC2G20eEFebUiKjN6IXy3IMQc9EdwTLanDXt4cjp8tsw6i5iuEWI2jxN6mUvpzvTM
         xDmw==
X-Forwarded-Encrypted: i=1; AJvYcCVOh3Yk4Yhnz4aGb7CvU7NAyeoEuisvAMrkYjTw2CLDWTMhIKj6Pp56DtpQ0PByw94fAd30bDs=@lists.linux.dev
X-Gm-Message-State: AOJu0YwRH/4JwLmBkGb7DD005+TcHfugH80gHPRY/0kHjZGaWAIA/t7C
	+41S3EC/2/aKZef2+Gi2abdu7toPMOuojevPORKllGkNmBAdRW9pZrHzY/rlTiht+K4L02+Ysdy
	m6A==
X-Google-Smtp-Source: AGHT+IGOJuaP0WOYc4NF1TL35cx/kQk7xjXiKYWsLOJ3hP5PbZs0l8odgkeUlx4VVQ9iglD1xAj61cXy0A==
X-Received: from wmsz20.prod.google.com ([2002:a05:600c:c174:b0:456:1075:9202])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:3d8f:b0:43c:fbba:41ba
 with SMTP id 5b1f17b1804b1-45565edca7emr116887765e9.28.1752572071954; Tue, 15
 Jul 2025 02:34:31 -0700 (PDT)
Date: Tue, 15 Jul 2025 10:33:48 +0100
In-Reply-To: <20250715093350.2584932-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250715093350.2584932-1-tabba@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250715093350.2584932-20-tabba@google.com>
Subject: [PATCH v14 19/21] KVM: Introduce the KVM capability KVM_CAP_GMEM_MMAP
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

Introduce the new KVM capability KVM_CAP_GMEM_MMAP. This capability
signals to userspace that a KVM instance supports host userspace mapping
of guest_memfd-backed memory.

The availability of this capability is determined per architecture, and
its enablement for a specific guest_memfd instance is controlled by the
GUEST_MEMFD_FLAG_MMAP flag at creation time.

Update the KVM API documentation to detail the KVM_CAP_GMEM_MMAP
capability, the associated GUEST_MEMFD_FLAG_MMAP, and provide essential
information regarding support for mmap in guest_memfd.

Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Shivank Garg <shivankg@amd.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 Documentation/virt/kvm/api.rst | 9 +++++++++
 include/uapi/linux/kvm.h       | 1 +
 virt/kvm/kvm_main.c            | 4 ++++
 3 files changed, 14 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 43ed57e048a8..5169066b53b2 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6407,6 +6407,15 @@ most one mapping per page, i.e. binding multiple memory regions to a single
 guest_memfd range is not allowed (any number of memory regions can be bound to
 a single guest_memfd file, but the bound ranges must not overlap).
 
+When the capability KVM_CAP_GMEM_MMAP is supported, the 'flags' field supports
+GUEST_MEMFD_FLAG_MMAP.  Setting this flag on guest_memfd creation enables mmap()
+and faulting of guest_memfd memory to host userspace.
+
+When the KVM MMU performs a PFN lookup to service a guest fault and the backing
+guest_memfd has the GUEST_MEMFD_FLAG_MMAP set, then the fault will always be
+consumed from guest_memfd, regardless of whether it is a shared or a private
+fault.
+
 See KVM_SET_USER_MEMORY_REGION2 for additional details.
 
 4.143 KVM_PRE_FAULT_MEMORY
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 3beafbf306af..698dd407980f 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -960,6 +960,7 @@ struct kvm_enable_cap {
 #define KVM_CAP_ARM_EL2 240
 #define KVM_CAP_ARM_EL2_E2H0 241
 #define KVM_CAP_RISCV_MP_STATE_RESET 242
+#define KVM_CAP_GMEM_MMAP 243
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 46bddac1dacd..f1ac872e01e9 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4916,6 +4916,10 @@ static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
 #ifdef CONFIG_KVM_GMEM
 	case KVM_CAP_GUEST_MEMFD:
 		return !kvm || kvm_arch_supports_gmem(kvm);
+#endif
+#ifdef CONFIG_KVM_GMEM_SUPPORTS_MMAP
+	case KVM_CAP_GMEM_MMAP:
+		return !kvm || kvm_arch_supports_gmem_mmap(kvm);
 #endif
 	default:
 		break;
-- 
2.50.0.727.gbf7dc18ff4-goog

