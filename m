Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2538B1E498;
	Fri, 20 Sep 2024 12:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726835873; cv=none; b=OS7FL0890B9jEOg9T7iOyT7I6WV1WKGW0GiHjytoE6+avAjG0NsBr+6UFMjbW3IlLl38MtfX5krRAWqXqwXDdkOqoB5oFY7+rhv9EPL6UzjO/wuKQtpmhgrdh/WaVICmPwDtIPxC8XnqGo2UuUmaiN4BRLtgynmQRJKcQyaE1AI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726835873; c=relaxed/simple;
	bh=+xuRPrmR7i0CxITWrMzA6Rbir0u7SYmmYJphYrBfy3A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tWEY+9cZm4DSDXsnjveuD9AaW+cowHdkZpXMFCT0LvHRFz+YKXP1MoGsf+W+qrEUW9+SCc+9P8cjnaR1Tvfn3wOCSzOI833VWnt8iOCVQifm2N3DNHpG91LuY/lJ5+PhL2beR7nGVqq4JSAHh1VbgU5NsX+2jyon4QxX/aJlYTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IAosnox0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IAosnox0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EA7AC4CEC3;
	Fri, 20 Sep 2024 12:37:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726835872;
	bh=+xuRPrmR7i0CxITWrMzA6Rbir0u7SYmmYJphYrBfy3A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IAosnox004cPJJHW+Yce205KY2IrNZcl+CtEsZ66I+gYMKSE+fq8pE685GUG2D+EJ
	 m1zHF9oNmFE5rcXk0uhVHyuVttL0SFDxoMmoHxvysv6F2CHInFj21hnvq8/iTgGvaI
	 Q3F9Bzi0P6PuACKEq3bddrqjg6qomtCcOLXBXoXXTNzVyDGGdVqdOkG3hPCklQBNDX
	 L21vx5LuGCCOeJwSeoogKTVj0e12k8ritzzV/uJzPJe1YtsMAZZCdiYNjwRjHJV5zI
	 vWETvKPasLYzMiOdZPf2d7yNQ5bzAxvXcQ/uVvOECT/6dHsW12+8mHdktGo0VDm/eR
	 yNTmeAkf5u+8w==
Date: Fri, 20 Sep 2024 14:34:47 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Fares Mehanna <faresx@amazon.de>
Cc: nh-open-source@amazon.com, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	=?iso-8859-1?Q?Pierre-Cl=E9ment?= Tosi <ptosi@google.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Arnd Bergmann <arnd@arndb.de>, Fuad Tabba <tabba@google.com>,
	Mark Brown <broonie@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Kristina Martsenko <kristina.martsenko@arm.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	David Hildenbrand <david@redhat.com>,
	Roman Kagan <rkagan@amazon.de>,
	"moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)" <linux-arm-kernel@lists.infradead.org>,
	"open list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)" <kvmarm@lists.linux.dev>,
	open list <linux-kernel@vger.kernel.org>,
	"open list:MEMORY MANAGEMENT" <linux-mm@kvack.org>
Subject: Re: [RFC PATCH 0/7] support for mm-local memory allocations and use
 it
Message-ID: <Zu1r5-JnL3sduoqy@kernel.org>
References: <20240911143421.85612-1-faresx@amazon.de>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240911143421.85612-1-faresx@amazon.de>

Hi,

On Wed, Sep 11, 2024 at 02:33:59PM +0000, Fares Mehanna wrote:
> In a series posted a few years ago [1], a proposal was put forward to allow the
> kernel to allocate memory local to a mm and thus push it out of reach for
> current and future speculation-based cross-process attacks.  We still believe
> this is a nice thing to have.
> 
> However, in the time passed since that post Linux mm has grown quite a few new
> goodies, so we'd like to explore possibilities to implement this functionality
> with less effort and churn leveraging the now available facilities.
> 
> An RFC was posted few months back [2] to show the proof of concept and a simple
> test driver.
> 
> In this RFC, we're using the same approach of implementing mm-local allocations
> piggy-backing on memfd_secret(), using regular user addresses but pinning the
> pages and flipping the user/supervisor flag on the respective PTEs to make them
> directly accessible from kernel.
> In addition to that we are submitting 5 patches to use the secret memory to hide
> the vCPU gp-regs and fp-regs on arm64 VHE systems.
> 
> The generic drawbacks of using user virtual addresses mentioned in the previous
> RFC [2] still hold, in addition to a more specific one:
> 
> - While the user virtual addresses allocated for kernel secret memory are not
>   directly accessible by userspace as the PTEs restrict that, copy_from_user()
>   and copy_to_user() can operate on those ranges, so that e.g. the usermode can
>   guess the address and pass it as the target buffer for read(), making the
>   kernel overwrite it with the user-controlled content. Effectively making the
>   secret memory in the current implementation missing confidentiality and
>   integrity guarantees.

Having a VMA in user mappings for kernel memory seems weird to say the
least.
Core MM does not expect to have VMAs for kernel memory. What will happen if
userspace ftruncates that VMA? Or registers it with userfaultfd?
 
> In the specific case of vCPU registers, this is fine because the owner process
> can read and write to them using KVM IOCTLs anyway. But in the general case this
> represents a security concern and needs to be addressed.
> 
> A possible way forward for the arch-agnostic implementation is to limit the user
> virtual addresses used for kernel to specific range that can be checked against
> in copy_from_user() and copy_to_user().
> 
> For arch specific implementation, using separate PGD is the way to go.
> 
> [1] https://lore.kernel.org/lkml/20190612170834.14855-1-mhillenb@amazon.de/

This approach seems much more reasonable and it's not that it was entirely
arch-specific. There is some plumbing at arch level, but the allocator is
anyway arch-independent. 

-- 
Sincerely yours,
Mike.
