Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02EADECAAA1
	for <kvmarm@archiver.kernel.org>; Fri, 28 Oct 2022 11:44:51 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8279640658;
	Fri, 28 Oct 2022 07:44:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0J3Po9JkpgSy; Fri, 28 Oct 2022 07:44:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4742840BB3;
	Fri, 28 Oct 2022 07:44:50 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BE09B40658
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Oct 2022 07:44:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XWLZgrQCXUEA for <kvmarm@lists.cs.columbia.edu>;
 Fri, 28 Oct 2022 07:44:48 -0400 (EDT)
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4B799405F7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Oct 2022 07:44:48 -0400 (EDT)
Date: Fri, 28 Oct 2022 13:44:46 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1666957487;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=lKr3ZxRBxgAbbIERdXuMUId7MnGr7ccUy84WJo1ZacI=;
 b=jmaTdc1O9Ni7gnN7EPpz4XsShcVsE2LKa/0jt4JX+pYR6wRQmGI1SdAgt6cb8svXn1T08w
 3s4Nhv1mw3Ts86k75CC1iXXAQ/OmYRCQ4zROS3uyvrJ06qMSUqPEEe77PaL4d0XQjl3EKQ
 CgAfBzY6Ef+Rilow6Gy5/z08Rr1Jwg8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Cornelia Huck <cohuck@redhat.com>
Subject: Re: [kvm-unit-tests PATCH] MAINTAINERS: new kvmarm mailing list
Message-ID: <20221028114446.zn2xz64lrzptskgd@kamzik>
References: <20221025160730.40846-1-cohuck@redhat.com>
 <87a65gkwld.fsf@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87a65gkwld.fsf@redhat.com>
X-Migadu-Flow: FLOW_OUT
Cc: kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
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

On Fri, Oct 28, 2022 at 01:37:34PM +0200, Cornelia Huck wrote:
> On Tue, Oct 25 2022, Cornelia Huck <cohuck@redhat.com> wrote:
> 
> > KVM/arm64 development is moving to a new mailing list (see
> > https://lore.kernel.org/all/20221001091245.3900668-1-maz@kernel.org/);
> > kvm-unit-tests should advertise the new list as well.
> >
> > Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> > ---
> >  MAINTAINERS | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 90ead214a75d..649de509a511 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -67,7 +67,8 @@ ARM
> >  M: Andrew Jones <andrew.jones@linux.dev>
> >  S: Supported
> >  L: kvm@vger.kernel.org
> > -L: kvmarm@lists.cs.columbia.edu
> > +L: kvmarm@lists.linux.dev
> > +L: kvmarm@lists.cs.columbia.edu (deprecated)
> 
> As the days of the Columbia list really seem to be numbered (see
> https://lore.kernel.org/all/364100e884023234e4ab9e525774d427@kernel.org/),
> should we maybe drop it completely from MAINTAINERS, depending on when
> this gets merged?

I'll merge your patch now with the old (deprecated) list still there. When
mail starts bouncing it may help people better understand why. When the
kernel drops it from its MAINTAINERS file, then we can drop it here too.

Thanks,
drew
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
