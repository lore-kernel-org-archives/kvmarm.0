Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8E901F37DA;
	Tue,  7 Jan 2025 19:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736279592; cv=none; b=n3jqeJWMnQS+p4Gl5u4mMoAVe64T+ke1e6+ScyCsBBdCScdrr+oPlAgc1NUNOV3ubFGhEe/AcAlZzHKbek0k5S0GgAMZOXRRqKMR6C44szrpcMmhd1jqlGHdDxFYxeRnPr2qa4e4EZKS2xRV1H6mlJ1GRI8wIt2ihcBBzO3P9XQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736279592; c=relaxed/simple;
	bh=YGFpvKIg02fTJ+GW1a1CCPZozGf8TSgdYsbLbq6lkjc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZlKmmji2JsAe7qfy7583SHqXq8BfW5mJI3EdY2W6e7ECiKoiDrAA6tj7aOcgJbIGxGMgw1AUCbY9dcBtNT9E1sdTI1kJy0vARQO8DSi0mIzrLIrW+wTJWDlaX/n3Yq826ZAGT+rq5gtk6JJtmFld+eQdtxlhEIA6ebBpZkrIXfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 409AAC4CED6;
	Tue,  7 Jan 2025 19:53:11 +0000 (UTC)
Date: Tue, 7 Jan 2025 14:54:39 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: mhiramat@kernel.org, linux-trace-kernel@vger.kernel.org, maz@kernel.org,
 oliver.upton@linux.dev, kvmarm@lists.linux.dev, will@kernel.org,
 qperret@google.com, kernel-team@android.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/13] Tracefs support for pKVM
Message-ID: <20250107145439.5bd66362@gandalf.local.home>
In-Reply-To: <20240911093029.3279154-1-vdonnefort@google.com>
References: <20240911093029.3279154-1-vdonnefort@google.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit


Hi Vincent,

Are you still working on this series? I was expecting an update.

-- Steve


On Wed, 11 Sep 2024 10:30:16 +0100
Vincent Donnefort <vdonnefort@google.com> wrote:

> The growing set of features supported by the hypervisor in protected
> mode necessitates debugging and profiling tools. Tracefs is the
> ideal candidate for this task:
> 
>   * It is simple to use and to script.
> 
>   * It is supported by various tools, from the trace-cmd CLI to the
>     Android web-based perfetto.
> 
>   * The ring-buffer, where are stored trace events consists of linked
>     pages, making it an ideal structure for sharing between kernel and
>     hypervisor.
> 
> This series introduces a method to create events and to generate them
> from the hypervisor (hyp_enter/hyp_exit given as an example) as well as
> a Tracefs user-space interface to read them.
> 
> A presentation was given on this matter during the tracing summit in
> 2022. [1]
