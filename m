Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2E2C2EBBB9
	for <kvmarm@lists.linux.dev>; Thu, 29 Jan 2026 17:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769707293; cv=none; b=AP3wzCjjSSElRvFiOUUeNYZC1QkbkoaqW6OSymloheW6+4OvJrmPgeVZ9ChzsGO4QQWmd5B5f2E0vIwu1YGyyM6NgoZZ8Vj2r5pkYhEPZ2HLO5WyshO2ySj1XLdxjqAq3mQAvPzOC+FjVhaYjV+FJsQHXvXZFW6fHtfnxo0puu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769707293; c=relaxed/simple;
	bh=EGbH5tooJcr5/+8CHBlXgDb5QAFjgZqs3a028FAhAn4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S0TEndlIgwObl6OtKWz8UcUqyFD0Ne1J+btHYJCXozQkcy6njy88NvctK3NbdD+blSBO6807hyNm6xGfL5+pOP23iWRLAGoYnAfx16m0W7ZtEZ+RkZIuNUpnKJ2X/16PypFJO7WV1PTqv1D8Gh7IQ5OLKSQ50zLxdulPNkLpx9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3A3D61BCF2;
	Thu, 29 Jan 2026 17:21:28 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf05.hostedemail.com (Postfix) with ESMTPA id 943DA2000E;
	Thu, 29 Jan 2026 17:21:24 +0000 (UTC)
Date: Thu, 29 Jan 2026 12:21:36 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
 linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev,
 joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
 kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 jstultz@google.com, qperret@google.com, will@kernel.org,
 aneesh.kumar@kernel.org, kernel-team@android.com,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 17/30] tracing: load/unload page callbacks for
 simple_ring_buffer
Message-ID: <20260129122136.69873587@gandalf.local.home>
In-Reply-To: <20260126104419.1649811-18-vdonnefort@google.com>
References: <20260126104419.1649811-1-vdonnefort@google.com>
	<20260126104419.1649811-18-vdonnefort@google.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: jtfheu8shqoipi9u5yzt3fkgzru6j7dw
X-Rspamd-Server: rspamout01
X-Rspamd-Queue-Id: 943DA2000E
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1+P5mzFd4ZWUvDj9SmD6phcMvBMATTT8U8=
X-HE-Tag: 1769707284-904358
X-HE-Meta: U2FsdGVkX1/oZ8BY+DTHEu7zvzBJzXR5GM/i1Uvhm0/GmhlbTOg04hWfxm7niWNweDUchAXGe3ZhEeezDlxl79OtF6b3lHBrpu5STLNTc2w6s1ILrFX8De22XyjnNCZ/4Dc1J5+aV6iKd0M6OEXA9Y0wsbGw/MfCfhwyuzcR2ilW687CSNKk9fY9uVhYx3NLMJJIBYgLGDW6G5mVk5CAPkBlVKq0E/pMnY87yUFzDj48l1Rcu10wsuV2ZAN+HRYdPTYLLOjYVRdDXEp7fpr4Ulx1vkR+WpnIUA/Ctd5bb1h51HmM2GhYFt1WntUckszQJ7ReqfKeRmylxjapYjyYNvYNkJ9HvDBW

On Mon, 26 Jan 2026 10:44:06 +0000
Vincent Donnefort <vdonnefort@google.com> wrote:

> Add load/unload callback used for each admitted page in the ring-buffer.
> This will be later useful for the pKVM hypervisor which uses a different
> VA space and need to dynamically map/unmap the ring-buffer pages.
> 
> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
> 
> diff --git a/include/linux/simple_ring_buffer.h b/include/linux/simple_ring_buffer.h
> index f324df2f875b..ecd0e988c699 100644
> --- a/include/linux/simple_ring_buffer.h
> +++ b/include/linux/simple_ring_buffer.h
> @@ -110,4 +110,11 @@ int simple_ring_buffer_reset(struct simple_rb_per_cpu *cpu_buffer);
>   */
>  int simple_ring_buffer_swap_reader_page(struct simple_rb_per_cpu *cpu_buffer);
>  
> +int __simple_ring_buffer_init(struct simple_rb_per_cpu *cpu_buffer,
> +			      struct simple_buffer_page *bpages,
> +			      const struct ring_buffer_desc *desc,
> +			      void *(*load_page)(unsigned long va),
> +			      void (*unload_page)(void *va));
> +void __simple_ring_buffer_unload(struct simple_rb_per_cpu *cpu_buffer,
> +				 void (*unload_page)(void *));

Underscored functions are for internally used functions and I rather not
have them for generic use (in include/linux).

Perhaps rename them as:

 int simple_ring_buffer_init_va()
 void simple_ring_buffer_init_va()

Or maybe "_mm()" would be better?

-- Steve

