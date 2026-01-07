Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06591322B61
	for <kvmarm@lists.linux.dev>; Wed,  7 Jan 2026 10:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.182
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767783011; cv=pass; b=D83AWjvbdBtyh5CEpeaK+ZZSsPLchgxmmkjk6PQTrleQEFe4vAnkxeHFC5fB4deyA9Alu8hANCDgT3nDMicRJ9XLYgKRpPzsalH52hoZwHuPNWIh4i3XmTFX4HMd83ZLdwT/STu7TUUcwouinY7dx/02hpvm4s9NvZAwDC3mK1o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767783011; c=relaxed/simple;
	bh=/1bs9t/kmUPdb9U00UsWUIKLi0vlejIXdWJfAhov7os=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QAL10xmBHTLQo0LGiuJvKq1sDzk6R+AH4uHiryQeHlWn0ZKnT067fzZGCBwvH7npmjHtdzdw6k4sJCjoAa+g9T6pMqAFlsy3TAcjNKeSfMgOSVNAXTd24pnSTwFtR/UgTGnKexos6F414E2PGQdpxwD+Qkp5osZNqIf9w2aNFO8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=U3YZVev4; arc=pass smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="U3YZVev4"
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-4ee147baf7bso331351cf.1
        for <kvmarm@lists.linux.dev>; Wed, 07 Jan 2026 02:50:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1767783007; cv=none;
        d=google.com; s=arc-20240605;
        b=JxSsQtrsZ3qv3acs1bVdMnXmtEq6Bhixr4PvjYlIU90g+NyBWqCrv1LDwaS2UfpGBj
         Npeu9DyEMIAzo9Cs2cSI4gtY2D/jfBZXFPn3DEIn/K9ORX0xwHVtXsDpo9avTKi7mxHz
         ppgUwdX8a8wqqj0G8930LYdFcRWHSzlCgJAnE6c5bfnG9KD1upKkEGaS7MUrvLvKhW82
         DhMQqKnAHYBAd4ud41DllWLP/u904SmOE/+fNAwPAMjD/hFXDKL3jh+qLKcnljb2UhNK
         NOtWMw0efJrjUtsGgGEi8fCv+07lewCuSg2W4W1X4y0qfCg9gqZX1ntIGzD6zShrG3uo
         /hiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=J9Kb3oOMS7dtZg79uYFU5rgqJ0l2yPeAHjyNaUZDKkY=;
        fh=PAHSbsKizU85g4cpswVEP14EbS8leQR7ZnQStht+ut0=;
        b=O9wh2ZJONJih7d6jK3topdVSvrTJB6soxtBRmdB4VncF5nFvmVTeb8NvByvPBvwsPm
         oGaYnBnrG7t8tYI1FQvC4DippaS4CosNbweM+VzPIRUDhq4kGceaYbrz9PMQoyqf2hnP
         9+VmKElEhkzRZESyXS2le6w1PR18K4Mc0l3C0ebVshPmTMN2iDbwAR1hbFF+ObMt0Ay0
         9iz+rUZLiQ8S6vOFsVWsmqo63Q0MtxkkFInj5b+M2MA2DVy5lX4ycixOAJMPg+tILJqE
         FV9IrZI1ILgYvtP0CGcqym+YbLEOLDZkTgtnNFcBXtE+uKSqKAvz/hrApS4kORF6zswk
         FsQw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767783007; x=1768387807; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=J9Kb3oOMS7dtZg79uYFU5rgqJ0l2yPeAHjyNaUZDKkY=;
        b=U3YZVev4Bn57Ukios9VJhnPab9v7/qogE4VqBdMrX7OM7yozhz3NZzxenlLkeQCoaz
         mXPs5YWcUMwYXN18nB+goKY7LCj+hzvwQrbbd5yH/ZDZf46oOWWfVfifABd8dhCGjs0h
         iTFI8xBmb+wWaMqg5aKevPDS4WOg4p6G83ntuXSdyT7EvmwZN3SbA1Ld0OyADMDvVJTh
         LzBpiHZkMfyCoqC/AvrvWK4k46jrNr0MNP/lYZniV0obG1vRZfJZfLp3RK7yD1oQbDGd
         v/2Kn8lBLgBHHAM0rTYRtvzS170BaKHSANqX8BNH1dtxtabgc2//q3gTrSZB8CxQnZei
         0ZIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767783007; x=1768387807;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J9Kb3oOMS7dtZg79uYFU5rgqJ0l2yPeAHjyNaUZDKkY=;
        b=chfkJwiRHmPk3VbdebSVjpNr+gkz6kPeG+a5w7RXCI9whyPq6913zVVGtDLRGb7RRy
         nPeQArksGHa4s0bXDf+DHPlLDA56RDOK/MZs+jqzLnOd7gUaEtiE1RngAkiq9l4WHXTs
         pih+sTjOxOdCWE93b8YGlyZTF9lCpSjtUTrTiMOpiw8ejKEKvP9Ipk71l/i0+iKGozlo
         NJM2GVadPm/ruRKTbiMT61dLBk9FK2NmUwji8E7Du6aXU9cZZqcGSyHO0gMVj/Vo/jqL
         eY7v/MkcDp5F74rxLNpI/fCmcHtedcGztbfkPH5t7mzVA4v2+j9dCapbj+6fo7o15BmP
         tyqg==
