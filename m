Return-Path: <SRS0=srdq=LL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_RED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FF9FC49EA4
	for <kvmarm@archiver.kernel.org>; Thu, 17 Jun 2021 15:51:46 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6C38661055
	for <kvmarm@archiver.kernel.org>; Thu, 17 Jun 2021 15:51:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6C38661055
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E434F49E57;
	Thu, 17 Jun 2021 11:51:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3jJ91UyjrI5X; Thu, 17 Jun 2021 11:51:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CA1394B08B;
	Thu, 17 Jun 2021 11:51:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E32E449E57
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Jun 2021 11:51:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Lyst58yu-hci for <kvmarm@lists.cs.columbia.edu>;
 Thu, 17 Jun 2021 11:51:41 -0400 (EDT)
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com
 [209.85.167.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B07E840878
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Jun 2021 11:51:41 -0400 (EDT)
Received: by mail-lf1-f52.google.com with SMTP id bp38so11413533lfb.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Jun 2021 08:51:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=kvwd9EpkhUinpwzSVnooHeUgUpNvfxheNpkid5yzIx8=;
 b=TxvTgcPI/Ra/tWUZA++LM92n/9N9cTc45nFEoGhah5rZzdxemGKBDvrRYYHnH4ElJt
 yeZYKEj3Lqkp+BP0P4ZFMlqAtvCYjKX6t4G5pL+NGvO/8eHXkyErvHJikNhQ82xaQoTq
 E4tiTMkcq1rkKtM7nLr4Upaq/GGoVKkfONVtDcs0f22HJaAYQy3Ug/8crI/5MUkmS78c
 IwGqnKxMKmqptWtKPTUMbqXncfLP3Px4QgECquw11X7E+Y33meqrsX+9oDDbuFcIx+yl
 gLr7fO7ADbTI7Co5iaDp6TxfEujoOq3bCRAkkK4lGCAoIfkQAfzZGLE2WYNQ+ctC+FK+
 Bvfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=kvwd9EpkhUinpwzSVnooHeUgUpNvfxheNpkid5yzIx8=;
 b=MZwMJtleqd7iFdUBfXHWyBlr7EN+3NnXnBoTKkGZg/gUO97A7gOWc39k3r7dhev3fD
 DhdPujefUJq0AScQRqPTJjk6O75H7MDVKdNKg/Zs4ejmZ7Gp41tK8CoLkSuQzSorUwsS
 WtdGEa6t+hF9X3DCk7tOc6OUCYXssJCTX7/15ByMiIUPrGl/ylCDCJ+fjUiicSoGJ/va
 ReJoqyoopQroJjx18Kl0C28tO7w5OAb5r+1EYvZLymlOFazJEptEDuLZLcjTeJfgvjJ1
 wcOl6CpEtw6i3ySrnrnjA3sga4tbeOmTAjowbd/F9D/xJUL6ujFo4czrZkbI7wwWE2xm
 yPBw==
X-Gm-Message-State: AOAM531A8PjluCxKBBmewyp1k9Qa0a6fRQU6BMbypcGbd6xpFIFXy2xU
 DG1ZV21MzMs8/K1HpRtRrlgudlRjwTuYiCYaD5UJJA==
X-Google-Smtp-Source: ABdhPJyUT96ejYRqWFIHeQAvBlwr1aj1uzNjIHt1HENKbAjxRBM9g7oEN8mmzhRuuz1Vfgjz72FeQyENnMW8V6GZXWk=
X-Received: by 2002:a05:6512:3ea:: with SMTP id
 n10mr4497632lfq.178.1623945100161; 
 Thu, 17 Jun 2021 08:51:40 -0700 (PDT)
MIME-Version: 1.0
References: <20210617044146.2667540-1-jingzhangos@google.com>
 <20210617044146.2667540-4-jingzhangos@google.com> <YMrmqOxDWJ2/8sfD@kroah.com>
 <be506135-5bc3-31bd-1b20-063f01f41df1@redhat.com> <YMszVQEK8LHiAT+9@kroah.com>
In-Reply-To: <YMszVQEK8LHiAT+9@kroah.com>
From: Jing Zhang <jingzhangos@google.com>
Date: Thu, 17 Jun 2021 10:51:27 -0500
Message-ID: <CAAdAUth+osvNAzhGGY3u8fH4b2=PnLKQNFSfF6W92y--uYFOVg@mail.gmail.com>
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

On Thu, Jun 17, 2021 at 6:34 AM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Thu, Jun 17, 2021 at 01:19:50PM +0200, Paolo Bonzini wrote:
> > On 17/06/21 08:07, Greg KH wrote:
> > > > The statistics data itself could be read out by userspace telemetry
> > > > periodically without any extra parsing or setup effort.
> > > Do you have a pointer to userspace code that can do such a thing that
> > > others can use?  We do not like adding apis to the kernel without at
> > > least seeing the user of those apis, especially for complex things like
> > > this.
> > >
> > > Ideally you would include some library code in the kernel tree itself
> > > that everyone can use for this for their own programs.  You have
> > > provided a test which is great, but how do we know it works for "real"
> > > usages?
> >
> > I am pretty sure that Google is using this internally, but we are also going
> > to work on QEMU and Libvirt support for this.
>
> We need an "external user" for something as complex as this to be able
> to see if it actually works or not.  Otherwise we have to just guess :(
We have plans to add some library code in kernel selftests and also some
simple tools to let everyone get a feeling of the new API.

>
> thanks,
>
> greg k-h

Thanks,
Jing
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
