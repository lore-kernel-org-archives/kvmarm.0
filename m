Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 829AA1531F5
	for <kvmarm@lists.linux.dev>; Fri, 30 Aug 2024 04:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724992577; cv=none; b=H3qHqxyFx7tE0tnr3kMsGIUtiL0Q9ievQul9RovyuguJcSB9xUPc6BBa80Ueo9CiNOoWxDQXKWLAR2C2PLh1TfhtxMjGV87EAhm5gX/NIZoeP2+6HRoFgvatLDltuN9b6Od6bAT9oDt14cr87IB0AWPCQT04e24Rm/mcjw5qWUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724992577; c=relaxed/simple;
	bh=guZPEi4HnZ68kmunYREUsW0wJ0a79wE6zG0LOWaHkWk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qBHYpZ5wqhLsZVKArOCVkRNkWAKA6X67jqvk+IyY2TCDUUEzR4TAQUZpEQqPwy+5PVDGVzdvmtibonOznX28i9A7mKzAxMuYqld7D15acepU0CyH05JqadOWB22sFVFLLvuZgkImrE50MeLFO8mwG2wwM4a5TXRdyu0MMiWfYi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kOKcoCOt; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kOKcoCOt"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6b052c5939cso17532457b3.1
        for <kvmarm@lists.linux.dev>; Thu, 29 Aug 2024 21:36:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724992574; x=1725597374; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=udiDa1YXNVQe9YQdq8pNqA0v4AMGb+sHHwac6qQVu4U=;
        b=kOKcoCOtb7mIrTADOCVnnvrGawF4Ra3B3XQkuy3NqOf3M2EyjweFgk4ceJ5RJxXuYJ
         4N5u7hoqGKHzD/S9nha2yW4fBTvK7hvczYs8vPRTVabjw1et4LawWocLhF8Tv/T0HkCE
         s0UsLqn27NFY+VDsYDVWr4yrRawE/UycmykAzcT9lK96jHE6yijRnmn0iyTXyAy/mBSh
         71xon+dLk6tFpnYXozw4eHKMQYSlK2ruharQOiiLyn242sRFsB2Owzs5Kfuvhsqmi9go
         CgulxMF3+zrc77Vm7IokO9GZHFAgSwLg/cB7x8uY+24LfmhYXO2J8CY/0vOJAm8FzJ++
         jXGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724992574; x=1725597374;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=udiDa1YXNVQe9YQdq8pNqA0v4AMGb+sHHwac6qQVu4U=;
        b=cCBW0YCKToNiddIYuQnhnH2EFTl26owutIWvVpzudFNbljCjTcW0duHdKu9VZmTIOW
         EZ4zB69YJuja2oouuZdwhwgod7EtAsYJJNViuRGdd8Y4izX8bFraTbSqZ7OHTBTr72bo
         8emWj/rIwl/ip/Io/HGxN9EKMp1ZXjMfW3Ic5ZojXfoB7cn4HTutzVau/GUU10ZMnKo7
         ZoZDFbHCFskxdv0afFmL9hV7aX1AMPNmymrq5rs1tCIrWNXL9c9R9Xr6j94NziA1IkFY
         FkYDgUZbSMWVDhxomyol4DfaynykUm4Jj8SLJQpZFBLfpqvrKIaYicQeuXLXtYqMiU+k
         ZWwQ==
X-Forwarded-Encrypted: i=1; AJvYcCV8NL6uZsGMhjoTB6qftQ53U74b34ovLK4JkplzverO2tGqKFnIGOzhhkhnvQDqSqwlrY+ainM=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw19pFAfPiY3hJEbrTNdCKfKc/fb4pSv5qhzsuAPoZBxY1dyNRJ
	/ERTickXscp9NTZ3rE7hVmjS/kP9ty5rRtYRccz8hh8mdYd8Lpixvl87B9dNxF7KJ/CEAlP7Vvv
	exA==
X-Google-Smtp-Source: AGHT+IF7AfgBrJe8PwdncYuFwENH9bcWVSUBeh2Gmsa0ZJKxp7DrJ4HVnhtseSn5Ja9qHK89gyQHI56lkSI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:6681:b0:665:24b0:e936 with SMTP id
 00721157ae682-6d286f64db5mr2502337b3.4.1724992574565; Thu, 29 Aug 2024
 21:36:14 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 29 Aug 2024 21:35:55 -0700
