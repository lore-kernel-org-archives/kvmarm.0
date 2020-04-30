Return-Path: <SRS0=Ot4E=6O=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D9EAC8300B
	for <kvmarm@archiver.kernel.org>; Thu, 30 Apr 2020 09:27:09 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DCCB22173E
	for <kvmarm@archiver.kernel.org>; Thu, 30 Apr 2020 09:27:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="sev0RdWr"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DCCB22173E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 53E934B39A;
	Thu, 30 Apr 2020 05:27:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ifx4d0+s+UVT; Thu, 30 Apr 2020 05:27:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4BA324B38D;
	Thu, 30 Apr 2020 05:27:07 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2612F4B38D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Apr 2020 05:27:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZG+rZFH7vti4 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Apr 2020 05:27:05 -0400 (EDT)
Received: from mail-wr1-f67.google.com (mail-wr1-f67.google.com
 [209.85.221.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E08744B24D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Apr 2020 05:27:04 -0400 (EDT)
Received: by mail-wr1-f67.google.com with SMTP id d15so5999665wrx.3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Apr 2020 02:27:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=USjIGVhWOh7s7FNpGRPObIs3K/tQd5FXhV8J+B/lAQk=;
 b=sev0RdWrDsI1k4SKZ2ClO+eqqDlLSi/X3Hq0Hwm6NuW4/E6/aLIqyMzcZvqhZR+J6c
 eUIxWtZR77N0Pv0Y4R55NsjIra2VIWrslAhrIuH8cj2aH2FILfWnwTBDEmoP6X8xpHGr
 +pMIL/nORGtb23Q7Gqw1TB/rFmceMz+uJjfFgyg1sCEq2z+mKuKq4qZ1Ag1RY1dNnLkW
 Iu9WJ/r57i1hI3vsLD5RojTkpnMVzKno357mok+W7VqLE1DFmANm0WRM7Vbj7N9jd3oV
 yid5orRXgtJKlQQXUA728cybZ6Yb6/ifuOSzoo44eK4HoAM1FYIWrV3cWUh97laqY/wV
 cD6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=USjIGVhWOh7s7FNpGRPObIs3K/tQd5FXhV8J+B/lAQk=;
 b=UAklo3AzR1GT34rS9bdqRQtjQhBLm6RnI1lTT1QtRfATbMRAlxThEEYjBfX/ObqieS
 zWBCYCsFtryrzhULGpDF3Km/lRVAhX2JAJiU8zaV790JVC/NuWlWGO1Ak/skpjzqoAjX
 gUkpBSeOq2IH+VN2UytO9JytAQPm65T1QKuxYeBPI3P6Gsyp59wnBlbLeXIjRmtI03y8
 G2b0QPspYlciDBTkJP8so8UVK+TIdIVIiJOLq0F/f9Bequ1Thqm+FlG0NPpb69dHjqkH
 B85+ZdQR9C5D5bXRDPCSBfn9V08oly16af5Ju4rC8aWyNRVfGZGGpTCNMtvpa4weWxqv
 ERVQ==
X-Gm-Message-State: AGi0Pub1JHmbxyPbZqd3Fp1YP45YdlscYyDTEQPXGOzh3iqM42sYJXag
 y89vKyy4XlzWWQkuq+t0hW32Rw==
X-Google-Smtp-Source: APiQypJ/7f3QnMFmCrai7poM2/q9I4XlvyLP2DcEusXJJVO9kgxdMGnvXsEUZaGfBg2W8rHlAmov6A==
X-Received: by 2002:adf:cc8d:: with SMTP id p13mr3124810wrj.114.1588238823516; 
 Thu, 30 Apr 2020 02:27:03 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:109:355c:447d:ad3d:ac5c])
 by smtp.gmail.com with ESMTPSA id q10sm3158515wrv.95.2020.04.30.02.27.02
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 30 Apr 2020 02:27:02 -0700 (PDT)
Date: Thu, 30 Apr 2020 10:26:58 +0100
From: Andrew Scull <ascull@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2] arm64: Unify WORKAROUND_SPECULATIVE_AT_{NVHE,VHE}
Message-ID: <20200430092658.GF15669@google.com>
References: <20200422161346.67325-1-ascull@google.com>
 <20200429212120.GC8604@willie-the-truck>
 <5f391a75142a8ae2263e52d37d73526d@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5f391a75142a8ae2263e52d37d73526d@kernel.org>
Cc: Steven Price <steven.price@arm.com>, Will Deacon <will@kernel.org>,
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

On Thu, Apr 30, 2020 at 10:16:03AM +0100, Marc Zyngier wrote:
> On 2020-04-29 22:21, Will Deacon wrote:
> > Hi Andrew,
> > 
> > On Wed, Apr 22, 2020 at 05:13:46PM +0100, Andrew Scull wrote:
> > > Errata 1165522, 1319367 and 1530923 each allow TLB entries to be
> > > allocated as a result of a speculative AT instruction. In order to
> > > avoid mandating VHE on certain affected CPUs, apply the workaround to
> > > both the nVHE and the VHE case for all affected CPUs.
> > > 
> > > Signed-off-by: Andrew Scull <ascull@google.com>
> > > CC: Marc Zyngier <maz@kernel.org>
> > > CC: James Morse <james.morse@arm.com>
> > > CC: Suzuki K Poulose <suzuki.poulose@arm.com>
> > > CC: Will Deacon <will@kernel.org>
> > > CC: Steven Price <steven.price@arm.com>
> > > ---
> > > * From v1 <20200327143941.195626-1-ascull@google.com>:
> > >   - Restored registers in VHE path
> > 
> > This largely looks good to me, but I don't understand these bits:
> > 
> > > diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> > > index 8a1e81a400e0..651820f537fb 100644
> > > --- a/arch/arm64/kvm/hyp/switch.c
> > > +++ b/arch/arm64/kvm/hyp/switch.c
> > > @@ -138,7 +138,7 @@ static void __hyp_text
> > > __activate_traps_nvhe(struct kvm_vcpu *vcpu)
> > > 
> > >  	write_sysreg(val, cptr_el2);
> > > 
> > > -	if (cpus_have_final_cap(ARM64_WORKAROUND_SPECULATIVE_AT_NVHE)) {
> > > +	if (cpus_have_const_cap(ARM64_WORKAROUND_SPECULATIVE_AT)) {
> > 
> > It seems like you consistently replace cpus_have_final_cap() with
> > cpus_have_const_cap(), but I can't figure out why that's required.
> 
> Seems like a bad conflict resolution. We definitely want to keep the
> final_cap checks for anything that will run at EL2, and probably
> everywhere else (if capabilities are not final by the time we hit KVM,
> we have bigger problems to solve).
> 
> Thanks,
> 
>         M.
> -- 
> Jazz is not dead. It just smells funny...

Indeed, those weren't the 5 characters my eye was interested in. Looks
like we'll be having a v3..
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
