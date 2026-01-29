Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16B81353EC7
	for <kvmarm@lists.linux.dev>; Thu, 29 Jan 2026 17:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769708254; cv=none; b=KVdGQ+0TXTn3nBVpJKpusxCxNmt/b4sIS8/KHpJ8zlDDM5fwCw8/OAxe0VNtN/nfa8NSMaO6WrNhSNpbzMzFgZd9x8JMhfbMEWutGX1uYIOZ9FdNWvQMp6z1EJtszM9vpP8cVmsEthfE2Zz3IIFch9J+xpBiQc8YSo8i5M4ul/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769708254; c=relaxed/simple;
	bh=4eeDZYqedG6a//apNfRq8r2MY+Q3O5UivFyaO8WY8pk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fIZcsHMPo/TVb1y23R4I4PcWjNlaEYnyUazqkgMSxEIWblgBLkhGtlysK2/tBU7yIA8/kSf8L1lRBa/EETw8NJ2d5J8ovDQhify4HHEzcwLO9ukZ9axu9W4mElG7AJpHV3tkY6i9GIA8C8BAfzKsbkzwOmWH2gSIfCsiMkJzx5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AE01A139C2F;
	Thu, 29 Jan 2026 17:37:30 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf04.hostedemail.com (Postfix) with ESMTPA id 5AA6F20023;
	Thu, 29 Jan 2026 17:37:27 +0000 (UTC)
Date: Thu, 29 Jan 2026 12:37:39 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
 linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev,
 joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
 kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 jstultz@google.com, qperret@google.com, will@kernel.org,
 aneesh.kumar@kernel.org, kernel-team@android.com,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 00/30] Tracefs support for pKVM
Message-ID: <20260129123739.3c00155b@gandalf.local.home>
In-Reply-To: <20260126104419.1649811-1-vdonnefort@google.com>
References: <20260126104419.1649811-1-vdonnefort@google.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: i3e386p3enc1g8khetg7zqh98gwfm6e5
X-Rspamd-Server: rspamout01
X-Rspamd-Queue-Id: 5AA6F20023
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX185SGLFWxWIIlWNPuU6R/rO9OX07ZYyhBY=
X-HE-Tag: 1769708247-604006
X-HE-Meta: U2FsdGVkX198IRJKBSNSZOodhqNxXkheSfTthyLQw7U19dwAdwvMwpStvYWEa4sQ8Yvve+aOpKxKCVCiuCa2tjJahjSjiQ8QCncyJ4OPNR8ui/MoeIz16e93DG1M8yodziKTBffwGLWLWlqCkyvZqe4m2P7tXhHMaPH871jux+BHugFnpaCMcj1dsFqjDHJ42WhPZFSey+iKvbBWKbLFnf9f4thildlYt7Gu9oH50rV3mRjkiDuebl12UfMQER311199ZIhINQcMOMVBqjq3jia+IfaUndGgTtHcyW7+apjJflVQOLLCq8pxYnN9Ju5VaPmzs5sso7DYmlF3/Pq437jzz5utuaCa

Hi Vincent,

I finished my review. I replied to every patch (before the KVM ones) and
either made comments or added a Reviewed-by tag.

When you send the next version, if you don't modify one of the patches I
replied with a RB tag, add the tag to the patch and it will let me know I
don't need to look at it again.

You can use b4 or download the series from here[1] and it will automatically
add the tags for you. Just create a new branch and apply the download via
git am and work from there.

Thanks,

-- Steve

[1] https://patchwork.kernel.org/series/1047043/mbox/
