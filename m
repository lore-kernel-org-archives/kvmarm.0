Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B001F16190B
	for <kvmarm@lists.linux.dev>; Fri, 30 Aug 2024 04:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724992583; cv=none; b=pLbTu6HcgVhGSmeFWhP8l1/ZKYoslsWQN/oVj7LQ3ab0LJpFV5GWTSoQ5x5b0UL/1+O33Qm1Cg63mp7QhgnyGnmfArEqE+VlfQFeyHJoyEf3SnwLTMNbZOF6e5+pdO4Hn5fvTwmk5OQ4mZdhpeKVSvzqXkEBbkQV7c9wfbtG1e4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724992583; c=relaxed/simple;
	bh=dkoydZWsfrh+v9zcazAPXepH7bmtcVEdXIe2ya2h+0E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SzjsKL0uleYRDUvs9s+0o0z/6JqR/EVmD9f1muXaJO13UvU/7tt725OqhwYNqCXxgemuTQVtOss8HjiVrCcpH3HQwvtbJ1lhui3VL4Kvwm/pKlHPxO/SDxSwBwuojD58/sM7sOtEPhJ6Sw1jKB3JiQkilu/ZQcgcn9iCfY4BbG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qGPqhTh9; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qGPqhTh9"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6d3aa5a672dso14697207b3.2
        for <kvmarm@lists.linux.dev>; Thu, 29 Aug 2024 21:36:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724992581; x=1725597381; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=k204YuuBNkPIQSpU0QhI7EvnHBfhBz5F6jzs/OiMdls=;
        b=qGPqhTh9hCWtX5WSPN2CpAzz6CW7tfvZRFREvPMG0jJwQdf+eJ2HgEYXnJuNFqHOWZ
         T5p3+P7Q2WmavRDe5eQ87uwpua3RQcf6jva/I6DuLofBJxBauX+m+31i/074JdIfu4rY
         PL0e+EafW/U190j047I4r2+oSVlj9wYZ44yB0EnEpXUjvOBM/zGtC/Kdd4e6ce4BHweE
         BjSH6kOKpzvgXUUjyclKxC0Ajp6+FxYzd58tq9rekqRnBaUxO5pFho3aaNXYBzbyrFBT
         giSS1waQT989gMtlV9ri7zrbIQ/Ap459W5gYLv6gFzDDfRfK+1TRyHu07V3jcX8bSEiI
         mnAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724992581; x=1725597381;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=k204YuuBNkPIQSpU0QhI7EvnHBfhBz5F6jzs/OiMdls=;
        b=e3gYvSG82SxnOmcBqHO+X3eK9mMRqJX/iTc+nJb/wDLPvXEkOrmjct+2o3cKZTJxFE
         +bD0b4m3+8Ne3SkBtbzy1wM9hiqbRHtufW5VAXRj5tdMaTQUKn/381w7R+HbDRbSixbL
         hDNl9dK5lrjROQrLqYKFwsxKisdjlRQybTaRkVAR9mPULodmNxs+Aq+yFINvEs0Jmshg
         YLtllj640QnbLkSGCZj2L5K/zi/Drla1AT5OWWnfFtZuor0oCaSQgisbfs6tnfWi+usM
         y2GRY/85oP+LDP2WqIa/9KXeVIMpk4Q0SYRALvwM5JwQkLc44yrtAH4iSRhoa7oLdsYv
         l62w==
X-Forwarded-Encrypted: i=1; AJvYcCVMiPvC4g9CgrTrmhKqsnzEDr8tjy9NlUMr0Eal3KJp9SKOGfxoSm0pQtS62x7E1B29S7su0lA=@lists.linux.dev
X-Gm-Message-State: AOJu0YwZB9udBbqiZF9p94UQtDa8JZR3ptW23Q9saTOyQw0FlKiBUBrb
	PhqQYeFGKDO0fdVjdod1SOoF/LYN3IoWv+QdSyd/zetPXKjjDqQik1wDTHeVJc3V6u7cP92i2jm
	1MA==
X-Google-Smtp-Source: AGHT+IH7doeLworevO5q5a0Cpx/I2Hf/rkCrWJ1Q/dDQPDqM64XFN6CvEdH2toTw5kd6ygYMiJVKDoge7UM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:e1f:b0:650:93e3:fe73 with SMTP id
 00721157ae682-6d41000b45bmr405537b3.5.1724992580739; Thu, 29 Aug 2024
 21:36:20 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 29 Aug 2024 21:35:58 -0700
