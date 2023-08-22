Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E75932B543
	for <kvmarm@lists.linux.dev>; Tue, 22 Aug 2023 16:35:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2203DC433C9;
	Tue, 22 Aug 2023 16:34:47 +0000 (UTC)
Date: Tue, 22 Aug 2023 17:34:38 +0100
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
Subject: Re: [PATCH v4 18/36] arm64/gcs: Context switch GCS state for EL0
Message-ID: <ZOTjnmwwZ+iMsi6Y@arm.com>
References: <20230807-arm64-gcs-v4-0-68cfa37f9069@kernel.org>
 <20230807-arm64-gcs-v4-18-68cfa37f9069@kernel.org>
 <ZNZUerbrJmzqZzJw@arm.com>
 <28a61b5f-db65-427e-8e92-60dd61549da5@sirena.org.uk>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <28a61b5f-db65-427e-8e92-60dd61549da5@sirena.org.uk>

On Wed, Aug 16, 2023 at 07:15:53PM +0100, Mark Brown wrote:
> On Fri, Aug 11, 2023 at 04:32:10PM +0100, Catalin Marinas wrote:
> > On Mon, Aug 07, 2023 at 11:00:23PM +0100, Mark Brown wrote:
> 
> > > +		gcs_free(current);
> > > +		current->thread.gcs_el0_mode = 0;
> > > +		write_sysreg_s(0, SYS_GCSCRE0_EL1);
> > > +		write_sysreg_s(0, SYS_GCSPR_EL0);
> > > +	}
> > > +}
> 
> > Do we need and isb() or there's one on this path? If it's only EL0
> > making use of this register, we should be fine with the ERET before
> > returning to user. Not sure whether the kernel uses this, GCSSTTR
> > doesn't need it.
> 
> They're only used by EL0, at EL1 we do read GCSPR for signal handling
> but AIUI that shouldn't be any more of an issue than it is for the
> TPIDRs which we don't have a barrier for.  It's possible I'm
> misunderstanding though.

We should be alright without since we'll eventually have an ERET to EL0.

> > > +	/*
> > > +	 * Ensure that GCS changes are observable by/from other PEs in
> > > +	 * case of migration.
> > > +	 */
> > > +	if (task_gcs_el0_enabled(current) || task_gcs_el0_enabled(next))
> > > +		gcsb_dsync();
> 
> > What's this barrier for? The spec (at least the version I have) only
> > talks about accesses, nothing to do with the registers that we context
> > switch here.
> 
> Right, it's for the GCS memory rather than the registers.  I'm fairly
> sure it's excessive but but was erring on the side of caution until I
> have convinced myself that the interactions between GCS barriers and
> regular barriers were doing the right thing, until we have physical
> implementations to contend with I'd guess the practical impact will be
> minimal.

Well, I'd say either we are clear about why it's (not) needed or we ask
the architects to clarify the spec. I haven't checked your latest
series but in principle I don't like adding barriers just because we are
not sure they are needed (and I don't think having hardware eventually
changes this).

-- 
Catalin
