Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70C5D405C30
	for <kvmarm@lists.linux.dev>; Wed, 17 Jun 2026 13:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781703087; cv=none; b=XEcN/LsLPlauxas/FqwbL2qltDCCVhJalvm04/nA0ECGerM2lhbKSWXcBO9ui6g4MVIpibEJw+f3ftqZsQzFnFuB0zGkHiFd1NMlcriK4stxXHO3I1BTWS5ZHjCbrTIdJyKJCrZizW1B0Qqnp4u+DWes8h+cR7nMWf2IhETdf+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781703087; c=relaxed/simple;
	bh=xQCt05CjB7ek5aUtSrtBSmFmtLmzXUwvTuLLQdFVE0E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NT004ug9KX3xY4e7l2YsDMnEDduK4Mj2cgWj/xYWfFBeOdlqPnSCbn5YCTKIbxLrjnDMnxrqC5O2HsXLZWNUKJKVef81B51K8/GzA8k2ZvFrk9h7WgQa3m0zJk2eFlCE40Ut76pWN5yTAju+ZwrPg/mG9ehMMzft2E0QT3vkexo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=haIPCAWM; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="haIPCAWM"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-6954810cfefso1427900a12.0
        for <kvmarm@lists.linux.dev>; Wed, 17 Jun 2026 06:31:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781703085; x=1782307885; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JehmYEYTvH3+KOoQ+zQz5tmrxZTR4p7Nh8L3WHEpuvc=;
        b=haIPCAWM+pAQDXVQLN5/DL+byZS1RBdrWKvuP1UlnhXW/3UWrYt8k1Sj02sApSSJh/
         PA6SHj0Wzds4WfDPeflb8Ct+t1DnLoB+mTJGWWYPKuFkv38+IPaeTgm/hZ6p7EnOCPmx
         ZaUKb/+SlduHA+e2zf6S6pcfuPci1P5Mgr7wvi2WtrJ8HSh2j9AAwFx1Qvczxs/33Y1N
         M8OrhleCt9M35xR+8aE6Njf9fGcRhu9bk/JXrXOOOlKxlFC7kfFQ7UaL3opkz+OSGgYk
         gCYDmGnMX2aCoyeaO5VLD41zVofxM1vZ3CC4RpD0ZLyPg/sNKwYb2O/ZKjwW6GuiiNJc
         pSQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781703085; x=1782307885;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JehmYEYTvH3+KOoQ+zQz5tmrxZTR4p7Nh8L3WHEpuvc=;
        b=FB31NH2W+lI00KOyJ/5f4Ju+NdFDLnDeGnliTRyz99BZsICkU7PV1u2/KDwjKCGiO3
         wOHEjekfNUlVetFlxsMk4dkTABgsK1HTZUOJ5DMmmBP5qSn8nJIaQrI7pg8bPPYtOcXj
         vGd03Q3y0vJQP2pyksItDlRxF4ad0pz2N+o2CzIbSfmjsPYn81XxI3d+00mYxs/vQ/yO
         8CPeFgm4fph+g/jvi/JW3UWUEdkSBat/tDaBrz2GwzWhECa42SKg9z5AdBUP5wpLnHjd
         FoYbWUBOi2Fc3Am5lgOAm1koMTx0/3Mh6kb7bvQssFX7N6W3pqPfBicPPNtyPNvmy9Ct
         q6Pg==
X-Forwarded-Encrypted: i=1; AFNElJ+rm8OPJKa4Xu9Yli/qgr93LgWnAZMaW1i0qHocCN2UDBJCHogCUdsVLQVXEC/2WF1ML2UaMeI=@lists.linux.dev
X-Gm-Message-State: AOJu0YzqCNIyPyBwbgKGODpxc/O60SyPPpc0CB44oR1eV43z583tFz4W
	zCgKuPC2fF2hM+Jg/Uxfda/VfW0bnUkXe8ckcdaypwW+TjQeVpouXTPVWJ3/4F/eDQ==
X-Gm-Gg: AfdE7cmlbc4MwZDUn04nvbDjoYs7Szif4oCZgN3ZBu4Zwr9ZsPRKTI/TeiE/3wb5rTj
	fN39/C/+jBHHI65tkhsi8dGnia4X9NBnWDTF5NJ5YiyaIYhWxva9TLQBwtXNnKp9NwS1m6WQJxh
	FEwWtS2I4mBDrqVWI8h9hOSO16G4QzimUFy8KAvZ1397B72FeoRjin8rGXlJZgARJzwJypHQ0ua
	nbDbhpfvr/jXgO6nXYspQKqJasEE8+h0mnbJxyRZCD+j1SSTCJydyP1BPnW5hP9cvtRcPo5XH2e
	gNN5Kjtx4KoF2vkbuS98hL4fPaCiCspVcNSnSw1NEXR0jPnFG7pO3vdLXbLNJ/w6MrBr+GaxsKI
	lREul2vhzWfc0qCp5FtWu8nMhTMgsu3tTAfV6wK9+Bl2K8EvjGCf1+ClRc5DEKVi46Dy1hxFFGh
	lrvBTy8OWY3/beYja5+hh4k8BSzifREBrypBffRTps5ZyiKGIFv6t0REKTTO4IMo+Z1nQ=
