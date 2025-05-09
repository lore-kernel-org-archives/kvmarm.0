Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FFCE23CEF8;
	Fri,  9 May 2025 19:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746820440; cv=none; b=jRpGgdvlEOiRboBtxEQtgod1wbqMDeR7X/008sMOUxhEpdO7d2VROQo6W3Ewxtwc7rrzNOt4mi1ADOzjAIEsl4+f7wKM2Fs0OWN3S7mNQ8IS4RJcl0vnCB0SdQrrSrFXk1QbTlEw+OGsfGKEwgwazL8v8L1CVEOTYcG+4jA1+/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746820440; c=relaxed/simple;
	bh=9F7MpQr8DTQtiQSo+kr1eN+p3ADiua+iMiJ1xVEnzX4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SR8DLqHhmCWUX5z5XsC7aZmuXgMl95OfiBq+XOfyHBMyQwOA0PMZ9cQoDUJKWNdlFSGD9CVGmWJ/6ed4DDMat59SyLZRN7h2lPpVXDwcjP5qNNX+Oer6RxziEXU3rtX8SgjMZYkG1rIm8ZSP06PhTFVTKAc5a47SZly0i1Ii7Z0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4BE1C4CEE4;
	Fri,  9 May 2025 19:53:57 +0000 (UTC)
Date: Fri, 9 May 2025 15:54:12 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
 linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev,
 joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
 kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 jstultz@google.com, qperret@google.com, will@kernel.org,
 kernel-team@android.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 08/24] ring-buffer: Expose buffer_data_page material
Message-ID: <20250509155412.03c89196@gandalf.local.home>
In-Reply-To: <20250506164820.515876-9-vdonnefort@google.com>
References: <20250506164820.515876-1-vdonnefort@google.com>
	<20250506164820.515876-9-vdonnefort@google.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue,  6 May 2025 17:48:04 +0100
Vincent Donnefort <vdonnefort@google.com> wrote:

> In preparation for allowing the write of ring-buffer compliant pages
> outside of ring_buffer.c, move buffer_data_page and timestamps
> encoding functions into the publicly available ring_buffer.h.
> 
> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

Let's create a new file for this instead of adding it to ring_buffer.h.
Although it's being used by remote buffers, I rather not make this
something that people may think they can access anywhere.

Perhaps: ring_buffer_types.h

with a comment stating that these are to be used by the remote ring buffers
and the ring buffer internals and should not be used directly.

-- Steve

