Return-Path: <SRS0=e8LN=FA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,FSL_HELO_FAKE,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E09D4C56202
	for <kvmarm@archiver.kernel.org>; Thu, 26 Nov 2020 17:29:38 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5415C21D91
	for <kvmarm@archiver.kernel.org>; Thu, 26 Nov 2020 17:29:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="OTwG7pth"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5415C21D91
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DD79F4C077;
	Thu, 26 Nov 2020 12:29:37 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id C9+2IXJ7r+M2; Thu, 26 Nov 2020 12:29:36 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B6DE44C066;
	Thu, 26 Nov 2020 12:29:36 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C3E754BEA6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Nov 2020 12:29:34 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BG8+lFi94OBq for <kvmarm@lists.cs.columbia.edu>;
 Thu, 26 Nov 2020 12:29:33 -0500 (EST)
Received: from mail-wm1-f67.google.com (mail-wm1-f67.google.com
 [209.85.128.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9F7224BEA3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Nov 2020 12:29:33 -0500 (EST)
Received: by mail-wm1-f67.google.com with SMTP id a3so3140779wmb.5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Nov 2020 09:29:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=eNmmYIntQD41kP5Sy+k/QWgGU3OC7ECA76To2f6sO84=;
 b=OTwG7pthwmbnQa4O4pEKQm3r7t+DfZH8/A814vskFeIwb1FswL2ou7mn064m+b6JOW
 ATuWhxu9ybb+JUMtcNuHn9iSPGGKMpNnuEvEaS18eW3zmdEEu55d6WTGi+7xbSMgFQWp
 EAe58Ogmc6EQdiNxH5da82B8tRgtKqIKsJQ4UgW/7kqj5a6FUqk0iqGtQnHOdRj/rJLI
 74XACjmqHWKIsHrhYhyE9sV6/lq+bvG/IH/hWft2e+793kU22Nu/UEN/rrbVQK6wZ+3m
 fqp/0IH4Z77e15TKRtrkLfcPNbbvcsWtK3G4DfrNsxurhbPDGuxcE766h35FrLx42G5m
 jhHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=eNmmYIntQD41kP5Sy+k/QWgGU3OC7ECA76To2f6sO84=;
 b=Fqcc3zXFG+NswJoviHuxkLTPbaOGO2SkQFcUNeBF8AnLWtCZHxfKrk0iFvJWfxSIgS
 zpvHQVQVzLLsXWSdaiCaD87+R78EqI1x2tAMYwYwwIUI93dnuOZuF1XPkP6rFB6NYRfz
 pQajS4TwePBeMupC8+aoV7Ubb2mg3rE7eWzYXgiNAwLP0KYx2XHBTfnBadq/NUvAy387
 MUs3sT5UrUwm+bCxYkmcRJ0OvgnGjy9lSfaHwrZGT2NK4EkDexvbp/h2C6MSXBIuyeP4
 kuiPY7FGNc5OXFzFUfBv+S4RVgKMpBOMweEvNu33XqjJJOKSX4vfZpNIF7+gCVhizzHp
 XDKg==
X-Gm-Message-State: AOAM532qAT6ly2T3vQlJACFW5t938A0GmzILb5FBG97u18LpWCC2OubR
 HX9KIdhQSHuLvE96DM6ruxbmLg==
X-Google-Smtp-Source: ABdhPJza6j04qFmVsjgAU43nbnlurhLEdweYclMbOSTmqBBsojLWwg3BqabR7gpjOx4N8c/OCFiJaA==
X-Received: by 2002:a7b:c319:: with SMTP id k25mr4627247wmj.65.1606411772607; 
 Thu, 26 Nov 2020 09:29:32 -0800 (PST)
Received: from google.com ([2a01:4b00:8523:2d03:4ca8:e54e:96f6:f182])
 by smtp.gmail.com with ESMTPSA id c64sm9074091wmd.41.2020.11.26.09.29.31
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 26 Nov 2020 09:29:31 -0800 (PST)
Date: Thu, 26 Nov 2020 17:29:30 +0000
From: David Brazdil <dbrazdil@google.com>
To: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v3 02/23] psci: Accessor for configured PSCI function IDs
Message-ID: <20201126172930.i63yemxpc5r3mqpq@google.com>
References: <20201126155421.14901-1-dbrazdil@google.com>
 <20201126155421.14901-3-dbrazdil@google.com>
 <20201126172450.GC38486@C02TD0UTHF1T.local>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20201126172450.GC38486@C02TD0UTHF1T.local>
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, kernel-team@android.com,
 Jonathan Corbet <corbet@lwn.net>, Catalin Marinas <catalin.marinas@arm.com>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 Sudeep Holla <sudeep.holla@arm.com>, linux-arm-kernel@lists.infradead.org,
 Marc Zyngier <maz@kernel.org>, Tejun Heo <tj@kernel.org>,
 Dennis Zhou <dennis@kernel.org>, Christoph Lameter <cl@linux.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu
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

Hey Mark,

On Thu, Nov 26, 2020 at 05:24:50PM +0000, Mark Rutland wrote:
> On Thu, Nov 26, 2020 at 03:54:00PM +0000, David Brazdil wrote:
> > Function IDs used by PSCI are configurable for v0.1 via DT/APCI. If the
> > host is using PSCI v0.1, KVM's host PSCI proxy needs to use the same IDs.
> > Expose the array holding the information with a read-only accessor.
> > 
> > Signed-off-by: David Brazdil <dbrazdil@google.com>
> > ---
> >  drivers/firmware/psci/psci.c | 16 ++++++++--------
> >  include/linux/psci.h         | 10 ++++++++++
> >  2 files changed, 18 insertions(+), 8 deletions(-)
> > 
> > diff --git a/drivers/firmware/psci/psci.c b/drivers/firmware/psci/psci.c
> > index 213c68418a65..40609564595e 100644
> > --- a/drivers/firmware/psci/psci.c
> > +++ b/drivers/firmware/psci/psci.c
> > @@ -58,16 +58,16 @@ typedef unsigned long (psci_fn)(unsigned long, unsigned long,
> >  				unsigned long, unsigned long);
> >  static psci_fn *invoke_psci_fn;
> >  
> > -enum psci_function {
> > -	PSCI_FN_CPU_SUSPEND,
> > -	PSCI_FN_CPU_ON,
> > -	PSCI_FN_CPU_OFF,
> > -	PSCI_FN_MIGRATE,
> > -	PSCI_FN_MAX,
> > -};
> > -
> >  static u32 psci_function_id[PSCI_FN_MAX];
> >  
> > +u32 psci_get_function_id(enum psci_function fn)
> > +{
> > +	if (WARN_ON_ONCE(fn < 0 || fn >= PSCI_FN_MAX))
> > +		return 0;
> > +
> > +	return psci_function_id[fn];
> > +}
> 
> I'd really like if we could namespace this with a psci_0_1_* prefix
> before we expose it outside of the PSCI code. I appreciate that's a
> larger change, but I reckon we only need a couple of new patches:
> 
> 1) Split the ops which consume the FN ids into separate psci_0_1_*() and
>    psci_0_2_*() variants, with a common __psci_*() helper that takes the
>    function ID as an argument. The 0_1 variants would read the function
>    ID from a variable, and the 0_2 variants would hard-code the id.
> 
> 2) Replace the psci_function_id array with:
> 
>    struct psci_0_1_function_ids {
>    	u32 suspend;
>    	u32 cpu_on;
>    	u32 cpu_off;
>    	u32 migrate;
>    };
> 
>    ... and remove enum psci_function entirely.
> 
> 3) Add a helper which returns the entire psci_0_1_function_ids struct in
>    one go. No warnings necessary.
> 
> Does that sound OK to you?

Sure, sounds easy enough and 2) is in line with how I structured the handlers
in KVM.

Thanks,
David
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
