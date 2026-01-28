Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 524042D6E72
	for <kvmarm@lists.linux.dev>; Wed, 28 Jan 2026 23:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769641560; cv=none; b=e0PksSSKYlmQ/ZNQv35A0/GJMGYXvLnQT6OO5xBEOhDetyl+wO45RntRuwufq3AUH2AaKg3oFLyClAC/eSF9KYZv2wG9094jRuFWyx0qoabAPeEX68vKPGhqy/n3RSsKIvS66CcuCRVbEQztXomDgHHUimaJAPRlTKLGwRsv9KE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769641560; c=relaxed/simple;
	bh=tJG7v64X0vPkFBtPJK2gylaT/jHpd5ISMyk3nFOi81Y=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TV6r2mTCHRN9kEe93SgzoyqPMVo+NLPSKq/ZQIxlAKHJjnisMRyc3RQdZliKCHmy7cJ/s35Zf+Pwdl7oAjx1AZ5jiYuwJte7cLuT3PNYU8q29JPRtgsL8JCf05rE8Xfd6Pd9k7GUNkpqpX5Xl9VUa05reXeUJ5kSMUDyOzdLSyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F10A513BB98;
	Wed, 28 Jan 2026 23:05:56 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf12.hostedemail.com (Postfix) with ESMTPA id 4ED0B19;
	Wed, 28 Jan 2026 23:05:53 +0000 (UTC)
Date: Wed, 28 Jan 2026 18:06:02 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
 linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev,
 joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
 kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 jstultz@google.com, qperret@google.com, will@kernel.org,
 aneesh.kumar@kernel.org, kernel-team@android.com,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 09/30] tracing: Add events to trace remotes
Message-ID: <20260128180602.4dd645de@gandalf.local.home>
In-Reply-To: <20260126104419.1649811-10-vdonnefort@google.com>
References: <20260126104419.1649811-1-vdonnefort@google.com>
	<20260126104419.1649811-10-vdonnefort@google.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 64uyghqa9n4atbg59i1p3muxdue48cc5
X-Rspamd-Server: rspamout04
X-Rspamd-Queue-Id: 4ED0B19
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX19WPhVJLy5TbGzL4199/ZqemVIHZwaAhhU=
X-HE-Tag: 1769641553-721359
X-HE-Meta: U2FsdGVkX19+jYoLOZs18rm280yAUhdSvQpIWK8tx9XPXYfDnCbgjYvHUvTP1JOaQEwG+lUeMVrqhU1k8e+7f2vJHr2xfVMbkalmiOLwMdJeEVI62F0bK9OL75fnGczpTGHCOjb552m4Covu6F5daWhu20zNfqlw8TM2gXb74nE2STgMXt6Y4wcm/5FDtNwWdt6gFB25VMOir9UoxvOdsL3esEhmSq98Br+MT6So48OCLdldlBfPH8A/+MyeDB5Sqd4W3xvcc3Hel2un9hv+HuE2en1Vgp3pLzWoZmIbPPs2UpBxwM2oY5VqfzECwKzTzHnZE2LmmhxzJ6fz3AGLM+nM5xpRhUjM

On Mon, 26 Jan 2026 10:43:58 +0000
Vincent Donnefort <vdonnefort@google.com> wrote:

> +
> +static int __cmp_events(const void *id, const void *evt)
> +{
> +	return (long)id - ((struct remote_event *)evt)->id;

Hmm, just to be safe, we should probably make everything int here, to not
have any overflow issues:

static int __cmp_events(const void *key, const void *data)
{
	const struct remote_event *evt = data;
	int id = (int)((long)key);

	return id - (int)evt->id;
}

-- Steve

> +}
> +
> +static struct remote_event *trace_remote_find_event(struct trace_remote *remote, unsigned short id)
> +{
> +	return bsearch((const void *)(unsigned long)id, remote->events, remote->nr_events,
> +		       sizeof(*remote->events), __cmp_events);
> +}

