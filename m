Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB41E2737F2;
	Mon, 16 Feb 2026 18:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771266289; cv=none; b=g2FLINoMhEVpSgE+2MZ0edJXCiR71aqOFJNyh6kDxS9GPIVT8p20cfMOnLT8esUJhH3m58/8UKhgtQrVI/7+iBqwRMjaajVMFMLyd3BYZcXI9pzCEPhZQFM5CHMur+Qnk4Gy7dO7R+ty5DvhIIzBfl7qdz7VcjD/BiE7+ehTJWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771266289; c=relaxed/simple;
	bh=e4Xv36F6K4gczFWPbbm/HwoIgQOOiINgmW2tJZCr86Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sRMahjOPPcQaiYOELsA81kZEXxnvHmomZZ27GUD3ZQHV9Gp3L4XByrDAE++yuQ446/ADU88VS1dzp05EaDXowZjnZt4RbUCec8dnKhfdDc2hAQag0vAHC2l9Io4Np4itVaVzaXN6mEfHASGgzZKlZfR1bMYkGV7wexXrQCOjFn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50B62C116C6;
	Mon, 16 Feb 2026 18:24:45 +0000 (UTC)
Date: Mon, 16 Feb 2026 18:24:42 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org, will@kernel.org, maz@kernel.org,
	broonie@kernel.org, oliver.upton@linux.dev, miko.lenczewski@arm.com,
	kevin.brodsky@arm.com, ardb@kernel.org, suzuki.poulose@arm.com,
	lpieralisi@kernel.org, scott@os.amperecomputing.com,
	joey.gouly@arm.com, yuzenghui@huawei.com, pbonzini@redhat.com,
	shuah@kernel.org, mark.rutland@arm.com, arnd@arndb.de
Subject: Re: [PATCH v12 2/7] arm64: cpufeature: add FEAT_LSUI
Message-ID: <aZNgR6prm0Exzar0@arm.com>
References: <20260121190622.2218669-1-yeoreum.yun@arm.com>
 <20260121190622.2218669-3-yeoreum.yun@arm.com>
 <aYY2CyHWtplQ-fuS@arm.com>
 <aYouAv_EjICIN8oA@arm.com>
 <aYsAaaQgBaLbDSsW@e129823.arm.com>
 <aYtZfpWjRJ1r23nw@arm.com>
 <aYtkbezCx9vW8SHz@e129823.arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aYtkbezCx9vW8SHz@e129823.arm.com>

On Tue, Feb 10, 2026 at 05:01:33PM +0000, Yeoreum Yun wrote:
> > Why not keep uaccess_enable_privileged() in
> > arch_futex_atomic_op_inuser() and cmpxchg for all cases and make it a
> > no-op if FEAT_LSUI is implemented together with FEAT_PAN?
> 
> This is because I had a assumption FEAT_PAN must be present
> when FEAT_LSUI is presented and this was not considering the virtualisation case.
> and  FEAT_PAN is present uaccess_ttbr0_enable() becomes nop and
> following feedback you gave - https://lore.kernel.org/all/aJ9oIes7LLF3Nsp1@arm.com/
> and the reason you mention last, It doesn't need to call mte_enable_tco().
> 
> That's why I thought it doesn't need to call uaccess_enable_privileged().
> 
> But for a compatibility with SW_PAN, I think we can put only
> uaccess_ttbr0_enable() in arch_futex_atomic_op_inuser() and cmpxchg simply
> instead of adding a new APIs uaccess_enable_futex() and
> by doing this I think has_lsui() can be removed with its WRAN.

Yes, I think you can use uaccess_ttbr0_enable() when we take the
FEAT_LSUI path. What I meant above was for uaccess_enable_privileged()
to avoid PAN disabling if we have FEAT_LSUI as we know all cases would
be executed with user privileges.

Either way, we don't need a new uaccess_enable_futex().

> > BTW, with the removal of uaccess_enable_privileged(), we now get MTE tag
> > checks for the futex operations. I think that's good as it matches the
> > other uaccess ops, though it's a slight ABI change. If we want to
> > preserve the old behaviour, we definitely need
> > uaccess_enable_privileged() that only does mte_enable_tco().
> 
> I think we don't need to preserve the old behaviour. so we can skip
> mte_enable_tco() in case of FEAT_LSUI is presented.

Just spell it out in the commit log that we have a slight ABI change. I
don't think we'll have a problem but it needs at least checking with
some user-space (libc, Android) people.

-- 
Catalin
