Return-Path: <SRS0=KFVQ=LE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6A50C47094
	for <kvmarm@archiver.kernel.org>; Thu, 10 Jun 2021 17:26:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 47389613E1
	for <kvmarm@archiver.kernel.org>; Thu, 10 Jun 2021 17:26:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 47389613E1
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8B3D44A4FC;
	Thu, 10 Jun 2021 13:26:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4KgIonn+2ren; Thu, 10 Jun 2021 13:26:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 89E404A4A0;
	Thu, 10 Jun 2021 13:26:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 701C84A1A7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Jun 2021 13:26:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YcnqIbIDsHtj for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Jun 2021 13:26:15 -0400 (EDT)
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com
 [209.85.167.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5236F49F83
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Jun 2021 13:26:15 -0400 (EDT)
Received: by mail-lf1-f47.google.com with SMTP id j2so4437950lfg.9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Jun 2021 10:26:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=onW47ZbFH5e5HdlUoVPNuscSOQqX/2SrpfD9q95JllY=;
 b=b6hzP0YccRsWRRzU9ACpHmsFQnmYuaVTbX3pLJrVClZpmJ8BdQEY4NyzcB+e9HkDWy
 NC09VOvmFwa0/XSiTVEsk5yJuCNs+bQIW3AIZ02R9sahMKur9D08Bgr3lJ/OhJRtLD1o
 BlYEX0xLTOySTV9lBOztJD3qJAdsp/6IHVAqlgN264WrwRKJy5jiyfY2YODTbTv50eZm
 HagnQMsvfTQIbob7ncuANB6LsQf7XAFdg0eqOnkqhq7Zz2bDCxMdB+xv1sthskhngNbZ
 UBLuUJ4UMHWPJP6okHwkretFYjIcBoI+l5AuDgK1Gl+KtZaAOhvO85V10T2j4GFhFYmw
 bEDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=onW47ZbFH5e5HdlUoVPNuscSOQqX/2SrpfD9q95JllY=;
 b=CHxZsnOIkoJ9IjL2U86V8hNf+4fo1JNSPkhPbvhV1oFbxH71s6fdkb4wtT0ShmQXKq
 isrVHWnSnl3TG1FaLlXHO181mUPr6dJ+KwV/VDGQEisdeChkEp+sPSYUaTjXPa/3g3U8
 UOB5Oo+h9qe/MoVSrZ9qP6HfRQ2kiHRRKqqEN9/KPjZvUhDgFtaCILapcJzjg6iC6RgF
 vredNYJq8UxB8tD6vh+KqNtoRE2yMA94/22QB7tfccy8YEBTbpjz8YlfcPNL+E/LzUTu
 kXh17Iftec7Z/L34SAe3Df6foaXK5tvIUOt/xv4u5N8biEu7T6poK/x3BTS+kcOSxMsk
 W8BA==
X-Gm-Message-State: AOAM531Fu8rRswSSIZSjUe2NG7sBzgefTHjc1fm3DfeGzTGun0YAjU7C
 cQNUjTfURBpx+cXWNjflNxxQg0rCcs5TGcPpXRfdaQ==
X-Google-Smtp-Source: ABdhPJz8EC2IEZhB34cW1A4E6Lqer1JPVsXnD5iNMnq9sh79Ry5VJrolXUt5s8cOLAUMW6xiM1HrMzx1A5MFg25P0eQ=
X-Received: by 2002:a05:6512:3ea:: with SMTP id
 n10mr2582051lfq.178.1623345973683; 
 Thu, 10 Jun 2021 10:26:13 -0700 (PDT)
MIME-Version: 1.0
References: <20210603211426.790093-1-jingzhangos@google.com>
 <20210603211426.790093-3-jingzhangos@google.com>
 <e3b2b3ab-88a2-827c-7775-10be63158ff3@redhat.com>
In-Reply-To: <e3b2b3ab-88a2-827c-7775-10be63158ff3@redhat.com>
From: Jing Zhang <jingzhangos@google.com>
Date: Thu, 10 Jun 2021 12:26:01 -0500
Message-ID: <CAAdAUtg638Fk9QVAdZ0Xt96YS311KCfeJqNiP5FycCMafZ3R0A@mail.gmail.com>
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
Sure, will do.

Thank,s
Jing
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
