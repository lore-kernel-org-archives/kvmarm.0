Received: from out-24.mta1.migadu.com (out-24.mta1.migadu.com [95.215.58.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADFBA1FA5
	for <kvmarm@lists.linux.dev>; Mon, 12 Jun 2023 07:52:28 +0000 (UTC)
Date: Mon, 12 Jun 2023 09:52:23 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1686556346;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WU+Rz4tch7eIwv3TMFZIV3pBP1OaRdHuLjagG6Uf+rI=;
	b=A6Jjk76tyZCdM6dELtjhE6hb6DbONAbGQE917lhLDbiiyGe3yIIdlJU2bDRUuC/s2SHhkA
	ZZCW+EpREAJflkdsEt695ZeBGBmrsVySUGqeQiMwpUCPWbEw8o6UfSaXGfJgEerAvWUuJO
	7VjKFioSsaW78Qh3/1eBBfmJOtDkBfo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Nadav Amit <nadav.amit@gmail.com>
Cc: Nikos Nikoleris <nikos.nikoleris@arm.com>, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, Paolo Bonzini <pbonzini@redhat.com>, alexandru.elisei@arm.com, 
	ricarkol@google.com, shahuang@redhat.com
Subject: Re: [kvm-unit-tests PATCH v6 00/32] EFI and ACPI support for arm64
Message-ID: <20230612-6e1f6fac1759f06309be3342@orel>
References: <20230530160924.82158-1-nikos.nikoleris@arm.com>
 <CC2B570B-9EE0-4686-ADF3-82D1ECDD5D8A@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CC2B570B-9EE0-4686-ADF3-82D1ECDD5D8A@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Sat, Jun 10, 2023 at 01:32:59AM -0700, Nadav Amit wrote:
> 
> > On May 30, 2023, at 9:08 AM, Nikos Nikoleris <nikos.nikoleris@arm.com> wrote:
> > 
> > Hello,
> > 
> > This series adds initial support for building arm64 tests as EFI
> > apps and running them under QEMU. Much like x86_64, we import external
> > dependencies from gnu-efi and adapt them to work with types and other
> > assumptions from kvm-unit-tests. In addition, this series adds support
> > for enumerating parts of the system using ACPI.
> 
> Just an issue I encountered, which I am not sure is arm64 specific:
> 
> All the printf’s in efi_main() are before current_thread_info() is
> initialized (or even memset’d to zero, as done in setup_efi).
> 
> But printf() calls puts() which checks if mmu_enabled(). And
> mmu_enabled() uses is_user() and current_thread_info()->cpu, both
> of which read uninitialized data from current_thread_info().
> 
> IOW: Any printf in efi_main() can cause a crash.
>

Nice catch, Nadav. Nikos, shouldn't we drop the memset() in setup_efi and
put a zero_range call, similar to the one in arm/cstart64.S which zero's
the thread-info area, in arm/efi/crt0-efi-aarch64.S?

Thanks,
drew
