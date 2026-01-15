Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2095B350D4A
	for <kvmarm@lists.linux.dev>; Thu, 15 Jan 2026 15:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768490438; cv=pass; b=ZVJ3zyxx/4hZ60vVoL+ioLpACJSj9Ajoh6qcvRF7ciddYeJEzb9+6W5Hp40JQM0d/0cznnb4izjSvQpvOx51xgYieQjQrd+Lvr3DhphgopdBjm1JEEjRkSgBsNAH/J7VkuCFcovGLwYaeqIPXI06baZoF5qRgvsTacCtc5EO9og=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768490438; c=relaxed/simple;
	bh=FvMwnXysfRvWYKa7aSVULY0PqRlALfnQBxg+gjKCw1A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uWd6ORoSikWVZi7FLwqDGWUdPNWhIejWbfRVoeULHSEMG4F2bogpRZzEUcPG/PjxKF3FZ0wCkunqUnZD0dwlAZkj9S2prBu8Vwt/zIQpXenMdXesIvKU0ExE8GMRfugAibZyJmHsaUuxrIXzVngyMo18YgSOyHw3icJC+G+ks1s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PEgzxhiC; arc=pass smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PEgzxhiC"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-47a95a96d42so52615e9.1
        for <kvmarm@lists.linux.dev>; Thu, 15 Jan 2026 07:20:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768490427; cv=none;
        d=google.com; s=arc-20240605;
        b=enPEj1HpjWan80zcBPZRzL6DYiy4+AzzEwg+DF6fav0f7KAjXiU8aoHGYV/mCssd1u
         0E8oKPxlM/4QPFAo2c/h71uR8iPoG6l5ipa1SX8xEr55oKTh+dl13umyA+Kt4aA5bjjr
         R5qqpGiqezUlsp3VqvCkDkm0YBQkviwVtREqOGiruoZibJAuhVWzmlKPfpLnxtEikTMQ
         C45lJM0NloNS1lsYUokcDWGvUml5oRmVOTdsqO8isKuYBOBKFQAyeFyS2KXTscwomsIQ
         KwhF5oDGIMwaqy3v/K2ZVrlOmqIjYkPsgDj+5cTUrehe6+nJ2XCnpHzUE783OPg2cy+Y
         BcBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=6JHhgPo73JFubMx4EP8h9jX67e75KNMkM7M/+r7y04Y=;
        fh=vxg7jDbV4KUkB1p2dijbmgxOcCsnV64udQg+GHT6RZo=;
        b=UEkLn49BacH+6oduwbUwNpfKj/k2J0lliLK2WwQe8Z4IIiv2sDfi07w8xumlcQUwRx
         Et2kZ0p/igrgIKYpyagCdPPsGYlNrfWz20xOLUR9iglv6FDjOEtykegPKAzMclKc/5Vd
         LieVMOM/O39tKfCn1JFLMA/BqOgBBt7BuOBhCxVyytBq+l1Eo04flNoxedk871sowIhy
         qNRAMCT9QlDX1dd3PjyQzTCNeAf68wx0Ai2fax2B8hSsJI/bR7CXoWfOdPz1yYBqiy9y
         Y03+Z4RzSSc2D9Dc3hKr/dUYlyWLMdMXq4YnpeImWJbOnIKrbvFQ3ws4iUxJATkyEuGD
         uCeQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768490427; x=1769095227; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=6JHhgPo73JFubMx4EP8h9jX67e75KNMkM7M/+r7y04Y=;
        b=PEgzxhiC7c7uZ0ihnP2dj6KEt9VTJRAn0MJvmqLvSZGK15IOPM2HPC5FBRXNHEpgKa
         jsSJ6MjckiLsGSyxI7JdsoUW8rvXWPQwiEMj7SGlDEy1QXwDuzvWD//wwNV3Ux14i8a/
         0G44AeI7PIt5uKn/J+QyAjAFX4kvfvYhNtKIUlVah6kgd+SdUYkdWCZG9fAF++jKQfQm
         6dETjcQFhsxrxgk/oLR6yxx6XNqi9VR6q+05Ah0sXyEOd5qGECHKUN9Aj/oOo5etgZ/F
         4eTrpbLihvWgi8kK0FhIhKshra6Ietmp5kqtKEey1SsvoXWdtJPv3Krp/k86YZjaYOOl
         HNiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768490427; x=1769095227;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6JHhgPo73JFubMx4EP8h9jX67e75KNMkM7M/+r7y04Y=;
        b=GG4xaGzDDhtVf5OL5BrcFoRehwj4hr+iJFLPZevnN8qxW6Gp5BDtQV+kQX5LL7UuXP
         AMlWH4kP6HHBIeA0Zog/tHNo8NV74tN1TZ5rcJiK2RETLcAMzdoGYdnzVlRiWtuQejOC
         Eb6IaJwlSlKV9bQqQYHRO/IWShCvE9KLXl2Id/KgmExo4f41PFOBsjBeYQY8nEeVIuh4
         q9kfX6BEy60ocT1Q8bbK+rBnPwSNQRS6yBmVmnZ9bIJ+6c6if28GLXnBgahPXap5Oj7y
         L4iqoXmlkMU6Z5VW22xPqQgvvTWUVXAH9BowaRfPP1t/LV0hpjbrOnucNH6LCLZYw69i
         hjYw==
