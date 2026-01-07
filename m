Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3A6F337686
	for <kvmarm@lists.linux.dev>; Wed,  7 Jan 2026 19:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767813951; cv=pass; b=RqIWJn7EMIHYVBTUrEUYOrTkl4l0WRSvLbwdxyAUDYHn4Zus8ouvVREXQeMbdNlkxYijI2R73Vmz21VsbqXmkf4Fak8UI598wUqKNginQ0wbPXNGuwsLZ6IQCEEj86EaPC7YL+mezyXBnhwZCkUfLJBkETiT4edogSsHKWXTfgk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767813951; c=relaxed/simple;
	bh=XVk3XmBWD63lnU/aMftVkJSiVIzcUinFUGBwW7jj1II=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QgkPk1mBH7+fkkmcpDjbOmaeo9noARBiS0Ob6CJ9W+stMILBPfSnX1K97O8TvS/PVL0xE26Bu8a/RYjZbRZZPVXm2yqVjxesxNvTHiE19x5ZjUfCCuDdmtu14DeeVfusIza53InibJx8l+2+s/Ig88DFwN7CyPVKmBLa94ogK2A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=URuWEW+X; arc=pass smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="URuWEW+X"
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-4ffbaaafac4so345981cf.0
        for <kvmarm@lists.linux.dev>; Wed, 07 Jan 2026 11:25:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1767813947; cv=none;
        d=google.com; s=arc-20240605;
        b=aSvZRCjMrsQ4S00tH6kQAAVnvPwvYxq5Sc9M181AwNDfdbyDY/5U5G4QC7Wo9ADQM6
         VoBKVbfodF8gXlGx/xwVb8NT7sPbRpBDQVkKcl8uRzJ7PDIqZGFCBSeDORP783T5wPx0
         756+V2JgnUestX+EcRg9HvsnZNIRPeQFOnH9YOP5zk5eKCS1dnSuMgpJDF8jopE8nQ0O
         u33Y4sJQT3imfOXZ7wQdW8L3cpGUEoxMsdm9eyqn3GbiccbfB2cGx9IQwLXsXfHwfOQk
         R/8cK3ySopTJaPjz64UD/dgk7dLrXyJrBuo44TIiVfQ1+oxIbWNCwbCEc1s/zCBCKf/l
         V6sA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=UL7Yi7Pvtp9vnv6DWf8Vlg3AdoCOpm+T6/ZVSqpBols=;
        fh=qllhbjAPpDy0/E5eYsU1GEQ4sUCzHz9k/Xvv31zyfg0=;
        b=OgcEEdFbOW2zkTWzPlepmf28SE9K86vIQhs+3K0XxzaSO7kHSROy+LEhWObESymuF5
         kDCFsFxBEbVZj35K+8GkQK5NprcTaF8XOau2aKZYhTHmDccSfZVLGlBK8sOnIwvDEtfM
         ufodM/qYnAUfiM19RYh4sANoknErqQBX2XaRSPibBWM5PXb19fyP24O1MhZIyxCWmDIc
         RdXB1D7GR+ulGaX2MgWtUcWaA3vvBrJVgf75N2K1AX+RLUM54Yl0alzaSwLMLoS8gV+8
         ml0woxOqMn77Iiq7z3mu66JBKWv5s5VQBm9hoWKqp3TZIRlgzw9p8Bb8r1sh6e3BFW+m
         ayDw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767813947; x=1768418747; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=UL7Yi7Pvtp9vnv6DWf8Vlg3AdoCOpm+T6/ZVSqpBols=;
        b=URuWEW+XXLQp8vmzuwzEmMH3d26xCBB7Yg24R2GJwVUAOAcElv1f6GvrA1U+qkFvoY
         AtpHwfGVHvrGLw/1emZkZP4HFUCIyN2P4TzZKK17yt7k6BaakDf8PyafQC9ONVkns5Lt
         HnWkxfY1RMmdIQyDs0eh3tQvX5LpUyIGjUdvJlekEUbdqNw4OoQDlSE8bVlJ78yz904L
         1uomKKm26ky8zY04hMdIkP+DsFYfBkQMNiQzlrCs8ny3iAJb8owjayWosUHz+cs6D0Dt
         Ql8YRQpez/M4QIIuA8vZILkyENMaH3B9fImxomaNSRZfrSwDDBBzJDK6e+LiGzmj4e/d
         IkaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767813947; x=1768418747;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UL7Yi7Pvtp9vnv6DWf8Vlg3AdoCOpm+T6/ZVSqpBols=;
        b=tdCgMFnlrxJKBkzN+kHNTBs29LAr4xAM60p5ZvAftMh9eXthGfDf7PvQJzYLxRg01E
         oii0RO5yfwOSRQNTNz3T1GDej31U7u3nJBLiTbl+nRZ73VvhYpoBkQgyJfOktfXOdGsW
         SKXEj+hgLCYD684Z71/E4bJLJ6UyCeQPD9OGjCvPOeq7IsZInQmNP8lk1niTThDnUsaA
         PubQvcud11flIFRBprDAvupjShxOJ803f1DQfEW/Iu1XctjzWBwDEZZkELl6uigBI1c0
         NCTCAx6/2pzhvUaRjabtmUWE5yPkuOQc8qwFgAp8okxmmchLUJvn/qP+rvpCjalzy21J
         PY6A==
