Return-Path: <SRS0=bTo6=ME=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD5C8C07E99
	for <kvmarm@archiver.kernel.org>; Mon, 12 Jul 2021 17:07:55 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4C036611CD
	for <kvmarm@archiver.kernel.org>; Mon, 12 Jul 2021 17:07:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4C036611CD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CFEF0406E0;
	Mon, 12 Jul 2021 13:07:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NsV+0nbfWfQe; Mon, 12 Jul 2021 13:07:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AD7024075E;
	Mon, 12 Jul 2021 13:07:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BC51C40623
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Jul 2021 13:07:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kHv8CuZXuUr3 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 12 Jul 2021 13:07:51 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CC952404F8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Jul 2021 13:07:51 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1626109671;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=TsrLFalCe5nNdE+AKqjeOWu3LTNOiX4cuylRsIPejw8=;
 b=Y3EoU4H9jMGaBgJYagdqJv1LlOibalFLcxXdM0L1Y60rXieYCdTkIjsTqBD6x1ttpR7usg
 zLcAe+CEYsgm/KktgXTUuY/CDJhAP6Hdu45UpszUGXAmd+zSVz9gWrRj1wLWdYPCpOFcQ9
 KEGQgU1saUvAaNmzJGN01WRGl4x/rKk=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-320-367Zpcn5MaC-YVUsodHL4A-1; Mon, 12 Jul 2021 13:07:48 -0400
X-MC-Unique: 367Zpcn5MaC-YVUsodHL4A-1
Received: by mail-il1-f198.google.com with SMTP id
 a18-20020a92c7120000b029020757e7bf9fso6077621ilp.7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Jul 2021 10:07:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=TsrLFalCe5nNdE+AKqjeOWu3LTNOiX4cuylRsIPejw8=;
 b=O/T/d4Nmc2CAPu7DxAuqTRfzcJ0DB4zYoe3uD1tBmODkEC0FnogLMY8PtRMTXRI23R
 xpKvf+32M3aV6c73e1NhXnXrvMHLpdT8HNNThghwwCKE99ubZUoOjQrOaRWv8jq1SuUf
 rUkWhHRpXBdjiCPGHBx/ijQxgKa9TlttZqtSMZvT9zQg88XHb40dSCMljkxjO/ggUBbr
 S9gPnVxlakYcS607tPErquo84qMVz4skZmmJk8dYh4CuBIYVb9LvovDTqaRk2E3ktiE6
 Du8fyljquYZNjjJvUjTGffuoj5MH7QvJYhCtjspvMpxiH2yhIAai1jJkqzgF4ik/LsKE
 IrWQ==
X-Gm-Message-State: AOAM533H38vqlcvq/Jb0d8zOLUbVLYRzgdJlnH7j3o5yjPzkOaxjMbBG
 FRNTAuQZEHyiG7zFFQ046vQQdfvDyK3yAXENjAB+jTYJtRUNOhOlHf455dp0JOau5nYDluIkbHX
 rYpGZTcnAz3NzBDE/iAEuV+YQ
X-Received: by 2002:a92:c0c3:: with SMTP id t3mr6195912ilf.80.1626109667984;
 Mon, 12 Jul 2021 10:07:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwW+FcYNWz+4Ju1xiZ3nfECC1K78r/zSQR3QsIBlAh2kMR8epVZ1JcshyO08RQjWkbEc/wn9A==
X-Received: by 2002:a92:c0c3:: with SMTP id t3mr6195897ilf.80.1626109667825;
 Mon, 12 Jul 2021 10:07:47 -0700 (PDT)
Received: from gator ([140.82.166.162])
 by smtp.gmail.com with ESMTPSA id j24sm3180497ioo.16.2021.07.12.10.07.46
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 12 Jul 2021 10:07:47 -0700 (PDT)
Date: Mon, 12 Jul 2021 19:07:45 +0200
From: Andrew Jones <drjones@redhat.com>
To: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [kvm-unit-tests RFC PATCH 1/5] lib: arm: Print test exit status
 on exit if chr-testdev is not available
