Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8582B3A1E80
	for <kvmarm@lists.linux.dev>; Thu, 15 Jan 2026 16:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768493719; cv=pass; b=IYsAzgbsNInmFEOVTuZZLcxC/0RGbitVR5PNLnn7XYZWmQ2iQQQJcWwYSu0a0s1t1arQAACYxazFGdDY+B54tV6pIyh18qCgU4+59GcEqs8oDYuiETwurTXp/Cv5zXpr0yp1V2688miZ8X3MbvyoEjtXhrIVadgrVFka+a+9MC8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768493719; c=relaxed/simple;
	bh=OgKV/SrKDyJzOK7sj2rTAppif8APJBAND6WSenJ0P7w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=e0nPOEPI6e93XIAMy+0uodHMoTwmWYYbn+IqrIyrqvhftyU8KAzW0+PXKuK4T2Hi9lBpxwczuefTpLR7ZXYfgK9BlssUjoIGTtzF5fM1XNIBElViAOgfrzKmdgCao6LQR/15LyPqTFLgPcOY4JFACR7uYYBrmgzpSa/EM0TzI10=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WVclsZeG; arc=pass smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WVclsZeG"
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-501511aa012so596121cf.0
        for <kvmarm@lists.linux.dev>; Thu, 15 Jan 2026 08:15:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768493717; cv=none;
        d=google.com; s=arc-20240605;
        b=WcOlGKcBtH4SiwXnsUp8lHyLFCI0udFBNcbs0+EXa0toH2UrwT3kQPydIZ5+IgB1CC
         uJd6gA5VHb/lHEXlCOY6lmn8H4Li0DETRb4Rrjd1cs5p7kHZjPwMWuOaTsNKRyBoEzkt
         3605rZuqHFSl2dZZ0TrVF5e156wybmKwISdLrNp6BG69rC/JMPa4RjVod0cihnqVpT5J
         BvyWk8vPa0TP1SKUzLZZIKWdHBcn4tvex/mCY9OX7vuBDPY8NThW+99sZV06P0AAIP57
         bh8972pPRskwId2Wrx8azP821n1jWyx0wZEc0i5C1mBLAtuhm+aR95ZQxCLcavn7NNN2
         hXyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=ADZclYBOIi/AqOnvkqBKuIp0Ei0sTC2tGmNVMMOBzb4=;
        fh=vxg7jDbV4KUkB1p2dijbmgxOcCsnV64udQg+GHT6RZo=;
        b=P9wsIKpFnLCRh0BHOM6P+Us/s+UYkj70tCZLUh5MsZEngO/TlDSHQo5H9Oxu+qFtAN
         BRkxaTz1nSRkCLWufwUtqbuI/n9SCOuXkvyvPCkBkLUEJZFvQARSwP7UbDnagrqesi9N
         YM8nhYsA2aSRS6n0Ykug2Tix2NHMb1N+PH8nlGCJVOJAs4LiGXdgC2JYwOslAUFQko/q
         Qf3O+mowlZ5k+jYPTdocHK+rsaDkIlehjnTsx/qrBCYO14Tz6k3XfM63q7mpVZKCYacc
         17SoeElfCoMdTQ75yayv3BtBuX1lP+6w5f/qqoOQKny0ByW2r++o7Ps+XakWPKJj7Lp+
         WNQg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768493717; x=1769098517; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ADZclYBOIi/AqOnvkqBKuIp0Ei0sTC2tGmNVMMOBzb4=;
        b=WVclsZeGeMAzzlNtLX9iKhgj5W0tkKMs5BAdzIFRrPVRPykG/SJdIJSccfSEW8fIEH
         Tpr1MSyHX5T6FI+rUA3bLE5oE0GK/6K5iAVjU3z0l+LOzenQHKwyjzO49Q0tGOyzpBfo
         PYxpeCGUetwDXiZ2BjITHh7fjea0hJD0OEDIjdh9rD74+kMGD1JDsKqwxqEnQ/GJpC0u
         4LfKbImMrBrPl5LzR8SrgAu1Zpo1oqqzwpG1F0rRz/+xbKLA6mDmhs8zuZsVygq4Ivlg
         YC96Y4CCklEB1+U3yQfgw9pHHSMbVnBuCc3HCenUa2I1DE4umpAbxNqYRNhWX83udJaz
         yxFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768493717; x=1769098517;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ADZclYBOIi/AqOnvkqBKuIp0Ei0sTC2tGmNVMMOBzb4=;
        b=AZf93ayzHxd+U8gJUs+Fe6td51revGq9nEkcfPHnD3Ou7aci2yUojXHoJaPk66Wi8G
         wjUwh9YYztP9TlgMlC1BUpAGji6BjjavL69P6HOawCZWepC+JQp8LxPTbTK8YCHngoE6
         MB5Otj9cn3QXRZrCpwiacytnHpatkExnSKsagcYvu4CT/auVavSIb9/95s2/T1Xpg9VS
         /qa3nlr/wAJdoYxHspQrvKDFHLFX95nH0gMIkXE3D3tQhV8GAGbJpXUC7a0wswEC7Rx+
         7exoWNd7qIuylwAtuOUlaL5woqHgbD87s37+qwJ/X8U33QyBvHZLTH1BT1/AVdKhmu0j
         pxMA==