In-Reply-To: <20240830043600.127750-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240830043600.127750-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.469.g59c65b2a67-goog
Message-ID: <20240830043600.127750-9-seanjc@google.com>
Subject: [PATCH v4 08/10] KVM: Add arch hooks for enabling/disabling virtualization
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

Add arch hooks that are invoked when KVM enables/disable virtualization.
x86 will use the hooks to register an "emergency disable" callback, which
is essentially an x86-specific shutdown notifier that is used when the
kernel is doing an emergency reboot/shutdown/kexec.

Add comments for the declarations to help arch code understand exactly
when the callbacks are invoked.  Alternatively, the APIs themselves could
communicate most of the same info, but kvm_arch_pre_enable_virtualization()
and kvm_arch_post_disable_virtualization() are a bit cumbersome, and make
it a bit less obvious that they are intended to be implemented as a pair.

Reviewed-by: Chao Gao <chao.gao@intel.com>
Reviewed-by: Kai Huang <kai.huang@intel.com>
Acked-by: Kai Huang <kai.huang@intel.com>
Tested-by: Farrah Chen <farrah.chen@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 include/linux/kvm_host.h | 14 ++++++++++++++
 virt/kvm/kvm_main.c      | 14 ++++++++++++++
 2 files changed, 28 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 63e46a5f3812..50ace701d468 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1514,6 +1514,20 @@ static inline void kvm_create_vcpu_debugfs(struct kvm_vcpu *vcpu) {}
 #endif
 
 #ifdef CONFIG_KVM_GENERIC_HARDWARE_ENABLING
+/*
+ * kvm_arch_{enable,disable}_virtualization() are called on one CPU, under
+ * kvm_usage_lock, immediately after/before 0=>1 and 1=>0 transitions of
+ * kvm_usage_count, i.e. at the beginning of the generic hardware enabling
+ * sequence, and at the end of the generic hardware disabling sequence.
+ */
+void kvm_arch_enable_virtualization(void);
+void kvm_arch_disable_virtualization(void);
+/*
+ * kvm_arch_{enable,disable}_virtualization_cpu() are called on "every" CPU to
+ * do the actual twiddling of hardware bits.  The hooks are called on all
+ * online CPUs when KVM enables/disabled virtualization, and on a single CPU
+ * when that CPU is onlined/offlined (including for Resume/Suspend).
+ */
 int kvm_arch_enable_virtualization_cpu(void);
 void kvm_arch_disable_virtualization_cpu(void);
 #endif
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 55779fbb37ec..9ae4bd8a3712 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5582,6 +5582,16 @@ static DEFINE_PER_CPU(bool, virtualization_enabled);
 static DEFINE_MUTEX(kvm_usage_lock);
 static int kvm_usage_count;
 
+__weak void kvm_arch_enable_virtualization(void)
+{
+
+}
+
+__weak void kvm_arch_disable_virtualization(void)
+{
+
+}
+
 static int kvm_enable_virtualization_cpu(void)
 {
 	if (__this_cpu_read(virtualization_enabled))
@@ -5681,6 +5691,8 @@ static int kvm_enable_virtualization(void)
 	if (kvm_usage_count++)
 		return 0;
 
+	kvm_arch_enable_virtualization();
+
 	r = cpuhp_setup_state(CPUHP_AP_KVM_ONLINE, "kvm/cpu:online",
 			      kvm_online_cpu, kvm_offline_cpu);
 	if (r)
@@ -5711,6 +5723,7 @@ static int kvm_enable_virtualization(void)
 	unregister_syscore_ops(&kvm_syscore_ops);
 	cpuhp_remove_state(CPUHP_AP_KVM_ONLINE);
 err_cpuhp:
+	kvm_arch_disable_virtualization();
 	--kvm_usage_count;
 	return r;
 }
@@ -5724,6 +5737,7 @@ static void kvm_disable_virtualization(void)
 
 	unregister_syscore_ops(&kvm_syscore_ops);
 	cpuhp_remove_state(CPUHP_AP_KVM_ONLINE);
+	kvm_arch_disable_virtualization();
 }
 
 static int kvm_init_virtualization(void)
-- 
2.46.0.469.g59c65b2a67-goog