Message-ID: <20210712170745.wz2jewomlqchmhhb@gator>
References: <20210702163122.96110-1-alexandru.elisei@arm.com>
 <20210702163122.96110-2-alexandru.elisei@arm.com>
 <20210712175155.7c6f8dc3@slackpad.fritz.box>
MIME-Version: 1.0
In-Reply-To: <20210712175155.7c6f8dc3@slackpad.fritz.box>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: lvivier@redhat.com, linux-s390@vger.kernel.org, thuth@redhat.com,
 frankja@linux.ibm.com, kvm@vger.kernel.org, david@redhat.com, maz@kernel.org,
 cohuck@redhat.com, kvm-ppc@vger.kernel.org, vivek.gautam@arm.com,
 pbonzini@redhat.com, imbrenda@linux.ibm.com, kvmarm@lists.cs.columbia.edu
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

On Mon, Jul 12, 2021 at 05:51:55PM +0100, Andre Przywara wrote:
> On Fri,  2 Jul 2021 17:31:18 +0100
> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
> 
> Hi,
> 
> > The arm64 tests can be run under kvmtool, which doesn't emulate a
> > chr-testdev device. In preparation for adding run script support for
> > kvmtool, print the test exit status so the scripts can pick it up and
> > correctly mark the test as pass or fail.
> > 
> > Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> > ---
> >  lib/chr-testdev.h |  1 +
> >  lib/arm/io.c      | 10 +++++++++-
> >  lib/chr-testdev.c |  5 +++++
> >  3 files changed, 15 insertions(+), 1 deletion(-)
> > 
> > diff --git a/lib/chr-testdev.h b/lib/chr-testdev.h
> > index ffd9a851aa9b..09b4b424670e 100644
> > --- a/lib/chr-testdev.h
> > +++ b/lib/chr-testdev.h
> > @@ -11,4 +11,5 @@
> >   */
> >  extern void chr_testdev_init(void);
> >  extern void chr_testdev_exit(int code);
> > +extern bool chr_testdev_available(void);
> >  #endif
> > diff --git a/lib/arm/io.c b/lib/arm/io.c
> > index 343e10822263..9e62b571a91b 100644
> > --- a/lib/arm/io.c
> > +++ b/lib/arm/io.c
> > @@ -125,7 +125,15 @@ extern void halt(int code);
> >  
> >  void exit(int code)
> >  {
> > -	chr_testdev_exit(code);
> > +	if (chr_testdev_available()) {
> > +		chr_testdev_exit(code);
> > +	} else {
> > +		/*
> > +		 * Print the test return code in the format used by chr-testdev
> > +		 * so the runner script can parse it.
> > +		 */
> > +		printf("\nEXIT: STATUS=%d\n", ((code) << 1) | 1);
> 
> It's more me being clueless here rather than a problem, but where does
> this "EXIT: STATUS" line come from? In lib/chr-testdev.c I see "%dq",
> so it this coming from QEMU (but I couldn't find it in there)?
> 
> But anyways the patch looks good and matches what PPC and s390 do.

I invented the 'EXIT: STATUS' format for PPC, which didn't/doesn't have an
exit code testdev. Now that it has also been adopted by s390 I guess we've
got a kvm-unit-tests standard to follow for arm :-)

Thanks,
drew


> 
> Cheers,
> Andre
> 
> 
> > +	}
> >  	psci_system_off();
> >  	halt(code);
> >  	__builtin_unreachable();
> > diff --git a/lib/chr-testdev.c b/lib/chr-testdev.c
> > index b3c641a833fe..301e73a6c064 100644
> > --- a/lib/chr-testdev.c
> > +++ b/lib/chr-testdev.c
> > @@ -68,3 +68,8 @@ void chr_testdev_init(void)
> >  	in_vq = vqs[0];
> >  	out_vq = vqs[1];
> >  }
> > +
> > +bool chr_testdev_available(void)
> > +{
> > +	return vcon != NULL;
> > +}
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
