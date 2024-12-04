Received: from mail-ot1-f73.google.com (mail-ot1-f73.google.com [209.85.210.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D2421F03CA
	for <kvmarm@lists.linux.dev>; Wed,  4 Dec 2024 19:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733339661; cv=none; b=OVRUMWzmLejAAGEu+Z6ENf7WysZKnDUH13hAor42Dc86E3Tar5FpPMVGT20ZP5hQ536ITJmeIc8H/1ca9IibyPaGCEXWpJHl77Jtu7PIqvAeRq7YwwDsSQ4IxzsUSX+2lEnFd9/B0FG+P2HxeQBs0Cv4+g4MIi6Xus7K2BX9+cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733339661; c=relaxed/simple;
	bh=TpUkUFBOXODTTMhFPZD2lNGB5T081ke6yKBQcgGS+ss=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=J0X6yxFhyVvJwH7TYMIhPvyaxyc6OAuh8hCOFEvl9lvH1WkNWhEgpjIuYiW3t2Izihp0tp7tt3ZamX6jqHdxYxQOQMxQnSeq2hmLty0kRixXxS/vcn2KZlovNzs04LhRiMetrktzKV+6l8o4Um/SAOqtprJmJ2o05qxtzcKaSs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=K+7gmdeo; arc=none smtp.client-ip=209.85.210.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="K+7gmdeo"
Received: by mail-ot1-f73.google.com with SMTP id 46e09a7af769-71d4d517158so111401a34.3
        for <kvmarm@lists.linux.dev>; Wed, 04 Dec 2024 11:14:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733339659; x=1733944459; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=QAQf3CS/PWwFToEYvErsd8wUXXWpCS3gaH7WeW/jjGQ=;
        b=K+7gmdeoE/+O8u1FrUtCFq+jKJFJjC0Ejm9k0FpVRsz2L8eoHbxzxkozr/VCoRCn0g
         QYYJOBI3Fu+guVGAcNFJ+Ppwt2lEaQOJqI1fq0mOedawORnTt7IKE2APdZWxlhSREmNM
         SHHHcgtxqiq/tPYd68iDO40NVAarBxeWru979kfJY2KYPCcm60FeNaqedLuTYWM3m1RJ
         xu4qYvN/PG1UDqLM+cLUHFSpaiVkE2x/Z885iZ97Wnt0+rmJQlmMacY5TEFTaZtkqIJF
         vig02tB+Avvrj3lpeEn/rx/nanFSiB3lZhjT2okH4zL9BjyWgnVsuEb0wwiBhG4dZciM
         IP+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733339659; x=1733944459;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QAQf3CS/PWwFToEYvErsd8wUXXWpCS3gaH7WeW/jjGQ=;
        b=apwkpc9Saz+N31tQzr+n4h72X1U/0sco+ZEJR3+nnaaXkezh6lWe8kmmGnQ4sUW98+
         B3eYKIE0NuUz9JHJJ6Uc217dUXfoknKh3eWHhUvbtbFtqWR/DbxKxxDnH1WjVDukScev
         WRYo/VVrfUMMzcl6DczvnI6XL8efrGSWSNWlX2/Nq4pVNm6/ZWubCZotbL3WSbQmgT66
         IYtjh46j9vsK47t0m+LdpFFC3pibq5A4Iy2v5aZSrEWyKXAD9ELi1wS8i2yh8txdq19D
         eO7C7cNZFk3VF5OqUToUifUSRz7dWfKKcG+4e/DSoDfKXxYhETtw0CvsNH9dCILo7QRb
         9FEg==
X-Forwarded-Encrypted: i=1; AJvYcCVl6mf6sVnewA2o0rhMjx+NFUlKrKYTWr74DsPmo3XJrqIvuQLkuTYhF1tJt8/6DH/V8hMGbP8=@lists.linux.dev
X-Gm-Message-State: AOJu0YzbcEamx57Our1iQRzlIewAy+ZJEJ5cVjtIav6Ly/VDlehj/oAF
	WT/8jHQv5XxoQ45dNvObXw9+u0hKVkWQ/fN02CEt/NBSVWZK6+TUVyTQ7YaRCQYazRXhyImgFwP
	/x2mYvLf5TUtaPv824g==
X-Google-Smtp-Source: AGHT+IF4lgVNFWtAABhlVyCvDTypvCqwQE4E76pJaa2ei5llPSfzgOLBadwb4XjVCcPSe7j0KBf+vwviXHvnVJ9Y
X-Received: from vsvj2.prod.google.com ([2002:a05:6102:3e02:b0:4af:5a5c:cdaa])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6830:348b:b0:71d:4c3b:f464 with SMTP id 46e09a7af769-71dad63c3e4mr7692549a34.13.1733339659221;
 Wed, 04 Dec 2024 11:14:19 -0800 (PST)
Date: Wed,  4 Dec 2024 19:13:39 +0000
In-Reply-To: <20241204191349.1730936-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241204191349.1730936-1-jthoughton@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241204191349.1730936-5-jthoughton@google.com>
Subject: [PATCH v1 04/13] KVM: Advertise KVM_CAP_USERFAULT in KVM_CHECK_EXTENSION
From: James Houghton <jthoughton@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Yan Zhao <yan.y.zhao@intel.com>, 
	James Houghton <jthoughton@google.com>, Nikita Kalyazin <kalyazin@amazon.com>, 
	Anish Moorthy <amoorthy@google.com>, Peter Gonda <pgonda@google.com>, Peter Xu <peterx@redhat.com>, 
	David Matlack <dmatlack@google.com>, Wang@google.com, Wei W <wei.w.wang@intel.com>, 
	kvm@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Advertise support for KVM_CAP_USERFAULT when kvm_has_userfault() returns
true. Currently this is merely IS_ENABLED(CONFIG_HAVE_KVM_USERFAULT), so
it is somewhat redundant.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 include/uapi/linux/kvm.h | 1 +
 virt/kvm/kvm_main.c      | 4 ++++
 2 files changed, 5 insertions(+)

diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 641a2e580441..d9a135c895d7 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -936,6 +936,7 @@ struct kvm_enable_cap {
 #define KVM_CAP_PRE_FAULT_MEMORY 236
 #define KVM_CAP_X86_APIC_BUS_CYCLES_NS 237
 #define KVM_CAP_X86_GUEST_MODE 238
+#define KVM_CAP_USERFAULT 239
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index fa851704db94..b552cdef2850 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4804,6 +4804,10 @@ static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
 #ifdef CONFIG_KVM_PRIVATE_MEM
 	case KVM_CAP_GUEST_MEMFD:
 		return !kvm || kvm_arch_has_private_mem(kvm);
+#endif
+#ifdef CONFIG_HAVE_KVM_USERFAULT
+	case KVM_CAP_USERFAULT:
+		return kvm_has_userfault(kvm);
 #endif
 	default:
 		break;
-- 
2.47.0.338.g60cca15819-goog

