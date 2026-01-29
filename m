Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B8FB1E1A3B
	for <kvmarm@lists.linux.dev>; Thu, 29 Jan 2026 00:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769646499; cv=none; b=OPlHC7cmytvDvDb3kFgkyhvIDBUqovRNt5EzBqzhvksz3AI4sB8VlLBWHYUI363k8w3lZnIsyPHTbeLj/6OSmRCFtkXbP+VMf/anuvsYDz3H9MRe7rlVSbNzu99YRMovZ8h1w5BEuqGAb0ek7p9cf+NduSrG96EjtyWZGH1SP24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769646499; c=relaxed/simple;
	bh=yNLkgH7kYrxlutGfc3chv7xTJxUg2tdL0c6wqfUBDtc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uZdsgwBmrnFI4AjXq9B7aHYBzsgNloUdicz6WhkWs/pdTio0mISnRUu011OUn0ie+ZELY6bvWYjIZinwdjgAeHx6S1nB9JI7RGG6Bm4FKc31Esd9vzg8fJLOMmLd6WtNhAmJ5OLIWiffhL1pLtYfrNiaOINbZ8AxH3i6mZ6tQNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DAB9C57021;
	Thu, 29 Jan 2026 00:28:15 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf08.hostedemail.com (Postfix) with ESMTPA id 8717320026;
	Thu, 29 Jan 2026 00:28:12 +0000 (UTC)
Date: Wed, 28 Jan 2026 19:28:22 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
 linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev,
 joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
 kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 jstultz@google.com, qperret@google.com, will@kernel.org,
 aneesh.kumar@kernel.org, kernel-team@android.com,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 11/30] tracing: Add helpers to create trace remote
 events
Message-ID: <20260128192822.6e9bb5fe@gandalf.local.home>
In-Reply-To: <20260126104419.1649811-12-vdonnefort@google.com>
References: <20260126104419.1649811-1-vdonnefort@google.com>
	<20260126104419.1649811-12-vdonnefort@google.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ptrpd6mybqqwprs4z7h1jq6r9idfoohp
X-Rspamd-Server: rspamout04
X-Rspamd-Queue-Id: 8717320026
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX18JGCoAQO5cD/cqcdAx5HTvwj2jM7MCu1Q=
X-HE-Tag: 1769646492-422144
X-HE-Meta: U2FsdGVkX19QOntaKOMDn4PQ1YaFQpLuUFoYTfEH1vRLLdd0Xcuma8LYWD9u6V87SO8G18Q8WhlTlkj+HhLCrKHrJOo0ow8t67KaTT//DaXkroLk1knqXAt+puYamKH7QFh3ip605O/N31oA5G/gO/GPqZE0lhoksjarXMlAV91kihpW6ymKpFxixkRKr13PEsdkt2HEyRTNk//7zzPebGhTsYTKBrtcLX8geuZssDoh7NwlHh4/Ts32/MSAcO08JGNNAusqsUAIzBdsQIiMQC/fBop35eSNEP4G4vzlQQCwUpPsLAQSwAz3LEBRknlJtdTlUxLjZCvBszdkG/Z3O0cYxEUM5duoFhPRiq2M58Ar1KwqR1tOHnWBT5hB9QCupBDtZrcxXTkRPY/l19s8/g==

On Mon, 26 Jan 2026 10:44:00 +0000
Vincent Donnefort <vdonnefort@google.com> wrote:

> Declaring remote events can be cumbersome let's add a set of macros to
> simplify developers life. The declaration of a remote event is very
> similar to kernel's events:
> 
>  REMOTE_EVENT(name, id,
>      RE_STRUCT(
>         re_field(u64 foo)
>      ),
>      RE_PRINTK("foo=%llu", __entry->foo)
>  )
> 
> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>

-- Steve
