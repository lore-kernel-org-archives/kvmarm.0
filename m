Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F74D22FE0E
	for <kvmarm@lists.linux.dev>; Thu,  6 Aug 2026 12:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786019749; cv=none; b=dje4aZYZDp6WqDVFhpohBQy8m1uwbfbnUQTGvnHC9gKp/nQ/tTl9m987DKM+B45vomJKGRwnnb2TaqKbXgx1/ugBQoGqMwL1GHvrybqySrvLlDC7AJ10YtvCBCB2Yy9jEcyJjclIagKbH/o8VZTjLnUtYc0AqGWv5ucBb9xtcAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786019749; c=relaxed/simple;
	bh=iuqm8IUhjhGQjcfwt27SIuyIUbPXiWsuLKm8o0NR6jc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KhHshEm1EiZEzkvw0iVJ5zgKIFdMmvnFgLp22L7d2jXArefCJ3O1RCzgc2O4ov76GMdwlXDznmDCyMqAvIvjzrGFZVykFZESD/codQ3QxuM+duLlT9w3XJctAB1GyosFOLfyY9GEKjDcSlSbX/XGLRvrH3+VAEdkzflS/iM1c7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aSfpLMu+; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aSfpLMu+"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c15cd3fd760so241321166b.2
        for <kvmarm@lists.linux.dev>; Thu, 06 Aug 2026 05:35:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786019746; x=1786624546; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=/n69lRzU+/KobSt2jufolpdWS7t3iHXcIlRoKqP9Tf4=;
        b=aSfpLMu+6GDH+A0klelDWMbARkGjX/EPzmoD7r+WSIIQETFB4RWmQAn+si8rsIcrpE
         4XGDdwuTl0cAq7rl7/4+GieOlukQd2+8h6vfHkubzObvajvzUYHWHSbu+loW8QSj5tDH
         rxokAlfBLfrecM44UYlfpTKFG/g1WbNAU3fwrwYxoOxGdb+fqFI/JMeOdxShIEbPS85+
         GGgEpklQAWjRuwkEu0BibD54+eFYF/Bq8CpKLHx9dJkd2IVcWPj+20ER/zMLK9mlvPtl
         v6NDSxTWtE9A6q8PnEDv1HKIVXwzNo5KnCPZGLQDlBo/c5h3bQVuFH+DCOHW6VXglfF8
         jdqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786019746; x=1786624546;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/n69lRzU+/KobSt2jufolpdWS7t3iHXcIlRoKqP9Tf4=;
        b=mdB/8k0y2ANpdvWr3jwiWrsOqkUGWGGAq5ntKxnq1sfZb5vhWwigb+YX+TBRJ+zjmb
         PCpy8bbo6uX13Iam4iSO2/AJdyEawuZCiXe97UIHDPYAgt1OwyorpscoHEuBcJ3CEOYG
         KEWK7f/4EJhw5b2z1t3/3HcN/9EcNUEHtdt5JNNUwkXdulBBCtaYJFzQi2CyNMgjc+lo
         4KdLS9/iX10piOE0Es03WE6ISTLGexWzoSE7qIXmwij2Hy0goS9MduFpK7sE2jFnl1n2
         IGDGRTr8VvhA4+rG9UCFDXXQUNl+WExT3V5uth7Up8VVf5qiPHWwDbKN1whhcwi4eOT5
         adQg==
X-Forwarded-Encrypted: i=1; AHgh+RorMw2Cnjw5ximWVlrEJ5HIx/zl4JRL7hxvwdLX2RQStMv6Wi055Jq+i0Ya0IvkFZAFEyOR7uc=@lists.linux.dev
X-Gm-Message-State: AOJu0YzKtZ9ee38wRncPGtHynO5jmVFYeB3jrwSNavlSq27RoAqltXVx
	UWATnDjHGKyK0jCRZkYnsLlwTbzoxcRvKIpZI4xOZhrnnQyLN0eFeC2WUEU+17wb/g==
