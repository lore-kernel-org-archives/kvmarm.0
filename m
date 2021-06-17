Return-Path: <SRS0=srdq=LL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00418C49EA2
	for <kvmarm@archiver.kernel.org>; Thu, 17 Jun 2021 15:45:29 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7A67760249
	for <kvmarm@archiver.kernel.org>; Thu, 17 Jun 2021 15:45:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7A67760249
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E323F4B0B2;
	Thu, 17 Jun 2021 11:45:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9N9QjFZZAwpA; Thu, 17 Jun 2021 11:45:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DF8404B09F;
	Thu, 17 Jun 2021 11:45:26 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3BF874B099
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Jun 2021 11:45:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vAdkCNIjsEiG for <kvmarm@lists.cs.columbia.edu>;
 Thu, 17 Jun 2021 11:45:24 -0400 (EDT)
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com
 [209.85.167.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 270F54B097
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Jun 2021 11:45:24 -0400 (EDT)
Received: by mail-lf1-f42.google.com with SMTP id j2so11286759lfg.9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Jun 2021 08:45:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=6PIz2TaIUWVoaOhj01hoKWnDrlEbbHPMNsId5QQRgVk=;
 b=kK7POj3fWrdNp5TQ/g3C2HbiICwLbyWBlPreXKzcvrqAPYwo5KHxj2hz6zacIzW48g
 aAWKreLHCRCbzUPm74najsUXpLcac7bKdwfZcU3+QELkdEs02W87bAh8ZDdJ0ka66EBM
 XhXC61cC8GQ3WfftVjVDmxCfwTULCyLu13yZbkj1sxOpMHcMTJtyBcLE3IiuZSfj9QyL
 Zk7V0jrjqDgnT7mYuNxBqUJeicHd+u95kjqFE02S8z9QeF4aA6DC0xkfwpcBrQnEBwRZ
 reOQeIQnwupuCMmH5Pw6Sb3KO0sR5qRGw13cHIT4bOp209Yifcx7flqwWpyurqPIE8Dg
 A1sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=6PIz2TaIUWVoaOhj01hoKWnDrlEbbHPMNsId5QQRgVk=;
 b=NN00vCwGRZa9GufqZIa3RfPgs28VYMc7LDLsCwU3bDN9tOVp/Xw23xdbANQJUk0/4Q
 n7exCTgE8b+rIir264kdKomfV7cqxr9LBBRDts78FVR//t3SqiVrb5cncAEF63WspQZ/
 o+CQJQtUrQn3gVC9AUugEqoCy5ZBgNXKIfV3HnClg96wWc1r+i/HpV/F/Fejw/U7NnbJ
 ZZpXf4kV/E7Gfkqe1jI3/tewmToyuoG1Lc3j1Ff7zGL5iQmyC5rYrZH/+9OIPby00SRk
 Tfu8xON+F3B374OoyXkNzl2YqB9p7CYxKGiAcMqSCdHHsypo+HkGjbCYu7a/imD7TNYy
 22KQ==
X-Gm-Message-State: AOAM531xuKxO5NoB2A6uQIk74fTvhsLAyh5yn8MxEZ7Cq7BUrVxeGhYH
 XWWt1fiWGW/2TuPPY70TfRDkvP1b1NRMJytaKem75A==
X-Google-Smtp-Source: ABdhPJwP8tw7uaKfFVnTtgmhBu0Z34sOJoaN3DTP50XOdwnYzL4tcVKakB1bGY53u3B1KUyAsBU0zeV3DiONBmuXTbk=
X-Received: by 2002:a19:7601:: with SMTP id c1mr4591175lff.106.1623944722534; 
 Thu, 17 Jun 2021 08:45:22 -0700 (PDT)
MIME-Version: 1.0
References: <20210617044146.2667540-1-jingzhangos@google.com>
 <20210617044146.2667540-4-jingzhangos@google.com> <YMrkGZzPrt0jA1iP@kroah.com>
 <0d959828-da89-bceb-f7cc-35622a60c431@redhat.com>
In-Reply-To: <0d959828-da89-bceb-f7cc-35622a60c431@redhat.com>
From: Jing Zhang <jingzhangos@google.com>
Date: Thu, 17 Jun 2021 10:45:10 -0500
Message-ID: <CAAdAUtiAEp-+MydpamzysT4aAXvu9tvhOY0YecnQkGkWp6pJWA@mail.gmail.com>
Subject: Re: [PATCH v10 3/5] KVM: stats: Add documentation for binary
 statistics interface
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

On Thu, Jun 17, 2021 at 6:32 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 17/06/21 07:56, Greg KH wrote:
> > On Thu, Jun 17, 2021 at 04:41:44AM +0000, Jing Zhang wrote:
> >> +    struct kvm_stats_desc {
> >> +            __u32 flags;
> >> +            __s16 exponent;
> >> +            __u16 size;
> >> +            __u32 offset;
> >> +            __u32 unused;
> >> +            char name[0];
> >> +    };
> >
> > <snip>
> >
> >> +The ``unused`` fields are reserved for future support for other types of
> >> +statistics data, like log/linear histogram.
> >
> > you HAVE to set unused to 0 for now, otherwise userspace does not know
> > it is unused, right?
>
> Jing, I think you planned to use it with other flags that are unused for
> now?  But please do check that it's zero in the testcase.
>
Yes, it was planned for future use (to support stats type of histogram).
Will add check in testcase and clarify it in doc.
> > It is not a pointer, it is the data itself.
> >
> >> +string starts at the end of ``struct kvm_stats_desc``.
> >> +The maximum length (including trailing '\0') is indicated by ``name_size``
> >> +in ``struct kvm_stats_header``.
> >
> > I thought we were replacing [0] arrays with [], are you sure you should
> > be declaring this as [0]?  Same for all structures in this document (and
> > code).
>
> In C code [0] is a bit more flexible than [].  I think in this
> particular case [] won't work due to how the structures are declared.
> In the documentation [] is certainly clearer.
>
> Paolo
>

Thanks,
Jing
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
