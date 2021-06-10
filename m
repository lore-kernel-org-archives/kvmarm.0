Return-Path: <SRS0=KFVQ=LE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 050D3C48BD1
	for <kvmarm@archiver.kernel.org>; Thu, 10 Jun 2021 22:48:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7373E613CA
	for <kvmarm@archiver.kernel.org>; Thu, 10 Jun 2021 22:48:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7373E613CA
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BE7C64B08A;
	Thu, 10 Jun 2021 18:47:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wHNUTS+ZuoxZ; Thu, 10 Jun 2021 18:47:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A1A804AC78;
	Thu, 10 Jun 2021 18:47:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A5244A523
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Jun 2021 18:47:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YtKsdPs9Ov+J for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Jun 2021 18:47:56 -0400 (EDT)
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com
 [209.85.167.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 077F449E93
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Jun 2021 18:47:56 -0400 (EDT)
Received: by mail-lf1-f47.google.com with SMTP id x24so41345lfr.10
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Jun 2021 15:47:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=NB6oruf2NY8GhkThmLRjR9OK5AwQwpQtqUKMMQIim6Q=;
 b=RlAcwFqFOmgURmrxCa/W36B7QDS48JsLtq3ukyvETwbEWY9n6kYR15OJLR1+m/Ayoa
 IFOPgRn+MWHaHRxfzFfw8YKkIIgs2ZCGs14vP+ZHoxKKjXRv9KyIxggliDfqvjBIjYCq
 V94EObt9JIV8pROJEKleOqvY3Lp4pDZx/7FjYYuWinqlm2/1Nytb+dPDD+hsW55nAX2C
 NGH7VQWOTOBEWWcYPh7P7p/+0rXPvWK0nt69u5R3R8eLlCTBAmYqdMr2C3ARulRpzg4R
 8Q+QNXpBn09jeaY6tlsnVHADHx9NQbdhTP8oD+yYICZdPO5DY7zVDUU7MeMZbXvDgcyf
 zO/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=NB6oruf2NY8GhkThmLRjR9OK5AwQwpQtqUKMMQIim6Q=;
 b=Q0JvRWsbPaV9L/gwi9nbV/XPNPJ/0PhFUASljj1ukz/NUIz2QBYyWyA8rJtErhm4Be
 PwqDSvEsbOy0mvgQUhaMaLSuJONNLrPtB//Yydq24qkWFqOg8I/zvmO+m6d2t9AVr653
 DRVwvZtRq+ZXcaEZ1g4oREkAWDVfY9z43sfzHd7dRLdz8BkxM6Pnu/NnXHZ4T/TXmN8y
 iFoaez1OsdxusEjSf/1m08inUFyVQeJlMmHo0pwtKsJXEG5ybyOp6N3k82+e83VQCn/1
 pbNsoMnoVw8lXeVeVF4b7cc4v3MWE5hekKC7yTbu1/WQT7Yj1GWHYFPGuMveGRpYmX4u
 Owyw==
X-Gm-Message-State: AOAM533VFbU7bVYnkrHQaT9fgmdGNx4bOgA4vbobc++EIDXvtZH7IbHW
 rr26c73jPgm0FPihTerfD8KQvtYeJVjUCrYqArINKQ==
X-Google-Smtp-Source: ABdhPJwpq8QDGCaA9l+lT37FAjCpuN+L2RrV3HuGV2JBb0AyojuY/TbuPJ2PuprqJ9F9pWJFYjBYz3jwM7wdjjpecmI=
X-Received: by 2002:a05:6512:39ca:: with SMTP id
 k10mr657852lfu.473.1623365274281; 
 Thu, 10 Jun 2021 15:47:54 -0700 (PDT)
MIME-Version: 1.0
References: <20210603211426.790093-1-jingzhangos@google.com>
 <20210603211426.790093-3-jingzhangos@google.com>
 <e3b2b3ab-88a2-827c-7775-10be63158ff3@redhat.com>
In-Reply-To: <e3b2b3ab-88a2-827c-7775-10be63158ff3@redhat.com>
From: Jing Zhang <jingzhangos@google.com>
Date: Thu, 10 Jun 2021 17:47:41 -0500
Message-ID: <CAAdAUtjAuDdyBz7qd7UE0WuY77US-bhY1-jA9E11ddhZ0=gw6g@mail.gmail.com>
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

On Thu, Jun 10, 2021 at 11:23 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 03/06/21 23:14, Jing Zhang wrote:
> > +#define DEFINE_VM_STATS_DESC(...) {                                         \
> > +     STATS_DESC_COUNTER("remote_tlb_flush"),                                \
> > +     ## __VA_ARGS__                                                         \
> > +}
> > +
> > +#define DEFINE_VCPU_STATS_DESC(...) {                                               \
> > +     STATS_DESC_COUNTER("halt_successful_poll"),                            \
> > +     STATS_DESC_COUNTER("halt_attempted_poll"),                             \
> > +     STATS_DESC_COUNTER("halt_poll_invalid"),                               \
> > +     STATS_DESC_COUNTER("halt_wakeup"),                                     \
> > +     STATS_DESC_TIME_NSEC("halt_poll_success_ns"),                          \
> > +     STATS_DESC_TIME_NSEC("halt_poll_fail_ns"),                             \
> > +     ## __VA_ARGS__                                                         \
>
> Let's instead put this (note it's without braces) in macros like these
>
> #define KVM_GENERIC_VM_STATS()                                                  \
>         STATS_DESC_COUNTER("remote_tlb_flush"),
>
> #define KVM_GENERIC_VCPU_STATS(...)                                             \
>         STATS_DESC_COUNTER("halt_successful_poll"),                             \
>         STATS_DESC_COUNTER("halt_attempted_poll"),                              \
>         STATS_DESC_COUNTER("halt_poll_invalid"),                                \
>         STATS_DESC_COUNTER("halt_wakeup"),                                      \
>         STATS_DESC_TIME_NSEC("halt_poll_success_ns"),                           \
>         STATS_DESC_TIME_NSEC("halt_poll_fail_ns"),
>
> and it can be used in the arch files.  In fact it can even be added in patch 1 and
> switched to STATS_DESC_* here.
>
> Paolo
>
I just remember that the reason I used braces is due to following
error from checkpatch.pl:
ERROR: Macros with complex values should be enclosed in parentheses

So, just keep it as it is?

Thanks,
Jing
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
