Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B1EC1A681B
	for <kvmarm@lists.linux.dev>; Thu, 12 Mar 2026 13:33:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773322382; cv=none; b=ZaNhmgwzja5/L6cNb0z6bdQuXuCT38cFcWtVzYArZhMZneuwJWV9d1kBxEkxfFkSdnjVtySWHanT8DIxFPJXmHL7rKzZ2wszasVR0RlguX/J1vaGUwbMyXQ+Iem21hxyLtJWVbvVbXo0mkm+UYIkXdzmxCzUSQywheTvEmbi12o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773322382; c=relaxed/simple;
	bh=Ejtdt2WhvS5pkZs+nVXs4lOvpVx8pa1hU96FEUE6FmU=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oZu2+TYdpoLqPIv9wK5+wHc55k8WIdA7fPW4ac35UmDcDMT50TfSC9UJUrIsmPqoKERWMC1lLFKN33aFQWDllEeyW0G4sy/uMjX70Eeslj8m1lH9uLjU1P6mGJkcyWKztqnIb0zlbDTePb7TxosDIwFH1cFs0caRVF6QfsWvB5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2AF601B71F7;
	Thu, 12 Mar 2026 13:32:59 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf17.hostedemail.com (Postfix) with ESMTPA id 61A041D;
	Thu, 12 Mar 2026 13:32:57 +0000 (UTC)
Date: Thu, 12 Mar 2026 09:33:11 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, linux-trace-kernel@vger.kernel.org,
 kvmarm@lists.linux.dev, kernel-team@android.com, Nathan Chancellor
 <nathan@kernel.org>
Subject: Re: [PATCH] tracing: Update undefined symbols allow list for
 simple_ring_buffer
Message-ID: <20260312093311.1788707d@gandalf.local.home>
In-Reply-To: <20260312113535.2213350-1-vdonnefort@google.com>
References: <20260312113535.2213350-1-vdonnefort@google.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: zg1uw5onefppz7eyfx8fm9s13edw6yeg
X-Rspamd-Server: rspamout02
X-Rspamd-Queue-Id: 61A041D
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX19chteRd5MMFXqJDmA8FERQdiN4XJ53LyI=
X-HE-Tag: 1773322377-179899
X-HE-Meta: U2FsdGVkX19i0DgKVzidNy09ZryUdGHug36GI9x8zIcRI3Rv7cFKtCKb5leS5p8CKq6I9WS6uwK26Snnf0BjYmvYXbfWjH7S2RSR3Gh8m2mpoyCdDnEPT0EKchfcSF1DzelGFM0yLU4dqhvuRwYJ9C9wTVqhiUWZ0zslyzxvVSUIACSM8lUTnkU3g5HcJ/SscZ1cNbbSXKYKtRA7DCeTBzpwVHHvHjQCNZ/I5SxLxtz0xjZ3GquNNOqtquCKRR4Ueh1fvYmsjw4XR8xOM3aMtPXnksEwpmJjOu0ZQQZoVGwFfXaA3XHfJdwYSWH4++r1qTskg0yHmN95AgdA7Er/wRxfgmDlh/DjFMFOZWrDUvTGv6mK/f01zVzUEZyuN+6i24EFmkXOPpK3KyeKX5seDkMIpnL217WvjvvCWXLI+9Y=

On Thu, 12 Mar 2026 11:35:35 +0000
Vincent Donnefort <vdonnefort@google.com> wrote:

> Undefined symbols are not allowed for simple_ring_buffer.c. But some
> compiler emitted symbols are missing in the allowlist. Update it.
> 

Should add:

Fixes: a717943d8ecc ("tracing: Check for undefined symbols in simple_ring_buffer")
Closes: https://lore.kernel.org/all/20260311221816.GA316631@ax162/

> Reported-by: Nathan Chancellor <nathan@kernel.org>
> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

Should this go through the arm tree or mine?

I'm fine with either, and in case the arm tree:

Acked-by: Steven Rostedt (Google) <rostedt@goodmis.org>

-- Steve


> 
> diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
> index 3182e1bc1cf7..3cc490aadc99 100644
> --- a/kernel/trace/Makefile
> +++ b/kernel/trace/Makefile
> @@ -137,7 +137,8 @@ obj-$(CONFIG_TRACE_REMOTE_TEST) += remote_test.o
>  # to all kernel symbols. Fail the build if forbidden symbols are found.
>  #
>  UNDEFINED_ALLOWLIST := memset alt_cb_patch_nops __x86 __ubsan __asan __kasan __gcov __aeabi_unwind
> -UNDEFINED_ALLOWLIST += __stack_chk_fail stackleak_track_stack __ref_stack __sanitizer
> +UNDEFINED_ALLOWLIST += __stack_chk_fail stackleak_track_stack __ref_stack __sanitizer llvm_gcda llvm_gcov
> +UNDEFINED_ALLOWLIST += .TOC\. __clear_pages_unrolled __memmove copy_page warn_slowpath_fmt
>  UNDEFINED_ALLOWLIST := $(addprefix -e , $(UNDEFINED_ALLOWLIST))
>  
>  quiet_cmd_check_undefined = NM      $<
> 
> base-commit: 455baa581922086f1ad44c76d4a3b03c265ee950

