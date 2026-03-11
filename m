Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBFAA3B6340
	for <kvmarm@lists.linux.dev>; Wed, 11 Mar 2026 10:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773224068; cv=pass; b=C5b6tx8KkOMe9J6qllKM4XrUONbRLat9/Xo1kdpPKAnp2ldGYhZb864pUDoL/ViowPopQ+lq8Qk2fKHqhB9ZKXZJkjGgFInGK7OE1PZfPERal5dINxMAmkVWHJ3CXUOe9PF1rE8dkBJxB7BcdP1d6mqaoJUw+01r1dpOnr3MujU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773224068; c=relaxed/simple;
	bh=Tf+TEAcCigm0U/4W+bgn9sPQByO6ra0E5peNwDeSDuo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZuhSFf8kf62egG3+9rFoRIquJKn+BqP75XKOSMd1LztQvLox7VyfjCOgkoghe91uBxlKtmZ/OkE3ieQwNhJXrY6CgKL+EFSlg7rHdjbzl7PKh25Af0P6pD8X9ZpMqeojCvxa4b8eSiytHQeZg9K5j1aXi//LPAmGEapX/YfyuTU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ubBQqkvj; arc=pass smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ubBQqkvj"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-509062d829dso409731cf.1
        for <kvmarm@lists.linux.dev>; Wed, 11 Mar 2026 03:14:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773224064; cv=none;
        d=google.com; s=arc-20240605;
        b=gHdA0IcRpaZn2Y6qeeeiassqL1h0QzlHA9Y799rcr1HaKnKk0b5NbR/MWsMP4VIq88
         tc5zd0hQMg1r3anVrszeNzZXD092zVcqhg20ulfy84Sbl6WZZkhDswmd3XYqCqkqe1bA
         IyB48jXRpzgx/JHPJPAenKOU5KydAkE4/ZQctzDVGt3kbjYfI4lh6efzZsv5l52STTqE
         1DInYyXLPssA7/1vfaGFTNrs77uFlHdRxT4NxOEhx4cNWyuxRG49VmNevQCwosEZri/q
         LfufNnFmSnajj+ToYjnt1Dqxc2MRmcgqo8ZrTtie6rEEzDQFL6UgPpcQtrX6oPgMjW6u
         Cfnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=lfLV59o4o1tglwLSOeFGWvFMCd8yTLZw+74FUNPihEs=;
        fh=Jxzwzg3laewSUvCA2a09gOOd6H1o1mMdzeS5XgaaAVk=;
        b=EkDbRmwWPylLOIRc+GSVum5yCWx5IIvRtRPD0x07LkI1Vrk7Vg8WJpOFnonoEsI1zm
         j26E+q39VAEJFmtZFl9M2zEdGOxU6g2xG+J3ifyKg0ZRE4CFHTewJQqPZ9Dpke/VvY9s
         bStLZ2fDfm5y7DnXnDEtdzpCq1Uk+3C8ZotI76nYjryMTBqEXnR2/zaWLc1ohX8sZdi3
         DcfjBqY6yWxpgeQPXEngzAftM6PxLeGM4Ax515QMZVhdBA/PzvISH4NqO5bEhYzNhcan
         /E5V8raQKsYKBKRAPAi7egP0BAF9LIeqyuaHzbc1+lWtPwzXuRn5o1HeeI6iwn69GKCj
         3/Lg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773224064; x=1773828864; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=lfLV59o4o1tglwLSOeFGWvFMCd8yTLZw+74FUNPihEs=;
        b=ubBQqkvjp2UOgtBU9yTebvHnuZbHTd2ZLwltAKWSh1mZhcGz69nVF8//vbmmikVxHt
         ofH/KfLjSPqItSCifPKhSjNNp/ymZn6r11M89I4rooYVPV+QQswsEhqPHYcVIgBcId50
         54deeHWTPsBqGA+PhrtRL6GCqiSalAOW8OpDvNkXuuhN8taUGpB1kyzPlo4AveVsHS1C
         +ecYgnlA9mLzw6KN3ueeJYHmTusgH7klyRPQNZHNDhjG5fa1st0XZP5nSKQzQZg2CfIW
         0Np0GB7FbAcbCxyzE5rRLZG3pVcJbIZsBw1Q1dnEeQy5OWWJ7iQKGIvIRI9Rrmmpwu8C
         PiXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773224064; x=1773828864;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lfLV59o4o1tglwLSOeFGWvFMCd8yTLZw+74FUNPihEs=;
        b=n58Vfm0XLNJoFKBDIqglx8ufFKPBRadm9vbUFA9L2fcm248NYUmFw0WlM9Ww4+cRyX
         LUg9bTPshJz/MW/PpF2Me7GmBWdbG0yCiCNdeQKPgp5b0UtIt0bTCvyHxS+thdv5vjMC
         Zqyigb8q6q3tbJrC58799SSzMJ1+Cij/iMw5u0dyhal1qivt2EfTQScR2j2keOTCBjO0
         pzoUyXj+XiFfjoUY8vve+KgTaIej/V+Q54BGPshlcQxtRiLBVUGz1QKpbwHEGP03Q9tR
         NLPQDJow2VGM804/MWSYk/Z7xGO7m6vvM2AA+xISWrdlQVSotIdZYsD0RNhd9YqoU6D0
         owIA==
