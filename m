Return-Path: <SRS0=/ADY=3Z=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAC6BC35247
	for <kvmarm@archiver.kernel.org>; Wed,  5 Feb 2020 17:12:49 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 900B2217BA
	for <kvmarm@archiver.kernel.org>; Wed,  5 Feb 2020 17:12:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gmwLCuBR"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 900B2217BA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3086E4A418;
	Wed,  5 Feb 2020 12:12:49 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Gu1VrkXn+dX0; Wed,  5 Feb 2020 12:12:48 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 247D14A578;
	Wed,  5 Feb 2020 12:12:48 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AD36C4A52E
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Feb 2020 10:47:20 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Hi5wUZZc1Knq for <kvmarm@lists.cs.columbia.edu>;
 Wed,  5 Feb 2020 10:47:19 -0500 (EST)
Received: from us-smtp-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [205.139.110.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AE3164A418
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Feb 2020 10:47:19 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1580917639;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=oFsmPcTmpKK74hHiUMCVVaDBnbXf1XdgHTJLxT7DmFI=;
 b=gmwLCuBRA2tD1K84xlyOZUMTZIKbncjBcUR2asJ7e2WIJ2KdAzgc+6azV75l+ZFrhBRJ2q
 BR9aik8zQhHFtJvIua+8gDedIycUR06/cdwREx2Xni2BDSJevzzGMHiguonneF1yP8bIp0
 EVotCPSNiYxTf6cIVYsmyNzN4carqUw=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-358-HNHn0V4LPviou4l41dYIdg-1; Wed, 05 Feb 2020 10:47:02 -0500
Received: by mail-qk1-f198.google.com with SMTP id a6so1547283qkl.7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 05 Feb 2020 07:47:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=7nlVGeHpp9SUIG8wrpMffu8Rdrv8R00fvHa/mYaOU0g=;
 b=RDE2kXGFZtFrHd8+2vYzfiUETcnYaNJM/vtM/yUKzAvc2tESUyPHVnGqQzL/gi3uvZ
 +cqvsBOOUtch0DpUQ135MEt32mehCuhvAvzVQcAZLojQEDpbyIsjZNN5aEMPzG0oDObI
 56WE18xsJqdr7aWgJ874JTef+50gk6Jw92hclJ8BDTwCBch8c8ojXCSO65BVHBUUcsiM
 42BODOxLVdhDqiAfLRgKeOU9yLPm+GkIFNwOiALXDc1rP1u2V1Htb7RZwgCg18FZJL2z
 /E6WN7aDjXJYDvKkByXctLBJpenu7705/wvxQmwNLMxasgUfUSGxMFyzLBkcvoWl28Qo
 eZgA==
X-Gm-Message-State: APjAAAUuDO8PgHqv53U8x4aeH9ssH0ZDLI+7VxMbXBJlYQCaq1Zfxd2E
 M7Pvz/HWWg2/7SUYeiVbyQA5HScxoebhcHwmq42xXFhkQ76kiXcwG3CzhdSoo7wivx1qr3MK/xy
 5N9+1c2/yRBqaBU3G0zgCWthl
X-Received: by 2002:ac8:43c1:: with SMTP id w1mr33141980qtn.156.1580917622333; 
 Wed, 05 Feb 2020 07:47:02 -0800 (PST)
X-Google-Smtp-Source: APXvYqyR3gtl04B5/ivAmSsxK+0IHBbTQlobHqHrH3aYmEjs8G/RJ/srgXoWDoXwLSsFiE3ITI4dCw==
X-Received: by 2002:ac8:43c1:: with SMTP id w1mr33141949qtn.156.1580917622035; 
 Wed, 05 Feb 2020 07:47:02 -0800 (PST)
Received: from dev.jcline.org ([136.56.87.133])
 by smtp.gmail.com with ESMTPSA id h7sm6394qke.30.2020.02.05.07.47.01
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 05 Feb 2020 07:47:01 -0800 (PST)
Date: Wed, 5 Feb 2020 10:46:59 -0500
From: Jeremy Cline <jcline@redhat.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH] KVM: arm/arm64: Fix up includes for trace.h
Message-ID: <20200205154659.GA83976@dev.jcline.org>
References: <20200205134146.82678-1-jcline@redhat.com>
 <e3446187abb20eb2a95eae1f51b36ca1@kernel.org>
MIME-Version: 1.0
In-Reply-To: <e3446187abb20eb2a95eae1f51b36ca1@kernel.org>
X-MC-Unique: HNHn0V4LPviou4l41dYIdg-1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
X-Mailman-Approved-At: Wed, 05 Feb 2020 12:12:47 -0500
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

On Wed, Feb 05, 2020 at 03:18:05PM +0000, Marc Zyngier wrote:
> On 2020-02-05 13:41, Jeremy Cline wrote:
> > Fedora kernel builds on armv7hl began failing recently because
> > kvm_arm_exception_type and kvm_arm_exception_class were undeclared in
> > trace.h. Add the missing include.
> > 
> > Signed-off-by: Jeremy Cline <jcline@redhat.com>
> > ---
> > 
> > I've not dug very deeply into what exactly changed between commit
> > b3a608222336 (the last build that succeeded) and commit 14cd0bd04907,
> > but my guess was commit 0e20f5e25556 ("KVM: arm/arm64: Cleanup MMIO
> > handling").
> > 
> > Fedora's build config is available at
> > https://src.fedoraproject.org/rpms/kernel/blob/master/f/kernel-armv7hl-fedora.config
> 
> This config doesn't have KVM enabled.
> 

Whoops, I did indeed mean
https://src.fedoraproject.org/rpms/kernel/blob/master/f/kernel-armv7hl-lpae-fedora.config.
Sorry about that.

> > 
> >  virt/kvm/arm/trace.h | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/virt/kvm/arm/trace.h b/virt/kvm/arm/trace.h
> > index 204d210d01c2..cc94ccc68821 100644
> > --- a/virt/kvm/arm/trace.h
> > +++ b/virt/kvm/arm/trace.h
> > @@ -4,6 +4,7 @@
> > 
> >  #include <kvm/arm_arch_timer.h>
> >  #include <linux/tracepoint.h>
> > +#include <asm/kvm_arm.h>
> > 
> >  #undef TRACE_SYSTEM
> >  #define TRACE_SYSTEM kvm
> 
> After enabling KVM in the above config (which requires LPAE), I've managed
> to reproduce
> the problem.
> 
> Fix now queued, thanks.
> 

Thanks!

- Jeremy

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
