Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ECA87F
	for <kvmarm@lists.linux.dev>; Wed, 16 Nov 2022 07:15:33 +0000 (UTC)
Received: by mail-pg1-f175.google.com with SMTP id q71so15860254pgq.8
        for <kvmarm@lists.linux.dev>; Tue, 15 Nov 2022 23:15:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
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
        b=ZIjXy55p/KdiU+wgEGVNQtPs/hWRtgqVSFT2LadezL/n7TRJVYl276qmjcSAehHLNO
         /TynzIm6KvwyN8wy9mm+aLKvFdfmmpeq87ORxhfesAHCwWYHB+LGGub98NsqzfWUIbt+
         0Nl0ZIuFaSs6z7/ptAIQoCM1yKkUdxn1A/VH1J6KocdxGr8ahHoxlAqPKV35ms4GFC9h
         fro68iNes8vc7a2K5mzvto92nmKTrfjMsr/sk8VarxBNfX5kkmqMj98FxZorWyLbZXpl
         h7I2yYx9e1MAeO4eTJ7m3CXifqXQVkZhN/Ey2TxGg3NWfcmi3EgSJMTXEgL4oK0mKgah
         x5XA==
X-Gm-Message-State: ANoB5pkQnph9R6zHuRBAuEEy0kBX8TldZmdlgZpQE0hG9o5z1dLsm1lr
	UrClQWimJULExmw1pHP8PoEsDsb9AxRliyYBc1k0Iw==
X-Google-Smtp-Source: AA0mqf4qVAOrSxpdJT6zZt/NoVVD9G5rp2nauOK2/L5V//qjk/naZGSqn65Gl+5u9CTiAvh6VcZAIATmMtW/6CkBhjU=
X-Received: by 2002:a63:4a21:0:b0:46f:d9f:476 with SMTP id x33-20020a634a21000000b0046f0d9f0476mr18938299pga.468.1668582932759;
 Tue, 15 Nov 2022 23:15:32 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221113163832.3154370-1-maz@kernel.org> <20221113163832.3154370-3-maz@kernel.org>
In-Reply-To: <20221113163832.3154370-3-maz@kernel.org>
From: Reiji Watanabe <reijiw@google.com>
Date: Tue, 15 Nov 2022 23:15:16 -0800
Message-ID: <CAAeT=FwTtzmarzq9evNoUvDXeWiBcfEpQUb-Ex4esROU8kfEsA@mail.gmail.com>
Subject: Re: [PATCH v4 02/16] KVM: arm64: PMU: Align chained counter
 implementation with architecture pseudocode
To: Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <20221116071516.nHbFtFJIRWxDS88Fc-kZ99fHLocANtO1WUK6OYXXzSg@z>

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
