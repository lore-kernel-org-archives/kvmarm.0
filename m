Received: from out-173.mta1.migadu.com (mta1.migadu.com [37.59.57.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8443E40EB90
	for <kvmarm@lists.linux.dev>; Thu,  6 Aug 2026 08:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=37.59.57.117
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786005918; cv=none; b=rNjdMkj7vH1OwgNc1udvyfuhviM21E6qQD138/WV/ssY22tLUcjk4JrpJA9LetqcilQFgw25Pw+F8ZEhm02FgGDWPFLqONgsATJAOG1V1G6IHE+RHwLBA7bhstpuhRk/8f6gJ7ylIQ6L2uA9QAEpqs0sIGnyprxLLsN2hhB7BFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786005918; c=relaxed/simple;
	bh=h6ooHdgjRZHBBwOsjyP2A+6c2LHkGT/fTYtdR1Ur6o0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AmEcoBCBoWHZU7bRZDAOlKvFbtyc/WM0YIcIDXUCbnRCyfrL1OxVA8MG3Y8MUrNIoO+vA7v0dfX8LguBDnIz26H539kW3a+qPmL5snmWJxbnjxE2Kd5DmToeuVgYQA9ytEfV318T8YG+SXwqB/FxreweNPW+IQ3uT4PyKMp/+2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=vZdC259o; arc=none smtp.client-ip=37.59.57.117
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="vZdC259o"
X-Forwarded-Encrypted: i=1; AHgh+RqAtXGiqfVG6vKBk2Tp7bd8RTS3KujiBoX24fp1PgIQVSJB/Sv4UFeofwpJwBD5tQelc4lAQX4=@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786005914;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2ePEtl2m67fNMAuLJ9Afbk/hABXEN6patEcXoPge2F0=;
	b=vZdC259oML1yL+CG0shbSd3PZPfO2v9j+qww5hkVw/bdmyE1ehpdx3igSUH1nnSYZkyIKI
	8hrveTfwzW3mX+7+z/nxcyuyXmx9vpNSV7CNJwVPpY5cO6VOFz0EC5HsHhYluBNlpPc+Jp
	jpXyiyYOvqsCBBLTqElNqtg2Hu8ZzNw=
X-Gm-Message-State: AOJu0YxazupQ7MKZ4Ikh1IC4OQ676JEslDoZk70wp7GhkOlL8wQ4HtHN
	cGBE6wYPmaSRNTwVu251AvT2KS1OoFkT3ypK/w7d/7hVTdLt4WCP4vufkCcZd8ADYSnmEjylqGy
	BUPBQAnnhVeN/9F1OOZDT2FtZJjjXq3EQakGiUk4t
X-Received: by 2002:a05:622a:4885:b0:516:3f51:81cb with SMTP id
 d75a77b69052e-52cfea4c54fmr11135181cf.13.1786005891634; Thu, 06 Aug 2026
 01:44:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260804112317.1937387-1-fuad.tabba@linux.dev>
 <20260804112317.1937387-2-fuad.tabba@linux.dev> <20260805165432.0118a513@gandalf.local.home>
In-Reply-To: <20260805165432.0118a513@gandalf.local.home>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Thu, 6 Aug 2026 09:43:00 +0100
X-Gmail-Original-Message-ID: <CA+EHjTxZ1tBfau4eK-nOdqig1xwngzsq8YyHtiE-iAMkZpSF8g@mail.gmail.com>
X-Gm-Features: AUfX_mx7LtwidANKMNRCu_ciAI4sGIOLaBR410JmLmjAj3CDd42EszWO5YDN5aw
Message-ID: <CA+EHjTxZ1tBfau4eK-nOdqig1xwngzsq8YyHtiE-iAMkZpSF8g@mail.gmail.com>
Subject: Re: [PATCH v3 01/11] tracing: Include linux/types.h in trace_remote_event.h
To: Steven Rostedt <rostedt@goodmis.org>
Cc: maz@kernel.org, oupton@kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, catalin.marinas@arm.com, will@kernel.org, 
	mhiramat@kernel.org, alexandru.elisei@arm.com, vdonnefort@google.com, 
	joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, qperret@google.com, ardb@kernel.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Migadu-Flow: FLOW_OUT

Thanks Steve,

On Wed, 5 Aug 2026 at 21:53, Steven Rostedt <rostedt@goodmis.org> wrote:
...
> > --- a/include/linux/trace_remote_event.h
> > +++ b/include/linux/trace_remote_event.h
> > @@ -3,6 +3,8 @@
> >  #ifndef _LINUX_TRACE_REMOTE_EVENTS_H
> >  #define _LINUX_TRACE_REMOTE_EVENTS_H
> >
> > +#include <linux/types.h>
> > +
> >  struct trace_remote;
> >  struct trace_event_fields;
> >  struct trace_seq;
>
> My ack still stands, but I wonder if we should just not use the include and
> instead s/bool/_Bool/ ?

I'd prefer to keep the include, if you don't mind.

As far as I can tell, apart from the typedef itself, the only headers
built into the kernel that use _Bool as a type are a uapi one and
arch/um's user.h when it's built for the host, neither of which has
bool available, plus what looks like a leftover in bcache_ondisk.h
from when it was uapi.

The include also covers whatever field gets added next.

Happy to switch if you'd still prefer _Bool.

Cheers,
/fuad

>
> -- Steve
