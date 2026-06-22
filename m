Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D37733CEA2
	for <kvmarm@lists.linux.dev>; Mon, 22 Jun 2026 16:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782147241; cv=none; b=uV8LBZ/EfwOgRRIGTvAtLgXrAXitvjwH0taejAdEsCyIyp6bbcvsQ9FJ4HoYNA61FkeQ7OJaSQEzRIJdM5nDENfc9puj4MbkPChsTk19TwWUa16FEN71zA0kvrIM2dGJ2lxTHdFkXuMKk+WVA4Cetwf8P5xaU7hSM1ltfoCvP2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782147241; c=relaxed/simple;
	bh=nvjgxfUAiQE9FH+SFzuxW9I2wWnku8W+Jts2rZ4Ki8g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tETFZHNUlN6xB1o3p87eIV+LfnBQ0sebLUXfl/g9ECPQeKAnSOeXSZy32mwANo0Se54CT6+ravSCqkAt3dYTYe2b5INUlhpuprWA2EpX9WjOhhCnui9GlJdOrxfWEpRbZSrydSxth2BiMFe1xRqRPtWUedBYQPAB3awi1x/8g5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k2KkmBxS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k2KkmBxS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68A591F00A3E;
	Mon, 22 Jun 2026 16:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782147239;
	bh=h4oqSzADNQ04uA1Dj4OA/6dT14XiJ6mKmI029BFIR9E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=k2KkmBxSO2cxv4BZ0PKAudFmR01aREyZ6KwNpBYazLnfP0+7GPq5MjWLxiVii32H4
	 ezpphDCSYdJetUk7nff+JdvnAQAzmwVrYE9TEVxoM7/kOoILGvQh4wEFBdo8kegUS8
	 HGUcl3RinmJVM/VJrEKxx9u40uvT/L3XMH4U0LKZ4MnWOBsKFOQqtjVENo14zVpD5B
	 q8dI+rNpEorZ02b33TiPSXuiDJ9ft6QLO/+PygjlZ0LsH8c9epvordMbnxWp5AeR5C
	 wqhANVwtmMY4w8oCcyxsDAoKvYfGkTacFuu0eFcP5nCh5X8lC3tRkt7UnRx2C1kp98
	 xwCfcNctz/cKQ==
Date: Mon, 22 Jun 2026 09:53:58 -0700
From: Oliver Upton <oupton@kernel.org>
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Fuad Tabba <fuad.tabba@linux.dev>, Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>,
	Vincent Donnefort <vdonnefort@google.com>,
	KVMARM <kvmarm@lists.linux.dev>
Subject: Re: Sashiko review emails to the list
Message-ID: <ajlopihdkRALO-do@kernel.org>
References: <ajVyJa-mZmYGzt6o@kernel.org>
 <7A91E52F-FCF3-4BB5-8AE5-9ED3A43809A8@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7A91E52F-FCF3-4BB5-8AE5-9ED3A43809A8@linux.dev>

On Fri, Jun 19, 2026 at 11:05:57AM -0700, Roman Gushchin wrote:
> 
> > On Jun 19, 2026, at 9:45 AM, Oliver Upton <oupton@kernel.org> wrote:
> > 
> > ﻿Hey,
> > 
> >> On Fri, Jun 19, 2026 at 03:19:05PM +0100, Fuad Tabba wrote:
> >> Hi folks,
> >> 
> >> I really like Sashiko and find it very useful. It's flagged real bugs
> >> in series I and others have posted to the list (e.g. [1][2][3]), and I
> >> run it locally before sending, which has saved me a few respins.
> >> 
> >> That said, it's been posting a lot lately, so it seemed worth asking
> >> how the review emails to the list are working out, and whether we
> >> should change anything.
> > 
> > So this is entirely my fault since I added the email configuration for
> > the kvmarm list. Sashiko has been finding some truly nasty bugs, posting
> > on-list is the easiest way to get attention from the right folks to get
> > things fixed.
> > 
> > With that being said, the signal to noise ratio hasn't been ideal.
> > 
> >> These fixes will take a while to land, so the question is what to do
> >> meanwhile. Some options, and surely others:
> >> 
> >>  - Leave it as-is while the fixes propagate.
> >>  - Stop the emails but keep the reviews on sashiko.dev, so people can
> >> look rather than have them pushed.
> >>  - Disable the emails until the noise is down to a reasonable level,
> >> then re-enable.
> > 
> > This sounds like the right approach. I'd like to re-enable emails once
> > we're happy with the quality of reviews.
> 
> From my perspective there are 3 main factors affecting the quality of reviews:
> 1) llm model capabilities. we have little control here, but it’s reasonable to expect that things will get better.
> 2) sashiko’s common code/harness. we’re improving it, but I’m not sure we have a lot of room left here, probably some. also, there are many tradeoffs to make, e.g. if we start verifying each issue separately, it almost certainly will improve signal/noise, but it will require way more tokens and will be slower.
> 3) developing per-subsystem prompts. there is a lot of potential here, but this is where we mostly rely on maintainers and developers.
> 
> Also not trying to push back on the decision, but I think it’s worth asking what is a reasonable level?
> I tried to measure the true positive rate several times based on human feedback and it always was at least ~80% (and usually more for critical/high severity bugs).
> And I’m afraid that it won’t be ~100% without compromising on the ability to find bugs. The reality is that there is a significant percentage of issues which are not exactly black and white and even people don’t necessarily agree if it’s an issue or not. Also there is a non-trivial amount of cases when ai findings are incorrectly dismissed by humans.
> 
> I’m not trying to pretend it’s perfect (it’s not), and I certainly expect it to be better going forward (and I’m working on it),
> but the point is that we might not see _dramatic_ improvements going forward simple because there is no room left for it,
> it’s more like a long tail of grey zone issues.

Marc touched on it as well, but the architecture hallucinations have
been pretty difficult to unwind since I don't expect most contributors
to know all the ins and outs of the Arm ARM.

I'm not terribly worried about this, especially since Fuad is actively
working to improve the review prompts / context.

> > On another note: Roman, is it possible to separately report pre-existing
> > issues from findings in a patch? Maintainers have a higher likelihood of
> > caring about these than individual contributors anyway.
> 
> It’s certainly possible, but how exactly do you see it?
> 
> It’s already somewhat separated (separate counters, separate list on top of each email).
> I don’t want to stop reporting them completely (but we can discuss it), because it produces
> a constant stream of fixes in the upstream kernel (in hundreds already).
> 
> I plan to improve it to e.g. not report multiple times within the same patchset.

Sorry, I was a bit vague.

Including pre-existing issues inline with the reviews is fine by me.
What I was actually hoping for is a way to view all the existing bugs in
a single place, either as a summary email on a regular cadence or a view
on the webpage.

We wont have enough cycles to go through every Sashiko review so I'm
worried that some bugs will be missed otherwise.

Thanks,
Oliver
