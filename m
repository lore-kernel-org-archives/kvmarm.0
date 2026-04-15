Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BCE11DDC37
	for <kvmarm@lists.linux.dev>; Wed, 15 Apr 2026 09:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776247018; cv=pass; b=c+XV0KxME6AGaBFEFrauOSb9V7dRHqBzTH9F0TLW1n0eCy2/6tMuOIoaDp45wjThbUxO015piHNDU3N8t4wcJ+HPRotm1HYklIrum4ZNWH14+jHTmvH62nMncEfEkxsRqyVqmQfa6pFg6eZdTg255TH/o1E4ALLD71Qu0cbbEYM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776247018; c=relaxed/simple;
	bh=DjQdq8iz173ZYvQkJltlMZPdvr0H9hjQIPqEqpBLC3g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=H3ZwKob7hs0xpSiRvgxviUx/mQdPGq0IrGc0AzzOmUpv0KxIo40+oNroFcLAT7VS4HlI5GM9xvgC5mabi24Qv6/H1mmRGu3gfGWoZPgcF5LMQRWhfnIdYn0TLsObvcgBvNoQfbLvWXvWB8HvFHDn+P8xgy3CGelu07yq0/rMLeE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TjD9tzxN; arc=pass smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TjD9tzxN"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-50d8c7a393fso4096681cf.1
        for <kvmarm@lists.linux.dev>; Wed, 15 Apr 2026 02:56:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776247015; cv=none;
        d=google.com; s=arc-20240605;
        b=Tlq+ehl9zsATz71Uz+Up0/uyetsLf7SShGZm4m3S8TqM958foKSqbZstPLZ36idcqh
         ifHV0XRZ0gSo5cQxna5yt/+U0clQbUfiKEibcVxURqiqhV8vWkFcRRbGsOwEaQaTBiJS
         X6v11CYW0UQhfYho/xYJFN/4Sx5b5Qy8krvIv3V5u6droaU/TAI/CjtGOMYEx8hgZwUM
         DPBzHspSQpgGmUDJ0g8jIXy+UUmTI2Y/Rnca4uxL0FCBhk27cIWH+ZCmpHKn1nLVP+24
         4ZFLK9zM9TP5Wg06G4fIkla9a9K2kKXsWJwtfHnoR/iBfP3BhY3QUI2z+olO7aMksy31
         5JRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=/EbgCdLHRY+jKfmk+Esh0hv8FKnFSyVXrH0IPR8PlGk=;
        fh=7o0KG5X7f5rl0d5WFwUh3QqhuoMCV1yoRq1gr2k/4mA=;
        b=YQuxz/2uBphvfVCfCeIAgKB7lGymo4j1MV+d1Ghihpb9C87Sqv8uA0h15FpgkH8tmp
         4Dh70ZRnelFDJ6k+lY6oiQeRYAnvRHMDw24S6tG5ZPY3+8QXoVuvMzAHIrry8G5Q9AHk
         StYnUteJVrVs9S5eoTCtiAwmaciaNhSRZdLFz+hp2crv/rP+c0X1dv72Gpya2UYU6FqI
         Zo9j9Xk50aJqE+/Qn3v877DArVbpGy3Rp52JInI5FIsYY0/szxwQCGSR7QEloIEMlhVp
         u2uc6ZvJEyrWavQyHhZI7Yu4hlKP9BZ8U1vREpvIrcwvHWO7EXtRfhtk9C6XGO+IYmLq
         9AjQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776247015; x=1776851815; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=/EbgCdLHRY+jKfmk+Esh0hv8FKnFSyVXrH0IPR8PlGk=;
        b=TjD9tzxNSzPFNZM75aMM58FhshRE7/RUJ2QdOJOCE7Ozd3hpdQRWZAFREKZ1UW1M0B
         EcNa4ROMG3MtZM7c3aZFZdhOZA5zzr0U5+ZyYbSSHBJZc2nbHrzagyrQ3X7vvH7F/fri
         zgrKkmd3GUxBFFBQw3K4ACXKIspj5R+jSleM9oqLqDT2CEm2cJv00gIj5ITr/OCp1hNe
         b7HY73NA8jdLhuRbvwGrmiWfaOPI12a6hjFiTSAae3dwlIW/rHAFuLTwoquXiFR0K68H
         zJxR2kqeVZL2RgVKYmyHJckVl6ngVYq4eBjbFUACp+A6zo3EwRPvHwDxl0BFfe661Z4G
         Ph8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776247015; x=1776851815;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/EbgCdLHRY+jKfmk+Esh0hv8FKnFSyVXrH0IPR8PlGk=;
        b=qKRWFD1fDFAb8rOZUDjzBv9+WY/Er9lqQ9mtzheM84Wm9VYmYD7/JaaXVjCcgtA7aM
         TxyHewv/zNh7NWgTMCZ19yl4AStmn9gYXfYqg/zHkaudj6qal4Dw/l8jqPxp+Gprw5WK
         yNvm3D8ODpvu0bmJrsZMExQUfeVdv7N67wN7fNjUolMBeLbCpKNG4fLRIXy5bKpL1x+L
         Ygd4q/rIsVcWP8+nmgrMLuiHysci2gHwuYGub6FOzQGtcQ+X1gm2wkxvkFtHkZh/1tRx
         LxT/vdGXPzu84wogKSU7rJ9Cw8fORvSGenBwDCDhnKRD6alWTUYwxz7LHl0Oo+1mOZnz
         I+5g==
