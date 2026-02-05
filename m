Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5DA429CEB
	for <kvmarm@lists.linux.dev>; Thu,  5 Feb 2026 01:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770255149; cv=none; b=TTnNyqVAh3XZH85Y9miyZRyv16yrWWCQdLCixKZygJ8qxNWshhkCe9mYerNh6686Fmw9a2won+3QIfEOnoIZL3geeEP0Hi2hFFIYNE11yOfiwTg2dI6Ck+SBCW1/58SBcwIMe8G9rd79CaIYfqQaWAnbmyj7fD3aXpAAIfV7cHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770255149; c=relaxed/simple;
	bh=9PDrIRIWiz2T0CqIrSipKt8ZM5+nE+o4bRGKdunwa5I=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QCDRQbQ4sF6pZgoNjTInIIMspXCZddCWl2fWpmBXy5XnvrMSeYulCj12CbcX0niVPDdygnOeeZYjwJshjJmgNcQZuBGSQksaGJxbeUA7Av2+sxf1qY3c1GjvukvbISK2zhpcZYEZ7l2AB4Pz4cWiriasrLHQnxswSdrq1nc/Imo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A6FC51B1C2D;
	Thu,  5 Feb 2026 01:32:27 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf13.hostedemail.com (Postfix) with ESMTPA id 3672620010;
	Thu,  5 Feb 2026 01:32:24 +0000 (UTC)
Date: Wed, 4 Feb 2026 20:32:22 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
 linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev,
 joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
 kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 jstultz@google.com, qperret@google.com, will@kernel.org,
 aneesh.kumar@kernel.org, kernel-team@android.com,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v11 14/30] tracing: Add a trace remote module for
 testing
Message-ID: <20260204203222.01064aa9@robin>
In-Reply-To: <20260131132848.254084-15-vdonnefort@google.com>
References: <20260131132848.254084-1-vdonnefort@google.com>
	<20260131132848.254084-15-vdonnefort@google.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspamout06
X-Rspamd-Queue-Id: 3672620010
X-Stat-Signature: kb9wzt1mfyn1fwopt3wk9ur4oubdog66
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX18OzKxI10ZLVtVcjd6iNhrr6VhjUOVLmYA=
X-HE-Tag: 1770255144-305708
X-HE-Meta: U2FsdGVkX1+EDR/c3dKgo0s3NgB59SoOMZgZmHJXInP+X82Ema1haQMEbnZ1mZfmooGScFWBRRzLMqkEMug8zZpYgJ6zdE2JpsBkgFnHvuu9Xz6KRv8ywJ86TSZXJ5FRXbDk8FZAEtXQgOO4AT52EFt9hQnFyjiuTgPTzzbEQlp0dJLFcly/ENn1XqlJ3Cs8w9IsPrcm9oLoMvf2YyriStfSQCgLsDauptpH4Mtc5+qBa5Mh5wfzAWRRbmKAeKyPu3e08aJKWmWtC74LLbtOw3rAq7Yb7cn3ZY0pTzxrBJoVHMCqNDMqq0apRsphMXXQqFaDblCQEawZlyLlHKGr2p05aCT5vNHQXwmQE0WthYsMLSbVC+iGtG8N6VNYHxS93zEh/M83ZTZAi0Gru/ouNg==

On Sat, 31 Jan 2026 13:28:32 +0000
Vincent Donnefort <vdonnefort@google.com> wrote:

> Add a module to help testing the tracefs support for trace remotes. This
> module:
> 
>   * Use simple_ring_buffer to write into a ring-buffer.
>   * Declare a single "selftest" event that can be triggered from
>     user-space.
>   * Register a "test" trace remote.
> 
> This is intended to be used by trace remote selftests.
> 
> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>

-- Steve
