Return-Path: <SRS0=saMt=KH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 674D8C433B4
	for <kvmarm@archiver.kernel.org>; Wed, 12 May 2021 16:03:16 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9E9F661CDF
	for <kvmarm@archiver.kernel.org>; Wed, 12 May 2021 16:03:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9E9F661CDF
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EED224B2C0;
	Wed, 12 May 2021 12:03:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id oqk7WseFIM-z; Wed, 12 May 2021 12:03:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7DC324B2B0;
	Wed, 12 May 2021 12:03:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D0A594B2B0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 May 2021 12:03:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id F0ODt8HFnT3O for <kvmarm@lists.cs.columbia.edu>;
 Wed, 12 May 2021 12:03:09 -0400 (EDT)
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com
 [209.85.214.176])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8DB6B4B29B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 May 2021 12:03:09 -0400 (EDT)
Received: by mail-pl1-f176.google.com with SMTP id 69so8134195plc.5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 May 2021 09:03:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=aVmYs+apRTUqz4G5EyhD9SbyJQ4D0L1K0aWCoYWQfJ4=;
 b=s5qzg3DgtagxZgqEuCvBBT9OJVOYAC90VkRdOaYWhLb/+zDfsksL1iYK1XGsNDvdKS
 t6BB+PVuYZW91u4G+0W2cD57E41ffaMQlDL+kkRggWgcTQDISSVFfRAOFir9rLHowdR6
 aI2zTQB2pncjxwwjlgPG4omBnQRJ4NMd9slrMqnVnlmdry/svKybNOtRvq9f8e6dy2m3
 axJIU4o1dZvAxanU/HnpK6skIvd1XRLHcU+cRlaHLhCIIzAzrggk5I7QtDmksB6RQ2r2
 2nBp/Cywyl9r1xuiS7q4aGDQKvhVTQfVp7KKRiJAqBeDtreSkdI4WzC8cRmWVrdFuXPn
 mWcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=aVmYs+apRTUqz4G5EyhD9SbyJQ4D0L1K0aWCoYWQfJ4=;
 b=rlU7cJY1O1Rz3/sliXaXFcV+IOf3SBQpZYyaPGIyVx2WZ/eIKhbL1Kx8CWUK3RbgLA
 gMTEsgeKawKmMCCBGdgvcA7ABfWsnxabJhoa8Oz3AvEIRZKsxJuxKMyMg3+0lRFUrX59
 SR9Zl7owVQC4uOOL/1wii2nImlK9AAKFc8RwSMzvSUbCYuPnApiyh154qv3nagg6K4lK
 YmXrtj6g8mAhRTpYjP7kgg4oLQKU6hnI+Buxi1/1H916WWTTjRYTha7v/dODgQZvyBRm
 niqg2IT61xurVk8v4MKEy/x5pPMuEJJajsMaXo9aih/cDnCVoSpLlanIP5fOmfVxwbZj
 g+9Q==
X-Gm-Message-State: AOAM533JU5p+lxXKxnF9a77VpHmL/2QxFLfCsRjwaIqK+HCG4o/tPNZO
 OSGAyPjODEbCeR1Cw5oL5PI1nA==
X-Google-Smtp-Source: ABdhPJy7Ar45AwH9wnKOlmuIMHWU46FfLre/sapwc88FmtcyWz+BGSUr9GP3erEG+vu+s1aHbuf/6w==
X-Received: by 2002:a17:902:e84c:b029:ee:d129:3b1c with SMTP id
 t12-20020a170902e84cb02900eed1293b1cmr35466669plg.73.1620835385927; 
 Wed, 12 May 2021 09:03:05 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com.
 [34.83.12.150])
 by smtp.gmail.com with ESMTPSA id j7sm223478pfd.129.2021.05.12.09.03.05
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 12 May 2021 09:03:05 -0700 (PDT)
Date: Wed, 12 May 2021 09:03:01 -0700
From: Ricardo Koller <ricarkol@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 4/5] KVM: selftests: Add exception handling support
 for aarch64
Message-ID: <YJv8NUtKilXPDYpY@google.com>
References: <20210430232408.2707420-1-ricarkol@google.com>
 <20210430232408.2707420-5-ricarkol@google.com>
 <87a6pcumyg.wl-maz@kernel.org> <YJBLFVoRmsehRJ1N@google.com>
 <20915a2f-d07c-2e61-3cce-ff385e98e796@redhat.com>
 <4f7f81f9-8da0-b4ef-49e2-7d87b5c23b15@huawei.com>
 <a5ad32abf4ff6f80764ee31f16a5e3fc@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <a5ad32abf4ff6f80764ee31f16a5e3fc@kernel.org>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
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

On Wed, May 12, 2021 at 02:43:28PM +0100, Marc Zyngier wrote:
> On 2021-05-12 13:59, Zenghui Yu wrote:
> > Hi Eric,
> > 
> > On 2021/5/6 20:30, Auger Eric wrote:
> > > running the test on 5.12 I get
> > > 
> > > ==== Test Assertion Failure ====
> > >   aarch64/debug-exceptions.c:232: false
> > >   pid=6477 tid=6477 errno=4 - Interrupted system call
> > >      1	0x000000000040147b: main at debug-exceptions.c:230
> > >      2	0x000003ff8aa60de3: ?? ??:0
> > >      3	0x0000000000401517: _start at :?
> > >   Failed guest assert: hw_bp_addr == PC(hw_bp) at
> > > aarch64/debug-exceptions.c:105
> > > 	values: 0, 0x401794
> > 
> > FYI I can also reproduce it on my VHE box. And Drew's suggestion [*]
> > seemed to work for me. Is the ISB a requirement of architecture?
> 
> Very much so. Given that there is no context synchronisation (such as
> ERET or an interrupt) in this code, the CPU is perfectly allowed to
> delay the system register effect as long as it can.
> 
>         M.
> -- 
> Jazz is not dead. It just smells funny...

Thank you very much Eric, Zenghui, Marc, and Andrew (for the ISB
suggestion)!

As per Zenghui test, will send a V3 that includes the missing ISBs.
Hopefully that will fix the issue for Eric as well. It's very
interesting that the CPU seems to _always_ reorder those instructions.

Thanks!
Ricardo
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
