Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BA36223708
	for <kvmarm@lists.linux.dev>; Thu, 29 Jan 2026 00:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769646483; cv=none; b=h/3JRTM0EePze0vGhQkDwzUJqKtlLq+VOrByD6y3+Fns7kb7o2maPbmXp8ECP8EVNH/4gPd2aYSo8cjtvWb99DBpM0+KybG2eGoIMJaJ5yIX02DNJWOzOCGfEC1YEDpKj9dNSm4ZpldyeKTBW0q0onI504kg0J8xcErfCXhz98Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769646483; c=relaxed/simple;
	bh=f3VMlX8o+KvRJTYy9tvcSYMLYlr6fZjU0/fZ6x7a35E=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dJWTmlZFmsKmY9YJ2wHl77bZvpLMJSfWpMLS2B42ysowI07gjfXa3x7qOFdbq6cGsZrIkaUVXH2qfHhg2jUKrhYzKICssrwCMbKiv835uWPbDfwgPJ00Qa4v2lfAvxaUZyqP2c/BTFwJvF65OLHtmAZTPO1hFgBqOtTARbbtpao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DE4D71B149E;
	Thu, 29 Jan 2026 00:27:53 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf04.hostedemail.com (Postfix) with ESMTPA id 6AC482002B;
	Thu, 29 Jan 2026 00:27:50 +0000 (UTC)
Date: Wed, 28 Jan 2026 19:28:00 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
 linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev,
 joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
 kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 jstultz@google.com, qperret@google.com, will@kernel.org,
 aneesh.kumar@kernel.org, kernel-team@android.com,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 10/30] tracing: Add events/ root files to trace
 remotes
Message-ID: <20260128192800.409ec6ab@gandalf.local.home>
In-Reply-To: <20260126104419.1649811-11-vdonnefort@google.com>
References: <20260126104419.1649811-1-vdonnefort@google.com>
	<20260126104419.1649811-11-vdonnefort@google.com>
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
X-Rspamd-Queue-Id: 6AC482002B
X-Stat-Signature: d56eazhnzchtmr5apwfo1hw6zon5ix9p
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX18rEWWb0ZDp69MvLdiK2KcNAtsch65RVjc=
X-HE-Tag: 1769646470-745762
X-HE-Meta: U2FsdGVkX1/rWDycGaLfdk0c9iaKzyedIZG4k2BKj5NVhUuCHcUKQHGmZhJvTRHSbUN5/Ux/1C0mKiNeONsSGzV9Bh5l9sZ5+Hmtc1ytkZ6J9ALOY+p92RqmWLkTxdBLqdqhWAEH5PjxNG3o60y8n31CgWHskdEDQV6CEB0icw9ANR2QxtrAOYaXD9CWzei/L9Qhmb1KYFBNFSz98KvpdqSRV73q5s8HTJquUgVYW0HVmx9OtJjmll+H8XzyVXIBtKprfrzDlar5v/ncgJ8u0TQdjKbTfNOIwzdALrpEpSJ5ky5+Eypt0Rz5yPaekF9zU5wX/48C+Oxpxz39aDLbuXzcCB/IgHsfjyb4EKLHnm6vgSzSu1E9JB409B4xPztCse2VCOoOA7kyB3Kfymgihw==

On Mon, 26 Jan 2026 10:43:59 +0000
Vincent Donnefort <vdonnefort@google.com> wrote:

> Just like for the kernel events directory, add 'enable', 'header_page'
> and 'header_event' at the root of the trace remote events/ directory.
> 
> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>

-- Steve
