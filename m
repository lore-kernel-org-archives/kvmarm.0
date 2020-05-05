Return-Path: <SRS0=MGAT=6T=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE402C47254
	for <kvmarm@archiver.kernel.org>; Tue,  5 May 2020 17:24:02 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 79F29206FA
	for <kvmarm@archiver.kernel.org>; Tue,  5 May 2020 17:24:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="EkW9V00O"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 79F29206FA
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F029D4B259;
	Tue,  5 May 2020 13:24:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id km3Thg4-tCND; Tue,  5 May 2020 13:24:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0129B4B273;
	Tue,  5 May 2020 13:24:01 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9CB354B259
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 May 2020 13:23:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aSO-gKkuxKsb for <kvmarm@lists.cs.columbia.edu>;
 Tue,  5 May 2020 13:23:58 -0400 (EDT)
Received: from mail-wr1-f68.google.com (mail-wr1-f68.google.com
 [209.85.221.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7C43E4B208
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 May 2020 13:23:57 -0400 (EDT)
Received: by mail-wr1-f68.google.com with SMTP id h9so3741689wrt.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 05 May 2020 10:23:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=NP9OIn8aZdjTBigvGWGYSxvnTPBy4fLFwfAKc1uTAGA=;
 b=EkW9V00OjSI1/ZNXcCO2ShjrxSwU48K+ycq1QjcEjdt3BdAlSmprqkST87DvkZHvW6
 ZST12Yx3Rb0hndsh0l00CBau1Cf/oUxPDSegLM2wOvjW1oZ3mmLe0HrIFVwsaRMHLtrL
 y3EQDmTJY3lxI8pEKjhAA6jzzy6MwcCmS+GPtwseWuLaLEnXfYr7xFTByvjD01hW8yUn
 S12b0kRAP1CFSiKlwbTKv522AqxGPAVXHH8FQa97RDrW6lN1ipc+585tSMIzHup4aeoq
 bLHoC1L2d8tR/2XjckmTJfAB2Ip64/EXbwM+aGRIlTpnRSysscymNoa3RnH8fsebos5U
 2lXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=NP9OIn8aZdjTBigvGWGYSxvnTPBy4fLFwfAKc1uTAGA=;
 b=ixk/2hRTu8pv0k3ftj77d9PmDZJ7gEueBPhdRKq0ZXFZquTt6CGlc/W4Y+2cJtX1Yp
 KfjGxpkKdQKuLIWsrmg7PuyxWNSdnTZCJ98+7Uum3j1DuOmfNYFwfLjUTqHqq/Vplrnx
 zQaqBiS8MLcagqj68Ezp532UrHPZL9RQaDW3Wo8r3UCyQVjW+fbiCx7eEbYNuJFbE11U
 Hk54ye0479GfW9DaEyvWs9od4SffVIDaA5hyxjGX9azvJ6mNddo9jF1gLtKLKnni4Ijl
 eK5wISwq+uF8MPDVvBBpEp58CIyqm6gszpFvWEnyknztIod3Pw4sMxRqkWp/3zeCZnnt
 8P9A==
X-Gm-Message-State: AGi0PuZKt29dwWVYObEwMWufnOj8Niy7yVlY3zL9YR0pcB5phy6JLDJ/
 cSBUp6X1zd6uVac8M5ZcV0917g==
X-Google-Smtp-Source: APiQypL5oOSXK6EB6pTmE0GvhZKkN9bomyS/0POUiPH8tnXR5GIsMN5uQyBtW82Y8w+DwA9j1QGpNQ==
X-Received: by 2002:adf:fcc8:: with SMTP id f8mr4780563wrs.230.1588699436552; 
 Tue, 05 May 2020 10:23:56 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:109:355c:447d:ad3d:ac5c])
 by smtp.gmail.com with ESMTPSA id t67sm5496003wmg.40.2020.05.05.10.23.55
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 05 May 2020 10:23:55 -0700 (PDT)
Date: Tue, 5 May 2020 18:23:51 +0100
From: Andrew Scull <ascull@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 03/26] KVM: arm64: Factor out stage 2 page table data
 from struct kvm
Message-ID: <20200505172351.GD237572@google.com>
References: <20200422120050.3693593-1-maz@kernel.org>
 <20200422120050.3693593-4-maz@kernel.org>
 <20200505152648.GA237572@google.com> <86pnbitka5.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <86pnbitka5.wl-maz@kernel.org>
Cc: kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
 kvmarm@lists.cs.columbia.edu, George Cherian <gcherian@marvell.com>,
 "Zengtao \(B\)" <prime.zeng@hisilicon.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Dave Martin <Dave.Martin@arm.com>, linux-arm-kernel@lists.infradead.org
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

> > > +	/* VTCR_EL2 value for this VM */
> > > +	u64    vtcr;
> > 
> > VTCR seems quite strongly tied to the MMU config. Is it not controlled
> > independently for the nested MMUs and so remains in this struct?
> 
> This particular instance of VTCR_EL2 is the host's version. Which
> means it describes the virtual HW for the EL1 guest. It constraints,
> among other things, the number of IPA bits for the guest, for example,
> and is configured by the VMM.
> 
> Once you start nesting, each vcpu has its own VTCR_EL2 which is still
> constrained by the main one (no nested guest can have a T0SZ bigger
> than the value imposed by userspace for this guest as a whole).
> 
> Does it make sense?

It does up to my ignorance of the spec in this regard.

Simliar to James's question, should `vtcr` live inside the mmu struct
with the top level `kvm::mmu` field containing the host's version and
the nested mmus containing the nested version of vtcr to be applied to
the vCPU? I didn't noticed there being a vtcr for the nested version in
the ~90-patch series so maybe that just isn't something that needs
thinking about?
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