X-Forwarded-Encrypted: i=1; AJvYcCXNLJFcagQ5+638NRZnTgmRTcl8SSZ7Y2CxFcTUca32ik5EBSU34IDWfLZAjr68D/H8E/KPmQU=@lists.linux.dev
X-Gm-Message-State: AOJu0YzH4x4pvA1cZDGS8cRIAJQ3y3NACwJfmSKQ4qWwyGp2MQnYGFXC
	dNurWd8RiLmr/msGTNwng2qsu4fTZ7KS/r1EHJW2tAYVGSKufyOUie/Di7685lCfvMXOGDXuIgo
	dmIbGzBTaAURzSRdE/fgbrfaPsqhW0wDdA+YsQM6Q
X-Gm-Gg: AY/fxX6W4WRswwJttJBKb7Jd9txkkFuI8BCcteH4JsamzKX+mFZoXNVz1mtLvpL/Fx/
	HeVTfPo3lbnsiv0qXGOxVRCEXC0SkB6NYHEBhy8cSvpYdA8iI8IEnxkvQNeiDVUf5rOxUSNUwVg
	Kzdsv/DMM4NZQoGXDQLjWgBwfo3MXEBsBBk73PgJFvixnq/F8Kodgv6CAOPcdLUv2c2ORkWfnb5
	zSXaRGE51599/7EQGuh0SmeUSt/3PxbfGAFd17PF+jazX8RIwtJ/OlfwAPWlu5CR4jsxBGSjORf
	5J9D5QPv00rtaOg0v1KynYCb
X-Google-Smtp-Source: AGHT+IE10rh+DN78N9YiMcwVYhJscwv8cpbNaNZBCYyl495p1sfIe8xo499YH5McJSOq9oBWKGVccLjtgAYQ8/EyETw=
X-Received: by 2002:ac8:740e:0:b0:4fb:e3b0:aae6 with SMTP id
 d75a77b69052e-4ffb3ee7ca4mr7057461cf.1.1767783007011; Wed, 07 Jan 2026
 02:50:07 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260106173707.3292074-1-mark.rutland@arm.com> <20260106173707.3292074-3-mark.rutland@arm.com>
In-Reply-To: <20260106173707.3292074-3-mark.rutland@arm.com>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 7 Jan 2026 10:49:30 +0000
X-Gm-Features: AQt7F2o3m38Z6d968yzTAfqCtkyv0VzU80IdiRiSLmqPB7tJYi9cn0hpoI97f68
Message-ID: <CA+EHjTyroHqMj5nHZvcwuqO64rQO1iMbSApW8mnNarHyR0zzzA@mail.gmail.com>
Subject: Re: [PATCH 2/3] KVM: arm64: Shuffle KVM_HOST_DATA_FLAG_* indices
To: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	broonie@kernel.org, catalin.marinas@arm.com, maz@kernel.org, 
	oliver.upton@linux.dev, will@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 6 Jan 2026 at 17:37, Mark Rutland <mark.rutland@arm.com> wrote:
>
> There's a gap in the KVM_HOST_DATA_FLAG_* indices since the removal of
> KVM_HOST_DATA_FLAG_HOST_SVE_ENABLED and
> KVM_HOST_DATA_FLAG_HOST_SME_ENABLED in commits:
>
> * 459f059be702 ("KVM: arm64: Remove VHE host restore of CPACR_EL1.ZEN")
> * 407a99c4654e ("KVM: arm64: Remove VHE host restore of CPACR_EL1.SMEN")
>
> Shuffle the indices to remove the gap, as Oliver requested at the time of
> the removals:
>
>   https://lore.kernel.org/linux-arm-kernel/Z6qC4qn47ONfDCSH@linux.dev/
>
> There should be no functional change as a result of this patch.

Tested-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

>
> Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Fuad Tabba <tabba@google.com>
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: Oliver Upton <oliver.upton@linux.dev>
> Cc: Will Deacon <will@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_host.h | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index ac7f970c78830..4c8b4274f669e 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -710,11 +710,11 @@ struct cpu_sve_state {
>  struct kvm_host_data {
>  #define KVM_HOST_DATA_FLAG_HAS_SPE                     0
>  #define KVM_HOST_DATA_FLAG_HAS_TRBE                    1
> -#define KVM_HOST_DATA_FLAG_TRBE_ENABLED                        4
> -#define KVM_HOST_DATA_FLAG_EL1_TRACING_CONFIGURED      5
> -#define KVM_HOST_DATA_FLAG_VCPU_IN_HYP_CONTEXT         6
> -#define KVM_HOST_DATA_FLAG_L1_VNCR_MAPPED              7
> -#define KVM_HOST_DATA_FLAG_HAS_BRBE                    8
> +#define KVM_HOST_DATA_FLAG_TRBE_ENABLED                        2
> +#define KVM_HOST_DATA_FLAG_EL1_TRACING_CONFIGURED      3
> +#define KVM_HOST_DATA_FLAG_VCPU_IN_HYP_CONTEXT         4
> +#define KVM_HOST_DATA_FLAG_L1_VNCR_MAPPED              5
> +#define KVM_HOST_DATA_FLAG_HAS_BRBE                    6
>         unsigned long flags;
>
>         struct kvm_cpu_context host_ctxt;
> --
> 2.30.2
>
