Return-Path: <SRS0=nsVm=IN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4AA4C433E0
	for <kvmarm@archiver.kernel.org>; Mon, 15 Mar 2021 22:31:33 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 130C864F4D
	for <kvmarm@archiver.kernel.org>; Mon, 15 Mar 2021 22:31:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 130C864F4D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5E3524B5E2;
	Mon, 15 Mar 2021 18:31:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id apuKCR86E9Cm; Mon, 15 Mar 2021 18:31:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1C87D4B5D6;
	Mon, 15 Mar 2021 18:31:31 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 027F04B5D1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 18:31:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QWMWmxhdtiUo for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Mar 2021 18:31:28 -0400 (EDT)
Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com
 [209.85.208.182])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9F0E64B5CF
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 18:31:28 -0400 (EDT)
Received: by mail-lj1-f182.google.com with SMTP id u4so18190395ljo.6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 15:31:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=t48JfE/I+ydsOOfkocl4ExwOYD4Cwrny9/Xf4iuVVeE=;
 b=YzOHwW9gU+2CCoT9hKyxcZQ9g6o779atEw1QSJLPBRAVTj7Gc0vDffISoB/Cd9mLvk
 keJsigpwHmgy2X42PpmONt7PB65J85QkeCx9fHcaIGkNovhredA86swM4cAXZwH+PSi8
 lRrPBaNDuKAYAs9HX13mcFnjNF4HVRXNtJQ97EfCuIjTjC3+fdoJesfZFgSy75Qsy3h5
 3KMoc/MoTsK7c1+mpTCTSVgVngYK9wFNZHp/tgw8qVex1AQ+P9QYvrUzbu9XpmNTz0v7
 2GyGh2j9ZBeGQ8E+jCJEwyRovr3E+WurRkyCDBICw0iCS9XJ4oKdl+9A7ZLiVshUP9R/
 VTaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=t48JfE/I+ydsOOfkocl4ExwOYD4Cwrny9/Xf4iuVVeE=;
 b=A7CATll6TNJfc/bpywX8rsiILUNgxhJiU9MHtgXUayf8mCMmEI2tZXfWS7YmPsr2gD
 qo5WMTdpJ6LHIEHECyLiXz70Tw/4FaHDj4CvLe/RJj4UtWUmSmR+kuFGLyzAQLhIjqwv
 Fvnd/WlRsJPACZoz6XMIAU0mjObPgSYzEdvM9u/+/jhJLKDKJohr/nLcV//1amjbe9ND
 7XkKxVtX/F4WTuTQ+eywW/LR4PSDD7z0meIQ0yF94CZcsp04paKTXx8mvBTQPwVvIqqh
 blf15PUuDqKOCkC2LsPfuJQ1W/Ng/cMJs3t1+D4GgbvXsMJfJRU6ugOqXefU+gL6zY8S
 V+Gw==
X-Gm-Message-State: AOAM530JvfSAyxBxuWf2HUCatguh1i36kILYHRVFhNDGQDgyXFHoleZV
 v7P/KlkQk6kQPs2anfJJ9nRopVTAmBPSl9wb7cZUrQ==
X-Google-Smtp-Source: ABdhPJxjr/et45iqQeRMTErI0LQhEQm42DqVbpHRSpcjhEUlWFO96pLBoZaf9saYhs4q/r0gUqfHvBityBsZA51vteE=
X-Received: by 2002:a2e:988f:: with SMTP id b15mr751964ljj.394.1615847486669; 
 Mon, 15 Mar 2021 15:31:26 -0700 (PDT)
MIME-Version: 1.0
References: <20210310003024.2026253-1-jingzhangos@google.com>
 <20210310003024.2026253-4-jingzhangos@google.com>
 <bb03107c-a413-50da-e228-d338dd471fb3@redhat.com>
In-Reply-To: <bb03107c-a413-50da-e228-d338dd471fb3@redhat.com>
From: Jing Zhang <jingzhangos@google.com>
Date: Mon, 15 Mar 2021 17:31:15 -0500
Message-ID: <CAAdAUth0J6z7fFpOkkmzKc83Bj+MST-jhsZ0uU0iYdRcE_-gMA@mail.gmail.com>
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
>
> I would prefer a completely different interface, where you have a file
> descriptor that can be created and associated to a vCPU or VM (or even
> to /dev/kvm).  Having a file descriptor is important because the fd can
We are considering about how to create the file descriptor. It might be risky
to create an extra fd for every vCPU. It will easily hit the fd limit for the
process or the system for machines running a ton of small VMs.
Looks like creating an extra file descriptor for every VM is a better option.
And then we can check per vCPU stats through Ioctl of this VM fd by
passing the vCPU index.
What do you think?
> be passed to a less-privileged process that takes care of gathering the
> metrics
>
> The result of reading the file descriptor could be either ASCII or
> binary.  IMO the real cost lies in opening and reading a multitude of
> files rather than in the ASCII<->binary conversion.
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
>
> Paolo
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
