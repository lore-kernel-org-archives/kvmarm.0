Return-Path: <SRS0=lGHe=IB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C20EC433DB
	for <kvmarm@archiver.kernel.org>; Wed,  3 Mar 2021 11:09:08 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B8D3D64E6C
	for <kvmarm@archiver.kernel.org>; Wed,  3 Mar 2021 11:09:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B8D3D64E6C
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2B0F44B786;
	Wed,  3 Mar 2021 06:09:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id G0thBq4gVVdt; Wed,  3 Mar 2021 06:09:06 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0284C4B66A;
	Wed,  3 Mar 2021 06:09:06 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 187754B768
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Mar 2021 06:09:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id k4rAY48SE9Rj for <kvmarm@lists.cs.columbia.edu>;
 Wed,  3 Mar 2021 06:09:03 -0500 (EST)
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com
 [209.85.128.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D91CE4B764
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Mar 2021 06:09:02 -0500 (EST)
Received: by mail-wm1-f50.google.com with SMTP id m1so5927013wml.2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 03 Mar 2021 03:09:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=MrgKs7AaAPjSu71bqqbhqpKHLtrghctRiTu/BX2ygw8=;
 b=FRekRJ5Nz3cuYK/fdGOcgaM6AWa1qil920H3kKq4lFukOc3ZwD8SjK6qpnsMwV2TQ7
 5BnY2nCQ3Z0rXltTRr1gF64IuwVC5GZ/7BDGhOCKm3M4Zfdj7nCQ8GgtYDv/XreD1tMa
 nerPCo83Rz7nSde1dO/VwB6Gjx6qZ8P2QhRVi93aTOeVz/kTLEbuh4Z6rIhJOcYxiSm6
 d4uZxTqyKSiQMrgs1l29hwka1QnS4gUVQQqJ0ZXg9MzeyCpQvCdsNBc1TqsZWvzwfe6V
 nSRA53tBAXvZdl1XZ/PMZ+HTLRuTbD/I/CgDQN+8XBRm5+hI9ma1/pc9+BbA7H3rgUSF
 Kk3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=MrgKs7AaAPjSu71bqqbhqpKHLtrghctRiTu/BX2ygw8=;
 b=runFyhalawEJ0ubV6YhNWyNApt7dZT2gRZJtQFusuAA4o14oZV4NX08iVMuwuEPLRo
 pC4BvSHPKfSgdbLx5kTJMmKNQGbXg5kYK+ov86OZWN+PGuUfws9YOcP5Z5xiLl+aacI/
 O8NEqsVtApr9hQP5hWmYtKYpNMFzBLhK9aQ1GryFORqoDq2J5PwDcL4HNWnrDL/9kWtx
 c2dRqRJ0iVBpfd/cbqjY+dQ0SygVlTjlhSgOupAGWGRHmWvhDvo2EpyiK7ofJ6k/j5C0
 1JZiqeXAxFlqHd3friUtqWryBBEAiJ+EeJ8lZNbZG3MO8WHzdfAcJR6/S5Lv3QvIbrlJ
 QhJA==
X-Gm-Message-State: AOAM5312SLIu63JxCLo/w5wYo3YbXA3MqGWfiGf41l0/GHU0gxd8y/Eu
 KFGhVqdnmvrqjvzC1IHyL4gF5g==
X-Google-Smtp-Source: ABdhPJxFT/FTy1GsdpssFmrNcBfUaVBDWruZyYIsCWz48j1d9N4bImoC/8FkC4KeJ3Nuf3JpJ9Rp5A==
X-Received: by 2002:a1c:bb89:: with SMTP id l131mr8855627wmf.47.1614769741728; 
 Wed, 03 Mar 2021 03:09:01 -0800 (PST)
Received: from google.com (230.69.233.35.bc.googleusercontent.com.
 [35.233.69.230])
 by smtp.gmail.com with ESMTPSA id r10sm7196657wmh.45.2021.03.03.03.09.01
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 03 Mar 2021 03:09:01 -0800 (PST)
Date: Wed, 3 Mar 2021 11:08:56 +0000
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH] KVM: arm64: Fix unaligned addr case in mmu walking
Message-ID: <YD9uSPQtlP2WTObe@google.com>
References: <20210303024225.2591-1-justin.he@arm.com>
 <87sg5czhny.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87sg5czhny.wl-maz@kernel.org>
