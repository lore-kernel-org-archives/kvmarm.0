Return-Path: <SRS0=HxNd=6C=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9A6DC2BA19
	for <kvmarm@archiver.kernel.org>; Sat, 18 Apr 2020 22:56:49 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2BF282072C
	for <kvmarm@archiver.kernel.org>; Sat, 18 Apr 2020 22:56:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Z4vkZdXU"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2BF282072C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5FDE54B265;
	Sat, 18 Apr 2020 18:56:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id pzmefF6rQy+e; Sat, 18 Apr 2020 18:56:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 178F44B160;
	Sat, 18 Apr 2020 18:56:47 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 30D754B160
 for <kvmarm@lists.cs.columbia.edu>; Sat, 18 Apr 2020 18:56:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FPCJieN3NBEh for <kvmarm@lists.cs.columbia.edu>;
 Sat, 18 Apr 2020 18:56:45 -0400 (EDT)
Received: from mail-io1-f68.google.com (mail-io1-f68.google.com
 [209.85.166.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 020644B130
 for <kvmarm@lists.cs.columbia.edu>; Sat, 18 Apr 2020 18:56:44 -0400 (EDT)
Received: by mail-io1-f68.google.com with SMTP id e127so6657719iof.6
 for <kvmarm@lists.cs.columbia.edu>; Sat, 18 Apr 2020 15:56:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=IvgW/0qH07zwxjdODqQ/wkgwGDwP10Y75Wq+uiCGqQc=;
 b=Z4vkZdXUCzEflRxHo4/BoQHXMctRosO8uawz4V6ao+y5Gn/pY6vhTXVdiNpDa1FjsM
 V/gC6oUtIMnqPY+UZQgXZQYM99SeqpSkdKNmKqfLod+6NRmJNr5B5Iu500T3KGJVgZ6k
 0HWcXwFmVIwDA26k8oqUR1wpIAQtWifWUtPoyILoHtVdzSatj3rJew5pWRkY+7bQ2HaA
 zuRuhCepQFZmLR+vF9XWgqVcUG2+9ldBTy3sO0rHupb8lYgGjr58OBxH2Mb3L7Qcdft9
 v2mST8ZQPPuWj+pQMNEL9+/YQdW4uKcd+Lf0/qcDXoy1GAXJZfesyzmLPBQi18VeSvjw
 EcNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=IvgW/0qH07zwxjdODqQ/wkgwGDwP10Y75Wq+uiCGqQc=;
 b=heGsgVPw1keTAM6jk4qjkzyHBTZhLJwXAgJW9lo/jNIqbCSo50DkU7bv/DtR4dRvF4
 ndCentv971jVr8pr5unLcNznYDJLZXen7tfuZcsAR0AJ82MU7qH7HKjjOtGdii3UTSk6
 emjtp0kryohLWJMQt8OuR3YRfxZGKPeIvcJn0/IhhYKcH9onS6vynTH7x5bq30vQ14N0
 iB8GBBm17gEfY1P6uhOte2HP+CT800FnMt0Ic8V8y3jUKOuMZvVrxtcAFQJQDB79Sz7e
 XKX5N8No2kXW4FlbZLdse8BiGyxIXCQb8K4nMaysQtVGzUoEj2pV9qq15G/qZcOrTVnJ
 68YQ==
X-Gm-Message-State: AGi0Publ8VUgjtEqIek6qUHpzWNfBTqs22Xo7d1cy8LQlFXJDmsaHrsd
 9ujmf9T/aApEFWV5bFnoI/HS0n9BLCPejA5cm3v7Zg==
X-Google-Smtp-Source: APiQypIXmPHLcvbEMLaoylw67WcS+FV+BryMjmCs5C3z5k/15r+BfwsPOQMTmor8ATWksCqVvZ6vbDkZMefCgoGv4m4=
X-Received: by 2002:a02:ccf4:: with SMTP id l20mr9766213jaq.28.1587250604367; 
 Sat, 18 Apr 2020 15:56:44 -0700 (PDT)
MIME-Version: 1.0
References: <20200323113227.3169-1-beata.michalska@linaro.org>
 <20200323113227.3169-2-beata.michalska@linaro.org>
 <CAFEAcA_uWS+cVRk=BKra8AhsD+B1syVzhXeCMttSKwQDdo=j3w@mail.gmail.com>
 <20200417131032.lcyunbjwofsn2nzz@kamzik.brq.redhat.com>
In-Reply-To: <20200417131032.lcyunbjwofsn2nzz@kamzik.brq.redhat.com>
From: Beata Michalska <beata.michalska@linaro.org>
Date: Sat, 18 Apr 2020 23:56:32 +0100
Message-ID: <CADSWDzvz6RzhQnPL9k91SGAXP0iGfXVd+h3RML8yqXrcCQ1xsQ@mail.gmail.com>
Subject: Re: [PATCH v4 1/2] target/arm: kvm: Handle DABT with no valid ISS
To: Andrew Jones <drjones@redhat.com>
Cc: Juan Quintela <quintela@redhat.com>,
 QEMU Developers <qemu-devel@nongnu.org>, qemu-arm <qemu-arm@nongnu.org>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
 "Dr. David Alan Gilbert" <dgilbert@redhat.com>
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

On Fri, 17 Apr 2020 at 14:10, Andrew Jones <drjones@redhat.com> wrote:
>
> On Fri, Apr 17, 2020 at 11:39:25AM +0100, Peter Maydell wrote:
> > On Mon, 23 Mar 2020 at 11:32, Beata Michalska
> > <beata.michalska@linaro.org> wrote:
> > >
> > > On ARMv7 & ARMv8 some load/store instructions might trigger a data abort
> > > exception with no valid ISS info to be decoded. The lack of decode info
> > > makes it at least tricky to emulate those instruction which is one of the
> > > (many) reasons why KVM will not even try to do so.
> > >
> > > Add support for handling those by requesting KVM to inject external
> > > dabt into the quest.
> > >
> > > Signed-off-by: Beata Michalska <beata.michalska@linaro.org>
> > > ---
> > >  target/arm/cpu.h     |  2 ++
> > >  target/arm/kvm.c     | 54 ++++++++++++++++++++++++++++++++++++++++++++++++++++
> > >  target/arm/kvm_arm.h | 11 +++++++++++
> > >  3 files changed, 67 insertions(+)
> > >
> > > diff --git a/target/arm/cpu.h b/target/arm/cpu.h
> > > index 4ffd991..4f834c1 100644
> > > --- a/target/arm/cpu.h
> > > +++ b/target/arm/cpu.h
> > > @@ -560,6 +560,8 @@ typedef struct CPUARMState {
> > >          uint64_t esr;
> > >      } serror;
> > >
> > > +    uint8_t ext_dabt_pending; /* Request for injecting ext DABT */
> >
> > I was trying to work out whether we need to migrate this state,
> > and I'm not sure. Andrew, do you know? I think this comes down
> > to "at what points in QEMU's kvm run loop can migration kick in",
> > and specifically if we get a KVM_EXIT_ARM_NISV do we definitely
> > go round the loop and KVM_RUN again without ever checking
> > to see if we should do a migration ?
> >
>
> I'd prefer a migration expert confirm this, so I've CC'ed David and Juan,
> but afaict there's no way to break out of the KVM_RUN loop after a
> successful (ret=0) call to kvm_arch_handle_exit() until after the next
> KVM_RUN ioctl. This is because even if migration kicks the vcpus between
> kvm_arch_handle_exit() and the next run, the signal won't do anything
> other than prepare the vcpu for an immediate exit.
>
I am definitely not an expert on that one, but if I got things right,
by the time the 'exit_request' gets verified , the external abort
should already be set up , the pending status cleared (through
KVM_SET_VCPU_EVENTS)
and the reg content verified (kvm_arch_pre_run), as all of it is being
 triggered
prior to checking the exit request. So this should not need a
dedicated migration state.

I will hold on with sending the new version though to get the confirmation
whether that is the case.

Thanks,

BR
Beata
>
> Thanks,
> drew
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
