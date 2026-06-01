Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 958D62D0617
	for <kvmarm@lists.linux.dev>; Mon,  1 Jun 2026 19:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.176
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780341478; cv=pass; b=RlLeVMNcsJ7d+TEXSllsmEvhcDJ+e5eBIGPE7bYA9UZ45Gzah8pKyIkUKa7/czgILK+Ly62Ko0koY8nIeGC7GkKlFV79fonQmIg0rKa7vZJr9UqojliqnrzI/VA87DZEgWzWF9RuA4a+mp+S8k7GeS5WHRObo0CXAwqmjDMLNfI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780341478; c=relaxed/simple;
	bh=o02VBojxscEO9g7iyNbnzioUF8czSX2uobcsWTXWXio=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JoEdar3BvAyXPHPmM/RpAtyMlxF9olB1U2BKEtRxu915iMxrb3DJudZMkiqvp12yYAPup05YINYs6Ekj5MUTVY+BZHpercYKbwqq9BMF7blEmn8LLZ7oVc6lcHrNCI7G4PoDNd43+4ORbhHOF5SZJ2pvLulDqC/vKRoSjz8WMzc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EM9kXQXQ; arc=pass smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EM9kXQXQ"
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-51765531803so1301cf.0
        for <kvmarm@lists.linux.dev>; Mon, 01 Jun 2026 12:17:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780341476; cv=none;
        d=google.com; s=arc-20240605;
        b=g2iFo4A2C2r9LrMHbUTKn9J5PJi1ajTA6O8Fjm8eRGMrYjRAVgmjcb56UPkslVD3OL
         uXpe6B3UncVvjmLyum+Exan1vHFKyIlHd61/mzMXa8D62jFGr8DmMaW+4m+DCUG0gTaB
         TeXN6cv/aZ9HeQRffjFtN+iLtYozRdIhoYdI1Qbmi8T+LPKfyQrekdRD73nIDZeZufmW
         pPXaco1srCdQnV3bjGfKJs2PXX1FLs2F++9BvweVTlx1pmFlV9ROoxbVRWk7hngqLNLC
         eYtNZDz+fqeKf5YnlQkOvHooGFGmtQlfgoIzMKiXAk7yXAC6EYDtpEnDwLq4FGdX17Qy
         og+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=LI+L8RU/Qox9q/iASiRe42zZZU6YPbY4gXzweQXOL08=;
        fh=i9d0uHtKdxJKAvTYrDLv5IOgx/dvdaSVxhMJcC0s2BU=;
        b=hjRE/T7M3gfJf52zPO4rpjRYyckB/0PdDrq/7ESttNBWAut1SiAwHrGXwUn1D3lXtB
         gBHBPRktN9126NF2cKVyMbi+V+eZU8kZr10ud5iNyoI0bXspd5TZxrRogLM0KzixxTe0
         c2YRaQ7rWyDLFQyFa3Te2ZJyd5B37z5k7eNuouCJKsuqMpurMATbG7kOO4mV27tsWbHK
         8b7NnbYBeNesm+Nr7ctB55cagK3yd79ORLCCJlIGz177h25mTEJmyjn0WnrR5b1aJo6y
         DlFScjMP3ri9wug+R10t/MTppVhg7/2krLEESRe3B2TGDCKiKeAFirSh3IjDJPZLmN3v
         /GHg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780341476; x=1780946276; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=LI+L8RU/Qox9q/iASiRe42zZZU6YPbY4gXzweQXOL08=;
        b=EM9kXQXQw569pZ8HI/K6djAeLY8jEynRLF6RPCtTrfldnRi45sN8IDqzY531H5nTKI
         I7oD7dkbf5zD/VZwlzislzWj1Vl/aTmduezlkG1UrvgPe4zMMTRartypJmbelhB0TobC
         1W0yWaSTNcRwEhVlxnCkcZPwjh4GxHbS+u29G+FBUUngTIO6EykkBDYsveltnHXD6RGO
         RK4Sq6RtcNpe3iLEPxgHfQXM9skvK75nD/DZPrk47Fxdp2hqT56JU+zSuSTCi8asmm/f
         HPamjViozULsUhbzz0yFlEAzsdglhK+TawsPrab1Uwb7sp9iYUuWCqTyUTtix1D5wUqI
         poRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780341476; x=1780946276;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LI+L8RU/Qox9q/iASiRe42zZZU6YPbY4gXzweQXOL08=;
        b=D3oNIG1iICGiucz4gnIiIhh4+HCRojA4RKlQp8KATF8SnrRLFkbMGhVxwapNZvt/Tr
         6pzhtWlT7mOaIs1FzmimdI6sU3+xBhMtFcb3hkLEIxRAhzszRz7cMI2T+40+qt/e7chR
         U52eZRoKwU26q7ft5vUJSXY/ikpZmwtlRspkosPHW40O18dbIzJUeE2pTHSnaeAgAZfj
         UOxvf1ug6t3MqeUO4++im2X8gZDqwd2Vl2Vr/T2s8yM0tWmpNIScjcLzVl9WuKowJ3xk
         WNrEJ2qOYXZQSNgeBtM4DsXpHkNTNHMCOJ3myhbDvY7bMLHisz09NDg2LVeAuoFSQBQH
         24fw==
