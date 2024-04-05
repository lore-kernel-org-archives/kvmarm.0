Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 227BA16C85B
	for <kvmarm@lists.linux.dev>; Fri,  5 Apr 2024 14:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712327846; cv=none; b=HoDXBhVkdSxqp221pXkKoBmLlWu/z/bjCvqFXCczZtmM67N+9Ezj09G8/A7G0gf41Zy3y/CU1CBDdcbgSCtoGPd7aIBiEzQBGjIJIxdqirDi8L9zNdLpDOyXVpuNoEx6Z9KEYCnG2TviuRMdTVGjOINuhsIfrZ60fZ1gIpY9dp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712327846; c=relaxed/simple;
	bh=/wcWZfFTiGu0tCXlgx2oIrJgnfV8soEbXGw3qrBZZDQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hOLQeNM/iZ6Ft+YGTvc7ZO7GGachrB/GHO4WbSuca5K2SD4kGL4FCgRcwr/dgdbIH2/b3Vswdx2KglsP/sBr4wkPshGtB7Xpt2sdFr8IxaC/ka5+BitUH27AbBLb2LU5g5nMXaCk05UBv8R1o2S99CoN9jxQ1+XE4FGvfAvMTj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=m2BhjFEn; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="m2BhjFEn"
Date: Fri, 5 Apr 2024 16:37:19 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1712327843;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+l9DctPtgtgSbeq5u1EB7dvhVT4XihzBexxkuU1IA1I=;
	b=m2BhjFEnJDmwOMix6wW+LuD82KtyIXSY3tTmCsVZj0C+E6iqB2MMh/rPrzsJxgIXKKqAUE
	dMbCPhBG7mg7zFq0iKR3MW9pWAc8QMxRLy4toWhiQy64JZaLozGPFl6VBvy0thdno7bSYr
	zf3e+iUbFMdfrpfKlU6Y56DNCqIXtPw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Nicholas Piggin <npiggin@gmail.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Huth <thuth@redhat.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Eric Auger <eric.auger@redhat.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Nico =?utf-8?B?QsO2aHI=?= <nrb@linux.ibm.com>, David Hildenbrand <david@redhat.com>, 
	Shaoqin Huang <shahuang@redhat.com>, Nikos Nikoleris <nikos.nikoleris@arm.com>, 
	Nadav Amit <namit@vmware.com>, David Woodhouse <dwmw@amazon.co.uk>, 
	Ricardo Koller <ricarkol@google.com>, rminmin <renmm6@chinaunicom.cn>, Gavin Shan <gshan@redhat.com>, 
	Nina Schoetterl-Glausch <nsg@linux.ibm.com>, Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org, linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests RFC PATCH 12/17] shellcheck: Fix SC2124
Message-ID: <20240405-a4a05544ec40a07744144d61@orel>
References: <20240405090052.375599-1-npiggin@gmail.com>
 <20240405090052.375599-13-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240405090052.375599-13-npiggin@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Apr 05, 2024 at 07:00:44PM +1000, Nicholas Piggin wrote:
>   SC2124 (warning): Assigning an array to a string! Assign as array, or
>   use * instead of @ to concatenate.
> 
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>  scripts/arch-run.bash | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
> index e5750cb98..89a496014 100644
> --- a/scripts/arch-run.bash
> +++ b/scripts/arch-run.bash
> @@ -150,7 +150,7 @@ run_migration ()
>  		return 77
>  	fi
>  
> -	migcmdline=$@
> +	migcmdline=("$@")
>  
>  	trap 'trap - TERM ; kill 0 ; exit 2' INT TERM
>  	trap 'rm -f ${src_out} ${dst_out} ${src_outfifo} ${dst_outfifo} ${dst_incoming} ${src_qmp} ${dst_qmp} ${src_infifo} ${dst_infifo}' RETURN EXIT
> @@ -179,7 +179,7 @@ run_migration ()
>  	exec {src_infifo_fd}<>${src_infifo}
>  	exec {dst_infifo_fd}<>${dst_infifo}
>  
> -	eval "$migcmdline" \
> +	eval "${migcmdline[@]}" \
>  		-chardev socket,id=mon,path=${src_qmp},server=on,wait=off \
>  		-mon chardev=mon,mode=control \
>  		< ${src_infifo} > ${src_outfifo} &
> @@ -219,7 +219,7 @@ run_migration ()
>  
>  do_migration ()
>  {
> -	eval "$migcmdline" \
> +	eval "${migcmdline[@]}" \
>  		-chardev socket,id=mon,path=${dst_qmp},server=on,wait=off \
>  		-mon chardev=mon,mode=control -incoming unix:${dst_incoming} \
>  		< ${dst_infifo} > ${dst_outfifo} &
> -- 
> 2.43.0
>

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
