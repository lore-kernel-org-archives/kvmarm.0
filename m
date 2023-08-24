Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7410F100DC
	for <kvmarm@lists.linux.dev>; Thu, 24 Aug 2023 15:43:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D722EC433C8;
	Thu, 24 Aug 2023 15:43:23 +0000 (UTC)
Date: Thu, 24 Aug 2023 16:43:19 +0100
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
Message-ID: <ZOd6lzj29VksAp7L@arm.com>
References: <f4cec4b3-c386-4873-aa1d-90528e062f2a@sirena.org.uk>
 <ZN+qki9EaZ6f9XNi@arm.com>
 <aaea542c-929c-4c9b-8caa-ca67e0eb9c1e@sirena.org.uk>
 <ZOTnL1SDJWZjHPUW@arm.com>
 <43ec219d-bf20-47b8-a5f8-32bc3b64d487@sirena.org.uk>
 <ZOXa98SqwYPwxzNP@arm.com>
 <227e6552-353c-40a9-86c1-280587a40e3c@sirena.org.uk>
 <ZOY3lz+Zyhd5ZyQ9@arm.com>
 <ZOZEmO6WGyVAcOqK@arm.com>
 <ef7272d2-d807-428f-9915-6fc9febadb5c@sirena.org.uk>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ef7272d2-d807-428f-9915-6fc9febadb5c@sirena.org.uk>

On Wed, Aug 23, 2023 at 07:16:52PM +0100, Mark Brown wrote:
> On Wed, Aug 23, 2023 at 06:40:40PM +0100, Szabolcs Nagy wrote:
> > i don't know if we can allow disabled gcs thread creation with locked
> > gcs state. (i can see arguments both ways, so further prctl flag may
> > be needed which may be another divergence from x86)
> 
> I think that if we do add a new flag that'd just be new functionality,
> the divergence would be in allowing configuration via clone3() rather
> than the flag.  TBH I'm not sure I see a use case for locking but
> providing a mechanism for getting out of the lock, that seems very
> questionable.

You are right, once the configuration is locked a plain clone() or
clone3() without a GCS pointer should be rejected.

Is there a use-case for the unlocked configuration to allow disabling
the GCS implicitly via a clone syscall?

If we go for extending clone3, I wonder whether we should also introduce
a sigaltstack2/3 ;). I haven't checked what the current patches do and
won't have time until early September (on holiday from the end of today).

-- 
Catalin