X-Received: by 2002:a05:6402:848:b0:68f:cca5:d9e7 with SMTP id 4fb4d7f45d1cf-69547463699mr2153169a12.27.1781703083904;
        Wed, 17 Jun 2026 06:31:23 -0700 (PDT)
Received: from google.com (135.91.155.104.bc.googleusercontent.com. [104.155.91.135])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6937938a145sm6879295a12.15.2026.06.17.06.31.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Jun 2026 06:31:23 -0700 (PDT)
Date: Wed, 17 Jun 2026 14:31:19 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Fuad Tabba <tabba@google.com>
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	kernel-team@android.com
Subject: Re: [PATCH] KVM: arm64: Add missing hyp_enter when trapping sysreg
Message-ID: <ajKhp-R01iaEL8XX@google.com>
References: <20260617095238.1530121-1-vdonnefort@google.com>
 <CA+EHjTz2Hc-mCA4Q0ayw0KV6KJ9_-qN5oPahVqMeKKUs93xtZQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTz2Hc-mCA4Q0ayw0KV6KJ9_-qN5oPahVqMeKKUs93xtZQ@mail.gmail.com>

On Wed, Jun 17, 2026 at 11:28:11AM +0100, Fuad Tabba wrote:
> On Wed, 17 Jun 2026 at 10:55, Vincent Donnefort <vdonnefort@google.com> wrote:
> >
> > Add a missing hypervisor event call for hyp_enter on sysreg trapping,
> > causing an unbalanced hyp_enter/hyp_exit.
> >
> > The enum hyp_enter_exit_reason is not ABI, so we can keep the ERET
> > reasons at the end for clarity.
> >
> > Fixes: 696dfec22b8e ("KVM: arm64: Add hyp_enter/hyp_exit events to nVHE/pKVM hyp")
> > Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
> 
> One thing that caught my eye (as Sashiko would say: pre-existing, not
> introduced here), __hyp_enter_exit_reason_str() relies on positional
> correspondence between strs[] and enum hyp_enter_exit_reason, with no
> compile-time check. Inserting a new value in the middle of the enum
> (as you do here) silently shifts all the strings after it if the table
> isn't updated in lockstep.
> 
> A BUILD_BUG_ON(ARRAY_SIZE(strs)...) would at least catch size
> mismatches; catching ordering bugs is harder without per-entry
> initialisers like [HYP_REASON_SYS] = "sys".

Both are declared in a different file. You're correct this would be less error
prone to define [ XXX ] = "xxx". Perhaps I should convert that later.

> 
> Something for a future patch, for now:
> 
> Reviewed-by: Fuad Tabba <tabba@google.com>
> Tested-by: Fuad Tabba <tabba@google.com>

Thanks!

> 
> Cheers,
> /fuad
> 
> 
> >
> > diff --git a/arch/arm64/include/asm/kvm_hypevents.h b/arch/arm64/include/asm/kvm_hypevents.h
> > index 743c49bd878f..5f6e6789d121 100644
> > --- a/arch/arm64/include/asm/kvm_hypevents.h
> > +++ b/arch/arm64/include/asm/kvm_hypevents.h
> > @@ -12,6 +12,7 @@
> >  enum hyp_enter_exit_reason {
> >         HYP_REASON_SMC,
> >         HYP_REASON_HVC,
> > +       HYP_REASON_SYS,
> >         HYP_REASON_PSCI,
> >         HYP_REASON_HOST_ABORT,
> >         HYP_REASON_GUEST_EXIT,
> > diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > index 06db299c37a8..45a4abb9619d 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > @@ -913,6 +913,7 @@ void handle_trap(struct kvm_cpu_context *host_ctxt)
> >                 handle_host_mem_abort(host_ctxt);
> >                 break;
> >         case ESR_ELx_EC_SYS64:
> > +               trace_hyp_enter(host_ctxt, HYP_REASON_SYS);
> >                 if (handle_host_mte(esr))
> >                         break;
> >                 fallthrough;
> > diff --git a/arch/arm64/kvm/hyp_trace.c b/arch/arm64/kvm/hyp_trace.c
> > index c4b3ee552131..c84434e2349a 100644
> > --- a/arch/arm64/kvm/hyp_trace.c
> > +++ b/arch/arm64/kvm/hyp_trace.c
> > @@ -398,6 +398,7 @@ static const char *__hyp_enter_exit_reason_str(u8 reason)
> >         static const char strs[][12] = {
> >                 "smc",
> >                 "hvc",
> > +               "sys",
> >                 "psci",
> >                 "host_abort",
> >                 "guest_exit",
> >
> > base-commit: 8cd9520d35a6c38db6567e97dd93b1f11f185dc6
> > --
> > 2.54.0.1136.gdb2ca164c4-goog
> >
