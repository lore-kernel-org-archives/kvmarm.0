Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F34D662B
	for <kvmarm@lists.linux.dev>; Fri, 18 Aug 2023 17:30:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61717C433C7;
	Fri, 18 Aug 2023 17:29:56 +0000 (UTC)
Date: Fri, 18 Aug 2023 18:29:54 +0100
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
Message-ID: <ZN+qki9EaZ6f9XNi@arm.com>
References: <20230807-arm64-gcs-v4-0-68cfa37f9069@kernel.org>
 <20230807-arm64-gcs-v4-3-68cfa37f9069@kernel.org>
 <ZNOhjrYleGBR6Pbs@arm.com>
 <f4cec4b3-c386-4873-aa1d-90528e062f2a@sirena.org.uk>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f4cec4b3-c386-4873-aa1d-90528e062f2a@sirena.org.uk>

On Wed, Aug 09, 2023 at 04:34:38PM +0100, Mark Brown wrote:
> On Wed, Aug 09, 2023 at 03:24:14PM +0100, Catalin Marinas wrote:
> > On Mon, Aug 07, 2023 at 11:00:08PM +0100, Mark Brown wrote:
> > > +* When set PR_SHADOW_STACK_ENABLE flag allocates a Guarded Control Stack for
> > 
> > The 'for' at the end of the line above is not needed.
> > 
> > > +  and enables GCS for the thread, enabling the functionality controlled by
> 
> I find it a little clearer that it's a per thread stack here but sure.

If it reads better for you, feel free to keep it as is.

> > > +3.  Allocation of Guarded Control Stacks
> > > +----------------------------------------
> 
> > > +* When GCS is enabled for a thread a new Guarded Control Stack will be
> > > +  allocated for it of size RLIMIT_STACK / 2 or 2 gigabytes, whichever is
> > > +  smaller.
> 
> > Is this number based on the fact that a function call would only push
> > the LR to GCS while standard function prologue pushes at least two
> > registers?
> 
> It's actually based on bitrot that I'd initially chosen a smaller value
> since it's likely that functions will push at least something as you
> suggest, the patches now just use RLIMIT_STACK.  I'll fix.

A related question - it may have been discussed intensively on the x86
thread (I may read it sometime) - why not have the libc map the shadow
stack and pass the pointer/size to clone3()? It saves us from having to
guess what the right size we'd need. struct clone_args is extensible.

(I plan to get back next week to this series, I'll need to read a bit
more on the spec)

-- 
Catalin
