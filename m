Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A150B367F46
	for <kvmarm@lists.linux.dev>; Sun, 22 Mar 2026 15:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774194278; cv=pass; b=MbTFSPOSO2zAkKpgijCPq/fqsYEEnJWYFriKWcywK7E/YClWT2gn9xjaKWv2SmfjZLDFC3hj4BowziTAEwjhCMUPbI0gS6mHKYlambijFKvSrIA4MHx1DgrucyD55R22JJTi2JLk25a3orF1xtXN1Li7JGZIspk/1o2yMcPEPTM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774194278; c=relaxed/simple;
	bh=qe6ufksEAl3fXYhd7OFfdXbBxI1wGaRCuq6Vve5so4w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Q5LZfs+bmhNL/dznU60XXsiQHzT8JsP0RmYiFFGV8gULC/SoDaliqcObMIlhBaDke7joAICTpr0IwMyd3m++l6JHGsI8lqXBkSOLBbGYHieiqJHY+1pCy867VP98QBL4UnCgw6kRFreT5X0Tz09mFy0usQke9w+xJ73t1do7hPQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=elOw082g; arc=pass smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="elOw082g"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-50b30d61be6so930671cf.0
        for <kvmarm@lists.linux.dev>; Sun, 22 Mar 2026 08:44:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774194276; cv=none;
        d=google.com; s=arc-20240605;
        b=YrTq6Vc4/9O0hHqxTl0CGNgJXOrfxd4N5oiNKqGB3FhRC2IIRtym8fwwLF99pZ+bt2
         HTHvSR/irEqdgBAWXBY54YPrbijfVjF3tLWAn75Q29RyAcPV0GPB6YZFCcLsWPmYw0qG
         Q5FdT8V7RhTYVgPLTQ5T38V/rqCib86AM9j9dY5Bqx/Subdbd5HtPKX1fwW5C5sMlww5
         r1NDevLefJ/bvA4ZeJdWdNQeN7UVR1fci1ZAg5Vdkh1s3hOCBU3H/U0UH6cRQ0IJ8lG8
         1ChKT1ZRRSCApBDnS2nl1w+rCtuid378HPdm+1DZI89iwG77O9WAOe0X/RHCG7Z4Nk+M
         pH2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=7g8MY1vCtLNn6W/YkPkDXFGjyD7zE3ehnXdpUQaG3r8=;
        fh=br/O7ad/Dpl82iqHQ050DMUcdTbv2XuF8/c9+X0NSgk=;
        b=e6mPJ7dVNHZayfg0Jf3e+n8NGO/L+bmncDilrkSFTroy1MhSG/ZjNNuf/0VdkyfvGt
         bAy4zKv4v7KbwTneF5JVZLJdfXfXymr4ofSyC9X4GzdN7bOIOzdfbsp8pwO9tGMbWo5x
         u+BhxGqYbhwUr65gCPEsA5RQkgb2f9Q+mMrXK9F6kT+hGudZn6O70+u1VetFEMr9FMa3
         lOUllq4CYFCcUSjDqr1e2522FwcteAr5p7xwLUiPVZa8EekCpFlQZ1v29mLVLX7sNHPA
         nAo6n9HQJG4Y7FpIKRr5s2656SWSXp7fG09uKeZvsPQdZEcno6uEZUQpuxGOJxdxq1YW
         O0zw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774194276; x=1774799076; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=7g8MY1vCtLNn6W/YkPkDXFGjyD7zE3ehnXdpUQaG3r8=;
        b=elOw082gBXyTPo9fxbfHfeOa9qscZfLSLlBEqmjYT5cj7eRLDmy0L9l3Q2m9NW6dep
         ZSVD2DecHNIjrsO3r9ufTYzLdj8Sgerf7m1KS2Qz15VuEdMxXJK2eCSTy5kQ0aMClFRM
         S4kvNXAErUcJb1cMjKnNCm5xVYY6R/SFUOdoS2sKWXcORXXyvLrF5/VzJdkNauPfKEVs
         FjTMDoQ/6lT7/dQ9SLWGLT6xRR1xQSOiFjuoS6K6RARCTTQVly24N7u4a7wcDltMo1vq
         LzF0+MEFYhvNuXTCx3M8gNhgad1ASpoKMJGkDgPAWSaT9y1Znswj3Trv4xhkLn4AGt5o
         b+IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774194276; x=1774799076;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7g8MY1vCtLNn6W/YkPkDXFGjyD7zE3ehnXdpUQaG3r8=;
        b=SU1A0kED/5SZu4XJy7nRGD7XVQDl5+6GiXBrjUlwlSmg8PiJnK89McvXJiiOBTFa1k
         tZW2wdlX/eryOPblbUchwBRJRMM3XJqexWSoBHxAKJ7gbrAJj3wEmqDlQ6nDREnGWd2T
         Ya5GRuN6jiLTRtZZoXoyGFbW6sGr9H4IbdxVBmnv1RBuSAdZ1CrDr/sPIFq35TxWVC9S
         VFVIvfJxRCetwO98Km8MP2eu490xnKul0MUWB6Qzbk1iC5lPODC3HsjuTngdCuEgnXjI
         3WQNKVMZafeaIt/vGQ00Jz4PJjrw9+C5Qcuy619TJxK5ntydRnsQMbaRPFUaNxnP9wHj
         y9sA==
