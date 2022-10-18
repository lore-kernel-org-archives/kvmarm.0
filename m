Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C5B9C433FE
	for <kvmarm@archiver.kernel.org>; Tue, 18 Oct 2022 07:47:28 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BC9BF4B642;
	Tue, 18 Oct 2022 03:47:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 07tb1hkAbl4y; Tue, 18 Oct 2022 03:47:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 722B34B84C;
	Tue, 18 Oct 2022 03:47:26 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 931084B63A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Oct 2022 03:47:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Pvw+wWJHgHx6 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 18 Oct 2022 03:47:24 -0400 (EDT)
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 43C194B632
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Oct 2022 03:47:24 -0400 (EDT)
Date: Tue, 18 Oct 2022 10:47:20 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1666079243;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=Ke4w2J4dPe970jTSZLZN8cLPPnUzQU8Z6qS3Lkrav70=;
 b=YC9fUGhUeXTcSyZMEAKTWIKcDRzJRHKx0IbN3ZVNp6BBHCW9o42o8LmMKrxFhifBU/tX+A
 LHyq2wm8Bl0pyy58F85pv55QeARQ4XT5/pVoqW6cV3b0CHQcrLC9fk/2N7s1XQTqvpl9qt
 PkJdPcfa5W5Tna4u9YTlYPakG77WE8s=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH 5/6] KVM: selftests: memslot_perf_test: Consolidate
 memory sizes
Message-ID: <Y05aCJH+BBo+Y+nh@google.com>
References: <20221014071914.227134-1-gshan@redhat.com>
 <20221014071914.227134-6-gshan@redhat.com>
 <cebafa0d-a2dc-c3f7-64c8-2637a254e3d0@maciej.szmigiero.name>
 <Y03ScGUUCA1KwlLF@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <Y03ScGUUCA1KwlLF@google.com>
X-Migadu-Flow: FLOW_OUT
Cc: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>, kvm@vger.kernel.org,
 maz@kernel.org, linux-kernel@vger.kernel.org, zhenyzha@redhat.com,
 shan.gavin@gmail.com, kvmarm@lists.linux.dev, pbonzini@redhat.com,
 shuah@kernel.org, kvmarm@lists.cs.columbia.edu, ajones@ventanamicro.com
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

On Mon, Oct 17, 2022 at 10:08:48PM +0000, Sean Christopherson wrote:
> On Mon, Oct 17, 2022, Maciej S. Szmigiero wrote:
> > > +#define MEM_EXTRA_SIZE		0x10000
> >
> > Also, an expression like "(64 << 10)" is more readable than a "1"
> > with a tail of zeroes (it's easy to add one zero too many or be one
> > zero short).
> 
> +1 to not open coding raw numbers.
> 
> I think it's high time KVM selftests add #defines for the common sizes, e.g. SIZE_4KB,
> 16KB, 64K, 2MB, 1GB, etc...
> 
> Alternatively (or in addition), just #define 1KB, 1MB, 1GB, and 1TB, and then do
> math off of those.

I mean I love boilerplate as much as the next guy, but we can just use
tools/include/linux/sizes.h

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
