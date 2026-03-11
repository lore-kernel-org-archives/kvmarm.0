Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26DDD3C8714
	for <kvmarm@lists.linux.dev>; Wed, 11 Mar 2026 10:17:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.180
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773224221; cv=pass; b=Cqto4Zycxc4396iFz/w6oGVvsWjhayWegW31tPMXRDWJOA+NZUxNNNNM1ztAh/OPFxokINTdT1KOl/1Nex/cChgUCikKy2hVByKLJ4u1cv8d172r8kHD6k6uiP7AVfjGknVkh5vrK8sMPH8OAa/spWhqRIdChTXef/7e+CGwRuw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773224221; c=relaxed/simple;
	bh=RZJzePeNKgeBLvcTVGef89EwPKrxKDBOeJ2MKLzMJSQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ms8JCLPUU2VPTiyhmGqFFyf5aenobic4rMIQ+RxJy2WkaY1iJDJQ/MxavCNy/i1jQ18HlIMc46W+GZeZm/4SfOPnBJD2IqIUKR6hBZsxFMQ62geTHXO/A0vA2Bg48mDbiA/EED4MkjXHiEggTCsurPOYq63mgNRXsMs7KiAwgf8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VSwTmmQ/; arc=pass smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VSwTmmQ/"
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-5091ed02c54so400801cf.1
        for <kvmarm@lists.linux.dev>; Wed, 11 Mar 2026 03:17:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773224219; cv=none;
        d=google.com; s=arc-20240605;
        b=FXrKRAf4mju5O/22riNYO/sS5oNO37t2OQU/PfN4/kCYtqrH3ZcZZygNxBJRXQq5Yx
         FlCbZfLtjqLEOAPKgV8t1UyLbxMmonhS2ML+BdLRsNpUIrvXJ4WMHcggN2V06Xksv+MI
         6NMsZfXdUgVG2/ugGpSKpmU4QWUy2ScCRinNPVnf21nz26PioiLosmsEY1f/vnnfnGcy
         wzMIvVlQxy0rgOLT7HSzpUGVW1q6pIa1d/id6S5IV7IB6qVa7JAZbsBX2B4QAHuf+LG9
         UcsD270vJrWfTX+orSAeAjVJMbFcbQkUYYWdwvpaualaUdKLw88QK9r60OTKTEFR7Y/K
         N7Tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=B6RFxb0yaU/mENvxQNg2l26KsJagj/pxhPvCmxc9Q0I=;
        fh=Jxzwzg3laewSUvCA2a09gOOd6H1o1mMdzeS5XgaaAVk=;
        b=ezm6NTBN1lvUFhw3oEABM/xlgzmoQcuGE2oywcQ+JB+nsTbrKWnsORO6gl/0qNLJkq
         LmsFDifVnNJbM9gH6ppSR/97unI28ASz3tHb6iGE8WhfUiJvdWVIDrIYo6lqeGRQrL22
         A9yWf9HW7AtUEQyYV1XKRD1vZ7ON13+La0+v7V8pWqkCf3gNfSTQJbuoOdckrvs7TwcP
         nF6LkF5QHYp5cGOyNbXP4m7DBRMJ1Cqzl5Mcy03i/yXOEHDF/uHKGXFvS0MvSiGTNZ6F
         8gX13akWKfeqzr1lRmRYIAruC54QILAPCmTBU0CR8IdzbWU5IMkaUD8NYAGp0OvZCmX1
         Pz7g==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773224219; x=1773829019; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=B6RFxb0yaU/mENvxQNg2l26KsJagj/pxhPvCmxc9Q0I=;
        b=VSwTmmQ/M2QzNv0+LULtuJewubSH0DLCh/ioyalAwtNmt+s0+WKszJn1rFLCg/Mkp2
         fCrdGk/gr68IKwlKTKexdWILYW6YctOD8m7GpvbFBCiNcUy1aMwYFRh/uGeyiB3zi3HA
         Ntzlz9Pz+QtapUnkKbadwZgWkMvEXjxDl/sfwlQWZ02bXwTZ+tdCjEGCwJGUxdjrs+xq
         SF03qw7eD7Ocjyc7DP81h3C1O4LyBxzaZr+K1YsOJuoCr4qmtKIGyJNChCIKjEu1Xf/m
         hzAWIBbBh3El5moh3LWgU7vEDUzU+1492k0jpCP+wOBZZEnJdvvUllLDTPAqcq8S+TRa
         tN8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773224219; x=1773829019;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B6RFxb0yaU/mENvxQNg2l26KsJagj/pxhPvCmxc9Q0I=;
        b=b70KA415Myr/0UofVsrOLeTph8eq3rriUrbmgHVBB7h7/ckbVa7IjMMEbsq1yIKWHp
         k/gWM79adqAl/jkq6tjZdTH0y/1PWn8nACtJVqoomxbHZxUFCRdg34Gre/LbIlI1Rw9P
         pZNlQyhhgF11ZROIvC3jq4D593Hi5wyHXyHy5T4tKr+nH/iUaAoalW1kzxM5xn3X4uUz
         fMyfvqdKxcsIivcwkoy2Clr/eYwL18o/DKglenYipCaENUrx+NLezrKcRmQAHzl2EijT
         cYrQIEkkPtxvnim9iNjgICAtx+dAjHLpLY0a9DCz8L3/+6cx1HWpu4vZcIHs3u4lVbzF
         1ncw==
