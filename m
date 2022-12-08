Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ED057E
	for <kvmarm@lists.linux.dev>; Thu,  8 Dec 2022 00:18:11 +0000 (UTC)
Received: by mail-pj1-f49.google.com with SMTP id fa4-20020a17090af0c400b002198d1328a0so4857852pjb.0
        for <kvmarm@lists.linux.dev>; Wed, 07 Dec 2022 16:18:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Do/Fb4RXRaxpoUe/20L4z3mrChb2/QmWaVwWrgAuquw=;
        b=n1bUs4Agkz6KF6RZdHKB5skrzZ92+pJenXEV9Kr8UrmBzPVi8IztmvxkNk+3Cf3Wkd
         ZMXL2qFkVdxhKt3YQT2BIUXSMbtkIibDICSp2vjJRRWG+d/RyGenYr4lFEm/F2PoCTZK
         2Dc9t53lbS5YsQkYlM6s92iETFmZX+V1/KkST/vzxRsTLSX1sAyfr+UM7rIE4DpbUzge
         DA63QqtGOKZd+tHCtOkISvSXCkUy5vMKjbnVNnOFpVhEO/7MVeykfrOj0GMQYqMM0KTj
         f31N88nUIpq3z4qXw6AkOXnf6AeAATOoYClGBQT21SgRgtPmcOCTVzJI4EJvv0AR0n8/
         ldqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Do/Fb4RXRaxpoUe/20L4z3mrChb2/QmWaVwWrgAuquw=;
        b=eH+skUU+ldNirW/Rh9KvQJ+Opip2NJN4KqduaEVAK+z1qXIatOK7P1gH7IMKLtPHgp
         JZ5FJJgc4fUBm30UOVkvF1W5m+Bf+ZRXikv5mtV8zcrQgEheoJRRcYY6tCA0AIw53kJm
         KET0rpNDW0uj0vsktAb2JU+MkibHj126wjdhey9Xs4CAr3GsFmRRGiiOx6kpFY0/C/ZD
         Jco7QSKdzifEQZ7Wd3OEgVRlPOJuHHzDyWl7msuU4/VHRNjMey1W15Phgx7Q5ToCnVOG
         FAOfjNBg7Rg4m+7mdveb+cB/tnviWyd/KpzKxnklRLeMKkbIzoy76dnJ7Ez9JNvFZAwz
         bMGg==
X-Gm-Message-State: ANoB5plIovaJgLwBDbbrLTgRp6fxce/03N9Bzg/6O8jLWoTncxiKHYEm
	Pt22PbvzwitInt96NmHbi/1zJw==
X-Google-Smtp-Source: AA0mqf4eo6zlPiZ4jUKwuO3uBpbbjvUkZki3Zx5Ncf0CCnw1E0xp60S868ANYGdyrzz24zWBVBpBiA==
X-Received: by 2002:a05:6a20:e60e:b0:9d:b8e6:d8e5 with SMTP id my14-20020a056a20e60e00b0009db8e6d8e5mr1557362pzb.2.1670458690934;
        Wed, 07 Dec 2022 16:18:10 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id l12-20020a170902e2cc00b00176a6ba5969sm9370997plc.98.2022.12.07.16.18.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 16:18:10 -0800 (PST)
Date: Thu, 8 Dec 2022 00:18:07 +0000
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
	kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	Ricardo Koller <ricarkol@google.com>,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] KVM: arm64: selftests: Align VA space allocator with
 TTBR0
Message-ID: <Y5EtP5z6rxSK1VUe@google.com>
References: <20221207214809.489070-1-oliver.upton@linux.dev>
 <20221207214809.489070-4-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221207214809.489070-4-oliver.upton@linux.dev>
Message-ID: <20221208001807.etIktGX4Qx4b230NS4X3lv2FBHrjPYqU-MaUgsZuDyQ@z>

On Wed, Dec 07, 2022, Oliver Upton wrote:
> diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> index 316de70db91d..5972a23b2765 100644
> --- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> @@ -541,3 +541,13 @@ void kvm_selftest_arch_init(void)
>  	 */
>  	guest_modes_append_default();
>  }
> +
> +void vm_vaddr_populate_bitmap(struct kvm_vm *vm)

