Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA8FC19DF9F;
	Fri, 16 Aug 2024 11:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723806656; cv=none; b=qOkPn7xPOrJKTp2uv2B3CY76fDOmpbkmOJ20fo7Qg1m8sxXgvR9d7kdCPmOqSp8uvR8HKkm1vFymImMmFCetO9CwepfLmPYSaC/hSjQc40O3d+W7udkjVkpMCnzSEao0CAU0pqIOX31xC3hfIvCQOGOvc3Iigj7ez3Mri7/W8fM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723806656; c=relaxed/simple;
	bh=7AuT09/kigp8EsKuGdcnahvbZs5FXt+btd7+T0zxmoo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B/2zGWRd3kFNyigTAXDMaPwjMrDIF6kvlsdaCNUb4A0oKz8ERfNqFOVQZdq+IekglYd6USxS9nbqLU4DMJ60Ic2q5lcZq6U8Xn+UbjImqTbJAeVSjL2Dlv+aFO3wJK7xGQsv6yD+R0TdPWfoB1T3WqlEOVzLekUnTMEAKjnToic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD531C32782;
	Fri, 16 Aug 2024 11:10:50 +0000 (UTC)
Date: Fri, 16 Aug 2024 12:10:48 +0100
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
	Shuah Khan <shuah@kernel.org>,
	"Rick P. Edgecombe" <rick.p.edgecombe@intel.com>,
	Deepak Gupta <debug@rivosinc.com>, Ard Biesheuvel <ardb@kernel.org>,
	Szabolcs Nagy <Szabolcs.Nagy@arm.com>, Kees Cook <kees@kernel.org>,
	"H.J. Lu" <hjl.tools@gmail.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Florian Weimer <fweimer@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Thiago Jung Bauermann <thiago.bauermann@linaro.org>,
	Ross Burton <ross.burton@arm.com>,
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
	kvmarm@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	linux-arch@vger.kernel.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org
Subject: Re: [PATCH v10 07/40] arm64/gcs: Add manual encodings of GCS
 instructions
Message-ID: <Zr8zuBgFrs6xYR0U@arm.com>
References: <20240801-arm64-gcs-v10-0-699e2bd2190b@kernel.org>
 <20240801-arm64-gcs-v10-7-699e2bd2190b@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240801-arm64-gcs-v10-7-699e2bd2190b@kernel.org>

On Thu, Aug 01, 2024 at 01:06:34PM +0100, Mark Brown wrote:
> Define C callable functions for GCS instructions used by the kernel. In
> order to avoid ambitious toolchain requirements for GCS support these are
> manually encoded, this means we have fixed register numbers which will be
> a bit limiting for the compiler but none of these should be used in
> sufficiently fast paths for this to be a problem.
> 
> Note that GCSSTTR is used to store to EL0.
> 
> Reviewed-by: Thiago Jung Bauermann <thiago.bauermann@linaro.org>
> Signed-off-by: Mark Brown <broonie@kernel.org>

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
