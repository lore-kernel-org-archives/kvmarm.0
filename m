Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5786189F30
	for <kvmarm@lists.linux.dev>; Thu, 19 Feb 2026 17:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771523727; cv=none; b=ipEmtrtqUIa1yGchX2zLQEGcvFHVKqrR746w8f7H+RCKfmQEBH4RGSrdqbWk/a1+058DBaHKcI4MY4tbBTIEPPnQ7633UlUHbho6w3Z7xNWgHus3c+mUPeYnvn3Nq27Afw8sAWTdvS37W6edBw6q1ZR6MdN8X9CcXjw9P1/1fO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771523727; c=relaxed/simple;
	bh=YVCUaCbE7jxx5AjeNPAyiWKDLsmidPJOGJn61Q8aNDc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cigiXk4Vi08qQKFaPpPoaMNfOQgCHFMUS4zMksHPpm1m3Q9ueZPmh8iOn1waC3+U7zEsaRFPOqK8Jo7shT0LDPC/3xUvZAuiCZj5BBKSelY5G/XtoqUrQihroctrrnjPDtRjGp3p7ecdftpdJ/45j+oK0pomo95B28kvOlxfnVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D4C8A160672;
	Thu, 19 Feb 2026 17:55:22 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf18.hostedemail.com (Postfix) with ESMTPA id 70B362E;
	Thu, 19 Feb 2026 17:55:19 +0000 (UTC)
Date: Thu, 19 Feb 2026 12:55:25 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
 linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev,
 joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
 kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 jstultz@google.com, qperret@google.com, will@kernel.org,
 aneesh.kumar@kernel.org, kernel-team@android.com,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v12 05/30] tracing: Introduce trace remotes
Message-ID: <20260219125525.12afbcfb@gandalf.local.home>
In-Reply-To: <20260219150307.14538-6-vdonnefort@google.com>
References: <20260219150307.14538-1-vdonnefort@google.com>
	<20260219150307.14538-6-vdonnefort@google.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspamout06
X-Rspamd-Queue-Id: 70B362E
X-Stat-Signature: u1he8b9g4za14gbwiygmi6hbhxy3z4a6
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1+WMo3F+bs2zk/Y4yoqF8XVhVwxseeWyj8=
X-HE-Tag: 1771523719-921131
X-HE-Meta: U2FsdGVkX1/LrJvJg4Wy78/u4/54AVEg1GJ5/mPuHr184EDrrqbRAapQiOKf1wx/fZLKN9iKRYe7XUwEmWB99Jo1BUX+JwLqRCR1mB6OKIhrZRTp2AdWwply1KIgOUEvvCSe35AwcfN+ktt5BlnYkneOlwAgds9O2H04tY3J+Mie/F5gCQrBAoukRUvzZ70v9jSsVY9wD8fUJ4ocO/oL9m40P91q8gNGt66xvjt1fKhnc5zqXNVQk6EIsmNbU1aqj8l8N1+t0ebr46WcAN/brlqaQOlxxl6SzgzAnRO8fpgORzlMhzyHmqEuZJgStuNN6+Z1t6u97wytW8IM5mDrMxGi22eUnN1nkSkkN/WaTfLRbQME+WLTRFEmgbEIYi5U1sLw0qQ7yJG1eMFmvq5Pvw==

On Thu, 19 Feb 2026 15:02:42 +0000
Vincent Donnefort <vdonnefort@google.com> wrote:

> A trace remote relies on ring-buffer remotes to read and control
> compatible tracing buffers, written by entity such as firmware or
> hypervisor.
> 
> Add a Tracefs directory remotes/ that contains all instances of trace
> remotes. Each instance follows the same hierarchy as any other to ease
> the support by existing user-space tools.
> 
> This currently does not provide any event support, which will come
> later.
> 
> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>

-- Steve
