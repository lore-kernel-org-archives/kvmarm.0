Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B45D6286408
	for <kvmarm@lists.linux.dev>; Sat,  6 Dec 2025 00:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764980281; cv=none; b=DrRLRsevBXO8Yy1jISM6BX3eCemJmtEkwVQ3yrmbO0yB4zVrns2MRY0W5J3NL1C5vybwTw/TZW2CtG1dSWrrWd4tP3fPNnbdueGD1Sq6E5FpuSefSSEcfsIb9Qw78LilYkqVfwNEK4N62om1kihXn5s0riLg50moqN5mQ4yOX7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764980281; c=relaxed/simple;
	bh=NxcTFxjepVUBhgcuDgXP9erFCogdZe/UYTYZVp4ITjU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=n2ybCqsdwagkt9NcfxsNHeuE7R+doAbURungcq0CiuSJpKfmFxOP3Lkk7a0rApRNDWQaN67nn8a/qmjLEI0BJgIZP+5fTO0RBNe1cNZNdwYBn3zsxr+OFyKMQPAj9IXpRnGyaLKqCOa4qu1hZ5aMrWUjr9GkKe/bw+YwmrgqppQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Qkt1/wxs; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Qkt1/wxs"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-340c0604e3dso3051816a91.2
        for <kvmarm@lists.linux.dev>; Fri, 05 Dec 2025 16:17:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764980278; x=1765585078; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=EJZjDSfKK1pwnMTXc65KmoRQXFDI8yuuzalHKLt+oxI=;
        b=Qkt1/wxs7kQjFSlHZ0MIl8h9Eah+cjLMLsTsWFtKVelmdCjWErmNECnKh5Gp0bHi5b
         /OgJFzhi4iH+dkfWW2VHzqliqeQuJqEQKl2XfxtcRkUpmtgPXxkUEM6q5qx+7uSjkP8a
         qdjYB+WYpmqwFUSyZUkwg2S99WXD6IHWMgSg1BqP57xvzxTthbvLXEVJPEaAfnB9L7vL
         EJ0DEqiwTmw+j0VIVjPXdqiuI4+hbUhDiGfBYGsoU5nItuWDv8g8WAaAs8he/h9hjqn+
         zaWsfYIGMbtDi4DRred9hOsXXQY7nc8ic5xEnlzxuyNAP+2bYgDyUCu5itua8kwPxgYk
         HR6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764980278; x=1765585078;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EJZjDSfKK1pwnMTXc65KmoRQXFDI8yuuzalHKLt+oxI=;
        b=UnahFLZJ/2iH1KoWvNGltr0AB+L1iPAvbxKixClGfvmK1q9bWX/YYAU367zUsU7bBR
         XMVGyDGlOudEWyb54UwCGTfm8o0q1YxAJLgFu+Z0cjn4HdHoGkkOfzx78ytSA7vZaqAW
         5+p5O8HLrw0ctlfZZ9w6MBuEcjAAweYy6bFg5GulharTxXv9E7zMvvZzKP9D5qLEt2l1
         tNhsrHPccQE8hx392qFENfw/iBHgnq47/1gn1CDOm5j9DvTu97Vsf2pTrhRokeCkQVJ1
         qzP+RTny+6SNK3al+43NoZrrNnYCmzmEYQOid0v1wpe56eKUhjWMB2DRqyEShtU6B/0a
         aypQ==
X-Forwarded-Encrypted: i=1; AJvYcCVZnHv9MeeaDOoK2hl+rRfyqDZQI8/72RxxLS3y9J2JWmeIbpGuqLjuCWZFU6OgZZqUhD8qDCI=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz1Y5fSgK4Aia28PMvJjD6g6Wl7XUeyg2muSXbqm41FavyT38v/
	OUAqLuPg4+4n30K+QRR3x0gkmsqG0kDeXw8edSeZJH5ZNJhaStrpHGXjv4QzP5TAbJ2A9OQBPRk
	0HJZEKg==
