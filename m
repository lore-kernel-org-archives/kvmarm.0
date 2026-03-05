Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9533B237A4F
	for <kvmarm@lists.linux.dev>; Thu,  5 Mar 2026 16:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.172
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772727263; cv=pass; b=eDncff0sFNduKUrXPMhqAihz4B8ukHTshXd76v6+qBBSpRBZUsabJF3w4bipx3NjN5oUyIQxjdvs4wNWZTDyOFFlFB48unH4r3Uznk9zNiXvYgamc0OKUmldzVU9aBNlklZlIEfCGRby9WqbRwDvHJHEey9fLcDikPp5vsxiQSg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772727263; c=relaxed/simple;
	bh=E2JN73GYFbl+ZdDy42TwPsf59BvisQzxvbwqRQGdtaU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KgSz/vsX0n7Tyr1xy5fz1y7Rig4Lo1YJmXBLJBhqeZthckbr9sVqLBmAnHwVgkWdSqdQuOLLcPdpWIH4C08Sb3acOuFV8XkAcd7HocY3GyB9wpwbL/hbbDsgmhsbMX6q29Cp7rD675ygYdcgX1VXUZ/+65/g4dDhLHOFqHD8zkY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pC6JBWLC; arc=pass smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pC6JBWLC"
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-5069a785ed2so517881cf.1
        for <kvmarm@lists.linux.dev>; Thu, 05 Mar 2026 08:14:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772727262; cv=none;
        d=google.com; s=arc-20240605;
        b=KV4lBOBTfYNLzBR/TbTLd0YO+QbC/6pry7/RRrouQCly1JQzqe8bD3tijm/d37sUTL
         GPnOQyvwwy5HUdgm04BD0GMSSjv8zEQQKPhbgLoRYYRfnGuH8kpQrIeFnBnTvp5+Ukxj
         f9JYOixtOfoOrKrVC465aTJX5OmeJdhu27KdroUvNXRRsMn8Fgy3hq/4/krZb44BdqKY
         +Qp/Xti679EEneZ65dHJLl7xtd4vaNGCFfrxvMrIy6Q5REETSBpw+N6dFwZjwwGmHcgV
         6iNIsAPQD9AeV3E31npSUSCOYcgQlMi/00cvslYj4mwVeufaF6uaGqkJR9RUoNM56jwy
         f6+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=RZX8IkznGuT8tzheZIwXF+8NCOjzDtkabhnGyWvo57Q=;
        fh=si3cbHFlePRjuWHe2neVu3XtkVcwP278FTSrmascg+4=;
        b=fL5zZzC17s1uhpqXXMknNOc07cNA1kHImJZ3aucN0FzeiwRV9+8lQ2E2q+74DMTr3I
         XtGj6T4ovPVyvVf0N4xit+oAW5cy0mGqSjTUfGSKl/sxP8hf0TKLvQUl7WLKw/qdJC4I
         bSCsWFsiy8lEfDh6kJt4rq0urs6pdAIpCwKBffoPKe6YKcXwJoUXsUTDEXOW8561NbJO
         vUOF6T/abf/KzPLtHEiX9+Frl9YmHH4SOsQ0tkki/Y19uJbBwcaMb0QOHJ/ldBzCISHH
         o04xVMMbI97CdRZy5g5YjCcSLNnIlGDI7g5oGMTueVXbtydELxoFP1ioi2XdXA5VAWIN
         PJbA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772727262; x=1773332062; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=RZX8IkznGuT8tzheZIwXF+8NCOjzDtkabhnGyWvo57Q=;
        b=pC6JBWLCOVFRl8Sj/LnMg0WeiPPBRQNWXn/tIQFKpzvqIwqXDOBA7bmpUoV2ccDIg7
         lQj0+8hvhmoDCtJXzm7uQ69Sgb9rrTPrPa1buNzpjqGrDwMirh8uvkXdoqlNDZ8McX8d
         i8fXqpUQK31wS4M3Gkl2s6+4IbL05T90OU+G2DwrK5eg2YZwkfMu7NvSZXRk4EyR2dta
         jECPA3sGUHmRVtJG60/kEkxaQDhWrnLnriJJp10LKgwUbGAGnxWOxlp5kDW1o/aHo4/q
         P5Ysu5/MkBDNM48kSNyg7DIDezY0xgOTtF/PuMMwlZA4Fnw3Nmwv4wb4fDxb2hJ0jWa3
         77eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772727262; x=1773332062;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RZX8IkznGuT8tzheZIwXF+8NCOjzDtkabhnGyWvo57Q=;
        b=hUkKe8ewtHisSFGoWqx6tqV+/ef67/5pmqpL7gJvTZl1qRpmos24yATN0N4F06Kam0
         Fzda8RThbHXw6XWJrpfake9CYoo0M6Y34u5SuSV5T0cISGJUMuL7z5tr9YVu7lAz4lWU
         RAn2+eqsjfC/3Tx72fzwZk3fWWZTW/3gR1gijydXWibLY+LFNwNHXfn6u2auRp2KCOmO
         HVYTl2kmG/eh1atnQTEpbGEGqxwzOYhjBwdARQfguakIWjRvE7X+n2sSQwgUEykHB9K3
         9Aa2nbxDsK+BEX+HcaddCszM41hStDOIp6aa7arUYXXTTD5Z0dbM9gL0TRhRyvb1bWSY
         KSmA==
