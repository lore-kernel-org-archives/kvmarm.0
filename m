Return-Path: <SRS0=VYoy=N6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDA40C433F5
	for <kvmarm@archiver.kernel.org>; Wed,  8 Sep 2021 15:09:27 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5C1E5611C9
	for <kvmarm@archiver.kernel.org>; Wed,  8 Sep 2021 15:09:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 5C1E5611C9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C8B2F4B110;
	Wed,  8 Sep 2021 11:09:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rtIULpT5RAz2; Wed,  8 Sep 2021 11:09:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A038149DE7;
	Wed,  8 Sep 2021 11:09:25 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4AAE449E93
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Sep 2021 11:09:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AERNp1pjlUHp for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 Sep 2021 11:09:22 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5C4EB40191
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Sep 2021 11:09:22 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1631113762;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=qOXWFEXoU4d1PWQB2jnOUh191rdp073coPYvLg02Gzo=;
 b=fybg4P0xA83O/z5OCQltTRjVx6qxz/HXr4j6gNN7ZQPtnkcUZHG3MY84b9QnI/T01bVEcY
 Qa+h4M2g8tYuWm0B/YxoY7hv7MndI1hXABDGxcG7RoG/YMRSsEamAJsP4WXk+/lYNc0w/V
 ncZO4a/Fbgj6YHTpgA5BNc1IjsXvQ7g=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-587-LPg6H495M-OC364GbdVQgw-1; Wed, 08 Sep 2021 11:09:21 -0400
X-MC-Unique: LPg6H495M-OC364GbdVQgw-1
Received: by mail-ed1-f69.google.com with SMTP id
 bf22-20020a0564021a5600b003c86b59e291so1238087edb.18
 for <kvmarm@lists.cs.columbia.edu>; Wed, 08 Sep 2021 08:09:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=qOXWFEXoU4d1PWQB2jnOUh191rdp073coPYvLg02Gzo=;
 b=Bd+K+uwyP6wibILP927vJHwH7jvP7UW/ICB49FtUpIv3NRp0asqfGg9+X/ILTLw6Cv
 0mnSAcbjKBYvUh6OxeaamdNzbEE3mtz76EHyXCnYQzzKPttRdg5xtZTL+ZQO3BoEdstY
 0MH4QrCRzAiV2F8zg2YXLu9aayLChienknQZxgI9pFSd5arx7EjY8EP1aEbxUvKJFwfE
 pfWRnwGJ/8VA2eqaPwhrkcW6C5xNcwfrAtGXP6QyzGzBwj4jjBZ4fBtkeciB610OAaul
 ibfeadt67mzS2wXAFXo3/+rbSRiGSj7hZGVNPi0IHG+W56pH2Cd8mLOIHYnKhbaV8w03
 s2cQ==
X-Gm-Message-State: AOAM531U3pqbItH4pk4YM/spt3kysQCks7/KC4cOU6vpUTizi+J1euZw
 7Ycpvy9zk/IJXEM/TmWGHq0mm9eJGQxS9GVPAggpSMinlOk6utquELoKyLTIdbAfiLg+8PlvCFz
 dTeDtQS2W7mrnj7Xtxj/SQWij
X-Received: by 2002:a50:c299:: with SMTP id o25mr1576709edf.80.1631113760145; 
 Wed, 08 Sep 2021 08:09:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyjnp+xQJV2TBV697pikqHC83BtR6hOPk6Xeh4PK3nYaAVUley8kE1D6LAnFzw9L4RuDVfVYQ==
X-Received: by 2002:a50:c299:: with SMTP id o25mr1576689edf.80.1631113759944; 
 Wed, 08 Sep 2021 08:09:19 -0700 (PDT)
