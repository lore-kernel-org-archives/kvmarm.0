Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4101923AB88
	for <kvmarm@lists.linux.dev>; Thu, 29 Jan 2026 00:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769646521; cv=none; b=iMGCqA3ozrOR80Ro4Y9HDiIpfvubsUfhT7LYHMVaDSl0xE4FEO8d4uSSz4qaRfTm2TVotm2RteiRE5ZJWRXp4R8XAzpaoDyIZfkznYLGKK5+sjemqU7il8qAxC//gBHOw9vXwiBJGcydcQVhP1GFImk9B0bXH/Ne4KfRVZZi+z0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769646521; c=relaxed/simple;
	bh=wKEc9F2r7UVY6wp3JVJXFSFB8gStjVRTmn34J1Hmsr0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QWxLSkfFrV2Qkp4TywtgyDxK9yO0gKc2uOHJ3oXqX3kyWHq7K8o53gw9Y9VtBXBGr4lmNJBW7cxcI+4h5ps63ePIPtHYE76vRot8MEvO/NnpbzokFZQlaDJ+j9oP1z/9BxFEhiOg0UzbNfi2tYzcaWVX51Go7l2EeU6to9lCSi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D8D5E8C375;
	Thu, 29 Jan 2026 00:28:37 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf08.hostedemail.com (Postfix) with ESMTPA id 7518D2002C;
	Thu, 29 Jan 2026 00:28:34 +0000 (UTC)
Date: Wed, 28 Jan 2026 19:28:44 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
 linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev,
 joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
 kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 jstultz@google.com, qperret@google.com, will@kernel.org,
 aneesh.kumar@kernel.org, kernel-team@android.com,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 12/30] ring-buffer: Export buffer_data_page and
 macros
Message-ID: <20260128192844.52190408@gandalf.local.home>
In-Reply-To: <20260126104419.1649811-13-vdonnefort@google.com>
References: <20260126104419.1649811-1-vdonnefort@google.com>
	<20260126104419.1649811-13-vdonnefort@google.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: qudwhjfi81bakcw6yadd167nzskxcbx7
X-Rspamd-Server: rspamout04
X-Rspamd-Queue-Id: 7518D2002C
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1/WCv8FJD8UF+HujZYF0gJjr4sqREnC3rY=
X-HE-Tag: 1769646514-966825
X-HE-Meta: U2FsdGVkX1+cpk7hAynmRv24KxQsND7QeSfWuDxiIjRee/WvUyE1teCarGLTIbLwjfnangZaVMAZuP7bMYtfdDIBQT8RWjfRBqCXGu58AL5WIDNqH63E/+JTSeI9KSjqtpHlLk20yTtsF55OjhMvB51ctngV0TzxbDbOUZMEA3JIhJeVxPi8hguD5CEr77bN6Klq2V4Sxuwx40lDfNwo9CLsNFWkXKrDJ1W9wgGk43ENphREQ43H4QSybVuLcd7VyF/ZIL8uvkoNQxqpEHUPozAGNWmKaBG4+L9pVws3oiTNShL4ni/M5AO2S7STNx6+kaA/xKcPC2mCA0N+VEumvW0GOu2fr0AEhfOO82byCZnTe5DAq/hbOHI5LuMiITCTPe3oVRkKzfIkjP9Uz/JraA==

On Mon, 26 Jan 2026 10:44:01 +0000
Vincent Donnefort <vdonnefort@google.com> wrote:

> In preparation for allowing the writing of ring-buffer compliant pages
> outside of ring_buffer.c, move buffer_data_page and timestamps encoding
> macros into the publicly available ring_buffer_types.h.
> 
> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>

-- Steve
