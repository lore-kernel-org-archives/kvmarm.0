Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0824D13FE0
	for <kvmarm@lists.linux.dev>; Wed, 19 Jul 2023 14:04:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86A33C433C7;
	Wed, 19 Jul 2023 14:04:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1689775488;
	bh=DsojJ8c08YhYOhIvhoV59R7SwUBwaWbGSlmHEcsKZIQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TtDEmqkabHBem9yJ7UzUmARHyvi7MfK3yPcEyBtqqc7iZpVi7XQ8rE/0nEed/u3fv
	 4jebzSAa69JN1WtB38UjvB8xD06fuG2SQQtcGs8jKC6rGw448mbgLhZMths0nC0WNk
	 vSk76ltaFEH6wgCafpCjBas90/imoqlU4CuITdsDb72bjCO7WlVe71Cfrb+pCSO8yZ
	 NDQtZKHAvd1GCWZqcLWxVgwspGle7NGLv6vFH2Okt1VtqRbTTatFLMZSjaQb2z/hQL
	 a29Uwycd9cZsDnrGsxpeQF6Z4gXKMbCbFgBumx/gikMzJL8w9GfYE5x+oKv/FxQgS8
	 26Rb5GPG8hhOw==
Date: Wed, 19 Jul 2023 17:04:19 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Mark Brown <broonie@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
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
Subject: Re: [PATCH 04/35] arm64/gcs: Document the ABI for Guarded Control
 Stacks
Message-ID: <20230719140419.GK1901145@kernel.org>
References: <20230716-arm64-gcs-v1-0-bf567f93bba6@kernel.org>
 <20230716-arm64-gcs-v1-4-bf567f93bba6@kernel.org>
 <20230719114437.GJ1901145@kernel.org>
 <01dd7853-953d-4715-8cf0-c2f500065b55@sirena.org.uk>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <01dd7853-953d-4715-8cf0-c2f500065b55@sirena.org.uk>

On Wed, Jul 19, 2023 at 02:25:38PM +0100, Mark Brown wrote:
> On Wed, Jul 19, 2023 at 02:44:37PM +0300, Mike Rapoport wrote:
> > On Sun, Jul 16, 2023 at 10:51:00PM +0100, Mark Brown wrote:
> 
> > > +7.  ptrace extensions
> > > +---------------------
> > > +
> > > +* A new regset NT_ARM_GCS is defined for use with PTRACE_GETREGSET and
> > > +  PTRACE_SETREGSET.
> > > +
> > > +* Due to the complexity surrounding allocation and deallocation of stakcs and
> > > +  lack of practical application changes to the GCS configuration via ptrace
> > > +  are not supported.
> 
> > On x86 CRIU needed to be able to temporarily unlock shadow stack features
> > to recreate the shadow stack of the thread being restored. I presume CRIU
> > will need something like that on arm64 as well.
> 
> It would be good to understand why and what exactly is needed here.
> I'm guessing the main thing would be stores? 

Yes, CRIU has to modify the shadow stack.

CRIU uses sigreturn directly, so we had to update the shadow stack before
calling sigreturn.
On x86 ptrace(POKEDATA) and update of the shadow stack pointer were enough,
but it looks like ptrace(POKEDATA) won't work on arm64.

Another place that requires shadow stack modifications is the restore of
the shadow stack from the checkpoint. On x86 we had to enable WRSS and that
required to temporarily unlock the features.

> It's relatively easy to add features later, I think I'll just add support
> for everything except enable just now.

Fair enough :)

-- 
Sincerely yours,
Mike.
