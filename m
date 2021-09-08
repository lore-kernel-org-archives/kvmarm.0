Return-Path: <SRS0=VYoy=N6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39CB2C433F5
	for <kvmarm@archiver.kernel.org>; Wed,  8 Sep 2021 16:07:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AF5F56113E
	for <kvmarm@archiver.kernel.org>; Wed,  8 Sep 2021 16:07:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org AF5F56113E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2F6D14B116;
	Wed,  8 Sep 2021 12:07:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id yh56-u1zcacU; Wed,  8 Sep 2021 12:07:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 063AC4B093;
	Wed,  8 Sep 2021 12:07:50 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 183AA4B090
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Sep 2021 12:07:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CbYpXDq25Q3U for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 Sep 2021 12:07:48 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1737E4A524
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Sep 2021 12:07:48 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1631117267;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=bgAixjfqxK+KySv0KLIPFQXXlPfwGRV/dBCLSa1qrTs=;
 b=btRqPXObuJxNlKVXmAozL4d+thxCLg9dkRCUUM3PYgR+apTrjF2VU1vGcGfWiS1nW9yJvD
 g6N1ke/Pfw9lsHP7iv5epmUUIoXFibPzI4AGorrWSb52pTi/gqhJ5LlRyw7GlEG4caJRnY
 8yLhX7O7WXc6DoMB/0H69N3KbhtV8sY=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-444-dgfeC6inN1ygIUBovEqiDw-1; Wed, 08 Sep 2021 12:07:47 -0400
X-MC-Unique: dgfeC6inN1ygIUBovEqiDw-1
Received: by mail-ej1-f72.google.com with SMTP id
 v19-20020a170906b013b02905b2f1bbf8f3so1251847ejy.6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 08 Sep 2021 09:07:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=bgAixjfqxK+KySv0KLIPFQXXlPfwGRV/dBCLSa1qrTs=;
 b=A+RCvY9GuNU2UKmSwOvYCZdc0t6QbbVGinx50s/WY2CcfRpqSExKMu2OgHio/pT1le
 2z0ywO9NbetND+jd96xY9GCFr427fbRL/NBuXqNLUKbtCqq7nUE1ut4Bute5b8OAGXcF
 W+U3qZf0rrczV9DFrdVx4E/ePf5XT505hys04bifOPtdmnCjixJVu4RUlOGzgu6S6KEI
 xbLV89Ly34sH988wbjGYI19R7PsBl5v9FXV2cyxvRsp+A8BAVITOOjFAzD+sUmd59xW/
 s2W54ELJRIJR4q0KAlsBCZJfWXw2N4oXmlpWDvAMvvPfViEjeOuF9MGm3k+YxHO5k9IB
 5eMA==
X-Gm-Message-State: AOAM531ozmQ12q+P1nO2bLwTe6zanEN3oBUBgOiK860RvIjVOuC2AjBx
 bQuaN6tVeaLiYXNdyJIAzTqO3pzxz4XTWBAReI8tJiDsjTJmuyHsbafWUm5VCKTm/ii9v+hoj1/
 EkTvIvixRDTz1dIGDItl9gbSu
X-Received: by 2002:aa7:c04e:: with SMTP id k14mr4597892edo.101.1631117265773; 
 Wed, 08 Sep 2021 09:07:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx/Z+CwRUwOjBWCCIIw4LzHo1BJr62ATb5mUiTSp/JNWar8qE3J6IMmTqOXtmUN6Dl6kWTUDw==
X-Received: by 2002:aa7:c04e:: with SMTP id k14mr4597875edo.101.1631117265580; 
 Wed, 08 Sep 2021 09:07:45 -0700 (PDT)
