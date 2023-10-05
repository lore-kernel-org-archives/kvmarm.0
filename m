Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A125030D05
	for <kvmarm@lists.linux.dev>; Thu,  5 Oct 2023 17:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E350DC433C8;
	Thu,  5 Oct 2023 17:23:12 +0000 (UTC)
Date: Thu, 5 Oct 2023 18:23:10 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Mark Brown <broonie@kernel.org>
Cc: Szabolcs Nagy <Szabolcs.Nagy@arm.com>, Will Deacon <will@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Arnd Bergmann <arnd@arndb.de>, Oleg Nesterov <oleg@redhat.com>,
	Eric Biederman <ebiederm@xmission.com>,
	Kees Cook <keescook@chromium.org>, Shuah Khan <shuah@kernel.org>,
	"Rick P. Edgecombe" <rick.p.edgecombe@intel.com>,
	Deepak Gupta <debug@rivosinc.com>, Ard Biesheuvel <ardb@kernel.org>,
	"H.J. Lu" <hjl.tools@gmail.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
	kvmarm@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	linux-arch@vger.kernel.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org
Subject: Re: [PATCH v4 03/36] arm64/gcs: Document the ABI for Guarded Control
 Stacks
Message-ID: <ZR7w/mr0xZbpIPc5@arm.com>
References: <ZN+qki9EaZ6f9XNi@arm.com>
 <aaea542c-929c-4c9b-8caa-ca67e0eb9c1e@sirena.org.uk>
 <ZOTnL1SDJWZjHPUW@arm.com>
 <43ec219d-bf20-47b8-a5f8-32bc3b64d487@sirena.org.uk>
 <ZOXa98SqwYPwxzNP@arm.com>
 <ZOYFazB1gYjzDRdA@arm.com>
 <ZRWw7aa3C0LlMPTH@arm.com>
 <38edb5c3-367e-4ab7-8cb7-aa1a5c0e330c@sirena.org.uk>
 <ZRvUxLgMse8QYlGS@arm.com>
 <a7d2fd66-c06b-4033-bca2-4b14afc4904f@sirena.org.uk>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a7d2fd66-c06b-4033-bca2-4b14afc4904f@sirena.org.uk>

On Tue, Oct 03, 2023 at 03:26:51PM +0100, Mark Brown wrote:
> On Tue, Oct 03, 2023 at 09:45:56AM +0100, Szabolcs Nagy wrote:
> > clone3 seems to have features that are only available in clone3 and
> > not exposed (reasonably) in libc apis so ppl will use clone3 directly
> > and those will be hard to fix for gcs (you have to convince upstream
> > to add future arm64 arch specific changes that they cannot test).
> 
> Ah, I hadn't realised that there were things that weren't available via
> libc - that does change the calculation a bit here.  I would hope that
> anything we do for clone3() would work just as well for x86 so the test
> side should be a bit easier there than if it were a future arm64 thing,
> though obviously it wouldn't be mandatory on x86 in the way that Catalin
> wanted it for arm64.

I haven't checked how many clone() or clone3() uses outside the libc are
(I tried some quick search in Debian but did not dig into the specifics
to see how generic that code is). I agree that having to change valid
cases outside of libc is not ideal. Even if we have the same clone3()
interface for x86 and arm64, we'd have other architectures that need
#ifdef'ing.

So I'm slightly warming up to the idea of having a default shadow stack
size (either RLIMIT_STACK or the clone3() stack size, following x86). A
clone3() extension can be added on top, though I wonder whether anyone
will use it if the kernel allocates a shadow stack by default.

It's not just the default size that I dislike (I think the x86
RLIMIT_STACK or clone3() stack_size is probably good enough) but the
kernel allocating the shadow stack and inserting it into the user
address space. The actual thread stack is managed by the user but the
shadow stack is not (and we don't do this very often). Anyway, I don't
have a better solution for direct uses of clone() or clone3(), other
than running those threads with the shadow stack disabled. Not sure
that's desirable.

-- 
Catalin