X-Gm-Message-State: AOJu0YwU5rcn+sGMYtBOnAcTEqYRcTWdABzZHjMrUOqfdj4aiZl4MW1e
	ZEYKwzGUl5DHx2qBkmyiDOQT/x8/hUNPEIz5dF5cSWvboU+GjJyv7YdKe8RKkSyRGgEtHV0pSl8
	Bbdtp6xlc17nG9sSOvfFwen91tTg3ID1Q61aRA36p
X-Gm-Gg: AY/fxX6v0Qjn3nql4aPL+2HOReWHP3hiCL9TawdrhhEmvq/zhuDMvLwaWGx+5E2QBkC
	cez/L8cDLH8O+KH5j1LhIn5oGh64rA7kO01EasdYLaZJ3uJwGKdqM0WKbjmkgAXoMfGbkIunz7x
	BEoLW4stmyxmyF14rhpqLi3bgd1qRgutNb9z4VoCFij5/cdQQvzPq8C6LZWrwHgyV2zLjdh0sOe
	oBN21Saz3F+Tt4g4iJAEab/Cp888bB6RDAVmYafYSWws1thkms2d4P24EjiF6eDob6ermyg
X-Received: by 2002:a05:600c:310c:b0:477:86fd:fb47 with SMTP id
 5b1f17b1804b1-47f83f3a12cmr746125e9.8.1768490427073; Thu, 15 Jan 2026
 07:20:27 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251211104710.151771-1-tabba@google.com> <20251211104710.151771-9-tabba@google.com>
 <86h5smlxyo.wl-maz@kernel.org>
In-Reply-To: <86h5smlxyo.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 15 Jan 2026 15:19:48 +0000
X-Gm-Features: AZwV_QgE41uEPI9Vg4fByEIPIpbH-ItbLeWT-3oeGpbf0mTS4ASvGnEoNWEl8Pg
Message-ID: <CA+EHjTzEtPta5VHr5R0r0v7ui7-8xv5me29uk2devZ=S14RHqw@mail.gmail.com>
Subject: Re: [PATCH v6 8/9] KVM: arm64: Check whether a VM IOCTL is allowed in pKVM
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	oliver.upton@linux.dev, will@kernel.org, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	vladimir.murzin@arm.com
Content-Type: text/plain; charset="UTF-8"

Hi Marc,

On Thu, 15 Jan 2026 at 15:03, Marc Zyngier <maz@kernel.org> wrote:
>
> On Thu, 11 Dec 2025 10:47:08 +0000,
> Fuad Tabba <tabba@google.com> wrote:
> >
> > Certain VM IOCTLs are tied to specific VM features. Since pKVM does not
> > support all features, restrict which IOCTLs are allowed depending on
> > whether the associated feature is supported.
> >
> > Use the existing VM capability check as the source of truth to whether
> > an IOCTL is allowed for a particular VM by mapping the IOCTLs with their
> > associated capabilities.
> >
> > Suggested-by: Oliver Upton <oupton@kernel.org>
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_pkvm.h | 21 +++++++++++++++++++++
> >  arch/arm64/kvm/arm.c              |  3 +++
> >  2 files changed, 24 insertions(+)
> >
> > diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
> > index 5b564576160d..0fa8c84816fd 100644
> > --- a/arch/arm64/include/asm/kvm_pkvm.h
> > +++ b/arch/arm64/include/asm/kvm_pkvm.h
> > @@ -9,6 +9,7 @@
> >  #include <linux/arm_ffa.h>
> >  #include <linux/memblock.h>
> >  #include <linux/scatterlist.h>
> > +#include <asm/kvm_host.h>
> >  #include <asm/kvm_pgtable.h>
> >
> >  /* Maximum number of VMs that can co-exist under pKVM. */
> > @@ -43,6 +44,7 @@ static inline bool kvm_pkvm_ext_allowed(struct kvm *kvm, long ext)
> >       case KVM_CAP_ARM_SVE:
> >       case KVM_CAP_ARM_PTRAUTH_ADDRESS:
> >       case KVM_CAP_ARM_PTRAUTH_GENERIC:
> > +     case KVM_CAP_ARM_BASIC:
>
> Can we instead rely on an existing VM capability? I'm not overly keen
> exposing something new to userspace (KVM_CAP_ARM_BASIC) for something
> that really is KVM's own internal problems.
>
> Looking at the history, a bunch of things have always been present:
> KVM_CAP_NR_VCPUS, for example. You could even #define
> KVM_CAP_ARM_BASIC to that if you want.

I wasn't too crazy about that either. I like the idea of defining it
as an alias of KVM_CAP_NR_VCPUS. I'll do that when I respin.

Cheers,
/fuad

> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
