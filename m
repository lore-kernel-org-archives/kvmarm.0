Return-Path: <SRS0=A4hI=LM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 900C5C48BDF
	for <kvmarm@archiver.kernel.org>; Fri, 18 Jun 2021 17:58:00 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 14E03613ED
	for <kvmarm@archiver.kernel.org>; Fri, 18 Jun 2021 17:58:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 14E03613ED
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 892AB40870;
	Fri, 18 Jun 2021 13:57:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id U4EzvmTlA72c; Fri, 18 Jun 2021 13:57:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6ADD84A49C;
	Fri, 18 Jun 2021 13:57:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CE3004A49C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Jun 2021 13:57:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5LHqyV5Pam8r for <kvmarm@lists.cs.columbia.edu>;
 Fri, 18 Jun 2021 13:57:55 -0400 (EDT)
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com
 [209.85.167.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A0AE640870
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Jun 2021 13:57:55 -0400 (EDT)
Received: by mail-lf1-f41.google.com with SMTP id f30so18035695lfj.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Jun 2021 10:57:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=maDxaMkygfC98K2Jogz/weNvhZGyllV9okYERLKrWaQ=;
 b=hM4ZsTOU9ID7wdvLSCiQA8V5BpnwohQD4F+ZhA+a5pxc6iNnXJ3z9WGHbA1JXlG93m
 BT698mKiYn551XOkseFwSUGgTDfzU1qeujrJVMB6Wa1t31SgD+BDzAbKS7pR/uJ1GR2h
 d/leM993XVeAmOh6vd9/B3Un21AoweRzZT49n2INzXjw3pzD6Y/w22vZC3ULdyV1S/3c
 KmChb8XJiXdgWGJlSRH26KP3t/3kJNx79yPbtJUtR869kLxKtnpGG1ZOeFh1q/freNxh
 Op7GngxAAbdwgAgu+bdYxao5/uGfsrNXlYfnx9wmS47eJ1kVvh23lGRh1Z3muHgn0bbA
 3OgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=maDxaMkygfC98K2Jogz/weNvhZGyllV9okYERLKrWaQ=;
 b=S6ndw0ddn9/SopNl7Xsq7o1u0ASnPBLWFhCdB5AxJki25QLlsJvP3oKaAia8109Lud
 LtAlesw/ldcmlup5K2cVGzqDYQdtHvn94p6FV8Fqf1R50JTvL22FZJviYwft0ZBckO4p
 XgUEs6xAyzCWqUy546LWjOLGS+koF9RYhPvMu2/9EPctL11pDjulsQL7tlTvzpa/lvCW
 VGUQUFDmdVxGEDyJv8atgkkeDxJfBxJxoCjsq8BT/pHPBKFfskzAcAG3GjUrba+hJ262
 1s/2V8+5jksvskBbUtVQRNkPuqkqH6qpalNkIaCKFTsfYqDCIRz5SdK2Ff+XiVAybmVY
 B95w==
X-Gm-Message-State: AOAM530PW1fEc+9ciWQUdjpqOVq00vZtAr6IykU+zY5ZsXX5oZnn+iVD
 KBM6j8uEdhpRGQhg2wSaVhH9g5ionfwMfDS6GSETJg==
X-Google-Smtp-Source: ABdhPJyhz9sA9ZKTa4VM/IMLnRITWImb7PHMT9HE1lgCmMMbxqqMV/BzR7/LJt2PxWXftvvxefjxSj5Ss7JOXAxsjKg=
X-Received: by 2002:a05:6512:33c4:: with SMTP id
 d4mr4273045lfg.536.1624039073748; 
 Fri, 18 Jun 2021 10:57:53 -0700 (PDT)
MIME-Version: 1.0
References: <20210618044819.3690166-1-jingzhangos@google.com>
 <20210618044819.3690166-3-jingzhangos@google.com> <YMxEqvKyGnZinMOS@kroah.com>
 <f2616b8e-0cf8-570f-4bd3-7ef5cbcb37b0@gnu.org> <YMxYC8syYRBhbBAq@kroah.com>
 <22bb0eb6-1305-4af9-aecc-166d7e62e6c3@gnu.org>
In-Reply-To: <22bb0eb6-1305-4af9-aecc-166d7e62e6c3@gnu.org>
From: Jing Zhang <jingzhangos@google.com>
Date: Fri, 18 Jun 2021 12:57:42 -0500
Message-ID: <CAAdAUtgG6awhfkWuDJMQn8-mWYbOSzFZD_amqB+gJ9RH-91VTA@mail.gmail.com>
Subject: Re: [PATCH v11 2/7] KVM: stats: Add fd-based API to read binary stats
 data
To: Paolo Bonzini <bonzini@gnu.org>
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
 Greg KH <gregkh@linuxfoundation.org>, Vitaly Kuznetsov <vkuznets@redhat.com>
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

On Fri, Jun 18, 2021 at 10:51 AM Paolo Bonzini <bonzini@gnu.org> wrote:
>
> On 18/06/21 10:23, Greg KH wrote:
> > On Fri, Jun 18, 2021 at 10:02:57AM +0200, Paolo Bonzini wrote:
> >> On 18/06/21 09:00, Greg KH wrote:
> >>>> +struct kvm_stats_header {
> >>>> +  __u32 name_size;
> >>>> +  __u32 count;
> >>>> +  __u32 desc_offset;
> >>>> +  __u32 data_offset;
> >>>> +  char id[];
> >>>> +};
> >>>
> >>> You mentioned before that the size of this really is the size of the
> >>> structure + KVM_STATS_ID_MAXLEN, right?  Or is it - KVM_STATS_ID_MAXLEN?
> >>>
> >>> If so, why not put that value explicitly in:
> >>>     char id[THE_REST_OF_THE_HEADER_SPACE];
> >>>
> >>> As this is not a variable header size at all, and you can not change it
> >>> going forward, so the variable length array here feels disingenuous.
> >>
> >> It can change; the header goes up to desc_offset.  Let's rename desc_offset
> >> to header_size.
> >
> > "Traditionally" the first field of a variable length structure like this
> > has the size.  So maybe this needs to be:
> >
> > struct kvm_stats_header {
> >       __u32 header_size;
>
> Thinking more about it, I slightly prefer id_offset so that we can later
> give a meaning to any bytes after kvm_stats_header and before id_offset.
>
> Adding four unused bytes (for now always zero) is also useful to future
> proof the struct a bit, thus:
>
> struct kvm_stats_header {
>         __u32 flags;
>         __u32 name_size;
>         __u32 num_desc;
>         __u32 id_offset;
>         __u32 desc_offset;
>         __u32 data_offset;
> }
>
> (Indeed num_desc is better than count).
>
> > Wait, what is "name_size" here for?
>
> So that you know the full size of the descriptors is (name_size +
> sizeof(kvm_stats_desc) + name_size) * num_desc.  That's the memory you
> allocate and the size that you can then pass to a single pread system
> call starting from offset desc_offset.
>
> There is certainly room for improvement in that the length of id[] and
> name[] can be unified to name_size.
>
Thanks for all these ideas, which indeed make it more clear and neat.
Will improve by this and post another version later.
> >>>> +struct kvm_stats_desc {
> >>>> +  __u32 flags;
> >>>> +  __s16 exponent;
> >>>> +  __u16 size;
> >>>> +  __u32 offset;
> >>>> +  __u32 unused;
> >>>> +  char name[];
> >>>> +};
> >>>
> >>> What is the max length of name?
> >>
> >> It's name_size in the header.
> >
> > So it's specified in the _previous_ header?  That feels wrong, shouldn't
> > this descriptor define what is in it?
>
> Compared to e.g. PCI where you can do random-access reads from memory or
> configuration space, reading from a file has slightly different
> tradeoffs.  So designing a file format is slightly different compared to
> designing an in-memory format, or a wire protocol.
>
> Paolo

Jing
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
