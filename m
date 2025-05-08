Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EF80245008;
	Thu,  8 May 2025 14:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746713113; cv=none; b=iKX7D1+rDWeZ6o/J8F6nACSFgGoujePoNxvH+Gdj9MRzFCo10hcBFOlgLz+JzeBfB0nmoAMx+ls2AIVOLonVvQfkmuC8AB66iEccowIxQ5APs22FuUsmuGt4jhnb1x4el9Z/umplaJ04QipJ1dqOls2pye+44WF1//ew4gjXAJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746713113; c=relaxed/simple;
	bh=4tmmAWJlkbjL1Nm4lMJmI0kVjwvxTXhmNQBdvHjddZg=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eiNxrqq6+gNAXwYumhLP3j24xszShJ69S+gK3/J3oFiZIJqRVJZkNp8js240euxN7oRfxC4d00+GqJuWy/wHJvg2tf2MAHLAS/Lf8Q1Wqnu+vjn7r1XvqhsgWuvPOgMPuw09ZYTQ9swtlWG51rK18PFQ1sJQz+gVLgdyBSrnn64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 113B4C4CEE7;
	Thu,  8 May 2025 14:05:10 +0000 (UTC)
Date: Thu, 8 May 2025 10:05:23 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
 linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev,
 joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
 kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 jstultz@google.com, qperret@google.com, will@kernel.org,
 kernel-team@android.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 01/24] ring-buffer: Introduce ring-buffer remotes
Message-ID: <20250508100523.750dfbaa@gandalf.local.home>
In-Reply-To: <aBx1EBa6QFH7dmqs@google.com>
References: <20250506164820.515876-1-vdonnefort@google.com>
	<20250506164820.515876-2-vdonnefort@google.com>
	<20250507194722.263a8d1e@gandalf.local.home>
	<aBx1EBa6QFH7dmqs@google.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 8 May 2025 10:10:40 +0100
Vincent Donnefort <vdonnefort@google.com> wrote:

> > Hmm, I wonder if this would be worth adding to the user interface?  
> 
> Would trace-cmd have any use for those fields? That said, even if it does not at
> the moment, it would mean the meta-page has a single version between
> kern/user-space and hyp/kern which is probably better?

I was thinking that it's better to have the consistency than user space
using it. I'm not sure how much overhead it has for the normal buffer to
update those fields.

-- Steve
