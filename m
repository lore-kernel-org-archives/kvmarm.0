Return-Path: <SRS0=xlfr=JT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA127C433ED
	for <kvmarm@archiver.kernel.org>; Thu, 22 Apr 2021 15:58:09 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0B4D4613DE
	for <kvmarm@archiver.kernel.org>; Thu, 22 Apr 2021 15:58:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0B4D4613DE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4C5884B4EE;
	Thu, 22 Apr 2021 11:58:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6Z6LOMocs91q; Thu, 22 Apr 2021 11:58:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 08EFB4B4CD;
	Thu, 22 Apr 2021 11:58:07 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 54C654B4CD
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Apr 2021 11:58:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TkOmA3At2-EF for <kvmarm@lists.cs.columbia.edu>;
 Thu, 22 Apr 2021 11:58:04 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 19CD24B43E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Apr 2021 11:58:04 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1619107083;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=A+D2duNY6Jz6vEcKAT3xK6NwCd9dhD5XS9gTlIjixsw=;
 b=GqEnvlzZru0urMq12VkZZ3QABEtPMV+hKuJjZ2cnrHjjguTUJL0C/vNIF6qJN5jLB+KmSo
 2t1fOiNB0OtkaDkuxPtlRV1oEIncNGiGK5eHL3vGpWTE5y6XV+yxn95zkRbS37kJI1epYJ
 XpOeL/qNwuydzoN0eyIhKFjBxXdTD7E=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-445-CrbuQFl7OQeSsQaGCy6cow-1; Thu, 22 Apr 2021 11:58:01 -0400
X-MC-Unique: CrbuQFl7OQeSsQaGCy6cow-1
Received: by mail-wr1-f72.google.com with SMTP id
 t18-20020adfdc120000b02900ffe4432d8bso14037070wri.6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Apr 2021 08:58:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=A+D2duNY6Jz6vEcKAT3xK6NwCd9dhD5XS9gTlIjixsw=;
 b=Ri/GTvnxK4/qrn2VGSrHXWBv99daBOyLJYfuhh5ttE7VcGZ+0cSVHXjzKrgRIJW6tb
 4y/PSK9oi40NgK/qVc/0a+sckKd66RErNluTP6raSHEeTrw7PIWa07GSpN9qrz027H5n
 G+t2nmiiKZ25dxGjQ64GnaWay86Brv8YJdntotoU/ChWEamqwp6e15ugrIwqdgMJ4ZZu
 hbfwW8CSS82l2MBk/OA/hnCSLqxrsBHn9jNVgQn07aiXXTZMUJyMAIi/GY/Pogvp97zO
 igA/KOhKgB8tWA6oH0yKguaG2seaZuc5s3JtmEpvPZ2Dy+JhbcosIJNnZN/GxYnjIbNV
 omCQ==
X-Gm-Message-State: AOAM531NnE0F0WKp6LmZ9mrOfJLCCaYyWQNmDzp06d20nGd73ghKppNe
 VEPETmpvyFh/INfYCl/ScBsYz5cQaJvZzg65jVDXCEQYbelOBOsN5sKnnBcg8/y/L59qfjEqn1b
 tWJraz4HM8DTZ2IOfDY48su4p
X-Received: by 2002:a1c:6709:: with SMTP id b9mr760601wmc.56.1619107080344;
 Thu, 22 Apr 2021 08:58:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwJcWLTOHJxFOQB3JHKtX9wIpaWaYcPOqbAAKCb6qD6isl9e5hO+ELChr11nzNKNkT3fLLD3Q==
X-Received: by 2002:a1c:6709:: with SMTP id b9mr760580wmc.56.1619107080126;
 Thu, 22 Apr 2021 08:58:00 -0700 (PDT)
