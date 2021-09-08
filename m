Return-Path: <SRS0=VYoy=N6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1593C433F5
	for <kvmarm@archiver.kernel.org>; Wed,  8 Sep 2021 15:49:53 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1B00560EE6
	for <kvmarm@archiver.kernel.org>; Wed,  8 Sep 2021 15:49:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 1B00560EE6
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9CBF84B0A0;
	Wed,  8 Sep 2021 11:49:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dR5djuja21hf; Wed,  8 Sep 2021 11:49:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6ECD34B10A;
	Wed,  8 Sep 2021 11:49:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E501E4B0A0
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Sep 2021 11:49:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7HIuPnPC1G-2 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 Sep 2021 11:49:49 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CE5FC4A49C
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Sep 2021 11:49:49 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1631116189;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=40UFBHRGhw7kqtdgKZE841ipL5pc0UoJdYE+Qv6yqos=;
 b=h820ZvBQ1iARuwOK50tEmfUsB/2ll/X2P7mAltw2xnYuO1rt8+NKLfkGi/hg1R8oB/a70O
 3U0NK6ndQpNh314Q8hmgDXX6i6kkWEhy1joOOwOYXuHS3+560gvdMYyjyDW9fBW6jL29bO
 S8iT0id4o/1WLPbXvKeQYmMjb4ARjoA=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-522-DVogTY3qNmeqhVkIjlfnQQ-1; Wed, 08 Sep 2021 11:49:48 -0400
X-MC-Unique: DVogTY3qNmeqhVkIjlfnQQ-1
Received: by mail-ed1-f69.google.com with SMTP id
 y11-20020aa7d50b000000b003ca1ef38cf3so1321008edq.7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 08 Sep 2021 08:49:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=40UFBHRGhw7kqtdgKZE841ipL5pc0UoJdYE+Qv6yqos=;
 b=PNYmXBmq57k1NKhtZar+ImeEBpZxBwPMW4EKWwsLmWdTFyz3Q6pIDAd0Gqwu0T5kH1
 ZU1bVgM4aG1kgAb6vDUaK5y50CESeYFxCogLvbQlJI+T7cAa/UCvyEmT12eViTw3OCDH
 sI+EAB1j4IN0tM/1M0mxhRV4SRGoDdMCpATXQXR2zHOP8tLrtU6tHaEZVvHFRjLRpcU7
 YIyCKI81Flwm77dd+tz1SbzPeFzsEzd5w0s8F8VV85gXtdsYlS4gbmf/Wb4fVP76IAAc
 MGHMM9bqj4gnAPGqCDMwVJK0kPZGfha3z344BU4sp9bPj3SlvQCTP+kPHGyB9Tll3WeO
 qIOA==
X-Gm-Message-State: AOAM532Xa3Iybj8aiHm81wqayfO6034GN9Gv/wLw242AwWvF6y3eexoP
 4zNnzBKgnFx4tmQWjCeqzshcIvpFEzER1XOn/KoqErPh1Y0XixRLiA+gBpI0LQNCD7fbs9aaWC2
 mL5hunw93/BiPZPkMaJP2vdfS
X-Received: by 2002:a17:906:b052:: with SMTP id
 bj18mr546489ejb.55.1631116187168; 
 Wed, 08 Sep 2021 08:49:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwXu4ZttkpvQjuCVBMIYjCKsZn9H35dFZn58PHwzeCurWJGXZpuFqkrf66aLT/CwHYOOp5Rdw==
X-Received: by 2002:a17:906:b052:: with SMTP id
 bj18mr546467ejb.55.1631116186921; 
 Wed, 08 Sep 2021 08:49:46 -0700 (PDT)