X-Gm-Message-State: AOJu0Yyc595I/46UBqwSDJXo4LdLqxsZxrQwsO+RSY5Di1EBSQ17fa3L
	DpALiqYJJ00r6UMq6eaHAuqv2bs77TeUAEoyv5uybwe0CYz9FkkYkc9yzZQPYq30C3SgCro9355
	K/4/bGjzo+C1/OQ6h383pvT9yDogETl9XTnjqrBnZ
X-Gm-Gg: ATEYQzz4qM8J7pEJiqW+76FtB5nQWPKOMVcRcetRlD2X4XAppZ2QEPpI2hOP+EwqHSA
	TGaECr6tmJfIqkLJabSBbIVTYhGIPbrJdy21+pyhezl481s70qA+R82X9dC2jrEaVK3lC30QF47
	d4j0haaqOeATMAQac8hiQPiMuNyGufYbOAxGdao0Bq3ykAkt46vyis5x3vunuWuF3h5FS06yEaM
	uff9+VCB3FJso4RFVc/tHmTAeK2L9/SoYvFPDwu0ApiS+d/ce9VDYiO45j89w44FXYugT5zGGdy
	4dhCrcdcD0CeyqscHo2PtgyAkcSCv0VsVarc/Y0JRScZ5VEN
X-Received: by 2002:ac8:7c53:0:b0:503:4bc:c925 with SMTP id
 d75a77b69052e-50939a5cc4bmr8975271cf.13.1773224063283; Wed, 11 Mar 2026
 03:14:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260305144351.17071-1-will@kernel.org> <20260305144351.17071-19-will@kernel.org>
In-Reply-To: <20260305144351.17071-19-will@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 11 Mar 2026 10:13:46 +0000
X-Gm-Features: AaiRm52JOrlHxk-wEWSReaveEiUCp-2PTv-VngEIYEq9CUZ8OT8VXU4ZwIjWCks
Message-ID: <CA+EHjTwORdwR2QRQ16CmJGuGSOdjnRXoP53C5mBt_Rn0R6aH_A@mail.gmail.com>
Subject: Re: [PATCH v3 18/36] KVM: arm64: Inject SIGSEGV on illegal accesses
To: Will Deacon <will@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Quentin Perret <qperret@google.com>, 
	Vincent Donnefort <vdonnefort@google.com>, Mostafa Saleh <smostafa@google.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, 5 Mar 2026 at 14:45, Will Deacon <will@kernel.org> wrote:
>
> From: Quentin Perret <qperret@google.com>
>
> The pKVM hypervisor will currently panic if the host tries to access
> memory that it doesn't own (e.g. protected guest memory). Sadly, as
> guest memory can still be mapped into the VMM's address space, userspace
> can trivially crash the kernel/hypervisor by poking into guest memory.
>
> To prevent this, inject the abort back in the host with S1PTW set in the
> ESR, hence allowing the host to differentiate this abort from normal
> userspace faults and inject a SIGSEGV cleanly.
>
> Signed-off-by: Quentin Perret <qperret@google.com>
> Signed-off-by: Will Deacon <will@kernel.org>

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

