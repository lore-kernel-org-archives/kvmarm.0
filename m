Return-Path: <SRS0=s1GN=FF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A57DC64E7B
	for <kvmarm@archiver.kernel.org>; Tue,  1 Dec 2020 13:19:23 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 41103206B6
	for <kvmarm@archiver.kernel.org>; Tue,  1 Dec 2020 13:19:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="g8r5HIuJ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 41103206B6
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 783524C0E1;
	Tue,  1 Dec 2020 08:19:21 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rmbeop4QPla7; Tue,  1 Dec 2020 08:19:20 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 61E3C4BD36;
	Tue,  1 Dec 2020 08:19:20 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A82404BD0A
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Dec 2020 08:19:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Qz+wsZV+L2R1 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  1 Dec 2020 08:19:17 -0500 (EST)
Received: from mail-wr1-f66.google.com (mail-wr1-f66.google.com
 [209.85.221.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 868D74BCB7
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Dec 2020 08:19:17 -0500 (EST)
Received: by mail-wr1-f66.google.com with SMTP id s8so2557736wrw.10
 for <kvmarm@lists.cs.columbia.edu>; Tue, 01 Dec 2020 05:19:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=pffIlxOmfR0gBVuszJT4P2RM92yWm19L13Fi6KZxY80=;
 b=g8r5HIuJm61ScStvkO7mJrI+1nn38z/980CV6TzqHAnq/C/tMpn8R0PxPMpdICIKFz
 KItikUjWHc9uvevp/742fpTQlJp9GaHVv+u8IxeGH1Eb8zaqaeqs18N/qHN3tAIeTEJc
 5bJf9zmO5oXCMIOHPvTM2mV3Zv1N6PSLSx4WNifkn3wEzI5gDFJl0lMu8IyD+oq2rWnW
 b4H4Dxui2ENwK3LINaVISyu0Uu498hRHfGi7tEXFmE5oEZgj8RCFV/RP+vsy8sirzVOY
 Eq3m8ra9jGoB+/q/94NpjZJ89tvQ2zIj+da16hIfj48eqsD914RqpXmPGpGwlFLWG2CR
 ILYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=pffIlxOmfR0gBVuszJT4P2RM92yWm19L13Fi6KZxY80=;
 b=PBfz8qgsVPL0p9isko04usC17VdGKP1yCDhQEM/SsKPeu5GsqcjjgB0IWKJgrpJXry
 lh+DXGii893Sp1LiOPdFtKmnFWvg1Oe8qYJx8tj3KMSVrgYzFDfXaA5d9mxEosXn+DVa
 PqhmdgGTWCNYpPkTTKdAsVZtwJtXUsvFw+DU1nDXSDAg49oWPXM94XC0u1kV8n+HX/Mi
 tXaSjT1AwQdzMSMDQ7L4VBztbqnyyJVYKgO3asNa89STh5grbUODozYBnsYkEUvZQqW8
 WMEpYPjqsosTRIggy0BQVxcJqRqp5oWPAJ1TQdlho4PQmSYI02LaS5ikxmgoJt81vRKX
 v6kw==
X-Gm-Message-State: AOAM532hiEU9d2qO6ppahqIy79qrbks9QcTOwPYGUEr8UTe5O49Y8a13
 OsrofvISCUJKOFM/sarSkx8AkA==
X-Google-Smtp-Source: ABdhPJxNpkgurha25ZUu8Qo29Cw4yJ3wJ4kR79/690cFW6P+G6s4//zbglAbpD8RaDoVhiqxuedQsg==
X-Received: by 2002:adf:a549:: with SMTP id j9mr3894987wrb.199.1606828756387; 
 Tue, 01 Dec 2020 05:19:16 -0800 (PST)
Received: from google.com ([2a01:4b00:8523:2d03:7c5f:5ab5:ac1f:89ce])
 by smtp.gmail.com with ESMTPSA id d17sm3237705wro.62.2020.12.01.05.19.14
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 01 Dec 2020 05:19:15 -0800 (PST)
Date: Tue, 1 Dec 2020 13:19:13 +0000
From: David Brazdil <dbrazdil@google.com>
To: Sudeep Holla <sudeep.holla@arm.com>
Subject: Re: [PATCH v3 06/23] kvm: arm64: Add kvm-arm.protected early kernel
 parameter
Message-ID: <20201201131913.u7m2eifvtus74dra@google.com>
References: <20201126155421.14901-1-dbrazdil@google.com>
 <20201126155421.14901-7-dbrazdil@google.com>
 <20201127163254.zxdrszlveaxhluwn@bogus>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20201127163254.zxdrszlveaxhluwn@bogus>
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, kernel-team@android.com,
 Jonathan Corbet <corbet@lwn.net>, Catalin Marinas <catalin.marinas@arm.com>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
 Tejun Heo <tj@kernel.org>, Dennis Zhou <dennis@kernel.org>,
 Christoph Lameter <cl@linux.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu
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

Hey Sudeep,

> > diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> > index 526d65d8573a..06c89975c29c 100644
> > --- a/Documentation/admin-guide/kernel-parameters.txt
> > +++ b/Documentation/admin-guide/kernel-parameters.txt
> > @@ -2259,6 +2259,11 @@
> >  			for all guests.
> >  			Default is 1 (enabled) if in 64-bit or 32-bit PAE mode.
> >  
> > +	kvm-arm.protected=
> > +			[KVM,ARM] Allow spawning protected guests whose state
> > +			is kept private from the host. Only valid for non-VHE.
> > +			Default is 0 (disabled).
> > +
> 
> Sorry for being pedantic. Can we reword this to say valid for
> !CONFIG_ARM64_VHE ? I read this as valid only for non-VHE hardware, it may
> be just me, but if you agree please update so that it doesn't give remote
> idea that it is not valid on VHE enabled hardware.
> 
> I was trying to run this on the hardware and was trying to understand the
> details on how to do that.

I see what you're saying, but !CONFIG_ARM64_VHE isn't accurate either. The
option makes sense if:
  1) all cores booted in EL2
     == is_hyp_mode_available()
  2) ID_AA64MMFR1_EL1.VH=0 or !CONFIG_ARM64_VHE
     == !is_kernel_in_hyp_mode()

The former feels implied for KVM, the latter could be 'Valid if the kernel
is running in EL1'? WDYT?

-David
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
