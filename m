Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A35D83502B4
	for <kvmarm@lists.linux.dev>; Thu, 29 Jan 2026 17:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769708008; cv=none; b=DucPjfMpNzLC+1UL+8XDa0dNw3AvYHH+09S0QQHbSJby03MpfRbxEqNNLSagyBWhhxWzCw5jUAaIsHQk1w1ppSAJzWGYMlfyA4hFsEvGXjXwwiamTFsCTwOQG+p/rpBmP9eP85S2CYfQm1h+i8XbZCZcs6goh0fa6PpEwIvjfM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769708008; c=relaxed/simple;
	bh=auwU+QBgHhgH17KufQIhJdeBeH5zMEuEcX0YOFiVem4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VacmiWKjWKC6CDpdVIrbQB2np5KZbDDqRJoi7a92tqrfFphkL8x5zQgmZu69o/LgXLM/vZr5QqTqogktK8wNu44d5H1H9WcFKOeNCmU5TuW+vYQ1ak3Zrpo1dOS6VWOblfINu/C47RdokGoJhY1hwzDO3Wfn0+Jl6c6lX/SYm2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 59957C1143;
	Thu, 29 Jan 2026 17:33:24 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf01.hostedemail.com (Postfix) with ESMTPA id F05996000F;
	Thu, 29 Jan 2026 17:33:20 +0000 (UTC)
Date: Thu, 29 Jan 2026 12:33:33 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
 linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev,
 joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
 kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 jstultz@google.com, qperret@google.com, will@kernel.org,
 aneesh.kumar@kernel.org, kernel-team@android.com,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 18/30] tracing: Check for undefined symbols in
 simple_ring_buffer
Message-ID: <20260129123333.0fd202f7@gandalf.local.home>
In-Reply-To: <20260126104419.1649811-19-vdonnefort@google.com>
References: <20260126104419.1649811-1-vdonnefort@google.com>
	<20260126104419.1649811-19-vdonnefort@google.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: F05996000F
X-Stat-Signature: o9j95uhm9j8efrdgmk8y4j5fexwz3idk
X-Rspamd-Server: rspamout08
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX195dtwkrQT53/vFwD6QG82Q6vcucrU+d38=
X-HE-Tag: 1769708000-307468
X-HE-Meta: U2FsdGVkX19dFv0bDGXtajpi9gIAkPXXQ9oDOgmRZBRmxlm8Acxyn18GR3Tmtn0vFh7pabfVByLquAgT+uc4JK6bX73G6GCsvAfGS/gwxwBPOQwg6efHDhZIshRrRudtF8Xkv2LniQiLQTNbanq+fHp3VZd8QtR6DSmd5EmzSb8wqlmsgTyiAcKYhgYLZNDAnf4o0rTenTpSqSV7S5hpSr61etGLq4AFNJD4ZoZUiV7t6YI9WKzH8HoC1PkBaEGlsGQM3Af/ScefsG0V+PKoACC8OlNF28zt5PU+WI+eYBfmHl04QVXgXv0CwYzQUXBXNcLm1kx15d7gLGdHZ7Fqf+DFp1BnPS4UCFrag7mOKL33yhs3WV8KE65DQ2o+fHjeIgRKEs2YaSNcsWEqhPkJdQ==

On Mon, 26 Jan 2026 10:44:07 +0000
Vincent Donnefort <vdonnefort@google.com> wrote:

> The simple_ring_buffer implementation must remain simple enough to be
> used by the pKVM hypervisor. Prevent the object build if unresolved
> symbols are found.
> 
> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>

-- Steve

> 
> diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
> index 9e86c43bf320..9f675d5d27c7 100644
> --- a/kernel/trace/Makefile
> +++ b/kernel/trace/Makefile
> @@ -131,4 +131,20 @@ obj-$(CONFIG_TRACE_REMOTE) += trace_remote.o
>  obj-$(CONFIG_SIMPLE_RING_BUFFER) += simple_ring_buffer.o
>  obj-$(CONFIG_TRACE_REMOTE_TEST) += remote_test.o
>  
> +#
> +# simple_ring_buffer is used by the pKVM hypervisor which does not have access
> +# to all kernel symbols. Fail the build if forbidden symbols are found.
> +#
> +UNDEFINED_ALLOWLIST := memset alt_cb_patch_nops __x86 __ubsan __asan __kasan __gcov __aeabi_unwind
> +UNDEFINED_ALLOWLIST += __stack_chk_fail stackleak_track_stack __ref_stack __sanitizer
> +UNDEFINED_ALLOWLIST := $(addprefix -e , $(UNDEFINED_ALLOWLIST))
> +
> +quiet_cmd_check_undefined = NM      $<
> +      cmd_check_undefined = test -z "`$(NM) -u $< | grep -v $(UNDEFINED_ALLOWLIST)`"
> +
> +$(obj)/%.o.checked: $(obj)/%.o FORCE
> +	$(call if_changed,check_undefined)
> +
> +always-$(CONFIG_SIMPLE_RING_BUFFER) += simple_ring_buffer.o.checked
> +
>  libftrace-y := ftrace.o

