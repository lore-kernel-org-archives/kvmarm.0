Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70ACD1DDC3F
	for <kvmarm@lists.linux.dev>; Tue, 23 Jun 2026 00:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782174093; cv=none; b=WaPFb4dZ2f98Afjynu+Iz+2euThEhcqHcx1K6ocy3+kxaXxMm4XA1EcFWpQXdHfbEktHdt07JRRrUIsWEJaurhE/9/e2NoALwpty3mv4QslgCiSsPyWJYNrYPe4jyB2S21Rc6MAFjP/+RR39zJK/yVpMoJYvNyn2laZEg/Urj6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782174093; c=relaxed/simple;
	bh=evq3HtMOX3bw07Jfo1CfEUWAkQifQ9nQ8jZ7fDfWwKM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Zyn1DE8jtX7u9kp+/tgO50lsgT3x+Lf2NnEFz38JVPtqcIOn7nsjHVhYKQEBo3oEAfT9/f2hlO5h/eQQwKKj26vvp3AhfNOWfQNJb97kjFhMKosaxcbWJJ+7Kc4BLcgM7XVcS5ii58XJCyHrBylQTwqTnnCsw52WbSX/N44A3CU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LF55Od1j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LF55Od1j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 006A21F000E9;
	Tue, 23 Jun 2026 00:21:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782174092;
	bh=FN5+DQM0a1o1AJOQPamNCOXfPdLivFp9bIJwV444tfQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LF55Od1ji3hZKHI4MyGoR7q8IP0/fqN1LxS1NPlh+YhULNF0oKkDT0t+hGRkQtFrB
	 lGWTNpIwqmHr1vzp3PYlxDHga4nzSDvHPm8qZWe9BPGUuAAWaXolumLc/zvXzr1SJM
	 z6P4D2vogclWTlJLpaTqBIaRM+jxJ6HK8rBsbpKLMCSPVZ9QtXVZdmvxfsxHyxgUn/
	 4PVKD3HVj0CsfDVIFHmTuu5BKcfXVNI+2jN/evXuWOimPPyXQQf+aHzbkj4TujLZoc
	 OMC+NFkv5adWkmXfM4QlBS7Q6qE3tzmywFM1INrMnOiq1TwLPapK6FrVtHYpIKdfWs
	 OPmWU0E/OOLEA==
Date: Mon, 22 Jun 2026 17:21:30 -0700
From: Oliver Upton <oupton@kernel.org>
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Fuad Tabba <fuad.tabba@linux.dev>, Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>,
	Vincent Donnefort <vdonnefort@google.com>,
	KVMARM <kvmarm@lists.linux.dev>
Subject: Re: Sashiko review emails to the list
Message-ID: <ajnRiqJS8aE-0IwN@kernel.org>
References: <ajlopihdkRALO-do@kernel.org>
 <DC6D08B0-9CB2-48B9-BF1C-4300C095F2B6@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <DC6D08B0-9CB2-48B9-BF1C-4300C095F2B6@linux.dev>

On Mon, Jun 22, 2026 at 12:20:48PM -0700, Roman Gushchin wrote:
> > Including pre-existing issues inline with the reviews is fine by me.
> > What I was actually hoping for is a way to view all the existing bugs in
> > a single place, either as a summary email on a regular cadence or a view
> > on the webpage.
> > 
> > We wont have enough cycles to go through every Sashiko review so I'm
> > worried that some bugs will be missed otherwise.
> 
> I’m working on something like this and it will be available soon-ish.

Awesome, looking forward to it. Thanks Roman!

Best,
Oliver
