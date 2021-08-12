Return-Path: <SRS0=3mia=ND=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EA30C4338F
	for <kvmarm@archiver.kernel.org>; Thu, 12 Aug 2021 09:21:46 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id EDAE860FC4
	for <kvmarm@archiver.kernel.org>; Thu, 12 Aug 2021 09:21:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org EDAE860FC4
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 64D06402DB;
	Thu, 12 Aug 2021 05:21:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7oD3xT5MIcGu; Thu, 12 Aug 2021 05:21:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 74C1C40856;
	Thu, 12 Aug 2021 05:21:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 71025407F4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Aug 2021 05:21:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ioc4Fa+0GMl7 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 12 Aug 2021 05:21:38 -0400 (EDT)
Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com
 [209.85.210.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 57937402DB
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Aug 2021 05:21:38 -0400 (EDT)
Received: by mail-ot1-f46.google.com with SMTP id
 n1-20020a9d1e810000b0290514da4485e4so4199332otn.4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Aug 2021 02:21:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=iqzxZhoC6kB4bLqUJZe+JW0zSkiAmZThOjct2YoGtrk=;
 b=HPoN/8bJTBl1bSRYawtOqmugOiQTAvVhXUHh6kp8Vc90cfe2sFGjNYQyh+wXLozBgi
 DreDQP+SZUsq8hMCS8djvnOF7zWa99ckV+3qldfFeMtZ4ekgCKE9xWDY/85H8vxuWm+i
 iH7HeXkXYYHmpn6EGDL0o5a1yee2SMWYJ0ZF3i/gpzmWLcW9LdT2h8sUbwrqdu12WOR2
 g48Ly1Ixzv5qlzZSKRt/b4FJlYnXgz8C5Woe3MOeg6P1iIhR2+/MYxGQOMSr4U0S6J8c
 2L9ztLQfPKfLJJenp+v5pjgLwQWUP7b3CQPnn+r3i3HswSkZ27zLWWEsO4ZYuNtBV80a
 yldg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=iqzxZhoC6kB4bLqUJZe+JW0zSkiAmZThOjct2YoGtrk=;
 b=g7WBWKCS5DT/OCnn1rZ8j8HoMvQioG6NjzQLEq2aXuaHEjrlc0+HI6B5Cdww2csEaZ
 cMU2U7+ESweNIGhBUiCb5Tlgx62KTdzwN9uxIPNyC7SsPT0x2k7FAOYr4fPLsslqJCSB
 Rrgg7K1lD3i+ITF3B/xJ/BKbeuGR7ilVS8wrjExSZE/uCg6Ns+h1HoXtm7SwUGvKuPhg
 5Te4WGm823uIvv8ninb3/eaZI7hiZn1D8VdfwPoWic017bxJEKEOOlJwLnLnBGUwdStj
 ng1zXkQkC079qvPBcOyViC3Q+sHTSA6NLHWGP6AsCTxRWZwPefluiVN5tQQByD9CmAEk
 gNgw==
X-Gm-Message-State: AOAM531g3nbzRMIxXdfv27B6sjprAe5pW7umO+LEUFdbpwxrClTJVwkm
 5PtZZgKDzvVHznY8fw0aMgjW54LR+UCVx8uXi2pWzg==
X-Google-Smtp-Source: ABdhPJxi+S+EtgmGj3lxGi+NQp6K5VuA3LSkvVkLCD2i5Jd7cCNEoUuyhCMTn3mxudarNoNz+ZV9n0INWXwGyVVrJpE=
X-Received: by 2002:a9d:2609:: with SMTP id a9mr2679662otb.365.1628760097655; 
 Thu, 12 Aug 2021 02:21:37 -0700 (PDT)
MIME-Version: 1.0
References: <20210719160346.609914-1-tabba@google.com>
 <20210719160346.609914-9-tabba@google.com>
 <20210812085939.GF5912@willie-the-truck>
In-Reply-To: <20210812085939.GF5912@willie-the-truck>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 12 Aug 2021 11:21:01 +0200
Message-ID: <CA+EHjTyXtVXEU7FMq53rmrgWuiikPzNnWJ7cj4EJkR5FCgj6Sg@mail.gmail.com>
Subject: Re: [PATCH v3 08/15] KVM: arm64: Add feature register flag definitions
To: Will Deacon <will@kernel.org>
Cc: kernel-team@android.com, kvm@vger.kernel.org, maz@kernel.org,
 pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Will,

On Thu, Aug 12, 2021 at 10:59 AM Will Deacon <will@kernel.org> wrote:
>
> On Mon, Jul 19, 2021 at 05:03:39PM +0100, Fuad Tabba wrote:
> > Add feature register flag definitions to clarify which features
> > might be supported.
> >
> > Consolidate the various ID_AA64PFR0_ELx flags for all ELs.
> >
> > No functional change intended.
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  arch/arm64/include/asm/cpufeature.h |  4 ++--
> >  arch/arm64/include/asm/sysreg.h     | 12 ++++++++----
> >  arch/arm64/kernel/cpufeature.c      |  8 ++++----
> >  3 files changed, 14 insertions(+), 10 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
> > index 9bb9d11750d7..b7d9bb17908d 100644
> > --- a/arch/arm64/include/asm/cpufeature.h
> > +++ b/arch/arm64/include/asm/cpufeature.h
> > @@ -602,14 +602,14 @@ static inline bool id_aa64pfr0_32bit_el1(u64 pfr0)
> >  {
> >       u32 val = cpuid_feature_extract_unsigned_field(pfr0, ID_AA64PFR0_EL1_SHIFT);
> >
> > -     return val == ID_AA64PFR0_EL1_32BIT_64BIT;
> > +     return val == ID_AA64PFR0_ELx_32BIT_64BIT;
> >  }
> >
> >  static inline bool id_aa64pfr0_32bit_el0(u64 pfr0)
> >  {
> >       u32 val = cpuid_feature_extract_unsigned_field(pfr0, ID_AA64PFR0_EL0_SHIFT);
> >
> > -     return val == ID_AA64PFR0_EL0_32BIT_64BIT;
> > +     return val == ID_AA64PFR0_ELx_32BIT_64BIT;
> >  }
> >
> >  static inline bool id_aa64pfr0_sve(u64 pfr0)
> > diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> > index 326f49e7bd42..0b773037251c 100644
> > --- a/arch/arm64/include/asm/sysreg.h
> > +++ b/arch/arm64/include/asm/sysreg.h
> > @@ -784,14 +784,13 @@
> >  #define ID_AA64PFR0_AMU                      0x1
> >  #define ID_AA64PFR0_SVE                      0x1
> >  #define ID_AA64PFR0_RAS_V1           0x1
> > +#define ID_AA64PFR0_RAS_ANY          0xf
>
> This doesn't correspond to an architectural definition afaict: the manual
> says that any values other than 0, 1 or 2 are "reserved" so we should avoid
> defining our own definitions here.

I'll add a ID_AA64PFR0_RAS_V2 definition in that case and use it for
the checking later. That would achieve the same goal and I wouldn't be
adding definitions to the reserved area.

Cheers,
/fuad
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
