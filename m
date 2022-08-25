Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F58DECAA25
	for <kvmarm@archiver.kernel.org>; Thu, 25 Aug 2022 16:53:04 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0BA1D4EA87;
	Thu, 25 Aug 2022 12:53:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id n9ZOj8UCmDme; Thu, 25 Aug 2022 12:53:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BB2AA4EA83;
	Thu, 25 Aug 2022 12:53:02 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B15614EA7D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Aug 2022 12:53:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SMUAyKUz5jzQ for <kvmarm@lists.cs.columbia.edu>;
 Thu, 25 Aug 2022 12:52:59 -0400 (EDT)
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com
 [209.85.210.169])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 58EA34E4CF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Aug 2022 12:52:59 -0400 (EDT)
Received: by mail-pf1-f169.google.com with SMTP id x15so19459762pfp.4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Aug 2022 09:52:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc;
 bh=vJj32hJvJGqkLqOH+3ra6D6nxOVq8DAl1sAc3dJpCjQ=;
 b=A1nxbuvolMJoJdVb4d2CeQ4deHP4rqOZs/TGKqEa/qgD20Q02IBCEc7eW+rStkj5K0
 D21GMCjOP5e+syC4ioQV2krjxXU3tlECG79YnCr/mqa7dW1y3k6V1iF+pKdPw3gs9jc3
 RPbmWLoQnxwHxEo4e0ueRPrkmNH9MZX/WT83UdZl0/xKtVmHzW/B/PsoXYeF71v6DW1Q
 SLQO+5avsNIKeAMF+hneHrKaaHt8oP/WjoFWKerxjct5NLGVqO0os2PrCDr5xMFGqFkC
 KmZGD2U9lEFfXh/XMifNiI/81vv/RCaPOyyGHwkg5quLecKl7Enr21eRs/2f7LYv4vGN
 9NAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
 bh=vJj32hJvJGqkLqOH+3ra6D6nxOVq8DAl1sAc3dJpCjQ=;
 b=Ei2lZPUaQ6X91eU9a43fM0lUIwrX5s3IqGsbPN4HAcxhIpImhJuE/6igvDxHQqWvTF
 hMumE0lenn0BXcHxSe07Jtk1Prc9xvUUdlhLKDOjZcPrco0oq8BySo8jnPn1Pr3mfcE3
 O2k+vvsZY1j+KPh1Q/lxnDySxtsB7NpIDBY/kuyOIjTRUDC5PIQQnHsoOSHrestu7J+u
 pfmnpNhqTTJOEyqkeXI+MvDQoDX1HcLrmLRop3auzgBUXEvndFEOTlGkS9FGXrN54xMs
 A5r0odmauKi/pTlPyc1GA4wBILHLrGLSXYEtV31dxCN80ISP+XtbMOIyYBCOdyyGnP7s
 7qxA==
X-Gm-Message-State: ACgBeo1orVsktM7BSf4MjdQGzte8OGsDOoYLhXdDjOmjro5YPAPNuVSR
 w6dnkiGbEIbVLEN4DiJeUSkGOQ==
X-Google-Smtp-Source: AA6agR5NVWXmyuXOgXsVmLZCpYheZR95GpW+RbkOLt2FXFMx1LD4VylP1CW8x/Hy3QYEIDM/dHONMw==
X-Received: by 2002:a63:e74d:0:b0:429:ead9:a350 with SMTP id
 j13-20020a63e74d000000b00429ead9a350mr30400pgk.194.1661446377961; 
 Thu, 25 Aug 2022 09:52:57 -0700 (PDT)
Received: from google.com (220.181.82.34.bc.googleusercontent.com.
 [34.82.181.220]) by smtp.gmail.com with ESMTPSA id
 j125-20020a625583000000b00535fd3290f0sm13789154pfb.113.2022.08.25.09.52.56
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 25 Aug 2022 09:52:56 -0700 (PDT)
Date: Thu, 25 Aug 2022 09:52:53 -0700
From: Ricardo Koller <ricarkol@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [PATCH 1/9] KVM: arm64: selftests: Add helpers to extract a
 field of an ID register
Message-ID: <Yweo5cmA6D0pxwmJ@google.com>
References: <20220825050846.3418868-1-reijiw@google.com>
 <20220825050846.3418868-2-reijiw@google.com>
 <Ywen44OKe8gGcOcW@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <Ywen44OKe8gGcOcW@google.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Andrew Jones <andrew.jones@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On Thu, Aug 25, 2022 at 09:48:35AM -0700, Oliver Upton wrote:
> Hi Reiji,
> 
> On Wed, Aug 24, 2022 at 10:08:38PM -0700, Reiji Watanabe wrote:
> > Introduce helpers to extract a field of an ID register.
> > Subsequent patches will use those helpers.
> > 
> > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > ---
> >  .../selftests/kvm/include/aarch64/processor.h     |  2 ++
> >  .../testing/selftests/kvm/lib/aarch64/processor.c | 15 +++++++++++++++
> >  2 files changed, 17 insertions(+)
> > 
> > diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
> > index a8124f9dd68a..a9b4b4e0e592 100644
> > --- a/tools/testing/selftests/kvm/include/aarch64/processor.h
> > +++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
> > @@ -193,4 +193,6 @@ void smccc_hvc(uint32_t function_id, uint64_t arg0, uint64_t arg1,
> >  
> >  uint32_t guest_get_vcpuid(void);
> >  
> > +int cpuid_get_sfield(uint64_t val, int field_shift);
> > +unsigned int cpuid_get_ufield(uint64_t val, int field_shift);
> >  #endif /* SELFTEST_KVM_PROCESSOR_H */
> > diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> > index 6f5551368944..0b2ad46e7ff5 100644
> > --- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
> > +++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> > @@ -528,3 +528,18 @@ void smccc_hvc(uint32_t function_id, uint64_t arg0, uint64_t arg1,
> >  		       [arg4] "r"(arg4), [arg5] "r"(arg5), [arg6] "r"(arg6)
> >  		     : "x0", "x1", "x2", "x3", "x4", "x5", "x6", "x7");
> >  }
> > +
> > +/* Helpers to get a signed/unsigned feature field from ID register value */
> > +int cpuid_get_sfield(uint64_t val, int field_shift)
> > +{
> > +	int width = 4;
> > +
> > +	return (int64_t)(val << (64 - width - field_shift)) >> (64 - width);
> > +}
> 
> I don't believe this helper is ever used.
> 
> > +unsigned int cpuid_get_ufield(uint64_t val, int field_shift)
> > +{
> > +	int width = 4;
> > +
> > +	return (uint64_t)(val << (64 - width - field_shift)) >> (64 - width);
> > +}
> 
> I would recommend not open-coding this and instead make use of
> ARM64_FEATURE_MASK(). You could pull in linux/bitfield.h to tools, or do
> something like this:
> 
>   #define ARM64_FEATURE_GET(ftr, val)					\
>   	  	  ((ARM64_FEATURE_MASK(ftr) & val) >> ftr##_SHIFT)
> 
> Slight preference for FIELD_{GET,SET}() as it matches the field
> extraction in the kernel as well.

Was doing that with this commit:

	[PATCH v5 05/13] tools: Copy bitfield.h from the kernel sources

Maybe you could just use it given that it's already reviewed.

> 
> --
> Thanks,
> Oliver
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