X-Forwarded-Encrypted: i=1; AJvYcCVpyc3Z/IGPMbNr9Za7GtsrvF9w9rXbeD+sBUN0/mZFH+klNEHDindyYokNlSFV82unKjS0Rfo=@lists.linux.dev
X-Gm-Message-State: AOJu0YxQkouhWrwOJCPXswhnAWWU/XT4qR342os2HqTn0BmyLSHDjjI4
	Nf/6hS1LJ5llWZguqj66QHL60PHt8VetM7pre0lOzOnFv1XSWz5nZ/k/5J2sR1XpzsvaGSB4j9u
	g+50OW0jh2uYjhH0FtiBOlR27KrCigPcN5xAwLC/h
X-Gm-Gg: ATEYQzxuaWzhQ611qAOt+9hfEGp8WY2DKF3uJ70FlbE3hBeALrtNxvf6WYrGNalpmAL
	DmYomdaUabwlZaBB+YD23hwgirlTmHfPzBqHi3NBOadNuIOmbPXyNHyYXFwXJl+tTA46M4llEoO
	DkE/htZHvuC77kJSlClxyYepUGlywO0M3T4pDbWMosb2UJ9rxMIPLZjgFUAIt26F4L0Jc4+FDAv
	ql56AYOnab22yf3Uv2KwZD8Qtw74Bf8K0DIFWWTrOvamcUQI/r0Q0FPWpMiKvO7PNubyUu4KEIz
	qmTK3va2
X-Received: by 2002:a05:622a:1908:b0:501:5180:3c90 with SMTP id
 d75a77b69052e-508e78bc5a4mr10844941cf.15.1772727260703; Thu, 05 Mar 2026
 08:14:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260304162222.836152-1-tabba@google.com> <20260304162222.836152-3-tabba@google.com>
 <86ms0m6yzk.wl-maz@kernel.org>
In-Reply-To: <86ms0m6yzk.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 5 Mar 2026 16:13:43 +0000
X-Gm-Features: AaiRm50AKwVyEzy5F_vJgB74LeS4g576zBjIzkwS3u0xl1hmNy8i_O0Mvctk7UE
Message-ID: <CA+EHjTwQP=sXJ=SJE3OqByHKm7Si3S41BfuFO827_ZVwaygC9g@mail.gmail.com>
Subject: Re: [PATCH v1 2/2] KVM: arm64: Fix vma_shift staleness on nested
 hwpoison path
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, oliver.upton@linux.dev, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, yangyicong@hisilicon.com, 
	wangzhou1@hisilicon.com
Content-Type: text/plain; charset="UTF-8"

On Thu, 5 Mar 2026 at 16:08, Marc Zyngier <maz@kernel.org> wrote:
>
> Hi Fuad,
>
> On Wed, 04 Mar 2026 16:22:22 +0000,
> Fuad Tabba <tabba@google.com> wrote:
> >
> > When user_mem_abort() handles a nested stage-2 fault, it truncates
> > vma_pagesize to respect the guest's mapping size. However, the local
> > variable vma_shift is never updated to match this new size.
> >
> > If the underlying host page turns out to be hardware poisoned,
> > kvm_send_hwpoison_signal() is called with the original, larger
> > vma_shift instead of the actual mapping size. This signals incorrect
> > poison boundaries to userspace and breaks hugepage memory poison
> > containment for nested VMs.
> >
> > Update vma_shift to match the truncated vma_pagesize when operating
> > on behalf of a nested hypervisor.
> >
> > Fixes: fd276e71d1e7 ("KVM: arm64: nv: Handle shadow stage 2 page faults")
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  arch/arm64/kvm/mmu.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index e1d6a4f591a9..b08240e0cab1 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -1751,6 +1751,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> >
> >               force_pte = (max_map_size == PAGE_SIZE);
> >               vma_pagesize = min_t(long, vma_pagesize, max_map_size);
> > +             vma_shift = force_pte ? PAGE_SHIFT : __ffs(vma_pagesize);
>
> If force_pte is set, then we know that max_map_size == PAGE_SIZE. From
> there, vma_pagesize == PAGE_SIZE, since nothing can be smaller.
>
> Is there anything preventing us from having:
>
>                 vma_shift = __ffs(vma_pagesize);
>
> and be done with it?

Nope, nothing prevents that. Even simpler and better.

Would you like me to respin it?

Cheers,
/fuad

> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
