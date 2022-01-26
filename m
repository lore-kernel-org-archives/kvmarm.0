Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4046C2BA4C
	for <kvmarm@archiver.kernel.org>; Wed, 26 Jan 2022 14:50:42 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3994940BE6;
	Wed, 26 Jan 2022 09:50:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id onfDMGPNsy0b; Wed, 26 Jan 2022 09:50:41 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1A1A040C02;
	Wed, 26 Jan 2022 09:50:41 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A1DBD40BDC
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Jan 2022 09:50:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MOLjHcD5Owfo for <kvmarm@lists.cs.columbia.edu>;
 Wed, 26 Jan 2022 09:50:38 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B55894076A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Jan 2022 09:50:38 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1643208638;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=24kMRqjE/mfts4KLJ2o54Nm09IK0MxEZxPEl8a0jE8A=;
 b=T9ngbtj+gXNjZe3/raBFhA/tQxQ31y2lNQI7IWEPg7nTQoxa58KSNir+TCNvfNWW/vZy3C
 PI5p5HvIdA4n5T+Rls2a1lzsmrL303whPRer2g2c0uXhoTnzgw89auXaV0NxnhA7+XQNx1
 2rMREBHMhyjeazW2HFSKdWFCwB+3sW4=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-110-LxZYbitOO8qGDLCHCLx1jQ-1; Wed, 26 Jan 2022 09:50:37 -0500
X-MC-Unique: LxZYbitOO8qGDLCHCLx1jQ-1
Received: by mail-ed1-f69.google.com with SMTP id
 l16-20020aa7c3d0000000b004070ea10e7fso8297493edr.3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Jan 2022 06:50:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=24kMRqjE/mfts4KLJ2o54Nm09IK0MxEZxPEl8a0jE8A=;
 b=lCF5hzl5Wyg1p3w+6u5SJeO+ogrnqVZmifXUcxJkwUrKgmJENZ2rafgL5GacmFCKI9
 IpozDz8ImfXF1tpiHGJ1xOJ5KbD+3FnNbuvSZXZXCF4ICtVEN5ewhFaq5ctnLwGEceL4
 u3Rj6NsQQRAPsiDcvGTS0X29m8TLh74ILsOG0624EdEZtH0FtGVVfWo0oHRYoSjAw2FQ
 XzZFgvS9f2/CmWVU5oR6RK5Ro9w09lPj8snHVixncYIwlclXGjBlt62tDOO3DpvXKbzp
 Lml9xMRrPPX5PwzxDKryukkUtv3F+oHD4yJV65SxgYFe10j/+3drMNSB1OXNKDuymIyP
 kp/g==
X-Gm-Message-State: AOAM530W8lyeciKfrEptZvWevs7eTBFpxOhS75ZYp8qjeBVZlwLbBpjq
 XUEzQEjBsxDv+7aJCjuRQFPMI+OapJPj70FImvX96t1boFmdp/4dy4ifmTDFGoQM1Hs1e+q2rZ8
 tuyvTDyTZZc/qg8yr2kg4P9wB
X-Received: by 2002:a05:6402:190f:: with SMTP id
 e15mr13639036edz.203.1643208635945; 
 Wed, 26 Jan 2022 06:50:35 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwBd/vEwW4Z/avy9Ldd+WhZ42kptNp4wXi1sz3pTq9kDD70yxHrMmoYahynWpglFwM0w/OaQA==
X-Received: by 2002:a05:6402:190f:: with SMTP id
 e15mr13639020edz.203.1643208635749; 
 Wed, 26 Jan 2022 06:50:35 -0800 (PST)
Received: from gator (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
 by smtp.gmail.com with ESMTPSA id k24sm5955935ejv.179.2022.01.26.06.50.34
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 26 Jan 2022 06:50:35 -0800 (PST)
Date: Wed, 26 Jan 2022 15:50:33 +0100
From: Andrew Jones <drjones@redhat.com>
To: Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v2] kselftest: kvm/arm64: Skip tests if we can't create a
 vgic-v3
Message-ID: <20220126145033.nwsf2g7dim7yeoz2@gator>
References: <20220126135319.1918802-1-broonie@kernel.org>
 <20220126141741.zxxltis5zdtjzz33@gator>
 <YfFauhK4FuM1/I8S@sirena.org.uk>
MIME-Version: 1.0
In-Reply-To: <YfFauhK4FuM1/I8S@sirena.org.uk>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
 Shuah Khan <shuah@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-kselftest@vger.kernel.org
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

On Wed, Jan 26, 2022 at 02:29:14PM +0000, Mark Brown wrote:
> On Wed, Jan 26, 2022 at 03:17:41PM +0100, Andrew Jones wrote:
> > On Wed, Jan 26, 2022 at 01:53:19PM +0000, Mark Brown wrote:
> 
> > > -	vgic_v3_setup(vm, nr_vcpus, 64, GICD_BASE_GPA, GICR_BASE_GPA);
> > > +	ret = vgic_v3_setup(vm, nr_vcpus, 64, GICD_BASE_GPA, GICR_BASE_GPA);
> > > +	if (ret < 0) {
> > > +		pr_info("Failed to create vgic-v3, skipping\n");
> 
> > Please use 'print_skip', which appends ", skipping test" to keep the skip
> > messages consistent. Also, print_skip can't be disabled with -DQUIET like
> > pr_info.
> 
> I see.  It might be nice to convert these tests to use the ksft_
> stuff...

Indeed. I'll add that to my TODO.

> 
> > > -	/* Distributor setup */
> > > +	/* Distributor setup - test if it's possible then actually do it */
> > > +	gic_fd = kvm_create_device(vm, KVM_DEV_TYPE_ARM_VGIC_V3, true);
> > > +	if (gic_fd != 0)
> > > +		return -1;
> > >  	gic_fd = kvm_create_device(vm, KVM_DEV_TYPE_ARM_VGIC_V3, false);
> 
> > kvm selftests generally asserts on failure with the nonunderscore
> > prefixed KVM ioctl wrapper functions, which is why you appear to
> > be forced to do this nasty dance. However, kvm selftests usually
> > always also offers an underscore prefixed version of the KVM ioctl
> > wrapper function too for cases like these. So we can just do
> 
> >   if (_kvm_create_device(vm, KVM_DEV_TYPE_ARM_VGIC_V3, false, &gic_fd) != 0)
> >           return -1;
> 
> And the _ version is OK to use in the vgic code?  The _ makes it look
> like it's internal only.

It's extra OK. Anything in lib/* or lib/*/* is internal to the lib.
However, it's even OK for a unit test to use the _ prefixed functions.
The _ isn't so much about being internal as it is about being a raw
version of the ioctl wrapper, which returns error codes, vs. the
asserting version of the wrapper which only returns results on success.

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