X-Google-Smtp-Source: AGHT+IFzyDODAGNW9A6GgT1Jbq067tl3uqRceo8na5LL790lP+X/PbzaZlwBYP1SXTWzOmiFVcopZu238bM=
X-Received: from pjis4.prod.google.com ([2002:a17:90a:5d04:b0:340:b1b5:eb5e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3ecd:b0:340:f05a:3ec2
 with SMTP id 98e67ed59e1d1-349a25fb8c0mr656453a91.17.1764980278079; Fri, 05
 Dec 2025 16:17:58 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  5 Dec 2025 16:16:52 -0800
In-Reply-To: <20251206001720.468579-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251206001720.468579-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <20251206001720.468579-17-seanjc@google.com>
Subject: [PATCH v6 16/44] KVM: x86/pmu: Start stubbing in mediated PMU support
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

From: Dapeng Mi <dapeng1.mi@linux.intel.com>

Introduce enable_mediated_pmu as a global variable, with the intent of
exposing it to userspace a vendor module parameter, to control and reflect
mediated vPMU support.  Wire up the perf plumbing to create+release a
mediated PMU, but defer exposing the parameter to userspace until KVM
support for a mediated PMUs is fully landed.

To (a) minimize compatibility issues, (b) to give userspace a chance to
opt out of the restrictive side-effects of perf_create_mediated_pmu(),
and (c) to avoid adding new dependencies between enabling an in-kernel
irqchip and a mediated vPMU, defer "creating" a mediated PMU in perf
until the first vCPU is created.

Regarding userspace compatibility, an alternative solution would be to
make the mediated PMU fully opt-in, e.g. to avoid unexpected failure due
to perf_create_mediated_pmu() failing.  Ironically, that approach creates
an even bigger compatibility issue, as turning on enable_mediated_pmu
would silently break VMMs that don't utilize KVM_CAP_PMU_CAPABILITY (well,
silently until the guest tried to access PMU assets).

Regarding an in-kernel irqchip, create a mediated PMU if and only if the
VM has an in-kernel local APIC, as the mediated PMU will take a hard
dependency on forwarding PMIs to the guest without bouncing through host
userspace.  Silently "drop" the PMU instead of rejecting KVM_CREATE_VCPU,
as KVM's existing vPMU support doesn't function correctly if the local
APIC is emulated by userspace, e.g. PMIs will never be delivered.  I.e.
it's far, far more likely that rejecting KVM_CREATE_VCPU would cause
problems, e.g. for tests or userspace daemons that just want to probe
basic KVM functionality.

Note!  Deliberately make mediated PMU creation "sticky", i.e. don't unwind
it on failure to create a vCPU.  Practically speaking, there's no harm to
having a VM with a mediated PMU and no vCPUs.  To avoid an "impossible" VM
setup, reject KVM_CAP_PMU_CAPABILITY if a mediated PMU has been created,
i.e. don't let userspace disable PMU support after failed vCPU creation
(with PMU support enabled).

Defer vendor specific requirements and constraints to the future.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Co-developed-by: Mingwei Zhang <mizhang@google.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
Tested-by: Xudong Hao <xudong.hao@intel.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/pmu.c              |  4 ++++
 arch/x86/kvm/pmu.h              |  7 +++++++
 arch/x86/kvm/x86.c              | 37 +++++++++++++++++++++++++++++++--
 arch/x86/kvm/x86.h              |  1 +
 5 files changed, 48 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 5a3bfa293e8b..defd979003be 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1484,6 +1484,7 @@ struct kvm_arch {
 
 	bool bus_lock_detection_enabled;
 	bool enable_pmu;
+	bool created_mediated_pmu;
 
 	u32 notify_window;
 	u32 notify_vmexit_flags;
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 7c219305b61d..0de0af5c6e4f 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -137,6 +137,10 @@ void kvm_init_pmu_capability(const struct kvm_pmu_ops *pmu_ops)
 			enable_pmu = false;
 	}
 
+	if (!enable_pmu || !enable_mediated_pmu || !kvm_host_pmu.mediated ||
+	    !pmu_ops->is_mediated_pmu_supported(&kvm_host_pmu))
+		enable_mediated_pmu = false;
+
 	if (!enable_pmu) {
 		memset(&kvm_pmu_cap, 0, sizeof(kvm_pmu_cap));
 		return;
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 5c3939e91f1d..a5c7c026b919 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -37,6 +37,8 @@ struct kvm_pmu_ops {
 	void (*deliver_pmi)(struct kvm_vcpu *vcpu);
 	void (*cleanup)(struct kvm_vcpu *vcpu);
 
+	bool (*is_mediated_pmu_supported)(struct x86_pmu_capability *host_pmu);
+
 	const u64 EVENTSEL_EVENT;
 	const int MAX_NR_GP_COUNTERS;
 	const int MIN_NR_GP_COUNTERS;
@@ -58,6 +60,11 @@ static inline bool kvm_pmu_has_perf_global_ctrl(struct kvm_pmu *pmu)
 	return pmu->version > 1;
 }
 
+static inline bool kvm_vcpu_has_mediated_pmu(struct kvm_vcpu *vcpu)
+{
+	return enable_mediated_pmu && vcpu_to_pmu(vcpu)->version;
+}
+
 /*
  * KVM tracks all counters in 64-bit bitmaps, with general purpose counters
  * mapped to bits 31:0 and fixed counters mapped to 63:32, e.g. fixed counter 0
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1b2827cecf38..fb3a5e861553 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -183,6 +183,10 @@ bool __read_mostly enable_pmu = true;
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(enable_pmu);
 module_param(enable_pmu, bool, 0444);
 
+/* Enable/disabled mediated PMU virtualization. */
+bool __read_mostly enable_mediated_pmu;
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(enable_mediated_pmu);
+
 bool __read_mostly eager_page_split = true;
 module_param(eager_page_split, bool, 0644);
 
@@ -6854,7 +6858,7 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 			break;
 
 		mutex_lock(&kvm->lock);
-		if (!kvm->created_vcpus) {
+		if (!kvm->created_vcpus && !kvm->arch.created_mediated_pmu) {
 			kvm->arch.enable_pmu = !(cap->args[0] & KVM_PMU_CAP_DISABLE);
 			r = 0;
 		}
@@ -12641,8 +12645,13 @@ static int sync_regs(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+#define PERF_MEDIATED_PMU_MSG \
+	"Failed to enable mediated vPMU, try disabling system wide perf events and nmi_watchdog.\n"
+
 int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
 {
+	int r;
+
 	if (kvm_check_tsc_unstable() && kvm->created_vcpus)
 		pr_warn_once("SMP vm created on host with unstable TSC; "
 			     "guest TSC will not be reliable\n");
@@ -12653,7 +12662,29 @@ int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
 	if (id >= kvm->arch.max_vcpu_ids)
 		return -EINVAL;
 
-	return kvm_x86_call(vcpu_precreate)(kvm);
+	/*
+	 * Note, any actions done by .vcpu_create() must be idempotent with
+	 * respect to creating multiple vCPUs, and therefore are not undone if
+	 * creating a vCPU fails (including failure during pre-create).
+	 */
+	r = kvm_x86_call(vcpu_precreate)(kvm);
+	if (r)
+		return r;
+
+	if (enable_mediated_pmu && kvm->arch.enable_pmu &&
+	    !kvm->arch.created_mediated_pmu) {
+		if (irqchip_in_kernel(kvm)) {
+			r = perf_create_mediated_pmu();
+			if (r) {
+				pr_warn_ratelimited(PERF_MEDIATED_PMU_MSG);
+				return r;
+			}
+			kvm->arch.created_mediated_pmu = true;
+		} else {
+			kvm->arch.enable_pmu = false;
+		}
+	}
+	return 0;
 }
 
 int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
@@ -13319,6 +13350,8 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 		__x86_set_memory_region(kvm, TSS_PRIVATE_MEMSLOT, 0, 0);
 		mutex_unlock(&kvm->slots_lock);
 	}
+	if (kvm->arch.created_mediated_pmu)
+		perf_release_mediated_pmu();
 	kvm_destroy_vcpus(kvm);
 	kvm_free_msr_filter(srcu_dereference_check(kvm->arch.msr_filter, &kvm->srcu, 1));
 #ifdef CONFIG_KVM_IOAPIC
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index fdab0ad49098..6e1fb1680c0a 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -470,6 +470,7 @@ extern struct kvm_caps kvm_caps;
 extern struct kvm_host_values kvm_host;
 
 extern bool enable_pmu;
+extern bool enable_mediated_pmu;
 
 /*
  * Get a filtered version of KVM's supported XCR0 that strips out dynamic
-- 
2.52.0.223.gf5cc29aaa4-goog

