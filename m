Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9B7CC4332F
	for <kvmarm@archiver.kernel.org>; Sun,  6 Feb 2022 20:29:07 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 266614083E;
	Sun,  6 Feb 2022 15:29:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@infradead.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id g4aX8IO97qi0; Sun,  6 Feb 2022 15:29:02 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A00214089E;
	Sun,  6 Feb 2022 15:29:02 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B1C5C4086D
 for <kvmarm@lists.cs.columbia.edu>; Sun,  6 Feb 2022 15:29:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qRb3zYP+Fhx0 for <kvmarm@lists.cs.columbia.edu>;
 Sun,  6 Feb 2022 15:28:58 -0500 (EST)
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D27D74083E
 for <kvmarm@lists.cs.columbia.edu>; Sun,  6 Feb 2022 15:28:58 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
 References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description;
 bh=7i3Z46f5V98hV+7wSTAkWTsI05L/w170G6IYhhzBpJA=; b=LTZUCqL9Z3AVQpPhC89N2wQE/C
 YdGgOE1ts3Gu9PU8GOjbz4eCamBzlB/KgHkxoDvcBviMgkTQhkBe9WHUehrTo/WvD10IIuNK+Ff7k
 3IQH1lm5ymPtJtvqFFK3yULXa8hD5OViN/myVM7rlPRRzc4UccEswil6Fm69OyxKdV8xWEjCYhl+S
 WQ/MFu0/O8jyETbb6MqCdHb/i84MyngV/2XAr6K28PxPENXi/kM9GqjIUfsiapg7SkXIP+XGXdCtU
 xyrbvaM3yTboYVCL0+OvEir4eQ2qIraGZYDAnt5coom3Iuh5Y2VVy78vZCKfeZpM3IU89MSE98rt/
 NetFg+qg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100]
 helo=noisy.programming.kicks-ass.net)
 by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
 id 1nGo9W-007XVO-KM; Sun, 06 Feb 2022 20:28:54 +0000
Received: from hirez.programming.kicks-ass.net
 (hirez.programming.kicks-ass.net [192.168.1.225])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
 (Client did not present a certificate)
 by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 4A9503001C7;
 Sun,  6 Feb 2022 21:28:52 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
 id 321F621378EDF; Sun,  6 Feb 2022 21:28:52 +0100 (CET)
Date: Sun, 6 Feb 2022 21:28:52 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v4 09/17] perf/core: Use static_call to optimize
 perf_guest_info_callbacks
Message-ID: <YgAvhG4wvnslbTqP@hirez.programming.kicks-ass.net>
References: <20211111020738.2512932-1-seanjc@google.com>
 <20211111020738.2512932-10-seanjc@google.com>
 <YfrQzoIWyv9lNljh@google.com>
 <CABCJKufg=ONNOvF8+BRXfLoTUfeiZZsdd8TnpV-GaNK_o-HuaA@mail.gmail.com>
 <202202061011.A255DE55B@keescook>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <202202061011.A255DE55B@keescook>
Cc: Will McVicker <willmcvicker@google.com>, kvm@vger.kernel.org,
 LKML <linux-kernel@vger.kernel.org>, Sami Tolvanen <samitolvanen@google.com>,
 kvmarm <kvmarm@lists.cs.columbia.edu>,
 linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
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

On Sun, Feb 06, 2022 at 10:45:15AM -0800, Kees Cook wrote:

> I'm digging through the macros to sort this out, but IIUC, an example of
> the problem is:
> 

> so the caller is expecting "unsigned int (*)(void)" but the prototype
> of __static_call_return0 is "long (*)(void)":
> 
> long __static_call_return0(void);
> 
> Could we simply declare a type-matched ret0 trampoline too?

That'll work for this case, but the next case the function will have
arguments we'll need even more nonsense...

And as stated in that other email, there's tb_stub_func() having the
exact same problem as well.

The x86_64 CFI patches had a work-around for this, that could trivially
be lifted I suppose.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
