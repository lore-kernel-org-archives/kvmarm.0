Return-Path: <SRS0=9vag=P7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 602F3C433EF
	for <kvmarm@archiver.kernel.org>; Fri, 12 Nov 2021 01:32:53 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D01E560EE9
	for <kvmarm@archiver.kernel.org>; Fri, 12 Nov 2021 01:32:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org D01E560EE9
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 57DCC4B24B;
	Thu, 11 Nov 2021 20:32:52 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id J7xfFlh4Gggb; Thu, 11 Nov 2021 20:32:50 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CEC564B243;
	Thu, 11 Nov 2021 20:32:50 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2D2334B223
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Nov 2021 20:32:49 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id epNUriaZKDeV for <kvmarm@lists.cs.columbia.edu>;
 Thu, 11 Nov 2021 20:32:47 -0500 (EST)
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com
 [209.85.214.176])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6FD224B1EF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Nov 2021 20:32:47 -0500 (EST)
Received: by mail-pl1-f176.google.com with SMTP id y1so7141984plk.10
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Nov 2021 17:32:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=AL90QSnlPxXv5tLufZ1zlq7KjJ0D5BExWrjps1t+29s=;
 b=bxpxOXkH1/gRoN3q2sIlqLWqnDgG6G2HCxNOF6DiM0eebPtdUrVaLZdwTKm30XXIKf
 pciYCCAraDj6+N5ub88aiEU9Sqc+gEEP0tH18UnSplfqeJqpp5zQ3lSTaSygRoGg4fg+
 tll+ejzFsotRKGLbtXHvALciCIt5yeW9ml8k89oDq6DTTLGsUACfArDWOsNIoY0iXp96
 kikQ0fngC+TPH3Kllv27OAwe5xRNf7EWJvcamUReZttXO7TYV+21eZVF7m1gQCC7oZ3B
 biwzTph5R1rTPbnijCWDmekT3qmBDk8AlH8GBjflmk5suuX4JZkxLi8aoALrZ9ZHJtW7
 R2tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=AL90QSnlPxXv5tLufZ1zlq7KjJ0D5BExWrjps1t+29s=;
 b=jbXUQdxS1kXJG29ynsEAJwlEcDrl9eHpOMzMKE8FmwDUDZp6vLc4Tn0swEDcOi1Hsl
 6vAVouZNaEbG2ipvqpbMNA3TEd21NZWK8tkX8+qKRj7TtoIr/R10xfxU86yC8IzHeixZ
 ozGM7GoEspaMK3810wECQyTlEanvnE8EZ1glsb13lOk3k2JMzarWk9skHRzMZxSJcPX/
 FhfAAySkA9ldl1kUh70mIdAWEe36NhZpOxZKXCWJ6Sl3fZpsYifGT3NoEARGBMVKXpnC
 uz6uXj7lLWH1pa/GdtXv/DrT7qfxb/aWan1lGYqcWNEIzAAYeccLCGbareSt063oLP0o
 lTCA==
X-Gm-Message-State: AOAM533uaqj6u6Je4efiqHAMjwTrDbrV3XNeX542mn7OY4tmiUARWNBW
 CpZUwyTWJTTxYIZwW1r6igkShA==
X-Google-Smtp-Source: ABdhPJy7r4nQtcrRS0vLIHiQ7JwTdkVyJqAYi43992L2uT2O4NHn7Evm+9JHhEIz/lSq4u0UiWyh1A==
X-Received: by 2002:a17:90a:17a5:: with SMTP id
 q34mr31238939pja.122.1636680766291; 
 Thu, 11 Nov 2021 17:32:46 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157])
 by smtp.gmail.com with ESMTPSA id p23sm9227849pjg.55.2021.11.11.17.32.45
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 11 Nov 2021 17:32:45 -0800 (PST)
Date: Fri, 12 Nov 2021 01:32:41 +0000
From: Sean Christopherson <seanjc@google.com>
To: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
Subject: Re: [PATCH v5.5 30/30] KVM: Dynamically allocate "new" memslots from
 the get-go
