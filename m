Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1E7B818
	for <kvmarm@lists.linux.dev>; Tue,  6 Jun 2023 08:34:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8EF9C4339B;
	Tue,  6 Jun 2023 08:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686040464;
	bh=IBidPa4YTyIF5atWcJcRcHpMTfYQvXCVIu3C1ReCwe8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FtdmKnJTbh0Th4rLzQVdzsyHI4nobuWxYORj11iWeWhGlMgvLcF7mRuKDFP/3SjWj
	 E5Za6vAzdwMhU2Fl7W+Yd14DBVHDobnBWLRAmob+EsEIFyB5d80PGYjA3JIjQUBajb
	 InBHOAv0cNMXRLtMH0xOOu4RRhUp3kA2MYZeOzlJOygnQC7JmPUZ5PDtqTXJfHRnP2
	 1AWELankUVH81S+2sDfidjLYiiUjlwt7jNuRuO9T4Eih88JdAH2XgOt0pTjw3cIR7b
	 lmQCCanbigXkSgQ/AIlWp5wfiem/MA7KeHluPdl6au2zq8eAq591Yb0A87DeofIIFq
	 Tf4L4UWn/XCBw==
Date: Tue, 6 Jun 2023 16:34:15 +0800
From: Tzung-Bi Shih <tzungbi@kernel.org>
To: Yu Zhao <yuzhao@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Alistair Popple <apopple@nvidia.com>,
	Anup Patel <anup@brainfault.org>, Ben Gardon <bgardon@google.com>,
	Borislav Petkov <bp@alien8.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Chao Peng <chao.p.peng@linux.intel.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Fabiano Rosas <farosas@linux.ibm.com>,
	Gaosheng Cui <cuigaosheng1@huawei.com>,
	Gavin Shan <gshan@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
	Ingo Molnar <mingo@redhat.com>, James Morse <james.morse@arm.com>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>,
	Marc Zyngier <maz@kernel.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Michael Larabel <michael@michaellarabel.com>,
	Mike Rapoport <rppt@kernel.org>,
	Nicholas Piggin <npiggin@gmail.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Paul Mackerras <paulus@ozlabs.org>, Peter Xu <peterx@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Thomas Huth <thuth@redhat.com>, Will Deacon <will@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org,
	linux-trace-kernel@vger.kernel.org, x86@kernel.org,
	linux-mm@google.com
Subject: Re: [PATCH mm-unstable v2 01/10] mm/kvm: add
 mmu_notifier_ops->test_clear_young()
Message-ID: <ZH7vh1GmsV+UCPwv@google.com>
References: <20230526234435.662652-1-yuzhao@google.com>
 <20230526234435.662652-2-yuzhao@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230526234435.662652-2-yuzhao@google.com>

On Fri, May 26, 2023 at 05:44:26PM -0600, Yu Zhao wrote:
> +/*
> + * Architectures that implement kvm_arch_test_clear_young() should override
> + * kvm_arch_has_test_clear_young().
> + *
> + * kvm_arch_has_test_clear_young() is allowed to return false positive, i.e., it
> + * can return true if kvm_arch_test_clear_young() is supported but disabled due
> + * to some runtime constraint. In this case, kvm_arch_test_clear_young() should

Is it a typo here?  s/kvm_arch_test_clear_young/kvm_arch_has_test_clear_young/.

> +static inline int mmu_notifier_clear_young(struct mm_struct *mm,
> +					   unsigned long start,
> +					   unsigned long end)
> +{
> +	return 0;
> +}
> +

This looks irrelevant to the patch but a fix for commit 1d7715c676a1
("mmu-notifier: add clear_young callback") instead.
