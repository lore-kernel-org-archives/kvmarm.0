Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1524EC54EE9
	for <kvmarm@archiver.kernel.org>; Tue, 20 Sep 2022 02:13:28 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6219E4B658;
	Mon, 19 Sep 2022 22:13:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UpaI4C9vBsr0; Mon, 19 Sep 2022 22:13:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4C9CF4B62F;
	Mon, 19 Sep 2022 22:13:27 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 355744B615
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Sep 2022 22:13:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3eM2A1uXWsVu for <kvmarm@lists.cs.columbia.edu>;
 Mon, 19 Sep 2022 22:13:25 -0400 (EDT)
Received: from mail-vs1-f45.google.com (mail-vs1-f45.google.com
 [209.85.217.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 527BE4B2A5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Sep 2022 22:13:25 -0400 (EDT)
Received: by mail-vs1-f45.google.com with SMTP id q26so1563167vsr.7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Sep 2022 19:13:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc:subject:date;
 bh=LhprL2QVbzky7ZAXaXmKaCG2fZ/bG0UYXk9tOS7aXnY=;
 b=PGCJcjWLr4SHxMv8ivTAMamCPU/lkKK0dFqBEfZy+Xoh/g4UvHR8Tjalko7fnj29cf
 ECXwL9kH/aqs1iN4dEjp98ccsT9UZFvlEjmNb1ZOmBEMuslU7MeQ+dvTUeavKDHKQWkT
 Q4sdG5mzJs1M66f2/yOjLYV7Mr23g9I1tPE7KgDV5IWqbQPWUM6r7hi+cwY1VQ4e6HAG
 iYFfrDkQCOw8EuUPf0ygxePt4Cp2eXiDyNWgfI/4cE1WmmdejsR0gyunDCIeYe34a7rH
 /0OIP5YArMqkI2DI5zSGm4n52uKi+aoQYTAKw2OM/X8C/CcDvnsTdize+LSbiPaahbN2
 sv7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date;
 bh=LhprL2QVbzky7ZAXaXmKaCG2fZ/bG0UYXk9tOS7aXnY=;
 b=ToIIVlVnR+e69HR7QAN9124QbOROJY2l0NFDJ3uYqbz/3wdPpHQdkFkk+EMbKEF5Pa
 OVpWSTrQGfrl/Eq/IJJ6Mshpwh0/eRENxJyXlyfEr/1s1cbus3RBLbDMBo0pikJfQTmp
 B79bT3CCo3w+SUMxKU/wIEOKC4kEqHAoaEWOSkrL3c45Q9HntdbpgBluxp+63DURE0n0
 XaWvgiyPze5u/R/oyMqF+02mXUZLUgzJGh/3B6hhSHQFDGYclp/tZjqleqFTscwH6n/y
 rczWbQODxq+y8asjScdkE8AKEWxpOItUwj3anmvVjy/AnrGwVFr3DTVNIyUoX/XzdpWw
 79yQ==
X-Gm-Message-State: ACrzQf04ai6bhHNYRNDpQQrUZfjLPth5wmm/OjXp+Ye7mkltLMjWGgVA
 PUxRunOKvFGtKhcGvmxQAKfB+EHKkq23Y5LFxkATAw==
X-Google-Smtp-Source: AMsMyM7wgUY6E8j/4SMw+/72+ih55ve9ug7EcEf9GLIsdD3MXqyNwHc4oK+hZoFAn5gEb/6kdxZ6GEWk15PY0d04huI=
X-Received: by 2002:a67:ea58:0:b0:38f:d89a:e4b3 with SMTP id
 r24-20020a67ea58000000b0038fd89ae4b3mr7517244vso.51.1663640004802; Mon, 19
 Sep 2022 19:13:24 -0700 (PDT)
MIME-Version: 1.0
References: <20220917010600.532642-1-reijiw@google.com>
 <20220917010600.532642-5-reijiw@google.com>
 <87bkrbln84.wl-maz@kernel.org>
In-Reply-To: <87bkrbln84.wl-maz@kernel.org>
From: Reiji Watanabe <reijiw@google.com>
Date: Mon, 19 Sep 2022 19:13:08 -0700
Message-ID: <CAAeT=FwN+5=1SjaHqpE2PCaa0H4_pkdz-OsTiRfd-WOzYaCNpw@mail.gmail.com>
Subject: Re: [PATCH v2 4/4] KVM: arm64: selftests: Add a test case for
 KVM_GUESTDBG_SINGLESTEP
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 kvmarm@lists.cs.columbia.edu, Linux ARM <linux-arm-kernel@lists.infradead.org>
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

On Mon, Sep 19, 2022 at 2:36 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Sat, 17 Sep 2022 02:06:00 +0100,
> Reiji Watanabe <reijiw@google.com> wrote:
> >
> > Add a test case for KVM_GUESTDBG_SINGLESTEP to the debug-exceptions test.
> > The test enables single-step execution from userspace, and check if the
> > exit to userspace occurs for each instruction that is stepped.
> > Set the default number of the test iterations to a number of iterations
> > sufficient to always reproduce the problem that the previous patch fixes
> > on an Ampere Altra machine.
>
> A possibly more aggressive version of this test would be to force a
> (short lived) timer to fire on the same CPU, forcing an exit. This
> should hopefully result in a more predictable way to trigger the
> issue. But that's a reasonable test as a start.

Yes, that could result in a more predictable way to cause the specific case!
I will consider this at a future opportunity.

Thank you,
Reiji
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