Received: from gator (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
 by smtp.gmail.com with ESMTPSA id b15sm1188273ejq.83.2021.09.08.08.09.18
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 08 Sep 2021 08:09:19 -0700 (PDT)
Date: Wed, 8 Sep 2021 17:09:12 +0200
From: Andrew Jones <drjones@redhat.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [kvm-unit-tests RFC PATCH 3/5] run_tests.sh: Add kvmtool support
Message-ID: <20210908150912.3d57akqkfux4fahj@gator>
References: <20210702163122.96110-1-alexandru.elisei@arm.com>
 <20210702163122.96110-4-alexandru.elisei@arm.com>
 <20210907101730.trnsig2j4jmhinyu@gator>
 <587a5f8c-cf04-59ec-7e35-4ca6adf87862@arm.com>
MIME-Version: 1.0
In-Reply-To: <587a5f8c-cf04-59ec-7e35-4ca6adf87862@arm.com>
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

On Wed, Sep 08, 2021 at 03:33:19PM +0100, Alexandru Elisei wrote:
...
> >> +fixup_kvmtool_opts()
> >> +{
> >> +    local opts=$1
> >> +    local groups=$2
> >> +    local gic
> >> +    local gic_version
> >> +
> >> +    if find_word "pmu" $groups; then
> >> +        opts+=" --pmu"
> >> +    fi
> >> +
> >> +    if find_word "its" $groups; then
> >> +        gic_version=3
> >> +        gic="gicv3-its"
> >> +    elif [[ "$opts" =~ -machine\ *gic-version=(2|3) ]]; then
> >> +        gic_version="${BASH_REMATCH[1]}"
> >> +        gic="gicv$gic_version"
> >> +    fi
> >> +
> >> +    if [ -n "$gic" ]; then
> >> +        opts=${opts/-machine gic-version=$gic_version/}
> >> +        opts+=" --irqchip=$gic"
> >> +    fi
> >> +
> >> +    opts=${opts/-append/--params}
> >> +
> >> +    echo "$opts"
> >> +}
> > Hmm, I don't think we want to write a QEMU parameter translator for
> > all other VMMs, and all other VMM architectures, that we want to
> > support. I think we should add new "extra_params" variables to the
> > unittest configuration instead, e.g. "kvmtool_params", where the
> > extra parameters can be listed correctly and explicitly. While at
> > it, I would create an alias for "extra_params", which would be
> > "qemu_params" allowing unittests that support more than one VMM
> > to clearly show what's what.
> 
> I agree, this is a much better idea than a parameter translator. Using a dedicated
> variable in unittests.cfg will make it easier for new tests to get support for all
> VMMs (for example, writing a list of parameters in unittests.cfg should be easier
> than digging through the scripts to figure exactly how and where to add a
> translation for a new parameter), and it allow us to express parameters for other
> VMMs which don't have a direct correspondent in qemu.
> 
> By creating an alias, do you mean replacing extra_params with qemu_params in
> arm/unittests.cfg? Or something else?

Probably something like this

diff --git a/scripts/common.bash b/scripts/common.bash
index 7b983f7d6dd6..e5119ff216e5 100644
--- a/scripts/common.bash
+++ b/scripts/common.bash
@@ -37,7 +37,12 @@ function for_each_unittest()
                elif [[ $line =~ ^smp\ *=\ *(.*)$ ]]; then
                        smp=${BASH_REMATCH[1]}
                elif [[ $line =~ ^extra_params\ *=\ *(.*)$ ]]; then
-                       opts=${BASH_REMATCH[1]}
+               elif [[ $line =~ ^extra_params\ *=\ *(.*)$ ]]; then
+                       qemu_opts=${BASH_REMATCH[1]}
+               elif [[ $line =~ ^qemu_params\ *=\ *(.*)$ ]]; then
+                       qemu_opts=${BASH_REMATCH[1]}
+               elif [[ $line =~ ^kvmtool_params\ *=\ *(.*)$ ]]; then
+                       kvmtool_opts=${BASH_REMATCH[1]}
                elif [[ $line =~ ^groups\ *=\ *(.*)$ ]]; then
                        groups=${BASH_REMATCH[1]}
                elif [[ $line =~ ^arch\ *=\ *(.*)$ ]]; then

and all other changes needed to support the s/opts/qemu_opts/ change
should work. Also, an addition to the unittests.cfg documentation.

The above diff doesn't consider that a unittests.cfg file could have
both an 'extra_params' and a 'qemu_params' field, but I'm not sure
we care about that. Users should read the documentation and we
should review changes to the committed unittests.cfg files to avoid
that.

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
