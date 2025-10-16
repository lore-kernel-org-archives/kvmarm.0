Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 238EA3BB5A
	for <kvmarm@lists.linux.dev>; Thu, 16 Oct 2025 21:06:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760648808; cv=none; b=YiwpKKyzQ6PW4510QYQu9DX0EFXN3eJKmaWfqfDWkEISOS3cmvxNnCqgtzuUNCBmJeNY8VNvvEIquf3zKIp56sVoG19t3T+2hLc0mlgupkeOwmBZQ/OPieebBqudtW1PghZEzqE9je17Kr7ZLNr0/Id1FOoqRIJk9iDAVj4r+GI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760648808; c=relaxed/simple;
	bh=BnfytX7/MC8y0/2nXGPHBcklNEM32JnN816IW60bNmk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=P3VLecD8++NWVt5WwBTBPNSXDGN23DxDH/Urm2VRwoL5cimVJ6EAUFN3s/bpjzo9HoFbt4evOWavvnhMlr8Wa8vf7tD+iMpqNFdvo08FHRt7q8WBAW9KTtWTJCpZFveNejz76e08C7JKToIMiNeyzVhhZsEIlD95CBh2Nbomdls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1ED2AC03EC;
	Thu, 16 Oct 2025 21:06:38 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf18.hostedemail.com (Postfix) with ESMTPA id DC7AE2E;
	Thu, 16 Oct 2025 21:06:34 +0000 (UTC)
Date: Thu, 16 Oct 2025 17:06:45 -0400
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
Message-ID: <20251016170645.15416c8a@gandalf.local.home>
In-Reply-To: <20251003133825.2068970-15-vdonnefort@google.com>
References: <20251003133825.2068970-1-vdonnefort@google.com>
	<20251003133825.2068970-15-vdonnefort@google.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 171ecfdbssy8jndycq7xaujpdryuex7e
X-Rspamd-Server: rspamout08
X-Rspamd-Queue-Id: DC7AE2E
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1/ZbvkePVWCGmToWBQLaaIP5VqhZo9jobY=
X-HE-Tag: 1760648794-186997
X-HE-Meta: U2FsdGVkX1+eCdST38Wg1ReLdZGNRZsCZYYH7m4AKdZaxOPM6jlfN1mdmRXhxBU1VJTVpWkj9A2ZkC4XzBBqjVn2xgmz9jqaGNfP/MVEaUcUqFsyArxWf4Zon8ocjQUcrHXPHlaG7hRC2p/C500ofrn+Ska0QyZ1UL4BX84tY07aCUosGlwrK264F71UDkljgxVSZX9es3SQ3l2o9PpqN7ZQqbnlO8s05NLTLmvKriB16vplXurmGcrmMTaGIuXvXW7RNibnhslg9/L0o3wPh9Ho9tO0wAGA1JZIVH1XyW203hsY+7imQdJ/Qe/twW+S9pm40Ff2eePzyLCyWSDJ4DFaOGuoIsLG

On Fri,  3 Oct 2025 14:38:11 +0100
Vincent Donnefort <vdonnefort@google.com> wrote:

> diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
> index 918afcc1fcaf..52131d89993c 100644
> --- a/kernel/trace/Kconfig
> +++ b/kernel/trace/Kconfig
> @@ -1244,4 +1244,12 @@ config TRACE_REMOTE
>  config SIMPLE_RING_BUFFER
>  	bool
>  
> +config TRACE_REMOTE_TEST
> +	tristate "Test module for remote tracing"
> +	select TRACE_REMOTE
> +	select SIMPLE_RING_BUFFER
> +	help
> +	  This trace remote includes a ring-buffer writer implementation using
> +	  "simple_ring_buffer". This is solely intending for testing.
> +

Nit, this should go up a few places so that it's with the other "test module" selections.

-- Steve
