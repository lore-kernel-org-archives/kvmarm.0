Return-Path: <SRS0=f6Gw=II=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDC2DC433DB
	for <kvmarm@archiver.kernel.org>; Wed, 10 Mar 2021 21:42:03 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4635064FCD
	for <kvmarm@archiver.kernel.org>; Wed, 10 Mar 2021 21:42:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4635064FCD
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AD7534B231;
	Wed, 10 Mar 2021 16:42:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id mvNDY0RmgcgT; Wed, 10 Mar 2021 16:42:01 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 70BDE4B2B6;
	Wed, 10 Mar 2021 16:42:01 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CB9D44B231
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Mar 2021 16:42:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id p2p6tTOCyRbb for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Mar 2021 16:41:59 -0500 (EST)
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com
 [209.85.167.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5FE754B22B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Mar 2021 16:41:59 -0500 (EST)
Received: by mail-lf1-f44.google.com with SMTP id d3so36030241lfg.10
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Mar 2021 13:41:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=1aCWly0eHYOBMX2QbB2MVQEtisRq+kLH3ylpaLZI0cc=;
 b=BwXgkRlIC4KTvskQmfIRT1UpL8FUSVcbmMR/10Xjal9SvwnJMSNCtMz4ebGfjZEpwl
 HCKgLGqmaBchqQkax5bvx+rjJAcaO8g0WZ2ZWmXxQ4vS1uLC6HEi952fLlwgPn3Wd4/q
 vqoybvVvV+lDlyFafHyb1AQmj59H1UWu6vilft7PMlZn1CkgPU9esxjzW1aIIW+ywWBj
 Udj5I9gR1kMtWjutL1NRbhChAuUHbUnPbNGqzqbYkjkbI7sy94gi6OuNkgkvUFI0515F
 8abSIYRh9W1om06VP1Y1rY1/9BRsh8VfgJuLmZ+BZIgJ3nbpC1hAYP0ed0rHqB2zazZ5
 +JZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=1aCWly0eHYOBMX2QbB2MVQEtisRq+kLH3ylpaLZI0cc=;
 b=tgsJeHgabBZytwbbznNDKdyS1JwUHtwxYvxXWeg83+bOHMKcHSOpCC4j6o6EawBtnl
 NMRpuoCJMKeCOPHAmX3J62XvJS1Q9qvBRIkHC8Jj6/IgYPYwe10G6SvqcS0HHErAe4bq
 MY1XBG4cHYCJI7dCCbWCuhYmEp+hBYJ/wm/76ER9wwD/VkUpbr1Wq1rIMpqyfcg2qhBR
 n8MkG4YYqXMFH4o30oSpw2ASC9naET6DMwDOsqO8uHz8UDAMeZOUpQaeHZwoRD2mQvw4
 lm8BUw/4TLvEtXjp/6tJNwqgvwMHyfNb2ZsF0BlVPk7eU0J0PR6qIOfS/dgRKWVwxDk3
 3yOw==
X-Gm-Message-State: AOAM532LPuFCgCvFvn41Bi/CsUOGGHDrMB8me4TvPuyugRwM6ruYiK7y
 qLozQUsGzlwHyyqBervD1vvWbJzYL28vfdspGwUzMg==
X-Google-Smtp-Source: ABdhPJzddr7Z3ChXsEeTaXJHTGvoL/NEnML3O1DtWcsC2600kv1w2ebi95vsyLg0smm0e43j3ORQP/5lcH5lDtVqU9E=
X-Received: by 2002:a05:6512:32ab:: with SMTP id
 q11mr306450lfe.106.1615412517738; 
 Wed, 10 Mar 2021 13:41:57 -0800 (PST)
MIME-Version: 1.0
References: <20210310003024.2026253-1-jingzhangos@google.com>
 <20210310003024.2026253-4-jingzhangos@google.com>
 <bb03107c-a413-50da-e228-d338dd471fb3@redhat.com>
In-Reply-To: <bb03107c-a413-50da-e228-d338dd471fb3@redhat.com>
From: Jing Zhang <jingzhangos@google.com>
Date: Wed, 10 Mar 2021 15:41:46 -0600
Message-ID: <CAAdAUtjj52+cAhD4KUzAaqrMSJXHD0g=ecQNG-a92Mqn3BCxiQ@mail.gmail.com>
Subject: Re: [RFC PATCH 3/4] KVM: stats: Add ioctl commands to pull statistics
 in binary format
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
 Paul Mackerras <paulus@ozlabs.org>,
 Linux kselftest <linux-kselftest@vger.kernel.org>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, Will Deacon <will@kernel.org>,
 KVM ARM <kvmarm@lists.cs.columbia.edu>,
 Emanuele Giuseppe Esposito <eesposit@redhat.com>,
 Linux S390 <linux-s390@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
 Oliver Upton <oupton@google.com>, Marc Zyngier <maz@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 David Rientjes <rientjes@google.com>, KVM PPC <kvm-ppc@vger.kernel.org>,
 Jim Mattson <jmattson@google.com>,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Sean Christopherson <seanjc@google.com>, Cornelia Huck <cohuck@redhat.com>,
 Peter Shier <pshier@google.com>, Linux MIPS <linux-mips@vger.kernel.org>,
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

On Wed, Mar 10, 2021 at 8:55 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 10/03/21 01:30, Jing Zhang wrote:
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index 383df23514b9..87dd62516c8b 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -3464,6 +3464,51 @@ static long kvm_vcpu_ioctl(struct file *filp,
> >               r = kvm_arch_vcpu_ioctl_set_fpu(vcpu, fpu);
> >               break;
> >       }
> > +     case KVM_STATS_GET_INFO: {
> > +             struct kvm_stats_info stats_info;
> > +
> > +             r = -EFAULT;
> > +             stats_info.num_stats = VCPU_STAT_COUNT;
> > +             if (copy_to_user(argp, &stats_info, sizeof(stats_info)))
> > +                     goto out;
> > +             r = 0;
> > +             break;
> > +     }
> > +     case KVM_STATS_GET_NAMES: {
> > +             struct kvm_stats_names stats_names;
> > +
> > +             r = -EFAULT;
> > +             if (copy_from_user(&stats_names, argp, sizeof(stats_names)))
> > +                     goto out;
> > +             r = -EINVAL;
> > +             if (stats_names.size < VCPU_STAT_COUNT * KVM_STATS_NAME_LEN)
> > +                     goto out;
> > +
> > +             r = -EFAULT;
> > +             if (copy_to_user(argp + sizeof(stats_names),
> > +                             kvm_vcpu_stat_strings,
> > +                             VCPU_STAT_COUNT * KVM_STATS_NAME_LEN))
>
> The only reason to separate the strings in patch 1 is to pass them here.
>   But this is a poor API because it imposes a limit on the length of the
> statistics, and makes that length part of the binary interface.
Agreed. I am considering returning the length of stats name strings in
the kvm_stats_info structure instead of exporting it as a constant in uapi,
which would put no limit on the length of the stats name strings.
>
> I would prefer a completely different interface, where you have a file
> descriptor that can be created and associated to a vCPU or VM (or even
> to /dev/kvm).  Having a file descriptor is important because the fd can
> be passed to a less-privileged process that takes care of gathering the
> metrics
Separate file descriptor solution is very tempting. We are still considering it
seriously. Our biggest concern is that the metrics gathering/handling process
is not necessary running on the same node as the one file descriptor belongs to.
It scales better to pass metrics data directly than to pass file descriptors.
>
> The result of reading the file descriptor could be either ASCII or
> binary.  IMO the real cost lies in opening and reading a multitude of
> files rather than in the ASCII<->binary conversion.
Agreed.
>
> The format could be one of the following:
>
> * binary:
>
> 4 bytes flags (always zero)
> 4 bytes number of statistics
> 4 bytes offset of the first stat description
> 4 bytes offset of the first stat value
> stat descriptions:
>    - 4 bytes for the type (for now always zero: uint64_t)
>    - 4 bytes for the flags (for now always zero)
>    - length of name
>    - name
> statistics in 64-bit format
>
> * text:
>
> stat1_name uint64 123
> stat2_name uint64 456
> ...
>
> What do you think?
The binary format presented above is very flexible. I understand why it is
organized this way.
In our situation, the metrics data could be pulled periodically as short as
half second. They are used by different kinds of monitors/triggers/alerts.
To enhance efficiency and reduce traffic caused by metrics passing, we
treat all metrics info/data as two kinds. One is immutable information,
which doesn't change in a given system boot. The other is mutable
data (statistics data), which is pulled/transferred periodically at a high
frequency.

>
> Paolo
>

Thanks,
Jing
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
