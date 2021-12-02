Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CD7AC433F5
	for <kvmarm@archiver.kernel.org>; Thu,  2 Dec 2021 04:43:07 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C96754B1B6;
	Wed,  1 Dec 2021 23:43:06 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MQR4VuG8hwKp; Wed,  1 Dec 2021 23:43:05 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BA60D4B1A3;
	Wed,  1 Dec 2021 23:43:05 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D7D6D4B16E
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Dec 2021 23:43:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id l19IGtXm865A for <kvmarm@lists.cs.columbia.edu>;
 Wed,  1 Dec 2021 23:43:01 -0500 (EST)
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com
 [209.85.215.181])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5367C4B16C
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Dec 2021 23:43:01 -0500 (EST)
Received: by mail-pg1-f181.google.com with SMTP id r138so25781871pgr.13
 for <kvmarm@lists.cs.columbia.edu>; Wed, 01 Dec 2021 20:43:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=WBjl40eoblEtslotDXg+2znA3v0fTi0Ym3CxNJvfO3s=;
 b=TCckOGN3de8PY6NFcbcSpt8fk++CRE8VftBWP67XQ6mYRi7RqPub6LnWwQM+At6lKJ
 wQxtMC04nGYlAFFE5zE+QvG95XzT27x0S9OzOalW30FZeMzi5/WEVbGUApakPWpwuhDd
 jFXyISCZlJOAnD+7brVTEJ5x10O1QrF6RQV0nAzZLxVeTGi0oULMJ8HZSP5n0n5OofZU
 KiHbiSwmxfodfIfjCcYDwNw5dduiv45dJge/d5dHQtCbYRhSRorirgHAiMgzfek2+l0n
 hwL+PsNX1xKsUlCOm+G0/nMEk7VngYbX/J4TJv8ARc25iX9//IhnN+6cK7piGFbayOWF
 GrdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=WBjl40eoblEtslotDXg+2znA3v0fTi0Ym3CxNJvfO3s=;
 b=5DME4MMXekdgqk8fO4eS1DaxVkC8rXUKHMaK3sAUUBO64WAks1dZmjmY/rtFBCO4TX
 LGCVGTCIVJLYPkw21yAjWoGIQfJtiU7ggBgOeAaFtU0jV+n88pY8xXkRu9ndfske73vV
 5g3ZeobzH5ERBbUTzcZuA1xb7bxPRgSZGlZgCrt4DMr6Op2D9ihf5ickPaE817Ty3wlo
 8jTNoV4qpJG5srUuDM/xN36y1B106L2yHaO/I9QfdH2TzWM11Bgda/+cB8X7egnILpRc
 kFElJZDnLa4nWqX6Q8ELvgbvANb8H6+rGliobu6JWKpTXaAjuy/TaKsFCFKI6rUiKgOr
 uQ5A==
X-Gm-Message-State: AOAM530uCI7a2jpTjPN8iUvUXKhslkVwDbBKqNnBSUqJ/BA2rAiJJ76Q
 HEy3aejwNwKWFXJ0wybGyU6DUZPf4rH8annvqBI8EQ==
X-Google-Smtp-Source: ABdhPJxe4f/ujhOahFLP6qr2iHzh8FVCbjXWHq53ajA7lz1m6Pq5502HFMviU1EboUUbswOwgX8Vt+QD9Mu3lTYrBZ8=
X-Received: by 2002:a62:874b:0:b0:4a8:2df0:1804 with SMTP id
 i72-20020a62874b000000b004a82df01804mr10493744pfe.39.1638420180251; Wed, 01
 Dec 2021 20:43:00 -0800 (PST)
MIME-Version: 1.0
References: <20211117064359.2362060-1-reijiw@google.com>
 <20211117064359.2362060-10-reijiw@google.com>
 <d09e53a7-b8df-e8fd-c34a-f76a37d664d6@redhat.com>
 <CAAeT=FzM=sLF=PkY_shhcYmfo+ReGEBN8XX=QQObavXDtwxFJQ@mail.gmail.com>
 <YaeabhZnYNLQcejs@monolith.localdoman> <YaeeJUGRwZN00byk@monolith.localdoman>
In-Reply-To: <YaeeJUGRwZN00byk@monolith.localdoman>
From: Reiji Watanabe <reijiw@google.com>
Date: Wed, 1 Dec 2021 20:42:44 -0800
Message-ID: <CAAeT=FxWsg-Bgyw4vOMqcq-aZ5LtyFaN-o=OjQSLsEZeLiV+ag@mail.gmail.com>
Subject: Re: [RFC PATCH v3 09/29] KVM: arm64: Hide IMPLEMENTATION DEFINED PMU
 support for the guest
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, Eric Auger <eauger@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

Hi Alex,

On Wed, Dec 1, 2021 at 8:09 AM Alexandru Elisei
<alexandru.elisei@arm.com> wrote:
>
> Hi Reiji,
>
> On Wed, Dec 01, 2021 at 03:53:18PM +0000, Alexandru Elisei wrote:
> > Hi Reiji,
> >
> > On Mon, Nov 29, 2021 at 09:32:02PM -0800, Reiji Watanabe wrote:
> > > Hi Eric,
> > >
> > > On Thu, Nov 25, 2021 at 12:30 PM Eric Auger <eauger@redhat.com> wrote:
> > > >
> > > > Hi Reiji,
> > > >
> > > > On 11/17/21 7:43 AM, Reiji Watanabe wrote:
> > > > > When ID_AA64DFR0_EL1.PMUVER or ID_DFR0_EL1.PERFMON is 0xf, which
> > > > > means IMPLEMENTATION DEFINED PMU supported, KVM unconditionally
> > > > > expose the value for the guest as it is.  Since KVM doesn't support
> > > > > IMPLEMENTATION DEFINED PMU for the guest, in that case KVM should
> > > > > exopse 0x0 (PMU is not implemented) instead.
> > > > s/exopse/expose
> > > > >
> > > > > Change cpuid_feature_cap_perfmon_field() to update the field value
> > > > > to 0x0 when it is 0xf.
> > > > is it wrong to expose the guest with a Perfmon value of 0xF? Then the
> > > > guest should not use it as a PMUv3?
> > >
> > > > is it wrong to expose the guest with a Perfmon value of 0xF? Then the
> > > > guest should not use it as a PMUv3?
> > >
> > > For the value 0xf in ID_AA64DFR0_EL1.PMUVER and ID_DFR0_EL1.PERFMON,
> > > Arm ARM says:
> > >   "IMPLEMENTATION DEFINED form of performance monitors supported,
> > >    PMUv3 not supported."
> > >
> > > Since the PMU that KVM supports for guests is PMUv3, 0xf shouldn't
> > > be exposed to guests (And this patch series doesn't allow userspace
> > > to set the fields to 0xf for guests).
> >
> > While it's true that a value of 0xf means that PMUv3 is not present (both
> > KVM and the PMU driver handle it this way) this is an userspace visible
> > change.
> >
> > Are you sure there isn't software in the wild that relies on this value
> > being 0xf to detect that some non-Arm architected hardware is present?
> >
> > Since both 0 and 0xf are valid values that mean that PMUv3 is not present,
> > I think it's best that both are kept.
>
> Sorry, somehow I managed to get myself confused and didn't realize that
> this is only used by KVM.
>
> What I said above about the possibility of software existing that pokes IMP
> DEF registers when PMUVer = 0xf is in fact a good argument for this patch,
> because KVM injects an undefined exception when a guest tries to access
> such registers.

Thank you for your review.  My understanding is the same as yours.

Thanks,
Reiji
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
