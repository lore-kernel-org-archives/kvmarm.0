Return-Path: <SRS0=srdq=LL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_RED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C675EC2B9F4
	for <kvmarm@archiver.kernel.org>; Thu, 17 Jun 2021 22:16:14 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3F501613AA
	for <kvmarm@archiver.kernel.org>; Thu, 17 Jun 2021 22:16:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3F501613AA
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AD9B34B0BC;
	Thu, 17 Jun 2021 18:16:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id S0IoP5T+QAgr; Thu, 17 Jun 2021 18:16:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9962B4B09A;
	Thu, 17 Jun 2021 18:16:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C42C440825
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Jun 2021 18:16:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YnuWmSTgHOV0 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 17 Jun 2021 18:16:10 -0400 (EDT)
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com
 [209.85.167.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 80BD9407EC
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Jun 2021 18:16:10 -0400 (EDT)
Received: by mail-lf1-f43.google.com with SMTP id r198so12953940lff.11
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Jun 2021 15:16:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=Om4JuohRkmHi4PHjJKgFSJXAnZij6pa7PZ+XB/Q93x4=;
 b=OOJpmNp62ZqVr6/h+5AHW1TBMZyF0mEzGOtoq/r2otQshVmw6uWPHvvmIPVKxDZJ8S
 INOe1MRD5ArDkisHNAm/m/BeaB21SJGpgm0A0A3o4jnwtPPOT4BI93x+cGmvun04tUfc
 9oed64L6ruhD5G0X3ATf8KfMWJvcjZqq/9ntWbomgnwy3H+yhpsCepGn6VD/wurC/N2N
 7eTCkGorBvJvG4JgwwjnhfMl4FmZhS2UCV+rteS/vwvyVaM5uFd33dISni3uW5mwJT7O
 a4PveGpEHqaokkFSRfCPS/C0SoVok/Hk+wPlQvWnytijp/pOuCFCkw2JVIvA6GOEp8Ed
 73Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=Om4JuohRkmHi4PHjJKgFSJXAnZij6pa7PZ+XB/Q93x4=;
 b=H8LX53Q8yvWLTfWrBrdk/Xgohpb3Rg5c+8H+Wt726jgyQ9PR3ZnVRx8/HVwRI+mx2i
 KSOP66kjPZGWjMP0RCIM4uUVDMLTgJmqRJThR9KwnSG873X63UNMUVxE/t+Z3jYTRkSo
 eyEYkVpkl6PczDeVZt/Yx/6h79qZki5jwm/JxEzpVssm8MsPs5hPHs6Kzy0GkWLFglOp
 BgnbF75lLgX5DD2TXL5eZwgv9gjNyHhXrA35KAX0ywu18+HvUg5xKYo0gloruGSz+Zf2
 dbMs1G2sMZsAeJdlQdz8lS/c84VxkMkQniFY1Oilo/ql18Q+Mrp5+vv5NMp3b3HUdW/y
 msPg==
X-Gm-Message-State: AOAM532HIqCY9KSJnARISknjD1S7TynTPEXux5i/5df7hOLicYNXBXF9
 0EBGosPtYSd+vBPUaPkUGRgUaEukejjqAg5hUDvWsQ==
X-Google-Smtp-Source: ABdhPJxohFfvIE3vimsdKuy3pBfzuaga47QP5AbxcBntiUHpDUZF67j+bYeQSRMJ5KlBsVBRHTjWoXc8V+tBTOqYm9M=
X-Received: by 2002:a05:6512:318d:: with SMTP id
 i13mr403328lfe.407.1623968168586; 
 Thu, 17 Jun 2021 15:16:08 -0700 (PDT)
MIME-Version: 1.0
References: <20210617044146.2667540-1-jingzhangos@google.com>
 <20210617044146.2667540-4-jingzhangos@google.com> <YMrkGZzPrt0jA1iP@kroah.com>
 <CAAdAUtik0Yw+4=4Ld-DJSokNzvdpa-tsxkqAdBCAb-C=uS0-sA@mail.gmail.com>
In-Reply-To: <CAAdAUtik0Yw+4=4Ld-DJSokNzvdpa-tsxkqAdBCAb-C=uS0-sA@mail.gmail.com>
From: Jing Zhang <jingzhangos@google.com>
Date: Thu, 17 Jun 2021 17:15:57 -0500
Message-ID: <CAAdAUthDbVvzFMGEp5sWEZ0MrtWaJBV4F_N4ois1D+4NO3n7fg@mail.gmail.com>
Subject: Re: [PATCH v10 3/5] KVM: stats: Add documentation for binary
 statistics interface
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

Hi Greg,

On Thu, Jun 17, 2021 at 10:20 AM Jing Zhang <jingzhangos@google.com> wrote:
>
> Hi Greg,
>
> On Thu, Jun 17, 2021 at 12:56 AM Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Thu, Jun 17, 2021 at 04:41:44AM +0000, Jing Zhang wrote:
> > > +     struct kvm_stats_desc {
> > > +             __u32 flags;
> > > +             __s16 exponent;
> > > +             __u16 size;
> > > +             __u32 offset;
> > > +             __u32 unused;
> > > +             char name[0];
> > > +     };
> >
> > <snip>
> >
> > > +The ``unused`` fields are reserved for future support for other types of
> > > +statistics data, like log/linear histogram.
> >
> > you HAVE to set unused to 0 for now, otherwise userspace does not know
> > it is unused, right?  And then, really it is "used", so why not just say
> > that now?  It's tricky, but you have to get this right now otherwise you
> > can never use it in the future.
> >
> Sure, will do that.
> > > +The ``name`` field points to the name string of the statistics data. The name
> >
> > It is not a pointer, it is the data itself.
> >
> Will fix it.
> > > +string starts at the end of ``struct kvm_stats_desc``.
> > > +The maximum length (including trailing '\0') is indicated by ``name_size``
> > > +in ``struct kvm_stats_header``.
> >
> > I thought we were replacing [0] arrays with [], are you sure you should
> > be declaring this as [0]?  Same for all structures in this document (and
> > code).
> >
> The reason to declare it as [0] is to have the flexibility to change the maximum
> length of KVM stats name. For now, the max len is  defined as 48, which can
> be read from the header. Then the userspace can get the length of descriptor by
> adding sizeof(struct_kvm_stats_desc) + 48. Whenever the max len is changed
> in KVM, the userspace would not have to update code to reflect that.
> However, if we are OK to restrict the maximum KVM stats' length to 48
> (or any other
> number), we can just declear it with [] instead of [0].
Please ignore my above comments.
You are right. We can just replace all zero-length arrays [0] with a
flexible array
member []. Thanks.
> > thanks,
> >
> > greg k-h
>
> Thanks,
> Jing
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
