Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8ED41CB500;
	Mon,  2 Sep 2024 15:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725289651; cv=none; b=PK+8ZRyw8lhTJMU3zaOa+ptHYJ5U84eOM38CIJfGBuBKWUYRKpzCzFb1PLKOTqsJiNgGvP0n5jtgTCsaWqxqnh6utOs1e/IU5R6EsXd0uAZxeJmVRSup6o0yFsges+HVpHRfYNXIw6X6HmODme3Fk8+cqKWdQfRT0dgOUTBUifc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725289651; c=relaxed/simple;
	bh=CDvImeaHi1qQ6IcRM7Vkr3C6C7NX0roxJJAoEE8EYho=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gNhm9t/rtBOfJ4yScWorGfz6MQ+JpuI9t9EjDYFSXibp83yATnzojh84Y2qMySf6JRa0pO/1ywSFjWw5RYI6ojZcNIiJqgoqvI0TRNGh2+gxwzbsXdKQqsI77WYTZjw2g3f+1SFKvWF+ZeyNIQJAznfYQFY713HYgRIoC0m1YI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nhhqpjOi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nhhqpjOi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EB19C4CEC4;
	Mon,  2 Sep 2024 15:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725289650;
	bh=CDvImeaHi1qQ6IcRM7Vkr3C6C7NX0roxJJAoEE8EYho=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nhhqpjOiUkLi/x1OXaP4Z8L/mpO8y510GALi9VNfj8pWo0Qm+kb065UbYmcVmDVLi
	 euOLwursgHkfVkS0zF0g9+WQWULITJa0bNMk1DOeSk9gT9roQ32CPg//I0kSubGXB4
	 Tvj81sKmEOc2OGtIEVYZa2bNEkI5p1A3mEyg69X3SD9pYBlIQ9cdB4oMAgUhh3QLhk
	 VGJKz83mWr/b7rDMCus15QaOPxDuYKNQBYJVfvVpwYwgB5RLJMJVq2u0Ecj5M9eqmJ
	 2gSaUihqJi3Hzj0qmHJEBqfDfA470i4lDw9aUzHx5L31K2e/qTdlsHPIKRF1KHAVHQ
	 QCNtdNqIr8nOw==
Date: Mon, 2 Sep 2024 16:07:26 +0100
From: Will Deacon <will@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] KVM/arm64 fixes for 6.11, round #2
Message-ID: <20240902150725.GA11571@willie-the-truck>
References: <Zsb4kbq6FAfgg4WA@linux.dev>
 <ZshONupF3nIhAlRf@arm.com>
 <CABgObfZ=P-Qc20SD=duFtDbCefWGO9YoEcA=S0DaTo59x58iYg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABgObfZ=P-Qc20SD=duFtDbCefWGO9YoEcA=S0DaTo59x58iYg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Mon, Sep 02, 2024 at 04:59:23PM +0200, Paolo Bonzini wrote:
> On Fri, Aug 23, 2024 at 10:54 AM Catalin Marinas
> <catalin.marinas@arm.com> wrote:
> >
> > Hi Oliver,
> >
> > On Thu, Aug 22, 2024 at 01:36:33AM -0700, Oliver Upton wrote:
> > > Paolo is on holiday for a few weeks and has asked that KVM arch maintainers
> > > send pulls through the architecture trees in his absence.
> > >
> > > So lucky you, here's a pile of kvmarm crap from the past week.
> > >
> > > Details can be found in the tag, but this is a set of small fixes
> > > around the shop thanks to syzkaller bringup on KVM/arm64 and a few
> > > recently introduced bugs.
> >
> > Pulled into the arm64 for-next/fixes branch. I'll send a pull request to
> > Linus later today.
> 
> Looks like this pull request was never sent (the last arm64 fixes PR
> is from August 16), so I pulled this now.
> 
> Duplicate commits are generally harmless so it shouldn't be an issue
> if they end up being sent by Catalin as well.

I think this was all pulled by Linus over a week ago:

https://lore.kernel.org/all/ZsjE6BXzDznbg6R-@arm.com/

Will
