Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8199223708
	for <kvmarm@lists.linux.dev>; Thu, 29 Jan 2026 00:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769646422; cv=none; b=rNkxYMEzPAC10b0e0TZCogF9TNJLo+PPc5bV29K0ZjHeexvmH+6dacmps5YET7StyuX7QYaweuzBiDVRarsmGB55/LCYi/Z1oI2Z6oyyJDZpGqseJMdRHvzIAhVzwL7pGZ1gq9Pk53SLCHNLjOqE6O8KCHTI+HFJ9WYnPHwjO7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769646422; c=relaxed/simple;
	bh=ETgoJ1e0qhwlQp5U2A+meE0vMSIkx8x5d02DJSWJz+Y=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jD08LRDSzWnSrjhpbDdScD9Zl7hdKepLYRfeDdfY+68HEFcv/77gFo77ddbRUSHGflt46+9YgMNadM0IRbRrHo1COIb2scz3G31smiuO78TZX8+wc4RLD+xf3QvSZtoSDMSxD6jYIHHwpIIav4BFanB3aBe2JJjj4EjMS1wy8k8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 25537BB28D;
	Thu, 29 Jan 2026 00:26:59 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf18.hostedemail.com (Postfix) with ESMTPA id B072F2E;
	Thu, 29 Jan 2026 00:26:55 +0000 (UTC)
Date: Wed, 28 Jan 2026 19:27:05 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
 linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev,
 joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
 kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 jstultz@google.com, qperret@google.com, will@kernel.org,
 aneesh.kumar@kernel.org, kernel-team@android.com,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 06/30] tracing: Add reset to trace remotes
Message-ID: <20260128192705.197f85da@gandalf.local.home>
In-Reply-To: <20260126104419.1649811-7-vdonnefort@google.com>
References: <20260126104419.1649811-1-vdonnefort@google.com>
	<20260126104419.1649811-7-vdonnefort@google.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: hx95fytmscwrpp1wo5jpp5jrfr6wftjs
X-Rspamd-Server: rspamout03
X-Rspamd-Queue-Id: B072F2E
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1/PaWGWKmzPr61am9mcBR7HtKL+iIVurNY=
X-HE-Tag: 1769646415-151747
X-HE-Meta: U2FsdGVkX18EUZivgGgaI3rGbX9lP6SRN/C0D1hJVndEwct7b0/0rTgEaRbeN3zmk2bGrbt9QF86v9HLa4nlJhBwQnxtWyUIaOb76e1UHMmHWwqod6bMm/Vzr5o9SfT3MwRRYGaXKP7i3xXnaIfXEmT+SXFEos60MO8oBF14cFsaj88X7qpwGaxq2gsus3H4WBCX4e+ruNxVpWBC9zlH4l4ys0OlQlxjClJFJAqVOwbzNsJPsAvrep6ZB8GOeL4/Cs15KosxFjEaFcBOj9NW/Dgz8cL4JyKq37F6RgRFNT2c4a7e15hJ7BXB7IxWYra//1woaLmnnXVFPryZ+0tUpOyjl0ptnHalzAHjiLQYgUii1Q/q9LUyC5I7V7hZ0AD64/8/LC5uaUeVPBZzM1T5hQ==

On Mon, 26 Jan 2026 10:43:55 +0000
Vincent Donnefort <vdonnefort@google.com> wrote:

> Allow to reset the trace remote buffer by writing to the Tracefs "trace"
> file. This is similar to the regular Tracefs interface.
> 
> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>

-- Steve
