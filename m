Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41A7E4316F
	for <kvmarm@lists.linux.dev>; Tue, 21 Nov 2023 11:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="D6ZlfF2f"
Date: Tue, 21 Nov 2023 12:48:34 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1700567319;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MJvc/u+y8ffXcjbVywGlGI+oKyv//SVH2yBvytutDBI=;
	b=D6ZlfF2fZwYPxQ9RnNZD7hAazWaP070kho89l5ICYnQb0eOsipL+mdcoVJg5hy5kcPh5UM
	5MU/JKuXbQXsald1+UNRbxYNpG4rvfs29YDj7ldNFkLW11nS3mjIrRelWEaKNwzDllQXfO
	EzMGiopli+tbuZawgG3ifNac9esKyAA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Matthias Rosenfelder <matthias.rosenfelder@nio.io>
Cc: Andrew Jones <ajones@ventanamicro.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Eric Auger <eric.auger@redhat.com>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>
Subject: Re: [kvm-unit-tests PATCH] arm: pmu: Fix overflow test condition
Message-ID: <20231121-52d66740214725baf6775f54@orel>
References: <FRYP281MB31463EC1486883DDA477393DF2C0A@FRYP281MB3146.DEUP281.PROD.OUTLOOK.COM>
 <20231024-9418f5e7b9e014986bdd4b58@orel>
 <FRYP281MB3146C5D86DCCBBB6CA37D3ACF2DDA@FRYP281MB3146.DEUP281.PROD.OUTLOOK.COM>
 <20231026-82e0400727da79cc04a637a4@orel>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231026-82e0400727da79cc04a637a4@orel>
X-Migadu-Flow: FLOW_OUT

On Thu, Oct 26, 2023 at 04:31:51PM +0200, Andrew Jones wrote:
> On Thu, Oct 26, 2023 at 02:24:07PM +0000, Matthias Rosenfelder wrote:
> > Hi drew,
> > 
> > thanks for coming back to me. I tried using "git-send-email" but was struggling with the SMTP configuration of my company (Microsoft Outlook online account...). So far I've not found a way to authenticate with SMTP, so I was unfortunately unable to send the patch (with improved rationale, as requested).
> > 
> > Since giving back to the open source community is more of a personal wish and is not required by management (but also not forbidden), it has low priority and I already spent some time on this. I will send patches in the future from my personal email account.
> > 
> > I am totally fine with someone else submitting the patch.
> > If it's not too inconvenient, could you please add a "reported-by" to the patch? (No problem if not)
> > Thank you.
> 
> You have the authorship
> 
> https://gitlab.com/jones-drew/kvm-unit-tests/-/commit/52d963e95aa2fa3ce4faa9557cb99c002b177ec7
>

Merged into https://gitlab.com/kvm-unit-tests/kvm-unit-tests master

Thanks,
drew
