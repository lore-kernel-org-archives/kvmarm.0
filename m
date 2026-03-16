Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BA1B2874FA
	for <kvmarm@lists.linux.dev>; Mon, 16 Mar 2026 20:33:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773693223; cv=pass; b=YX0RpUhLKZBsC52bzIhRhji/PKS2tXD779LKt6/PRWzjKVdQKcPDCUOP4X98gqKVBOWV+mGfQ5Ng59u+3v+Hfshc9z6ggr/TWr9gSoLCClzfzO9sYRkUSUuPOe71gvmZ+8A4jmm5we6UbvAmgzXAccAVH4cAQHMUfy1fQveYRLQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773693223; c=relaxed/simple;
	bh=B8A+2MGbRQPZNOJ0F8ZpYPwo8bEsDV7aM2jQ2oYcmPA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hc6uqQYHNlay4Qh2h3wIIKvEUTlW7d80LENXNsN6qGUkfOrDpqVwaKZig4RcvM9irPBtLwV/lHqXGw25S8fVJiqWApKaddPNjWr06wWyJnAnwBmfyiZiBQd2kGRCMwBRzbWv3pCnT1GX3vY+H8pRZw89unaVpSEURpaVCSCGpzM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gyd1iJzr; arc=pass smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gyd1iJzr"
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-509062d829dso43341cf.1
        for <kvmarm@lists.linux.dev>; Mon, 16 Mar 2026 13:33:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773693221; cv=none;
        d=google.com; s=arc-20240605;
        b=hVHbfU0ItAxKE+CxsKj6NGsSqddvsbNKGIrga2FkdT5/fxGxnBvUD/ibhZln8J0SC0
         rxq14NzUwDsJ6Co/Uxe8+5offIOuSW/UTx0Vi03k7I8tYgz5J9IRpukDA/6q3iqK/f1f
         uCxgIVcuA2IIj04t7sTY8v1VD4RJdgHgMeab67tSBbUS3ASlpxPqqE3mHdFPkOKI9QO2
         VPosvWnI6dAh2mZaupFIdBSmxe/RbP3KIlUbBXb98MIUYQjQ2smXvpiaVZDXZHSU4Dc6
         aUchsSNQmFblX9ngYV9MBL7q5Yy528gs4yJsmEst9U18ol/z8CEDZM41Eip8XtTJKSs7
         4sOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=XCP75YBSVNyiC0SMnuy0JEeD8LPAxxpS81/985sICXA=;
        fh=clnHTzAvt4aYOa2Pra7MMfnGJgWCg3sy4xV9cvJ65Tc=;
        b=cyPB5esuDT/rTBmRuuY7naR7Ah3SEyuhN8gdnju4i5hzq3x2KJK5CfcwMIKbdacK5F
         LjyCFlP+0VYtTKshm7gy2n6T21f5UwhgcaZkKRVYu8/FML6bCDJnKPJdnVn8KIs2gwsT
         qzh46/0Pkj2AxSuVT0zClrQ7lWt1SGWWNCx4PzyjZH+6ECf1dlwkZLtdIOt1Hdbu6sZX
         pKtmShugM7h5qlxwP7rgZS/Dkyih7Y2ZZHn2U0HE7GlJ6ZXAWWQHcSnE38pUeaylTOcX
         rseMppJ4KBpknWkHXJBCQ4bP1M74T4BupE3jix/lxyodi4eKOo21RylG98oDYQp5Si2A
         tUGg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773693221; x=1774298021; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=XCP75YBSVNyiC0SMnuy0JEeD8LPAxxpS81/985sICXA=;
        b=gyd1iJzrE7vEKhjE0ECNOKkFKsLEK4FhBpc3jnXd5+xzWzf6fNsDAZ/qEHdJzuYcbN
         hzAlI1Tfj6lfGAu/+B41oVkGjS0BlDBP4AugIh8V71dpma8mdFgoGKKjKwi4uFfCiNJa
         fP6HbTvhWNItw84Y5z2c1tYSQtL6t/MRWh9pvyfr9I9+KBCK5M0jlRC+KscvmKnrWWNd
         o76kJDNnR/zXohpI3atdQgRorMJRKbXfWC/5G7mLwDY6vFMnJNp0MfpQdBskrqPQ6D2r
         ggMWtfuojYeiv9D7VFIc7z/Ytn+0jMXRPW+vCGwUQDK8SkS3iq4QOs5SeLbBGjpPLdRk
         Dj9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773693221; x=1774298021;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XCP75YBSVNyiC0SMnuy0JEeD8LPAxxpS81/985sICXA=;
        b=hzjCLuSbNrrhXqdcS8OJLpoV1unK1GKjEZApRG1MjPva58ovfijGK7Y1IH8ZZLTwXD
         CUad09rtrQ/Tyc9LTNgV8TeaJhIT01cW7NdCJreSBJiGRH5Dth0A4q8IH5oHGt4g9Sl2
         ThTtj2ueR2oVMim/aM3AhTlH8mmnaZT3Xm2q2XsXE8A7sPLF6TgYzdrCeZAISPADu2TR
         sm1KJnY4G+pLg454GGSicHurrKXMwhHCZrjgiPqGBAgQEd9B9geGUNZJr2dmeV3PKTQg
         1zX2cYr7a/jn8yZPA2qjlV7SScteBmpplHM2zpCMb/csrxbsnx9NOHiYWF0l6cbc3iee
         xsUw==