Add "arch" so that it's obvious this can be overidden?  The "__weak" conveys that
for the implementation, but not for the call site.  E.g. vm_arch_vaddr_populate_bitmap().

Actually, IIUC, the issue is that the high half isn't mapped (probably the wrong
terminology).  I.e. the calculation for the low half stays the same, and the high
half just goes away.

> +{
> +	/*
> +	 * arm64 selftests use only TTBR0_EL1, meaning that the valid VA space
> +	 * is [0, 2^(64 - TCR_EL1.T0SZ)).
> +	 */
> +	sparsebit_set_num(vm->vpages_valid, 0,
> +			  (1ULL << vm->va_bits) >> vm->page_shift);
> +}
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index e9607eb089be..c88c3ace16d2 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -186,6 +186,15 @@ const struct vm_guest_mode_params vm_guest_mode_params[] = {
>  _Static_assert(sizeof(vm_guest_mode_params)/sizeof(struct vm_guest_mode_params) == NUM_VM_MODES,
>  	       "Missing new mode params?");
>  
> +__weak void vm_vaddr_populate_bitmap(struct kvm_vm *vm)
> +{
> +	sparsebit_set_num(vm->vpages_valid,
> +		0, (1ULL << (vm->va_bits - 1)) >> vm->page_shift);
> +	sparsebit_set_num(vm->vpages_valid,
> +		(~((1ULL << (vm->va_bits - 1)) - 1)) >> vm->page_shift,
> +		(1ULL << (vm->va_bits - 1)) >> vm->page_shift);

Any objection to fixing up the formatting?  Actually, we can do more than just
fix the indentation, e.g. the number of bits is identical, and documenting that
this does a high/low split would be helpful.

Together, what about?  The #ifdef is a bit gross, especially around "hi_start",
but it's less duplicate code.  And IMO, having things bundled in the same place
makes it a lot easier for newbies (to arm64 or kernel coding in general) to
understand what's going on and why arm64 is different.

---
 tools/testing/selftests/kvm/lib/kvm_util.c | 23 +++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index e9607eb089be..d6f2c17e3d40 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -186,6 +186,23 @@ const struct vm_guest_mode_params vm_guest_mode_params[] = {
 _Static_assert(sizeof(vm_guest_mode_params)/sizeof(struct vm_guest_mode_params) == NUM_VM_MODES,
 	       "Missing new mode params?");
 
+static void vm_vaddr_populate_bitmap(struct kvm_vm *vm)
+{
+	/*
+	 * All architectures supports splitting the virtual address space into
+	 * a high and a low half.  Populate both halves, except for arm64 which
+	 * currently uses only TTBR0_EL1 (arbitrary selftests "logic"), i.e.
+	 * only has a valid low half.
+	 */
+	sparsebit_num_t nr_va_bits = (1ULL << (vm->va_bits - 1)) >> vm->page_shift;
+#ifndef __aarch64__
+	sparsebit_num_t hi_start = (~((1ULL << (vm->va_bits - 1)) - 1)) >> vm->page_shift
+
+	sparsebit_set_num(vm->vpages_valid, hi_start, nr_bits);
+#endif
+	sparsebit_set_num(vm->vpages_valid, 0, nr_va_bits);
+}
+
 struct kvm_vm *____vm_create(enum vm_guest_mode mode)
 {
 	struct kvm_vm *vm;
@@ -274,11 +291,7 @@ struct kvm_vm *____vm_create(enum vm_guest_mode mode)
 
 	/* Limit to VA-bit canonical virtual addresses. */
 	vm->vpages_valid = sparsebit_alloc();
-	sparsebit_set_num(vm->vpages_valid,
-		0, (1ULL << (vm->va_bits - 1)) >> vm->page_shift);
-	sparsebit_set_num(vm->vpages_valid,
-		(~((1ULL << (vm->va_bits - 1)) - 1)) >> vm->page_shift,
-		(1ULL << (vm->va_bits - 1)) >> vm->page_shift);
+	vm_vaddr_populate_bitmap(vm);
 
 	/* Limit physical addresses to PA-bits. */
 	vm->max_gfn = vm_compute_max_gfn(vm);

base-commit: 35aecc3289eebf193fd70a067ea448ae2f0bb9b9
-- 

