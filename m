Return-Path: <SRS0=A4hI=LM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AD89C48BDF
	for <kvmarm@archiver.kernel.org>; Fri, 18 Jun 2021 12:34:37 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DC16E613EE
	for <kvmarm@archiver.kernel.org>; Fri, 18 Jun 2021 12:34:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DC16E613EE
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 50EEB4A522;
	Fri, 18 Jun 2021 08:34:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id oS-7alFmpYbA; Fri, 18 Jun 2021 08:34:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 43FB04A523;
	Fri, 18 Jun 2021 08:34:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 644374A49C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Jun 2021 08:34:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IKe6DGcppBsB for <kvmarm@lists.cs.columbia.edu>;
 Fri, 18 Jun 2021 08:34:33 -0400 (EDT)
Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com
 [209.85.208.171])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0D9B64A3B4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Jun 2021 08:34:33 -0400 (EDT)
Received: by mail-lj1-f171.google.com with SMTP id 131so13841605ljj.3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Jun 2021 05:34:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=nZ8eZKcheetAVVtntDyOPDczvB8LGNmHxynp06Hwje4=;
 b=gem9n2oV7siw83AG8SlRs8mVxwOwxCy2gN2ftYt8Cz67bhgXmc2w00MxcPfoZ9mJpB
 sg/wSDsX34t83RRTKbk6Qs27kQStSxWG3HjPj6/XU2HOoxB14lnA7+ishARi3u47qouL
 A9ohAwN083OUKOdmoDlEFBPNodXkFN6VPz2ttTDC0uxV7v+gu+6Hw710eM5GaIYooO8/
 4DUDPjLNVyihbqd7JbECs734pUsTIHIC8tGN5Xt1IgghNHNM+TbucaOhD480OZ4REs27
 VL6ufqWcV+HYsEvcDPLjJJRwT4Lbxi6EUqfyDmTWaim1b0e8tq3/RkTCwRFcYY1isfOT
 aZhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=nZ8eZKcheetAVVtntDyOPDczvB8LGNmHxynp06Hwje4=;
 b=rwLz0rPYHI+5YHku24Po4+AT8z+mGDXCDXMuoYTvc+mqBazgcMvdaEeqbuR98mB7td
 6AIV+D0/MVCqckZ14zomhHKrm2hf77W7NwZzhevLZtqzMVT68/aQyhjD/NXOCOewAyCp
 eccbwQ7kYVbrR1sikBC/L00cNJmcKqIJ+Yzigm1rJ3yE7Tjid/moUPmEsHm97PztXblM
 gj0lFRAM4IAGq3WASIJ8s+nUBId+6uESheIvbHXsDAHXY7PTTeVuy614m0fLQaEsJ+RS
 3vWfLAtq2djT7+hWYMy7/vkcKa1T0PVboxplMDPNTAF9RhYoSVtucuOI6l6UEJjxe/yR
 8TFQ==
X-Gm-Message-State: AOAM532FzoGDhwfEmp+l4jUnQmGoOILJSHohjH/c9PIZOtcT9Rc770co
 aojQgdVSTvKGFRPGgRBhfXX3PxA67XHDmC2+SP6tng==
X-Google-Smtp-Source: ABdhPJy/SmtmBEa6EeaTOLzSOUyOJ0FCW1v/VcB96xzGJFrUogLnnlSkPebfytnB2OvvIcWiKdLH+1HCeEh87E18VuA=
X-Received: by 2002:a2e:bf21:: with SMTP id c33mr9245298ljr.28.1624019671303; 
 Fri, 18 Jun 2021 05:34:31 -0700 (PDT)
MIME-Version: 1.0
References: <20210618044819.3690166-1-jingzhangos@google.com>
 <20210618044819.3690166-4-jingzhangos@google.com> <YMxD/NxAvKkXB2iM@kroah.com>
In-Reply-To: <YMxD/NxAvKkXB2iM@kroah.com>
From: Jing Zhang <jingzhangos@google.com>
Date: Fri, 18 Jun 2021 07:34:19 -0500
Message-ID: <CAAdAUti86QZY+KT+NLnLyYf0P09_p5AWhXMmT7+mSt1r=OVEfA@mail.gmail.com>
Subject: Re: [PATCH v11 3/7] KVM: stats: Support binary stats retrieval for a
 VM
To: Greg KH <gregkh@linuxfoundation.org>
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
 Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>
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

On Fri, Jun 18, 2021 at 1:58 AM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Fri, Jun 18, 2021 at 04:48:15AM +0000, Jing Zhang wrote:
> > Add a VM ioctl to get a statistics file descriptor by which a read
> > functionality is provided for userspace to read out VM stats header,
> > descriptors and data.
> > Define VM statistics descriptors and header for all architectures.
> >
> > Reviewed-by: David Matlack <dmatlack@google.com>
> > Reviewed-by: Ricardo Koller <ricarkol@google.com>
> > Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> > Reviewed-by: Fuad Tabba <tabba@google.com>
> > Tested-by: Fuad Tabba <tabba@google.com> #arm64
> > Signed-off-by: Jing Zhang <jingzhangos@google.com>
> > ---
> >  arch/arm64/kvm/guest.c    | 14 +++++++++++++
> >  arch/mips/kvm/mips.c      | 14 +++++++++++++
> >  arch/powerpc/kvm/book3s.c | 16 +++++++++++++++
> >  arch/powerpc/kvm/booke.c  | 16 +++++++++++++++
> >  arch/s390/kvm/kvm-s390.c  | 19 +++++++++++++++++
> >  arch/x86/kvm/x86.c        | 24 ++++++++++++++++++++++
> >  include/linux/kvm_host.h  |  6 ++++++
> >  virt/kvm/kvm_main.c       | 43 +++++++++++++++++++++++++++++++++++++++
> >  8 files changed, 152 insertions(+)
> >
> > diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> > index 4962331d01e6..f456d1defe2b 100644
> > --- a/arch/arm64/kvm/guest.c
> > +++ b/arch/arm64/kvm/guest.c
> > @@ -28,6 +28,20 @@
> >
> >  #include "trace.h"
> >
> > +struct _kvm_stats_desc kvm_vm_stats_desc[] = {
> > +     KVM_GENERIC_VM_STATS()
> > +};
> > +static_assert(ARRAY_SIZE(kvm_vm_stats_desc) ==
> > +             sizeof(struct kvm_vm_stat) / sizeof(u64));
> > +
> > +struct kvm_stats_header kvm_vm_stats_header = {
>
> Can this be const?
>
> > +     .name_size = KVM_STATS_NAME_LEN,
> > +     .count = ARRAY_SIZE(kvm_vm_stats_desc),
> > +     .desc_offset = sizeof(struct kvm_stats_header) + KVM_STATS_ID_MAXLEN,
> > +     .data_offset = sizeof(struct kvm_stats_header) + KVM_STATS_ID_MAXLEN +
> > +                    sizeof(kvm_vm_stats_desc),
> > +};
>
> If it can't be const, what is modified in it that prevents that from
> happening?
>
> thanks,
>
> greg k-h
Yes, it can be const.

Thanks,
Jing
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
