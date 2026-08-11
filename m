Received: from out-189.mta1.migadu.com (mta1.migadu.com [37.59.57.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1DD6446C0C
	for <kvmarm@lists.linux.dev>; Tue, 11 Aug 2026 14:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=37.59.57.117
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786459573; cv=none; b=D07E+P/WLXtBOsbBX3+MWnj40YYgYF0GsA5wu8NYeXabRNC4MEuxl38n7Yk33JPeSjcxr9oHcCmuE2MEMP5tFrZOESzY88wEpGmmpwEE4wb6JjtZzkHpG+aHP7y4CzwdGqomSOxy2MDHR5KdcrWeDS9EzkL8h6oESTlSgXAGadU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786459573; c=relaxed/simple;
	bh=Bd+Bl/a3Plzw7PzGw0HfdsccKH/tRTwcysEidL485Qs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LfJ09g9V6zP4c0jqdc1rJcvnyaQIHQO22ZAPw6UcGe8bVSRMEqEFfEzyXN/Zaq96k5PLP8fYl8UK++aMOLS2jeGPxvdl+jTu/X/LH4G7g/CYrDF4oI+sUaa8TgabJui1MuybEPdROVyKfWIg0Zn66H3GhPZkO62Q3WY4zvfQfVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=QZH8xwGH; arc=none smtp.client-ip=37.59.57.117
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="QZH8xwGH"
X-Forwarded-Encrypted: i=1; AHgh+Ro/mQ6A3978oEVDTfK0qIqmCnn21jqFLqu8sIou1h6aQ2d8MS5fKs4BS9qqdXiTz0Ijqf/EqH8=@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786459570;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bkBsw0nlNKffF346uy8TG9H988zPUKGCrYeJMzVpF88=;
	b=QZH8xwGHhl6VKe14RnPmsOzhyfPDNZpMlffiUVKuiwG5QMVWmf1/rcUDkdXAk+Yw3puRbZ
	5tDMWdiKFCA7rm1jwkCgjp6vd170VmdsFMKMTfhi6tBkD23GTQpKKKhqd2sK/hyrZX6r3O
	7q1xusdzVKbyOcst6e51kUE0q3wQy3I=
X-Gm-Message-State: AOJu0YzpGpVXeXHc7LuT+zaulbTXaV6RRq8gDPkRN+T5bcI6zR2h1AI/
	oOXiZKP2lXZEOm3OLcb1yMrM0tZHvTAlQFICE2bhW6Up9i6b+WiyVjq4QXrfbgu9Vp2vT7RoC9W
	5QpY/63bNveQ/O2NaBT/NX1Xsk4kZ+vtTi6eaH3TS
X-Received: by 2002:ac8:7fc5:0:b0:50f:af60:3496 with SMTP id
 d75a77b69052e-52d5805b682mr10634971cf.1.1786459525915; Tue, 11 Aug 2026
 07:45:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260804112317.1937387-1-fuad.tabba@linux.dev>
 <20260804112317.1937387-2-fuad.tabba@linux.dev> <20260810183017.32db8b80@gandalf.local.home>
In-Reply-To: <20260810183017.32db8b80@gandalf.local.home>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 11 Aug 2026 16:44:48 +0200
X-Gmail-Original-Message-ID: <CA+EHjTxge9X+XyNPpJwrpK5wiO4cHRHJrCPMPgo0iZBXHSLPxQ@mail.gmail.com>
X-Gm-Features: AUfX_mxjTGmsQJDiPjF8-9rvIAUMM_O2scFaxYRWXLqNn62taG1aJ6Vh3ON23CE
Message-ID: <CA+EHjTxge9X+XyNPpJwrpK5wiO4cHRHJrCPMPgo0iZBXHSLPxQ@mail.gmail.com>
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

Hi Steve,

On Tue, 11 Aug 2026 at 00:30, Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Tue,  4 Aug 2026 12:23:07 +0100
> Fuad Tabba <fuad.tabba@linux.dev> wrote:
>
> > trace_remote_event.h uses bool without including linux/types.h, so a
> > translation unit that includes it ahead of anything else that pulls
> > types.h in fails to build, as with nvhe/trace.h at EL2.
> >
> > Fixes: 072529158e60 ("tracing: Add events to trace remotes")
>
> Is there a config that already fails the build without this change? Or is
> it that new code will fail without it?
>
> If it is the former, please drop the fixes tag, as nothing is currently
> broken. If it is the latter, then sure, keep it, but you should mention
> what config options break with it.

I checked the include graph and tested by building with configurations
that could potentially fail. Nothing does. I dropped the fixes tag in
the branch I have based on kvmarm/next in case Oliver/Marc want to go
that route [1], or I'll respin it on the latest tag once kvmarm/next
has gone in to the next tag.

Cheers,
/fuad

[1] https://android-kvm.googlesource.com/linux/+/refs/heads/tabba/pkvm-hostva-kvmarm-next




>
> -- Steve
>
>
> > Acked-by: Steven Rostedt <rostedt@goodmis.org>
> > Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
> > ---
> >  include/linux/trace_remote_event.h | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/include/linux/trace_remote_event.h b/include/linux/trace_remote_event.h
> > index c8ae1e1f5e721..e4cc2d4497bcf 100644
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
