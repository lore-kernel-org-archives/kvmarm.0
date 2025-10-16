Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F6F42DFA48
	for <kvmarm@lists.linux.dev>; Thu, 16 Oct 2025 21:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760649112; cv=none; b=QJcnqdHwQNlLnxTrkr5epKhkLOzrdTxM98B1vvw1m8bbwNhfH/ISN4V6SaPvQy5e5HS6CZEnb2qvX3G30pnuemC2yYISqZczZrlZmOFomJ6d6NyQc2BbE73WiW0ucfb9YnlVUi9lXxEpGsmDafS4TRrO7cF1Wv0KN/oZUPcVkhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760649112; c=relaxed/simple;
	bh=QGBW6ECPqYyJYBquRloNyqFNd7l7dsduVLBDuiecXE0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ND+sdBX3gIuH9bkG9eH2CxPASvuHR6MKD5cflZ4LBZWGBFhUsekdrO8+rLnMlLUl5KqmWBLSXvEJvHYgFSsN1SiMCsm3Utn+OhHJvZ9k8QVUU6F1GWwlftcB4loAG47J+90Az6eOjaiEF1q9gLvmwqU2bAmv8OJjF/Fs4FKgd8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 09BCB1A0421;
	Thu, 16 Oct 2025 21:11:47 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf14.hostedemail.com (Postfix) with ESMTPA id 9489E34;
	Thu, 16 Oct 2025 21:11:44 +0000 (UTC)
Date: Thu, 16 Oct 2025 17:11:55 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
 linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev,
 joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
 kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 jstultz@google.com, qperret@google.com, will@kernel.org,
 aneesh.kumar@kernel.org, kernel-team@android.com,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 14/28] tracing: Add a trace remote module for testing
Message-ID: <20251016171155.0d871fc3@gandalf.local.home>
In-Reply-To: <20251016170645.15416c8a@gandalf.local.home>
References: <20251003133825.2068970-1-vdonnefort@google.com>
	<20251003133825.2068970-15-vdonnefort@google.com>
	<20251016170645.15416c8a@gandalf.local.home>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 33hbw6rr73jtdzwf8bckjrt5why11rej
X-Rspamd-Server: rspamout01
X-Rspamd-Queue-Id: 9489E34
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1+mzqTR6rqbkd1NzU33NlFjpBTX4YYBDpY=
X-HE-Tag: 1760649104-568230
X-HE-Meta: U2FsdGVkX18UOnRfo5/M586ViFyUv6tsn+gOTfw2M0Y9noR3McpUrJwpsabHTvpL2/5wzsDCaUL/d12GzAjhNNf2t3Mhh8WD1Kmh+O8qlcvBgcXVf/dnXrigVY66PAvWoi1nhL66TQ68n9IiyyDAd1Yy7C8R2HGrPEXZuNIGll4R/6JVAlCDDccqVf1UpNW9JDuwtJniNcqNR3SLoNhCyIPEGrDKQrN3u9E0qhCgI5ih58GR5+Hc4f3tG6AszSfxvRCkVDTjfUprjZDI6HBrwKxPjK/jMfpJxezYVYWqtgRGBWg4teEiBTVO+M+ApM8vuZHp8FfUOBjYmshmFZTZO3HF5KgmtxNNnnyv6IZZXWwe2EQmzloM3nL1370pPrbXF0lrENiGYgHtfF+Z96qFqQ==

On Thu, 16 Oct 2025 17:06:45 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Fri,  3 Oct 2025 14:38:11 +0100
> Vincent Donnefort <vdonnefort@google.com> wrote:
> 
> > diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
> > index 918afcc1fcaf..52131d89993c 100644
> > --- a/kernel/trace/Kconfig
> > +++ b/kernel/trace/Kconfig
> > @@ -1244,4 +1244,12 @@ config TRACE_REMOTE
> >  config SIMPLE_RING_BUFFER
> >  	bool
> >  
> > +config TRACE_REMOTE_TEST
> > +	tristate "Test module for remote tracing"
> > +	select TRACE_REMOTE
> > +	select SIMPLE_RING_BUFFER
> > +	help
> > +	  This trace remote includes a ring-buffer writer implementation using
> > +	  "simple_ring_buffer". This is solely intending for testing.
> > +  
> 
> Nit, this should go up a few places so that it's with the other "test module" selections.

And when I tried to build it, I hit this:

  GEN     .vmlinux.objs
  MODPOST Module.symvers
ERROR: modpost: "simple_ring_buffer_reserve" [kernel/trace/remote_test.ko] undefined!
ERROR: modpost: "simple_ring_buffer_commit" [kernel/trace/remote_test.ko] undefined!
ERROR: modpost: "simple_ring_buffer_unload" [kernel/trace/remote_test.ko] undefined!
ERROR: modpost: "trace_remote_free_buffer" [kernel/trace/remote_test.ko] undefined!
ERROR: modpost: "trace_remote_alloc_buffer" [kernel/trace/remote_test.ko] undefined!
ERROR: modpost: "simple_ring_buffer_init" [kernel/trace/remote_test.ko] undefined!
ERROR: modpost: "trace_remote_register" [kernel/trace/remote_test.ko] undefined!
ERROR: modpost: "simple_ring_buffer_reset" [kernel/trace/remote_test.ko] undefined!
ERROR: modpost: "simple_ring_buffer_swap_reader_page" [kernel/trace/remote_test.ko] undefined!
ERROR: modpost: "simple_ring_buffer_enable_tracing" [kernel/trace/remote_test.ko] undefined!
WARNING: modpost: suppressed 1 unresolved symbol warnings because there were too many)
make[3]: *** [/work/git/linux-trace.git/scripts/Makefile.modpost:147: Module.symvers] Error 1
make[2]: *** [/work/git/linux-trace.git/Makefile:1960: modpost] Error 2
make[1]: *** [/work/git/linux-trace.git/Makefile:248: __sub-make] Error 2
make[1]: Leaving directory '/work/build/nobackup/debiantesting-x86-64'
make: *** [Makefile:248: __sub-make] Error 2


-- Steve