Received: from gator (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
 by smtp.gmail.com with ESMTPSA id t16sm1226386ejj.54.2021.09.08.08.49.44
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 08 Sep 2021 08:49:45 -0700 (PDT)
Date: Wed, 8 Sep 2021 17:49:43 +0200
From: Andrew Jones <drjones@redhat.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [kvm-unit-tests RFC PATCH 3/5] run_tests.sh: Add kvmtool support
Message-ID: <20210908154943.z7d6bhww3pnbaftd@gator>
References: <20210702163122.96110-1-alexandru.elisei@arm.com>
 <20210702163122.96110-4-alexandru.elisei@arm.com>
 <20210907101730.trnsig2j4jmhinyu@gator>
 <587a5f8c-cf04-59ec-7e35-4ca6adf87862@arm.com>
 <20210908150912.3d57akqkfux4fahj@gator>
 <56289c06-04ec-1772-6e15-98d02780876d@arm.com>
MIME-Version: 1.0
In-Reply-To: <56289c06-04ec-1772-6e15-98d02780876d@arm.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: lvivier@redhat.com, linux-s390@vger.kernel.org, thuth@redhat.com,
 frankja@linux.ibm.com, kvm@vger.kernel.org, david@redhat.com,
 andre.przywara@arm.com, cohuck@redhat.com, kvm-ppc@vger.kernel.org,
 vivek.gautam@arm.com, maz@kernel.org, pbonzini@redhat.com,
 imbrenda@linux.ibm.com, kvmarm@lists.cs.columbia.edu
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

On Wed, Sep 08, 2021 at 04:46:19PM +0100, Alexandru Elisei wrote:
> Hi Drew,
> 
> On 9/8/21 4:09 PM, Andrew Jones wrote:
> > On Wed, Sep 08, 2021 at 03:33:19PM +0100, Alexandru Elisei wrote:
> > ...
> >>>> +fixup_kvmtool_opts()
> >>>> +{
> >>>> +    local opts=$1
> >>>> +    local groups=$2
> >>>> +    local gic
> >>>> +    local gic_version
> >>>> +
> >>>> +    if find_word "pmu" $groups; then
> >>>> +        opts+=" --pmu"
> >>>> +    fi
> >>>> +
> >>>> +    if find_word "its" $groups; then
> >>>> +        gic_version=3
> >>>> +        gic="gicv3-its"
> >>>> +    elif [[ "$opts" =~ -machine\ *gic-version=(2|3) ]]; then
> >>>> +        gic_version="${BASH_REMATCH[1]}"
> >>>> +        gic="gicv$gic_version"
> >>>> +    fi
> >>>> +
> >>>> +    if [ -n "$gic" ]; then
> >>>> +        opts=${opts/-machine gic-version=$gic_version/}
> >>>> +        opts+=" --irqchip=$gic"
> >>>> +    fi
> >>>> +
> >>>> +    opts=${opts/-append/--params}
> >>>> +
> >>>> +    echo "$opts"
> >>>> +}
> >>> Hmm, I don't think we want to write a QEMU parameter translator for
> >>> all other VMMs, and all other VMM architectures, that we want to
> >>> support. I think we should add new "extra_params" variables to the
> >>> unittest configuration instead, e.g. "kvmtool_params", where the
> >>> extra parameters can be listed correctly and explicitly. While at
> >>> it, I would create an alias for "extra_params", which would be
> >>> "qemu_params" allowing unittests that support more than one VMM
> >>> to clearly show what's what.
> >> I agree, this is a much better idea than a parameter translator. Using a dedicated
> >> variable in unittests.cfg will make it easier for new tests to get support for all
> >> VMMs (for example, writing a list of parameters in unittests.cfg should be easier
> >> than digging through the scripts to figure exactly how and where to add a
> >> translation for a new parameter), and it allow us to express parameters for other
> >> VMMs which don't have a direct correspondent in qemu.
> >>
> >> By creating an alias, do you mean replacing extra_params with qemu_params in
> >> arm/unittests.cfg? Or something else?
> > Probably something like this
> >
> > diff --git a/scripts/common.bash b/scripts/common.bash
> > index 7b983f7d6dd6..e5119ff216e5 100644
> > --- a/scripts/common.bash
> > +++ b/scripts/common.bash
> > @@ -37,7 +37,12 @@ function for_each_unittest()
> >                 elif [[ $line =~ ^smp\ *=\ *(.*)$ ]]; then
> >                         smp=${BASH_REMATCH[1]}
> >                 elif [[ $line =~ ^extra_params\ *=\ *(.*)$ ]]; then
> > -                       opts=${BASH_REMATCH[1]}
> > +               elif [[ $line =~ ^extra_params\ *=\ *(.*)$ ]]; then
> > +                       qemu_opts=${BASH_REMATCH[1]}
> > +               elif [[ $line =~ ^qemu_params\ *=\ *(.*)$ ]]; then
> > +                       qemu_opts=${BASH_REMATCH[1]}
> > +               elif [[ $line =~ ^kvmtool_params\ *=\ *(.*)$ ]]; then
> > +                       kvmtool_opts=${BASH_REMATCH[1]}
> >                 elif [[ $line =~ ^groups\ *=\ *(.*)$ ]]; then
> >                         groups=${BASH_REMATCH[1]}
> >                 elif [[ $line =~ ^arch\ *=\ *(.*)$ ]]; then
> >
> > and all other changes needed to support the s/opts/qemu_opts/ change
> > should work. Also, an addition to the unittests.cfg documentation.
> 
> Got it, replace extra_opts with qemu_opts in the scripts.
> 
> Yes, the documentation for unittests.cfg (at the top of the file) should
> definitely be updated to document the new configuration option, kvmtool_params.
> 
> >
> > The above diff doesn't consider that a unittests.cfg file could have
> > both an 'extra_params' and a 'qemu_params' field, but I'm not sure
> > we care about that. Users should read the documentation and we
> > should review changes to the committed unittests.cfg files to avoid
> > that.
> 
> What do you feel about renaming extra_params -> qemu_params in unittests.cfg?

Yes, that's what I would expect the patch to do.

> I'm
> thinking it would make the usage clearer, improve consistency (we would have
> qemu_params and kvmtool_params, instead of extra_params and kvmtool_params), and
> remove any confusions regarding when they are used (I can see someone thinking
> that extra_params are used all the time, and are appended to kvmtool_params when
> --target=kvmtool). On the other hand, this could be problematic for people using
> out-of-tree scripts that parse the unittest.cfg file for whatever reason (are
> there people that do that?).

I'm not as worried about that as about people using out-of-tree
unittests.cfg files that will break when the 'extra_params' field
disappears. That's why I suggested to make 'extra_params' an alias.

Thanks,
drew

> 
> Thanks,
> 
> Alex
> 
> >
> > Thanks,
> > drew
> >
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
