Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A5952B540
	for <kvmarm@lists.linux.dev>; Tue, 22 Aug 2023 16:50:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21995C433C8;
	Tue, 22 Aug 2023 16:49:55 +0000 (UTC)
Date: Tue, 22 Aug 2023 17:49:51 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Mark Brown <broonie@kernel.org>
Cc: Will Deacon <will@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
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
	Szabolcs Nagy <Szabolcs.Nagy@arm.com>,
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
Message-ID: <ZOTnL1SDJWZjHPUW@arm.com>
References: <20230807-arm64-gcs-v4-0-68cfa37f9069@kernel.org>
 <20230807-arm64-gcs-v4-3-68cfa37f9069@kernel.org>
 <ZNOhjrYleGBR6Pbs@arm.com>
 <f4cec4b3-c386-4873-aa1d-90528e062f2a@sirena.org.uk>
 <ZN+qki9EaZ6f9XNi@arm.com>
 <aaea542c-929c-4c9b-8caa-ca67e0eb9c1e@sirena.org.uk>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aaea542c-929c-4c9b-8caa-ca67e0eb9c1e@sirena.org.uk>

On Fri, Aug 18, 2023 at 08:38:02PM +0100, Mark Brown wrote:
> On Fri, Aug 18, 2023 at 06:29:54PM +0100, Catalin Marinas wrote:
> > A related question - it may have been discussed intensively on the x86
> > thread (I may read it sometime) - why not have the libc map the shadow
> 
> Your assumption that this is a single thread feels optimistic there.

Yeah and I unfortunately ignored all of them.

> > stack and pass the pointer/size to clone3()? It saves us from having to
> > guess what the right size we'd need. struct clone_args is extensible.
> 
> I can't recall or locate the specific reasoning there right now, perhaps
> Rick or someone else can?  I'd guess there would be compat concerns for
> things that don't go via libc which would complicate the story with
> identifying and marking things as GCS/SS safe, it's going to be more
> robust to just supply a GCS if the process is using it.  That said
> having a default doesn't preclude us using the extensibility to allow
> userspace directly to control the GCS size, I would certainly be in
> favour of adding support for that.

It would be good if someone provided a summary of the x86 decision (I'll
get to those thread but most likely in September). I think we concluded
that we can't deploy GCS entirely transparently, so we need a libc
change (apart from the ELF annotations). Since libc is opting in to GCS,
we could also update the pthread_create() etc. to allocate the shadow
together with the standard stack.

Anyway, that's my preference but maybe there were good reasons not to do
this.

-- 
Catalin
