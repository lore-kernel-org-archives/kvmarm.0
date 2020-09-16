Return-Path: <SRS0=cLXx=CZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22CFDC433E2
	for <kvmarm@archiver.kernel.org>; Wed, 16 Sep 2020 11:54:12 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7CF5D22209
	for <kvmarm@archiver.kernel.org>; Wed, 16 Sep 2020 11:54:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="JyQsV3C/"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7CF5D22209
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BAF0E4B354;
	Wed, 16 Sep 2020 07:54:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vGB05la2HtwW; Wed, 16 Sep 2020 07:54:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C09A84B445;
	Wed, 16 Sep 2020 07:54:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A5AF54B445
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Sep 2020 07:54:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0riUNsbY52Rp for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 Sep 2020 07:54:07 -0400 (EDT)
Received: from mail-wm1-f68.google.com (mail-wm1-f68.google.com
 [209.85.128.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8F3734B354
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Sep 2020 07:54:07 -0400 (EDT)
Received: by mail-wm1-f68.google.com with SMTP id w2so2494752wmi.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Sep 2020 04:54:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=Yh0igFnXFGH3K7pZzQhRNs7ViU5/hMjpnGkORzHpipk=;
 b=JyQsV3C/yV+HMhjcrBeo4b6vbtbXN/7M7NJbIgBea1ZCl6bB/Wv56zT6tM39MhZYIz
 1ePZsPTW5M75mT5wRpRoNtZy/x1FJ8O69Jo5IFaxDlzHdWeRiNrB4GKbyft7T7Rf3m7c
 aWwz5PsssRQJClQFnacWnvlS5MQg4yUM9L2jw8VuALu4NTPRUxNv67kIW5FUWGPCDVP9
 yMm7HzrgXsD04qEeBHOQTjc1spMBk+h1ObSRut8UsG0poo7gRH4ptNx9EujbEMj5Cb7U
 w4FXV2249ahLD5jNOQ2ov9+67BvirUZC0p0CE4a+dXdPSDP2nJyRXQPZXP6lPs90vfLk
 zTZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=Yh0igFnXFGH3K7pZzQhRNs7ViU5/hMjpnGkORzHpipk=;
 b=WJLvWsSKR0PjP2+HrFr4S8gvLZbxgxTCSGWXMGDd1BvOHqHUiycjqyRdf1AHfxQy2j
 7oLce5rvmE1JjQU9q9igZHDORYRvj0rkn+GARawLK8+QCI5s1dhCEgI1VIGsTml8R/in
 qhXOofJ3iLilrnJwbrkJD3afVx1/wt56t5WpgnOxv9jVbj7OwcD/YS/bdnC0eWCZCdTl
 43KzVn3L1bL7v6n+DPYMMMAe/XAeMq0UeuXvHDq/BNoeuWotArtpibx5WdqErJPDP1Nd
 IaD8+tcsOyDAyzjsYVBJiYSNkUXijRzXSwueahY7e7PVV9lEUfHy6lN5o/aDw1n9d+rF
 Riwg==
X-Gm-Message-State: AOAM530OAUSroHdESXGinqVURW3k43unUDf9l28lQ6jVzOLXc6u3+k8/
 2P/qAXB/OTmj8B6QIGbXgCqtiA==
X-Google-Smtp-Source: ABdhPJwEUCld1s87TOjbwzmcs50r5qVIn7ePIrzWPUYEsAFENq0CtkJ+OctMHBN++deLK1KNg4U8hw==
X-Received: by 2002:a05:600c:2118:: with SMTP id
 u24mr4258846wml.59.1600257246355; 
 Wed, 16 Sep 2020 04:54:06 -0700 (PDT)
Received: from google.com ([2a01:4b00:8523:2d03:e49d:f6be:d31b:ad3c])
 by smtp.gmail.com with ESMTPSA id u66sm5088416wmg.44.2020.09.16.04.54.05
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 16 Sep 2020 04:54:05 -0700 (PDT)
Date: Wed, 16 Sep 2020 12:54:04 +0100
From: David Brazdil <dbrazdil@google.com>
To: Will Deacon <will@kernel.org>
Subject: Re: [PATCH v2 00/10] Independent per-CPU data section for nVHE
Message-ID: <20200916115404.rhv4dkyjz35e4x25@google.com>
References: <20200903091712.46456-1-dbrazdil@google.com>
 <20200914174008.GA25238@willie-the-truck>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200914174008.GA25238@willie-the-truck>
Cc: linux-arch@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
 Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>, Tejun Heo <tj@kernel.org>,
 Dennis Zhou <dennis@kernel.org>, Christoph Lameter <cl@linux.com>,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu
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

Hi Will,

On Mon, Sep 14, 2020 at 06:40:09PM +0100, Will Deacon wrote:
> Hi David,
> 
> On Thu, Sep 03, 2020 at 11:17:02AM +0200, David Brazdil wrote:
> > Introduce '.hyp.data..percpu' as part of ongoing effort to make nVHE
> > hyp code self-contained and independent of the rest of the kernel.
> > 
> > The series builds on top of the "Split off nVHE hyp code" series which
> > used objcopy to rename '.text' to '.hyp.text' and prefix all ELF
> > symbols with '__kvm_nvhe' for all object files under kvm/hyp/nvhe.
> 
> I've been playing around with this series this afternoon, trying to see
> if we can reduce the coupling between the nVHE code and the core code. I've
> ended up with the diff below on top of your series, but I think it actually
> removes the need to change the core code at all. The idea is to collapse
> the percpu sections during prelink, and then we can just deal with the
> resulting data section a bit like we do for .hyp.text already.
> 
> Have I missed something critical?

I was wondering whether this approach would be sufficient as well because of
the simplicity. We'd just need to be careful about correctly preserving the
semantics of the different .data..percpu..* sections.

For instance, I've noticed you make .hyp..data..percpu page-aligned rather than
cacheline-aligned. We need that for stage-2 unmapping but it also happens to
correctly align DEFINE_PER_CPU_PAGE_ALIGNED variables when collapsed into the
single hyp section. The reason why I ended up reusing the global macro was to
avoid introducing subtleties like that into the arm64 linker script. Do you
think it's a worthwhile trade off?

One place where this approach doesn't work is DEFINE_PER_CPU_FIRST. But I'm
guessing that's something we can live without.

I was also wondering about another approach - using the PERCPU_SECTION macro
unchanged in the hyp linker script. It would lay out a single .data..percpu and
we would then prefix it with .hyp and the symbols with __kvm_nvhe_ as with
everything else. WDYT? Haven't tried that yet, could be a naive idea. 

Thanks for reviewing,
David
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
