Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 053253043B0
	for <kvmarm@lists.linux.dev>; Sat,  6 Dec 2025 00:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764980327; cv=none; b=sMu5g1Q651uAQnx0InMUqOKWkjEZCdqEndDwJI7aBi5JXk5fcIQjMRauHtsoFRT6Pwnjg/DCRfHKOxOn/CGdJqeAqFroP3S/Uy89ANcrBFQtcL0AMemXvRkA+sd6Vk0oQG1LQMYK23Mer5s7GhuaS0A6szIVpq0nATjK1Xt6mEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764980327; c=relaxed/simple;
	bh=NbkrBG3duMpaol6d8oG4nabrvUXIXCsgan8nKAy9HYc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TelNb3R2x3e61h5VdKqb1ZOTB70sfAnGb69MhvQbX0p+pzpqdYiTQmlbXcC237+/N1c7MBjWyfmcsV/rv+6kqtHGRBACfBh8sajhFuGhsUfOFujhDT96lrN+05GxS7pWZ03jHaIejYlAzsbF5Qkw9hX75Ke3LIgRfaTw+LcqWgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rltOOPq9; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rltOOPq9"
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7c240728e2aso4693165b3a.3
        for <kvmarm@lists.linux.dev>; Fri, 05 Dec 2025 16:18:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764980324; x=1765585124; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=0alQNA5MnRougM8104k8mY12SAXvJNUdA/VqOuM31LI=;
        b=rltOOPq9AWNuFVjK9h9yXqGtHbKxhoVU27NuE3NYHdsLRJksdA7OdKqdLvwvFXnP8Q
         jb8D+hMXwGDWmDv+qu6PME70uOKFcbfzr30gMbFeHnhBFB0TdAXVe9kNCYAuV3yffIje
         xP2ZMTiEpRr4ClYX9JFwIG5yKZAVHZmm/uq436YpfW7NC/6G+FUPVutk31qWKu6lPqZW
         GTKkgieX8ShEYbBNOnwhpDNBoN3W8JOU2sSznLzZpB524Ij+wvYU2IbsS9aWiqFnQIhF
         s45zKob55c5fz1r1Q98QD+b8m4kfBtPFPh/qPfraARUevpQqu3D2kHJA57MJBAxvS299
         tj1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764980324; x=1765585124;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0alQNA5MnRougM8104k8mY12SAXvJNUdA/VqOuM31LI=;
        b=XVKHI/ua00YaMjvoQSG+wl9XAfr2Wle8rdPCJWDB6Df9tOGlKOJZZ6RkkgDM8tVf6E
         5fD50Swd9bWXakcSgTIgvQQZY123yjAjjV2WowXdzguJu3t7ha8MYQV7c0Z3Cq2Co+G7
         7wKylYqPnAypqjfGfd5EoHWkLzTmCKSQnkBCGCJJ+aRknh3MtaP1DxyWcl8c2qI66ICk
         ZF3YS1Xl1SwJ0eG+rLAxeCGOSM7YrwW0smXtVEr+F9CTm0rKr+YyevuDeCTRT910YLwa
         c0YUoU3LJo3FU3+eXnbd+1tSkxft/iRAg0cK4eOLn6La+t6MQor5IVYU0ydw+85Ivssw
         ETKA==
X-Forwarded-Encrypted: i=1; AJvYcCW3c+vslctFRsPvOvpyipEs2/zpDD39V6NuQYbhP0u0/AGN/9f7xNCqciDGQHTNM63vaJC9XzI=@lists.linux.dev
X-Gm-Message-State: AOJu0YzbstXD7LPp7h+9GwFVK0qSgEqKf1uaRuq1bZ2KFo9hK3Z8KqtP
	qNtCUkACJbpp3RgdmjYj3zxl3/Sfslw0cKAeKNTuZ8WP9hknL6I1oQfBNbrlpBtyzJj+dmnGv/t
	TvprlVg==