Received: from gator (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
 by smtp.gmail.com with ESMTPSA id l8sm1080254ejn.103.2021.09.08.09.07.44
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 08 Sep 2021 09:07:45 -0700 (PDT)
Date: Wed, 8 Sep 2021 18:07:43 +0200
From: Andrew Jones <drjones@redhat.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [kvm-unit-tests RFC PATCH 4/5] scripts: Generate kvmtool
 standalone tests
Message-ID: <20210908160743.l4hrl4de7wkxwuda@gator>
References: <20210702163122.96110-1-alexandru.elisei@arm.com>
 <20210702163122.96110-5-alexandru.elisei@arm.com>
 <20210907102135.i2w3r7j4zyj736b5@gator>
 <ee11a10a-c3e6-b9ce-81e1-147025a9b5bd@arm.com>
MIME-Version: 1.0
In-Reply-To: <ee11a10a-c3e6-b9ce-81e1-147025a9b5bd@arm.com>
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

On Wed, Sep 08, 2021 at 04:37:39PM +0100, Alexandru Elisei wrote:
> Hi Drew,
> 
> On 9/7/21 11:21 AM, Andrew Jones wrote:
> > On Fri, Jul 02, 2021 at 05:31:21PM +0100, Alexandru Elisei wrote:
> >> Add support for the standalone target when running kvm-unit-tests under
> >> kvmtool.
> >>
> >> Example command line invocation:
> >>
> >> $ ./configure --target=kvmtool
> >> $ make clean && make standalone
> >>
> >> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> >> ---
> >>  scripts/mkstandalone.sh | 14 +++++++-------
> >>  1 file changed, 7 insertions(+), 7 deletions(-)
> >>
> >> diff --git a/scripts/mkstandalone.sh b/scripts/mkstandalone.sh
> >> index 16f461c06842..d84bdb7e278c 100755
> >> --- a/scripts/mkstandalone.sh
> >> +++ b/scripts/mkstandalone.sh
> >> @@ -44,6 +44,10 @@ generate_test ()
> >>  	config_export ARCH_NAME
> >>  	config_export PROCESSOR
> >>  
> >> +	if [ "$ARCH" = "arm64" ] || [ "$ARCH" = "arm" ]; then
> >> +		config_export TARGET
> >> +	fi
> > Should export unconditionally, since we'll want TARGET set
> > unconditionally.
> 
> Yes, will do.
> 
> >
> >> +
> >>  	echo "echo BUILD_HEAD=$(cat build-head)"
> >>  
> >>  	if [ ! -f $kernel ]; then
> >> @@ -59,7 +63,7 @@ generate_test ()
> >>  		echo 'export FIRMWARE'
> >>  	fi
> >>  
> >> -	if [ "$ENVIRON_DEFAULT" = "yes" ] && [ "$ERRATATXT" ]; then
> >> +	if [ "$TARGET" != "kvmtool" ] && [ "$ENVIRON_DEFAULT" = "yes" ] && [ "$ERRATATXT" ]; then
> > I think it would be better to ensure that ENVIRON_DEFAULT is "no" for
> > TARGET=kvmtool in configure.
> 
> From looking at the code, it is my understanding that with ENVIRON_DEFAULT=yes, an
> initrd file is generated with the contents of erratatxt and other information, in
> a key=value pair format. This initrd is then passed on to the test (please correct
> me if I'm wrong). With ENVIRON_DEFAULT=no (set via ./configure
> --disable-default-environ), this initrd is not generated.
> 
> kvmtool doesn't have support for passing an initrd when loading firmware, so yes,
> I believe the default should be no.
> 
> However, I have two questions:
> 
> 1. What happens when the user specifically enables the default environ via
> ./configure --enable-default-environ --target=kvmtool? In my opinion, that should
> be an error because the user wants something that is not possible with kvmtool
> (loading an image with --firmware in kvmtool means that the initrd image it not
> loaded into the guest memory and no node is generated for it in the dtb), but I
> would like to hear your thoughts about it.

As part of the forcing ENVIRON_DEFAULT to "no" for kvmtool in configure an
error should be generated if a user tries to explicitly enable it.

> 
> 2. If the default environment is disabled, is it still possible for an user to
> pass an initrd via other means? I couldn't find where that is implemented, so I'm
> guessing it's not possible.

Yes, a user could have a KVM_UNIT_TESTS_ENV environment variable set when
they launch the tests. If that variable points to a file then it will get
passed as an initrd. I guess you should also report a warning in arm/run
if KVM_UNIT_TESTS_ENV is set which states that the environment file will
be ignored when running with kvmtool.

There aren't currently any other ways to invoke the addition of the
-initrd command line option, because so far we only support passing a
single file to test (the environment "file"). If we ever want to pass
more files, then we'd need to create a simple file system on the initrd
and make it possible to add -initrd even when no environment is desired.
But, that may never happen.

Thanks,
drew

> 
> Thanks,
> 
> Alex
> 
> >
> >
> >>  		temp_file ERRATATXT "$ERRATATXT"
> >>  		echo 'export ERRATATXT'
> >>  	fi
> >> @@ -95,12 +99,8 @@ function mkstandalone()
> >>  	echo Written $standalone.
> >>  }
> >>  
> >> -if [ "$TARGET" = "kvmtool" ]; then
> >> -	echo "Standalone tests not supported with kvmtool"
> >> -	exit 2
> >> -fi
> >> -
> >> -if [ "$ENVIRON_DEFAULT" = "yes" ] && [ "$ERRATATXT" ] && [ ! -f "$ERRATATXT" ]; then
> >> +if [ "$TARGET" != "kvmtool" ] && [ "$ENVIRON_DEFAULT" = "yes" ] && \
> >> +		[ "$ERRATATXT" ] && [ ! -f "$ERRATATXT" ]; then
> >>  	echo "$ERRATATXT not found. (ERRATATXT=$ERRATATXT)" >&2
> >>  	exit 2
> >>  fi
> >> -- 
> >> 2.32.0
> >>
> > Thanks,
> > drew 
> >
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
