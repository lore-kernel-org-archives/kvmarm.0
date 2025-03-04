Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5B4923A98C
	for <kvmarm@lists.linux.dev>; Tue,  4 Mar 2025 14:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741099018; cv=none; b=ga98of5wpwpi9hd1AsRhKFVXM2ZdnMjmanrnAL4LvNIhLplNcUnlAcPLywsg0LMHiqshwoBAqOcHFOvERFFSIFR4oUkGrICucruUFnDK1yvEXJ3r3W1qErGY3/7Us853+7oxNacAN+su8MW7dD3EpcfUycAfrj4desf0h8zLdvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741099018; c=relaxed/simple;
	bh=QxDMqoc0xID44HaESYXc7yWWzMeYF/JbxGeoRjff/Jw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qvL5PVVu2rRw+JT4ZUKlPQLlIFC3tfNAbWzpYGUGX6Wi5PYtQov656VBpQcYk19XsHXLPvg0aPIeW83vC/h3C6b771H1UYHugMFWfoT2nbxDvLEFk53KRncyusZqtXJr4glBpcFcz1u5nTDt7zF8lOioFTAKBmXWa3SWsx5wVIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ekRjN9uW; arc=none smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ekRjN9uW"
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-472098e6e75so214391cf.1
        for <kvmarm@lists.linux.dev>; Tue, 04 Mar 2025 06:36:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741099016; x=1741703816; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=+ygttRTKf7i4hHwUkxbYRbNGqV7dr+gxLZlkMmtHeME=;
        b=ekRjN9uWUz20ifqjVWmbtgFDbhBpkGjktIaOwohMEvvKEW/UPST0b12BGpY6JAliXt
         Bd+qPnRM+ad74pZouUbRQSU79Y7FbxYfV1yq7tYifTbPiELEcbONKI2JYJbUzZkttu0U
         OsPdTWB2ifvvykIBjG66S6zcinrj1nnmD5rQ1AIpqFBtwjNrH+rtiJ7KFJkuo1JIKlhP
         2L7qVLOznWvcuvsKvNHzxS4x1QtzZAms9U2OCjOTR+YxXJ/9FAvzxbnzKevsy75+t+Qa
         mjJ9w25JUyqGK0KhpJeBCWlb2RcaW2EXOMBpTH24CO5tS24PTs1FNcAEhid7fq+lyywI
         Z4BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741099016; x=1741703816;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+ygttRTKf7i4hHwUkxbYRbNGqV7dr+gxLZlkMmtHeME=;
        b=XSqBP7z9FZl8NMgAf63qDLf2WQqELiXKetRbEacL6el++dC2+ed2uheCkpf3PVPa56
         r0iI411QBGN8byU7tsWj8n3Tk3XbPFm9TwQgYv8IRqjsbqsGIpG2W4OPXis2t9omMtsG
         v0R1WmGKpnyVgEJKP7rjuvOKBZ8LraX4Q2lMHygPDQcu3iV8ZhNcCqfSwVljc2XPCtHZ
         ZbPRwyCZ/DwF4KzJPdyDqcVrMkWx45sQkDypQ36uQQD7CUT26dvSDaewGH8myrP/pcpq
         NnbbKDs1BpFksvBOHndeP8K1WoaLwzEFZa4rn4qdc6N8NQznl5ilw+Ltsvbyc+s7ATCP
         qyJA==
X-Gm-Message-State: AOJu0YzoFDjcQ79PiQkudE06r5uW3KFyo2q4dyBMtMeGKefbEGO/szLt
	0IUwP28qV/kY247EkJ7gYybhvlbKMmg2/XKSFAz3EHUJjjLPLHX6mBbq07NHnwrYhovXK3A1f06
	W14KqLL17zbkIY5OcJUvNbbuHuHfs7e3u06Bu
X-Gm-Gg: ASbGncsDyBvrg+YPztx2ZrSOXWnYW0VnGOZTICDbUOMTNti/cZJ3o3NENFW4gKTh2+C
	6lQd2rNnCL6aj/zL2LxFHfJWSERFV5fXH5tC4T1ZdbaWQA1fPm11nOC5wQzM3Y4O8hFIQEzCcfR
	amj1cKPD1Al3nM5XEq/2ZkwvnKEonRerOIqZ9EgHhnOEOToBL16zUinwY=
X-Google-Smtp-Source: AGHT+IFeNCEP0siRwcGFMhDyxTwUgN/q4ESl7wZnSThP1BZE2VnPVYxln59ocl0tbMWx93FWKB2s5IMnvCUEO374htw=
X-Received: by 2002:ac8:7e86:0:b0:471:939c:a304 with SMTP id
 d75a77b69052e-474fc4f486bmr4445741cf.8.1741099015479; Tue, 04 Mar 2025
 06:36:55 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250210184150.2145093-1-maz@kernel.org> <20250210184150.2145093-4-maz@kernel.org>
In-Reply-To: <20250210184150.2145093-4-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 4 Mar 2025 14:36:19 +0000
X-Gm-Features: AQ5f1Jo68p3yb9_4_jDKr_EIPn09Ol_E9D3YE9a_TVB0qWSEdbu-YNoM1obqL94
Message-ID: <CA+EHjTwkX+sy1wuS8LvGM+=m_S-h-=xUUXOyMapnoLiHt0XpOw@mail.gmail.com>
Subject: Re: [PATCH 03/18] KVM: arm64: Handle trapping of FEAT_LS64* instructions
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Zenghui Yu <yuzenghui@huawei.com>, Mark Rutland <mark.rutland@arm.com>
Content-Type: text/plain; charset="UTF-8"

