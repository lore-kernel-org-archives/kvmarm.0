Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3305C20C492
	for <kvmarm@lists.linux.dev>; Mon, 24 Feb 2025 23:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740441353; cv=none; b=bYZmwLV8GO+QtQCGxwBY8DEatzyD2kxb9rhHC017coGXVIEBgk5dxzRQ8gPHao3fRsgBHN3J37D/wxtF3XAKl4oErAKL79fr3fXp3MWJEo5gs38+Fojp5oih66Ufw8J9/ighHja8LdoH5JtnkziiLwW8ar8nJe72LRUoYGj+Z10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740441353; c=relaxed/simple;
	bh=4XGt0AThhPQKODAnl6NTLZpfJZyUD3zLteURrvwSqiE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cyMwqRvha0yL2OCLlwJX3ZmeMrh/6Z8IVzn/6v+NzUtrt0i5gmBlVhWETf/87vBmueJhteSIs67q72iILIQwVIyQjAPai7seZqjGVBFk842eaBLhs0q9bKiI/7BFYRkutiEo67r2kYWYo6UaaSGLK5gS5xs6cqH0vrEPat7DjIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QxoekT/c; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QxoekT/c"
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-220cb5924a4so49385895ad.2
        for <kvmarm@lists.linux.dev>; Mon, 24 Feb 2025 15:55:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740441350; x=1741046150; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=cX82JgrIVLcCgP8NY5WI6d8YhxJG+M3Mihkk6f4MOJg=;
        b=QxoekT/cO6HbZ7oAQdqAxsAHDbKEMxWKm6NaG8aWmh/NW0Ff6fnmH7hGmeRRVdUq4t
         56/YwKxBRd4MEjIBJXK/6UiiFOIHBUJV249aOd/ghzg+2/ka1vYMXu2FiYxEorD0vpcB
         D7XHc3Hmo7R2CRFzLCIAkDeKXvgHvLzLt8raOnsYF+UWj3DG3zfC3ReGx3djaVjnxXRk
         nThVCQhRIPTeuafKj7kMSUXhHDaBvxhy4DuKg6mvWDoR9wWTkAqHadeu3UCyHQkIagTB
         mDgiEIT+lxKeUaqhvzEnOXIXU+ey9vzi9MLlqjsuoHeNzz2bMdCTxrqHX1xwEa3NFmnG
         xb0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740441350; x=1741046150;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cX82JgrIVLcCgP8NY5WI6d8YhxJG+M3Mihkk6f4MOJg=;
        b=poqYH7L/8P9aYcCHoW83Z59vfuFYwppzBtYVdX+Ljzmc2GxsRpNp0xxTfjjje0MWOK
         gICHcFshIELo6eJGb1CjRTLQyP+NGGJyrR9S8JIvN59KaSoyr18MXrHZB7lQ12ocsgUO
         tTE5wgaXmf6iUOYidCKKsRPAmQyLAobT8kf3QFMubHfzSug9KTdhQMvkXQ+xFxcsDDme
         TcaPw44608bTl35kYihYTaKH3Ldr6XdEs69tsueU7G9/ONtGPSvmVyb8OjXLABl6zvIz
         7uvduqsIKxM5jzL5zKRssChzz8bLgPtvBp0jEn2pYocrZGlVqVUOCCSDKlNMeko5C/pO
         6GVw==
X-Forwarded-Encrypted: i=1; AJvYcCVVGgNDJ6Rq/rAY9nYJgQO0Mn2Vbe0xRTlCAxGg0Z+AR5Qyk84AmgUHKNS1h8RB3xF8Plk8hiU=@lists.linux.dev
X-Gm-Message-State: AOJu0YxcuMUCgGzG6fM8L3phTdzVGZIbxD/34Dp2CXk8sHpnRs2pswXF
	xHyrgFwXSXG0AYzOiZ66+XZzixZ5Accfzziktbq0hV3HOFAgvHUoxYLtjLErbJM0GSsFIwMS44l
	TLw==
X-Google-Smtp-Source: AGHT+IGsyGC9C+MeujnUnW2nPba4jsQ7IgXXOkNko0b7VAiFOZ5bP8OY6ummej4/xlJQLwWUr2RcXaF45Ig=
X-Received: from pjbse14.prod.google.com ([2002:a17:90b:518e:b0:2ef:78ff:bc3b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:2f8d:b0:220:d81d:f521
 with SMTP id d9443c01a7336-22307e72198mr15100345ad.51.1740441350608; Mon, 24
 Feb 2025 15:55:50 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon, 24 Feb 2025 15:55:38 -0800
In-Reply-To: <20250224235542.2562848-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250224235542.2562848-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.658.g4767266eb4-goog
Message-ID: <20250224235542.2562848-4-seanjc@google.com>
Subject: [PATCH 3/7] KVM: Assert that a destroyed/freed vCPU is no longer visible
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Aaron Lewis <aaronlewis@google.com>, Jim Mattson <jmattson@google.com>, 
	Yan Zhao <yan.y.zhao@intel.com>, Rick P Edgecombe <rick.p.edgecombe@intel.com>, 
	Kai Huang <kai.huang@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"

After freeing a vCPU, assert that it is no longer reachable, and that
kvm_get_vcpu() doesn't return garbage or a pointer to some other vCPU.
While KVM obviously shouldn't be attempting to access a freed vCPU, it's
all too easy for KVM to make a VM-wide request, e.g. via KVM_BUG_ON() or
kvm_flush_remote_tlbs().

Alternatively, KVM could short-circuit problematic paths if the VM's
refcount has gone to zero, e.g. in kvm_make_all_cpus_request(), or KVM
could try disallow making global requests during teardown.  But given that
deleting the vCPU from the array Just Works, adding logic to the requests
path is unnecessary, and trying to make requests illegal during teardown
would be a fool's errand.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 201c14ff476f..991e8111e88b 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -489,6 +489,14 @@ void kvm_destroy_vcpus(struct kvm *kvm)
 	kvm_for_each_vcpu(i, vcpu, kvm) {
 		kvm_vcpu_destroy(vcpu);
 		xa_erase(&kvm->vcpu_array, i);
+
+		/*
+		 * Assert that the vCPU isn't visible in any way, to ensure KVM
+		 * doesn't trigger a use-after-free if destroying vCPUs results
+		 * in VM-wide request, e.g. to flush remote TLBs when tearing
+		 * down MMUs, or to mark the VM dead if a KVM_BUG_ON() fires.
+		 */
+		WARN_ON_ONCE(xa_load(&kvm->vcpu_array, i) || kvm_get_vcpu(kvm, i));
 	}
 
 	atomic_set(&kvm->online_vcpus, 0);
-- 
2.48.1.658.g4767266eb4-goog

