Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF884C433F5
	for <kvmarm@archiver.kernel.org>; Tue,  8 Feb 2022 16:58:35 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 543174B120;
	Tue,  8 Feb 2022 11:58:35 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0RFClE+b4RpW; Tue,  8 Feb 2022 11:58:33 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E4B1F4A105;
	Tue,  8 Feb 2022 11:58:33 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BB4F94A105
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Feb 2022 11:58:32 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JIyAzFDzHk31 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Feb 2022 11:58:31 -0500 (EST)
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com
 [209.85.216.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 52A2B49F5F
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Feb 2022 11:58:31 -0500 (EST)
Received: by mail-pj1-f44.google.com with SMTP id
 t14-20020a17090a3e4e00b001b8f6032d96so2241593pjm.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 08 Feb 2022 08:58:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=BehLNzAs/zQ1lF/lRFmUiYEG0MqDcTlN+Zi4GMNO4po=;
 b=gtD1WqxflWJB+W3B+2IPTB0tczwLG7fEAfX6erBc0MU5nljMZXr+E8SiEnTM4N+BFg
 RjxyhEm/cmjmv0ervzymU069H+VhD045lnQ39rcRknECCnyaucw8K93VEVf8UoKDZSew
 jdP2LEemYZcR5i2XXtiiLw/uLGKW8q/gojZST44XnLhBy+AmIOEsB1Iw9vJRMUTEWeLR
 04asKhrQVyx/py9Gao6ECyqb62nkk/SpW8Cm42Mt4FPy1xSjZMUrEsAZmNS1hS0HcFd5
 G+KT9JLD/hjAa7U929ByWGFWRp/jjxzZ8/OA5yppdq3NtjrTwzncuBmrOEXYNjpnmH68
 H4Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=BehLNzAs/zQ1lF/lRFmUiYEG0MqDcTlN+Zi4GMNO4po=;
 b=v+7tUSnM04K9x+TxU6Y85RVhxnDG71hbzwSA2iyr7D77/HyP7g1usKAHOX1u6iGFeX
 aQnf86JmK7bSQ9pVUTeVF2AglyHspV6Y+LfIfDCfDeELNiBvFVFKzYtY8N+Yw+NiSawV
 cWCk+NdD9fvXLub02iYUC29KrALBzwVZACyJzHd1Mstb1LpYDYV9xwacpkHYFc18uM+c
 ILNJI0SFCUxcxXyp2zz1M4AUaCX+LPDyR6IGtiFK5HWP1oVKi5aX8GkQjR4d5XZfnDdB
 9P9uyl4rLc5rJ10F6JT4yr6iEckbMKZ6ZPJuIQR7Hga8LWLmG3yAGOMEGkcXTd3bzWjB
 zzNw==
X-Gm-Message-State: AOAM530UpowNL7aN8952zRdzWm59WqdsRxj5+wq73/qsCAVAWc2QRwAb
 no2LRD5UhCSzY75TJWiVXfnDdw==
X-Google-Smtp-Source: ABdhPJycqIE2rS7QGrW4hrzwOVH1TbvshmoHJyww4j5tVSIRNytldRpHF1r23ExSbwF4NMrAS2Xnog==
X-Received: by 2002:a17:902:8f96:: with SMTP id
 z22mr5455290plo.2.1644339510071; 
 Tue, 08 Feb 2022 08:58:30 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157])
 by smtp.gmail.com with ESMTPSA id m20sm16957314pfk.215.2022.02.08.08.58.29
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 08 Feb 2022 08:58:29 -0800 (PST)
Date: Tue, 8 Feb 2022 16:58:26 +0000
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oupton@google.com>
Subject: Re: KVM/arm64: Guest ABI changes do not appear rollback-safe
Message-ID: <YgKhMjGtBH+1nJCk@google.com>
References: <CAOQ_Qsg2dKLLanSx6nMbC1Er9DSO3peLVEAJNvU1ZcRVmwaXgQ@mail.gmail.com>
 <87ilyitt6e.wl-maz@kernel.org>
 <CAOQ_QshfXEGL691_MOJn0YbL94fchrngP8vuFReCW-=5UQtNKQ@mail.gmail.com>
 <87lf3drmvp.wl-maz@kernel.org>
 <CAOQ_QsjVk9n7X9E76ycWBNguydPE0sVvywvKW0jJ_O58A0NJHg@mail.gmail.com>
 <CAJHc60wp4uCVQhigNrNxF3pPd_8RPHXQvK+gf7rSxCRfH6KwFg@mail.gmail.com>
 <875yq88app.wl-maz@kernel.org>
 <CAOQ_QshL2MCc8-vkYRTDhtZXug20OnMg=qedhSGDrp_VUnX+5g@mail.gmail.com>
 <878ruld72v.wl-maz@kernel.org>
 <CAOQ_QshwtTknXrpLkHbKj119=wVHvch0tHJURfrvia6Syy3tjg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAOQ_QshwtTknXrpLkHbKj119=wVHvch0tHJURfrvia6Syy3tjg@mail.gmail.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>, pshier@google.com,
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

On Tue, Feb 08, 2022, Oliver Upton wrote:
> Hi Marc,
> 
> On Tue, Feb 8, 2022 at 1:46 AM Marc Zyngier <maz@kernel.org> wrote:
> > > > KVM currently restricts the vcpu features to be unified across vcpus,
> > > > but that's only an implementation choice.
> > >
> > > But that implementation choice has become ABI, no? How could support
> > > for asymmetry be added without requiring userspace opt-in or breaking
> > > existing VMMs that depend on feature unification?
> >
> > Of course, you'd need some sort of advertising of this new behaviour.
> >
> > One thing I would like to add to the current state of thing is an
> > indication of whether the effects of a sysreg being written from
> > userspace are global or local to a vcpu. You'd need a new capability,
> > and an extra flag added to the encoding of each register.
> 
> Ah. I think that is a much more reasonable fit then. VMMs unaware of
> this can continue to migrate new bits (albeit at the cost of
> potentially higher lock contention for the per-VM stuff), and those
> that do can reap the benefits of writing such attributes exactly once.

But the "proper" usage is no different than adding support for VM-scoped variants
of KVM_{G,S}ET_ONE_REG and friends, and a VM-scoped variant is conceptually a lot
cleaner IMO.  And making them truly VM-scoped means KVM can do things like support
sysregs that are immutable after vCPUs are created.

So long as KVM defaults to '0' for all such registers, lack of migration support
in userspace that isn't aware of the new API, i.e. doesn't do KVM_GET_REG_LIST at
a VM-scope, is a nop because said userspace also won't modify the registers in the
first place.  The only "unsolvable" problem that is avoided by usurping the per-vCPU
ioctls is rollback to a userspace VMM that isn't aware of the per-VM ioctls, but it
doesn't seem too onerous to tell userspace "don't use these unless your entire fleet
has upgraded", especially since that requirement/advisement is true for the KVM side
with respect to new registers regardless of how those registers are accessed.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