X-Gm-Gg: AR+sD12Vy2toBLekrqtrwe13BwIP69nJyp1MBIi0uaJRufv79OtNvHxmrv1qHsahRcc
	KEmhNJim7MUevzoyzXbx5PfEOWCShGBntkDkTw1Knh4bzHElfD3ZAKZveZUsoSv83TJIhzRSPq5
	0/otfqAXv+mioBSfA8Xd/0RAXgC9ujSwCleaWwrwJ9IMTetJv3iVLGng8rr69BgNce0qA7RSvFW
	4vE/NnN99wLYIf4we7/eRwg39idi3mNQBcLOx65sjbtyYi82kxVe7NWn4D2lXvuoMDpaPXqV4Br
	Lhb66YOJmFTiClpjBKfysKmvflLoFwLuMasTIj6CDWxmZWuK/JHdv+z95qYTr+9q1sxRfuxEm2r
	wzors+9AhCLV6n9x0RdYOPhuon57UDgIRc6HS52OLE7sIjkbO7+laGb1W+J6GzaN2ph9yIXw9/P
	PYaT7jvqROhxC6pBk/17FKgZ7gGXYtXdGNm2TuX+A96Gb2VMlI+Z6gcz6twEIDuFbQK9MpSTI3S
	6z4SUOisj4MQNaqzH4z6VP/BgRGUUwu
X-Received: by 2002:a17:907:c00d:b0:c16:9043:7973 with SMTP id a640c23a62f3a-c2039af8befmr794258966b.4.1786019745003;
        Thu, 06 Aug 2026 05:35:45 -0700 (PDT)
Received: from google.com (135.91.155.104.bc.googleusercontent.com. [104.155.91.135])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c203642435dsm244849866b.44.2026.08.06.05.35.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 05:35:44 -0700 (PDT)
Date: Thu, 6 Aug 2026 13:35:40 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Fuad Tabba <fuad.tabba@linux.dev>, maz@kernel.org, oupton@kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	catalin.marinas@arm.com, will@kernel.org, mhiramat@kernel.org,
	alexandru.elisei@arm.com, joey.gouly@arm.com, seiden@linux.ibm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com, qperret@google.com,
	ardb@kernel.org, linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH v3 01/11] tracing: Include linux/types.h in
 trace_remote_event.h
Message-ID: <anR_nEDeWLYKIs7P@google.com>
References: <20260804112317.1937387-1-fuad.tabba@linux.dev>
 <20260804112317.1937387-2-fuad.tabba@linux.dev>
 <20260805165432.0118a513@gandalf.local.home>
 <CA+EHjTxZ1tBfau4eK-nOdqig1xwngzsq8YyHtiE-iAMkZpSF8g@mail.gmail.com>
 <20260806081952.5cbd8170@gandalf.local.home>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260806081952.5cbd8170@gandalf.local.home>

On Thu, Aug 06, 2026 at 08:19:52AM -0400, Steven Rostedt wrote:
> On Thu, 6 Aug 2026 09:43:00 +0100
> Fuad Tabba <fuad.tabba@linux.dev> wrote:
> 
> > > My ack still stands, but I wonder if we should just not use the include and
> > > instead s/bool/_Bool/ ?  
> > 
> > I'd prefer to keep the include, if you don't mind.
> > 
> > As far as I can tell, apart from the typedef itself, the only headers
> > built into the kernel that use _Bool as a type are a uapi one and
> > arch/um's user.h when it's built for the host, neither of which has
> > bool available, plus what looks like a leftover in bcache_ondisk.h
> > from when it was uapi.
> > 
> > The include also covers whatever field gets added next.
> > 
> > Happy to switch if you'd still prefer _Bool.
> 
> The reason I suggested this is because I'm not sure how much we want to add
> Linux headers to files built for the hypervisor.
> 
> If Vincent is good with adding this, then so am I.
> 
> But I rather have him give an ack before we do.
> 
> -- Steve

We have types.h already in several places in the hypervisor, so I think it's
alright to include it here also.

Reviewed-by: Vincent Donnefort <vdonnefort@google.com>

-- 
Vincent
