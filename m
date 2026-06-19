Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B38A2D060B
	for <kvmarm@lists.linux.dev>; Fri, 19 Jun 2026 16:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781887528; cv=none; b=B6bNN50esD30kiAaZ5kt/KjuIF32TLogubvc6S55fROxxS64jb/qYifn4eAil/NwCgZz8coT/hY83a1S7wfjxCrMiikU5vY1fnKFNDGI70FfbRoM5jW0LpFh6IPfWoYzb5Yu7VSz3G3VmuJPNcxUmvnsGBLUHeP5PKbsx07lWQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781887528; c=relaxed/simple;
	bh=Qtn+FdoQfW/FFYD+4u2LEi66M5qxPEqTf+ge1hzvuf4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SzxkbjZ/zNUBIyZyEWzbopC9tfTLHgdbTpE1PEqVURqXd+gbsmRoxq2uEsmrLLhFLjyKGsdoEdVWpIKLyfuOElthgTikrJgp3okduhiC9fZH8PvjEE/k5lmAMdmAJUMqqoEOOgkUysc54FQ0TFnZbw2klA5p+Zl027BemH7UP8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D/LH/rlT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D/LH/rlT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D491A1F000E9;
	Fri, 19 Jun 2026 16:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781887526;
	bh=lM49Ei0wZ+A/CZgLuAfOKTKqnfAeeuTCx37DfOaSJsU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=D/LH/rlTZM6odgkjFZbq/ROJqSCOTK8sg3VhR9kMBlGNCikZjKncQMORdos3NSfpa
	 hyPVyPs2xFZB+my019/+CQsMtuKIUq8qrjFij1emdQu7tk2kHaFoTNFoTnQbcaon8f
	 aOMOFCkAMNEpXqDg56uqRg9pGix0ps+GAqUqFq/JLvZRjUOZyXNR/6seCC/vPDv34Q
	 8CNVLy7ge8lwJ+Uhwsat3NKrbyVCZknSyxZcjZlv61Fj9MabTE8v5XuiGDPkUqDyg/
	 dk3L3EFLBKv7HqSSNIbjzP5T/Lwo9gtvknCx1bCmfyLMbg2s+c4uCCP77QYCv3WMLp
	 eQ7fTqL8cYVDg==
Date: Fri, 19 Jun 2026 09:45:25 -0700
From: Oliver Upton <oupton@kernel.org>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Will Deacon <will@kernel.org>,
	Vincent Donnefort <vdonnefort@google.com>,
	KVMARM <kvmarm@lists.linux.dev>
Subject: Re: Sashiko review emails to the list
Message-ID: <ajVyJa-mZmYGzt6o@kernel.org>
References: <CA+EHjTzdCf2waY_Qc+GWzA-MuKG=_XjQ4Hzn3HJ6Yi0NfB_CzQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTzdCf2waY_Qc+GWzA-MuKG=_XjQ4Hzn3HJ6Yi0NfB_CzQ@mail.gmail.com>

Hey,

On Fri, Jun 19, 2026 at 03:19:05PM +0100, Fuad Tabba wrote:
> Hi folks,
> 
> I really like Sashiko and find it very useful. It's flagged real bugs
> in series I and others have posted to the list (e.g. [1][2][3]), and I
> run it locally before sending, which has saved me a few respins.
> 
> That said, it's been posting a lot lately, so it seemed worth asking
> how the review emails to the list are working out, and whether we
> should change anything.

So this is entirely my fault since I added the email configuration for
the kvmarm list. Sashiko has been finding some truly nasty bugs, posting
on-list is the easiest way to get attention from the right folks to get
things fixed.

With that being said, the signal to noise ratio hasn't been ideal.

> These fixes will take a while to land, so the question is what to do
> meanwhile. Some options, and surely others:
> 
>   - Leave it as-is while the fixes propagate.
>   - Stop the emails but keep the reviews on sashiko.dev, so people can
> look rather than have them pushed.
>   - Disable the emails until the noise is down to a reasonable level,
> then re-enable.

This sounds like the right approach. I'd like to re-enable emails once
we're happy with the quality of reviews.

On another note: Roman, is it possible to separately report pre-existing
issues from findings in a patch? Maintainers have a higher likelihood of
caring about these than individual contributors anyway.

Thanks,
Oliver
