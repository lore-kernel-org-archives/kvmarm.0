Return-Path: <SRS0=sayA=JR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26DBFC433B4
	for <kvmarm@archiver.kernel.org>; Tue, 20 Apr 2021 16:51:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6E0476135F
	for <kvmarm@archiver.kernel.org>; Tue, 20 Apr 2021 16:51:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6E0476135F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 966AF4B3D1;
	Tue, 20 Apr 2021 12:51:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5-3wtzYWLm-R; Tue, 20 Apr 2021 12:51:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 859764B39F;
	Tue, 20 Apr 2021 12:51:47 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3794A4B39B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Apr 2021 12:51:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id U866ODwoWZ9J for <kvmarm@lists.cs.columbia.edu>;
 Tue, 20 Apr 2021 12:51:45 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 41A9C4B380
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Apr 2021 12:51:45 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1618937505;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=tZGILbW5lYeHumeP6O6QqclV3GEtjDxhfENCYh0m+CM=;
 b=E6u0FA8YVKPx4YZ0CLIbesgHkN8fTwNpeag8r0NFXPXbF2/noHBIvLUBL3YDuQU0EBLTBT
 n89r3P5qhjAnfBPjqr+BcO8aHrRK5XAENOp6+BeuFnk6EQzwknHpnc3sPMpmEMDkStL5gd
 Aspc8JQ1Z5rohZkydI4R6wa1jCZ0YNY=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-499-S6APQPuGOMmt7ztA7QlXwQ-1; Tue, 20 Apr 2021 12:51:06 -0400
X-MC-Unique: S6APQPuGOMmt7ztA7QlXwQ-1
Received: by mail-ed1-f70.google.com with SMTP id
 f9-20020a50fe090000b02903839889635cso11479794edt.14
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Apr 2021 09:51:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=tZGILbW5lYeHumeP6O6QqclV3GEtjDxhfENCYh0m+CM=;
 b=I870lOfWGwx6nDT8lSIUNFY/jj0zVcsIu5/0HZeJ2We2py6jtPjJbCSqIPSMq5Qjw8
 17c6g5wu4R2E7hW4wVJuov8Iiya5CXTfZVDbXHc2tR3SYGCoHBWzCLNbCxJ3bsuwySN4
 1oiF0U0T7gaBuls7rzqCRkFerQTwkYu7FzOfhXGpbxiSjNRbHWmGQdYIa7LmSzaGY8oO
 kyJCKjENFWCXjZCV2r2wu1Nyd1m9My7TdDboJUl4ZAryznLLZfY5jqO+YdR4XOwcKaHJ
 oIKRYDX4AJaxePHyjPd0jAaMiElxv7D8CRZ5GfHzdjVGLVa8O8DOy1gPk9qTjeeeiM5e
 eHFg==
X-Gm-Message-State: AOAM5314sgZd4dJd3A3AAIsJMk2/phoVKf3PnCse7JZQfgR418w+ly7P
 EcB92vx9l/kyXteZ2ELtBFCrUiW1qFVDuOdew8KrPey4P0TRBIi7yHGtDr2tI2DjjgDVdib7fHv
 0gxCF9N2B91AmSYTGGqmBuoQq
X-Received: by 2002:a17:906:a20b:: with SMTP id
 r11mr8780448ejy.323.1618937465005; 
 Tue, 20 Apr 2021 09:51:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwL5KA4qQaeXGknmm3Xp+nypJu8k1ETUJbyg+XCSOizIJi3da9UkAOcK2L3vpIXCljtynanEQ==
X-Received: by 2002:a17:906:a20b:: with SMTP id
 r11mr8780434ejy.323.1618937464762; 
 Tue, 20 Apr 2021 09:51:04 -0700 (PDT)
Received: from gator.home (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
 by smtp.gmail.com with ESMTPSA id i2sm13198678ejv.99.2021.04.20.09.51.03
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 20 Apr 2021 09:51:04 -0700 (PDT)
Date: Tue, 20 Apr 2021 18:51:01 +0200
From: Andrew Jones <drjones@redhat.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [kvm-unit-tests RFC PATCH 0/1] configure: arm: Replace --vmm
 with --target
Message-ID: <20210420165101.irbx2upgqbazkvlt@gator.home>
References: <20210420161338.70914-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
In-Reply-To: <20210420161338.70914-1-alexandru.elisei@arm.com>
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

Hi Alex,

On Tue, Apr 20, 2021 at 05:13:37PM +0100, Alexandru Elisei wrote:
> This is an RFC because it's not exactly clear to me that this is the best
> approach. I'm also open to using a different name for the new option, maybe
> something like --platform if it makes more sense.

I like 'target'.

> 
> I see two use cases for the patch:
> 
> 1. Using different files when compiling kvm-unit-tests to run as an EFI app
> as opposed to a KVM guest (described in the commit message).
> 
> 2. This is speculation on my part, but I can see extending
> arm/unittests.cfg with a "target" test option which can be used to decide
> which tests need to be run based on the configure --target value. For
> example, migration tests don't make much sense on kvmtool, which doesn't
> have migration support. Similarly, the micro-bench test doesn't make much
> sense (to me, at least) as an EFI app. Of course, this is only useful if
> there are automated scripts to run the tests under kvmtool or EFI, which
> doesn't look likely at the moment, so I left it out of the commit message.

Sounds like a good idea. unittests.cfg could get a new option 'targets'
where a list of targets is given. If targets is not present, then the
test assumes it's for all targets. Might be nice to also accept !<target>
syntax. E.g.

# builds/runs for all targets
[mytest]
file = mytest.flat

# builds/runs for given targets
[mytest2]
file = mytest2.flat
targets = qemu,kvmtool

# builds/runs for all targets except disabled targets
[mytest3]
file = mytest3.flat
targets = !kvmtool

And it wouldn't bother me to have special logic for kvmtool's lack of
migration put directly in scripts/runtime.bash

diff --git a/scripts/runtime.bash b/scripts/runtime.bash
index 132389c7dd59..0d5cb51df4f4 100644
--- a/scripts/runtime.bash
+++ b/scripts/runtime.bash
@@ -132,7 +132,7 @@ function run()
     }
 
     cmdline=$(get_cmdline $kernel)
-    if grep -qw "migration" <<<$groups ; then
+    if grep -qw "migration" <<<$groups && [ "$TARGET" != "kvmtool" ]; then
         cmdline="MIGRATION=yes $cmdline"
     fi
     if [ "$verbose" = "yes" ]; then

> 
> Using --vmm will trigger a warning. I was thinking about removing it entirely in
> a about a year's time, but that's not set in stone. Note that qemu users
> (probably the vast majority of people) will not be affected by this change as
> long as they weren't setting --vmm explicitely to its default value of "qemu".
>

While we'd risk automated configure+build tools, like git{hub,lab} CI,
failing, I think the risk is pretty low right now that anybody is using
the option. Also, we might as well make them change sooner than later by
failing configure. IOW, I'd just do s/vmm/target/g to rename it now. If
we are concerned about the disruption, then I'd just make vmm an alias
for target and not bother deprecating it ever.

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
