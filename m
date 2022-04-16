Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D97BDC433F5
	for <kvmarm@archiver.kernel.org>; Sat, 16 Apr 2022 16:03:28 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 406754A100;
	Sat, 16 Apr 2022 12:03:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HFP1KA1Whf7c; Sat, 16 Apr 2022 12:03:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 01F7C4A4BE;
	Sat, 16 Apr 2022 12:03:27 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 35AEC4A100
 for <kvmarm@lists.cs.columbia.edu>; Sat, 16 Apr 2022 12:03:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pOo92WybFAxM for <kvmarm@lists.cs.columbia.edu>;
 Sat, 16 Apr 2022 12:03:24 -0400 (EDT)
Received: from mail-il1-f181.google.com (mail-il1-f181.google.com
 [209.85.166.181])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D62B64A0FE
 for <kvmarm@lists.cs.columbia.edu>; Sat, 16 Apr 2022 12:03:24 -0400 (EDT)
Received: by mail-il1-f181.google.com with SMTP id i8so1312196ila.5
 for <kvmarm@lists.cs.columbia.edu>; Sat, 16 Apr 2022 09:03:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=wEt9N3Zhz4Vmmb7sqXNK/pWIreJjgm6LVz0beu10MRM=;
 b=NvYgpTXq2m6azGeR9w4P/7TL4sXEY6B7fIf4UDvIRkvKtw0JIK1J+IidxSzbdFxSy5
 q1mdOSugjRgbVCfiBlDGhlZwCYA1ffXlpS5AX4ZIweRQ1aQo3q64medWVQ/vYBEJjcvN
 DAqBX4epYgzd3f6LmhN5uzmuf2GfSB0KVh73/FepfptUrNHen2fvG68RcYzMw6JzV99b
 yLY1W0wifkrv/2/Ob38mT18umNWV5beggdvvctMKrLs4VfKdb6qU6azx3WXFFG8XT2GK
 uEm13V9Gc0CDOO52seiIEPeqUFpstU6G8/dRys8h5EWZA/RUBcr+z6MZdWmXDh63T8mb
 ccZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=wEt9N3Zhz4Vmmb7sqXNK/pWIreJjgm6LVz0beu10MRM=;
 b=Guw9Twj1Nn9IUyBsZW9CZxSSqlawJ1Ttlyerl6yvXABRnU2O1gyfYL0G4kutxtAMyQ
 UZZyYl02YmZFcXRRz6+5ml3c2mMZs4OZHgDacWugGAP5jatJkJ+SQCo4N7VVKu3MShNw
 iBaf3ngYbrV18CHQVw6oCMrRah3Sl95dGclof5f6qJyhLRcXUj7c27fED64y5XlMG0MY
 gyTtKulA0fvIBX+jKa0mSuRCX4j41GGbtqAWHUzjdwgDmUcU5aQr70p5eTBXKSqtoWZ4
 gEz17M/k0kdgMQtI4j3C/Owp4FlDcpGe8c5gZ3sYIZ7saDpXr9a7PdRrjnG16yxAt0PA
 gitA==
X-Gm-Message-State: AOAM532+majWerpCodcJ9j307dyWii0vL+gTU8cCfd0U/Rvrc9jH/L9E
 bZD3B88BmEFzf+qP0HysngRG5A==
X-Google-Smtp-Source: ABdhPJyyOEmzYK0FQivDQe0O5g3cZHm6nQaURPCa+AA+WKAFPTZsK7uW8SAGhg3mYpfM2B8pgGhfRQ==
X-Received: by 2002:a92:d7d0:0:b0:2ca:33ba:8bde with SMTP id
 g16-20020a92d7d0000000b002ca33ba8bdemr1596697ilq.121.1650125004003; 
 Sat, 16 Apr 2022 09:03:24 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194]) by smtp.gmail.com with ESMTPSA id
 k6-20020a6b4006000000b00649d7111ebasm4865516ioa.0.2022.04.16.09.03.19
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sat, 16 Apr 2022 09:03:21 -0700 (PDT)
Date: Sat, 16 Apr 2022 16:03:09 +0000
From: Oliver Upton <oupton@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [RFC PATCH 05/17] KVM: arm64: Take an argument to indicate
 parallel walk
Message-ID: <YlrovTwbgjeuxXea@google.com>
References: <20220415215901.1737897-1-oupton@google.com>
 <20220415215901.1737897-6-oupton@google.com>
 <871qxxb700.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <871qxxb700.wl-maz@kernel.org>
Cc: kvm@vger.kernel.org, Peter Shier <pshier@google.com>,
 Ben Gardon <bgardon@google.com>, David Matlack <dmatlack@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
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

On Sat, Apr 16, 2022 at 12:30:23PM +0100, Marc Zyngier wrote:
> Hi Oliver,
> 
> On Fri, 15 Apr 2022 22:58:49 +0100,
> Oliver Upton <oupton@google.com> wrote:
> > 
> > It is desirable to reuse the same page walkers for serial and parallel
> > faults. Take an argument to kvm_pgtable_walk() (and throughout) to
> > indicate whether or not a walk might happen in parallel with another.
> >
> > No functional change intended.
> > 
> > Signed-off-by: Oliver Upton <oupton@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_pgtable.h  |  5 +-
> >  arch/arm64/kvm/hyp/nvhe/mem_protect.c |  4 +-
> >  arch/arm64/kvm/hyp/nvhe/setup.c       |  4 +-
> >  arch/arm64/kvm/hyp/pgtable.c          | 91 ++++++++++++++-------------
> >  4 files changed, 54 insertions(+), 50 deletions(-)
> > 
> > diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> > index ea818a5f7408..74955aba5918 100644
> > --- a/arch/arm64/include/asm/kvm_pgtable.h
> > +++ b/arch/arm64/include/asm/kvm_pgtable.h
> > @@ -194,7 +194,7 @@ enum kvm_pgtable_walk_flags {
> >  typedef int (*kvm_pgtable_visitor_fn_t)(u64 addr, u64 end, u32 level,
> >  					kvm_pte_t *ptep, kvm_pte_t *old,
> >  					enum kvm_pgtable_walk_flags flag,
> > -					void * const arg);
> > +					void * const arg, bool shared);
> 
> Am I the only one who find this really ugly? Sprinkling this all over
> the shop makes the code rather unreadable. It seems to me that having
> some sort of more general context would make more sense.

You certainly are not. This is a bit sloppy, a previous spin of this
needed to know about parallelism in the generic page walker context and
I had picked just poking the bool through instead of hitching it to
kvm_pgtable_walker. I needed to churn either way in that scheme, but
that is no longer the case now.

> For example, I would fully expect the walk context to tell us whether
> this walker is willing to share its walk. Add a predicate to that,
> which would conveniently expand to 'false' for contexts where we don't
> have RCU (such as the pKVM HYP PT management, and you should get
> something that is more manageable.

I think the blast radius is now limited to just the stage2 visitors, so
it can probably get crammed in the callback arg now. Limiting the
changes to stage2 was intentional. The hyp walkers seem to be working
fine and I'd rather not come under fire for breaking it somehow ;)

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