X-Gm-Message-State: AOJu0YzFGdk/SykI+BIRerr19jf5qZ/hS3EV7iqDrUc2kluwWPpGVP1v
	ZXsptiMJv1963jQkn55UNFzj7qbUEEucRlv/f9qudsMsblnyO14hOY4IzNxII6uxWh0KCDLBVMn
	JTXyqrEqjxRtKVNLMbMO4loKLmoXpfd62mJY2fNCT
X-Gm-Gg: AeBDietOiqMKUNMLhr9HL4Ox1/UGgVRb7Gk6dr4YVHXHRNvVssKvGD5Ihs3SDmLajj+
	Wvu9ptMMWb+IB5CJT6UqNjzkiSEwR69jGR7Is6MOwSihL/lDTEMZrRUR4WjIemnZE5uuZ4o9Ckf
	CQ0koJEsDprYQ5PkW1IoqkvwyQ+6qkUmefaYS7KXL1R4PvnAOgHD8n9QVV7Emushd6C/Pxv1uRC
	/L58O8G1bFWLH9czkZX5WPPJ6syNkEzQ6n4x8ZDfPq1Dsp9dodDTf6N7rpL1Ef006oc8Epnd7hf
	xabezQM0YuoOypi7qP2WQb0JHc4WVZvuQvBTLOhdVFqIC2cA5BA0UpeeMzw=
X-Received: by 2002:a05:622a:47:b0:50d:edb1:6bd1 with SMTP id
 d75a77b69052e-50e19087b29mr8513401cf.13.1776247014409; Wed, 15 Apr 2026
 02:56:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260414160528.2218858-1-maz@kernel.org>
In-Reply-To: <20260414160528.2218858-1-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 15 Apr 2026 10:56:17 +0100
X-Gm-Features: AQROBzAI0VOPROkQCqyX7Dt9X2lg7F9YAmrA11FS7_WWuEvNdak5O-heggH5cq0
Message-ID: <CA+EHjTxWAFKHqBUOCVkkqtzTKrMSU8HQDwoLMqD2HQPga7y_-w@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: pkvm: Adopt MARKER() to define host hypercall ranges
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	Will Deacon <will@kernel.org>, Vincent Donnefort <vdonnefort@google.com>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>
Content-Type: text/plain; charset="UTF-8"

Hi Marc,

On Tue, 14 Apr 2026 at 17:05, Marc Zyngier <maz@kernel.org> wrote:
>
> The EL2 code defines ranges of host hypercalls that are either
> enabled at boot-time only, used by [nh]VHE KVM, or reserved to pKVM.
>
> The way these ranges are delineated is error prone, as the enum symbols
> defining the limits are expressed in terms of actual function symbols.
> This means that should a new function be added, special care must be
> taken to also update the limit symbol.
>
> Improve this by reusing the mechanism introduced for the vcpu_sysreg
> enum, which uses a MARKER() macro and some extra trickery to make
> the limit symbol standalone. Crucially, the limit symbol has the
> same value as the *following* symbol.
>
> The handle_host_hcall() function is then updated to make use of
> the new limit definitions and get rid of the brittle default
> upper limit. This allows for some more strict checks at build
> time, and the removal of an comparison at run time.

This is pretty neat. There is still the issue of a hole, i.e., adding
an enum in the middle but forgetting to add a function, but that is
caught in handle_host_hcall(). I can't think of an easy way to catch
that though (xarray that initializes both?)
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Tested-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad


