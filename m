Return-Path: <SRS0=x+jN=ER=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FC22C5517A
	for <kvmarm@archiver.kernel.org>; Wed, 11 Nov 2020 13:03:34 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D46382074B
	for <kvmarm@archiver.kernel.org>; Wed, 11 Nov 2020 13:03:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="Sd1vuoKU"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D46382074B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1F6D14B9A7;
	Wed, 11 Nov 2020 08:03:33 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1ZxEU4KDFsST; Wed, 11 Nov 2020 08:03:31 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EED644B9BD;
	Wed, 11 Nov 2020 08:03:31 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 268FA4B9B3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Nov 2020 08:03:31 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CBOlLvezVv5z for <kvmarm@lists.cs.columbia.edu>;
 Wed, 11 Nov 2020 08:03:26 -0500 (EST)
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com
 [209.85.128.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3332F4B9A7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Nov 2020 08:03:26 -0500 (EST)
Received: by mail-wm1-f48.google.com with SMTP id a3so2238907wmb.5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Nov 2020 05:03:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=XdgP6+ZmS9XKah/BF5cKI8FqYLe6KBfyjX/IEuvicQk=;
 b=Sd1vuoKU1AAoYkRoYQHxPEIrxpuhnPYf6Jliv3HEtBhI373IsM55sSjF/1PlobkLkW
 SxhGOo+oyAGlcN0kEMK14apG+X1On5FFrOy26nZhrqCtJNnnHhs+zNwpB1QjAr9fxQ60
 ulwdOIk3Cg6pW/Z5fHxdnoAEddVYu7JHHMCEAoqBTZugKX/R+QpchiECxxBoGjH1oyCX
 BD50o7vNtJFgFReaBuCHNnGAbz8EXlNJ5P6fFLhjeJFRPJlGMjBO7eI8UcPbUj45Nt51
 s3yJhAm0LM8vaTZmzbaz654XgbC7HJOzzwOJQbnR/Pr73PQiiqVUjmE2rEppd6OAtCOc
 GVug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=XdgP6+ZmS9XKah/BF5cKI8FqYLe6KBfyjX/IEuvicQk=;
 b=JlXn2MZ6s4B7IXSYijaD+oEPkf6X2d1GzX4NHmCedyEH/T2nE6Q4uRLlXHadRt4RK+
 yIBVXYZjSrkxXmMIGUhimleRY0aNDQ+KUBv537h+pDbodLsTAaJDEsNJTMtXWwtfwDaJ
 6UPfvjOTUwkCpZbsyzG58zwuA/ub0kFrhFK1BhcPGCKnjSfwLB7SHFT18fbmUli+8hvD
 nJstAzVX2AmtiWd1e7m+E5sSu9DDHavHiSIp6cPgJtEsUowNUxYs6WOiUn7iVdkbMgXc
 gWGk+kDPoFylRhZmRDUA1tjW2LHSuBDfMEryq/MyuFPKalB6FO3DGDmN1jC0DsYwp9KB
 Px+Q==
X-Gm-Message-State: AOAM533QhArmIWLTtWz1wEtGdyNCqIXdvMTdzK0LWGijC4Ld8uRsLJIe
 NZTgN+pBXyvsc31yV6WrCOYfxg==
X-Google-Smtp-Source: ABdhPJzCms/R+/q5OstGcy7wJvxHU5hys4N0pivVj2UMObHaYOBFmyNaXLuMbMjj6xXFcRuzEIMErw==
X-Received: by 2002:a1c:bd08:: with SMTP id n8mr4008787wmf.136.1605099804930; 
 Wed, 11 Nov 2020 05:03:24 -0800 (PST)
Received: from google.com ([2a01:4b00:8523:2d03:2595:ed05:1717:fe6e])
 by smtp.gmail.com with ESMTPSA id g138sm2508752wme.39.2020.11.11.05.03.22
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 11 Nov 2020 05:03:23 -0800 (PST)
Date: Wed, 11 Nov 2020 13:03:21 +0000
From: David Brazdil <dbrazdil@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v1 07/24] kvm: arm64: Create nVHE copy of cpu_logical_map
Message-ID: <20201111130321.qalrzfabdonrwvsz@google.com>
References: <20201109113233.9012-1-dbrazdil@google.com>
 <20201109113233.9012-8-dbrazdil@google.com>
 <d473fd26e5314f2407b70242488f33de@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <d473fd26e5314f2407b70242488f33de@kernel.org>
Cc: kernel-team@android.com, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Andrew Walbran <qwandor@google.com>, Catalin Marinas <catalin.marinas@arm.com>,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
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

> > +/*
> > + * nVHE copy of data structures tracking available CPU cores.
> > + * Only entries for CPUs that were online at KVM init are populated.
> > + * Other CPUs should not be allowed to boot because their features were
> > + * not checked against the finalized system capabilities.
> > + */
> > +u64 __ro_after_init __cpu_logical_map[NR_CPUS] = { [0 ... NR_CPUS-1]
> > = INVALID_HWID };
> 
> I'm not sure what __ro_after_init means once we get S2 isolation.

It is stretching the definition of 'init' a bit, I know, but I don't see what
your worry is about S2? The intention is to mark this read-only for .hyp.text
at runtime. With S2, the host won't be able to write to it after KVM init.
Obviously that's currently not the case.

One thing we might change in the future is marking it RW for some initial
setup in a HVC handler, then marking it RO for the rest of uptime.

> 
> > +
> > +u64 cpu_logical_map(int cpu)
> 
> nit: is there any reason why "cpu" cannot be unsigned? The thought
> of a negative CPU number makes me shiver...

Same here. That's how it's defined in kernel proper, so I went with that.

> 
> > +{
> > +	if (cpu < 0 || cpu >= ARRAY_SIZE(__cpu_logical_map))
> > +		hyp_panic();
> > +
> > +	return __cpu_logical_map[cpu];
> > +}
> > +
> >  unsigned long __hyp_per_cpu_offset(unsigned int cpu)
> >  {
> >  	unsigned long *cpu_base_array;
> 
> Overall, this patch would make more sense closer it its use case
> (in patch 19). I also don't understand why this lives in percpu.c...

I didn't think it called for adding another C file for this. How about we
rename this file to smp.c? Would that make sense for both?
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
