Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C3E547A87E
	for <kvmarm@lists.linux.dev>; Thu,  6 Aug 2026 12:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786018800; cv=none; b=VWS/NUfr3s2JzZr5WrKmBpuyDRKQWn/l4AalK1dqRPYM2awiTjkYIoZ+YxGBMGLdeXiH0xzBY0+x8KEL4Da++GEoVk3J96peRQzVz42LfCQ1kyyZ8HHugggFZtNVCvkvcZ+xxsTvGXbT6vEKoKPDGxrqRkjstq6WEPpWPsbAac0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786018800; c=relaxed/simple;
	bh=IL82bkQoogT0tIzedkG7o6bS3g1xKVlq3ylx4i0lUVo=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RDhNVzPM6m8UTH5z2fqEE3wpDdK93rWhPK4FlatbkJGf2OzBEd9bQCYaw0HAuNvk8qz0eDfmqhw5PSzu4x21PqAnArp4vbxSkNXx5t6GiYOFSbFR++vaLex6mTy1fEuio/xIFIwjmU2m+4VA9lnMMHPRNnNb+OwmOYPv1NSCRtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 06F4F4071F;
	Thu,  6 Aug 2026 12:19:55 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf13.hostedemail.com (Postfix) with ESMTPA id 8425720010;
	Thu,  6 Aug 2026 12:19:52 +0000 (UTC)
Date: Thu, 6 Aug 2026 08:19:52 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: maz@kernel.org, oupton@kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, catalin.marinas@arm.com, will@kernel.org,
 mhiramat@kernel.org, alexandru.elisei@arm.com, vdonnefort@google.com,
 joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com,
 yuzenghui@huawei.com, qperret@google.com, ardb@kernel.org,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH v3 01/11] tracing: Include linux/types.h in
 trace_remote_event.h
Message-ID: <20260806081952.5cbd8170@gandalf.local.home>
In-Reply-To: <CA+EHjTxZ1tBfau4eK-nOdqig1xwngzsq8YyHtiE-iAMkZpSF8g@mail.gmail.com>
References: <20260804112317.1937387-1-fuad.tabba@linux.dev>
	<20260804112317.1937387-2-fuad.tabba@linux.dev>
	<20260805165432.0118a513@gandalf.local.home>
	<CA+EHjTxZ1tBfau4eK-nOdqig1xwngzsq8YyHtiE-iAMkZpSF8g@mail.gmail.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspamout01
X-Rspamd-Queue-Id: 8425720010
X-Stat-Signature: r86qiecciymy1dxrye8d3wyxeubaweq4
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX19xrAhumewMEU9bfBTbxDXmAHqbmaYBTcE=
X-HE-Tag: 1786018792-901548
X-HE-Meta: U2FsdGVkX195zuqn6+P/oJUmDDmBsGeDk/Dol51GDMslSARahWNz568H6AtS7EGsXujFR5EgnerJAA1FLcRtHPbxXpVUqLywGSkHQCrLp5MMyOzhfpBJktvO9poZuZIuc2bqlmAIxIsHu6m1BBV10K+mDygWR0Q72fcRl0tfpITuQ6ol0J6Uq1wof/YO35DXnmCeVAZfY2ACGKSPARPQ5q6a4D5JodKbU9zOfAXLY6igoorxNrttkORPBbra1VvJ6+fyPYWKHprBf7RlDIqX1WHxGhaue79t/6UsjyUwbZcuAYGowA4DC0/RtB1xeIJp

On Thu, 6 Aug 2026 09:43:00 +0100
Fuad Tabba <fuad.tabba@linux.dev> wrote:

> > My ack still stands, but I wonder if we should just not use the include and
> > instead s/bool/_Bool/ ?  
> 
> I'd prefer to keep the include, if you don't mind.
> 
> As far as I can tell, apart from the typedef itself, the only headers
> built into the kernel that use _Bool as a type are a uapi one and
> arch/um's user.h when it's built for the host, neither of which has
> bool available, plus what looks like a leftover in bcache_ondisk.h
> from when it was uapi.
> 
> The include also covers whatever field gets added next.
> 
> Happy to switch if you'd still prefer _Bool.

The reason I suggested this is because I'm not sure how much we want to add
Linux headers to files built for the hypervisor.

If Vincent is good with adding this, then so am I.

But I rather have him give an ack before we do.

-- Steve
