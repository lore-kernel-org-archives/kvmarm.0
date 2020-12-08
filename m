Return-Path: <SRS0=0wdR=FM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.7 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FSL_HELO_FAKE,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B572C433FE
	for <kvmarm@archiver.kernel.org>; Tue,  8 Dec 2020 19:14:55 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7B82123B6E
	for <kvmarm@archiver.kernel.org>; Tue,  8 Dec 2020 19:14:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7B82123B6E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B01B14B134;
	Tue,  8 Dec 2020 14:14:53 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gj-c4yERU+oW; Tue,  8 Dec 2020 14:14:52 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 93E404B2A6;
	Tue,  8 Dec 2020 14:14:52 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DE6324B14B
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Dec 2020 14:14:50 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7CvYXEmA-8bn for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Dec 2020 14:14:50 -0500 (EST)
Received: from mail-wr1-f66.google.com (mail-wr1-f66.google.com
 [209.85.221.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D32334B134
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Dec 2020 14:14:49 -0500 (EST)
Received: by mail-wr1-f66.google.com with SMTP id x6so13459573wro.11
 for <kvmarm@lists.cs.columbia.edu>; Tue, 08 Dec 2020 11:14:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=REHA7EmuVy2412k5JBZlHnXSXCITuu5RQOyBaXf28o8=;
 b=DgXW4UZBGLPpi3lT4JKM6pKgI6mSt/dk7wglJitvXIYua+es3r0i9AvLN/NQeGaP5U
 0o39PUgticPGXS/fYZNwS8crslfcVJzP5XqpbflzbNi1WIPQQkwrD8L+PyURTqOQpZXK
 juYMowq4SdzpKYgYEWh9mjAqdMeSmT5AuzeomKp9OBkSwKn/nhgrCcRcloOpBNFyF+LS
 F7QTMAtYzWvCBhMO17hlxIie6tINGAutTZqZ+iA69roa3OxdwFqTXq3aWTLNOU3Nf25h
 h+HiI5SvMkOHNJE2debg9Vgm+45pfSNQ7dCEr+eKCAP0z5nl66gJpg6Khb1Qiev3/hZh
 EtJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=REHA7EmuVy2412k5JBZlHnXSXCITuu5RQOyBaXf28o8=;
 b=fGF5DKmyoDMJ1rbKlagjPmmLdIgrsHMYOo1yOa4jMkJuPvt491fVwQOcsD8xhWyWuN
 kDtR+sJYItGY7AoPwEPt9P4iG+YNy8AcZF0j3uy5h5hxmpHvZxYpSweA//LknR3SB34u
 0vdi7dDbKAW9fxT7sHVix2nzFzpfn2P/BwZj0OQKtxy9qnVvJx0MztcmTmiFO8c1eWZ2
 79i7n2GJNVQYIFoPVePdyKZwSo9fiJctscEa9dJlUG9NdamusbMje0vv1EYEg7xWGo7T
 u6sHpKf72l57jL3f0EFUBBvc5kXfQvycKRlsB1klkK91iQpLRxgWAOBF1IjU9OXhRuaT
 SqHg==
X-Gm-Message-State: AOAM533BoFwTUnExJUuRhxFDTru2h7vUt6/E0hXH10V0JIHMIG6X2hSD
 ZHDn6D4Elalvr59wJipPBX/GMA==
X-Google-Smtp-Source: ABdhPJzMvjijXhKf6UwzlQgGLdXNiyElYjmteXjfB+clUMsCI8Qf7bumNkex70eiOtelbQWNt3aQ2A==
X-Received: by 2002:a5d:51d2:: with SMTP id n18mr19894485wrv.92.1607454888755; 
 Tue, 08 Dec 2020 11:14:48 -0800 (PST)
Received: from google.com ([2a01:4b00:8523:2d03:258e:cb26:cef:a620])
 by smtp.gmail.com with ESMTPSA id i16sm2846391wrx.89.2020.12.08.11.14.47
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 08 Dec 2020 11:14:47 -0800 (PST)
Date: Tue, 8 Dec 2020 19:14:47 +0000
From: David Brazdil <dbrazdil@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v4 00/26] Opt-in always-on nVHE hypervisor
Message-ID: <20201208191447.47idqf7n2v3hvrdg@google.com>
References: <20201202184122.26046-1-dbrazdil@google.com>
 <160702322202.1501317.9696987088711766533.b4-ty@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <160702322202.1501317.9696987088711766533.b4-ty@kernel.org>
Cc: Christoph Lameter <cl@linux.com>,
 Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, linux-doc@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>, Jonathan Corbet <corbet@lwn.net>,
 linux-kernel@vger.kernel.org, Sudeep Holla <sudeep.holla@arm.com>,
 Tejun Heo <tj@kernel.org>, Dennis Zhou <dennis@kernel.org>,
 kernel-team@android.com, Will Deacon <will@kernel.org>,
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

Hey Marc,

On Thu, Dec 03, 2020 at 07:23:19PM +0000, Marc Zyngier wrote:
> On Wed, 2 Dec 2020 18:40:56 +0000, David Brazdil wrote:
> > As we progress towards being able to keep guest state private to the
> > host running nVHE hypervisor, this series allows the hypervisor to
> > install itself on newly booted CPUs before the host is allowed to run
> > on them.
> > 
> > All functionality described below is opt-in, guarded by an early param
> > 'kvm-arm.mode=protected'. Future patches specific to the new protected
> > mode should be hidden behind the same param.
> > 
> > [...]
> 
> Applied to kvm-arm64/psci-relay, thanks!
> 
> Note that although I pushed it to -next, I still need people to
> eyeball it and give it some Acks. The commit-IDs below will
> thus change as I apply tags, if any.
> 

I'm looking at -next and I think the merge with Mark Rutland's el2_setup
refactor didn't go as planned.

The `#ifdef CONFIG_ARM64_VHE` section needs to cover everything between
init_el2 and init_el2_nvhe. Currently the code falls through into VHE init
when CONFIG_ARM64_VHE is not set.

Here's the snippet:

SYM_INNER_LABEL(init_el2, SYM_L_LOCAL)
#ifdef CONFIG_ARM64_VHE
	/*
	 * Check for VHE being present. x2 being non-zero indicates that we
	 * do have VHE, and that the kernel is intended to run at EL2.
	 */
	mrs	x2, id_aa64mmfr1_el1
	ubfx	x2, x2, #ID_AA64MMFR1_VHE_SHIFT, #4
	cbz	x2, init_el2_nvhe
#endif						// <--- THIS

	<... initialize VHE ...>
	msr	elr_el2, lr
	mov	w0, #BOOT_CPU_MODE_EL2
	eret
						// <--- NEEDS TO MOVE HERE
SYM_INNER_LABEL(init_el2_nvhe, SYM_L_LOCAL)
	<... initialize nVHE ...>

-David

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