Cc: Jia He <justin.he@arm.com>, Catalin Marinas <catalin.marinas@arm.com>,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
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

On Wednesday 03 Mar 2021 at 09:54:25 (+0000), Marc Zyngier wrote:
> Hi Jia,
> 
> On Wed, 03 Mar 2021 02:42:25 +0000,
> Jia He <justin.he@arm.com> wrote:
> > 
> > If the start addr is not aligned with the granule size of that level.
> > loop step size should be adjusted to boundary instead of simple
> > kvm_granual_size(level) increment. Otherwise, some mmu entries might miss
> > the chance to be walked through.
> > E.g. Assume the unmap range [data->addr, data->end] is
> > [0xff00ab2000,0xff00cb2000] in level 2 walking and NOT block mapping.
> 
> When does this occur? Upgrade from page mappings to block? Swap out?
> 
> > And the 1st part of that pmd entry is [0xff00ab2000,0xff00c00000]. The
> > pmd value is 0x83fbd2c1002 (not valid entry). In this case, data->addr
> > should be adjusted to 0xff00c00000 instead of 0xff00cb2000.
> 
> Let me see if I understand this. Assuming 4k pages, the region
> described above spans *two* 2M entries:
> 
> (a) ff00ab2000-ff00c00000, part of ff00a00000-ff00c00000
> (b) ff00c00000-ff00db2000, part of ff00c00000-ff00e00000
> 
> (a) has no valid mapping, but (b) does. Because we fail to correctly
> align on a block boundary when skipping (a), we also skip (b), which
> is then left mapped.
> 
> Did I get it right? If so, yes, this is... annoying.
> 
> Understanding the circumstances this triggers in would be most
> interesting. This current code seems to assume that we get ranges
> aligned to mapping boundaries, but I seem to remember that the old
> code did use the stage2_*_addr_end() helpers to deal with this case.
> 
> Will: I don't think things have changed in that respect, right?

Indeed we should still use stage2_*_addr_end(), especially in the unmap
path that is mentioned here, so it would be helpful to have a little bit
more context.

> > Without this fix, userspace "segment fault" error can be easily
> > triggered by running simple gVisor runsc cases on an Ampere Altra
> > server:
> >     docker run --runtime=runsc -it --rm  ubuntu /bin/bash
> > 
> > In container:
> >     for i in `seq 1 100`;do ls;done
> 
> The workload on its own isn't that interesting. What I'd like to
> understand is what happens on the host during that time.
> 
> > 
> > Reported-by: Howard Zhang <Howard.Zhang@arm.com>
> > Signed-off-by: Jia He <justin.he@arm.com>
> > ---
> >  arch/arm64/kvm/hyp/pgtable.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> > index bdf8e55ed308..4d99d07c610c 100644
> > --- a/arch/arm64/kvm/hyp/pgtable.c
> > +++ b/arch/arm64/kvm/hyp/pgtable.c
> > @@ -225,6 +225,7 @@ static inline int __kvm_pgtable_visit(struct kvm_pgtable_walk_data *data,
> >  		goto out;
> >  
> >  	if (!table) {
> > +		data->addr = ALIGN_DOWN(data->addr, kvm_granule_size(level));
> >  		data->addr += kvm_granule_size(level);
> >  		goto out;
> >  	}
> 
> It otherwise looks good to me. Quentin, Will: unless you object to
> this, I plan to take it in the next round of fixes with

Though I'm still unsure how we hit that today, the change makes sense on
its own I think, so no objection from me.

Thanks,
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