X-Forwarded-Encrypted: i=1; AFNElJ/jBYRPuWX+z3EczxqYu5Z07Vv8PCuCvGCXR/OnrD7LlRtWVs6/p5UlZkXZ6CTTKMlKIHutzLQ=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz/KGMGQE3r9kQ5za7YfPTMMgp5QMIbRlD7LEDeAui5oPK0tRNa
	hecLfUXhW3aHEl0ATlrhS/cj7HytEMg0M27IrMDO+1mTrxEQzcACwLK2AVc9y3SbTMF7mg3EPa+
	eVFC5E5Bsgx5gEWwYjbScfgSnU33NOH2aEjpc/0NI
X-Gm-Gg: Acq92OG0CfiuHSnhprxo5jaf9yXDfM4+Rt0u20W8Nwq7RmUOmDT0bCxb0ANoSzOIf0s
	Ovyp5Zt2A01lNA0L78Al2bNDvoayfd3zm618tinymZYinE6Dyt3O1KE6M0FHkrBkxkgAALavjNw
	Ri7vDrwScDNk8XC+RReT6D66jYYE8OacULh2zEvx/iOb6VQRIG9EGE4KuzP67kG3IaOla0NpBb5
	zQCrIaEp41cWcRZ8GmafvjQzVgE3ntS6ouLMWmxZwSYzHG10SYnhV8d9a3qQI9bOys2LvOINMDi
	bOu9vI6v/nm9Ma6W/Wn2W2H3XUFmOQ==
X-Received: by 2002:a05:622a:5c87:b0:517:591f:d116 with SMTP id
 d75a77b69052e-51766d32b94mr2426531cf.0.1780341475700; Mon, 01 Jun 2026
 12:17:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260531154548.1505799-1-tabba@google.com> <ah3agGh1s61HKiPG@kernel.org>
In-Reply-To: <ah3agGh1s61HKiPG@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 1 Jun 2026 20:17:18 +0100
X-Gm-Features: AVHnY4JAw4mChCz3TurVLTKFNFnjr7AvqRDIeObJ6oWYUr7X71eD3nmvJ-HzDCw
Message-ID: <CA+EHjTyLWoM6_pSzC4bqN+EKpuAtDoKOZN39B0UMR_Va5Af_XQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: Flush HCR_EL2.VSE to deliver SErrors to pKVM guests
To: Oliver Upton <oupton@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Quentin Perret <qperret@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 1 Jun 2026 at 20:16, Oliver Upton <oupton@kernel.org> wrote:
>
> On Sun, May 31, 2026 at 04:45:48PM +0100, tabba@google.com wrote:
> > With pKVM enabled, the host injects a virtual SError by setting
> > HCR_EL2.VSE on its vCPU copy, but flush_hyp_vcpu() only flows TWI/TWE
> > into the hyp vCPU that runs, so VSE never reaches it and a deferred
> > (masked) SError is never delivered. VSE is a host-owned injection
> > control, not a trap-configuration bit, so restricting the host's
> > trap-register values should not have dropped it. Flow it on entry;
> > sync_hyp_vcpu() already copies hcr_el2 back, so delivery is reflected
> > to the host.
>
> Might be worth mentioning that flush_hyp_vcpu() also forwards VSESR_EL2
> from the host since that bit is _just_ out of context of this diff :)

Sure, would you like me to respin? Or would one of the maintainers
kindly add that? :)

Cheers,
/fuad

> > Fixes: b56680de9c648 ("KVM: arm64: Initialize trap register values in hyp in pKVM")
> > Reported-by: Sashiko (local):gemini-3.1-pro
> > Signed-off-by: Fuad Tabba <tabba@google.com>
>
> Reviewed-by: Oliver Upton <oupton@kernel.org>
>
> Thanks,
> Oliver
>
> > ---
> > Not an urgent fix. I should stop running Sashiko...
> > ---
> >  arch/arm64/kvm/hyp/nvhe/hyp-main.c | 9 +++++++--
> >  1 file changed, 7 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > index 06db299c37a8..9e4a20df6409 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > @@ -129,9 +129,14 @@ static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
> >       hyp_vcpu->vcpu.arch.ctxt        = host_vcpu->arch.ctxt;
> >
> >       hyp_vcpu->vcpu.arch.mdcr_el2    = host_vcpu->arch.mdcr_el2;
> > -     hyp_vcpu->vcpu.arch.hcr_el2 &= ~(HCR_TWI | HCR_TWE);
> > +     /*
> > +      * HCR_EL2.VSE is host-owned (a pending virtual SError to inject), not a
> > +      * trap-control bit, so it must flow to the hyp vCPU alongside TWI/TWE
> > +      * for the vSError to be delivered. sync_hyp_vcpu() reflects it back.
> > +      */
> > +     hyp_vcpu->vcpu.arch.hcr_el2 &= ~(HCR_TWI | HCR_TWE | HCR_VSE);
> >       hyp_vcpu->vcpu.arch.hcr_el2 |= READ_ONCE(host_vcpu->arch.hcr_el2) &
> > -                                              (HCR_TWI | HCR_TWE);
> > +                                              (HCR_TWI | HCR_TWE | HCR_VSE);
> >
> >       hyp_vcpu->vcpu.arch.iflags      = host_vcpu->arch.iflags;
> >
> > --
> > 2.54.0.929.g9b7fa37559-goog
> >
