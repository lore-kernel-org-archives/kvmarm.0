Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2303E4F5E0E
	for <kvmarm@lists.linux.dev>; Wed, 30 Sep 2026 15:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783066; cv=none; b=e7zIIAk3t4yX8aD50QDTB+sDm7P+CaQ8ZPZW+8vpSzA6K2EsWPrwSOon6AuOoKaAUs/+sFeXryLYobPYHunzsuWli6dabDCw+8Hgk70x/dPPrjPDJduJcRFhOv843+A4S3oPeoaYkTsgQFzmyeJ4khGxrLCnYhptkt+Ao/zwn3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783066; c=relaxed/simple;
	bh=n2w0f2BUpWFG6UBWcHupqkdiNXU0uKV812nFX28fzow=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=eBaxQLuLrUBP4OJ2oHP5mwEwLBccFvSs2zwHBWFpmnm4robMXxcqDLJoQ/HS7h6UeoPelkEUiXphcVUeXalPLXeyCnQr9axINdsH9ylZhrJE3drrKvQTOO+08QRjVlhXWa+bGbaurUUobCUAX/gjXh55QJkUVY2EpeC1okjz1/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QFCAmkOV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QFCAmkOV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7CC21F000FF;
	Wed, 30 Sep 2026 15:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790783057;
	bh=FMzUWP/gHY//zU7ZFHJo2aaa46I8A9yWFF2zm9QMAdM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QFCAmkOVTGbbZV8pwyEGmS0NoEkbQhzPHLrykeI53xihLtoraqla48y5lQkc11Gm4
	 MPX/lTdBCWMj09+J3S8VwsSPgczx4xc2yF4h7AXSdj3X7pltqX14KP+TQBRa8tp5L6
	 KSI93KlPi2AFMjSUeqion1RShp627DAZEj7a6hIMAoV6TG9NDY7B5Oc6/rKRSDeV4E
	 Q75iVfFu7QAQBxyePlVZxM4kTMb8XOrlIiY5Q9PrEWkVU/yRGfvXJLNXuLEtC+QKxS
	 apTVSDz2wGbAuwfxQMDgj8MRHQLCJmSzUFL06cBSbywHj9fCfaBl2F3sXkrg3bNpLJ
	 rh7c5nUcg2B/w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 3/4] tracing/remotes: Add
 REMOTE_EVENT_CUSTOM_PRINTK() helper
Reply-To: sashiko-reviews@lists.linux.dev
To: "Vincent Donnefort" <vdonnefort@google.com>
Cc: "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260930153505.2144559-4-vdonnefort@google.com>
References: <20260930153505.2144559-1-vdonnefort@google.com>
 <20260930153505.2144559-4-vdonnefort@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 30 Sep 2026 15:44:16 +0000
Message-Id: <20260930154416.C7CC21F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] tracing/remotes: invalid unquoted print fmt string breaks libtra=
ceevent
--

commit c1fe85ccb9998d0f07df828f87f45a8f874da608
Author: Vincent Donnefort <vdonnefort@google.com>

tracing/remotes: Add REMOTE_EVENT_CUSTOM_PRINTK() helper

The current REMOTE_EVENT() takes as a __printk argument a string format
and a list of arguments. Add a REMOTE_EVENT_CUSTOM_PRINTK() where the
__printk argument can be a function. This intends to support the creation
of a "printk" event for the arm64 nVHE/pKVM hypervisor with a dynamic
prototype and by extension a dynamic print format.

> diff --git a/include/trace/define_remote_events.h b/include/trace/define_=
remote_events.h
> index 676e803dc144d..4f4d58e37b84b 100644
> --- a/include/trace/define_remote_events.h
> +++ b/include/trace/define_remote_events.h

[ ... ]

> @@ -70,4 +79,8 @@ do {											\
>  		.print_fmt	=3D remote_event_print_fmt_##__name,			\
>  		.print		=3D remote_event_print_##__name,				\
>  	}
> +
> +#define REMOTE_EVENT_CUSTOM_PRINTK(__name, __id, __struct, __printk)			\
> +	REMOTE_EVENT(__name, __id, RE_STRUCT(__struct), "Unknown")

[Severity: Medium]
Does this unquoted print fmt string break libtraceevent parsing?

This macro assigns the literal "Unknown" directly to the event's print_fmt
field. The tracefs format file outputs this field directly, which results in
print fmt: Unknown instead of the expected print fmt: "Unknown".

The standard libtraceevent parser expects the format string to be enclosed
in double quotes. Encountering an unquoted string causes it to be misparsed
as a field variable (which does not exist) rather than a literal string,
preventing userspace tools like perf and trace-cmd from parsing the event
format correctly.

Should this be escaped as "\"Unknown\"" to preserve UAPI formatting
expectations?

> +
>  #include REMOTE_EVENT_INCLUDE(REMOTE_EVENT_INCLUDE_FILE)

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260930153505.2144=
559-1-vdonnefort@google.com?part=3D3
