Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A40081A76D7
	for <kvmarm@lists.linux.dev>; Thu, 12 Sep 2024 14:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726150944; cv=none; b=DVtZKLj5+G7fuvr1cDDI3JE8hSrUp16mryFXKCoeYPzlq5C7MooDocqGgn2A3KxzYtpmegHZsMO3j96Vkvn+gj/jTLJ0IjQCQKwe6UkNUXF5BTxLEPWbDQU97uGmOzhm2SIVJgsf6yT58mS6xTfb/RnAS3reQ5BZJz6zBxEH11Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726150944; c=relaxed/simple;
	bh=wjbYL2Xn5q39ZUu2R2/TS92BlULoVl0GkzrND1hKir4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bNe49mkh/obSmrxR+BfeqsB4DCzX0IyMbb4/Ut87Ev9KrH21keEp7Q4jJjvmQqeMDjesgJg94Bo6uyX0EDvgbe28fzwqTP3BXxNt04HQRBiuOE7yt/Qx1Ytw67oIpM45WalUIpB/gDbGgvcqz5IWCdqr8VxhSBm2bmrib6LurCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=R4GqPkJV; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="R4GqPkJV"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-5c247dd0899so16665a12.1
        for <kvmarm@lists.linux.dev>; Thu, 12 Sep 2024 07:22:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726150941; x=1726755741; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=vPVa+TxePmfNOKyBF++5A+N++QA4GdG9hxLFcALU9M8=;
        b=R4GqPkJVvtULziTXpIvPuknmVSqQp6HLOEkL+tx5B2Uu1MTFUGeI6uoNY/0rmZhXFI
         tJQUTX3zHsePUTQw/KWsV+nWOMDBBQ5Edqs53pmlm98p9fgrZAEGwCAW8vp0DgGkmwPI
         npr4KYt5h8ZLY4XwkYOfSBwLjTSIaJuc+6KmQZtGfeboPqaT84ddJt2Ez7ZyoONebsp7
         Hx1AQQOYVh1h6D/pEznzwsN8I5FGjzsDCFIT9T9kehg3nL3HEeV/NU40iD+1tQpG63uO
         IpSP8A47RzDt6QnOgeLyx8cvAGgnEAnWja34FX308sRKqdGOsag40DhH4CxNiQxpUNeo
         XoTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726150941; x=1726755741;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vPVa+TxePmfNOKyBF++5A+N++QA4GdG9hxLFcALU9M8=;
        b=YCAfhYFwnBMeqSkG9h8VXlDiYYBGRZy4hmW+2l3+CF7feMWmqhFeSIAC8Oq1IOEuk5
         3cbFqG6NBpAtYUNXCD9pJ7Oq9qcYfgbJ2Kuh35TPq+eY8Jr4dr1KTFjGkslzJrqwesHT
         Nptay8rS3v57M9jmTyVZsaJejdP1QFTmTqiBS8wJaG9EDOFt5mJPkeitu5/zYUb+HuHi
         TJ1PsMS3HdECTXK40UWV4A7c3aCGhjAdDRbyjyItqORxi5ZXkLA662KNoVtzw1RO7B4s
         ceA5xYjfy46vVhFpizqo/6839zypKi2pzGMVAG2nktMcySoYygBgGSl4tlNRvFcmb3tc
         mIjw==
X-Forwarded-Encrypted: i=1; AJvYcCVDanOiI15zRuG6nWbi4lGooZbXqg9RALcK+TQUe29H8eIwP1X62UbOV+aEtRl5P7zgYmAP3K4=@lists.linux.dev
X-Gm-Message-State: AOJu0YyvHhBmxAX7NZsobkyu2bFDJbk9Vlg/yhqS0+3Nq9o/jzU23Lh8
	aYqCfX/oXDjwaa3O6QJWcK/p+SzGy4M0z1F3NZP0OvXYiGtga2TiVH7P4Q6CfLrQcBUKwvgKBT/
	DROefRgwmT4U5YXzHu4sSF0Y43VrjkdaBhvHR
X-Google-Smtp-Source: AGHT+IEa6Hzh8iplc2O4j6MAuHsPrz3gwMtJo4QDDed36sqLtaIyvZNgtfYHMunzORQAJFT/1HqMx5ok1MkSOReqCEc=
X-Received: by 2002:a05:6402:35cd:b0:58b:15e4:d786 with SMTP id
 4fb4d7f45d1cf-5c415dd2e59mr386985a12.5.1726150940497; Thu, 12 Sep 2024
 07:22:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240912-kvm-arm64-limit-guest-vl-v2-1-dd2c29cb2ac9@kernel.org>
In-Reply-To: <20240912-kvm-arm64-limit-guest-vl-v2-1-dd2c29cb2ac9@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 12 Sep 2024 15:21:43 +0100
Message-ID: <CA+EHjTyJcP0NcvhF0WeuF9_zuFSa1o7w8tA5J2eU=GutF+ZmRA@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: arm64: Constrain the host to the maximum shared
 SVE VL with pKVM
To: Mark Brown <broonie@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Dave Martin <Dave.Martin@arm.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Mark,

