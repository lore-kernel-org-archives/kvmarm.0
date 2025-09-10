Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4C63279792
	for <kvmarm@lists.linux.dev>; Wed, 10 Sep 2025 16:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757522671; cv=none; b=eZldALsuTxMJ0qbE2fXN2e717jufu0GLQggohND1E4c8MHXwQ5f5DQEwR51U8vpY+31Vf0a74g/LQwi64eepwCed4qVF2loDbUdlvjuAqdurTIzsgsqL3zYIM7C8WrJzWUTQ2kB1ooOiO0SslgnYgCijUb3wQW2pYek8CCCmHtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757522671; c=relaxed/simple;
	bh=r/7R8Ot9/dUoaakmLAlilgN6nH8AAdJU83ErrVJsziU=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Vrnz/XwR1nag1y7azoS9FrTTRm9sQfB8R9fWasfXNv1kI+wHiNlyvanghixKWP5LWzwaqWyimFPmqRSjjFqm//HoTtQ5uOmW0YaFiJ7+eu1IJEyaW/lU/CFRotO/dgA5oPwFccLv0lNpHTKzVci99FPYHOlHjrHSARSUkPtTGw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 86C39117880;
	Wed, 10 Sep 2025 16:44:22 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf19.hostedemail.com (Postfix) with ESMTPA id 2C88D20025;
	Wed, 10 Sep 2025 16:44:19 +0000 (UTC)
Date: Wed, 10 Sep 2025 12:45:09 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
 linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev,
 joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
 kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 jstultz@google.com, qperret@google.com, will@kernel.org,
 aneesh.kumar@kernel.org, kernel-team@android.com,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 04/24] tracing: Add reset to trace remotes
Message-ID: <20250910124509.14e2c69f@gandalf.local.home>
In-Reply-To: <aMFIoY5yfQa2Mzgk@google.com>
References: <20250821081412.1008261-1-vdonnefort@google.com>
	<20250821081412.1008261-5-vdonnefort@google.com>
	<20250908193757.079aae76@gandalf.local.home>
	<aMAZMaZJ1_Eny5Ku@google.com>
	<20250909094028.3265b751@gandalf.local.home>
	<aMBSa29ev0BNgr5R@google.com>
	<20250909143948.420bfb1c@gandalf.local.home>
	<20250909145236.69192cd0@gandalf.local.home>
	<aMFIoY5yfQa2Mzgk@google.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 134qpie7ddpmaaj1uqq33s96zuakqbyg
X-Rspamd-Server: rspamout05
X-Rspamd-Queue-Id: 2C88D20025
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX198PcTMaukh33mwqIRhwDqNrdifUI66crI=
X-HE-Tag: 1757522659-640068
X-HE-Meta: U2FsdGVkX1+3HNOYDX1kRWm9XkAAF+NlcLIGDkVLNzH1iYc4AWJqpIE4VZh98lQ3n2BNfksoq8Ym95szXl+L/hfduWR7OZyh3GRJVva8FlS31lxD3CEgOEKS1r6yQYmDyZyenpn373H68mcmS/pwNT8pKaTsscTTW7IR40+AtInmBfP6fnOPDWhUJAnLgb55qs0+7T5ogk8bErBQMhjry4WIAd3WvaYerSAPYDm+kTYY0ok77pNa6gB4Nv8k1FnfxgDnnp8nzeKLCJl2mQ/V+GpU4LvSEHFKNvbdusHhezxS9U4DDjZopePAJouWK3I5wLt31uqWfwnwa/7vF2bQcicCLYR/QwW+

On Wed, 10 Sep 2025 10:45:05 +0100
Vincent Donnefort <vdonnefort@google.com> wrote:

> > If we are gonna keep the "trace" file, let's make sure it's fully
> > implemented.  
> 
> I was more worry about the ring-buffer page order that can be reshuffled on each
> swap_reader_page(), making the page links useless in the kernel. Ideally, the
> meta-page would keep the page ID order somewhere.

Yeah, internally we could keep the order of the pages. Shouldn't be too
hard, as the swapping happens by the kernel.

> 
> Alternatively, we could walk all the buffer pages to read the timestamp and
> re-create the order but that sounds quite cumbersome.

No, having a separate array of the order is probably what we want. Then
every swap_reader_page() will update the array. The trace iterator could
simply walk that array.

-- Steve
