Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A64818046;
	Tue, 15 Aug 2023 21:31:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86368C433C7;
	Tue, 15 Aug 2023 21:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1692135079;
	bh=44nqP2+rxiy7+ftu8/29+SQO1/KKAl9lLgkE77FHuY4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=YyXw8OtB8+epu6GxFCTIj+gPfAAr6vEVhPfH+wAeOv3CBXWv3k3PiSzFwcVmmJmKj
	 uF6x18yOD+YZVo/NH0RA4cGatztWvfHlJqBZj0HeaiOShfXh4yL3xQmTTXrsV3w7We
	 JG6tFkYpAfzVHJrga/A5tBGJYVJr7TVhiFSAyDFs=
Date: Tue, 15 Aug 2023 14:31:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kees Cook <keescook@chromium.org>
Cc: Marco Elver <elver@google.com>, Guenter Roeck <linux@roeck-us.net>,
 Peter Zijlstra <peterz@infradead.org>, Mark Rutland <mark.rutland@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>, Marc Zyngier <maz@kernel.org>, Oliver
 Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, Suzuki K
 Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, Paul Moore <paul@paul-moore.com>, James
 Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, Nathan
 Chancellor <nathan@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>,
 Tom Rix <trix@redhat.com>, Miguel Ojeda <ojeda@kernel.org>, Sami Tolvanen
 <samitolvanen@google.com>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-security-module@vger.kernel.org, llvm@lists.linux.dev, Dmitry Vyukov
 <dvyukov@google.com>, Alexander Potapenko <glider@google.com>,
 kasan-dev@googlegroups.com, linux-toolchains@vger.kernel.org
Subject: Re: [PATCH v4 1/4] compiler_types: Introduce the Clang
 __preserve_most function attribute
Message-Id: <20230815143116.17baaae9b91e1f1708c928a8@linux-foundation.org>
In-Reply-To: <202308141620.E16B93279@keescook>
References: <20230811151847.1594958-1-elver@google.com>
	<202308141620.E16B93279@keescook>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 14 Aug 2023 16:21:43 -0700 Kees Cook <keescook@chromium.org> wrote:

> Should this go via -mm, the hardening tree, or something else? I'm happy
> to carry it if no one else wants it?

Please do so.
