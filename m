Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACFE56D22;
	Wed,  2 Aug 2023 18:03:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64E5EC433C9;
	Wed,  2 Aug 2023 18:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1690999385;
	bh=b3H1cxTxktEnjXl+iExW/YcKRfU1BuhonrjVJGBbVXY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=2Nmf/GfPEkagF9BmZl/oPNQfos2XuRpiubItnG9HrgJX4XueGbgDG2UGKJAUVJy/r
	 FBg7gFXRVOU8DbSBGdtmS0/rfnaquGaBhHiYQoAOsVOsIGq7SOMeugtLr9/uyaM/Ox
	 gX/17ad4oY8MT9g0HDCZS34KX6zvvb3mBpCF8an8=
Date: Wed, 2 Aug 2023 11:03:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Marco Elver <elver@google.com>
Cc: Kees Cook <keescook@chromium.org>, Guenter Roeck <linux@roeck-us.net>,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, James
 Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
 Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas
 <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Miguel Ojeda
 <ojeda@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, Nathan
 Chancellor <nathan@kernel.org>, Tom Rix <trix@redhat.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 linux-kernel@vger.kernel.org, llvm@lists.linux.dev, Dmitry Vyukov
 <dvyukov@google.com>, Alexander Potapenko <glider@google.com>,
 kasan-dev@googlegroups.com, linux-toolchains@vger.kernel.org
Subject: Re: [PATCH 1/3] Compiler attributes: Introduce the __preserve_most
 function attribute
Message-Id: <20230802110303.1e3ceeba5a96076f723d1d08@linux-foundation.org>
In-Reply-To: <20230802150712.3583252-1-elver@google.com>
References: <20230802150712.3583252-1-elver@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed,  2 Aug 2023 17:06:37 +0200 Marco Elver <elver@google.com> wrote:

> [1]: "On X86-64 and AArch64 targets, this attribute changes the calling
> convention of a function. The preserve_most calling convention attempts
> to make the code in the caller as unintrusive as possible. This
> convention behaves identically to the C calling convention on how
> arguments and return values are passed, but it uses a different set of
> caller/callee-saved registers. This alleviates the burden of saving and
> recovering a large register set before and after the call in the
> caller."
> 
> [1] https://clang.llvm.org/docs/AttributeReference.html#preserve-most
> 
> Use of this attribute results in better code generation for calls to
> very rarely called functions, such as error-reporting functions, or
> rarely executed slow paths.
> 
> Introduce the attribute to compiler_attributes.h.

That sounds fairly radical.  And no changes are needed for assembly
code or asm statements?

I'll add "LLVM" to the patch title to make it clear that gcc isn't
affected.

