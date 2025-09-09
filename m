Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FD992FE058
	for <kvmarm@lists.linux.dev>; Tue,  9 Sep 2025 18:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757443917; cv=none; b=rVXHub0qK3adtMVddLkaYjwIEfjSg8xdZpYew2CggpiI/bKQswiGhsNPOFoQCODuU90nxtjUOy2/pNUocHt+fGmH47rPwVK4JEeqYV1B7XufruPB3hpA8PXZLe16o/eXCERRwelo0BgMhgFf1BlYKRBSeeSmwp57P8755XbWkXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757443917; c=relaxed/simple;
	bh=BspH+H9bDmo8zPVTnwL3CGtMUZHBn1KnVEmbw2azLPs=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LCLGs3+I35xPy+/FVYc5hEAYDu+oVDNtHDHFFlhk0H03t/izQvpByOfIO1ny055RKfh1w/im2eyOxxLn4MJkztENaAGdSWUzdon+HP7h7h8iZex+7afZ76bH7t/TmKxar+Akr9+XCOnsM3Y93i2qSx/urHvVPbqgwpiQ/Gf3MB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F2317160720;
	Tue,  9 Sep 2025 18:51:51 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf13.hostedemail.com (Postfix) with ESMTPA id 7B67F20012;
	Tue,  9 Sep 2025 18:51:48 +0000 (UTC)
Date: Tue, 9 Sep 2025 14:52:36 -0400
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
Message-ID: <20250909145236.69192cd0@gandalf.local.home>
In-Reply-To: <20250909143948.420bfb1c@gandalf.local.home>
References: <20250821081412.1008261-1-vdonnefort@google.com>
	<20250821081412.1008261-5-vdonnefort@google.com>
	<20250908193757.079aae76@gandalf.local.home>
	<aMAZMaZJ1_Eny5Ku@google.com>
	<20250909094028.3265b751@gandalf.local.home>
	<aMBSa29ev0BNgr5R@google.com>
	<20250909143948.420bfb1c@gandalf.local.home>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 7B67F20012
X-Stat-Signature: 6jcmoe7kyeoer8m9umxo4ko1reffbtxx
X-Rspamd-Server: rspamout02
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1/Tp3xCEgkAFI9W9nCgXIN17UPOUbr/RZU=
X-HE-Tag: 1757443908-581386
X-HE-Meta: U2FsdGVkX19lVud6y51xD4pMo2ZnzH0+UrCZC4hG0ICafd9IutkjFFOMtBXudM1zmBAVN/ESckwodi3a29EU01Len6FKTmVk2tjNG99glyZ+QI696mxRxOxD2bUPYF12N/hHUtbTx6vVRZCXpWAb/7xweUx089qM/JRxCOCfk1eA4id+quq9lOrlkLW9+L2+dle6GSfGoW9IwFgYvjLbC4ZtzLIlYJA3uH0qIqcJwJqThsDREqcMQCssMntZzpGq5l0GJHyAy7fi4dCWAcWK8H91UnGqFFzUOmr9Yo/BbOFYTy3NVlTEEx5rX1M42WuDEufQlOM1JvbO1zjYLsvHPI6FqzaraTfe2/fIxIwCHJC+xQ9246RoD9BVWgA5Vh6t

On Tue, 9 Sep 2025 14:39:48 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> But anyway, I think it should work for the remote buffers too. Let me go
> and fix the current iterator.

I thought it was broken but it isn't ;-) I did it properly, I just didn't
look deep enough.

So yeah, look at the rb_iter_head_event() code. The ring buffer iterator
has a copy of the event. It has:

	if ((iter->head + length) > commit || length > iter->event_size)
		/* Writer corrupted the read? */
		goto reset;

	memcpy(iter->event, event, length);
	/*
	 * If the page stamp is still the same after this rmb() then the
	 * event was safely copied without the writer entering the page.
	 */
	smp_rmb();

	/* Make sure the page didn't change since we read this */
	if (iter->page_stamp != iter_head_page->page->time_stamp ||
	    commit > rb_page_commit(iter_head_page))
		goto reset;

It first checks before copying that the data it's about to copy hasn't been
touched by the writer.

It then copies the event into the iter->event temp buffer.

Then it checks again that the data hasn't been touched. If it has, then
consider the data corrupt and end the iteration. This is how the "trace"
file works. I believe you could do the same for the remote code.

If we are gonna keep the "trace" file, let's make sure it's fully
implemented.

-- Steve
