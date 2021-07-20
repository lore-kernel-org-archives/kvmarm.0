Return-Path: <SRS0=KNUW=MM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,FSL_HELO_FAKE,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1B6FC07E95
	for <kvmarm@archiver.kernel.org>; Tue, 20 Jul 2021 10:30:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 75C776113C
	for <kvmarm@archiver.kernel.org>; Tue, 20 Jul 2021 10:30:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 75C776113C
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F34914B0F5;
	Tue, 20 Jul 2021 06:30:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1yxmFMAYhIeL; Tue, 20 Jul 2021 06:30:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F39AA4B098;
	Tue, 20 Jul 2021 06:30:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2EB184B08E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Jul 2021 06:30:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jzuGQmhNVl80 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 20 Jul 2021 06:30:12 -0400 (EDT)
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com
 [209.85.128.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 161364B088
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Jul 2021 06:30:12 -0400 (EDT)
Received: by mail-wm1-f44.google.com with SMTP id l6so12017137wmq.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Jul 2021 03:30:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=yyHhpf3IFAZa8+1SI9IG6peKhoOSRw9FB1qV/j0MUk8=;
 b=PhXJaFKOpcy2R87A3f53vk2DTtTJTWwcjsKW3ZIokani62gKo5jR0aptPSmRJ/1fTA
 6DTZ6pKoaLfDrl4bXXLSOUBjVLCt7f5wxvv4LQMWoTuqMv0cxIUiPLbommSaffKuRjrP
 gOmxbCxfzZ7GDSNvdtbSL2rHvQELDImGwvWMlagzTJLTsFQ/sqVZYBhcLuUrRLjO5xop
 0BAAZHK1brhUGSN7QZ6Rc5KkPqMNq2A9quWdZax1xJCcYYfyGp0q8AOgjjkeOo8R2jk8
 LznC5t+fgx50pyAxYWv1XtdF/r48ir3eBkYYr7JNEU1eMnPFNXlYweVxAtymaGdW9yV1
 SiQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=yyHhpf3IFAZa8+1SI9IG6peKhoOSRw9FB1qV/j0MUk8=;
 b=PvIc8MH9jV1T3WT0i3ziZ2CGiaL/t7LmSMIzO3zMMlvo1ZCfcJc6TW2MhwFBZDAu5P
 qIGNP+RnbfokPsVKrO4qOHVa1X3DUiBH2kfTqHU90i8Cb9xFfQHuDsX3DabjCgsiEZzW
 l7gq/+G6D2LzCG2Hrzk6ogqfziDi/68OQEkAAHeIPPld0tTVrHTcNCV0qGktdT0n7n0C
 hc6J58KbI3j9sjBPrQKu7n0vPwXl/loJg8aYvSSgqASmfoJ0Vp187EY+58gxGrmIyL8Z
 lcjEnNq485JFyTwIoeGoUXTTMfypYBwzZz03bL8Fz8PL3pbXOEEVX2tmOtkOuELxoTdM
 Gb0A==
X-Gm-Message-State: AOAM531D0A7k1CeoJgZ5gpzglT9Pc8El/Ui5LQi5rrcg7h3aEkAv0URa
 aca3RYEJb7bO/rIw4WaC5ocTXg==
X-Google-Smtp-Source: ABdhPJzn7ppEiI6BziSUJrI9AZI83z3s8BqsMlMXuRgHmlK8PB4VVXduDhaZmxWobhXPrKosB7ng7A==
X-Received: by 2002:a05:600c:2255:: with SMTP id
 a21mr30864834wmm.90.1626777010977; 
 Tue, 20 Jul 2021 03:30:10 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:210:83e0:11ac:c870:2b97])
 by smtp.gmail.com with ESMTPSA id w15sm2558095wmi.3.2021.07.20.03.30.10
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 20 Jul 2021 03:30:10 -0700 (PDT)
Date: Tue, 20 Jul 2021 11:30:07 +0100
From: Quentin Perret <qperret@google.com>
To: Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH 06/14] KVM: arm64: Tolerate re-creating hyp mappings to
 set ignored bits
Message-ID: <YPalr09gA6tGYVtl@google.com>
References: <20210719104735.3681732-1-qperret@google.com>
 <20210719104735.3681732-7-qperret@google.com>
 <CA+EHjTzjT2iv=9jsTNquSAD-_AWqpyCKVPiuCBWGzpxcAkWf9w@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CA+EHjTzjT2iv=9jsTNquSAD-_AWqpyCKVPiuCBWGzpxcAkWf9w@mail.gmail.com>
Cc: kernel-team@android.com, qwandor@google.com, maz@kernel.org,
 linux-kernel@vger.kernel.org, catalin.marinas@arm.com, will@kernel.org,
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

Hi Fuad,

On Tuesday 20 Jul 2021 at 11:17:03 (+0100), Fuad Tabba wrote:
> Hi Quentin,
> 
> 
> On Mon, Jul 19, 2021 at 11:47 AM Quentin Perret <qperret@google.com> wrote:
> >
> > The current hypervisor stage-1 mapping code doesn't allow changing an
> > existing valid mapping. Relax this condition by allowing changes that
> > only target ignored bits, as that will soon be needed to annotate shared
> > pages.
> >
> > Signed-off-by: Quentin Perret <qperret@google.com>
> > ---
> >  arch/arm64/kvm/hyp/pgtable.c | 18 ++++++++++++++++--
> >  1 file changed, 16 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> > index a0ac8c2bc174..34cf67997a82 100644
> > --- a/arch/arm64/kvm/hyp/pgtable.c
> > +++ b/arch/arm64/kvm/hyp/pgtable.c
> > @@ -362,6 +362,17 @@ static int hyp_set_prot_attr(enum kvm_pgtable_prot prot, kvm_pte_t *ptep)
> >         return 0;
> >  }
> >
> > +static bool hyp_pte_needs_update(kvm_pte_t old, kvm_pte_t new)
> > +{
> > +       if (old == new)
> > +               return false;
> > +
> > +       if (!kvm_pte_valid(old))
> > +               return true;
> > +
> > +       return !WARN_ON((old ^ new) & ~KVM_PTE_LEAF_ATTR_IGNORED);
> 
> Wouldn't this return false if both ignored and non-ignored bits were
> different, or is that not possible (judging by the WARN_ON)?

Correct, but that is intentional, see below ;)

> If it is, then it would need an update, wouldn't it?

Maybe, but if you look at what the existing code does, we do skip the
update if the old mapping is valid and not equal to new. So I kept the
behaviour as close as possible to this -- if you change any bits outside
of SW bits you get a WARN and we skip the update, as we already do
today. But if you touch only SW bits and nothing else, then I let the
update go through.

That said, I don't think warning and then proceeding to update would be
terribly wrong, it's just that a change of behaviour felt a bit
unnecessary for this particular patch.

Thanks,
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
