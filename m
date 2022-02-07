Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0EE4C433EF
	for <kvmarm@archiver.kernel.org>; Mon,  7 Feb 2022 02:56:02 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1DF4D49E22;
	Sun,  6 Feb 2022 21:56:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@chromium.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hxUN0B5twncC; Sun,  6 Feb 2022 21:56:00 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AF9EF49E29;
	Sun,  6 Feb 2022 21:56:00 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B3C4F49E22
 for <kvmarm@lists.cs.columbia.edu>; Sun,  6 Feb 2022 21:55:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ntNepOGbMzy6 for <kvmarm@lists.cs.columbia.edu>;
 Sun,  6 Feb 2022 21:55:58 -0500 (EST)
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com
 [209.85.210.180])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2BD0C49B26
 for <kvmarm@lists.cs.columbia.edu>; Sun,  6 Feb 2022 21:55:58 -0500 (EST)
Received: by mail-pf1-f180.google.com with SMTP id i186so10636025pfe.0
 for <kvmarm@lists.cs.columbia.edu>; Sun, 06 Feb 2022 18:55:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chromium.org; s=google;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=2Pa0V6uNmqfY1ryqz8Euha/wH0C0Ls7fitkB4Pk5MqA=;
 b=gRAy4PoGc6tworsSuNdh30bSZQIj9aWCyJMXg0AshOgRXWF3uHuOAwnvny2SfX5X9L
 kZ0MQf0StanDgY9gtsakTJJlP0m+u6Klf4IYOPKO1rIjoD10FJjy9pjQaW7ROoUUrOC6
 NPztgeTkHnfAGYppVDGgBG/GOze2NmDg+3Enw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=2Pa0V6uNmqfY1ryqz8Euha/wH0C0Ls7fitkB4Pk5MqA=;
 b=lsq7XPn3s0pUIQd681mz5pkJtTFKxa9ytKtHG6PFhcc62xKVyueeMbrbV6TG23Ily9
 U4NaRna55y4jLGvek8qT4HfEa4uN4At6k46w1Sopg51VRhIzn9nUCWBQVDnpXTRd3Z9Z
 Pjica6lProWHO7PnEcLSQoT5EMPjFxm68bzFqk2pmZDmUBrdLI12ST3RBZBfuMBLeDHB
 +RBtKWnhHnmKH9ucO0O9/vx7Ek3pD6+xHEmxn7mTksq/akRTxqthJ5Ld9u5/1d57rkfr
 pJ0EHi+E5janG8fewt7Ly8DIlbC2OFMnYkqrb+OtwY5GVUiHlmxEvt1Xua1WTtQ71MXk
 obyw==
X-Gm-Message-State: AOAM5318OR/Eao1LxduV2Kxc5khcn73GZmEAAzBrAF404uDbnFoRwtjn
 YEc0TYqfwNEVgwFgf4KaZJRr3A==
X-Google-Smtp-Source: ABdhPJwHPVPoUNs7X6rVF0qEiMM2Yz+rYinp0zhxBkrnP/OdvFlTr0vh4/W4vp+6BQZPaSJE/nM/WA==
X-Received: by 2002:a65:48c5:: with SMTP id o5mr7729001pgs.284.1644202557293; 
 Sun, 06 Feb 2022 18:55:57 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
 by smtp.gmail.com with ESMTPSA id nv13sm9221650pjb.17.2022.02.06.18.55.56
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sun, 06 Feb 2022 18:55:56 -0800 (PST)
Date: Sun, 6 Feb 2022 18:55:56 -0800
From: Kees Cook <keescook@chromium.org>
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v4 09/17] perf/core: Use static_call to optimize
 perf_guest_info_callbacks
Message-ID: <202202061854.B5B11282@keescook>
References: <20211111020738.2512932-1-seanjc@google.com>
 <20211111020738.2512932-10-seanjc@google.com>
 <YfrQzoIWyv9lNljh@google.com>
 <CABCJKufg=ONNOvF8+BRXfLoTUfeiZZsdd8TnpV-GaNK_o-HuaA@mail.gmail.com>
 <202202061011.A255DE55B@keescook>
 <YgAvhG4wvnslbTqP@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <YgAvhG4wvnslbTqP@hirez.programming.kicks-ass.net>
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

On Sun, Feb 06, 2022 at 09:28:52PM +0100, Peter Zijlstra wrote:
> On Sun, Feb 06, 2022 at 10:45:15AM -0800, Kees Cook wrote:
> 
> > I'm digging through the macros to sort this out, but IIUC, an example of
> > the problem is:
> > 
> 
> > so the caller is expecting "unsigned int (*)(void)" but the prototype
> > of __static_call_return0 is "long (*)(void)":
> > 
> > long __static_call_return0(void);
> > 
> > Could we simply declare a type-matched ret0 trampoline too?
> 
> That'll work for this case, but the next case the function will have
> arguments we'll need even more nonsense...

Shouldn't the typeof() work there too, though? I.e. as long as the
return value can hold a "0", it'd work.

> And as stated in that other email, there's tb_stub_func() having the
> exact same problem as well.

Yeah, I'd need to go look at that again.

> The x86_64 CFI patches had a work-around for this, that could trivially
> be lifted I suppose.

Yeah, I think it'd be similar. I haven't had a chance to go look at that
again...

-- 
Kees Cook
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
