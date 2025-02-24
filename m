Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A354211471
	for <kvmarm@lists.linux.dev>; Mon, 24 Feb 2025 23:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740441358; cv=none; b=D79COWNaSejDt+OpZ7cZ1ys6rFUk9y+9bzWnHy/c53/ZDoFNtrHaKiPAzKwEcLgTzBPSNZMBjKu5gHp2OejiU/gOmf1qb6qNszc+oAJUZulePGEiVXr2PaP2yQtV6MggPhJPhzEAu5gM+se8ZWwp1+nK8lG4BDsuaVTAnYpEW7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740441358; c=relaxed/simple;
	bh=RyQAx7Z5zYd41S/+BHB5zwIwQj3p0JUw5qeOKaGY3V4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WVMuAnmygArUgwNFlMrpF3iFPc4qa6bQsqLECMLsbi4X4S/+03Wb0VjzqPRLTeDwUfCu1YWvVwmw3eTOe/wrodc7sJWWD2+OHcM3tAsw3Wcs+0XYIr3V81qpF5pGzw1U50xQTStHxwZeNWvx2vCC+d/KBssGjddhsC2GIDJEKL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UVRHZ0UN; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UVRHZ0UN"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-220e62c4fc2so108951945ad.3
        for <kvmarm@lists.linux.dev>; Mon, 24 Feb 2025 15:55:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740441356; x=1741046156; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=TJTgZNhYY30nXxMYJRDXX1rx/rqsWdUW6nwlsEZr+Zo=;
        b=UVRHZ0UN6mA/xjB8EFlhbh9jbv5Ih6CqUS3Xju37yb+S/XkKy4W24EOfvdv75qOAL9
         j5xCY12u2KAK4YjdgXYjocSl+oksj0Ipx0QTwbwTRkSS7lEyqcJmkXsnIv6FJV9bsvm2
         TZp4lpwKPqn0YlMyUiyDJMdu5E5T5oE+iNd58OVeaeYcyXC/iWH5nanIM6aB+d93O/kr
         cDdk9hlio7feaTydXzD9LUVu7ISPHk0Pfs8ze2UhPwhM6BCgctOYn05Mi2dSlpBkWDyB
         aLEXVqA74qKdAOJiZY1x9kPvD5gOYQI4ShEeEKUU8UHP5aPCwloZZF6oeBadf6zD6yn9
         v4BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740441356; x=1741046156;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TJTgZNhYY30nXxMYJRDXX1rx/rqsWdUW6nwlsEZr+Zo=;
        b=BqaqKPap/8QcCU96jpMahVVX6NdhfhsD1JkwCxNOcDBxBbxwTvyx9aOlgJj5aZauRx
         RbQMPrZ6SYIUC/QQ129uqbL9nJZhF5uihitf2w9FiRJlyMoyi/T4GzTOZmcfLkzGpjZP
         RsFMv09nchRVQngIPJsd/30khf0SW+JXJjDCPGhvHS4tqu5cJo1GhoOhHA8mWM4e7oza
         FShkJI01wepwXvMJ1Wj37Iw7vKJil5kKvgUseGwdUDixHZ0Hsvr20BYjJb6as0wjq5gG
         W9llnk+WO6zqcIpFRbRZfibZJSiew2cRnZzXbCCS1g9UU9fVYvzBGKVavOnYW5N53W0D
         DDKg==
X-Forwarded-Encrypted: i=1; AJvYcCUygA7HXSvIEq1tQmpCNZfIi+JQUnnINkeCjCnkh9hfKWk7IU+18n0JeICmm67meBOQ45jZ6V8=@lists.linux.dev
X-Gm-Message-State: AOJu0YxV4fQS3+rskdRkyWuYoznuQln+oknjfw8Ge3edMwZJsoWODCHv
	eVQp30QU7sfC1a/crns56vNt7BlP/9Q73tjAXJIjXI8oUieftQoq9aUP8WhIbwwzoTaO54lka9C
	7OQ==
X-Google-Smtp-Source: AGHT+IHgthprmvsK7rAfh+PsqOM1pat7xQuGm72FmKpfdI+qTOt1cCxKN5aFSZszJT1EFJi9jy4pNoVXfJY=
X-Received: from pfbig2.prod.google.com ([2002:a05:6a00:8b82:b0:730:7c03:35e1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:1947:b0:732:623e:2bdc
 with SMTP id d2e1a72fcca58-73426c84885mr24369761b3a.2.1740441355733; Mon, 24
 Feb 2025 15:55:55 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon, 24 Feb 2025 15:55:41 -0800
In-Reply-To: <20250224235542.2562848-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250224235542.2562848-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.658.g4767266eb4-goog
Message-ID: <20250224235542.2562848-7-seanjc@google.com>
Subject: [PATCH 6/7] KVM: x86: Fold guts of kvm_arch_sync_events() into kvm_arch_pre_destroy_vm()
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

Fold the guts of kvm_arch_sync_events() into kvm_arch_pre_destroy_vm(), as
the kvmclock and PIT background workers only need to be stopped before
destroying vCPUs (to avoid accessing vCPUs as they are being freed); it's
a-ok for them to be running while the VM is visible on the global vm_list.

Note, the PIT also needs to be stopped before IRQ routing is freed
(because KVM's IRQ routing is garbage and assumes there is always non-NULL
routing).

Opportunistically add comments to explain why KVM stops/frees certain
assets early.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a61dbd1f0d01..ea445e6579f1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12772,9 +12772,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 
 void kvm_arch_sync_events(struct kvm *kvm)
 {
-	cancel_delayed_work_sync(&kvm->arch.kvmclock_sync_work);
-	cancel_delayed_work_sync(&kvm->arch.kvmclock_update_work);
-	kvm_free_pit(kvm);
+
 }
 
 /**
@@ -12855,6 +12853,17 @@ EXPORT_SYMBOL_GPL(__x86_set_memory_region);
 
 void kvm_arch_pre_destroy_vm(struct kvm *kvm)
 {
+	/*
+	 * Stop all background workers and kthreads before destroying vCPUs, as
+	 * iterating over vCPUs in a different task while vCPUs are being freed
+	 * is unsafe, i.e. will lead to use-after-free.  The PIT also needs to
+	 * be stopped before IRQ routing is freed.
+	 */
+	cancel_delayed_work_sync(&kvm->arch.kvmclock_sync_work);
+	cancel_delayed_work_sync(&kvm->arch.kvmclock_update_work);
+
+	kvm_free_pit(kvm);
+
 	kvm_mmu_pre_destroy_vm(kvm);
 }
 
-- 
2.48.1.658.g4767266eb4-goog

