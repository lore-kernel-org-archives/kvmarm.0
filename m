Return-Path: <SRS0=YGC0=PG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98ABEC433F5
	for <kvmarm@archiver.kernel.org>; Mon, 18 Oct 2021 23:54:51 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0CC9161212
	for <kvmarm@archiver.kernel.org>; Mon, 18 Oct 2021 23:54:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 0CC9161212
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7B2A54B1AD;
	Mon, 18 Oct 2021 19:54:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id sR4Q2s4OCK-7; Mon, 18 Oct 2021 19:54:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6FEE84B19D;
	Mon, 18 Oct 2021 19:54:49 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A81734B199
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Oct 2021 19:54:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZtK-T8tSQBzA for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Oct 2021 19:54:46 -0400 (EDT)
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com
 [209.85.215.178])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AF1F54B192
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Oct 2021 19:54:46 -0400 (EDT)
Received: by mail-pg1-f178.google.com with SMTP id r2so17679553pgl.10
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Oct 2021 16:54:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=ynOhmjUOkwSpnrJ88zMEmxNB0eI9c/2L1iHrpBkEpk4=;
 b=EFOaBD2lQnyqIAAG5lrCqU/8zu6qACMCiE/0CRBR75mPq/VJ6w6L8PDbEje9d0OiaJ
 5eFaONYYZuOumyI17zC4o/vaZRO8CjnVUYDishxFaY6QkQVZDEZKaPF4TfWTBEQQ2bZn
 nIHOqtbKge9kX9oRaTxIs5lD1nsPmp3dlb+5vQxOA00ewEMo3WgiF3MVdQ2E5CEV+Jem
 mkZOcvGaZ1UHqdF+6hvJIiM4mBZDZBNWf9PxZ5clWM2kplQwTSaA87Z5+H13SX/2aGFn
 6QkehEXNPY3Kf07patc7zcFiBrweGIjWJwpXKYeQxGjWkE4SWH6Gd2wXEN2x6YReAs6M
 fLlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=ynOhmjUOkwSpnrJ88zMEmxNB0eI9c/2L1iHrpBkEpk4=;
 b=MuGOoYjI+TDAjy6gu6XYLm9q5m0e7uXWTRIFp/mFnLsEq/aCLvmoXEedCrjlmkfAJS
 bYDrZ70/V6ungHFwti971/3bqL8QpzghC+oLnq++PEzM7ffO/M/mmlN361OxwQmRHWQZ
 1dXgl85eboCs/4WjwxCbfZaHCpd5UkeBu0b3qOeAWWT/wHhwbbWJAXx4Eh5i+EqTP2Sn
 keN5j91doOCJtuWwluON4YGHP+Va32Kl0PYlfELkwpYVQfEAFbdhXkqbBTDY9K8UrHa9
 shwUdZ2dEaZiUgSBuw8lexZTSciKvGUC0eM0eGKBz3oFDGcCP198IodmwKaoNkoGALnI
 GBMw==
X-Gm-Message-State: AOAM530i1SA/8s9+UxKKeIDQZZOu8Mdd+wOVVN4/kbDtd4LcvPzkXlx2
 E2zx+w9/yB3vcbxQcoOVuTOXJkL52f4yvJZEnZ9msQ==
X-Google-Smtp-Source: ABdhPJzVbYDhkj/gRXc6UEHpqQBV4tybyVWFXS4+PBSGTI/Gq/Fn+h+wfokG4GSqJyDfn5rly0rCn5FHhXPB3vizLTc=
X-Received: by 2002:a63:d806:: with SMTP id b6mr26403649pgh.395.1634601285698; 
 Mon, 18 Oct 2021 16:54:45 -0700 (PDT)
MIME-Version: 1.0
References: <20211012043535.500493-1-reijiw@google.com>
 <20211012043535.500493-3-reijiw@google.com>
 <20211015130918.ezlygga73doepbw6@gator>
 <CAAeT=Fx9zUet2HvFe8dwhXjyozuggn+qcQBoyb_8hUGJNKFNTQ@mail.gmail.com>
 <20211018143040.nhkv67cxni6ind6k@gator.home>
In-Reply-To: <20211018143040.nhkv67cxni6ind6k@gator.home>
From: Reiji Watanabe <reijiw@google.com>
Date: Mon, 18 Oct 2021 16:54:29 -0700
Message-ID: <CAAeT=FzK1dNaJvR9u98-M63pPdeou=KfKoxHE+WN0cadeQUKHw@mail.gmail.com>
Subject: Re: [RFC PATCH 02/25] KVM: arm64: Save ID registers' sanitized value
 per vCPU
To: Andrew Jones <drjones@redhat.com>
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

> > > > +static void reset_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd)
> > >
> > > Since not all ID registers will use this, then maybe name it
> > > reset_sanitised_id_reg?
> >
> > Thank you for the suggestion.
> >
> > I named it 'reset_id_reg' according to the naming conventions of
> > set_id_reg, get_id_reg, and access_id_reg which are used for the same
> > set of ID registers (ID_SANITISED ones) as reset_id_reg.
> > I would think it's better to use consistent names for all of them.
> > So, I am a bit reluctant to change only the name of reset_id_reg.
> >
> > What do you think about the names of those other three functions ?
>
> I think I like the shorter names, so please disregard my suggestion.

Thank you for the confirmation. I will keep those names as they are.

Regards,
Reiji
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
