Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D24A92949F3
	for <kvmarm@lists.linux.dev>; Wed,  9 Jul 2025 11:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752058830; cv=none; b=d9j+aAfaWj4BwAmuRaxSE1c/xO9pF+ehFDV+JzMnr99F9TzZzANP9Q1LfN160QsMD7blGdd+ws3NDLQ0wetJ68oXzcIn79JqAcuE5loF5HsPzPyC3UsD6UjMUxAxtRnj8fqs80tkG9V8A0n9MbmMtzpY48tr1UGrzblkEpH50uQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752058830; c=relaxed/simple;
	bh=m/nmoXWVPgCKDwXnifRxHNN6Py4H7d6jjERskE5ddl0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Cir9l/8qFmQ3QhTCrVZ2D26NnCBHKEAF4sC85IwXzatMhdWUetmQoVF9scjrCNx1Ljbp1m8gB8ulRv6dg3rir4BI4+p+TpLyWNhecNnG7woAPCRK3hayEUvQRWCrKorVnG2Fv7ygKQ7tOmUQyBdNjO1x+th1vw8fmLluMrGi7VE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=D31AZ2JO; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="D31AZ2JO"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-3b4a0013c0dso1485835f8f.2
        for <kvmarm@lists.linux.dev>; Wed, 09 Jul 2025 04:00:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752058827; x=1752663627; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=EN0gEy7fU6jw5R0YczNv78dam7g/lGJpUBf0uEoq9Mk=;
        b=D31AZ2JOB/4xEqsc9nDUTlKV1z2okINVZ/I4gkTA4hzcbQzXRx5BGwg2Q9SXVhbpSA
         l8/ZkdeBtLR57W6KShCWnMbw+++meb3RTmdtslqqJnk+W6XV8CJP+8f+Nl/g7FzqQtXF
         YjlVng+gGTDRuh97gTo/zvHWXazuuhInkyHT8OOekfjqJ43ffRXsyNOsUjMZw7Ut5vAU
         AKvydYkpJ6EzKJtnHzDw8hBatO/fywtjItWDWDq+LmkLfi0BDFwv5B7nSmd+E+oL5qPo
         XFJnTJLqkM19Ngp/vpNp1WXzY87k7NZZE9pkvs0tA7x3S8iI9y1dfl2CIil/AcIaBtEy
         i8MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752058827; x=1752663627;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EN0gEy7fU6jw5R0YczNv78dam7g/lGJpUBf0uEoq9Mk=;
        b=c5s1yQGBluAzHteQOB6T5krn2ghVN8QbhUbGDGOOH98fUQYPD8TZsiH1/UnKn3TxWT
         VbCrZA7XWKGSADJKdF2WccAhcm7cOSaTYPepKusPgQ7Ycnf98hA1+jzxpAJzRmNflD5T
         3Omhkp5zCgUn06++lNS5tNh0Er32F0YhlXT4cpJpmCW82tDK/KVbaFCRRUr6H/i6U630
         kHj6CyjhmmTWzyGCZ1Y/b2gnFUMIIW2MJwgbdkYa1mJeLMw+LxSfjOOnnKMMHV0BxD5E
         onCsqp6Fl/LeWdlWmAR9eBwjRMzEweVt8oLlJrqJ939MV2vLA4kH9BIinWQcjhtNMK76
         dUmQ==
X-Forwarded-Encrypted: i=1; AJvYcCUVSZGuyzCB0PUVlOPHHUnFsnfMhRgSjVWmAUXqcQePYXLGvwx7Y22dgPzAMVG/sJAHbhonx2g=@lists.linux.dev
X-Gm-Message-State: AOJu0YyysIVC99bLZ8GpRoGIvcbkj981VKnNmNlM3ls7TKEI7cqupXmN
	2G3pQH/xD8SqsroFsVy7XSaIZZzS5CM5TkH/abSmI/m4eK6a0dWiQiquS11Lqr6xQblLmo3VCNi
	6HA==
X-Google-Smtp-Source: AGHT+IHX8EI5JXc2m1Ub6jRFvHKhxx/iMkDQpy+4Lc0WVLTknDLg7nWPPGgOQGFU7U2VLXzeD+QYo91L5w==
X-Received: from wmth13.prod.google.com ([2002:a05:600c:8b6d:b0:450:dc81:eec9])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:2006:b0:3b4:990b:9ee7
 with SMTP id ffacd0b85a97d-3b5e453117emr1323755f8f.22.1752058826920; Wed, 09
 Jul 2025 04:00:26 -0700 (PDT)
Date: Wed,  9 Jul 2025 11:59:44 +0100
In-Reply-To: <20250709105946.4009897-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250709105946.4009897-1-tabba@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250709105946.4009897-19-tabba@google.com>
Subject: [PATCH v13 18/20] KVM: Introduce the KVM capability KVM_CAP_GMEM_MMAP
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
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 Documentation/virt/kvm/api.rst | 9 +++++++++
 include/uapi/linux/kvm.h       | 1 +
 virt/kvm/kvm_main.c            | 4 ++++
 3 files changed, 14 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 9abf93ee5f65..70261e189162 100644
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
index c71348db818f..cbf28237af79 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -956,6 +956,7 @@ struct kvm_enable_cap {
 #define KVM_CAP_ARM_EL2 240
 #define KVM_CAP_ARM_EL2_E2H0 241
 #define KVM_CAP_RISCV_MP_STATE_RESET 242
+#define KVM_CAP_GMEM_MMAP 243
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 81bb18fa8655..5463e81b08b9 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4913,6 +4913,10 @@ static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
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

