Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DE0718FDAF
	for <kvmarm@lists.linux.dev>; Wed, 11 Sep 2024 12:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726056183; cv=none; b=kWsUoSZf4hOlK/73woWN8wOKUxsHZ4KcKVOQlz5eoLSp1aAJsDZsKBPz/HMzrOXdTTZWnlKFMpfhG8OjUL+7uT1LIPYoV9gSacrRvsk9ozn6BlU3QOv5tEPPvHxWWKoLqX0T3Wnmf+43Vjdk7Hgj4rD8R0gvuuQ7Lk0GQHZ0XYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726056183; c=relaxed/simple;
	bh=pvPCReOfqb0hl1N5DVnqiLi1EYUVIXYNuuNKrt8yl00=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ixSJt/V11bKuLRN1YZ1TVYt5jVAGWVlLpaTvV+gzMUqGiWJVXfnd73bQg+EOcimX/JLUS4dMzdR8jgORU5qM9zrdvo6atI9qHPiEyyJ+qpIB/tGX37ngJEe9HPZhdnwqbKxjpwc6N/BVY/qn1rKBTmqBVaa9wFsJpUlsqiF35OM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ipqH0t+r; arc=none smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ipqH0t+r"
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-5356a2460ceso47554e87.0
        for <kvmarm@lists.linux.dev>; Wed, 11 Sep 2024 05:03:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726056179; x=1726660979; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=g8+WrkrtX7z+5qAOjWhXHblXMHkXc3ydENuaRKn/RkA=;
        b=ipqH0t+rG1CfEZPWAyqm/8rnfG+DEoeEAd2Rd4p1REEjjuHtcFYtt/DgadX5MM26Bn
         fcb6Id15BMRyHHtpMcR8e83eb6FKLUhvkTaklpgDdhNNuykcJRW0k4ylA9g0j2D4XljB
         gYEfw5Ho6zOZR/WyYkGUbe8i+DBCxRSjx96tT5jErLzWCx1xvJ+wRWFfEKGgMjskH6cq
         iuXg4I1aNOYUfQybtg0q5SCD05ASLUUTR1dmof6qlxLSjeU8eKkV5hX5JxcxT3cK2WiH
         7olEQdSXlyS/d+PXBTHOz0HL+bK+1e9dl4795b5DucptbKoSfQzAZpiviAY2t7b1Da+W
         WqdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726056179; x=1726660979;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=g8+WrkrtX7z+5qAOjWhXHblXMHkXc3ydENuaRKn/RkA=;
        b=d+3IKPpD4RZ/ickw76/7Zn654B8lk08Vz2mo/3ddD0OFOYdyfR+dawZaaqdHTMO96b
         h811jRYfPwwyuMQlXgElJ8q0thWQ/V2Y1LPwnt+ILFlN/+ES1Mz82GpVxXstdZJTMYuH
         MTLPxgvrc/rV+uurJT/UWubH+MihdJbrENtpqbZ0HjJchyPu3RZcMOABXRMj60QzfM5K
         hAk7hsxBnYCTvxtfOsFz9m/aK777eancCPKPyy3crVhbIW+egT9ysSRUO8zslyjLYH9L
         rd1tR+BQtXOlgKsXUxnKgu7ZiXYCC8Q4iN4lFv0GHZ77WlTZmPrn2XmtcqTX8fCv/KY8
         h3Og==
X-Forwarded-Encrypted: i=1; AJvYcCXr14OIVNXoe00XP5ytw1tDSsRFETS7pvqbm3ldAjHIaknwaHLTvwXGdJ7+Xxw8rZ14cIYmQT8=@lists.linux.dev
X-Gm-Message-State: AOJu0YxzBXMtusHPNoPktY8TWsB0+6Ux0S+AVb/AV5PjXs08WYJ7x2Yh
	XMcJop8AuF2Xr490NhKUCZMCi6Ex8zYxy7HIrDH5UtAat9SrZOc3u38dtVdkXzj8hzIBuZVDkTg
	sexQN/Qmz4vJc6QGhfIoe2zLC2b9prodS9GNE
X-Google-Smtp-Source: AGHT+IGyiFWYQs1poeq0GVCiBhwyuLSgU3JDdcocqgqSStZELu7mBOadOBoTNT1J/cbDtILNItDbqsune6NpVx3GsmI=
X-Received: by 2002:a05:6512:b85:b0:535:68b2:9589 with SMTP id
 2adb3069b0e04-5367431fdeemr464105e87.2.1726056174422; Wed, 11 Sep 2024
 05:02:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240910-kvm-arm64-limit-guest-vl-v1-1-54df40b95ffb@kernel.org>
In-Reply-To: <20240910-kvm-arm64-limit-guest-vl-v1-1-54df40b95ffb@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 11 Sep 2024 13:02:16 +0100
Message-ID: <CA+EHjTzk6_hWFnrEiJVYZnY41qGORL7NQdV6S+cobDy+UcAR-Q@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: Constrain the host to the maximum shared SVE
 VL with pKVM
To: Mark Brown <broonie@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Dave Martin <Dave.Martin@arm.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Mark,

On Tue, 10 Sept 2024 at 21:26, Mark Brown <broonie@kernel.org> wrote:
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

I just tested this patch (QEMU, cpu max), and it crashes sometimes
when the guest after the guest has performed an fpsimd operation (pKVM
with a non-protected guest VM). I tested this patch applied to the
base patch (Linux 6.11-rc3).

The crash is triggered by arch/arm64/kernel/fpsimd.c:487
(fpsimd_save_user_state(): if (WARN_ON(sve_get_vl() != vl)) ...) ,
which ends up issuing a SIGKILL.

The easiest way to consistently reproduce the crash is with a host and
a guest both running the sve stress test (the one in the arm64
selftests).

I think the issue is that this patch doesn't cover all the cases that
are setting or assuming ZCR_ELx_LEN_MASK as the vector length.

Cheers,
/fuad



>
> Fixes: b5b9955617bc ("KVM: arm64: Eagerly restore host fpsimd/sve state in pKVM")
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
>  arch/arm64/kvm/hyp/include/hyp/switch.h | 2 +-
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c      | 7 ++++---
>  2 files changed, 5 insertions(+), 4 deletions(-)
>
> diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
> index f59ccfe11ab9..ab1425baf0e9 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> @@ -339,7 +339,7 @@ static inline void __hyp_sve_save_host(void)
>         struct cpu_sve_state *sve_state = *host_data_ptr(sve_state);
>
>         sve_state->zcr_el1 = read_sysreg_el1(SYS_ZCR);
> -       write_sysreg_s(ZCR_ELx_LEN_MASK, SYS_ZCR_EL2);
> +       write_sysreg_s(sve_vq_from_vl(kvm_host_sve_max_vl), SYS_ZCR_EL2);
>         __sve_save_state(sve_state->sve_regs + sve_ffr_offset(kvm_host_sve_max_vl),
>                          &sve_state->fpsr,
>                          true);
> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> index f43d845f3c4e..90ff79950912 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
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
> +       write_sysreg_s(sve_vq_from_vl(kvm_host_sve_max_vl), SYS_ZCR_EL2);
>         __sve_restore_state(sve_state->sve_regs + sve_ffr_offset(kvm_host_sve_max_vl),
>                             &sve_state->fpsr,
>                             true);
>
> ---
> base-commit: 7c626ce4bae1ac14f60076d00eafe71af30450ba
> change-id: 20240910-kvm-arm64-limit-guest-vl-d5fba0c7cc7b
>
> Best regards,
> --
> Mark Brown <broonie@kernel.org>
>
