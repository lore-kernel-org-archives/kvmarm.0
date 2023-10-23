Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C82011CB7
	for <kvmarm@lists.linux.dev>; Mon, 23 Oct 2023 14:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KGd9VIbY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24CF1C433CA;
	Mon, 23 Oct 2023 14:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1698070603;
	bh=Tsva2Jcx3f+q3JuOyVrZM2eEcMM1MKZDfCK0MNTt6oI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KGd9VIbYGqB2bzeB56eve6CsXs6jfhDAxuwu/8UMIfSpoXTdhg10bXnUC9cik/a+O
	 I5QltH88k1TUBjSPnanGmQLmsgOf0r5gYr3pxcy1VYvcoDmadWbIb+cStrlRLh6Fbj
	 kpyvkae99Q/DH0MaroEv0NhwsfihIBBKhnn8rULNj6SzZ1WI8JXSWyyrlrMfeSvGSe
	 xVWHFr1rxRTliwZKatk9zU/Hc8hOiRXCiwyWNkikJzOANA8uuhxIRoVdod0sQpLyv9
	 mqaCnGgZVMpnDd2ZHlXNhm4IYeEqmut52cUYTaH/YpN/8IswTOw3PGrt2nAbFTrIXm
	 95kOjdhQr0SDQ==
Date: Mon, 23 Oct 2023 15:16:39 +0100
From: Will Deacon <will@kernel.org>
To: KVMR <kvmrdy@gmail.com>
Cc: kvmarm@lists.linux.dev, tabba@google.com
Subject: Re: pKVM: Which kernel version has support for pKVM?
Message-ID: <20231023141639.GA3779@willie-the-truck>
References: <CAC=5qx_EDYCifRGNbXaJ96psuqQ-Y7zw8O_V_q-_kYpkuD52RQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAC=5qx_EDYCifRGNbXaJ96psuqQ-Y7zw8O_V_q-_kYpkuD52RQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Hi Venkat [+Fuad],

On Wed, Oct 11, 2023 at 09:10:19AM +0530, KVMR wrote:
> We are interested in using Protected KVM (pKVM) in one of our
> projects. Our goal is to launch protected VMs on Linux with KVM,
> ARM64. We have a few queries and would appreciate your assistance in
> addressing them:
> 
> 1. We'd like to know which mainline kernel version offers complete
> support for pKVM. We've observed that the current TOT kernel (6.6.rc5)
> may not have all the necessary changes. Specifically, we couldn't
> locate the KVM_CAP_ARM_PROTECTED_VM symbol in the code. If all the
> required changes have not yet been merged into the mainline kernel,
> could you please provide information on the specific branch or
> repository that contains these changes?

Upstreaming is currently blocked on support for the guestmem series [1],
but you can look at our integration branch at [2] which has everything
based on the last kernel release.

> 2. Are there any additional changes planned for pKVM, and is there a
> roadmap page where we can find more information on the project's
> future developments?

It's mainly driven by the Android annual roadmap, since that's still
the driving force behind pKVM.

> 3. In order to verify the pKVM memory protection features, we are
> seeking readily available test cases. Could you guide us to where we
> can find such test cases for this purpose?

We have high-level tests integrated with the Android CTS, but I'm not sure
whether that's what you're after.

Will

[1] https://lore.kernel.org/all/20230914015531.1419405-1-seanjc@google.com/
[2] https://android-kvm.googlesource.com/linux/+/refs/heads/for-upstream/pkvm-integration