X-Gm-Message-State: AOJu0YyTIp2/cfUhyfMYi6MKI7Y2a9CKD7ttUyJMWuGfhJ7SaCrMv4jB
	vuf+EpbUeHNUMUtaDfuHIVpnJX2TkXCbE7OI57dS+akTHItsoXDke8vr5PSjYL20cNjf38QfWgQ
	ilMT+FCN9Lpw/A9Lv3tnjR5vTol6ewErF/FKH4hkTYhCbQhru87rR8/8aWvI=
X-Gm-Gg: AY/fxX6yz935hhtTQnMpokIVKxF16EzCIfYYzTfc81FXIvkXSU4/6sT2a20kQaKhO3S
	1jbt4FSiL+0xB8IM7AQ4oh2DDLS+yzjSCjjQgRs8BHX34WqXlEiX77f7st1VlV1cJaB9MPyRG+9
	oyC3ylbzUWF/K+ArCg5obeCz8WCfHLG8uQRHhnH69rpvxN+b0F7HyQvhvX1hCkzHYYb7wXJFKb5
	jHcBMYXEK1lO8tdnoOWr+sKDdSZztjx+j+x+xqxIJvuTDdgSNUXta/GKzpWh/n7qHiTCy2R
X-Received: by 2002:a05:622a:1990:b0:4fb:e3b0:aae6 with SMTP id
 d75a77b69052e-5026ecd9f86mr9214711cf.1.1768493716769; Thu, 15 Jan 2026
 08:15:16 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251211104710.151771-1-tabba@google.com> <20251211104710.151771-9-tabba@google.com>
 <86h5smlxyo.wl-maz@kernel.org> <CA+EHjTzEtPta5VHr5R0r0v7ui7-8xv5me29uk2devZ=S14RHqw@mail.gmail.com>
 <86fr86lv3d.wl-maz@kernel.org>
In-Reply-To: <86fr86lv3d.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 15 Jan 2026 16:14:39 +0000
X-Gm-Features: AZwV_Qjxkf37x4xlkb_vNXX6DSUwpmJb6vgEZyD9bK2AvVgSh62ISFpVaKTdQlM
Message-ID: <CA+EHjTwX-kDg24LMHCyMVP3Xpdpv55WyP2AxeWXa5CKk1yyudQ@mail.gmail.com>
Subject: Re: [PATCH v6 8/9] KVM: arm64: Check whether a VM IOCTL is allowed in pKVM
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	oliver.upton@linux.dev, will@kernel.org, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	vladimir.murzin@arm.com
Content-Type: text/plain; charset="UTF-8"

