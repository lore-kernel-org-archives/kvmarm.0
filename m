Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33A2522F13
	for <kvmarm@lists.linux.dev>; Tue,  1 Aug 2023 14:13:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C215FC433C7;
	Tue,  1 Aug 2023 14:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1690899209;
	bh=NTBwd29Dbu+ECP276LsKiM8HBDKaR00BKAB6CRCf3bE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=abqS+G0uERa7fIKrH4hSw9IDBy+zR3n2e2RncQqAqkzlG6NQHu8J5iIFlkwrB657I
	 oJQ0+vDyHimf0Zzmz13ZMAyco3wCnDXoFSci37voDkjQr4SVseAsIyVJ06v3CG1ZKX
	 wA4zk4L/vjGB4EVHMfxhGACjxWZzRWGs+AESTu3SAB7pEpFPTu5QyCSKsYrmv6ocyz
	 STvBOLI5/v9lmw1IkmkGMiZootxRVm5BrSrS3Z8ppbrLm97hcIZG9bJiqDSG26raqx
	 VegkDKaNPneU+4IvGTtTT2RITGdJC90YBsdQ0YM0USvoHqq9xrcZJCf7t4mwUrCzhT
	 F9wsepVvvxiMA==
Date: Tue, 1 Aug 2023 15:13:20 +0100
From: Will Deacon <will@kernel.org>
To: Mark Brown <broonie@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
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
Subject: Re: [PATCH v3 00/36] arm64/gcs: Provide support for GCS in userspace
Message-ID: <20230801141319.GC26253@willie-the-truck>
References: <20230731-arm64-gcs-v3-0-cddf9f980d98@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230731-arm64-gcs-v3-0-cddf9f980d98@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Mon, Jul 31, 2023 at 02:43:09PM +0100, Mark Brown wrote:
> The arm64 Guarded Control Stack (GCS) feature provides support for
> hardware protected stacks of return addresses, intended to provide
> hardening against return oriented programming (ROP) attacks and to make
> it easier to gather call stacks for applications such as profiling.

Why is this better than Clang's software shadow stack implementation? It
would be nice to see some justification behind adding all this, rather
than it being an architectural tick-box exercise.

Will
