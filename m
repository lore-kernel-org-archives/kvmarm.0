Return-Path: <SRS0=A4hI=LM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0201BC49EB7
	for <kvmarm@archiver.kernel.org>; Fri, 18 Jun 2021 13:03:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6974A613D1
	for <kvmarm@archiver.kernel.org>; Fri, 18 Jun 2021 13:03:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6974A613D1
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EC98C4A2E5;
	Fri, 18 Jun 2021 09:03:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QoqPtykZMjp0; Fri, 18 Jun 2021 09:03:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AB3524A51D;
	Fri, 18 Jun 2021 09:03:04 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 322F14A4A0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Jun 2021 09:03:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QFAjJQ0rLUKl for <kvmarm@lists.cs.columbia.edu>;
 Fri, 18 Jun 2021 09:03:03 -0400 (EDT)
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com
 [209.85.208.179])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D31B94A4A3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Jun 2021 09:03:02 -0400 (EDT)
Received: by mail-lj1-f179.google.com with SMTP id k8so13841358lja.4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Jun 2021 06:03:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=sEclsuEWMpJAtZre1q7afze1RnKMopUqEN3Jq0eFLJo=;
 b=vWbKHgBItt8O7lINA7KgYjqeNkMrhXk8Vo4/mwzHt+XzDHF8TwoTLudfyISLKu6e4E
 crEoUad+aXxFkZUoUzykuOPLXpriwUyBVa9xD/29tvlKgKsc5veLSdSs0P8uStI83p6J
 IOpxlJyoPzpIyURxXbWjcWr7jsnP6TrgAuFYCQuahJJpg/9IjrJXQVaGo6+I35vTmLQW
 2hHg/yrkx6UZ8hw+T45mpqVwes2HiyNqHTDc9ltDAtxIZ2oThwvBodTxWmAlYDJZ39oe
 zQ0v1ar5jAXbN2cs6bmCH09I7Amcqg8oZDxc1oLafArpZfJzE/dmGXxUQRHSEt4uGj35
 EDYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=sEclsuEWMpJAtZre1q7afze1RnKMopUqEN3Jq0eFLJo=;
 b=RChVFxGl/FZFM//kXy0ZGbs5bsgi8Ycpwy3y94G4b6AehigZ1T/usMRt4xL19qvJxU
 9hSo49y6wkaGt8TwPNBA+xVeGLO9NAl7yyYFpbZizCRHq1KJfhByzDfw4zxVh/LAGYRs
 8y+y28xFuoZGGZ9E0HxZwWyINlLjk16A5EJFVLxDcHcxgnVShBIdqKe9ki95uaVCyzXG
 eeqovGqZJKiZP+vV8dq6cdQX7XQtS24atPGvV819YtccI9acqRaMsmgVF/2yl+FQuNeN
 LediOdCaehWD0kcnvMj7meMtAoUnqExqzCRd7O8sIoa2OD68kNgvEyxrqbtREau4DDga
 Fp9Q==
X-Gm-Message-State: AOAM530DHaMR9VJq9f1vU8TU5+NUkMvm6rzzImU6foTl4i0jQi6Xb6KN
 wtNbEXXF4KYRQpilpJkV24F9In+HOt1c9giPkMwC9A==
X-Google-Smtp-Source: ABdhPJwYJQdcIEytkrMx0Wz3wvyodJYH5zp4XXjs8/9Vx6hj1aP7xcJZkVdJWvuJ4nqyknxb0IdsL0leVGFcKnX9GTM=
X-Received: by 2002:a05:651c:150a:: with SMTP id
 e10mr9521276ljf.215.1624021379799; 
 Fri, 18 Jun 2021 06:02:59 -0700 (PDT)
MIME-Version: 1.0
References: <20210618044819.3690166-1-jingzhangos@google.com>
 <20210618044819.3690166-3-jingzhangos@google.com> <YMxEqvKyGnZinMOS@kroah.com>
 <f2616b8e-0cf8-570f-4bd3-7ef5cbcb37b0@gnu.org> <YMxYC8syYRBhbBAq@kroah.com>