On Thu, 15 Jan 2026 at 16:05, Marc Zyngier <maz@kernel.org> wrote:
>
> On Thu, 15 Jan 2026 15:19:48 +0000,
> Fuad Tabba <tabba@google.com> wrote:
> >
> > Hi Marc,
> >
> > On Thu, 15 Jan 2026 at 15:03, Marc Zyngier <maz@kernel.org> wrote:
> > >
> > > On Thu, 11 Dec 2025 10:47:08 +0000,
> > > Fuad Tabba <tabba@google.com> wrote:
> > > >
> > > > Certain VM IOCTLs are tied to specific VM features. Since pKVM does not
> > > > support all features, restrict which IOCTLs are allowed depending on
> > > > whether the associated feature is supported.
> > > >
> > > > Use the existing VM capability check as the source of truth to whether
> > > > an IOCTL is allowed for a particular VM by mapping the IOCTLs with their
> > > > associated capabilities.
> > > >
> > > > Suggested-by: Oliver Upton <oupton@kernel.org>
> > > > Signed-off-by: Fuad Tabba <tabba@google.com>
> > > > ---
> > > >  arch/arm64/include/asm/kvm_pkvm.h | 21 +++++++++++++++++++++
> > > >  arch/arm64/kvm/arm.c              |  3 +++
> > > >  2 files changed, 24 insertions(+)
> > > >
> > > > diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
> > > > index 5b564576160d..0fa8c84816fd 100644
> > > > --- a/arch/arm64/include/asm/kvm_pkvm.h
> > > > +++ b/arch/arm64/include/asm/kvm_pkvm.h
> > > > @@ -9,6 +9,7 @@
> > > >  #include <linux/arm_ffa.h>
> > > >  #include <linux/memblock.h>
> > > >  #include <linux/scatterlist.h>
> > > > +#include <asm/kvm_host.h>
> > > >  #include <asm/kvm_pgtable.h>
> > > >
> > > >  /* Maximum number of VMs that can co-exist under pKVM. */
> > > > @@ -43,6 +44,7 @@ static inline bool kvm_pkvm_ext_allowed(struct kvm *kvm, long ext)
> > > >       case KVM_CAP_ARM_SVE:
> > > >       case KVM_CAP_ARM_PTRAUTH_ADDRESS:
> > > >       case KVM_CAP_ARM_PTRAUTH_GENERIC:
> > > > +     case KVM_CAP_ARM_BASIC:
> > >
> > > Can we instead rely on an existing VM capability? I'm not overly keen
> > > exposing something new to userspace (KVM_CAP_ARM_BASIC) for something
> > > that really is KVM's own internal problems.
> > >
> > > Looking at the history, a bunch of things have always been present:
> > > KVM_CAP_NR_VCPUS, for example. You could even #define
> > > KVM_CAP_ARM_BASIC to that if you want.
> >
> > I wasn't too crazy about that either. I like the idea of defining it
> > as an alias of KVM_CAP_NR_VCPUS. I'll do that when I respin.
>
> I've done something [1]. If that works for you, let me know and I'll
> just merge that.

That works for the previous patch (7/9), which is where you've made
the change. But since the alias is defined in `arm.c` it wouldn't work
in this patch (8/9), because the function kvm_pkvm_ext_allowed() is
defined in  `asm/kvm_pkvm.h`. Defining the alias in `asm/kvm_pkvm.h`
or in `asm/kvm_host.h` should solve this, since both files are visible
in arm.c (and in kvm_pkvm.h in both cases).

Cheers,
/fuad



 > Thanks,
>
>         M.
>
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/commit/?h=kvm-arm64/pkvm-features-6.20&id=8823485a697de5c280a7a2632620338722f16663
>
> --
> Without deviation from the norm, progress is not possible.
