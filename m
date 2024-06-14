Received: from gate.crashing.org (gate.crashing.org [63.228.1.57])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F7DE15A4BC
	for <kvmarm@lists.linux.dev>; Fri, 14 Jun 2024 01:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=63.228.1.57
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718327726; cv=none; b=bfEXSLFzmjxepQnWTWxhM+s0PheWSLKqJOOiKcjf28uTMUMVR4DL4ROm7+ojOnoUJHYsMjGpgE5wSKz3isFv+9nxattw5/ZDz1E97imPbFQfN0gd0QwgxIdEJ/jq263oFMDD/5XJ4YH7iVgmTHF10D09K83zqk/02okbBwIXBvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718327726; c=relaxed/simple;
	bh=7Retf0v8z9os8KrbHDiWjchdnzz8mCBkIDS9qi4WQb8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Mime-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cQ/mLesEoCH02k1RAF7klXdJ6sYJcOkjZ6kX3FLXD607GpLgXaqKBZ/TlLY/R8p01T633RQOLtnCl6tACSh7pLv7UAm/KCIp4SFb5TzqOEguLhVfAIkw3XPUH1NuRloS4BWxDNUNl33dD3ksrwCPpjLDRhXOdsI/0Eo26iz4Z8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.crashing.org; spf=pass smtp.mailfrom=kernel.crashing.org; arc=none smtp.client-ip=63.228.1.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.crashing.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.crashing.org
Received: from gate.crashing.org (localhost.localdomain [127.0.0.1])
	by gate.crashing.org (8.14.1/8.14.1) with ESMTP id 45E18v5Y029218;
	Thu, 13 Jun 2024 20:08:57 -0500
Received: (from segher@localhost)
	by gate.crashing.org (8.14.1/8.14.1/Submit) id 45E18uJY029217;
	Thu, 13 Jun 2024 20:08:56 -0500
X-Authentication-Warning: gate.crashing.org: segher set sender to segher@kernel.crashing.org using -f
Date: Thu, 13 Jun 2024 20:08:56 -0500
From: Segher Boessenkool <segher@kernel.crashing.org>
To: Nicholas Piggin <npiggin@gmail.com>
Cc: Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Andrew Jones <andrew.jones@linux.dev>,
        Marc Hartmayer <mhartmay@linux.ibm.com>, kvm-riscv@lists.infradead.org,
        kvmarm@lists.linux.dev, linuxppc-dev@lists.ozlabs.org
Subject: Re: [kvm-unit-tests PATCH] build: retain intermediate .aux.o targets
Message-ID: <20240614010856.GK19790@gate.crashing.org>
References: <20240612044234.212156-1-npiggin@gmail.com> <20240612082847.GG19790@gate.crashing.org> <D1ZBO021MLHV.3C7E4V3WOHO8V@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D1ZBO021MLHV.3C7E4V3WOHO8V@gmail.com>
User-Agent: Mutt/1.4.2.3i

On Fri, Jun 14, 2024 at 10:43:39AM +1000, Nicholas Piggin wrote:
> On Wed Jun 12, 2024 at 6:28 PM AEST, Segher Boessenkool wrote:
> > On Wed, Jun 12, 2024 at 02:42:32PM +1000, Nicholas Piggin wrote:
> > > arm, powerpc, riscv, build .aux.o targets with implicit pattern rules
> > > in dependency chains that cause them to be made as intermediate files,
> > > which get removed when make finishes. This results in unnecessary
> > > partial rebuilds. If make is run again, this time the .aux.o targets
> > > are not intermediate, possibly due to being made via different
> > > dependencies.
> > > 
> > > Adding .aux.o files to .PRECIOUS prevents them being removed and solves
> > > the rebuild problem.
> > > 
> > > s390x does not have the problem because .SECONDARY prevents dependancies
> > > from being built as intermediate. However the same change is made for
> > > s390x, for consistency.
> >
> > This is exactly what .SECONDARY is for, as its documentation says,
> > even.  Wouldn't it be better to just add a .SECONDARY to the other
> > targets as well?
> 
> Yeah we were debating that and agreed .PRECIOUS may not be the
> cleanest fix but since we already use that it's okay for a
> minimal fix.

But why add it to s390x then?  It is not a fix there at all!


Segher
