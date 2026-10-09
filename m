Received: from mta0.migadu.com (out-52.mta0.migadu.com [91.218.175.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 245AB4C650B
	for <kvmarm@lists.linux.dev>; Fri,  9 Oct 2026 11:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791545504; cv=none; b=nIiULRksopAzwrj9MXYSticFpVxbgLVHhcYfOjv70nmk0iO45434pycrAKI/moZKfUViG+/ZN9Al6Ppm8QJzWwEycoOKHhcOaieRY+gq90UlZh7k+HMeKTXYVdaXiOudoJz82yJlByLkeE4iTxcv88ipZNFvF7R8bhyzwb95jtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791545504; c=relaxed/simple;
	bh=uCtXgM21jDXIOWhSaCZvIRnqzIfzMQzSFLIzCqskVow=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JQlXZjDwExXpAjBTfoIczss3eZTypB4IfIhvR5cRbpI2cPtQ830JG6jmULVsGwRv4sDL5oSguRLqW9mhDIl0OqXSEa0QxII6OjOg+vXlOx1cFBe5hlgfwUH5LMJU5PSePq+dBwu7RWErLTbx+9IRjYe+bNTAkIh77Ics8Chwb68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=sH7wXgcd; arc=none smtp.client-ip=91.218.175.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="sH7wXgcd"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=uCtXgM21jDXIOWhSaCZvIRnqzIfzMQzSFLIzCqskVow=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791545493; v=1; x=1792150293;
 b=sH7wXgcd4dAI1DUcsntMicSIOacxD+oA2wAOLM9FwY5D99YyfSrHZW2SVUMHJ2DGObaKF+QA
 WJVWC7IBVOXT/InoI4RKvv4Za18qY0FN81KLvKulrLmx6Vz+kNEN0+cLQuNsYTIXbbjwbmoBPmX
 PE6+83st5ELu7II1sZwOQnAg=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id c1f2725d6371bd69;
	Fri, 09 Oct 2026 11:31:33 +0000
X-Mizu-Trace-ID: c1f2725d6371bd69
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-5bcc04c71f5so6621e87.0
        for <kvmarm@lists.linux.dev>; Fri, 09 Oct 2026 04:31:33 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBz6bcwhodyj3uKRNXX0U2NiucHhauKg2qVN42URfdYdhxpKBjMH4GyherHApogFaPRVVLkEAqM=@lists.linux.dev
X-Gm-Message-State: AFq9FYJ9GD3w4bNrX7Sek1e9P2/Gv+WSVewLuxsE2Nw+Or1dARSoyHym
	rfGCZotFf/U7LNGe/mAUaAz9zvmy2nNtsPuOXD4tP9g/W4ozm0llDoM+Tpalz/ei9YYNvvFpy55
	MTSS2yltgspGi6qHxqKSaT5iAX699Ix/XCX+vLVQj
X-Received: by 2002:a05:6512:15a5:b0:5ae:b1b3:145a with SMTP id
 2adb3069b0e04-5bcdd52a6acmr112519e87.6.1791545492765; Fri, 09 Oct 2026
 04:31:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20261009084529.462577-1-vdonnefort@google.com> <20261009084529.462577-2-vdonnefort@google.com>
In-Reply-To: <20261009084529.462577-2-vdonnefort@google.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Fri, 9 Oct 2026 12:30:56 +0100
X-Gmail-Original-Message-ID: <CA+EHjTwNTarWqSc_XVXGFT6mHUZD=QuTeVWrd087jUtexxCScg@mail.gmail.com>
X-Gm-Features: AclHuK_cF5JT5S12VCtvnCgSU9UqoMj-R1sTP2STp90bITgupW6QRjwU-nRbT90
Message-ID: <CA+EHjTwNTarWqSc_XVXGFT6mHUZD=QuTeVWrd087jUtexxCScg@mail.gmail.com>
Subject: Re: [PATCH v1 1/3] KVM: arm64: Add ESR class to the hyp_enter hyp event
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, 
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, kernel-team@android.com, 
	qperret@google.com
Content-Type: text/plain; charset="UTF-8"

Hi Vincent,

On Fri, 09 Oct 2026 09:45:27 +0100, Vincent Donnefort
<vdonnefort@google.com> wrote:

[...]
> To distinguish between a trap from host and from guest, add a "from="
> field, which has 3 possibilities: "host", "vcpu" or "firmware". This
> value can be deducted based on the existing vcpu field.

nit: "deduced". Also, "firmware" comes from the reason rather than
from the vcpu field.

[...]
> diff --git a/arch/arm64/include/asm/kvm_hypevents.h b/arch/arm64/include/asm/kvm_hypevents.h

[...]
> @@ -10,15 +10,10 @@
>  #ifndef __HYP_ENTER_EXIT_REASON
>  #define __HYP_ENTER_EXIT_REASON
>  enum hyp_enter_exit_reason {
> -        HYP_REASON_SMC,
> -        HYP_REASON_HVC,
> -        HYP_REASON_SYS,
> +        HYP_REASON_SMC = ESR_ELx_EC_MAX + 1,

This header now uses ESR_ELx_EC_MAX, so it should include <asm/esr.h>
rather than rely on its includers.

>          HYP_REASON_PSCI,
> -        HYP_REASON_HOST_ABORT,
> -        HYP_REASON_GUEST_EXIT,
> -        HYP_REASON_ERET_HOST,
> -        HYP_REASON_ERET_GUEST,
> -        HYP_REASON_UNKNOWN        /* Must be last */
> +        HYP_REASON_IRQ,
> +        HYP_REASON_ERET,
>  };

Aren't fixed trace points ABI? This changes the raw values of the
reason field (1 was hvc and is now WFx) and the strings it prints.
Keeping the old values and recording the EC in a new field would avoid
that.

[...]
> diff --git a/arch/arm64/kvm/hyp/nvhe/psci-relay.c b/arch/arm64/kvm/hyp/nvhe/psci-relay.c
[...]
> @@ -213,7 +213,7 @@ static void __noreturn __kvm_host_psci_cpu_entry(unsigned long pc, unsigned long
>          write_sysreg_el1(INIT_SCTLR_EL1_MMU_OFF, SYS_SCTLR);
>          write_sysreg(INIT_PSTATE_EL1, SPSR_EL2);
>
> -        trace_hyp_exit(host_ctxt, HYP_REASON_PSCI);
> +        trace_hyp_exit(host_ctxt, HYP_REASON_ERET);
>          __host_enter(host_ctxt);

This also replaces the PSCI, ERET_HOST and ERET_GUEST exit reasons
with a single ERET, which the commit message doesn't mention.

[...]
> diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c

[...]
> @@ -324,13 +324,15 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
>          __debug_switch_to_guest(vcpu);
>
>          do {
> -                trace_hyp_exit(host_ctxt, HYP_REASON_ERET_GUEST);
> +                trace_hyp_exit(host_ctxt, HYP_REASON_ERET);
>
>                  /* Jump in the fire! */
>                  exit_code = __guest_enter(vcpu);
>
>                  /* And we're baaack! */
> -                trace_hyp_enter(host_ctxt, HYP_REASON_GUEST_EXIT);
> +                trace_hyp_enter(host_ctxt,
> +                                ARM_EXCEPTION_CODE(exit_code) == ARM_EXCEPTION_IRQ ?
> +                                HYP_REASON_IRQ : ESR_ELx_EC(read_sysreg_el2(SYS_ESR)));
>          } while (fixup_guest_exit(vcpu, &exit_code));

Could ESR_EL2 be read only when the event is enabled? The read happens
even when tracing is disabled or compiled out, so every non-IRQ guest
exit now does an extra one: with NVHE_EL2_DEBUG=n, __kvm_vcpu_run()
goes from two reads of ESR_EL2 to three.

[...]
> diff --git a/arch/arm64/kvm/hyp_trace.c b/arch/arm64/kvm/hyp_trace.c
[...]
>  static const char *__hyp_enter_exit_reason_str(u8 reason)
>  {
[...]
> +        if (reason <= ESR_ELx_EC_MAX) {
> +                int i;
> +
> +                for (i = 0; i < ARRAY_SIZE(class); i++) {
> +                        if (class[i].mask == reason)
> +                                return class[i].name;
> +                }
> +
> +                return "UNKNOWN_ESR";
> +        }

Could this print the EC value when it isn't in the table?
kvm_arm_exception_class has no entry for ILL, BTI, SME or GCS among
others, so an ARM_EXCEPTION_IL exit (EC 0x0E) shows up as UNKNOWN_ESR.

Cheers,
/fuad
