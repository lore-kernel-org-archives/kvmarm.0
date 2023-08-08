Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71044F9DB
	for <kvmarm@lists.linux.dev>; Tue,  8 Aug 2023 11:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1691494874;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LpOwTgxUQueKTTwOJlS9a4DMbQJlgeLRkDEjrIokCAc=;
	b=W1R76Pd5JHa4J8xEGiVB1zzF5sHvUFfZV119p8OH3LfKSMcHXlBrcNWCh4Vdl79tXAQAfl
	HBVPbn4P21lrEU7yNESpmQgcQr+61t9WWmwfxDbvRNKlCzpcxF2BmFYei2mDcnglw8iugv
	/tThSyEto6mHl3cOo7cCCRDNkdKdzic=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-678-x_BVl-L4N6OBZSXsqfsgqg-1; Tue, 08 Aug 2023 07:41:11 -0400
X-MC-Unique: x_BVl-L4N6OBZSXsqfsgqg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CFA37381AE42;
	Tue,  8 Aug 2023 11:41:09 +0000 (UTC)
Received: from oldenburg.str.redhat.com (unknown [10.2.16.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 462E41121314;
	Tue,  8 Aug 2023 11:41:06 +0000 (UTC)
From: Florian Weimer <fweimer@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Marco Elver <elver@google.com>,  Andrew Morton
 <akpm@linux-foundation.org>,  Kees Cook <keescook@chromium.org>,  Guenter
 Roeck <linux@roeck-us.net>,  Mark Rutland <mark.rutland@arm.com>,  Steven
 Rostedt <rostedt@goodmis.org>,  Marc Zyngier <maz@kernel.org>,  Oliver
 Upton <oliver.upton@linux.dev>,  James Morse <james.morse@arm.com>,
  Suzuki K Poulose <suzuki.poulose@arm.com>,  Zenghui Yu
 <yuzenghui@huawei.com>,  Catalin Marinas <catalin.marinas@arm.com>,  Will
 Deacon <will@kernel.org>,  Nathan Chancellor <nathan@kernel.org>,  Nick
 Desaulniers <ndesaulniers@google.com>,  Tom Rix <trix@redhat.com>,  Miguel
 Ojeda <ojeda@kernel.org>,  linux-arm-kernel@lists.infradead.org,
  kvmarm@lists.linux.dev,  linux-kernel@vger.kernel.org,
  llvm@lists.linux.dev,  Dmitry Vyukov <dvyukov@google.com>,  Alexander
 Potapenko <glider@google.com>,  kasan-dev@googlegroups.com,
  linux-toolchains@vger.kernel.org,  Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: [PATCH v2 1/3] compiler_types: Introduce the Clang
 __preserve_most function attribute
References: <20230804090621.400-1-elver@google.com>
	<87il9rgjvw.fsf@oldenburg.str.redhat.com>
	<20230808105705.GB212435@hirez.programming.kicks-ass.net>
Date: Tue, 08 Aug 2023 13:41:05 +0200
In-Reply-To: <20230808105705.GB212435@hirez.programming.kicks-ass.net> (Peter
	Zijlstra's message of "Tue, 8 Aug 2023 12:57:05 +0200")
Message-ID: <87pm3xhicu.fsf@oldenburg.str.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3

* Peter Zijlstra:

> Now, the problem with __preserve_most is that it makes it really easy to
> deviate from this pattern, you can trivially write a function that is
> not a trivial wrapper and then does not show up on unwind. This might
> indeed be a problem.

Backtrace generation shouldn't be impacted by a compiler implementation
of __preserve_most__.  If unwinding implies restoring register contents,
the question becomes whether the unwinder can be taught to do this
natively.  For .eh_frame/PT_GNU_EH_FRAME-based unwinders and
__preserve_most__, I think that's true because they already support
custom ABIs (and GCC uses them for local functions).  In other cases, if
the unwinder does not support the extra registers, then it might still
be possible to compensate for that via code generation (e.g., setjmp
won't be __preserve_most__, so the compiler would have to preserve
register contents by other means, also accounting for the returns-twice
nature, likewise for exception handling landing pads).

But __preserve_all__ is a completely different beast.  I *think* it is
possible to do this with helpers (state size, state save, state restore)
and strategically placed restores after returns-twice functions and the
like, but people disagree.  This has come up before in the context of
the s390x vector ABI and the desire to add new callee-saved registers.
We just couldn't make that work at the time.  On the other hand,
__preserve_all__ goes into the other direction (opt-in of extra saves),
so it may be conceptually easier.

Thanks,
Florian

