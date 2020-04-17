Return-Path: <SRS0=Fj5y=6B=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA5B6C2D0EF
	for <kvmarm@archiver.kernel.org>; Fri, 17 Apr 2020 13:10:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 72B8420776
	for <kvmarm@archiver.kernel.org>; Fri, 17 Apr 2020 13:10:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Jm2ExflX"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 72B8420776
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 07D634B264;
	Fri, 17 Apr 2020 09:10:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8QOhbH7bOtSp; Fri, 17 Apr 2020 09:10:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EB1C04B248;
	Fri, 17 Apr 2020 09:10:50 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 632CE4B248
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Apr 2020 09:10:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lLCjA43FHRoY for <kvmarm@lists.cs.columbia.edu>;
 Fri, 17 Apr 2020 09:10:46 -0400 (EDT)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A6DAA4B239
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Apr 2020 09:10:46 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1587129046;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=UIWGFNTVhWPNBow8DtRZ8iIscOSllsxNFMydloAjCDM=;
 b=Jm2ExflXtgM+Iy3kWUibwUqHUopOjimeid0rtWTWeRUvqJrd8BGsDE/KWwtPoymotWIxdE
 LXh1/1GSWmNishYqO8SX3ioIOHbDj8WObOrAT/RQZScR73CmT3Fprmom1YJVRGTG2JDRNO
 62zDkmtf+h5ugZ4nCbg9HSKcMi7zlfQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-40-RZYgCtYdM9uF51XGOYBrDg-1; Fri, 17 Apr 2020 09:10:41 -0400
X-MC-Unique: RZYgCtYdM9uF51XGOYBrDg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
 [10.5.11.15])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 266518018A6;
 Fri, 17 Apr 2020 13:10:40 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.194.141])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B1D49120C00;
 Fri, 17 Apr 2020 13:10:35 +0000 (UTC)
Date: Fri, 17 Apr 2020 15:10:32 +0200
From: Andrew Jones <drjones@redhat.com>
To: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH v4 1/2] target/arm: kvm: Handle DABT with no valid ISS
Message-ID: <20200417131032.lcyunbjwofsn2nzz@kamzik.brq.redhat.com>
References: <20200323113227.3169-1-beata.michalska@linaro.org>
 <20200323113227.3169-2-beata.michalska@linaro.org>
 <CAFEAcA_uWS+cVRk=BKra8AhsD+B1syVzhXeCMttSKwQDdo=j3w@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAFEAcA_uWS+cVRk=BKra8AhsD+B1syVzhXeCMttSKwQDdo=j3w@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: quintela@redhat.com, QEMU Developers <qemu-devel@nongnu.org>,
 qemu-arm <qemu-arm@nongnu.org>, Paolo Bonzini <pbonzini@redhat.com>,
 kvmarm@lists.cs.columbia.edu, dgilbert@redhat.com
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

On Fri, Apr 17, 2020 at 11:39:25AM +0100, Peter Maydell wrote:
> On Mon, 23 Mar 2020 at 11:32, Beata Michalska
> <beata.michalska@linaro.org> wrote:
> >
> > On ARMv7 & ARMv8 some load/store instructions might trigger a data abort
> > exception with no valid ISS info to be decoded. The lack of decode info
> > makes it at least tricky to emulate those instruction which is one of the
> > (many) reasons why KVM will not even try to do so.
> >
> > Add support for handling those by requesting KVM to inject external
> > dabt into the quest.
> >
> > Signed-off-by: Beata Michalska <beata.michalska@linaro.org>
> > ---
> >  target/arm/cpu.h     |  2 ++
> >  target/arm/kvm.c     | 54 ++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  target/arm/kvm_arm.h | 11 +++++++++++
> >  3 files changed, 67 insertions(+)
> >
> > diff --git a/target/arm/cpu.h b/target/arm/cpu.h
> > index 4ffd991..4f834c1 100644
> > --- a/target/arm/cpu.h
> > +++ b/target/arm/cpu.h
> > @@ -560,6 +560,8 @@ typedef struct CPUARMState {
> >          uint64_t esr;
> >      } serror;
> >
> > +    uint8_t ext_dabt_pending; /* Request for injecting ext DABT */
> 
> I was trying to work out whether we need to migrate this state,
> and I'm not sure. Andrew, do you know? I think this comes down
> to "at what points in QEMU's kvm run loop can migration kick in",
> and specifically if we get a KVM_EXIT_ARM_NISV do we definitely
> go round the loop and KVM_RUN again without ever checking
> to see if we should do a migration ?
>

I'd prefer a migration expert confirm this, so I've CC'ed David and Juan,
but afaict there's no way to break out of the KVM_RUN loop after a
successful (ret=0) call to kvm_arch_handle_exit() until after the next
KVM_RUN ioctl. This is because even if migration kicks the vcpus between
kvm_arch_handle_exit() and the next run, the signal won't do anything
other than prepare the vcpu for an immediate exit.

Thanks,
drew 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
