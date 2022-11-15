Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97376C433FE
	for <kvmarm@archiver.kernel.org>; Tue, 15 Nov 2022 17:24:00 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 08CB24B8C5;
	Tue, 15 Nov 2022 12:24:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id c+vMCjjJjXwd; Tue, 15 Nov 2022 12:23:58 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D42B34B8A9;
	Tue, 15 Nov 2022 12:23:58 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ACB0E4B8AA
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Nov 2022 12:23:57 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ADjcKq73XGxS for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Nov 2022 12:23:56 -0500 (EST)
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 93CFE4B7FC
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Nov 2022 12:23:56 -0500 (EST)
Date: Tue, 15 Nov 2022 17:23:51 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1668533035;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=epDwsDiYoNZ6uhKBqwMbJzXJpjRcm2DVB2PP1BGcjP8=;
 b=LMKySPNF2K08tEU8/pacucf93qxXUOua+1KWhnakFetm4VAYbi1ofKjDaiEZ/IDYEaYhj6
 E7ssklZu9Y1+ZIf9KUl4UgiMCAQQp1LHUO0YfCVLJh7TB2gsxpFsg3cKGGkiXQTlKgdwTV
 BR8S7QBQCXemVNgYdPzwfxfjQlgLYOE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Will Deacon <will@kernel.org>
Subject: Re: [PATCH 1/1] KVM: arm64: Use a separate function for hyp stage-1
 walks
Message-ID: <Y3PLJxnvmZp35MpF@google.com>
References: <20221114201127.1814794-1-oliver.upton@linux.dev>
 <20221114201127.1814794-2-oliver.upton@linux.dev>
 <20221115132532.GA524@willie-the-truck>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20221115132532.GA524@willie-the-truck>
X-Migadu-Flow: FLOW_OUT
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

Hey Will,

On Tue, Nov 15, 2022 at 01:25:34PM +0000, Will Deacon wrote:

[...]

> On Mon, Nov 14, 2022 at 08:11:27PM +0000, Oliver Upton wrote:
> > +int kvm_pgtable_hyp_walk(struct kvm_pgtable *pgt, u64 addr, u64 size,
> > +			 struct kvm_pgtable_walker *walker);
> 
> Hmm, this feels like slightly the wrong abstraction to me -- there's nothing
> hyp-specific about the problem being solved, it's just that the only user
> is for hyp walks.
> 
> Could we instead rework 'struct kvm_pgtable' slightly so that the existing
> 'flags' field is no-longer stage-2 specific and includes a KVM_PGTABLE_LOCKED
> flag which could be set by kvm_pgtable_hyp_init()?
> 
> That way the top-level API remains unchanged and the existing callers will
> continue to work.

Thanks for the suggestion! Yeah, this should be described by the flags
instead.

We already have KVM_PGTABLE_WALK_SHARED, I could actually condition the
RCU lock/unlock on that one. That would make it an explicit opt-in
instead of requiring an opt out with callers passing KVM_PGTABLE_LOCKED.

Thoughts?

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