X-Google-Smtp-Source: AGHT+IE9VOcwrfHydwxf79golQ2o2etTa7qJp+DbC2tY99Fupcp+X66ru5yHSbM1504AJSJDzZlYcA1+Jcw=
X-Received: from pgdc11.prod.google.com ([2002:a05:6a02:510b:b0:bd9:6028:d18c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:4ed2:10b0:361:4ca3:e17d
 with SMTP id adf61e73a8af0-36617e37b3fmr739726637.13.1764980324070; Fri, 05
 Dec 2025 16:18:44 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  5 Dec 2025 16:17:14 -0800
In-Reply-To: <20251206001720.468579-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251206001720.468579-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <20251206001720.468579-39-seanjc@google.com>
Subject: [PATCH v6 38/44] KVM: VMX: Drop unused @entry_only param from add_atomic_switch_msr()
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Xin Li <xin@zytor.com>, "H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, Mingwei Zhang <mizhang@google.com>, 
	Xudong Hao <xudong.hao@intel.com>, Sandipan Das <sandipan.das@amd.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>, Xiong Zhang <xiong.y.zhang@linux.intel.com>, 
	Manali Shukla <manali.shukla@amd.com>, Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

Drop the "on VM-Enter only" parameter from add_atomic_switch_msr() as it
is no longer used, and for all intents and purposes was never used.  The
functionality was added, under embargo, by commit 989e3992d2ec
("x86/KVM/VMX: Extend add_atomic_switch_msr() to allow VMENTER only MSRs"),
and then ripped out by commit 2f055947ae5e ("x86/kvm: Drop L1TF MSR list
approach") just a few commits later.

  2f055947ae5e x86/kvm: Drop L1TF MSR list approach
  72c6d2db64fa x86/litf: Introduce vmx status variable
  215af5499d9e cpu/hotplug: Online siblings when SMT control is turned on
  390d975e0c4e x86/KVM/VMX: Use MSR save list for IA32_FLUSH_CMD if required
  989e3992d2ec x86/KVM/VMX: Extend add_atomic_switch_msr() to allow VMENTER only MSRs

Furthermore, it's extremely unlikely KVM will ever _need_ to load an MSR
value via the auto-load lists only on VM-Enter.  MSRs writes via the lists
aren't optimized in any way, and so the only reason to use the lists
instead of a WRMSR are for cases where the MSR _must_ be load atomically
with respect to VM-Enter (and/or VM-Exit).  While one could argue that
command MSRs, e.g. IA32_FLUSH_CMD, "need" to be done exact at VM-Enter, in
practice doing such flushes within a few instructons of VM-Enter is more
than sufficient.

Note, the shortlog and changelog for commit 390d975e0c4e ("x86/KVM/VMX: Use
MSR save list for IA32_FLUSH_CMD if required") are misleading and wrong.
That commit added MSR_IA32_FLUSH_CMD to the VM-Enter _load_ list, not the
VM-Enter save list (which doesn't exist, only VM-Exit has a store/save
list).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index a51f66d1b201..38491962b2c1 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1094,7 +1094,7 @@ static __always_inline void add_atomic_switch_msr_special(struct vcpu_vmx *vmx,
 }
 
 static void add_atomic_switch_msr(struct vcpu_vmx *vmx, unsigned msr,
-				  u64 guest_val, u64 host_val, bool entry_only)
+				  u64 guest_val, u64 host_val)
 {
 	int i, j = 0;
 	struct msr_autoload *m = &vmx->msr_autoload;
@@ -1132,8 +1132,7 @@ static void add_atomic_switch_msr(struct vcpu_vmx *vmx, unsigned msr,
 	}
 
 	i = vmx_find_loadstore_msr_slot(&m->guest, msr);
-	if (!entry_only)
-		j = vmx_find_loadstore_msr_slot(&m->host, msr);
+	j = vmx_find_loadstore_msr_slot(&m->host, msr);
 
 	if ((i < 0 && m->guest.nr == MAX_NR_LOADSTORE_MSRS) ||
 	    (j < 0 &&  m->host.nr == MAX_NR_LOADSTORE_MSRS)) {
@@ -1148,9 +1147,6 @@ static void add_atomic_switch_msr(struct vcpu_vmx *vmx, unsigned msr,
 	m->guest.val[i].index = msr;
 	m->guest.val[i].value = guest_val;
 
-	if (entry_only)
-		return;
-
 	if (j < 0) {
 		j = m->host.nr++;
 		vmcs_write32(VM_EXIT_MSR_LOAD_COUNT, m->host.nr);
@@ -1190,8 +1186,7 @@ static bool update_transition_efer(struct vcpu_vmx *vmx)
 		if (!(guest_efer & EFER_LMA))
 			guest_efer &= ~EFER_LME;
 		if (guest_efer != kvm_host.efer)
-			add_atomic_switch_msr(vmx, MSR_EFER,
-					      guest_efer, kvm_host.efer, false);
+			add_atomic_switch_msr(vmx, MSR_EFER, guest_efer, kvm_host.efer);
 		else
 			clear_atomic_switch_msr(vmx, MSR_EFER);
 		return false;
@@ -7350,7 +7345,7 @@ static void atomic_switch_perf_msrs(struct vcpu_vmx *vmx)
 			clear_atomic_switch_msr(vmx, msrs[i].msr);
 		else
 			add_atomic_switch_msr(vmx, msrs[i].msr, msrs[i].guest,
-					msrs[i].host, false);
+					      msrs[i].host);
 }
 
 static void vmx_update_hv_timer(struct kvm_vcpu *vcpu, bool force_immediate_exit)
-- 
2.52.0.223.gf5cc29aaa4-goog

