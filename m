Return-Path: <SRS0=x+jN=ER=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3A0BC388F9
	for <kvmarm@archiver.kernel.org>; Wed, 11 Nov 2020 13:45:34 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0418C20756
	for <kvmarm@archiver.kernel.org>; Wed, 11 Nov 2020 13:45:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="n6ILGBo/"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0418C20756
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2AAB24B3E5;
	Wed, 11 Nov 2020 08:45:33 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id R0l2kyAbyHZG; Wed, 11 Nov 2020 08:45:32 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2747E4B3FD;
	Wed, 11 Nov 2020 08:45:32 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 78E4B4B3E2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Nov 2020 08:45:31 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AcEPlhPGLF2I for <kvmarm@lists.cs.columbia.edu>;
 Wed, 11 Nov 2020 08:45:30 -0500 (EST)
Received: from mail-wr1-f66.google.com (mail-wr1-f66.google.com
 [209.85.221.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 430014B338
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Nov 2020 08:45:30 -0500 (EST)
Received: by mail-wr1-f66.google.com with SMTP id k2so2600220wrx.2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Nov 2020 05:45:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=aN9UhE4DLqxeGNvPkzfZsJS2+DLJT4pT+KyGFIkUBxM=;
 b=n6ILGBo/Vse8JvnguXnl3tQYuKcQPOHhQNVXLdZ4gvmWMzEEBVmfuLXBmmzVAt+SGg
 +QMI3ZLjDTF/wfhpjLJfsVSNgTmmQTsOGzhYpn9Ws4AljBWYwc/IsR4l5Gcq3jaQDw+e
 iRMgY2QF6TIkJqwhqwBToAbDeBVpTZ/2lZDjpLLUjmKdtfG0mnuTIeLCCQQ3jTsmrG6R
 n8JolcURVbOgUM4scyPuTbf25B7l0b/AaaNVYfMVXoVu/tzv2XU3i8iAIXzOGTrCgdP1
 QLfIxzUzm0a0P43i4ha4vQqOO3zjnKRLeQJrbA4Jo3LcpMmnu6ZdpYb9Awa0jOdXolG8
 fqPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=aN9UhE4DLqxeGNvPkzfZsJS2+DLJT4pT+KyGFIkUBxM=;
 b=S0HIqwZF8h24y9WXztf2je4G66UkbGmAXj10Zblk8kL4X/4P8k/uAjoTLL1OZYEMRv
 iKg/xzNpHcMgK5YzpBrkUf3ca3y+sMdyPeMIWOFey0vmgPB7bjq3uJ+9sV3fGqdKQgcP
 lo/KcvNNPZEPUAsEnuVY3vPRce+Ldnf96rUtIxQTAMUFLcpFYQVp/tqO4GBC76icxzim
 Dvr0Q6fCgQuAVgdcazq12cMdQ+EY02aue04qatkUsvAsLXWXyNYXD1d9Z0VYptLHtd8M
 idDCM1iu1vVkB0DcJekCnom5dx2bsiNm/Gvfuf1FOkIdtBQs8VSH57xuHeVgxcOY+ZLT
 jlwQ==
X-Gm-Message-State: AOAM533anmfxS7IgnIRHkGd7UMrBz+C44/rlEs77ssYUlBEtrT0f53xG
 MmhcSXSDPs/vvy3bkfCwyFcFTA==
X-Google-Smtp-Source: ABdhPJxNfMSdJg/5S43HS/VH+jA7JrZoyOTCCBu3ZeYuIkATnnLfgh3FcQjEebsSYbjXIRr8KwAMdw==
X-Received: by 2002:a5d:4ec2:: with SMTP id s2mr30003335wrv.258.1605102329039; 
 Wed, 11 Nov 2020 05:45:29 -0800 (PST)
Received: from google.com ([2a01:4b00:8523:2d03:2595:ed05:1717:fe6e])
 by smtp.gmail.com with ESMTPSA id y63sm2575014wmg.28.2020.11.11.05.45.27
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 11 Nov 2020 05:45:28 -0800 (PST)
Date: Wed, 11 Nov 2020 13:45:27 +0000
From: David Brazdil <dbrazdil@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v1 07/24] kvm: arm64: Create nVHE copy of cpu_logical_map
Message-ID: <20201111134527.ygzf5cm6qpdpcroo@google.com>
References: <20201109113233.9012-1-dbrazdil@google.com>
 <20201109113233.9012-8-dbrazdil@google.com>
 <d473fd26e5314f2407b70242488f33de@kernel.org>
 <20201111130321.qalrzfabdonrwvsz@google.com>
 <15a580e6ac06294ead8859fba8f51deb@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <15a580e6ac06294ead8859fba8f51deb@kernel.org>
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

On Wed, Nov 11, 2020 at 01:29:29PM +0000, Marc Zyngier wrote:
> On 2020-11-11 13:03, David Brazdil wrote:
> > > > +/*
> > > > + * nVHE copy of data structures tracking available CPU cores.
> > > > + * Only entries for CPUs that were online at KVM init are populated.
> > > > + * Other CPUs should not be allowed to boot because their features were
> > > > + * not checked against the finalized system capabilities.
> > > > + */
> > > > +u64 __ro_after_init __cpu_logical_map[NR_CPUS] = { [0 ... NR_CPUS-1]
> > > > = INVALID_HWID };
> > > 
> > > I'm not sure what __ro_after_init means once we get S2 isolation.
> > 
> > It is stretching the definition of 'init' a bit, I know, but I don't see
> > what
> > your worry is about S2? The intention is to mark this read-only for
> > .hyp.text
> > at runtime. With S2, the host won't be able to write to it after KVM
> > init.
> > Obviously that's currently not the case.
> 
> More importantly, EL2 can write to it at any time, which is the bit I'm
> worried
> about, as it makes the annotation misleading.

EL2 can't, at least not accidentally. The hyp memory mapping is PAGE_HYP_RO
(see patch 05). Does this annotation have stronger guarantees in EL1?
AFAICT, those variables are made PAGE_KERNEL_RO in mark_rodata_ro().

> 
> > One thing we might change in the future is marking it RW for some
> > initial
> > setup in a HVC handler, then marking it RO for the rest of uptime.
> 
> That'd be a desirable outcome, and it would be consistent with the rest
> of the kernel.
> 
> > 
> > > 
> > > > +
> > > > +u64 cpu_logical_map(int cpu)
> > > 
> > > nit: is there any reason why "cpu" cannot be unsigned? The thought
> > > of a negative CPU number makes me shiver...
> > 
> > Same here. That's how it's defined in kernel proper, so I went with
> > that.
> 
> I'm happy to deviate from the kernel (give the function a different name
> if this clashes with existing include files).
> 
> We can also fix the rest of the kernel (I've just written the trivial
> patch).

Shouldn't clash with include files. Where fixing the kernel might clash is
all the users of for_each_*_cpu that use an int for the iterator var.

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
