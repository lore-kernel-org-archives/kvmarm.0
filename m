Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FD6FC00144
	for <kvmarm@archiver.kernel.org>; Wed, 27 Jul 2022 02:29:12 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 72F804C2B8;
	Tue, 26 Jul 2022 22:29:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id thGMexMaP2rs; Tue, 26 Jul 2022 22:29:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 598054C2BE;
	Tue, 26 Jul 2022 22:29:10 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D989B4C2B8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jul 2022 22:29:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id N8Wgn0WJ-XDs for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Jul 2022 22:29:07 -0400 (EDT)
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com
 [209.85.210.173])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CA7A64C23D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jul 2022 22:29:07 -0400 (EDT)
Received: by mail-pf1-f173.google.com with SMTP id b9so14883354pfp.10
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jul 2022 19:29:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=Xt1DjmVl4U5N3l5qtCeMuaUsGLKcjntACgSyyEM4lUc=;
 b=szuOoqkw2ViLkaHOXdhTRcJsv330QS30uwrWThy/QvFSt6dMjYUW1Kb8xRHB3hHPZS
 jdH5iGcFHQbPtves5M/Viy5DL2k8GvQcSKXD6fCWbuzjobMEzkAwoIR1WbkuIbvsADBD
 UFRiX1ADtYD2qF0FsUZDzDHekJrgTd6TxftAtoyHi6rTHfhHOMx3UpuRMsrzUBVTmUOk
 MKKsll0lqKC1Rb7z7XK/zSVY2xjpYzCkYbCa+QBeiEs5kd1+qEdwuf76+9vk5pdxHbhx
 XTsatamtSYbiDrgrdTKVYkGkmzlIqafnE3iXC9mxzBA7XRvtNYmKoi1YOo+0TyJ75I6B
 ABBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=Xt1DjmVl4U5N3l5qtCeMuaUsGLKcjntACgSyyEM4lUc=;
 b=Idf90ix/7ByqvLkiW4sdUc7gB8Ba5pYQNVJzIDHq7hLlXaqh7iHkJqisSNDv6B4MJO
 pTWjfoZmBQ7eXRIyu8OMM25tGn36NfyEcRzwo4A4GULtfFXERVcNuQ+aStRRcNCvO8vj
 cefwi0Ak07+XZRKtTlf4Xxjz7JMdYiBOS5Ba+RxvFVilyrrx3DrGmTHIJ2/TkMI4HG0w
 dZlMRSA6oR0EXfp/g3h4hTTk+DnW6lqkHuKb0WK1M7rkQu70IcGa6vsVHc3gI0b6Uou2
 66CSpYWC9+lhzaYots35Z1LQC2nDW88A7qE9xicGm4gZWxYmOg2vPEdnhc7mVtzofeXr
 JWcw==
X-Gm-Message-State: AJIora8OwHMB+TNMXjsGQf7SV5Npqnfwu4AC27MwRFCBToAl9p0a9wpC
 8PiiZSVqC7CMLl6lliIIXPK7gg==
X-Google-Smtp-Source: AGRyM1uX1ZM5ywBj8WbRVbH9b+XKaR87Z46iycdDdF6uQ9blbrk80iU3FnQ/eDW4XGZGRdcazp1H1A==
X-Received: by 2002:a65:580e:0:b0:41a:4c10:817f with SMTP id
 g14-20020a65580e000000b0041a4c10817fmr17433895pgr.93.1658888946533; 
 Tue, 26 Jul 2022 19:29:06 -0700 (PDT)
Received: from google.com (220.181.82.34.bc.googleusercontent.com.
 [34.82.181.220]) by smtp.gmail.com with ESMTPSA id
 j6-20020a170902da8600b0016d763967f8sm5617010plx.107.2022.07.26.19.29.05
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 26 Jul 2022 19:29:05 -0700 (PDT)
Date: Tue, 26 Jul 2022 19:29:01 -0700
From: Ricardo Koller <ricarkol@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [kvm-unit-tests PATCH 3/3] arm: pmu: Remove checks for !overflow
 in chained counters tests
Message-ID: <YuCi7ew10HfnSFmc@google.com>
References: <20220718154910.3923412-4-ricarkol@google.com>
 <87edyhz68i.wl-maz@kernel.org> <Yte/YXWYSikyQcqh@google.com>
 <875yjsyv67.wl-maz@kernel.org> <Ythw1UT1wFHbY/jN@google.com>
 <Ythy8XXN2rFytXdr@google.com> <871quezill.wl-maz@kernel.org>
 <YtscUOUGKra3LpsK@google.com>
 <20220723075955.ipoekdpzkqticadt@kamzik>
 <875yjmdf23.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <875yjmdf23.wl-maz@kernel.org>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 Andrew Jones <andrew.jones@linux.dev>
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

On Sun, Jul 24, 2022 at 10:40:20AM +0100, Marc Zyngier wrote:
> On Sat, 23 Jul 2022 08:59:55 +0100,
> Andrew Jones <andrew.jones@linux.dev> wrote:
> > 
> > On Fri, Jul 22, 2022 at 02:53:20PM -0700, Ricardo Koller wrote:
> > > 
> > > Which brings me to what to do with this test. Should it be fixed for
> > > bare-metal by ignoring the PMOVSSET check? or should it actually check
> > > for PMOVSSET=1 and fail on KVM until KVM gets fixed?
> > >
> > 
> > Hi Ricardo,
> > 
> > Please write the test per the spec. Failures pointed out in kvm-unit-tests
> > are great, when the tests are written correctly, since it means it's
> > doing its job :-)
> 
> Agreed. This is a bug, and bugs are to be fixed. The fact that it will
> flare up and annoy people is a good incentive to fix the kernel!
> 

Sounds good, thank you both. Will send V2 with the proper behavior then.

Thanks,
Ricardo

> Thanks,
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
