Return-Path: <SRS0=QphI=J3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55309C43462
	for <kvmarm@archiver.kernel.org>; Fri, 30 Apr 2021 15:35:16 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 91B1661459
	for <kvmarm@archiver.kernel.org>; Fri, 30 Apr 2021 15:35:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 91B1661459
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 10E8C4B39F;
	Fri, 30 Apr 2021 11:35:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fd1NxytKW98N; Fri, 30 Apr 2021 11:35:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 110444B3AC;
	Fri, 30 Apr 2021 11:35:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E0344B39F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Apr 2021 11:35:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1xQZ4ni0fpny for <kvmarm@lists.cs.columbia.edu>;
 Fri, 30 Apr 2021 11:35:11 -0400 (EDT)
Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com
 [209.85.208.174])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C14844B39D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Apr 2021 11:35:11 -0400 (EDT)
Received: by mail-lj1-f174.google.com with SMTP id s9so23396682ljj.6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Apr 2021 08:35:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=Zw/V8/6W4skoSH0mSs8cW3qf3BAXRpq8TIlzvcUbh9Y=;
 b=KB8gW36y7USDPOimeqhXInwA40Pnt1d90bk9cbUzrAJc2frJTwsE8DUmYpsixNTY5D
 0VEStw8wvZ8I0IlKf2CJfoljSzTfYWIayX3SvyxM1bomk9H/siwFiNjIEIKFbzohtdgO
 w6vFYnxfHEF3wCnVt6V3YoSITDNsGsa10Pis/sjL+FQpIE58o9XbL+C2P81CYaPhq8Qt
 qj8CGwVy7J+1cUwf/CXA01U/5rkNLcbVSAinzGvr1lHAjjXEfQK4i5hKVhhHHO2QhunW
 aiKrl9b+u8yIOotQlVcCRKukY18jn7e3TOfbROxw1rCaup7aO+V4Nvp132xeshzjhRwg
 DFLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=Zw/V8/6W4skoSH0mSs8cW3qf3BAXRpq8TIlzvcUbh9Y=;
 b=ZKlki1lTy6cM/0JRCMaMckS/U7deOmQ5R+dsT0t7pFa1ElPiE5ksp4eouwteovyBAg
 n3EKNpNzps5XCXkIA9BdeDawDb13cMKGn6/0z8GtCogpQoI1gkc+ModN1KWbEwj9cr1m
 uBkMHldtadiLEC5UVYmdAa4EXE2/+Ed1GH6ozwBD6ysVH9pfrXetXVT6OMpgt49jJRGc
 IQAlVII/9wcCRL5/l65Xa+/ghhmNjFxDju452MT5gYiihknugIMGgQq9xZOon176YVJU
 NGPzeC/QzHy6Ggg6Fk2XEPzQeF2rIzKI5NGBkkEk9GikLmpjjX4mww+OkFvyIZT2MrmS
 W5TQ==
X-Gm-Message-State: AOAM533JRDESgjHS+bBPwhMeabgzFkm16/rEK3gk03QF9ZW35JLhj/Yv
 UIYDCULUhQuhZSKM6+UoKxk7fa3ceMOydlFnrqb9WQ==
X-Google-Smtp-Source: ABdhPJx/QRgwRdWJdR4aTn2uakfmtAz6C7OxdhfGIo2oiu582wd/0wprc5qi+RX6OipU6nb2KN0bPjeYB4Dj/CDoOuM=
X-Received: by 2002:a2e:9a0a:: with SMTP id o10mr4294282lji.216.1619796910218; 
 Fri, 30 Apr 2021 08:35:10 -0700 (PDT)
MIME-Version: 1.0
References: <20210429203740.1935629-1-jingzhangos@google.com>
 <20210429203740.1935629-2-jingzhangos@google.com>
 <87bl9wnfgo.wl-maz@kernel.org>
In-Reply-To: <87bl9wnfgo.wl-maz@kernel.org>
From: Jing Zhang <jingzhangos@google.com>
Date: Fri, 30 Apr 2021 10:34:58 -0500
Message-ID: <CAAdAUtiMV_cVXPKBBEymNub8qYq-whLdihKG0si4_ALxK=yv6g@mail.gmail.com>
Subject: Re: [PATCH v4 1/4] KVM: stats: Separate common stats from
 architecture specific ones
To: Marc Zyngier <maz@kernel.org>
Cc: KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
 Paul Mackerras <paulus@ozlabs.org>,
 Linuxkselftest <linux-kselftest@vger.kernel.org>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, Will Deacon <will@kernel.org>,
 KVMARM <kvmarm@lists.cs.columbia.edu>,
 Emanuele Giuseppe Esposito <eesposit@redhat.com>,
 LinuxS390 <linux-s390@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
 Oliver Upton <oupton@google.com>, Huacai Chen <chenhuacai@kernel.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 David Rientjes <rientjes@google.com>, KVMPPC <kvm-ppc@vger.kernel.org>,
 Jim Mattson <jmattson@google.com>,
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

Hi Marc,

On Fri, Apr 30, 2021 at 7:07 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Thu, 29 Apr 2021 21:37:37 +0100,
> Jing Zhang <jingzhangos@google.com> wrote:
>
> > +struct kvm_vm_stat_common {
> > +     ulong remote_tlb_flush;
> > +};
> > +
> > +struct kvm_vcpu_stat_common {
> > +     u64 halt_successful_poll;
> > +     u64 halt_attempted_poll;
> > +     u64 halt_poll_invalid;
> > +     u64 halt_wakeup;
> > +     u64 halt_poll_success_ns;
> > +     u64 halt_poll_fail_ns;
> > +};
>
> Why can't we make everything a u64? Is there anything that really
> needs to be a ulong? On most architectures, they are the same anyway,
> so we might as well bite the bullet.
That's a question I have asked myself many times. It is a little bit annoying
to handle different types for VM and VCPU stats.
This divergence was from the  commit 8a7e75d47b681933, which says
"However vm statistics
 could potentially be updated by multiple vcpus from that vm at a time.
 To avoid the overhead of atomics make all vm statistics ulong such that
 they are 64-bit on 64-bit systems where they can be atomically incremented
 and are 32-bit on 32-bit systems which may not be able to atomically
 increment 64-bit numbers."

I would be very happy if there is a lock-free way to use u64 for VM stats.
Please let me know if anyone has any idea about this.
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.

Thanks,
Jing
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
