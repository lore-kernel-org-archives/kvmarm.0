Return-Path: <SRS0=4KxT=LZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68410C11F64
	for <kvmarm@archiver.kernel.org>; Thu,  1 Jul 2021 14:32:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D4DBF6140B
	for <kvmarm@archiver.kernel.org>; Thu,  1 Jul 2021 14:32:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D4DBF6140B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 503474B089;
	Thu,  1 Jul 2021 10:32:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rZM5HHZK1Gs1; Thu,  1 Jul 2021 10:32:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 54DE540CC5;
	Thu,  1 Jul 2021 10:32:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C8CF240CC5
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Jul 2021 10:32:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NoKKO9s9NX9F for <kvmarm@lists.cs.columbia.edu>;
 Thu,  1 Jul 2021 10:32:31 -0400 (EDT)
Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com
 [209.85.210.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DFB034080B
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Jul 2021 10:32:31 -0400 (EDT)
Received: by mail-ot1-f44.google.com with SMTP id
 n99-20020a9d206c0000b029045d4f996e62so6712598ota.4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 01 Jul 2021 07:32:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=GTWJSM0xuYeJ1qxgbQHiMwUUzauF3cOKfHO15I4MhOw=;
 b=EygC7C1OvqQkptipYOSfVSwUc6YZNt5+lNvyBzvRWkOWnirOZ5wZ5dEsoamkLJSrj5
 /9B6RCY00Jxl7hENRq7PzVM0E7y+LFl/Zq9En80e2xztq0ZfSTeBnb2rLBJ0B7btNNvu
 VmYVBwzU4mhxmPmzpctJscT43Ul9Jn2DCd5DgNc3sB3joylfXFKMVIz5uHQzyQXU7iZV
 AvsFjjNLNPQWuSh2bM7QffkAjjXVhneH9SBuMvihGyPgnRcaQqd9047WD3+O7z9yiXXX
 N35Cvz55rAMmglMiCW5pr9ff+HoAErFWVkAA+hb05qKN9wEBJSrop38E/WXO+MK+WD+z
 AXdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=GTWJSM0xuYeJ1qxgbQHiMwUUzauF3cOKfHO15I4MhOw=;
 b=uMnDNW5FReia5s7+dKUsYPxLf7lw0vctJTl4DnOaDslOW+D6TRvfYV4PqTki6nSrcw
 kiBHQSQT9IFYdJyi/r75AoaZQ9DOdP9GFw7hn5NUv4G8FfpcjbKmtIpa8aXVjadmZhBM
 HCjN++POl5paTF0aPqT1bbwaiHxafeo5/qBf4e4yBD50iL7C/F3qbk8nOBYEtSTGE93u
 xwEuly7BXiJsovWAu0YScJyr5yoW045iAnXcMoUXxsvuisdg/m9I5zGyHdzHb8jyWmIt
 IK6+71duYxEuB0oLTg6TRBrg5NEDbpJMXDYechakG0LCz5xrwVI3R8/oFG5IxIEQMpk7
 VDbw==
X-Gm-Message-State: AOAM531yvRlIoSxhzBhh903a2ClgngvDWnZz12osd3mwR2uIs7Kf5FyC
 ahtzFTiHRxt8YYr1F6phpzfaFfl6wnzsnY1cU6DhNQ==
X-Google-Smtp-Source: ABdhPJzW0WFDucrNK/jthp+c5o1CjayKDRPKm1VqM1CogtX3ulAO6RQp4oH+Gl/UqH7nsn/hycliW0RuWuVZ1PFLkpU=
X-Received: by 2002:a05:6830:18da:: with SMTP id
 v26mr262263ote.144.1625149951088; 
 Thu, 01 Jul 2021 07:32:31 -0700 (PDT)
MIME-Version: 1.0
References: <20210615133950.693489-1-tabba@google.com>
 <20210615133950.693489-7-tabba@google.com>
 <20210701132244.GF9757@willie-the-truck>
In-Reply-To: <20210701132244.GF9757@willie-the-truck>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 1 Jul 2021 15:31:54 +0100
Message-ID: <CA+EHjTwcJaQtgJK8Wiqj1W+oyNU8oycGdR0Kk-+5BJbyj5oEPQ@mail.gmail.com>
Subject: Re: [PATCH v2 06/13] KVM: arm64: Add feature register flag definitions
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

On Thu, Jul 1, 2021 at 2:22 PM Will Deacon <will@kernel.org> wrote:
>
> On Tue, Jun 15, 2021 at 02:39:43PM +0100, Fuad Tabba wrote:
> > Add feature register flag definitions to clarify which features
> > might be supported.
> >
> > No functional change intended.
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  arch/arm64/include/asm/sysreg.h | 9 +++++++++
> >  1 file changed, 9 insertions(+)
> >
> > diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> > index 65d15700a168..42bcc5102d10 100644
> > --- a/arch/arm64/include/asm/sysreg.h
> > +++ b/arch/arm64/include/asm/sysreg.h
> > @@ -789,6 +789,10 @@
> >  #define ID_AA64PFR0_FP_SUPPORTED     0x0
> >  #define ID_AA64PFR0_ASIMD_NI         0xf
> >  #define ID_AA64PFR0_ASIMD_SUPPORTED  0x0
> > +#define ID_AA64PFR0_EL3_64BIT_ONLY   0x1
> > +#define ID_AA64PFR0_EL3_32BIT_64BIT  0x2
> > +#define ID_AA64PFR0_EL2_64BIT_ONLY   0x1
> > +#define ID_AA64PFR0_EL2_32BIT_64BIT  0x2
> >  #define ID_AA64PFR0_EL1_64BIT_ONLY   0x1
> >  #define ID_AA64PFR0_EL1_32BIT_64BIT  0x2
> >  #define ID_AA64PFR0_EL0_64BIT_ONLY   0x1
>
> Maybe just consolidate all of these into two definitions:
>
>   #define ID_AA64PFR0_ELx_64BIT_ONLY   0x1
>   #define ID_AA64PFR0_ELx_32BIT_64BIT  0x2

Will do.

Cheers,
/fuad

> ?
>
> Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
