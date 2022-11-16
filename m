Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A153FC433FE
	for <kvmarm@archiver.kernel.org>; Wed, 16 Nov 2022 07:15:37 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 104D64B8B9;
	Wed, 16 Nov 2022 02:15:37 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8MENz2W3KO1T; Wed, 16 Nov 2022 02:15:36 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 09EEC4B8D2;
	Wed, 16 Nov 2022 02:15:36 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0638E4B8B9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Nov 2022 02:15:35 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PLjeOfkb6lKD for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 Nov 2022 02:15:34 -0500 (EST)
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com
 [209.85.215.170])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 032E14B8A4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Nov 2022 02:15:33 -0500 (EST)
Received: by mail-pg1-f170.google.com with SMTP id 62so7518873pgb.13
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Nov 2022 23:15:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc:subject:date:message-id:reply-to;
 bh=jyttA9l5U2zfeLkz1BoPbTHDObwZ9U09dDfAmOF59co=;
 b=WFqq62z11REleJUcpbpVLlAz/I8zQKWQ+yMcq6YOPBsK8EeIRNA9fM/ZUz9I4p3IJ0
 C8q7ZZ6YcPejwgXCZeHT8NOcQqHHgth+qZN/42XgLiPLF9g6r2oyYVmdK/pmXqIV5zp5
 oO3TzCZ9K133Y3I1ptdzoqSH85jKM5JxoUXfufR57VP8Qg4tBegBGCSZ0cFl5DuUdy+u
 ii9NfgQVVV/orMxW0MIbmHtairHx9xnJtkFym2hXGxqC4xLPF4tSaZteayNFLdfPsceJ
 e6494BhU3c7sbxuPksbIPSv7e3/nHRbIWk+JhlG+s1twJBWOAvlDtRFsD3VS32+WuS08
 k0ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=jyttA9l5U2zfeLkz1BoPbTHDObwZ9U09dDfAmOF59co=;
 b=b9xhtTttPGB4w+t0ikP4s/yLMVrYQ3WzaLmz8XLS1iJ5fLkeqkqRc1RdLpitCLz88P
 aJxRQQ+uUyVe/g9SIzNpvjId1L4PPbE1+90MskZIWJn4mZuXwCoFlOoKW1GdHhCeAGBt
 XMUCXDgKIbcvVufGB1nuYHuP3VPFrufjHUWEXi6uMVrd9zz4gtwTJ9X0D9i9G6KgJGM4
 whxzgUuPUekeAfrXh8e7E2TmuJLatboRqvqkAWV5aEGa2APF2XWfsnHAIhhC8Rd5t/d6
 PZTLW1+KF/acGwjHydfJ4nUU50Zgj57tHArSzrnhMkJc38QzBNKYBtjkWS93eXOn6Fjk
 158A==
X-Gm-Message-State: ANoB5plEEkEyFlaVdbGiJrkWc/i8p28oUY9XQgKRF1J48zxjtJf75SU4
 wC8vBDgWc9P34sW79a5ltdSUFaIZ7Rvaahxf6HlzhQ==
X-Google-Smtp-Source: AA0mqf4qVAOrSxpdJT6zZt/NoVVD9G5rp2nauOK2/L5V//qjk/naZGSqn65Gl+5u9CTiAvh6VcZAIATmMtW/6CkBhjU=
X-Received: by 2002:a63:4a21:0:b0:46f:d9f:476 with SMTP id
 x33-20020a634a21000000b0046f0d9f0476mr18938299pga.468.1668582932759; 
 Tue, 15 Nov 2022 23:15:32 -0800 (PST)
MIME-Version: 1.0
References: <20221113163832.3154370-1-maz@kernel.org>
 <20221113163832.3154370-3-maz@kernel.org>
In-Reply-To: <20221113163832.3154370-3-maz@kernel.org>
From: Reiji Watanabe <reijiw@google.com>
Date: Tue, 15 Nov 2022 23:15:16 -0800
Message-ID: <CAAeT=FwTtzmarzq9evNoUvDXeWiBcfEpQUb-Ex4esROU8kfEsA@mail.gmail.com>
Subject: Re: [PATCH v4 02/16] KVM: arm64: PMU: Align chained counter
 implementation with architecture pseudocode
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
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

On Sun, Nov 13, 2022 at 8:38 AM Marc Zyngier <maz@kernel.org> wrote:
>
> Ricardo recently pointed out that the PMU chained counter emulation
> in KVM wasn't quite behaving like the one on actual hardware, in
> the sense that a chained counter would expose an overflow on
> both halves of a chained counter, while KVM would only expose the
> overflow on the top half.
>
> The difference is subtle, but significant. What does the architecture
> say (DDI0087 H.a):
>
> - Up to PMUv3p4, all counters but the cycle counter are 32bit
>
> - A 32bit counter that overflows generates a CHAIN event on the
>   adjacent counter after exposing its own overflow status
>
> - The CHAIN event is accounted if the counter is correctly
>   configured (CHAIN event selected and counter enabled)
>
> This all means that our current implementation (which uses 64bit
> perf events) prevents us from emulating this overflow on the lower half.
>
> How to fix this? By implementing the above, to the letter.
>
> This largly results in code deletion, removing the notions of

nit: s/largly/largely ?

> "counter pair", "chained counters", and "canonical counter".
> The code is further restructured to make the CHAIN handling similar
> to SWINC, as the two are now extremely similar in behaviour.
>
> Reported-by: Ricardo Koller <ricarkol@google.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Reiji Watanabe <reijiw@google.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
