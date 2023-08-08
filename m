Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F7E5E57E;
	Tue,  8 Aug 2023 10:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=jW2Ev2fEU+tZ64hL5Q4L57WV2mLp60uuQxKGj9Nz61U=; b=s+uSHykrxwdxki2XCrclKevIAH
	MJoGCh+i9DNbxuy9Na53KErR8H7nbUXpSigO/op8OE+3RGXWM5LaOzqfPIthDkpvgo1IsA+UJWAug
	87p0DNMySA2R+5nZ3uiFvMP5cE4bwxhgTwDQrVmO+OC0jG7S8m5NGVRY7mznI+kpPXdonsFX9kKum
	ZyJWgvFc8DA8QCKbRB+9E9x+B2+G4jq+7yYx2l0dXXwYR5inUcYTFGnq6Lv06a9G4kFdfupLt/JEZ
	v03/4eWvx2RNhBTrh2qRDOLfTyCHtSMFDQ2BdNWh/3mnGKGlTleqEwPZrTKoT9chs6NQnAzXRleV7
	yRcWrn3Q==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1qTKOh-00H2dm-Bd; Tue, 08 Aug 2023 10:57:07 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(Client did not present a certificate)
	by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id C876430010B;
	Tue,  8 Aug 2023 12:57:05 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
	id 8B9BE2038C087; Tue,  8 Aug 2023 12:57:05 +0200 (CEST)
Date: Tue, 8 Aug 2023 12:57:05 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Florian Weimer <fweimer@redhat.com>
Cc: Marco Elver <elver@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kees Cook <keescook@chromium.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Mark Rutland <mark.rutland@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Tom Rix <trix@redhat.com>, Miguel Ojeda <ojeda@kernel.org>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
	Dmitry Vyukov <dvyukov@google.com>,
	Alexander Potapenko <glider@google.com>, kasan-dev@googlegroups.com,
	linux-toolchains@vger.kernel.org,
	Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: [PATCH v2 1/3] compiler_types: Introduce the Clang
 __preserve_most function attribute
Message-ID: <20230808105705.GB212435@hirez.programming.kicks-ass.net>
References: <20230804090621.400-1-elver@google.com>
 <87il9rgjvw.fsf@oldenburg.str.redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87il9rgjvw.fsf@oldenburg.str.redhat.com>

On Mon, Aug 07, 2023 at 01:41:07PM +0200, Florian Weimer wrote:
> * Marco Elver:
> 
> > [1]: "On X86-64 and AArch64 targets, this attribute changes the calling
> > convention of a function. The preserve_most calling convention attempts
> > to make the code in the caller as unintrusive as possible. This
> > convention behaves identically to the C calling convention on how
> > arguments and return values are passed, but it uses a different set of
> > caller/callee-saved registers. This alleviates the burden of saving and
> > recovering a large register set before and after the call in the
> > caller."
> >
> > [1] https://clang.llvm.org/docs/AttributeReference.html#preserve-most
> 
> You dropped the interesting part:
> 
> | If the arguments are passed in callee-saved registers, then they will
> | be preserved by the callee across the call. This doesn’t apply for
> | values returned in callee-saved registers.
> | 
> |  ·  On X86-64 the callee preserves all general purpose registers, except
> |     for R11. R11 can be used as a scratch register. Floating-point
> |     registers (XMMs/YMMs) are not preserved and need to be saved by the
> |     caller.
> |     
> |  ·  On AArch64 the callee preserve all general purpose registers, except
> |     X0-X8 and X16-X18.
> 
> Ideally, this would be documented in the respective psABI supplement.
> I filled in some gaps and filed:
> 
>   Document the ABI for __preserve_most__ function calls
>   <https://gitlab.com/x86-psABIs/x86-64-ABI/-/merge_requests/45>
> 
> Doesn't this change impact the kernel module ABI?
> 
> I would really expect a check here

So in the GCC bugzilla you raise the point of unwinding.

So in arch/x86 we've beeing doing what this attribute proposes (except
without that weird r11 exception) for a long while.

We simply do: asm("call foo_thunk"); instead of a C call, and then
have the 'thunk' thing PUSH/POP all the registers around a regular C
function.

Paravirt does quite a lot of that as well.

In a very few cases we implement a function specifically to avoid all
the PUSH/POP nonsense because it's so small the stack overhead kills it.

For unwinding this means that the 'thunk' becomes invisible when IP is
not inside it. But since the thunk is purely 'uninteresting' PUSH/POP
around a real C call, this is not an issue.

[[ tail calls leaving their sibling invisible is a far more annoying
   issue ]]

If the function is one of those special things, then it will be a leaf
function and we get to see it throught he IP.


Now, the problem with __preserve_most is that it makes it really easy to
deviate from this pattern, you can trivially write a function that is
not a trivial wrapper and then does not show up on unwind. This might
indeed be a problem.

Ofc. the kernel doesn't longjmp much, and we also don't throw many
exxceptions, but the live-patch people might care (although ORC unwinder
should be able to deal with all this perfectly fine).

In userspace, would not .eh_frame still be able to unwind this?
