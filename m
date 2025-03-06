Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68A0DDDA8;
	Thu,  6 Mar 2025 19:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741290970; cv=none; b=Ilk5X7ZxF4QjYDTd8ZtOTzAhhhIcDu/O0vP5lmOY9w6wrO1SR4oCDgn+Dtg3rq+eqYTfM9Vz/cA/8+bSgguw4hKFQUYfn7ksPni4G1TFAiXqycI/T/6yyLUKTXa4ni2f6szjg+yHH5HghYBIV7U0GK6pBEHCdckxJzHICOi97PQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741290970; c=relaxed/simple;
	bh=ntOd0i1f+iMTNXJzbMPoo+sx55hSYGepTgVwnp2V9l4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NTOyhYiYYivP0eJjPGkaRi4DoMBb2hXjIfybcMee/+0GVAJZMKly7W5zCHsbmbfTIfJEF5Zniu02w5adz9ekpk3XIeyCji+D0BsBgxQAQd//kJYmDpkd+/FS2jqgoWnDOj6ana++4hT9rHeZykWu9g/hME3yPdZTfgRNvgZCyk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39C81C4CEE0;
	Thu,  6 Mar 2025 19:56:07 +0000 (UTC)
Date: Thu, 6 Mar 2025 14:56:07 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
 linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev,
 joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
 kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 jstultz@google.com, qperret@google.com, will@kernel.org,
 kernel-team@android.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/11] ring-buffer: Expose buffer_data_page material
Message-ID: <20250306145607.0aa91e22@gandalf.local.home>
In-Reply-To: <20250224121353.98697-3-vdonnefort@google.com>
References: <20250224121353.98697-1-vdonnefort@google.com>
	<20250224121353.98697-3-vdonnefort@google.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 24 Feb 2025 12:13:44 +0000
Vincent Donnefort <vdonnefort@google.com> wrote:

> @@ -61,11 +65,50 @@ enum ring_buffer_type {
>  	RINGBUF_TYPE_TIME_STAMP,
>  };
>  
> +#define TS_SHIFT        27
> +#define TS_MASK         ((1ULL << TS_SHIFT) - 1)
> +#define TS_DELTA_TEST   (~TS_MASK)

By moving this to include/linux you need to add a prefix to prevent name
space conflicts.

 RB_TS_SHIFT
 RB_TS_MASK
 RB_TS_DELTA_TEST

-- Steve


> +
> +/*
> + * We need to fit the time_stamp delta into 27 bits.
> + */
> +static inline bool test_time_stamp(u64 delta)
> +{
> +	return !!(delta & TS_DELTA_TEST);
> +}
> +
