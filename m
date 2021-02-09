Return-Path: <SRS0=2BI6=HL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1D88C433E9
	for <kvmarm@archiver.kernel.org>; Tue,  9 Feb 2021 10:00:37 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DAFAC64E9A
	for <kvmarm@archiver.kernel.org>; Tue,  9 Feb 2021 10:00:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DAFAC64E9A
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 42D324B782;
	Tue,  9 Feb 2021 05:00:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4Vxa72-0y6bg; Tue,  9 Feb 2021 05:00:35 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 577034B783;
	Tue,  9 Feb 2021 05:00:35 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8F1404B781
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Feb 2021 05:00:34 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id N6UVWZpI2JqA for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Feb 2021 05:00:33 -0500 (EST)
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com
 [209.85.221.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8004C4B73E
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Feb 2021 05:00:33 -0500 (EST)
Received: by mail-wr1-f43.google.com with SMTP id b3so20854346wrj.5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 09 Feb 2021 02:00:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=qm0cSL/QtRytmHGpisi5xpuLYYaM91e4VtafX8yXdgA=;
 b=Qu2b01DvtGYXJeJxDXNNE1KeI4fwXHqTFP9NUINIClmyovM1EXyaAgdMtyphaqcPjz
 BW240oE/Ro+4mYQ1ho1diep6tj3gk7c8M0PWNQLRph+DujYRBkt+OZiYtke0CFce7jNu
 eWWChjHaBXyma6Xojt/HIqFpTZhtiIr0lUinDES0r/155umcLvlXYF1CdiDmsr5kDpdc
 7+6EjCub+DdSxNlJS+ueD7dMv83ZN0AEi4wyB90rziN/G7o5cmaehpvfAuHpWq/wNyIT
 WjeOv5dbYzTilYNyXTp8Us0S0ITCiDcb8eVCd4CLm/L+uBwK1C5FbMuA2YsxK3110zzh
 ng/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=qm0cSL/QtRytmHGpisi5xpuLYYaM91e4VtafX8yXdgA=;
 b=Rtx49z1t3oILuUspXUDULKrYWv/0RjsEfuAPjQBcUFNCmr2/F1/tNd1NSXw2HdQmJP
 60j5MBGEnaEwsPCc0RJ53uzAjtydML8pbar+iDI6vX22VyOCx3iKQeeOM7G/LBXIGBeW
 tuxvBSEtF5i5uHm0pROpE9K9Hcc6dJ/rmmSA9c4pLjzYA9tIRQolrF+2woRHOSJbpEHI
 wrOj6HRh2onzFlbYd+PDHt0tDulc5YJp5WaJ7XBXj9AnOijN9StZpfvtZIUncdje+8u1
 0zBZN/kiGF1bacjvd1KDpmN0tqObFYMMX0bY4zR0tx1v0sWy1TWxzqIk4YPwaSyXXHIA
 c3nQ==
X-Gm-Message-State: AOAM530XEisBWuwGscHw5MnxKqTDPDsP8fKdTWZjFJX6xyZXAFpBkFNz
 sDWwa1Rqjs1cH5VJC3SQ2jEryg==
X-Google-Smtp-Source: ABdhPJyXLvE+jYOfb0Dy90ik3YsfWn6xHnuNbVcZCVLQKV4b7h1RDaJQVeB4jpjHc7njZBq4PHZhFQ==
X-Received: by 2002:a5d:43c2:: with SMTP id v2mr12217582wrr.81.1612864832295; 
 Tue, 09 Feb 2021 02:00:32 -0800 (PST)
Received: from google.com (230.69.233.35.bc.googleusercontent.com.
 [35.233.69.230])
 by smtp.gmail.com with ESMTPSA id m6sm3113718wmq.13.2021.02.09.02.00.31
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 09 Feb 2021 02:00:31 -0800 (PST)
Date: Tue, 9 Feb 2021 10:00:29 +0000
From: Quentin Perret <qperret@google.com>
To: Will Deacon <will@kernel.org>
Subject: Re: [RFC PATCH v2 16/26] KVM: arm64: Prepare Hyp memory protection
Message-ID: <YCJdPXuGr9kCIKVM@google.com>
References: <20210108121524.656872-1-qperret@google.com>
 <20210108121524.656872-17-qperret@google.com>
 <20210203143709.GA18907@willie-the-truck>
 <YBvQrHdbiNTSLQq6@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <YBvQrHdbiNTSLQq6@google.com>
Cc: devicetree@vger.kernel.org, kernel-team@android.com, android-kvm@google.com,
 Catalin Marinas <catalin.marinas@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
 linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
 Frank Rowand <frowand.list@gmail.com>, kvmarm@lists.cs.columbia.edu
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

On Thursday 04 Feb 2021 at 10:47:08 (+0000), Quentin Perret wrote:
> On Wednesday 03 Feb 2021 at 14:37:10 (+0000), Will Deacon wrote:
> > > +static void handle___pkvm_init(struct kvm_cpu_context *host_ctxt)
> > > +{
> > > +	DECLARE_REG(phys_addr_t, phys, host_ctxt, 1);
> > > +	DECLARE_REG(unsigned long, size, host_ctxt, 2);
> > > +	DECLARE_REG(unsigned long, nr_cpus, host_ctxt, 3);
> > > +	DECLARE_REG(unsigned long *, per_cpu_base, host_ctxt, 4);
> > > +
> > > +	cpu_reg(host_ctxt, 1) = __pkvm_init(phys, size, nr_cpus, per_cpu_base);
> > 
> > __pkvm_init() doesn't return, so I think this assignment back into host_ctxt
> > is confusing.
> 
> Very good point, I'll get rid of this.

Actually not, I think I'll leave it like that. __pkvm_init can return an
error, which is why I did this in the first place And it is useful for
debugging to have it propagated back to the host.

Thanks,
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
