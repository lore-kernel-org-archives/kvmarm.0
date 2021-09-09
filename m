Return-Path: <SRS0=OUTu=OC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C060AC433FE
	for <kvmarm@archiver.kernel.org>; Sun, 12 Sep 2021 16:33:09 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 49D3F61076
	for <kvmarm@archiver.kernel.org>; Sun, 12 Sep 2021 16:33:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 49D3F61076
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D4C0E4B1B2;
	Sun, 12 Sep 2021 12:33:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HKuUdp3733I3; Sun, 12 Sep 2021 12:33:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9CFD54B1FC;
	Sun, 12 Sep 2021 12:33:06 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 77F294B163
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Sep 2021 16:28:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JyVz4-T+y6ev for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Sep 2021 16:28:15 -0400 (EDT)
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com
 [209.85.214.175])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6B5D34B152
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Sep 2021 16:28:15 -0400 (EDT)
Received: by mail-pl1-f175.google.com with SMTP id 5so746047plo.5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 09 Sep 2021 13:28:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=KkIQUN6UVWVDGVs7gQUvenivKjOnMibWM6lN26FSefU=;
 b=FVbJMuxsPdMboW3fGRpeknq9uQRgiNFYMkfTDCp+yIJU/r8SnfixFRLOMHCuS02TXV
 RwGohEECz7j1XeRtYg7gQzlcG+vLV6rsHNncc7O4uYVacKrMziWXHeyXi3ToHSI5Krci
 dAtD/keu37A2un94zex2UJJKhbPBH+ZA+1B3gpOkZmfN9W4RivrlV4R9/tQ/9cnZUrgu
 RzQYH2dMHu7mQiJ40p9ZTab+fVOUV0+TFBglNS4NUUQKTHkf9HLIB/mCNlTcORWAPzSS
 K/4cGRMB01MOZSLT6KTLNPsQp2b002EpBhgBufLFsJW1FvkHgofIBfja7U+61OoYFw47
 vXng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=KkIQUN6UVWVDGVs7gQUvenivKjOnMibWM6lN26FSefU=;
 b=ZJ9wJoF8bGpqvpHjv442lAhLXaRpbtw3MstQu/pma/e9ASvCiD4dnDNAxzi4+yp0De
 qxtMjuxkg6h+toxZTN1l0zLFFj6E+YoACIAn3BwfRw9wdi7sJ5ZouGcnMNCAVfWdCA9s
 3acnjEHdVL8VVUHPMrwcl1f6tCArik0MbdojkjpS/Zbbvpa1CcVn9qMzlpfEVsTSphXG
 igKoNntpiTqSIJ7c7RtQaDO8qc1atgV1VGbkr4pobTNKBX70IB0JNnqrtfGlCrDvusx9
 3+rRNtdpmqRvLR9SynL1w0CBXlHmrVBNWJpIw4CZZx9Wh0psjzYl/FnO3q8c9nOd3LDk
 vJ/Q==
X-Gm-Message-State: AOAM532jjw9Eg3wCl1geCK1XsaeqYfqtdldNzaj+pRylCqf5ifsUQKYi
 SHeJKJ7PUduzs82HgDxSCETNTQ==
X-Google-Smtp-Source: ABdhPJyAc4CRr9tF0y4feLojYbdHTKlOemQgA2iiZMpEO+mvtfr+51OjqPfvtnvGWSxrmgXGK89LBw==
X-Received: by 2002:a17:90a:428e:: with SMTP id
 p14mr5632154pjg.92.1631219294432; 
 Thu, 09 Sep 2021 13:28:14 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157])
 by smtp.gmail.com with ESMTPSA id b4sm3124696pga.69.2021.09.09.13.28.13
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 09 Sep 2021 13:28:14 -0700 (PDT)
Date: Thu, 9 Sep 2021 20:28:10 +0000
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 5/6] kvm: allocate vcpu pointer array separately
Message-ID: <YTpuWl3Uhu4qpC1U@google.com>
References: <20210903130808.30142-1-jgross@suse.com>
 <20210903130808.30142-6-jgross@suse.com>
 <871r65wwk7.wl-maz@kernel.org>
 <37699e98-9a47-732d-8522-daa90f35c52f@suse.com>
 <87eea2c9zu.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87eea2c9zu.wl-maz@kernel.org>
X-Mailman-Approved-At: Sun, 12 Sep 2021 12:33:05 -0400
Cc: Juergen Gross <jgross@suse.com>, Wanpeng Li <wanpengli@tencent.com>,
 ehabkost@redhat.com, kvm@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>, Joerg Roedel <joro@8bytes.org>,
 x86@kernel.org, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 Will Deacon <will@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
 Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 Thomas Gleixner <tglx@linutronix.de>, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>
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

On Mon, Sep 06, 2021, Marc Zyngier wrote:
> On Mon, 06 Sep 2021 05:33:35 +0100,
> Juergen Gross <jgross@suse.com> wrote:
> > 
> > On 03.09.21 16:41, Marc Zyngier wrote:
> >
> > > At this stage, I really wonder why we are not using an xarray instead.
> > > 
> > > I wrote this [1] a while ago, and nothing caught fire. It was also a
> > > net deletion of code...
> > 
> > Indeed, I'd prefer that solution!
> > 
> > Are you fine with me swapping my patch with yours in the series?
> 
> Of course, feel free to grab the whole series. You'll probably need
> the initial patches to set the scene for this. On their own, they are
> a nice cleanup, and I trust you can write a decent commit message for
> the three patches affecting mips/s390/x86.

It would also be a good idea to convert kvm_for_each_vcpu() to use xa_for_each(),
I assume that's more performant than 2x atomic_read() + xa_load().  Unless I'm
misreading the code, xa_for_each() is guaranteed to iterate in ascending index
order, i.e. preserves the current vcpu0..vcpuN iteration order.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
