Return-Path: <SRS0=Qgx2=LI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02239C2B9F4
	for <kvmarm@archiver.kernel.org>; Mon, 14 Jun 2021 13:36:21 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6EB46611CE
	for <kvmarm@archiver.kernel.org>; Mon, 14 Jun 2021 13:36:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6EB46611CE
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D91EF40870;
	Mon, 14 Jun 2021 09:36:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id h9nbNM-vEqln; Mon, 14 Jun 2021 09:36:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E5DCE49E57;
	Mon, 14 Jun 2021 09:36:18 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BCAD14083E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Jun 2021 09:36:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HjXs8tjeuNXL for <kvmarm@lists.cs.columbia.edu>;
 Mon, 14 Jun 2021 09:36:16 -0400 (EDT)
Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com
 [209.85.208.176])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9D94A40808
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Jun 2021 09:36:16 -0400 (EDT)
Received: by mail-lj1-f176.google.com with SMTP id bn21so20237144ljb.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Jun 2021 06:36:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=8eDKzbSZu1SwWJ0P86Rh5OM8P2vVwoJZM4q1bflykQ8=;
 b=R0CbDztlv0la7WD/fHY4DFjQzcsop/sh/PmzKnq/2thw9f3PUT2P3wOo+csesCUKls
 LS9qMnbXlXxKgcujagKu/oXpOxYpy2dxS7IHIP6s3wQi+HK7YPP3VHeVgYnLTuvxw2W8
 e9JmgplDrf0dXO+4lR9EtTG+25VcDjXtBgPbHQRB0R7jiHpwm4cLbzR7H4GApyDAID41
 6ySSLIw03/EDfbQ30EEFVf7PeSaHBB2ZEQMx2Bk0fP2scv+TBKF3DLaDOqTLw4lzoHFa
 wNkM22Y6pJCUDfCfDdm2C57VbEIz5RbUdG+Q4N+Wr+1C67rueWN6JzUgBH8Obhx2/D3l
 bWlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=8eDKzbSZu1SwWJ0P86Rh5OM8P2vVwoJZM4q1bflykQ8=;
 b=HvSblIeJ/3a0IIb2m8riDd4Q6Fk/kPT4g3m1trSWRDa/VLixgyJL5aHLIhoeOpVXC2
 j1e9mIX9M0/DHzVqR/9LmI/OMtR+EHZf2maxfkUh0b3vVF5h6gOuIsgykgaDkoRLYkLj
 b+XstrYOKJxrqmRYpPytzJeX6QL3ISh1eCQPrN79e5vvKROHMf+rTEviv+ovBuY5KeRB
 JWj6W5e8IltGNXE9diukJjSCBoL7K2zhb0M6z1RTJ4mx+a+e0qCmbVrKvkwjE5GmwqzO
 BZXd2ZAtMGEjNF9UPeGxvnNX6eRzYn1tKT816Jg8Om4KR8VxZHIkl6e+x9JaOgfbFiqY
 BgZQ==
X-Gm-Message-State: AOAM531X8aPIG9GqSndnJH1HGOjq6AjKRJ3iM0+k9vb98zJlvR8UZ+m3
 JkrzoMZ18XmYzUJ4Ay9rD15Mb7udijNMUQZ8Fx4GNw==
X-Google-Smtp-Source: ABdhPJyRerJorqPpaASqjE9boZ8l83RWNQm1Z5lsPnNwsXUo1I390oxKiUv+iF3/YpVooNiCx/RtKI8ne6I6YJoWEvk=
X-Received: by 2002:a2e:b8c9:: with SMTP id s9mr5867978ljp.216.1623677774828; 
 Mon, 14 Jun 2021 06:36:14 -0700 (PDT)
MIME-Version: 1.0
References: <20210614025351.365284-1-jingzhangos@google.com>
 <20210614025351.365284-3-jingzhangos@google.com>
 <1b57502b-116a-9be5-fa2f-1e8f5b5fce2d@redhat.com>
In-Reply-To: <1b57502b-116a-9be5-fa2f-1e8f5b5fce2d@redhat.com>
From: Jing Zhang <jingzhangos@google.com>
Date: Mon, 14 Jun 2021 08:36:02 -0500
Message-ID: <CAAdAUtiG6Wt52Z3sKchBKR7-7qyeux6CfR1KFEnvi6nNoCRE_Q@mail.gmail.com>
Subject: Re: [PATCH 2/4] KVM: stats: Use binary stats descriptors for debugfs
 interface
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: LinuxS390 <linux-s390@vger.kernel.org>, KVM <kvm@vger.kernel.org>,
 LinuxMIPS <linux-mips@vger.kernel.org>, KVMPPC <kvm-ppc@vger.kernel.org>,
 KVMARM <kvmarm@lists.cs.columbia.edu>
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

Hi Paolo,

On Mon, Jun 14, 2021 at 4:51 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 14/06/21 04:53, Jing Zhang wrote:
> > +     STATS_DESC_ICOUNTER_RONLY(VM, lpages),
> > +     STATS_DESC_ICOUNTER_RONLY(VM, nx_lpage_splits),
> >       STATS_DESC_ICOUNTER(VM, max_mmu_page_hash_collisions)
>
> I think we're now adding too many macros.
>
> max_mmu_page_hash_collisions is the only remaining instant counter that
> is not read-only.  In fact, in the statsfs prototype we made all instant
> counters read-only.
>
> You could add a third type in addition to instant and cumulative, let's
> call it "peak".  This essentially corresponds to the "max" aggregation
> function in the statsfs prototype.  Then instant counters would be read
> only, while cumulative and peak would be read-write.
>
> Paolo
>
Thanks for the suggestion. Will do that.
Jing
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