X-Gm-Message-State: AOJu0Yylrwn7QKsmR7wNEjxGUpwUGI8mx/9xXFmLE+B/VJc7+lVMorNB
	4S9Sfq2AhmxYpgwKk9XNEmGYHeIimmkNa4FFXT9Xw2+VvaTWvodiW6lzqfTUyTwLDSHycq2D2OZ
	10Fdh1d9GIyghwkXyqYp8ibl9IIbkoztg0BfC7qzSXUHZqsLsBXiKKuvkh2k=
X-Gm-Gg: ATEYQzzTgdcPCCfZuVdxwKfcbBndVi5RLWeTqZOblZAeI1Qubzo/deipDMlw3a7aBbN
	oT0t4zUg9G1XzT+q82bNPSyKxK3kMz+mktYyJ7VyrQmuWLe5c7jMCI3HPT2XmUJmS9YipBYHbd0
	XRqoiFyGaSx49eED8S8hK5lzrEJlq6Z78LmELUP+GZsAo6TpuwG8XGElGpjRQBhaXAOSZz4dTt2
	8LreLdticAjN4Ehf5Pypk2IO8G/RgdO4PO2SF5v912blKepGXssGbXcjTGH6uN2FZ09LkDm3uYj
	s8nSTpv5TWQyMEJOacuIac/Q9CT7/PYFZmZa/w==
X-Received: by 2002:ac8:7c52:0:b0:509:25c5:42b4 with SMTP id
 d75a77b69052e-50939a712b5mr8934141cf.13.1773224218723; Wed, 11 Mar 2026
 03:16:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260305144351.17071-1-will@kernel.org> <20260305144351.17071-7-will@kernel.org>
In-Reply-To: <20260305144351.17071-7-will@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 11 Mar 2026 10:16:22 +0000
X-Gm-Features: AaiRm53tzKibGyxw6pmicDBO5NhlB4E-DgLOJdV-mGhPiyZXSjv4EXvKiR4Er3I
Message-ID: <CA+EHjTzu1XCpwNCu767i5m3+gG1Fzitj=VYyKeUK7eHU_TE_Aw@mail.gmail.com>
Subject: Re: [PATCH v3 06/36] KVM: arm64: Remove is_protected_kvm_enabled()
 checks from hypercalls
To: Will Deacon <will@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Quentin Perret <qperret@google.com>, 
	Vincent Donnefort <vdonnefort@google.com>, Mostafa Saleh <smostafa@google.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, 5 Mar 2026 at 14:44, Will Deacon <will@kernel.org> wrote:
>
> When pKVM is not enabled, the host shouldn't issue pKVM-specific
> hypercalls and so there's no point checking for this in the pKVM
> hypercall handlers.
>
> Remove the redundant is_protected_kvm_enabled() checks from each
> hypercall and instead rejig the hypercall table so that the
> pKVM-specific hypercalls are unreachable when pKVM is not being used.
>
> Reviewed-by: Quentin Perret <qperret@google.com>
> Signed-off-by: Will Deacon <will@kernel.org>

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

