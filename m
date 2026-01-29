Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25581239E75
	for <kvmarm@lists.linux.dev>; Thu, 29 Jan 2026 00:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769646373; cv=none; b=jYKZ8q3BUR+yeWPdASF2uIrs4ZwCpL/GKeV0lHCwgkYqjHYTIGxi3l3BL24mkcILcnh3XNorxqe716CxYn5S5prj+qpsrcU5AsdBZKzhMxMsw7LB8GqLVBYFz3ypl8/o3OZEb0Hi7QSUfr5e74P8atahXr0N2K3sXrBTOvSUaNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769646373; c=relaxed/simple;
	bh=sdunrEJXn/1RGT8ArCRCGLAugkdWutd5LRhoj6woUZE=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KFEC/MCOoRPah90FSLVZpCsQg61XeobSjPM+Idw7Y1UbCbydryNAnnD6P6tqJ2dJVfsqY0m7Fqunk1koa9FFblOut1Ow89WrEKTDuJMy1ElxoGEwQMjh9tcMSYlSqmZHVA7CRzt46qja+Vz+1x2PkazBsedV0QqHjkEwwS3wVTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D8785C2A1D;
	Thu, 29 Jan 2026 00:26:03 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf16.hostedemail.com (Postfix) with ESMTPA id 6D7752000E;
	Thu, 29 Jan 2026 00:26:00 +0000 (UTC)
Date: Wed, 28 Jan 2026 19:26:10 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
 linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev,
 joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
 kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 jstultz@google.com, qperret@google.com, will@kernel.org,
 aneesh.kumar@kernel.org, kernel-team@android.com,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 02/30] ring-buffer: Store bpage pointers into
 subbuf_ids
Message-ID: <20260128192610.705081e1@gandalf.local.home>
In-Reply-To: <20260126104419.1649811-3-vdonnefort@google.com>
References: <20260126104419.1649811-1-vdonnefort@google.com>
	<20260126104419.1649811-3-vdonnefort@google.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ujnetgib94ug6t6hojmscg4dka4y3p7r
X-Rspamd-Server: rspamout01
X-Rspamd-Queue-Id: 6D7752000E
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX19nwewCE2+i7VvsE8GxDLLQ6QU+hiCvMYo=
X-HE-Tag: 1769646360-135765
X-HE-Meta: U2FsdGVkX18dkm+4R6cqC70HRYkyAX2cnzh/6q2Jp/mV2p6gRJ7o5dSkCRv+cj0VZuBSl3b3nNq0Cus06vsEMWTZY+3b8Pl0ZillKzIAJuxM7kwtyk0tePDhGUoaQi4TZRxDLFm85DDb+kimh2xoKY3a813j5tTT34eLICmeZsQxALHwm2cxBTsQD8mpr8A38LTvdVoilFaPVXbINdws5OkBwQpy5+glzkEooaSSK9KfFplTmJ3nkN8DG/mk+lIkT27A+ZJ3cyLm+MeDpmLDhCHFAX8daUMXwCZC+oKKHW79CGKEW4EQ+Zgi1xB9Sq7fHAUWTk7b5ZK44T4mH4LRqTglAi5KlF066bG+HkU0/XraWwP4LRPKvPmd8nokAttWgclJ2MrhDvMMi8fz7c3cng==

On Mon, 26 Jan 2026 10:43:51 +0000
Vincent Donnefort <vdonnefort@google.com> wrote:

> The subbuf_ids field allows to point to a specific page from the
> ring-buffer based on its ID. As a preparation or the upcoming
> ring-buffer remote support, point this array to the buffer_page instead
> of the buffer_data_page.
> 
> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>

-- Steve
