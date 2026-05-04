Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4258638AC61
	for <kvmarm@lists.linux.dev>; Mon,  4 May 2026 22:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777934564; cv=none; b=XjoPvjFzTyqaSZDE314vbeXbWY2K1+ZG8OFtFQd0lC5pvueEarjin5sLJzq4r0la4AmeolFyaLarGnCZ9wNifU7HoBY18zvtW06oZI6azBaTiBpunlO/90q5FMV5laZTn+EK9VvzSk9AjG48+K7AaVAfhnCRvR0bpbHaXORucB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777934564; c=relaxed/simple;
	bh=CUOCTJmVRKCTLlMSZJdBYm2KCJJFvArAmComUQyKG2A=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OvVj3vUJW/ZM4blusG7z+InA5JtXZWXP4TGiu1TenPWo98pRnq1nx0e1+YedHp8LoHsfKHgdmd7HoW9bm5aIzNTHmEpFEvotLjWFdvKq9yK1YNAM0Rzx5kS07OZJaSvxg1gaRYhU+drt9lZm+5hJfLnSS9+NfjgO27kpqMONaKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UXhtDyP8; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UXhtDyP8"
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c7985752be1so1622714a12.0
        for <kvmarm@lists.linux.dev>; Mon, 04 May 2026 15:42:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777934562; x=1778539362; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=WPDlks8S40wU9ZB94GBJYrEHqJjoYpfybndF76KRr9U=;
        b=UXhtDyP8e+JhKlxcIlsh7RIc6fFJ/uzHIdJ8t1t0gq3Tc1zqCd7pnLX/9ig3rI61mM
         +Qg2uBhqNtlLLib+6GUXg2K63Fk2BbF5duc5TtYiEcWPwc1knADOe8wPY7ZFtfGqAKcF
         yOEF/WxqH6Pv3X9HXaeMQFuohTry3GYwa/DV0VWyOPxrU+yrxKGIcbCOZxEHIkGLkbK1
         l6Mk0Q6qIo5ouaHBmgFm1OWGy5yq1uZVdLY43/tGEmFLK4RO1HpL0jhgnX2R0rKRyNzo
         xgkXlqBL9IRnw5hJWZ4a8MIAYqCO9T25R0YPchSWJqgyA/yQXt5ANCh3lOKhxZD0d9/G
         tHxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777934562; x=1778539362;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WPDlks8S40wU9ZB94GBJYrEHqJjoYpfybndF76KRr9U=;
        b=HpbvHca9vH7WGhbe7FCadICUSAtMKQ3UM/DydAW2Pmwn1MeShCZ31IbarU+bHg76hy
         /JYlOc+54nWCjuXqg9uO2LBH9JmwKCu907O0ZG6ISwMDU1ydLJ6+MOsPnKwjX4Q/Mv4j
         y1Ok3fQnpRQDJvK7nVsc5Pyn3pDkv1u98nOM9CX61NcMnhJoCJNXuwtoKU3Ki9Csmy7q
         U5P2Vmsox1HyxkuKSp2dglInQGWGorqXJHh+tDXwcVczkW5JTlXixpTJTtTS1u6dzlkc
         IFSMhYlMcSf/UBnO/MZad0N2Xso5gvq8DS9v2C1OtN6Ft6VGI70MEBpKcH2LXjUc3+8g
         /SIg==
X-Forwarded-Encrypted: i=1; AFNElJ9EJrpA8uJM9Ss8Kog7zv3g7+cJRB0sYu7+/gsUA9Zu2KptIeMFU5nPufaJL9wpEGbKhhmIgWg=@lists.linux.dev
X-Gm-Message-State: AOJu0YxXyuKyCBqNkseQxznunTZMa2SNXJ89Wh8b9dj3seTsmSEfYI0B
	mpJjAsU+70yUyySGed9oP+zfZQ2OzEMjyZUsuzmp4I1XRVsVg8Blz514fT3+PEgfJWOVgDca2Ar
	+I3I+tUnyTEMSLPFJyQah3w==
X-Received: from pgbcp9.prod.google.com ([2002:a05:6a02:4009:b0:c79:8315:4734])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:918a:b0:3a2:e0d3:37d1 with SMTP id adf61e73a8af0-3a7f1eb20dbmr12044574637.41.1777934561428;
 Mon, 04 May 2026 15:42:41 -0700 (PDT)
Date: Mon,  4 May 2026 22:42:10 +0000
In-Reply-To: <20260504224213.1049426-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260504224213.1049426-1-jthoughton@google.com>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
Message-ID: <20260504224213.1049426-4-jthoughton@google.com>
Subject: [PATCH 3/5] KVM: mips: Grab MMU lock in kvm_arch_flush_shadow_all()
From: James Houghton <jthoughton@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Sean Christopherson <seanjc@google.com>, Gavin Shan <gshan@redhat.com>, 
	Shaoqin Huang <shahuang@redhat.com>, Ricardo Koller <ricarkol@google.com>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, James Hogan <jhogan@kernel.org>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	loongarch@lists.linux.dev, linux-mips@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, James Houghton <jthoughton@google.com>, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

kvm_mips_flush_gpa_pt() expects the MMU lock to be held; it is not in
this path.

This can lead to a double-free of page table entries if
kvm_arch_flush_shadow_all() is called twice on the same `kvm`
concurrently; such a scenario is possible.

Cc: stable@vger.kernel.org
Fixes: b62091108633 ("KVM: MIPS: Implement kvm_arch_flush_shadow_all/memslot")
Signed-off-by: James Houghton <jthoughton@google.com>
---
Note: This is compile-tested only!

 arch/mips/kvm/mips.c | 2 ++
 arch/mips/kvm/mmu.c  | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
index a53abbba43ea..463b6c4aa62c 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -180,6 +180,8 @@ long kvm_arch_dev_ioctl(struct file *filp, unsigned int ioctl,
 
 void kvm_arch_flush_shadow_all(struct kvm *kvm)
 {
+	guard(spinlock)(&kvm->mmu_lock);
+
 	/* Flush whole GPA */
 	kvm_mips_flush_gpa_pt(kvm, 0, ~0);
 	kvm_flush_remote_tlbs(kvm);
diff --git a/arch/mips/kvm/mmu.c b/arch/mips/kvm/mmu.c
index d2c3b6b41f18..5045833f8116 100644
--- a/arch/mips/kvm/mmu.c
+++ b/arch/mips/kvm/mmu.c
@@ -269,6 +269,8 @@ static bool kvm_mips_flush_gpa_pgd(pgd_t *pgd, unsigned long start_gpa,
  */
 bool kvm_mips_flush_gpa_pt(struct kvm *kvm, gfn_t start_gfn, gfn_t end_gfn)
 {
+	lockdep_assert_held(&kvm->mmu_lock);
+
 	return kvm_mips_flush_gpa_pgd(kvm->arch.gpa_mm.pgd,
 				      start_gfn << PAGE_SHIFT,
 				      end_gfn << PAGE_SHIFT);
-- 
2.54.0.545.g6539524ca2-goog

