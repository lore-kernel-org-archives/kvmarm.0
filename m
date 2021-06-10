Return-Path: <SRS0=KFVQ=LE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22E9EC47094
	for <kvmarm@archiver.kernel.org>; Thu, 10 Jun 2021 17:28:00 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 80736613E1
	for <kvmarm@archiver.kernel.org>; Thu, 10 Jun 2021 17:27:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 80736613E1
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E230D4A4CD;
	Thu, 10 Jun 2021 13:27:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id sX1cvLaXaYKJ; Thu, 10 Jun 2021 13:27:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CDD4B4A4A0;
	Thu, 10 Jun 2021 13:27:57 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7369D4A1A7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Jun 2021 13:27:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YX6p5pZmuvKs for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Jun 2021 13:27:55 -0400 (EDT)
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com
 [209.85.167.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 64B6B49F83
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Jun 2021 13:27:55 -0400 (EDT)
Received: by mail-lf1-f52.google.com with SMTP id j20so4438110lfe.8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Jun 2021 10:27:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=FLnQvFD4x7DNDj+NEJ3O+AkctP1r/V6a1b3Mdx886HU=;
 b=rYFqapPgHlrCQ4YV5UAaF9vTXxJW71bDJszf6XXAAypmGGRdGy7rfe1/NkQ88jkidv
 zj0sX27ZlwVd1QclSX13XE640t7tzrvWWWb1G2tctffoctIf1fhooZ7Z71CevX/0YxEF
 tuOvnyEYg0UtYKXQV9KQGDQGVcEUJKGE2o7Ere77VbhsmdIPiI7RPZHMj8zFUV6O58ia
 ZHRxLj73Uxg2A+dJQSroGT/BW6I99RPB91M1y0pZsGyl/MLduTCcimMeMfbZQU+j52PK
 73cqjjeLjcblTMTYG4JtB0oQ0j/azuNLDIYH6CGSA+Lzz/w3wgp0j+picMdZdSjO0idh
 bqlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=FLnQvFD4x7DNDj+NEJ3O+AkctP1r/V6a1b3Mdx886HU=;
 b=qkEbcgCdB+OcBxF4AHGhsgYY2k7hGe814kbsUD4a2XzyHSb8XjhaQ1OeU7SCDUNO84
 VOWVHokDHO59j2k23KQ+tuGwJSc8zSrlQmZekRnC9/fx7/Q1GHOawe2lPlyB5IS8y7xS
 M22HuSwGHtCv5nO2CpPIc92Ab354ntGCJtkelDDEbmJkPgg64ZcSMbQyYvbkkDrqPlVr
 w3yKEpSz9SRDBxSOQbDAJPoS2ZmFSEY1MG1iXhi9uLiaO2H3WcSM+/yFpvQD2F4Ij67u
 CCQ8SQ7DMYrsEtfEuH2La0Z4LaQRRUeamzfBycAe1d6z8dWfnrmqotB7EkmS3L6/4SNc
 8BQw==
X-Gm-Message-State: AOAM532KWuSnA6GQshpxXNHiISzFL28X0S4H4CUDvklgBEEEWPn6RLKP
 mnrof46HRpmm4eGZEPyaW1bwqh4KhogoJE4CA2GYjw==
X-Google-Smtp-Source: ABdhPJxMYyFCrOdc3qDmqDYkOsRd9Ou7KT5iYSlyqMweabXy+tFPPqYLyS4hzfuDF71PLN1Lon73E77keupLBsrNlto=
X-Received: by 2002:a05:6512:33c4:: with SMTP id
 d4mr2754345lfg.536.1623346073785; 
 Thu, 10 Jun 2021 10:27:53 -0700 (PDT)
MIME-Version: 1.0
References: <20210603211426.790093-1-jingzhangos@google.com>
 <20210603211426.790093-3-jingzhangos@google.com>
 <345170fd-636c-f1be-7dc3-69467e51d872@redhat.com>
In-Reply-To: <345170fd-636c-f1be-7dc3-69467e51d872@redhat.com>
From: Jing Zhang <jingzhangos@google.com>
Date: Thu, 10 Jun 2021 12:27:41 -0500
Message-ID: <CAAdAUthr+An=SWZLDfWQ1nfnAr-PdAJgSuBmK2iypa1a3+Ay5g@mail.gmail.com>
Subject: Re: [PATCH v7 2/4] KVM: stats: Add fd-based API to read binary stats
 data
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
 Paul Mackerras <paulus@ozlabs.org>,
 Linuxkselftest <linux-kselftest@vger.kernel.org>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, Will Deacon <will@kernel.org>,
 KVMARM <kvmarm@lists.cs.columbia.edu>,
 Emanuele Giuseppe Esposito <eesposit@redhat.com>,
 LinuxS390 <linux-s390@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
 Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 David Rientjes <rientjes@google.com>, KVMPPC <kvm-ppc@vger.kernel.org>,
 Krish Sadhukhan <krish.sadhukhan@oracle.com>,
 David Matlack <dmatlack@google.com>, Jim Mattson <jmattson@google.com>,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Sean Christopherson <seanjc@google.com>, Cornelia Huck <cohuck@redhat.com>,
 Peter Shier <pshier@google.com>, LinuxMIPS <linux-mips@vger.kernel.org>,
 Vitaly Kuznetsov <vkuznets@redhat.com>
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

On Thu, Jun 10, 2021 at 11:42 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 03/06/21 23:14, Jing Zhang wrote:
> > +struct _kvm_stats_header {
> > +     __u32 name_size;
> > +     __u32 count;
> > +     __u32 desc_offset;
> > +     __u32 data_offset;
> > +};
> > +
>
> Keeping this struct in sync with kvm_stats_header is a bit messy.  If
> you move the id at the end of the header, however, you can use the same
> trick with the zero-sized array that you used for _kvm_stats_desc.
>
Good point. Will do.
> > +struct kvm_vm_stats_data {
> > +     unsigned long value[0];
> > +};
> > +
>
> I posted the patch to switch the VM statistics to 64-bit; you can rebase
> on top of it.
Cool!
>
> > +#define KVM_GET_STATS_FD  _IOR(KVMIO,  0xcc, struct kvm_stats_header)
>
> This should be _IO(KVMIO, 0xcc) since it does not have an argument.
>
Will correct it.
> > +#define STATS_DESC(stat, type, unit, scale, exp)                            \
> > +     {                                                                      \
> > +             {                                                              \
> > +                     .flags = type | unit | scale,                          \
> > +                     .exponent = exp,                                       \
> > +                     .size = 1                                              \
> > +             },                                                             \
> > +             .name = stat,                                                  \
>
> Here you can use
>
>         type | BUILD_BUG_ON_ZERO(type & ~KVM_STATS_TYPE_MASK) |
>         unit | BUILD_BUG_ON_ZERO(unit & ~KVM_STATS_UNIT_MASK) |
>         scale | BUILD_BUG_ON_ZERO(scale & ~KVM_STATS_SCALE_MASK) |
>
> to get a little bit of type checking.
Sure, will do.
>
> Paolo
>

Thanks,
Jing
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
