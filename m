Return-Path: <SRS0=JLBt=LF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5C1DC48BE0
	for <kvmarm@archiver.kernel.org>; Fri, 11 Jun 2021 13:40:51 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 29A4761400
	for <kvmarm@archiver.kernel.org>; Fri, 11 Jun 2021 13:40:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 29A4761400
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8AC074B0C6;
	Fri, 11 Jun 2021 09:40:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vI8Un28ebmHH; Fri, 11 Jun 2021 09:40:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4FCEA4B096;
	Fri, 11 Jun 2021 09:40:49 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BE3B44B096
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Jun 2021 09:40:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kyIFYes4TivZ for <kvmarm@lists.cs.columbia.edu>;
 Fri, 11 Jun 2021 09:40:46 -0400 (EDT)
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com
 [209.85.167.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A29ED4B090
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Jun 2021 09:40:46 -0400 (EDT)
Received: by mail-lf1-f43.google.com with SMTP id x24so2996991lfr.10
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Jun 2021 06:40:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=7VAgpxI0j7t6r6tnNN0LDsrTuOsaMVKhAYb54Y9rji0=;
 b=R6HK/NJxHEZTezhNED+ResyUbr+sC601m/iO/yfsGQgv6ogP2SdmM5iYweIFBi+81P
 hyF9E/8Xrldy8fIf8GayGtdco3cQrPxbrr6+/VnjT57oUnU0JHiWvCKCdunlXn5JDwIx
 Jf8RrszvH2/kPhgoitfHztj1hflGpwARazZuN8JqgjX/r6rahbdqT704CgMt52xFNjx+
 jd9QIGoU6NqAn2WCvCywUPJNfMGD1iBAceqc3mhlCZfuY8wtzlxpHztJ47QiaBCsYC4L
 rLQblEYrRoF4996ROTgZ1ptPvyBrxnj2cPeGJJUJGJzpvgUobPC0lVTmbD92+xt19t9h
 QaRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=7VAgpxI0j7t6r6tnNN0LDsrTuOsaMVKhAYb54Y9rji0=;
 b=YIWTUJniqI7t/xIRwfQPkxlZECE8G44fiUhVrnKQo28BeVQnwRdHFhWjdH3svkjQ0w
 E+7qM8xwW7aCS7y2DNBP14yZISej31hBd+idM9jzVItk8MCx4pGgFooZImY3E6Ne9d+O
 JuazzlVqcisJuXYDQiYa1ftQH+lzZDPkhjzZtoyET6IIn2BRtGqIWb7JLqkx6+kzIev1
 S7ZmAdlgaPLZ/Of2dXiGt171Jq5OMxu0laKWXvASokdtw8BnXn4ITZQDBa2Hy+GZqyiz
 zj66bYkiN/Llb067pEzSfsl/B4+iT3rpsLNrbB7XhciN0rCfsOr6lPilkQIG1jaMn5ZY
 B+bQ==
X-Gm-Message-State: AOAM533/NX8c69Uo04+2Opj1FosWamiecea3H0t1kulkeriZjVU1UFcE
 y/mffXt97d2txGXcPjD+ld/aAL+o+qEvkAZ15kgF3A==
X-Google-Smtp-Source: ABdhPJyd/EWKehnkyt/vEE7X4dLTk7ydhohkYIDaOlTtBlusLIXCnO+/tsxRSHdwRgbB5WhF0L3bzLcFmsQAmgprGWM=
X-Received: by 2002:a19:ed18:: with SMTP id y24mr2814385lfy.359.1623418844699; 
 Fri, 11 Jun 2021 06:40:44 -0700 (PDT)
MIME-Version: 1.0
References: <20210611124624.1404010-1-jingzhangos@google.com>
 <d9d440f0-ac2d-5a90-4e90-5eaa365f422e@redhat.com>
In-Reply-To: <d9d440f0-ac2d-5a90-4e90-5eaa365f422e@redhat.com>
From: Jing Zhang <jingzhangos@google.com>
Date: Fri, 11 Jun 2021 08:40:33 -0500
Message-ID: <CAAdAUthF98tacvqb-WR8xX4EJzjhu0yeM=-qVk7oViiOF12kEw@mail.gmail.com>
Subject: Re: [PATCH v8 0/4] KVM statistics data fd-based binary interface
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

On Fri, Jun 11, 2021 at 8:35 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 11/06/21 14:46, Jing Zhang wrote:
> > This patchset provides a file descriptor for every VM and VCPU to read
> > KVM statistics data in binary format.
> > It is meant to provide a lightweight, flexible, scalable and efficient
> > lock-free solution for user space telemetry applications to pull the
> > statistics data periodically for large scale systems. The pulling
> > frequency could be as high as a few times per second.
> > In this patchset, every statistics data are treated to have some
> > attributes as below:
> >    * architecture dependent or generic
> >    * VM statistics data or VCPU statistics data
> >    * type: cumulative, instantaneous,
> >    * unit: none for simple counter, nanosecond, microsecond,
> >      millisecond, second, Byte, KiByte, MiByte, GiByte. Clock Cycles
> > Since no lock/synchronization is used, the consistency between all
> > the statistics data is not guaranteed. That means not all statistics
> > data are read out at the exact same time, since the statistics date
> > are still being updated by KVM subsystems while they are read out.
>
> The binary interface itself looks good.  Can you do a follow-up patch to
> remove struct kvm_stats_debugfs_item and avoid the duplication?  I'd
> rather have that too before committing the code.
>
> Thanks,
>
> Paolo
>
Sure. Will do.

Thanks,
Jing
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
