Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F6183054F0
	for <kvmarm@lists.linux.dev>; Mon,  8 Sep 2025 23:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757374644; cv=none; b=Jw/ci9kCaZrVwNzsLOAKcgp8YkU4BluZPqjCC7sNnUeTyPd0krlSaQTvZ4p2xjSdNiv0KPGxHJprL888jI0LTIkO8HnjZkN4PafY3xcVMMYTK9ooSLYF2soaJOIRCCsXHTBo9ajlMrt1o3Q5oK+P1r4YPEPp8LMBzb7+i0Tp0Ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757374644; c=relaxed/simple;
	bh=b/7INvGlACZqgSm8XhR6n/N4TB0Cl26/+RGOEBMuczE=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=d8KxeukWnunTs0W4CjXsBwS2/duM8ZbTrE2RLUrrrltu4neYOf0AxDWpYlQ8m0o/iIQYclmQMxU/7GEsBaoHkXVcX7j0/FJvdvrHJksXXj52Gp63fzlBBIbtieJGBzdJdhv5aTLzfMo3vSCrJrUhljUfx21hcVFrzweLOMsSqTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7F90A1DDB91;
	Mon,  8 Sep 2025 23:37:14 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf07.hostedemail.com (Postfix) with ESMTPA id F243A20024;
	Mon,  8 Sep 2025 23:37:10 +0000 (UTC)
Date: Mon, 8 Sep 2025 19:37:57 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
 linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev,
 joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
 kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 jstultz@google.com, qperret@google.com, will@kernel.org,
 aneesh.kumar@kernel.org, kernel-team@android.com,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 04/24] tracing: Add reset to trace remotes
Message-ID: <20250908193757.079aae76@gandalf.local.home>
In-Reply-To: <20250821081412.1008261-5-vdonnefort@google.com>
References: <20250821081412.1008261-1-vdonnefort@google.com>
	<20250821081412.1008261-5-vdonnefort@google.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: wdbcg9cmz9hgzbiksnz8z5e99z9oj6b5
X-Rspamd-Server: rspamout07
X-Rspamd-Queue-Id: F243A20024
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX18XbN7DKfTHTi5CaU0ETRtueyTq0Kn+udA=
X-HE-Tag: 1757374630-126015
X-HE-Meta: U2FsdGVkX1+EtvhnbdP2Gtp4noi9cwQOFuTgiBxTimh80Zt9R2I9RRFZOl6Ad9iETIg8Vo1wn0H3utT0IieAsllW9nATADRweoco0USuPbF/DP4mzyWeE7aIzDtTjPTMCyknsX9vb+/wfUw4RcDhTt6//E9Z3hqrulPr2olWCfWURJbu73yPFEi3lUwCRSODrbQJTtcFs9kbOy6wjiU0k5sLzN78GCaIrqX6j0uq3wxNHph6lidTpEKShX9mn39tAzBAhFD2JHB0HJDOgo8fyH/TPKH5N4qstseJVEKZysaLeFeVQlz4byE2opEgIDC69C7Sll18FkwB6E6vUWqaMXNqzjYegYIr

On Thu, 21 Aug 2025 09:13:52 +0100
Vincent Donnefort <vdonnefort@google.com> wrote:

> @@ -400,7 +436,9 @@ static int trace_remote_init_tracefs(const char *name, struct trace_remote *remo
>  	    !trace_create_file("buffer_size_kb", TRACEFS_MODE_WRITE, remote_d, remote,
>  			       &buffer_size_kb_fops) ||
>  	    !trace_create_file("trace_pipe", TRACEFS_MODE_READ, remote_d, remote,
> -			       &trace_pipe_fops))
> +			       &trace_pipe_fops) ||
> +	    !trace_create_file("trace", 0200, remote_d, remote,
> +			       &trace_fops))
>  		goto err;
>  
>  	percpu_d = tracefs_create_dir("per_cpu", remote_d);
> @@ -422,7 +460,9 @@ static int trace_remote_init_tracefs(const char *name, struct trace_remote *remo
>  		}
>  
>  		if (!trace_create_cpu_file("trace_pipe", TRACEFS_MODE_READ, cpu_d, remote, cpu,
> -					   &trace_pipe_fops))
> +					   &trace_pipe_fops) ||
> +		    !trace_create_cpu_file("trace", 0200, cpu_d, remote, cpu,
> +					   &trace_fops))
>  			goto err;
>  	}

I wonder if we should name the file "reset" to not be confusing to users
when they cat the file and it doesn't produce any output.

-- Steve
