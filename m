Return-Path: <SRS0=n474=OM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FSL_HELO_FAKE,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25121C433EF
	for <kvmarm@archiver.kernel.org>; Wed, 22 Sep 2021 18:16:41 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9B78360EFF
	for <kvmarm@archiver.kernel.org>; Wed, 22 Sep 2021 18:16:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 9B78360EFF
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 20E764B0A0;
	Wed, 22 Sep 2021 14:16:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QU77iPt444JZ; Wed, 22 Sep 2021 14:16:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EB4BC4B0BF;
	Wed, 22 Sep 2021 14:16:38 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0082E4B099
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Sep 2021 14:13:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2c+VnKGvYvCE for <kvmarm@lists.cs.columbia.edu>;
 Wed, 22 Sep 2021 14:13:46 -0400 (EDT)
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com
 [209.85.215.171])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D7EB340291
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Sep 2021 14:13:45 -0400 (EDT)
Received: by mail-pg1-f171.google.com with SMTP id g184so3584075pgc.6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Sep 2021 11:13:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=rEfGQnKC2Rk4coZrfgQQApFk3zR3RiS6MSMlv3roo5E=;
 b=sdhaf5RnXeZyrzFn+kWJ+zD2MERo/LcZvz+lnC05HI6sgGdFeggPNpkiEuFfzG93Ks
 dpvXmguIGDD+QE2+Rq/NLT54k5UI0awKo7Ccrhq7GeIQV8Gpyw2UNKc34pQnfqSpzAOX
 TtSlCKkmNj0xRcvWKRXpptD6NGcYfbjvlbee/xR2rTXL8jtg/Kq5dOlDgi1N8GfANvuf
 m68Spmgs/aENcmyXomWhmrQRJfimEfPD/e1PhyMJbmKn2FTgOJf7336FiX14i9sAI5xy
 8QHgqiS+HlHlEc9hP2Ir1WNeUsmgea0MGXcOhPeVLm7SQWq0rjKJd67WBVtPvjhHmGt9
 IBeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=rEfGQnKC2Rk4coZrfgQQApFk3zR3RiS6MSMlv3roo5E=;
 b=izu63vT6LYg6KQIK3MCp/ARRLftVokLnAcKXvQ0bSek9le0u2ycNsbQSHITNjBoIms
 INIgPnbM1wvteLmRpPjN0fP+hHBPhJ8OhEXGvhivZfYDGzxpsSV4yb11kLh1hqe23cAw
 1ZK1y56HDpk4Iqdt6FFSqCtZuMgKmpGvZV7TSgcy0Bm+gd9keb+PCodOCxSpcee6aPZN
 QjJFteowgvzi+h8AP49d0Ur6csh6TCWce1oNBatrnelTXrOWkWoI8qB4PMNHBbL1UwcL
 WziNWyY6qduejpnJOOyMGT5SZpROG+osq4wKqYwpCBV7z6w8Bv0cS/kIuHi48MoHMXNm
 Sb/Q==
X-Gm-Message-State: AOAM532V0AiRBDaEK0IPheC3eS3hIh+A75QrMNiXPy68CIk2+5F6gCe/
 LfRSVOLkJHXnPvDFhdbn/5wsXQ==
X-Google-Smtp-Source: ABdhPJzCQmCaSOsJPoQjkK7m7fOPC+A+61MDYsLb7ksgDBveJSxAp8dnM8KJ5912bQZPJ8qftXiMRg==
X-Received: by 2002:aa7:9f8a:0:b0:43c:39be:23fb with SMTP id
 z10-20020aa79f8a000000b0043c39be23fbmr172220pfr.57.1632334424775; 
 Wed, 22 Sep 2021 11:13:44 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157])
 by smtp.gmail.com with ESMTPSA id ga24sm6331417pjb.41.2021.09.22.11.13.43
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 22 Sep 2021 11:13:44 -0700 (PDT)
Date: Wed, 22 Sep 2021 18:13:40 +0000
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v1 3/3] KVM: arm64: Add histogram stats for handling time
 of arch specific exit reasons
Message-ID: <YUtyVEpMBityBBNl@google.com>
References: <20210922010851.2312845-1-jingzhangos@google.com>
 <20210922010851.2312845-3-jingzhangos@google.com>
 <87czp0voqg.wl-maz@kernel.org>
 <d16ecbd2-2bc9-2691-a21d-aef4e6f007b9@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <d16ecbd2-2bc9-2691-a21d-aef4e6f007b9@redhat.com>
X-Mailman-Approved-At: Wed, 22 Sep 2021 14:16:38 -0400
Cc: Aaron Lewis <aaronlewis@google.com>, KVM <kvm@vger.kernel.org>,
 Venkatesh Srinivas <venkateshs@google.com>, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, Ben Gardon <bgardon@google.com>,
 David Matlack <dmatlack@google.com>, Will Deacon <will@kernel.org>,
 KVMARM <kvmarm@lists.cs.columbia.edu>, Jim Mattson <jmattson@google.com>
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

+Google folks

On Wed, Sep 22, 2021, Paolo Bonzini wrote:
> On 22/09/21 13:22, Marc Zyngier wrote:
> > Frankly, this is a job for BPF and the tracing subsystem, not for some
> > hardcoded syndrome accounting. It would allow to extract meaningful
> > information, prevent bloat, and crucially make it optional. Even empty
> > trace points like the ones used in the scheduler would be infinitely
> > better than this (load your own module that hooks into these trace
> > points, expose the data you want, any way you want).
> 
> I agree.  I had left out for later the similar series you had for x86, but I
> felt the same as Marc; even just counting the number of occurrences of each
> exit reason is a nontrivial amount of memory to spend on each vCPU.

That depends on the use case, environment, etc...  E.g. if the VM is assigned a
_minimum_ of 4gb per vCPU, then burning even tens of kilobytes of memory per vCPU
is trivial, or at least completely acceptable.

I do 100% agree this should be optional, be it through an ioctl(), module/kernel
param, Kconfig, whatever.  The changelogs are also sorely lacking the motivation
for having dedicated stats; we'll do our best to remedy that for future work.

Stepping back a bit, this is one piece of the larger issue of how to modernize
KVM for hyperscale usage.  BPF and tracing are great when the debugger has root
access to the machine and can rerun the failing workload at will.  They're useless
for identifying trends across large numbers of machines, triaging failures after
the fact, debugging performance issues with workloads that the debugger doesn't
have direct access to, etc...

Logging is a similar story, e.g. using _ratelimited() printk to aid debug works
well when there are a very limited number of VMs and there is a human that can
react to arbitrary kernel messages, but it's basically useless when there are 10s
or 100s of VMs and taking action on a kernel message requires a prior knowledge
of the message.

I'm certainly not expecting other people to solve our challenges, and I fully
appreciate that there are many KVM users that don't care at all about scalability,
but I'm hoping we can get the community at large, and especially maintainers and
reviewers, to also consider at-scale use cases when designing, implementing,
reviewing, etc...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