X-Forwarded-Encrypted: i=1; AJvYcCUOmDlTQgcCPTQFmWCIr+E2UCrXSUU6ediEWdc2gzQ6aI1jD0qXbZHT26IjwKA9TOZ2Vj5+EZA=@lists.linux.dev
X-Gm-Message-State: AOJu0YxvSjkj+uWpe+d4UNd5yAvoexD4J3NCzE5qWlot300AlvvagJ5E
	yT6/rHjuqJX1LUKEHg8yz7/LQB/RpCtJ0y/ytsJVsPsNkoMbdSomw0w3sPSek1NZhe9Kj3Fgb92
	s1Cz5K+7VFhOL3d0ou+1Ixa2C2CSP7AmtNJvxFU4o
X-Gm-Gg: AY/fxX6Po+GKnufEPqBuulmaFycY+mFUGeDysdf3JVPJ55g/yGakIfnIlQ+TREDb/mm
	RlAGiUvF6EHQvItxzg44sut2knIMdyTkf3dIJ7HPsbOhNU3fnz4a4U4Fc4Dpx+PcN4jPMQ6yF78
	dyDYmnd1wf47tqzuZze77Vfiv0t2A1MigwPNwzYMx24uvRd5RZxOXMimWvY/Do11E6aRtKdY8C3
	BSqOyddknlE/EJ3/WBjAGPuJaHPFOfAWqxpZ+1+T7KIIayvFP3onXtzT1SWRtpovMSCTLuhH5A/
	HqU+b1w=
X-Received: by 2002:ac8:5755:0:b0:4f1:a61a:1e8 with SMTP id
 d75a77b69052e-4ffb3e21616mr16125611cf.10.1767813946629; Wed, 07 Jan 2026
 11:25:46 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251223-kvm-arm64-sme-v9-0-8be3867cb883@kernel.org> <20251223-kvm-arm64-sme-v9-3-8be3867cb883@kernel.org>
In-Reply-To: <20251223-kvm-arm64-sme-v9-3-8be3867cb883@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 7 Jan 2026 19:25:09 +0000
X-Gm-Features: AQt7F2qG7tZNiD_FEqhIhHEVb7oMgUHIgaIXPRg8ASWrsWZrjE8qelJTJPBe6w8
Message-ID: <CA+EHjTyZg=WH4GmAXzmNroAPVtRUM=LMvNWc38S4_Oh7UQi78w@mail.gmail.com>
Subject: Re: [PATCH v9 03/30] arm64/fpsimd: Decide to save ZT0 and streaming
 mode FFR at bind time
To: Mark Brown <broonie@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <shuah@kernel.org>, Oliver Upton <oupton@kernel.org>, Dave Martin <Dave.Martin@arm.com>, 
	Mark Rutland <mark.rutland@arm.com>, Ben Horgan <ben.horgan@arm.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Peter Maydell <peter.maydell@linaro.org>, 
	Eric Auger <eric.auger@redhat.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, 23 Dec 2025 at 01:21, Mark Brown <broonie@kernel.org> wrote:
