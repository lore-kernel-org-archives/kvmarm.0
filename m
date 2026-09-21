Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADFF04582D4
	for <kvmarm@lists.linux.dev>; Mon, 21 Sep 2026 08:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789981185; cv=none; b=MmgBGpv737+jPduNhaRbi5kCLvBzPYyj+sYgTG6WF3ob5Ofm17AbxRsgDmrNIzsBaPdbk6h5Vxibl6To0dVlWCV21EtYmpnNWTRducPqTiAmHgfxO7W04QiDLYy6DlvMOuy5ZL8b89R6qnpd+La5MAYcS5A8LW7TCu6Hx1OQmEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789981185; c=relaxed/simple;
	bh=MxtCpLf+O8fMXcDqbLvflbINzdvEZ16LzLkZP73gn9Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GDEL3O4hcXPk2PtP+ndF0ylRDUlQwj+N/YtAooYz2bS8x6gO1UiMVNivpZfsZFls/jcK/w26HePLtycJqL0YrtY0fiGP+sZyMqc9HzPxooaIyFWmJhzczL79sxgS3Eyd6l1dGPdP9fUMlh+0lPxmvsryulJgh3cpMHhwiy1GXwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=FK+Mls5O; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="FK+Mls5O"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6EDD81D13;
	Mon, 21 Sep 2026 01:59:39 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4C6993F86C;
	Mon, 21 Sep 2026 01:59:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789981182; bh=MxtCpLf+O8fMXcDqbLvflbINzdvEZ16LzLkZP73gn9Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FK+Mls5OtsTgLk6IYJdSnW5aG5Hi2PyyG5+lNpA7QC3REm4t/EmuYUI6dSmKRkXu6
	 XFEllh+1aZZLvqhsP6QNU8e3ewlhe/vTWtD7rILvB8TJgTmXaueVwHGTn2TEuBko7A
	 xMYf6KoKH2Kh+RZMiODh0bNF3jp3M3vdQMJW99+Y=
Date: Mon, 21 Sep 2026 09:59:38 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: will@kernel.org, julien.thierry.kdev@gmail.com, kvm@vger.kernel.org,
	oupton@kernel.org, fuad.tabba@linux.dev, joey.gouly@arm.com,
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH kvmtool 0/7] Fix --vcpu-affinity
Message-ID: <arDx-mrK_V6jiKvT@raptor>
References: <20260917154932.193943-1-alexandru.elisei@arm.com>
 <86zexe4ume.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86zexe4ume.wl-maz@kernel.org>

Hi Marc,

On Fri, Sep 18, 2026 at 01:22:17PM +0100, Marc Zyngier wrote:
> On Thu, 17 Sep 2026 16:49:25 +0100,
> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
> > 
> > Tested on an Orion board and a x86 machine. On the x86 machine, there's was this
> > one thread called 'kvm-nx-lpage-re' which had affinity of the VCPUs, but I
> > couldn't figure out where it was created. I grep'ed for each part of the name in
> > the source node, no luck. I used strace, and couldn't see a clone call that
> > returned the corresponding pid. Any clues would be appreciated.
> 
> This is a KVM internal thread, from what I can tell. See
> arch/x86/kvm/mmu/mmu.c::kvm_mmu_start_lpage_recovery().

Indeed, it didn't cross my mind that it might KVM that is creating the thread.
Thanks for the hint, and to Joey too, he suggested it offline.

Alex
