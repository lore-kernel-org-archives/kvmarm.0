Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E44E2522A1;
	Mon, 18 Aug 2025 18:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755542165; cv=none; b=Z/fm9uqBoioPL+4VVyKGZAfTKWAfINs6iPnUEUx5Ru1bxIHboQsp2LLTw8fItkYkzbXYnKHOnY4CBPzRXz090f6Dw4IEboUQfOzwByrOXbKZTPppEZadr+YmpdHmDbvW22FpDzbs9o3vIr5TbgbMmihWvDPcdXIPqt7CnFVQmXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755542165; c=relaxed/simple;
	bh=/TNdDJM7aNaPZKDRxUq92db+dTiso/s/YJpk5Xhi43c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VZJC0VUMJqtIdaEuPF2dpUmEXrN7B0r0/G/kby+SGo8pEwvkNiMppK2SY+mXSZvKjWDod7N0mTDkos6IZfsPkk6og76ee1Wp1vAwcuPOv8MD8hatXk8OVaqILV/RvWuo9keqdCh/pthbbBYYSCicHnMVuIrakUBPw1jOhWleDvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A7D1C4CEEB;
	Mon, 18 Aug 2025 18:36:02 +0000 (UTC)
Date: Mon, 18 Aug 2025 19:35:59 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: will@kernel.org, broonie@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, shameerali.kolothum.thodi@huawei.com,
	joey.gouly@arm.com, james.morse@arm.com, ardb@kernel.org,
	scott@os.amperecomputing.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, mark.rutland@arm.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 5/5] arm64: futex: support futex with FEAT_LSUI
Message-ID: <aKNyj_6dZVp9O4BA@arm.com>
References: <20250811163635.1562145-1-yeoreum.yun@arm.com>
 <20250811163635.1562145-6-yeoreum.yun@arm.com>
 <aJ9oIes7LLF3Nsp1@arm.com>
 <aKB55rPj1Qe8G+zF@e129823.arm.com>
 <aKCcbQWioNfG1MMQ@e129823.arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aKCcbQWioNfG1MMQ@e129823.arm.com>

On Sat, Aug 16, 2025 at 03:57:49PM +0100, Yeoreum Yun wrote:
> > > > +#ifdef CONFIG_AS_HAS_LSUI
> > > > +
> > > > +#define __LSUI_PREAMBLE	".arch_extension lsui\n"
> > > > +
> > > > +#define LSUI_FUTEX_ATOMIC_OP(op, asm_op, mb)				\
> > > > +static __always_inline int						\
> > > > +__lsui_futex_atomic_##op(int oparg, u32 __user *uaddr, int *oval)	\
> > > > +{									\
> > > > +	int ret = 0;							\
> > > > +	int val;							\
> > > > +									\
> > > > +	mte_enable_tco();						\
> > >
> >
> > > The reason uaccess_disable_privileged() sets the MTE TCO (tag check
> > > override) is because the user and the kernel may have different settings
> > > for tag checking. If we use the user instructions provided by FEAT_LSUI,
> > > we leave the MTE checking as is.
> > >
> > > The same comment for all the other functions here.
> >
> > You're right. Thanks for catching this :)
> 
> But one bikeshedding question.
> why we need to care about the different settings for tag checking when
> we use uaccess_disable_privileged()?

Because, for example, the user may not be interested in any tag check
faults (has checking disabled) but the kernel uses KASAN with
synchronous tag check faults. If it uses the privileged instructions as
in the futex API, it either won't make progress or report errors to the
user which it does not expect.

> IIUC, the reason we uses to uaccess_disaable_privileged() to access
> user memory with copy_from/to_user() and etc.

We don't use uaccess_disable_privileged() with copy_from_user() since
those use the unprivileged instructions already.

> But, although tag check fault happens in kernel side,
> It seems to be handled by fixup code if user address is wrong.

The user may know it is wrong and not care (e.g. one wants to keep using
a buggy application).

-- 
Catalin