X-Gm-Message-State: AOJu0Yx5U03jA6p45tOejPO/c9T8Bs0i3MHGI88GWIXJAKufIVMSUaTD
	cehQVcAfZ/+nxukL3lcLt12knjoQcRU/+2MSyvWfXNXMFl1Shxz78/ai2GnmlYa9wXaqLOUslyC
	Sr1L3emkjb1PNW7G93S+Oy/LBr0g/Phz5GbgEKa9o
X-Gm-Gg: ATEYQzxEC7YrOP02u7jFxHLTp7dqHoCMoqoOLQ4EKXBNQVKoxiBIceACHjqsX4MK0Df
	iYBBJEUAgCCMj3t95J/jFYjtSco6Iv7ynr1eOLu7Da3nFw6P/r1WJxwxNs5qdfBkDo761uJXjPc
	P1lm1ouPnw9Sbho5VkxXsY6QTA90XEVzcI0hDWkoPMHoY59TLLqLzSIp/Z25XEEa7oepb8HSMIY
	VB9d2qgtByV6o5MhUZVu+mnjEbxu1VPiRIkqopPViSv7d9gRKn7IrTCYTwaxfQkkC5n60Wnbrk9
	+mXoOIK7
X-Received: by 2002:a05:622a:8c04:b0:509:14f0:bff2 with SMTP id
 d75a77b69052e-50b46cb352cmr19351491cf.12.1774194276032; Sun, 22 Mar 2026
 08:44:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260321212419.2803972-1-maz@kernel.org> <20260321212419.2803972-4-maz@kernel.org>
In-Reply-To: <20260321212419.2803972-4-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Sun, 22 Mar 2026 15:43:58 +0000
X-Gm-Features: AQROBzD3Objm2EQkQmOztE3PUeZpkFxeB6Okjt6XWmW0dH-3UyAexaWM0HnGGdI
Message-ID: <CA+EHjTycbB1rZGALB0L1iyOkaVuH+5a5bBD0teo79YHNEE5-Pg@mail.gmail.com>
Subject: Re: [PATCH 3/5] KVM: arm64: pkvm: Turn __kvm_hyp_init_cpu into an
 inner label
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>, 
	Mostafa Saleh <smostafa@google.com>, Quentin Perret <qperret@google.com>
Content-Type: text/plain; charset="UTF-8"

On Sat, 21 Mar 2026 at 21:24, Marc Zyngier <maz@kernel.org> wrote:
>
> __kvm_hyp_init_cpu really is an internal label for kvm_hyp_cpu_entry
> and kvm_hyp_cpu_resume.
>
> Make it clear that this is what it is, and drop a pointless branch
> in kvm_hyp_cpu_resume.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

> ---
>  arch/arm64/kvm/hyp/nvhe/hyp-init.S | 15 +++------------
>  1 file changed, 3 insertions(+), 12 deletions(-)
>
> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-init.S b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
> index 55e0dce65dc56..2e80fcbff2dff 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-init.S
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
> @@ -175,7 +175,6 @@ SYM_CODE_END(___kvm_hyp_init)
>  SYM_CODE_START(kvm_hyp_cpu_entry)
>         mov     x1, #1                          // is_cpu_on = true
>         b       __kvm_hyp_init_cpu
> -SYM_CODE_END(kvm_hyp_cpu_entry)
>
>  /*
>   * PSCI CPU_SUSPEND / SYSTEM_SUSPEND entry point
> @@ -184,17 +183,8 @@ SYM_CODE_END(kvm_hyp_cpu_entry)
>   */
>  SYM_CODE_START(kvm_hyp_cpu_resume)
>         mov     x1, #0                          // is_cpu_on = false
> -       b       __kvm_hyp_init_cpu
> -SYM_CODE_END(kvm_hyp_cpu_resume)
>
> -/*
> - * Common code for CPU entry points. Initializes EL2 state and
> - * installs the hypervisor before handing over to a C handler.
> - *
> - * x0: struct kvm_nvhe_init_params PA
> - * x1: bool is_cpu_on
> - */
> -SYM_CODE_START_LOCAL(__kvm_hyp_init_cpu)
> +SYM_INNER_LABEL(__kvm_hyp_init_cpu, SYM_L_LOCAL)
>         mov     x28, x0                         // Stash arguments
>         mov     x29, x1
>
> @@ -223,7 +213,8 @@ SYM_CODE_START_LOCAL(__kvm_hyp_init_cpu)
>  1:     wfe
>         wfi
>         b       1b
> -SYM_CODE_END(__kvm_hyp_init_cpu)
> +SYM_CODE_END(kvm_hyp_cpu_resume)
> +SYM_CODE_END(kvm_hyp_cpu_entry)
>
>  SYM_CODE_START(__kvm_handle_stub_hvc)
>         /*
> --
> 2.47.3
>
