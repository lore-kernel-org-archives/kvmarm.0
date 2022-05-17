Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A77F0C433FE
	for <kvmarm@archiver.kernel.org>; Tue, 17 May 2022 14:43:28 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 26DD349F38;
	Tue, 17 May 2022 10:43:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id E9cbtVlJAqju; Tue, 17 May 2022 10:43:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BA9744B19D;
	Tue, 17 May 2022 10:43:26 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2297B4B093
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 May 2022 10:43:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YpLkfYTK5hTI for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 May 2022 10:43:23 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EAEEC49F38
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 May 2022 10:43:23 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1652798603;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=EUOebm1848nquUkzsfc+CUVVZX634BgGKga1hmkbgcs=;
 b=BySSWBOsdFl1p4LMZ0VQBun434IOWp3wLUG4/pD39rFw56sWZO03+xHn+Z+BufGezYCFbO
 hN2QL7GW7TPY1s6ap3PuOR120D/ztuYzC5Bh6PwYXwQqHnYpV+7lHBgFRuLDY/ZpmYN3DH
 5++HoKVAijEW+UIov03hT/ygfDvW0do=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-491-yKOg1fFpNai6k8jaeuxHgw-1; Tue, 17 May 2022 10:43:22 -0400
X-MC-Unique: yKOg1fFpNai6k8jaeuxHgw-1
Received: by mail-ej1-f70.google.com with SMTP id
 qw30-20020a1709066a1e00b006f45e7f44b0so7495044ejc.5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 May 2022 07:43:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=EUOebm1848nquUkzsfc+CUVVZX634BgGKga1hmkbgcs=;
 b=Ym+qnpJvqqGLRSuwlowvn3YiHQQ5AoXx2R/yb7tvxk2Lls0S9eUr4McbTHhrmp+zyg
 4djPfwBrjF8+YV9unh3/Z+jT3/TJm9pzkXPH8pp5Ls0SZCoBMayQa/bcivohBHN/EoB9
 JzCv0GRrNseYoUEG+JulcJUEm25MQ/k9jIJxehTgc0tgpicP0bLKiWbHp7NGbBpTgBJz
 Tc9WQBP/5mqPiVWUPQCg7rF15vaY9ib6Vkvc8eBS/0JlHXeMqNQ0db1/713sH+4WRkk2
 CQVgOj8Yi6qDyabtQdsQbU3Dm5sJaNXF6xhxWZ1n49Y6SXQczikfr+4vcaKEH5bd2FUj
 b7qQ==
X-Gm-Message-State: AOAM532cl/oTmEafB8jCmYD3mI51HTzuLhdWFP9E561iZIYQwwRKw0s4
 mi1jV+vejJZv+yrkxK3LdnlE+QMkrntpHBubOIT4MNEtu5li0hpPDeEj28FQEEK6mjshQUkMGGM
 3nGa/SoeRxSmRSwfp0IvajRQA
X-Received: by 2002:a17:907:7e84:b0:6fe:2a21:1467 with SMTP id
 qb4-20020a1709077e8400b006fe2a211467mr10719932ejc.673.1652798599959; 
 Tue, 17 May 2022 07:43:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzlnoJM/lXQ64XKdKCEL4Apv61bFcxyV3tHdLZlG0EczC2ChtveMzId+2dKEbYOZdkVKaMbrw==
X-Received: by 2002:a17:907:7e84:b0:6fe:2a21:1467 with SMTP id
 qb4-20020a1709077e8400b006fe2a211467mr10719913ejc.673.1652798599759; 
 Tue, 17 May 2022 07:43:19 -0700 (PDT)
Received: from gator (cst2-173-79.cust.vodafone.cz. [31.30.173.79])
 by smtp.gmail.com with ESMTPSA id
 t23-20020aa7d717000000b0042ac7b34b4asm1153428edq.81.2022.05.17.07.43.18
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 17 May 2022 07:43:19 -0700 (PDT)
Date: Tue, 17 May 2022 16:43:17 +0200
From: Andrew Jones <drjones@redhat.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [kvm-unit-tests PATCH] arm/run: Use TCG with qemu-system-arm on
 arm64 systems
Message-ID: <20220517144317.ggdesc23xgxq6pnh@gator>
References: <20220317165601.356466-1-alexandru.elisei@arm.com>
 <20220317174507.jt2rattmtetddvsq@gator>
 <YjN3xyfiLU2RUdGr@monolith.localdoman>
MIME-Version: 1.0
In-Reply-To: <YjN3xyfiLU2RUdGr@monolith.localdoman>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
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

On Thu, Mar 17, 2022 at 06:03:07PM +0000, Alexandru Elisei wrote:
> Hi,
> 
> On Thu, Mar 17, 2022 at 06:45:07PM +0100, Andrew Jones wrote:
> > On Thu, Mar 17, 2022 at 04:56:01PM +0000, Alexandru Elisei wrote:
> > > From: Andrew Jones <drjones@redhat.com>
> > > 
> > > If the user sets QEMU=qemu-system-arm on arm64 systems, the tests can only
> > > be run by using the TCG accelerator. In this case use TCG instead of KVM.
> > > 
> > > Signed-off-by: Andrew Jones <drjones@redhat.com>
> > > [ Alex E: Added commit message ]
> > > Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> > > ---
> > >  arm/run | 12 ++++++++++--
> > >  1 file changed, 10 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/arm/run b/arm/run
> > > index 28a0b4ad2729..128489125dcb 100755
> > > --- a/arm/run
> > > +++ b/arm/run
> > > @@ -10,16 +10,24 @@ if [ -z "$KUT_STANDALONE" ]; then
> > >  fi
> > >  processor="$PROCESSOR"
> > >  
> > > -ACCEL=$(get_qemu_accelerator) ||
> > > +accel=$(get_qemu_accelerator) ||
> > >  	exit $?
> > >  
> > > -if [ "$ACCEL" = "kvm" ]; then
> > > +if [ "$accel" = "kvm" ]; then
> > >  	QEMU_ARCH=$HOST
> > >  fi
> > >  
> > >  qemu=$(search_qemu_binary) ||
> > >  	exit $?
> > >  
> > > +if [ "$QEMU" ] && [ -z "$ACCEL" ] &&
> > > +   [ "$HOST" = "aarch64" ] && [ "$ARCH" = "arm" ] &&
> > > +   [ "$(basename $QEMU)" = "qemu-system-arm" ]; then
> > > +	accel=tcg
> > > +fi
> > > +
> > > +ACCEL=$accel
> > > +
> > >  if ! $qemu -machine '?' 2>&1 | grep 'ARM Virtual Machine' > /dev/null; then
> > >  	echo "$qemu doesn't support mach-virt ('-machine virt'). Exiting."
> > >  	exit 2
> > > -- 
> > > 2.35.1
> > >
> > 
> > Ha, OK, I guess you posting this is a strong vote in favor of this
> > behavior. I've queued it
> 
> Ah, yes, maybe I should've been more clear about it. I think this is more
> intuitive for the new users who might not be very familiar with
> run_tests.sh internals, and like you've said it won't break existing users
> who had to set ACCEL=tcg to get the desired behaviour anyway.
> 
> Thanks you for queueing it so fast! Should probably have also mentioned
> this as a comment in the commit, but I take full responsibility for
> breaking stuff.
> 
> Alex
> 
> > 
> > https://gitlab.com/rhdrjones/kvm-unit-tests/-/commits/arm/queue

I finally merged this.

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