In-Reply-To: <YMxYC8syYRBhbBAq@kroah.com>
From: Jing Zhang <jingzhangos@google.com>
Date: Fri, 18 Jun 2021 08:02:48 -0500
Message-ID: <CAAdAUticeB2Rr8g5eywPvHGGYfsXV=mNA4mNbd4thAae9zbXWA@mail.gmail.com>
Subject: Re: [PATCH v11 2/7] KVM: stats: Add fd-based API to read binary stats
 data
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
 David Rientjes <rientjes@google.com>, Paolo Bonzini <bonzini@gnu.org>,
 KVMPPC <kvm-ppc@vger.kernel.org>, Krish Sadhukhan <krish.sadhukhan@oracle.com>,
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

On Fri, Jun 18, 2021 at 3:23 AM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Fri, Jun 18, 2021 at 10:02:57AM +0200, Paolo Bonzini wrote:
> > On 18/06/21 09:00, Greg KH wrote:
> > > > +struct kvm_stats_header {
> > > > + __u32 name_size;
> > > > + __u32 count;
> > > > + __u32 desc_offset;
> > > > + __u32 data_offset;
> > > > + char id[];
> > > > +};
> > >
> > > You mentioned before that the size of this really is the size of the
> > > structure + KVM_STATS_ID_MAXLEN, right?  Or is it - KVM_STATS_ID_MAXLEN?
> > >
> > > If so, why not put that value explicitly in:
> > >     char id[THE_REST_OF_THE_HEADER_SPACE];
> > >
> > > As this is not a variable header size at all, and you can not change it
> > > going forward, so the variable length array here feels disingenuous.
> >
> > It can change; the header goes up to desc_offset.  Let's rename desc_offset
> > to header_size.
>
> "Traditionally" the first field of a variable length structure like this
> has the size.  So maybe this needs to be:
>
> struct kvm_stats_header {
>         __u32 header_size;
>         __u32 name_size;
>         __u32 num_desc;
>         __u32 desc_offset;
>         __u32 data_offset;
>         char id[];
> };
>
> I just guessed at what "count" is as I do not remember at the moment,
> but obviously "count" wasn't descriptive :)
>
> Wait, what is "name_size" here for?
>
> > > > +struct kvm_stats_desc {
> > > > + __u32 flags;
> > > > + __s16 exponent;
> > > > + __u16 size;
> > > > + __u32 offset;
> > > > + __u32 unused;
> > > > + char name[];
> > > > +};
> > >
> > > What is the max length of name?
> >
> > It's name_size in the header.
>
> So it's specified in the _previous_ header?  That feels wrong, shouldn't
> this descriptor define what is in it?
>
> I'm not trying to nit-pick here, I'm actually confused now.  Structures
> that contain "headers" should have in those headers at least two things:
>         - declare the size of themselves if they are variable length
>         - declare offsets to other structures
>
> Don't put a size in this header for the size of a later structure,
> that's just extra complexity that is not needed.
>
> Think of this as a stream of bytes across the wire like a hardware
> descriptor.  We have loads of experience dealing with this with
> protocols like USB and Greybus and PCI and the like.  Let's learn from
> those experiences and not try to mess things up where we don't need to
> :)
>
>
The name_size in the header is necessary for userspace to discover the
length of a descriptor of a KVM statistics, since the size of name[] in every
descriptor could be different (increased) in future versions.
One thing worth mentioning is that, for every file content, there is only one
header, but many descriptors, that's why it makes sense to have the size of
name[] in the header instead of in the descriptor. We don't want every
descriptor contain the same duplicated information.
> >
> > > Why aren't these structures defined here in kerneldoc so that we can
> > > understand them better?  Putting them in a .rst file guarantees they
> > > will get out of sync, and you can always directly import the kerneldoc
> > > into the .rst file.
> >
> > This is a problem in general with Documentation/virt/kvm/api.rst.  The file
> > is organized to match the kerneldoc structs to the ioctl that they are used
> > for, and sometimes a ioctl includes different structs for each architecture.
> >
> > It is probably possible to do it using :identifiers: and/or :doc:, but it
> > would require running scripts/kernel-doc on the uAPI headers dozens of
> > times.  That is quite expensive at 0.3s each run, but that's what you get
> > with Perl (gcc -fsyntax-only is 20 times faster).
>
> Is that what v4l and drm do today?  That's still safer and more
> "obvious" than trying to keep two different files in sync which, as I
> well know, almost impossible to do well over the _years_ in which you
> will have to maintain these files.
>
> Let's make it easier for everyone, put it only in one place and if
> people want to see the documentation, they can generate it (it's
> auto-generated on kernel.org anyway), no need to worry about multiple
> passes or not.
>
> thanks,
>
> greg k-h
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
