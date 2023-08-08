Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C789659;
	Tue,  8 Aug 2023 02:17:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EEB8C433C8;
	Tue,  8 Aug 2023 02:16:59 +0000 (UTC)
Date: Mon, 7 Aug 2023 22:16:58 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Florian Weimer <fweimer@redhat.com>, Marco Elver <elver@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Kees Cook
 <keescook@chromium.org>, Guenter Roeck <linux@roeck-us.net>, Mark Rutland
 <mark.rutland@arm.com>, Marc Zyngier <maz@kernel.org>, Oliver Upton
 <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, Suzuki K
 Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Nathan Chancellor <nathan@kernel.org>, Nick Desaulniers
 <ndesaulniers@google.com>, Tom Rix <trix@redhat.com>, Miguel Ojeda
 <ojeda@kernel.org>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
 Dmitry Vyukov <dvyukov@google.com>, Alexander Potapenko
 <glider@google.com>, kasan-dev@googlegroups.com,
 linux-toolchains@vger.kernel.org
Subject: Re: [PATCH v2 1/3] compiler_types: Introduce the Clang
 __preserve_most function attribute
Message-ID: <20230807221658.1d65ee28@gandalf.local.home>
In-Reply-To: <20230807123137.GA564305@hirez.programming.kicks-ass.net>
References: <20230804090621.400-1-elver@google.com>
	<87il9rgjvw.fsf@oldenburg.str.redhat.com>
	<20230807123137.GA564305@hirez.programming.kicks-ass.net>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 7 Aug 2023 14:31:37 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> > that this is not a compilation for a module.  Otherwise modules built
> > with a compiler with __preserve_most__ attribute support are
> > incompatible with kernels built with a compiler without that attribute.  
> 
> We have a metric ton of options that can break module ABI. If you're
> daft enough to not build with the exact same compiler and .config you
> get to keep the pieces.

I believe there's enough checks for various compiler options in order to
enable features during the build that trying to load a module built with
another compiler is pretty much guaranteed to fail today.

-- Steve
