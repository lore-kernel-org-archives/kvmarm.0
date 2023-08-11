Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCCF063B6
	for <kvmarm@lists.linux.dev>; Fri, 11 Aug 2023 16:36:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80FC3C433C8;
	Fri, 11 Aug 2023 16:36:07 +0000 (UTC)
Date: Fri, 11 Aug 2023 17:36:05 +0100
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
Subject: Re: [PATCH v4 07/36] arm64/gcs: Provide copy_to_user_gcs()
Message-ID: <ZNZjdXTJw2p5vh7C@arm.com>
References: <20230807-arm64-gcs-v4-0-68cfa37f9069@kernel.org>
 <20230807-arm64-gcs-v4-7-68cfa37f9069@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230807-arm64-gcs-v4-7-68cfa37f9069@kernel.org>

On Mon, Aug 07, 2023 at 11:00:12PM +0100, Mark Brown wrote:
> +static inline int copy_to_user_gcs(unsigned long __user *addr,
> +				   unsigned long *val,
> +				   int count)
> +{
> +	int ret = -EFAULT;
> +	int i;
> +
> +	if (access_ok((char __user *)addr, count * sizeof(u64))) {
> +		uaccess_ttbr0_enable();
> +		for (i = 0; i < count; i++) {
> +			ret = gcssttr(addr++, *val++);
> +			if (ret != 0)
> +				break;
> +		}
> +		uaccess_ttbr0_disable();
> +	}
> +
> +	return ret;
> +}

I think it makes more sense to have a put_user_gcs() of a single
element. I've only seen it used with 2 elements in the signal code but
we could as well do two put_user_gcs() calls (as we do for other stuff
that we push to the signal frame).

-- 
Catalin