On Thu, 12 Sept 2024 at 12:39, Mark Brown <broonie@kernel.org> wrote:
>
> When pKVM saves and restores the host floating point state on a SVE system
> it programs the vector length in ZCR_EL2.LEN to be whatever the maximum VL
> for the PE is but uses a buffer allocated with kvm_host_sve_max_vl, the
> maximum VL shared by all PEs in the system. This means that if we run on a
> system where the maximum VLs are not consistent we will overflow the buffer
> on PEs which support larger VLs.
>
> Since the host will not currently attempt to make use of non-shared VLs fix
> this by explicitly setting the EL2 VL to be the maximum shared VL when we
> save and restore. This will enforce the limit on host VL usage. Should we
> wish to support asymmetric VLs this code will need to be updated along with
> the required changes for the host, patches have previously been posted:
>
>   https://lore.kernel.org/r/20240730-kvm-arm64-fix-pkvm-sve-vl-v6-0-cae8a2e0bd66@kernel.org

Thanks for fixing this.

One part that you haven't changed is setting ZCR_EL2 during el2 setup:
arch/arm64/include/asm/el2_setup.h: .Linit_sve_ : lines 290/291

I guess at that point it's not straightforward to figure sve_max_vl.
Is there a window after el2 setup where we might actually get the VL
implied by ZCR_ELx_LEN_MASK, or would it always get set to
sve_vq_from_vl(kvm_host_sve_max_vl) - 1 ?

That said, this passes the sve-stress test now: tested on qemu using
nvhe, pKVM non-protected guest, pKVM protected guest (the latest with
patches not upstream yet).

Assuming that the current code in el2_setup.h is fine as it is:
Tested-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad



>
> Fixes: b5b9955617bc ("KVM: arm64: Eagerly restore host fpsimd/sve state in pKVM")
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
> Changes in v2:
> - Update all places where we constrain the host VL, not just those where
>   we save and restore host state.
> - The value written to the register is 0 based, not 1 based.
> - Link to v1: https://lore.kernel.org/r/20240910-kvm-arm64-limit-guest-vl-v1-1-54df40b95ffb@kernel.org
> ---
>  arch/arm64/kvm/hyp/include/hyp/switch.h |  2 +-
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c      | 12 +++++++-----
>  2 files changed, 8 insertions(+), 6 deletions(-)
>
> diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
> index f59ccfe11ab9..c2cfb4d6dc92 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> @@ -339,7 +339,7 @@ static inline void __hyp_sve_save_host(void)
>         struct cpu_sve_state *sve_state = *host_data_ptr(sve_state);
>
>         sve_state->zcr_el1 = read_sysreg_el1(SYS_ZCR);
> -       write_sysreg_s(ZCR_ELx_LEN_MASK, SYS_ZCR_EL2);
> +       write_sysreg_s(sve_vq_from_vl(kvm_host_sve_max_vl) - 1, SYS_ZCR_EL2);
>         __sve_save_state(sve_state->sve_regs + sve_ffr_offset(kvm_host_sve_max_vl),
>                          &sve_state->fpsr,
>                          true);
> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> index f43d845f3c4e..dd1c6aa907a2 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> @@ -33,7 +33,7 @@ static void __hyp_sve_save_guest(struct kvm_vcpu *vcpu)
>          */
>         sve_cond_update_zcr_vq(vcpu_sve_max_vq(vcpu) - 1, SYS_ZCR_EL2);
>         __sve_save_state(vcpu_sve_pffr(vcpu), &vcpu->arch.ctxt.fp_regs.fpsr, true);
> -       write_sysreg_s(ZCR_ELx_LEN_MASK, SYS_ZCR_EL2);
> +       write_sysreg_s(sve_vq_from_vl(kvm_host_sve_max_vl) - 1, SYS_ZCR_EL2);
>  }
>
>  static void __hyp_sve_restore_host(void)
> @@ -45,10 +45,11 @@ static void __hyp_sve_restore_host(void)
>          * the host. The layout of the data when saving the sve state depends
>          * on the VL, so use a consistent (i.e., the maximum) host VL.
>          *
> -        * Setting ZCR_EL2 to ZCR_ELx_LEN_MASK sets the effective length
> -        * supported by the system (or limited at EL3).
> +        * Note that this constrains the PE to the maximum shared VL
> +        * that was discovered, if we wish to use larger VLs this will
> +        * need to be revisited.
>          */
> -       write_sysreg_s(ZCR_ELx_LEN_MASK, SYS_ZCR_EL2);
> +       write_sysreg_s(sve_vq_from_vl(kvm_host_sve_max_vl) - 1, SYS_ZCR_EL2);
>         __sve_restore_state(sve_state->sve_regs + sve_ffr_offset(kvm_host_sve_max_vl),
>                             &sve_state->fpsr,
>                             true);
> @@ -479,7 +480,8 @@ void handle_trap(struct kvm_cpu_context *host_ctxt)
>         case ESR_ELx_EC_SVE:
>                 cpacr_clear_set(0, CPACR_ELx_ZEN);
>                 isb();
> -               sve_cond_update_zcr_vq(ZCR_ELx_LEN_MASK, SYS_ZCR_EL2);
> +               sve_cond_update_zcr_vq(sve_vq_from_vl(kvm_host_sve_max_vl) - 1,
> +                                      SYS_ZCR_EL2);
>                 break;
>         case ESR_ELx_EC_IABT_LOW:
>         case ESR_ELx_EC_DABT_LOW:
>
> ---
> base-commit: 7c626ce4bae1ac14f60076d00eafe71af30450ba
> change-id: 20240910-kvm-arm64-limit-guest-vl-d5fba0c7cc7b
>
> Best regards,
> --
> Mark Brown <broonie@kernel.org>
>