Hi Marc,

On Mon, 10 Feb 2025 at 18:42, Marc Zyngier <maz@kernel.org> wrote:
>
> We generally don't expect FEAT_LS64* instructions to trap, unless
> they are trapped by a guest hypervisor.
>
> Otherwise, this is just the guest playing tricks on us by using
> an instruction that isn't advertised, which we handle with a well
> deserved UNDEF.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/handle_exit.c | 64 ++++++++++++++++++++++++++++++++++++
>  1 file changed, 64 insertions(+)
>
> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> index 512d152233ff2..4f8354bf7dc5f 100644
> --- a/arch/arm64/kvm/handle_exit.c
> +++ b/arch/arm64/kvm/handle_exit.c
> @@ -294,6 +294,69 @@ static int handle_svc(struct kvm_vcpu *vcpu)
>         return 1;
>  }
>
> +static int handle_ls64b(struct kvm_vcpu *vcpu)
> +{
> +       struct kvm *kvm = vcpu->kvm;
> +       u64 esr = kvm_vcpu_get_esr(vcpu);
> +       u64 iss = ESR_ELx_ISS(esr);
> +       bool allowed;
> +
> +       switch (iss) {
> +       case ESR_ELx_ISS_ST64BV:
> +               allowed = kvm_has_feat(kvm, ID_AA64ISAR1_EL1, LS64, LS64_V);
> +               break;
> +       case ESR_ELx_ISS_ST64BV0:
> +               allowed = kvm_has_feat(kvm, ID_AA64ISAR1_EL1, LS64, LS64_ACCDATA);
> +               break;
> +       case ESR_ELx_ISS_LDST64B:
> +               allowed = kvm_has_feat(kvm, ID_AA64ISAR1_EL1, LS64, LS64);
> +               break;
> +       default:
> +               /* Clearly, we're missing something. */
> +               goto unknown_trap;
> +       }
> +
> +       if (!allowed)
> +               goto undef;
> +
> +       if (vcpu_has_nv(vcpu) && !is_hyp_ctxt(vcpu)) {
> +               u64 hcrx = __vcpu_sys_reg(vcpu, HCRX_EL2);
> +               bool fwd;
> +
> +               switch (iss) {
> +               case ESR_ELx_ISS_ST64BV:
> +                       fwd = !(hcrx & HCRX_EL2_EnASR);
> +                       break;
> +               case ESR_ELx_ISS_ST64BV0:
> +                       fwd = !(hcrx & HCRX_EL2_EnAS0);
> +                       break;
> +               case ESR_ELx_ISS_LDST64B:
> +                       fwd = !(hcrx & HCRX_EL2_EnALS);
> +                       break;
> +               default:
> +                       /* We don't expect to be here */
> +                       fwd = false;
> +               }
> +
> +               if (fwd) {
> +                       kvm_inject_nested_sync(vcpu, esr);
> +                       return 1;
> +               }
> +       }
> +
> +unknown_trap:
> +       /*
> +        * If we land here, something must be very wrong, because we
> +        * have no idea why we trapped at all. Warn and undef as a
> +        * fallback.
> +        */
> +       WARN_ON(1);

nit: should this be WARN_ONCE() instead?

> +
> +undef:
> +       kvm_inject_undefined(vcpu);
> +       return 1;
> +}

I'm wondering if this can be simplified by having one switch()
statement that toggles both allowed and fwd (or maybe even only fwd),
and then inject depending on that, e.g.,

+static int handle_ls64b(struct kvm_vcpu *vcpu)
+{
+    struct kvm *kvm = vcpu->kvm;
+    bool is_nv = vcpu_has_nv(vcpu) && !is_hyp_ctxt(vcpu);
+    u64 hcrx = __vcpu_sys_reg(vcpu, HCRX_EL2);
+    u64 esr = kvm_vcpu_get_esr(vcpu);
+    u64 iss = ESR_ELx_ISS(esr);
+    bool fwd = false;
+
+    switch (iss) {
+    case ESR_ELx_ISS_ST64BV:
+         fwd = kvm_has_feat(kvm, ID_AA64ISAR1_EL1, LS64, LS64_V) &&
+                   !(hcrx & HCRX_EL2_EnASR)
+         break;
...
+    default:
+        WARN_ONCE(1);
+ }
+
+    if (is_nv && fwd) {
+        kvm_inject_nested_sync(vcpu, esr);
+    else
+        kvm_inject_undefined(vcpu);
+
+    return 1;
+}

I think this has the same effect as the code above.

Cheers,
/fuad



> +
>  static exit_handle_fn arm_exit_handlers[] = {
>         [0 ... ESR_ELx_EC_MAX]  = kvm_handle_unknown_ec,
>         [ESR_ELx_EC_WFx]        = kvm_handle_wfx,
> @@ -303,6 +366,7 @@ static exit_handle_fn arm_exit_handlers[] = {
>         [ESR_ELx_EC_CP14_LS]    = kvm_handle_cp14_load_store,
>         [ESR_ELx_EC_CP10_ID]    = kvm_handle_cp10_id,
>         [ESR_ELx_EC_CP14_64]    = kvm_handle_cp14_64,
> +       [ESR_ELx_EC_LS64B]      = handle_ls64b,
>         [ESR_ELx_EC_HVC32]      = handle_hvc,
>         [ESR_ELx_EC_SMC32]      = handle_smc,
>         [ESR_ELx_EC_HVC64]      = handle_hvc,
> --
> 2.39.2
>
