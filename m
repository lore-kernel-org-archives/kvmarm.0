Return-Path: <SRS0=60kf=LB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A03D5C47082
	for <kvmarm@archiver.kernel.org>; Mon,  7 Jun 2021 10:03:34 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0968061090
	for <kvmarm@archiver.kernel.org>; Mon,  7 Jun 2021 10:03:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0968061090
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=nuviainc.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 76C96407F4;
	Mon,  7 Jun 2021 06:03:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered)
	header.i=@nuviainc-com.20150623.gappssmtp.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id yrIbhx3Ja2Vg; Mon,  7 Jun 2021 06:03:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5DFA74B080;
	Mon,  7 Jun 2021 06:03:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A8FA4B080
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Jun 2021 05:59:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PuuiLnX8t3oP for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Jun 2021 05:59:47 -0400 (EDT)
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com
 [209.85.221.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B53B64A524
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Jun 2021 05:59:47 -0400 (EDT)
Received: by mail-wr1-f43.google.com with SMTP id a11so14997591wrt.13
 for <kvmarm@lists.cs.columbia.edu>; Mon, 07 Jun 2021 02:59:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=nuviainc-com.20150623.gappssmtp.com; s=20150623;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=p4DLt66lUCYjaFVIOgZH75INGuDN8geDg/llZgnm7Ic=;
 b=v+wDKQVWu9yMRQlxnrjcHW+YzayMQw8AKbw0Sotye6dq6Mi/XirZdCp+SVNLSNDUH6
 KnVPIi7G03WsdOSYqvHd5Qc9rE6Ecr2yquz0U/t1CxhCeMVmY7pHgQqo5UUuKnuv66yD
 3IxkiD8fgYT76I/fGm3OO6dyf8hVmZ6JUEsAxDr7wQvkbldYEDC6/ZiW9h/QUlHXjuSa
 KiSH4xUr3mQtUm9S97PATjYfHMsIZyny5eSguSytWJD1hwTV5gcNLx1Y6MeiDRiSzYLh
 /YYeUsrPtK7KK1ZWQdQmufTNGSlm2eQtRfG/TZ0qs/majukVbye/OQcd6qlqhLBo0z3g
 ySSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=p4DLt66lUCYjaFVIOgZH75INGuDN8geDg/llZgnm7Ic=;
 b=M9UdKz5e9S5XjAbLkZpjfImfooZtniU2iyKKM9BBa0xTlY10dcTLvJbk64NsJPBBgV
 x/sfLCv/Xt3Az3wIhORT7pBHauj5+jtU6BK9IYrer3CXRpikPS+7Sl2xyLgh8uHQ7dB5
 3+aLRm7HqTiv8oop100sTHSeHEw5FMqf8kTjoOg38YP0+XTMQWILwX2AnKLizGx3Um4F
 WKTrcJFREZh8mE4nKHoeXDgt5QQzNX/28OpbIAdG8IY5i4U89O4uHcL8Bs31pMugErxA
 +QK/KoOrhjYu4pD3XK2oouGoC8S0kjgpABJC2fvuZs+vc1lr9CalCchonPrNgog9U1C6
 VxJA==
X-Gm-Message-State: AOAM530r5o5tLjivJw68h20JILpfujXJ8X3/X/ClVEeK1CfCZRrRGeb2
 CsukU2nbAc67flH0gJyRejVpPA==
X-Google-Smtp-Source: ABdhPJxqSJVg78qWie75iU0nfkVmt/mrlTFme0qOfok5xe8IqNIFyAUXePcJPqifJe8VM+aT7yJP6g==
X-Received: by 2002:adf:fa88:: with SMTP id h8mr16381574wrr.364.1623059986701; 
 Mon, 07 Jun 2021 02:59:46 -0700 (PDT)
Received: from localhost ([82.44.17.50])
 by smtp.gmail.com with ESMTPSA id 89sm16240879wri.94.2021.06.07.02.59.45
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 07 Jun 2021 02:59:46 -0700 (PDT)
Date: Mon, 7 Jun 2021 10:59:45 +0100
From: Jamie Iles <jamie@nuviainc.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v4 00/66] KVM: arm64: ARMv8.3/8.4 Nested Virtualization
 support
Message-ID: <YL3uEToHum2xgyOz@hazel>
References: <20210510165920.1913477-1-maz@kernel.org> <YLh/qsmKDJ86n75w@hazel>
 <87zgw7z6j6.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87zgw7z6j6.wl-maz@kernel.org>
X-Mailman-Approved-At: Mon, 07 Jun 2021 06:03:27 -0400
Cc: kernel-team@android.com, kvm@vger.kernel.org,
 Andre Przywara <andre.przywara@arm.com>, Jamie Iles <jamie@nuviainc.com>,
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

On Thu, Jun 03, 2021 at 09:39:09AM +0100, Marc Zyngier wrote:
> Hi Jamie,
> 
> Funny, your email has a "Mail-Followup-To:" field that contains
> everyone but you... Not ideal! ;-)

Oops, new mutt config, thanks.

> On Thu, 03 Jun 2021 08:07:22 +0100,
> Jamie Iles <jamie@nuviainc.com> wrote:
> > 
> > Hi Marc,
> > 
> > On Mon, May 10, 2021 at 05:58:14PM +0100, Marc Zyngier wrote:
> > > Here the bi-annual drop of the KVM/arm64 NV support code.
> > > 
> > > Not a lot has changed since [1], except for a discovery mechanism for
> > > the EL2 support, some tidying up in the idreg emulation, dropping RMR
> > > support, and a rebase on top of 5.13-rc1.
> > > 
> > > As usual, blame me for any bug, and nobody else.
> > > 
> > > It is still massively painful to run on the FVP, but if you have a
> > > Neoverse V1 or N2 system that is collecting dust, I have the right
> > > stuff to keep it busy!
> > 
> > I've been testing this series on FVP and get a crash when returning from 
> > __kvm_vcpu_run_vhe because the autiasp is failing.
> 
> Ah, the joy of testing with older guests. I guess i should upgrade by
> test rig and play with some newer guests at L1.
> 
> > 
> > The problem is when the L1 boots and during EL2 setup sets hcr_el2 to 
> > HCR_HOST_NVHE_FLAGS and so enables HCR_APK|HCR_API.  Then the guest 
> > enter+exit logic in L0 starts performing the key save restore, but as we 
> > didn't go through __hyp_handle_ptrauth, we haven't saved the host keys 
> > and invoked vcpu_ptrauth_enable() so restore the host keys back to 0.
> > 
> > I wonder if the pointer auth keys should be saved+restored 
> > unconditionally for a guest when running nested rather than the lazy 
> > faulting that we have today?
> 
> I'd like to try and avoid that in order to keep the basic logic as
> simple as possible for the time being, and as close to the tried and
> trusted flow we have today.
> 
> > Alternatively we would need to duplicate
> > the lazy logic for hcr_el2 writes.  A quick hack of saving the host keys 
> > in __kvm_vcpu_run_vhe before sysreg_save_host_state_vhe is enough to 
> > allow me to boot an L1 with --nested and then an L2.
> >
> > Do we also need to filter out HCR_APK|HCR_API for hcr_el2 writes when 
> > pointer authentication hasn't been exposed to the guest?  I haven't yet 
> > tried making ptrauth visible to the L1.
> 
> I think this is the real thing. We should never propagate trap bits
> for features we don't want to support in guests. The L1 kernel sets
> these bits unconditionally, despite PtrAuth never being advertised,
> which trips the host code.
> 
> Could you try the untested hack below?

That fixes the issue that I was seeing, lgtm.

Thanks Marc!

Jamie
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