Received: from gator (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
 by smtp.gmail.com with ESMTPSA id o4sm5132985wrn.81.2021.04.22.08.57.59
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 22 Apr 2021 08:57:59 -0700 (PDT)
Date: Thu, 22 Apr 2021 17:57:57 +0200
From: Andrew Jones <drjones@redhat.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [kvm-unit-tests RFC PATCH 0/1] configure: arm: Replace --vmm
 with --target
Message-ID: <20210422155757.t4pvv6blkvoyi2oy@gator>
References: <20210420161338.70914-1-alexandru.elisei@arm.com>
 <20210420165101.irbx2upgqbazkvlt@gator.home>
 <ed3ba802-fee7-4c58-9d73-d33dfbd44d7f@arm.com>
MIME-Version: 1.0
In-Reply-To: <ed3ba802-fee7-4c58-9d73-d33dfbd44d7f@arm.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
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

On Thu, Apr 22, 2021 at 04:17:27PM +0100, Alexandru Elisei wrote:
> Hi Drew,
> 
> On 4/20/21 5:51 PM, Andrew Jones wrote:
> > Hi Alex,
> >
> > On Tue, Apr 20, 2021 at 05:13:37PM +0100, Alexandru Elisei wrote:
> >> This is an RFC because it's not exactly clear to me that this is the best
> >> approach. I'm also open to using a different name for the new option, maybe
> >> something like --platform if it makes more sense.
> > I like 'target'.
> >
> >> I see two use cases for the patch:
> >>
> >> 1. Using different files when compiling kvm-unit-tests to run as an EFI app
> >> as opposed to a KVM guest (described in the commit message).
> >>
> >> 2. This is speculation on my part, but I can see extending
> >> arm/unittests.cfg with a "target" test option which can be used to decide
> >> which tests need to be run based on the configure --target value. For
> >> example, migration tests don't make much sense on kvmtool, which doesn't
> >> have migration support. Similarly, the micro-bench test doesn't make much
> >> sense (to me, at least) as an EFI app. Of course, this is only useful if
> >> there are automated scripts to run the tests under kvmtool or EFI, which
> >> doesn't look likely at the moment, so I left it out of the commit message.
> > Sounds like a good idea. unittests.cfg could get a new option 'targets'
> > where a list of targets is given. If targets is not present, then the
> > test assumes it's for all targets. Might be nice to also accept !<target>
> > syntax. E.g.
> >
> > # builds/runs for all targets
> > [mytest]
> > file = mytest.flat
> >
> > # builds/runs for given targets
> > [mytest2]
> > file = mytest2.flat
> > targets = qemu,kvmtool
> >
> > # builds/runs for all targets except disabled targets
> > [mytest3]
> > file = mytest3.flat
> > targets = !kvmtool
> 
> That's sounds like a good idea, but to be honest, I would wait until someone
> actually needs it before implementing it. That way we don't risk not taking a use
> case into account and then having to rework it.

Don't we have a usecase? Above you said that kvmtool should at least skip
the migration tests.

> 
> >
> > And it wouldn't bother me to have special logic for kvmtool's lack of
> > migration put directly in scripts/runtime.bash
> 
> Good to keep in mind when support is added.
> 
> >
> > diff --git a/scripts/runtime.bash b/scripts/runtime.bash
> > index 132389c7dd59..0d5cb51df4f4 100644
> > --- a/scripts/runtime.bash
> > +++ b/scripts/runtime.bash
> > @@ -132,7 +132,7 @@ function run()
> >      }
> >  
> >      cmdline=$(get_cmdline $kernel)
> > -    if grep -qw "migration" <<<$groups ; then
> > +    if grep -qw "migration" <<<$groups && [ "$TARGET" != "kvmtool" ]; then
> >          cmdline="MIGRATION=yes $cmdline"
> >      fi
> >      if [ "$verbose" = "yes" ]; then
> >
> >> Using --vmm will trigger a warning. I was thinking about removing it entirely in
> >> a about a year's time, but that's not set in stone. Note that qemu users
> >> (probably the vast majority of people) will not be affected by this change as
> >> long as they weren't setting --vmm explicitely to its default value of "qemu".
> >>
> > While we'd risk automated configure+build tools, like git{hub,lab} CI,
> > failing, I think the risk is pretty low right now that anybody is using
> > the option. Also, we might as well make them change sooner than later by
> > failing configure. IOW, I'd just do s/vmm/target/g to rename it now. If
> > we are concerned about the disruption, then I'd just make vmm an alias
> > for target and not bother deprecating it ever.
> 
> I also think it will not be too bad if we make the change now, but I'm not sure
> what you mean by making vmm an alias of target. The patch ignores --vmm is it's
> not specified, and if it is specified on the configure command line, then it must
> match the value of --target, otherwise configure fails.
>

The current patch does both things; it says don't use --vmm and it says
the new --vmm is --target. I'm saying do one or the other. Either
completely rename vmm to target, which will then error out when vmm is
specified as an unknown option or allow the user to use either --vmm or
--target with no error and where both mean to do the same thing, which is
to set the TARGET variable.

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
