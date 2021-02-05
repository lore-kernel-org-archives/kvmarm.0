Return-Path: <SRS0=/Ra0=HH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CED54C433E6
	for <kvmarm@archiver.kernel.org>; Fri,  5 Feb 2021 18:56:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2386D64DA5
	for <kvmarm@archiver.kernel.org>; Fri,  5 Feb 2021 18:56:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2386D64DA5
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6BFA34B48C;
	Fri,  5 Feb 2021 13:56:56 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zvSBVoRrTaLN; Fri,  5 Feb 2021 13:56:55 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7D2594B48E;
	Fri,  5 Feb 2021 13:56:55 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1DDC54B3E8
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Feb 2021 13:56:55 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wUCv6dRikX-h for <kvmarm@lists.cs.columbia.edu>;
 Fri,  5 Feb 2021 13:56:54 -0500 (EST)
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com
 [209.85.167.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F1FDF4B3E1
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Feb 2021 13:56:53 -0500 (EST)
Received: by mail-lf1-f44.google.com with SMTP id p21so11305321lfu.11
 for <kvmarm@lists.cs.columbia.edu>; Fri, 05 Feb 2021 10:56:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=cHuXgL884ShiDPsTYGfb0bTiHe7tuKKlwCFWqjM9XGY=;
 b=CHXTe4WuMyR8yTZK5y1ObmdD8r5SZk+v7YJ52A6CFUKOggESswlbxpD2997kTc/Fqe
 qW8ICFqf2Cw+JpMT8DQ9BPZLxkDe/rncdnNVkq4Wl7w8CuVMb/7G5Y4obbJjd4efG5c8
 giwHvumB7vcyFAVnCYstwF5UEJ6ikWdOeTUF62Q31HiO6WJahXIRBJrYZgpzsralqWAg
 qPZ+CYStfuHqK6BNjIxUjprosOsBRt2r4xwUXQ3C1ONcDXeECFQGYsNbninL2xRCVUb7
 PrZcddIEjWasBtMSK1biaujW2VwxP1MiCQ0HOMUBjydr8WGbjwR6gE6OP9nEXH7dneF/
 xnLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=cHuXgL884ShiDPsTYGfb0bTiHe7tuKKlwCFWqjM9XGY=;
 b=ZRPHQbUwcR73y1VmUTZfOEvvjNHWGTsyiBikswWy93pDxc52UBb9ZNRqO6xFuFnqbK
 d4C9Q/Pkp4E5YVs55mGcBD8/Q54WQ/XVbKrYLj20jLSFM39dJ3TVtk/QP54pfOnsUtmF
 JoW+y9H2jGsu76H0ZlFr1MDZF/80AmxFjgGQDGImto/N2DPWcPllfC5gHkNWmW+nsPZa
 K43ZWTtl/7JGig18dwcV+SC/wsb+4/U4VxWFz03mb4U3ZvGA2K0/0AqxSyhBh2MKcE+8
 07jQvO8DSC1dUcRAOVrQVFSEwNut6f0mgzy6kmnSSJ3MFH04yemNl0l6cyrnSoyWL8V3
 FhQQ==
X-Gm-Message-State: AOAM530LnhkRBgj63h0TzQHA1GParZsflVAJGieQwN0c7XfKgxhLmLwr
 f/odxvUP1YhGL19S4IuW6A+C0B+RszX479leLXVuCQ==
X-Google-Smtp-Source: ABdhPJzfVloJ4puX9xBHwRSQPUgMiKklXtUzBdRAeZ5HPFQShbChjmVGYLEF7ed9XOC9vFYWa/+bRSr39/mR18cQ/Vs=
X-Received: by 2002:a05:6512:1042:: with SMTP id
 c2mr3280984lfb.359.1612551412383; 
 Fri, 05 Feb 2021 10:56:52 -0800 (PST)
MIME-Version: 1.0
References: <20210205044403.1559010-1-jingzhangos@google.com>
 <e34480715d3d5e13e5238195d596feda@kernel.org>
In-Reply-To: <e34480715d3d5e13e5238195d596feda@kernel.org>
From: Jing Zhang <jingzhangos@google.com>
Date: Fri, 5 Feb 2021 12:56:41 -0600
Message-ID: <CAAdAUtggLdom5=KOHPZYSVGSO2SmnO71bM796=F0YFayMWj5yw@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: Remove redundant check for S2FWB
To: Marc Zyngier <maz@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
 linux-arm-kernel@lists.infradead.org, Will Deacon <will@kernel.org>,
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

Hi Marc,

Thanks for the comment.
On Fri, Feb 5, 2021 at 11:24 AM Marc Zyngier <maz@kernel.org> wrote:
>
> Hi Jing,
>
> On 2021-02-05 04:44, Jing Zhang wrote:
> > Remove redundant check for CPU feature S2FWB in dcache flush code
> > to save some CPU cycles for every memslot flush and unmapping.
>
> What CPU cycles? This is only a static branch. Can you actually
> measure the overhead? What does it represent in the face of
> a full memslot unmapping?
For CPU cycles, I mean CPU time spent for S2FWB check.
For memslot unmapping, there is actually no improvement, just move the
check to the stage2_unmap_walker since we removed the S2FWB check in
stage2_flush_dcache.
The saving is from the code path of memslot flush. The S2FWB check was
in stage2_flush_dcache, in which case, for a memslot flush, the check
was done for every page. Now it will save some CPU time if we do the
check at a higher level, like in kvm_toggle_cache, access_dcsw,
kvm_arch_prepare_memory_region.
The redundant check is as follows (Only the first check is necessary):
kvm_arch_prepare_memory_region -> S2FWB check -> stage2_flush_memslot
-> kvm_pgtable_stage2_flush -> S2FWB check -> stage2_flush_walker ->
S2FWB check -> __flush_dcache_area

>
> Thanks,
>
>          M.
> --
> Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
