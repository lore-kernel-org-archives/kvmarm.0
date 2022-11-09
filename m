Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C11CFC433FE
	for <kvmarm@archiver.kernel.org>; Wed,  9 Nov 2022 22:49:09 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3B39F4BA2B;
	Wed,  9 Nov 2022 17:49:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9zWC1tW7KLy0; Wed,  9 Nov 2022 17:49:07 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C9DEA4002F;
	Wed,  9 Nov 2022 17:49:07 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BC9DF4BA2C
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Nov 2022 17:49:06 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gUmvaURHDvTn for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Nov 2022 17:49:05 -0500 (EST)
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 639C34BA2B
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Nov 2022 17:49:05 -0500 (EST)
Date: Wed, 9 Nov 2022 22:48:48 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1668034140;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=uy8PKmBJllUyFJnAMPXkpcKsBKhmjino2ZkcFTbS9rs=;
 b=sUu1+UXh7oEBAIs4hIdEgPV8KWK0j3gsGb9InYHeHjT0tU5n3mMiYYMOeVdXGc2M49fMAB
 9x+1Uhk+3EgMVSPzaDyJ6Tijp2FBsZDTpw8lRKQ6d0b+d0zuVcY480/UygcXT7rWNI3/Gn
 4T/XSrE44KY34fkUSjdG7+XP0ezELL0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH v5 01/14] KVM: arm64: Combine visitor arguments into a
 context structure
Message-ID: <Y2wuUNNAlsIlxnwM@google.com>
References: <20221107215644.1895162-1-oliver.upton@linux.dev>
 <20221107215644.1895162-2-oliver.upton@linux.dev>
 <CANgfPd9ooA5c+ZQMx4-yy+n92TsxoAXZyHRoTpatoSOb+jXi-w@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CANgfPd9ooA5c+ZQMx4-yy+n92TsxoAXZyHRoTpatoSOb+jXi-w@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, kvmarm@lists.linux.dev,
 David Matlack <dmatlack@google.com>, kvmarm@lists.cs.columbia.edu,
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

On Wed, Nov 09, 2022 at 02:23:08PM -0800, Ben Gardon wrote:
> On Mon, Nov 7, 2022 at 1:57 PM Oliver Upton <oliver.upton@linux.dev> wrote:
> >
> > Passing new arguments by value to the visitor callbacks is extremely
> > inflexible for stuffing new parameters used by only some of the
> > visitors. Use a context structure instead and pass the pointer through
> > to the visitor callback.
> >
> > While at it, redefine the 'flags' parameter to the visitor to contain
> > the bit indicating the phase of the walk. Pass the entire set of flags
> > through the context structure such that the walker can communicate
> > additional state to the visitor callback.
> >
> > No functional change intended.
> >
> > Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> 
> This looks good to me. It's all fairly mechanical and I don't see any
> problems. I was a little confused by the walk context flags passed via
> visit, because they seem somewhat redundant if the leaf-ness can be
> determined by looking at the PTE, but perhaps that's not always
> possible.

Some explanation is probably owed here. I think you caught the detail
later on in the series, but I'm overloading flags to describe both the
requested visits and some properties about the walk (i.e. a SHARED
walk).

I tried to leave it sufficiently generic as there will be other
configuration bits we will want to stuff into a walker later on (such as
TLBI and CMO elision).

> Reviewed-by: Ben Gardon <bgardon@google.com>

Thanks!

--
Best,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
