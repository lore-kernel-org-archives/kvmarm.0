Return-Path: <SRS0=hs0s=PY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05D06C433EF
	for <kvmarm@archiver.kernel.org>; Fri,  5 Nov 2021 06:25:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 684F96124F
	for <kvmarm@archiver.kernel.org>; Fri,  5 Nov 2021 06:25:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 684F96124F
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B3B7A4A49C;
	Fri,  5 Nov 2021 02:25:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0Y4d8PV1VzGF; Fri,  5 Nov 2021 02:25:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 86A5F4B0CE;
	Fri,  5 Nov 2021 02:25:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F25224A49C
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Nov 2021 02:25:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5l+t46D2zoCe for <kvmarm@lists.cs.columbia.edu>;
 Fri,  5 Nov 2021 02:25:38 -0400 (EDT)
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com
 [209.85.210.170])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7BD7D4031F
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Nov 2021 02:25:38 -0400 (EDT)
Received: by mail-pf1-f170.google.com with SMTP id g18so3271074pfk.5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 04 Nov 2021 23:25:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=83I8KWJOKgy+kYsvOfvG78wBhuMiPl6vZLrWNC92y68=;
 b=f0zOuYJ0R/98fpq8DKHySf+sIvIHFTfBCgK4n/d1EoCYiWKyKR4aA9jyvDyhdxbmfr
 YHMxJQyuINQTM1ibyysDpCkDj4+38zSsX2BREDDSfg58sWjoxCBvGIz30WjMfr09FIAx
 qUoe6oDOD8Oo3CD6/eTDmaXtgyRP9SgtmzHX2pwZrY/K+2PJzt9HGdnYXg42zZ2nKvms
 q6HtKdspaQ14CR3pB6ICiUM7gOtLAjb6TUNmxUnX6kWrrDE5YPGoO4Dr0iPtg4EyQkoo
 l6+OfBra1fHrmBAWTk3hgQc6MY8RjVhsDu8IBTxpH/Tsc3unRhpAoM2z143bLz6nMVOk
 wD8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=83I8KWJOKgy+kYsvOfvG78wBhuMiPl6vZLrWNC92y68=;
 b=qweQOSrvA1RXxYojNBCu3271Vmlu7iYpea1ZnzVfJSeBJrV4n79wwgRNz24ZEL7pHU
 qTA2ghxZgQcvjPniYBT8k7NJ8qOJGZV7KsZuPJ6WHOOj+6Cwh+zjfvABThq8ThkjtfNE
 XHrWtfWC69Ngwv77PiB/2PW19VpH+YDrFOZUhDboELHiOOU1Pk38zI2NNXPC8wBqRp3z
 qazoAvxTbhixjgMWifDncbizvX57qdo7ZGxu0SKTtqxkRdT4vIIC6C2qvX1AnrVtZYbw
 YCSWSOXqkWLMN3T0clm6pVKI0MDWiMAHM78Tv1VQAip5RFYFy0qhrmzdp3akcGJbbhP/
 kIrw==
X-Gm-Message-State: AOAM5320Zqda5IvRcBftOyNE4UZtx0T6l9Kx8G2jAmYFbAaMFUVzRQon
 oJPd4lzqLT4956C5jyPYnmxHruXI71ZFxHNQm1s6Lg==
X-Google-Smtp-Source: ABdhPJxw9VnfnHe9u50el4lnxVAR9qUrlhodBzmSVS92D4DmQlKkuRP7Li6Zcj7Slw2kIxX2GwblXLsXIsFv3YBquzU=
X-Received: by 2002:aa7:8246:0:b0:44b:4870:1b09 with SMTP id
 e6-20020aa78246000000b0044b48701b09mr58421337pfn.82.1636093537523; Thu, 04
 Nov 2021 23:25:37 -0700 (PDT)
MIME-Version: 1.0
References: <20211103062520.1445832-1-reijiw@google.com>
 <20211103062520.1445832-3-reijiw@google.com>
 <YYQG6fxRVEsJ9w2d@google.com>
 <CAAeT=FzTxpmnGJ4a=eGiE1xxvbQR2HqrtRA3vymwdJobN99eQA@mail.gmail.com>
In-Reply-To: <CAAeT=FzTxpmnGJ4a=eGiE1xxvbQR2HqrtRA3vymwdJobN99eQA@mail.gmail.com>
From: Reiji Watanabe <reijiw@google.com>
Date: Thu, 4 Nov 2021 23:25:21 -0700
Message-ID: <CAAeT=FxqonCJHuv55jj0DR7n164yJaJHYU1XpQk3r4kWaXjyPw@mail.gmail.com>
Subject: Re: [RFC PATCH v2 02/28] KVM: arm64: Save ID registers' sanitized
 value per vCPU
To: Oliver Upton <oupton@google.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, Will Deacon <will@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
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

On Thu, Nov 4, 2021 at 2:39 PM Reiji Watanabe <reijiw@google.com> wrote:
>
> Hi Oliver,
>
> On Thu, Nov 4, 2021 at 9:14 AM Oliver Upton <oupton@google.com> wrote:
> >
> > Hi Reiji,
> >
> > On Tue, Nov 02, 2021 at 11:24:54PM -0700, Reiji Watanabe wrote:
> > > Extend sys_regs[] of kvm_cpu_context for ID registers and save ID
> > > registers' sanitized value in the array for the vCPU at the first
> > > vCPU reset. Use the saved ones when ID registers are read by
> > > userspace (via KVM_GET_ONE_REG) or the guest.
> >
> > Based on my understanding of the series, it appears that we require the
> > CPU identity to be the same amongst all vCPUs in a VM. Is there any
> > value in keeping a single copy in kvm_arch?
>
> Yes, that's a good point.
> It reminded me that the idea bothered me after we discussed a similar
> case about your counter offset patches, but I didn't seriously
> consider that.
>
> Thank you for bringing this up.
> I will look into keeping it per VM in kvm_arch.

I just remembered that I made the prototype that kept ID registers
per VM as the option B (, which introduced per VM ID register
configuration API though...).

Anyway, I've noticed that requiring the consistency of ID registers
amongst vCPUs in a VM affects KVM_ARM_VCPU_INIT API, with which
userspace can currently configure different features for each vCPUs.
I'm not sure if any existing userspace program practically does that
though.

Now, I think I should rather remove that consistency requirement...
(at least for features that can be configured by KVM_ARM_VCPU_INIT)

Thanks,
Reiji
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