> ---
>  arch/arm64/include/asm/kvm_asm.h   | 12 ++++++++++--
>  arch/arm64/include/asm/kvm_host.h  |  3 ---
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c | 10 +++++-----
>  3 files changed, 15 insertions(+), 10 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
> index 37414440cee7f..fa033be6141ad 100644
> --- a/arch/arm64/include/asm/kvm_asm.h
> +++ b/arch/arm64/include/asm/kvm_asm.h
> @@ -50,6 +50,9 @@
>
>  #include <linux/mm.h>
>
> +#define MARKER(m)                              \
> +       m, __after_##m = m - 1
> +
>  enum __kvm_host_smccc_func {
>         /* Hypercalls that are unavailable once pKVM has finalised. */
>         /* __KVM_HOST_SMCCC_FUNC___kvm_hyp_init */
> @@ -59,8 +62,10 @@ enum __kvm_host_smccc_func {
>         __KVM_HOST_SMCCC_FUNC___kvm_enable_ssbs,
>         __KVM_HOST_SMCCC_FUNC___vgic_v3_init_lrs,
>         __KVM_HOST_SMCCC_FUNC___vgic_v3_get_gic_config,
> +
> +       MARKER(__KVM_HOST_SMCCC_FUNC_MIN_PKVM),
> +
>         __KVM_HOST_SMCCC_FUNC___pkvm_prot_finalize,
> -       __KVM_HOST_SMCCC_FUNC_MIN_PKVM = __KVM_HOST_SMCCC_FUNC___pkvm_prot_finalize,
>
>         /* Hypercalls that are always available and common to [nh]VHE/pKVM. */
>         __KVM_HOST_SMCCC_FUNC___kvm_adjust_pc,
> @@ -76,7 +81,8 @@ enum __kvm_host_smccc_func {
>         __KVM_HOST_SMCCC_FUNC___vgic_v3_restore_vmcr_aprs,
>         __KVM_HOST_SMCCC_FUNC___vgic_v5_save_apr,
>         __KVM_HOST_SMCCC_FUNC___vgic_v5_restore_vmcr_apr,
> -       __KVM_HOST_SMCCC_FUNC_MAX_NO_PKVM = __KVM_HOST_SMCCC_FUNC___vgic_v5_restore_vmcr_apr,
> +
> +       MARKER(__KVM_HOST_SMCCC_FUNC_PKVM_ONLY),
>
>         /* Hypercalls that are available only when pKVM has finalised. */
>         __KVM_HOST_SMCCC_FUNC___pkvm_host_share_hyp,
> @@ -108,6 +114,8 @@ enum __kvm_host_smccc_func {
>         __KVM_HOST_SMCCC_FUNC___tracing_reset,
>         __KVM_HOST_SMCCC_FUNC___tracing_enable_event,
>         __KVM_HOST_SMCCC_FUNC___tracing_write_event,
> +
> +       MARKER(__KVM_HOST_SMCCC_FUNC_MAX)
>  };
>
>  #define DECLARE_KVM_VHE_SYM(sym)       extern char sym[]
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 851f6171751c0..44211e86f5ebd 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -450,9 +450,6 @@ struct kvm_vcpu_fault_info {
>         r = __VNCR_START__ + ((VNCR_ ## r) / 8),        \
>         __after_##r = __MAX__(__before_##r - 1, r)
>
> -#define MARKER(m)                              \
> -       m, __after_##m = m - 1
> -
>  enum vcpu_sysreg {
>         __INVALID_SYSREG__,   /* 0 is reserved as an invalid value */
>         MPIDR_EL1,      /* MultiProcessor Affinity Register */
> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> index 73f2e0221e703..9e44c05cf780e 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> @@ -748,9 +748,11 @@ static const hcall_t host_hcall[] = {
>  static void handle_host_hcall(struct kvm_cpu_context *host_ctxt)
>  {
>         DECLARE_REG(unsigned long, id, host_ctxt, 0);
> -       unsigned long hcall_min = 0, hcall_max = -1;
> +       unsigned long hcall_min = 0, hcall_max = __KVM_HOST_SMCCC_FUNC_MAX;
>         hcall_t hfn;
>
> +       BUILD_BUG_ON(ARRAY_SIZE(host_hcall) != __KVM_HOST_SMCCC_FUNC_MAX);
> +
>         /*
>          * If pKVM has been initialised then reject any calls to the
>          * early "privileged" hypercalls. Note that we cannot reject
> @@ -763,16 +765,14 @@ static void handle_host_hcall(struct kvm_cpu_context *host_ctxt)
>         if (static_branch_unlikely(&kvm_protected_mode_initialized)) {
>                 hcall_min = __KVM_HOST_SMCCC_FUNC_MIN_PKVM;
>         } else {
> -               hcall_max = __KVM_HOST_SMCCC_FUNC_MAX_NO_PKVM;
> +               hcall_max = __KVM_HOST_SMCCC_FUNC_PKVM_ONLY;
>         }
>
>         id &= ~ARM_SMCCC_CALL_HINTS;
>         id -= KVM_HOST_SMCCC_ID(0);
>
> -       if (unlikely(id < hcall_min || id > hcall_max ||
> -                    id >= ARRAY_SIZE(host_hcall))) {
> +       if (unlikely(id < hcall_min || id >= hcall_max))
>                 goto inval;
> -       }
>
>         hfn = host_hcall[id];
>         if (unlikely(!hfn))
> --
> 2.47.3
>