> ---
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c | 37 +++++++++++++++++++++++++++
>  arch/arm64/mm/fault.c                 | 22 ++++++++++++++++
>  2 files changed, 59 insertions(+)
>
> diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> index 31b6a52e5e4c..0dc1d6fc546c 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> @@ -18,6 +18,7 @@
>  #include <nvhe/memory.h>
>  #include <nvhe/mem_protect.h>
>  #include <nvhe/mm.h>
> +#include <nvhe/trap_handler.h>
>
>  #define KVM_HOST_S2_FLAGS (KVM_PGTABLE_S2_AS_S1 | KVM_PGTABLE_S2_IDMAP)
>
> @@ -612,6 +613,39 @@ static int host_stage2_idmap(u64 addr)
>         return ret;
>  }
>
> +static void host_inject_mem_abort(struct kvm_cpu_context *host_ctxt)
> +{
> +       u64 ec, esr, spsr;
> +
> +       esr = read_sysreg_el2(SYS_ESR);
> +       spsr = read_sysreg_el2(SYS_SPSR);
> +
> +       /* Repaint the ESR to report a same-level fault if taken from EL1 */
> +       if ((spsr & PSR_MODE_MASK) != PSR_MODE_EL0t) {
> +               ec = ESR_ELx_EC(esr);
> +               if (ec == ESR_ELx_EC_DABT_LOW)
> +                       ec = ESR_ELx_EC_DABT_CUR;
> +               else if (ec == ESR_ELx_EC_IABT_LOW)
> +                       ec = ESR_ELx_EC_IABT_CUR;
> +               else
> +                       WARN_ON(1);
> +               esr &= ~ESR_ELx_EC_MASK;
> +               esr |= ec << ESR_ELx_EC_SHIFT;
> +       }
> +
> +       /*
> +        * Since S1PTW should only ever be set for stage-2 faults, we're pretty
> +        * much guaranteed that it won't be set in ESR_EL1 by the hardware. So,
> +        * let's use that bit to allow the host abort handler to differentiate
> +        * this abort from normal userspace faults.
> +        *
> +        * Note: although S1PTW is RES0 at EL1, it is guaranteed by the
> +        * architecture to be backed by flops, so it should be safe to use.
> +        */
> +       esr |= ESR_ELx_S1PTW;
> +       inject_host_exception(esr);
> +}
> +
>  void handle_host_mem_abort(struct kvm_cpu_context *host_ctxt)
>  {
>         struct kvm_vcpu_fault_info fault;
> @@ -635,6 +669,9 @@ void handle_host_mem_abort(struct kvm_cpu_context *host_ctxt)
>         addr = FIELD_GET(HPFAR_EL2_FIPA, fault.hpfar_el2) << 12;
>
>         switch (host_stage2_idmap(addr)) {
> +       case -EPERM:
> +               host_inject_mem_abort(host_ctxt);
> +               fallthrough;
>         case -EEXIST:
>         case 0:
>                 break;
> diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
> index be9dab2c7d6a..3abfc7272d63 100644
> --- a/arch/arm64/mm/fault.c
> +++ b/arch/arm64/mm/fault.c
> @@ -43,6 +43,7 @@
>  #include <asm/system_misc.h>
>  #include <asm/tlbflush.h>
>  #include <asm/traps.h>
> +#include <asm/virt.h>
>
>  struct fault_info {
>         int     (*fn)(unsigned long far, unsigned long esr,
> @@ -269,6 +270,15 @@ static inline bool is_el1_permission_fault(unsigned long addr, unsigned long esr
>         return false;
>  }
>
> +static bool is_pkvm_stage2_abort(unsigned int esr)
> +{
> +       /*
> +        * S1PTW should only ever be set in ESR_EL1 if the pkvm hypervisor
> +        * injected a stage-2 abort -- see host_inject_mem_abort().
> +        */
> +       return is_pkvm_initialized() && (esr & ESR_ELx_S1PTW);
> +}
> +
>  static bool __kprobes is_spurious_el1_translation_fault(unsigned long addr,
>                                                         unsigned long esr,
>                                                         struct pt_regs *regs)
> @@ -279,6 +289,9 @@ static bool __kprobes is_spurious_el1_translation_fault(unsigned long addr,
>         if (!is_el1_data_abort(esr) || !esr_fsc_is_translation_fault(esr))
>                 return false;
>
> +       if (is_pkvm_stage2_abort(esr))
> +               return false;
> +
>         local_irq_save(flags);
>         asm volatile("at s1e1r, %0" :: "r" (addr));
>         isb();
> @@ -395,6 +408,8 @@ static void __do_kernel_fault(unsigned long addr, unsigned long esr,
>                         msg = "read from unreadable memory";
>         } else if (addr < PAGE_SIZE) {
>                 msg = "NULL pointer dereference";
> +       } else if (is_pkvm_stage2_abort(esr)) {
> +               msg = "access to hypervisor-protected memory";
>         } else {
>                 if (esr_fsc_is_translation_fault(esr) &&
>                     kfence_handle_page_fault(addr, esr & ESR_ELx_WNR, regs))
> @@ -621,6 +636,13 @@ static int __kprobes do_page_fault(unsigned long far, unsigned long esr,
>                                          addr, esr, regs);
>         }
>
> +       if (is_pkvm_stage2_abort(esr)) {
> +               if (!user_mode(regs))
> +                       goto no_context;
> +               arm64_force_sig_fault(SIGSEGV, SEGV_ACCERR, far, "stage-2 fault");
> +               return 0;
> +       }
> +
>         perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS, 1, regs, addr);
>
>         if (!(mm_flags & FAULT_FLAG_USER))
> --
> 2.53.0.473.g4a7958ca14-goog
>