>
> Some parts of the SME state are optional, enabled by additional features
> on top of the base FEAT_SME and controlled with enable bits in SMCR_ELx. We
> unconditionally enable these for the host but for KVM we will allow the
> feature set exposed to guests to be restricted by the VMM. These are the
> FFR register (FEAT_SME_FA64) and ZT0 (FEAT_SME2).
>
> We defer saving of guest floating point state for non-protected guests to
> the host kernel. We also want to avoid having to reconfigure the guest
> floating point state if nothing used the floating point state while running
> the host. If the guest was running with the optional features disabled then
> traps will be enabled for them so the host kernel will need to skip
> accessing that state when saving state for the guest.
>
> Support this by moving the decision about saving this state to the point
> where we bind floating point state to the CPU, adding a new variable to
> the cpu_fp_state which uses the enable bits in SMCR_ELx to flag which
> features are enabled.
>
> Signed-off-by: Mark Brown <broonie@kernel.org>

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad


> ---
>  arch/arm64/include/asm/fpsimd.h |  1 +
>  arch/arm64/kernel/fpsimd.c      | 10 ++++++++--
>  arch/arm64/kvm/fpsimd.c         |  1 +
>  3 files changed, 10 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/fpsimd.h
> index ece65061dea0..146c1af55e22 100644
> --- a/arch/arm64/include/asm/fpsimd.h
> +++ b/arch/arm64/include/asm/fpsimd.h
> @@ -87,6 +87,7 @@ struct cpu_fp_state {
>         void *sme_state;
>         u64 *svcr;
>         u64 *fpmr;
> +       u64 sme_features;
>         unsigned int sve_vl;
>         unsigned int sme_vl;
>         enum fp_type *fp_type;
> diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
> index be4499ff6498..887fce177c92 100644
> --- a/arch/arm64/kernel/fpsimd.c
> +++ b/arch/arm64/kernel/fpsimd.c
> @@ -490,12 +490,12 @@ static void fpsimd_save_user_state(void)
>
>                 if (*svcr & SVCR_ZA_MASK)
>                         sme_save_state(last->sme_state,
> -                                      system_supports_sme2());
> +                                      last->sme_features & SMCR_ELx_EZT0);
>
>                 /* If we are in streaming mode override regular SVE. */
>                 if (*svcr & SVCR_SM_MASK) {
>                         save_sve_regs = true;
> -                       save_ffr = system_supports_fa64();
> +                       save_ffr = last->sme_features & SMCR_ELx_FA64;
>                         vl = last->sme_vl;
>                 }
>         }
> @@ -1671,6 +1671,12 @@ static void fpsimd_bind_task_to_cpu(void)
>         last->to_save = FP_STATE_CURRENT;
>         current->thread.fpsimd_cpu = smp_processor_id();
>
> +       last->sme_features = 0;
> +       if (system_supports_fa64())
> +               last->sme_features |= SMCR_ELx_FA64;
> +       if (system_supports_sme2())
> +               last->sme_features |= SMCR_ELx_EZT0;
> +
>         /*
>          * Toggle SVE and SME trapping for userspace if needed, these
>          * are serialsied by ret_to_user().
> diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
> index 15e17aca1dec..9158353d8be3 100644
> --- a/arch/arm64/kvm/fpsimd.c
> +++ b/arch/arm64/kvm/fpsimd.c
> @@ -80,6 +80,7 @@ void kvm_arch_vcpu_ctxsync_fp(struct kvm_vcpu *vcpu)
>                 fp_state.svcr = __ctxt_sys_reg(&vcpu->arch.ctxt, SVCR);
>                 fp_state.fpmr = __ctxt_sys_reg(&vcpu->arch.ctxt, FPMR);
>                 fp_state.fp_type = &vcpu->arch.fp_type;
> +               fp_state.sme_features = 0;
>
>                 if (vcpu_has_sve(vcpu))
>                         fp_state.to_save = FP_STATE_SVE;
>
> --
> 2.47.3
>