X-Gm-Message-State: AOJu0YxIdaoT/6haBF+s697J/LOWYADjxdabAHTaYyLlybm9+5xFuLPt
	s0OpwzdppRYIIgk0Q7WDXAL6JndHxPLwpue/yWy2/1TFGI2kyXUb8w1hJkW+LA5L1Faoz8StCJ3
	veKJ63M1NSif2TxSz+P6LpbM0+v63xBva5D5KAa7V
X-Gm-Gg: ATEYQzxbvXQvbbJiK0MKG3CASap9YQiPK9kfAtT/LnxoD3jwyIOK0vBfW5DOwOe7inD
	Ig5QZeNUROl5B24AL54RavFBjYhvjS3K6a3gs8MGecE1j6ifk8NVXukJBBBO1jSxgdqB3bOs4Y/
	yGmgYzGUy8mxnIeQoFEWL0pbrWe8Ck4Eunqb/M+OEBBXYqwlwrWw6Yp24xFOXlIt9jR310OB4Je
	N7Ht+yMJnGW9TiVgjI3qo+VDPifqg/r9zTJ3E+IzE+ejE3SPna0S7bPMZZRIcj12jkdalqRqFsA
	WVji8L+i
X-Received: by 2002:a05:622a:144f:b0:501:4eae:dbfc with SMTP id
 d75a77b69052e-5099ae2a155mr787131cf.5.1773693220799; Mon, 16 Mar 2026
 13:33:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260316175451.1866175-1-maz@kernel.org> <CA+EHjTyBtM5idopKisJf_e10aRifubtKEpbkjkEnmrOqa9-SPw@mail.gmail.com>
In-Reply-To: <CA+EHjTyBtM5idopKisJf_e10aRifubtKEpbkjkEnmrOqa9-SPw@mail.gmail.com>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 16 Mar 2026 20:33:03 +0000
X-Gm-Features: AaiRm52rszfavVOV2FIeKmV442WE5Yr4f6pDh3yfG162HvC0brQIKx6ADDRQdIk
Message-ID: <CA+EHjTy=MCgeKoi9sA_eDuiODucOdMP5m4CAciUW=rStgJggmQ@mail.gmail.com>
Subject: Re: [PATCH 00/17] KVM: arm64: More user_mem_abort() rework
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>, 
	Quentin Perret <qperret@google.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, 16 Mar 2026 at 20:26, Fuad Tabba <tabba@google.com> wrote:
>
> Hi Marc,
>
> On Mon, 16 Mar 2026 at 17:55, Marc Zyngier <maz@kernel.org> wrote:
> >
> > Piqued by Fuad's initial set of patches[1] splitting user_mem_abort()
> > into more "edible" functions, I've added my on take on top of it with
> > a few goals in mind:
> >
> > - contextualise the state by splitting kvm_s2_fault into more granular
> >   structures
> >
> > - reduce the amount of state that is visible and/or mutable by any
> >   single function
> >
> > - reduce the number of variable that simply cache state that is
> >   already implicitly available (and often only a helper away)
> >
> > I find the result reasonably attractive, and throwing it at a couple
> > of machines didn't result in anything out of the ordinary.
> >
> > For those interested, I have stashed a branch at [2], and I'd
> > appreciate some feedback on the outcome.
> >
> > [1] https://lore.kernel.org/all/20260306140232.2193802-1-tabba@google.com/
> > [2] https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=hack/user_mem_abort-rework
>
> The series in hack/user_mem_abort-rework is different from this one.
> Here are the first few patches:

And I just realized it's because they're based on _my_ patches ... doh! :D

Sorry for the noise.

Cheers,
/fuad

> 7243471061be KVM: arm64: Extract VMA size resolution in user_mem_abort()
> 3a8557ce6025 KVM: arm64: Introduce struct kvm_s2_fault to user_mem_abort()
> 9f3c0a14bbcb KVM: arm64: Extract PFN resolution in user_mem_abort()
> 98740dc5cf2b KVM: arm64: Isolate mmap_read_lock inside new
> kvm_s2_fault_get_vma_info() helper
> ea364906b626 KVM: arm64: Extract stage-2 permission logic in user_mem_abort()
>
> The first patch here doesn't appear until quite later.
>
> Cheers,
> /fuad
>
> >
> > Marc Zyngier (17):
> >   KVM: arm64: Kill fault->ipa
> >   KVM: arm64: Make fault_ipa immutable
> >   KVM: arm64: Move fault context to const structure
> >   KVM: arm64: Replace fault_is_perm with a helper
> >   KVM: arm64: Constrain fault_granule to kvm_s2_fault_map()
> >   KVM: arm64: Kill write_fault from kvm_s2_fault
> >   KVM: arm64: Kill exec_fault from kvm_s2_fault
> >   KVM: arm64: Kill topup_memcache from kvm_s2_fault
> >   KVM: arm64: Move VMA-related information to kvm_s2_fault_vma_info
> >   KVM: arm64: Kill logging_active from kvm_s2_fault
> >   KVM: arm64: Restrict the scope of the 'writable' attribute
> >   KVM: arm64: Move kvm_s2_fault.{pfn,page} to kvm_s2_vma_info
> >   KVM: arm64: Replace force_pte with a max_map_size attribute
> >   KVM: arm64: Move device mapping management into kvm_s2_fault_pin_pfn()
> >   KVM: arm64: Directly expose mapping prot and kill kvm_s2_fault
> >   KVM: arm64: Simplify integration of adjust_nested_*_perms()
> >   KVM: arm64: Convert gmem_abort() to struct kvm_s2_fault_desc
> >
> >  arch/arm64/kvm/mmu.c | 428 ++++++++++++++++++++++---------------------
> >  1 file changed, 223 insertions(+), 205 deletions(-)
> >
> > --
> > 2.47.3
> >