Message-ID: <YY3EOeHVvgOKHNnt@google.com>
References: <20211104002531.1176691-1-seanjc@google.com>
 <20211104002531.1176691-31-seanjc@google.com>
 <fee75f86-26b0-2dbe-770a-8ecf5cc9e178@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <fee75f86-26b0-2dbe-770a-8ecf5cc9e178@oracle.com>
Cc: Anup Patel <anup.patel@wdc.com>, Wanpeng Li <wanpengli@tencent.com>,
 kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
 linux-kernel@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
 Atish Patra <atish.patra@wdc.com>, Ben Gardon <bgardon@google.com>,
 linux-riscv@lists.infradead.org, Claudio Imbrenda <imbrenda@linux.ibm.com>,
 kvmarm@lists.cs.columbia.edu, Janosch Frank <frankja@linux.ibm.com>,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 kvm-ppc@vger.kernel.org, Paul Walmsley <paul.walmsley@sifive.com>,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 Cornelia Huck <cohuck@redhat.com>, linux-mips@vger.kernel.org,
 kvm-riscv@lists.infradead.org, Paolo Bonzini <pbonzini@redhat.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>
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

On Fri, Nov 12, 2021, Maciej S. Szmigiero wrote:
> On 04.11.2021 01:25, Sean Christopherson wrote:
> > Allocate the "new" memslot for !DELETE memslot updates straight away
> > instead of filling an intermediate on-stack object and forcing
> > kvm_set_memslot() to juggle the allocation and do weird things like reuse
> > the old memslot object in MOVE.
> > 
> > In the MOVE case, this results in an "extra" memslot allocation due to
> > allocating both the "new" slot and the "invalid" slot, but that's a
> > temporary and not-huge allocation, and MOVE is a relatively rare memslot
> > operation.
> > 
> > Regarding MOVE, drop the open-coded management of the gfn tree with a
> > call to kvm_replace_memslot(), which already handles the case where
> > new->base_gfn != old->base_gfn.  This is made possible by virtue of not
> > having to copy the "new" memslot data after erasing the old memslot from
> > the gfn tree.  Using kvm_replace_memslot(), and more specifically not
> > reusing the old memslot, means the MOVE case now does hva tree and hash
> > list updates, but that's a small price to pay for simplifying the code
> > and making MOVE align with all the other flavors of updates.  The "extra"
> > updates are firmly in the noise from a performance perspective, e.g. the
> > "move (in)active area" selfttests show a (very, very) slight improvement.
> > 
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> 
> Reviewed-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
> 
> For a new patch set version when the "main" commit is rewritten anyway
> (I mean the one titled "Keep memslots in tree-based structures instead of
> array-based ones") it makes sense to integrate changes like these into
> such modified main commit.
> 
> This way a full algorithm / logic check for all the supported memslot
> operations needs to be done only once instead of having to be done
> multiple times for all these intermediate forms of the code (as this is
> a quite time-consuming job to do properly).
> 
> I think it only makes sense to separate non-functional changes (like
> renaming of variables, comment rewording, open-coding a helper, etc.)
> into their own patches for ease of reviewing.

I agree that validating intermediate stages is time-consuming and can be
frustrating, but that doesn't diminish the value of intermediate patches.  I do
tend to lean too far towards slicing and dicing, but I am quite confident that
I've come out ahead in terms of time spent validating smaller patches versus
time saved because bisection could pinpoint the exact problem.

E.g. in this patch, arch code can now see a NULL @new.  That's _supposed_ to be a
non-functional change, but it would be all too easy to have missed a path in the
prep work where an arch accesses @new without first checking it for NULL (or DELETE).
If such a bug were to escape review, then bisection would point at this patch, not
the mega patch that completely reworked the core memslots behavior.

And IIRC, I actually botched the prior "bitter end" patch and initially missed a
new.npages => npages conversion.  Again, no functional change _intended_, but one
of the main reasons for doing small(er) intermediate patches is precisely so that
any unintended behavior stands out and is easier to debug/triage.

> Or if the main commit was unchanged from the last reviewed version so
> actual changes in the new version will stand out.
> 
> Thanks,
> Maciej
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