> ---
>  arch/arm64/include/asm/kvm_asm.h   | 24 +++++++-----
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c | 63 ++++++++++--------------------
>  2 files changed, 34 insertions(+), 53 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
> index a1ad12c72ebf..7b72aac4730d 100644
> --- a/arch/arm64/include/asm/kvm_asm.h
> +++ b/arch/arm64/include/asm/kvm_asm.h
> @@ -51,7 +51,7 @@
>  #include <linux/mm.h>
>
>  enum __kvm_host_smccc_func {
> -       /* Hypercalls available only prior to pKVM finalisation */
> +       /* Hypercalls that are unavailable once pKVM has finalised. */
>         /* __KVM_HOST_SMCCC_FUNC___kvm_hyp_init */
>         __KVM_HOST_SMCCC_FUNC___pkvm_init = __KVM_HOST_SMCCC_FUNC___kvm_hyp_init + 1,
>         __KVM_HOST_SMCCC_FUNC___pkvm_create_private_mapping,
> @@ -60,16 +60,9 @@ enum __kvm_host_smccc_func {
>         __KVM_HOST_SMCCC_FUNC___vgic_v3_init_lrs,
>         __KVM_HOST_SMCCC_FUNC___vgic_v3_get_gic_config,
>         __KVM_HOST_SMCCC_FUNC___pkvm_prot_finalize,
> +       __KVM_HOST_SMCCC_FUNC_MIN_PKVM = __KVM_HOST_SMCCC_FUNC___pkvm_prot_finalize,
>
> -       /* Hypercalls available after pKVM finalisation */
> -       __KVM_HOST_SMCCC_FUNC___pkvm_host_share_hyp,
> -       __KVM_HOST_SMCCC_FUNC___pkvm_host_unshare_hyp,
> -       __KVM_HOST_SMCCC_FUNC___pkvm_host_share_guest,
> -       __KVM_HOST_SMCCC_FUNC___pkvm_host_unshare_guest,
> -       __KVM_HOST_SMCCC_FUNC___pkvm_host_relax_perms_guest,
> -       __KVM_HOST_SMCCC_FUNC___pkvm_host_wrprotect_guest,
> -       __KVM_HOST_SMCCC_FUNC___pkvm_host_test_clear_young_guest,
> -       __KVM_HOST_SMCCC_FUNC___pkvm_host_mkyoung_guest,
> +       /* Hypercalls that are always available and common to [nh]VHE/pKVM. */
>         __KVM_HOST_SMCCC_FUNC___kvm_adjust_pc,
>         __KVM_HOST_SMCCC_FUNC___kvm_vcpu_run,
>         __KVM_HOST_SMCCC_FUNC___kvm_flush_vm_context,
> @@ -81,6 +74,17 @@ enum __kvm_host_smccc_func {
>         __KVM_HOST_SMCCC_FUNC___kvm_timer_set_cntvoff,
>         __KVM_HOST_SMCCC_FUNC___vgic_v3_save_aprs,
>         __KVM_HOST_SMCCC_FUNC___vgic_v3_restore_vmcr_aprs,
> +       __KVM_HOST_SMCCC_FUNC_MAX_NO_PKVM = __KVM_HOST_SMCCC_FUNC___vgic_v3_restore_vmcr_aprs,
> +
> +       /* Hypercalls that are available only when pKVM has finalised. */
> +       __KVM_HOST_SMCCC_FUNC___pkvm_host_share_hyp,
> +       __KVM_HOST_SMCCC_FUNC___pkvm_host_unshare_hyp,
> +       __KVM_HOST_SMCCC_FUNC___pkvm_host_share_guest,
> +       __KVM_HOST_SMCCC_FUNC___pkvm_host_unshare_guest,
> +       __KVM_HOST_SMCCC_FUNC___pkvm_host_relax_perms_guest,
> +       __KVM_HOST_SMCCC_FUNC___pkvm_host_wrprotect_guest,
> +       __KVM_HOST_SMCCC_FUNC___pkvm_host_test_clear_young_guest,
> +       __KVM_HOST_SMCCC_FUNC___pkvm_host_mkyoung_guest,
>         __KVM_HOST_SMCCC_FUNC___pkvm_reserve_vm,
>         __KVM_HOST_SMCCC_FUNC___pkvm_unreserve_vm,
>         __KVM_HOST_SMCCC_FUNC___pkvm_init_vm,
> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> index e7790097db93..127decc2dd2b 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> @@ -169,9 +169,6 @@ static void handle___pkvm_vcpu_load(struct kvm_cpu_context *host_ctxt)
>         DECLARE_REG(u64, hcr_el2, host_ctxt, 3);
>         struct pkvm_hyp_vcpu *hyp_vcpu;
>
> -       if (!is_protected_kvm_enabled())
> -               return;
> -
>         hyp_vcpu = pkvm_load_hyp_vcpu(handle, vcpu_idx);
>         if (!hyp_vcpu)
>                 return;
> @@ -188,12 +185,8 @@ static void handle___pkvm_vcpu_load(struct kvm_cpu_context *host_ctxt)
>
>  static void handle___pkvm_vcpu_put(struct kvm_cpu_context *host_ctxt)
>  {
> -       struct pkvm_hyp_vcpu *hyp_vcpu;
> +       struct pkvm_hyp_vcpu *hyp_vcpu = pkvm_get_loaded_hyp_vcpu();
>
> -       if (!is_protected_kvm_enabled())
> -               return;
> -
> -       hyp_vcpu = pkvm_get_loaded_hyp_vcpu();
>         if (hyp_vcpu)
>                 pkvm_put_hyp_vcpu(hyp_vcpu);
>  }
> @@ -257,9 +250,6 @@ static void handle___pkvm_host_share_guest(struct kvm_cpu_context *host_ctxt)
>         struct pkvm_hyp_vcpu *hyp_vcpu;
>         int ret = -EINVAL;
>
> -       if (!is_protected_kvm_enabled())
> -               goto out;
> -
>         hyp_vcpu = pkvm_get_loaded_hyp_vcpu();
>         if (!hyp_vcpu || pkvm_hyp_vcpu_is_protected(hyp_vcpu))
>                 goto out;
> @@ -281,9 +271,6 @@ static void handle___pkvm_host_unshare_guest(struct kvm_cpu_context *host_ctxt)
>         struct pkvm_hyp_vm *hyp_vm;
>         int ret = -EINVAL;
>
> -       if (!is_protected_kvm_enabled())
> -               goto out;
> -
>         hyp_vm = get_np_pkvm_hyp_vm(handle);
>         if (!hyp_vm)
>                 goto out;
> @@ -301,9 +288,6 @@ static void handle___pkvm_host_relax_perms_guest(struct kvm_cpu_context *host_ct
>         struct pkvm_hyp_vcpu *hyp_vcpu;
>         int ret = -EINVAL;
>
> -       if (!is_protected_kvm_enabled())
> -               goto out;
> -
>         hyp_vcpu = pkvm_get_loaded_hyp_vcpu();
>         if (!hyp_vcpu || pkvm_hyp_vcpu_is_protected(hyp_vcpu))
>                 goto out;
> @@ -321,9 +305,6 @@ static void handle___pkvm_host_wrprotect_guest(struct kvm_cpu_context *host_ctxt
>         struct pkvm_hyp_vm *hyp_vm;
>         int ret = -EINVAL;
>
> -       if (!is_protected_kvm_enabled())
> -               goto out;
> -
>         hyp_vm = get_np_pkvm_hyp_vm(handle);
>         if (!hyp_vm)
>                 goto out;
> @@ -343,9 +324,6 @@ static void handle___pkvm_host_test_clear_young_guest(struct kvm_cpu_context *ho
>         struct pkvm_hyp_vm *hyp_vm;
>         int ret = -EINVAL;
>
> -       if (!is_protected_kvm_enabled())
> -               goto out;
> -
>         hyp_vm = get_np_pkvm_hyp_vm(handle);
>         if (!hyp_vm)
>                 goto out;
> @@ -362,9 +340,6 @@ static void handle___pkvm_host_mkyoung_guest(struct kvm_cpu_context *host_ctxt)
>         struct pkvm_hyp_vcpu *hyp_vcpu;
>         int ret = -EINVAL;
>
> -       if (!is_protected_kvm_enabled())
> -               goto out;
> -
>         hyp_vcpu = pkvm_get_loaded_hyp_vcpu();
>         if (!hyp_vcpu || pkvm_hyp_vcpu_is_protected(hyp_vcpu))
>                 goto out;
> @@ -424,12 +399,8 @@ static void handle___kvm_tlb_flush_vmid(struct kvm_cpu_context *host_ctxt)
>  static void handle___pkvm_tlb_flush_vmid(struct kvm_cpu_context *host_ctxt)
>  {
>         DECLARE_REG(pkvm_handle_t, handle, host_ctxt, 1);
> -       struct pkvm_hyp_vm *hyp_vm;
> +       struct pkvm_hyp_vm *hyp_vm = get_np_pkvm_hyp_vm(handle);
>
> -       if (!is_protected_kvm_enabled())
> -               return;
> -
> -       hyp_vm = get_np_pkvm_hyp_vm(handle);
>         if (!hyp_vm)
>                 return;
>
> @@ -603,14 +574,6 @@ static const hcall_t host_hcall[] = {
>         HANDLE_FUNC(__vgic_v3_get_gic_config),
>         HANDLE_FUNC(__pkvm_prot_finalize),
>
> -       HANDLE_FUNC(__pkvm_host_share_hyp),
> -       HANDLE_FUNC(__pkvm_host_unshare_hyp),
> -       HANDLE_FUNC(__pkvm_host_share_guest),
> -       HANDLE_FUNC(__pkvm_host_unshare_guest),
> -       HANDLE_FUNC(__pkvm_host_relax_perms_guest),
> -       HANDLE_FUNC(__pkvm_host_wrprotect_guest),
> -       HANDLE_FUNC(__pkvm_host_test_clear_young_guest),
> -       HANDLE_FUNC(__pkvm_host_mkyoung_guest),
>         HANDLE_FUNC(__kvm_adjust_pc),
>         HANDLE_FUNC(__kvm_vcpu_run),
>         HANDLE_FUNC(__kvm_flush_vm_context),
> @@ -622,6 +585,15 @@ static const hcall_t host_hcall[] = {
>         HANDLE_FUNC(__kvm_timer_set_cntvoff),
>         HANDLE_FUNC(__vgic_v3_save_aprs),
>         HANDLE_FUNC(__vgic_v3_restore_vmcr_aprs),
> +
> +       HANDLE_FUNC(__pkvm_host_share_hyp),
> +       HANDLE_FUNC(__pkvm_host_unshare_hyp),
> +       HANDLE_FUNC(__pkvm_host_share_guest),
> +       HANDLE_FUNC(__pkvm_host_unshare_guest),
> +       HANDLE_FUNC(__pkvm_host_relax_perms_guest),
> +       HANDLE_FUNC(__pkvm_host_wrprotect_guest),
> +       HANDLE_FUNC(__pkvm_host_test_clear_young_guest),
> +       HANDLE_FUNC(__pkvm_host_mkyoung_guest),
>         HANDLE_FUNC(__pkvm_reserve_vm),
>         HANDLE_FUNC(__pkvm_unreserve_vm),
>         HANDLE_FUNC(__pkvm_init_vm),
> @@ -635,7 +607,7 @@ static const hcall_t host_hcall[] = {
>  static void handle_host_hcall(struct kvm_cpu_context *host_ctxt)
>  {
>         DECLARE_REG(unsigned long, id, host_ctxt, 0);
> -       unsigned long hcall_min = 0;
> +       unsigned long hcall_min = 0, hcall_max = -1;
>         hcall_t hfn;
>
>         /*
> @@ -647,14 +619,19 @@ static void handle_host_hcall(struct kvm_cpu_context *host_ctxt)
>          * basis. This is all fine, however, since __pkvm_prot_finalize
>          * returns -EPERM after the first call for a given CPU.
>          */
> -       if (static_branch_unlikely(&kvm_protected_mode_initialized))
> -               hcall_min = __KVM_HOST_SMCCC_FUNC___pkvm_prot_finalize;
> +       if (static_branch_unlikely(&kvm_protected_mode_initialized)) {
> +               hcall_min = __KVM_HOST_SMCCC_FUNC_MIN_PKVM;
> +       } else {
> +               hcall_max = __KVM_HOST_SMCCC_FUNC_MAX_NO_PKVM;
> +       }
>
>         id &= ~ARM_SMCCC_CALL_HINTS;
>         id -= KVM_HOST_SMCCC_ID(0);
>
> -       if (unlikely(id < hcall_min || id >= ARRAY_SIZE(host_hcall)))
> +       if (unlikely(id < hcall_min || id > hcall_max ||
> +                    id >= ARRAY_SIZE(host_hcall))) {
>                 goto inval;
> +       }
>
>         hfn = host_hcall[id];
>         if (unlikely(!hfn))
> --
> 2.53.0.473.g4a7958ca14-goog
>