In-Reply-To: <20240830043600.127750-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240830043600.127750-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.469.g59c65b2a67-goog
Message-ID: <20240830043600.127750-6-seanjc@google.com>
Subject: [PATCH v4 05/10] KVM: MIPS: Rename virtualization {en,dis}abling APIs
 to match common KVM
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Chao Gao <chao.gao@intel.com>, 
	Kai Huang <kai.huang@intel.com>, Farrah Chen <farrah.chen@intel.com>
Content-Type: text/plain; charset="UTF-8"

Rename MIPS's trampoline hooks for virtualization enabling to match the
recently renamed arch hooks.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/mips/include/asm/kvm_host.h | 4 ++--
 arch/mips/kvm/mips.c             | 4 ++--
 arch/mips/kvm/vz.c               | 8 ++++----
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm/kvm_host.h
index 6743a57c1ab4..f7222eb594ea 100644
--- a/arch/mips/include/asm/kvm_host.h
+++ b/arch/mips/include/asm/kvm_host.h
@@ -728,8 +728,8 @@ struct kvm_mips_callbacks {
 	int (*handle_fpe)(struct kvm_vcpu *vcpu);
 	int (*handle_msa_disabled)(struct kvm_vcpu *vcpu);
 	int (*handle_guest_exit)(struct kvm_vcpu *vcpu);
-	int (*hardware_enable)(void);
-	void (*hardware_disable)(void);
+	int (*enable_virtualization_cpu)(void);
+	void (*disable_virtualization_cpu)(void);
 	int (*check_extension)(struct kvm *kvm, long ext);
 	int (*vcpu_init)(struct kvm_vcpu *vcpu);
 	void (*vcpu_uninit)(struct kvm_vcpu *vcpu);
diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
index 52e1f275351e..60b43ea85c12 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -127,12 +127,12 @@ int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu)
 
 int kvm_arch_enable_virtualization_cpu(void)
 {
-	return kvm_mips_callbacks->hardware_enable();
+	return kvm_mips_callbacks->enable_virtualization_cpu();
 }
 
 void kvm_arch_disable_virtualization_cpu(void)
 {
-	kvm_mips_callbacks->hardware_disable();
+	kvm_mips_callbacks->disable_virtualization_cpu();
 }
 
 int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
diff --git a/arch/mips/kvm/vz.c b/arch/mips/kvm/vz.c
index 99d5a71e4300..ccab4d76b126 100644
--- a/arch/mips/kvm/vz.c
+++ b/arch/mips/kvm/vz.c
@@ -2869,7 +2869,7 @@ static unsigned int kvm_vz_resize_guest_vtlb(unsigned int size)
 	return ret + 1;
 }
 
-static int kvm_vz_hardware_enable(void)
+static int kvm_vz_enable_virtualization_cpu(void)
 {
 	unsigned int mmu_size, guest_mmu_size, ftlb_size;
 	u64 guest_cvmctl, cvmvmconfig;
@@ -2983,7 +2983,7 @@ static int kvm_vz_hardware_enable(void)
 	return 0;
 }
 
-static void kvm_vz_hardware_disable(void)
+static void kvm_vz_disable_virtualization_cpu(void)
 {
 	u64 cvmvmconfig;
 	unsigned int mmu_size;
@@ -3280,8 +3280,8 @@ static struct kvm_mips_callbacks kvm_vz_callbacks = {
 	.handle_msa_disabled = kvm_trap_vz_handle_msa_disabled,
 	.handle_guest_exit = kvm_trap_vz_handle_guest_exit,
 
-	.hardware_enable = kvm_vz_hardware_enable,
-	.hardware_disable = kvm_vz_hardware_disable,
+	.enable_virtualization_cpu = kvm_vz_enable_virtualization_cpu,
+	.disable_virtualization_cpu = kvm_vz_disable_virtualization_cpu,
 	.check_extension = kvm_vz_check_extension,
 	.vcpu_init = kvm_vz_vcpu_init,
 	.vcpu_uninit = kvm_vz_vcpu_uninit,
-- 
2.46.0.469.g59c65b2a67-goog

