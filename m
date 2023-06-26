Received: from out-58.mta1.migadu.com (out-58.mta1.migadu.com [95.215.58.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ED2BEC5
	for <kvmarm@lists.linux.dev>; Mon, 26 Jun 2023 06:18:46 +0000 (UTC)
Date: Mon, 26 Jun 2023 08:18:41 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1687760324;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OhZJ/PNAy1sS5Vv5/AA6dJUQlC5FYTgnnv+RdIErFtU=;
	b=Ifc9lbTcTU260O65sBkCBg0/4eXB3WhECvcP/cZ1sySn4dBcOoHlIlr38AXTN2Rp+tuceZ
	rr17UH0swxSyz6BckhoWRhKVqatHfTfBI3AHf2mUB1GNKJTM/dfCVfKepyvDHS/jmPN1s7
	u3z9+FLsJfoehJyg0rxb+SIcCODhyX8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Nadav Amit <nadav.amit@gmail.com>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	Nikos Nikoleris <nikos.nikoleris@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Nadav Amit <namit@vmware.com>
Subject: Re: [kvm-unit-tests PATCH v2 1/6] efi: keep efi debug information in
 a separate file
Message-ID: <20230626-74deb6543bf4c51ef9b723f2@orel>
References: <20230625230716.2922-1-namit@vmware.com>
 <20230625230716.2922-2-namit@vmware.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230625230716.2922-2-namit@vmware.com>
X-Migadu-Flow: FLOW_OUT

On Sun, Jun 25, 2023 at 11:07:11PM +0000, Nadav Amit wrote:
> From: Nadav Amit <namit@vmware.com>
> 
> Debugging tests that run on EFI is hard because the debug information is
> not included in the EFI file. Dump it into a separeate .debug file to
> allow the use of gdb or pretty_print_stacks script.
> 
> Signed-off-by: Nadav Amit <namit@vmware.com>
> 
> ---
> 
> v1->v2:
> * Making clean should remove .debug [Andrew]

I forgot to point out in the previous review that not only do we need
to clean but also add *.debug to .gitignore

Thanks,
drew
