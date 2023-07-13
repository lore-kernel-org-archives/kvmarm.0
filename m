Received: from out-55.mta0.migadu.com (out-55.mta0.migadu.com [91.218.175.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89F846108
	for <kvmarm@lists.linux.dev>; Thu, 13 Jul 2023 06:01:48 +0000 (UTC)
Date: Wed, 12 Jul 2023 23:01:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1689228105;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PUd5QBFuIZqGlE60i0vexGbRuMlDcLS+ViVFV/4HNkE=;
	b=Ytgk2lPDsLUI4qkJKqeWx16eIywoMzUTfFAkPbS5jQ90hBGFe86PN4ZaLGVbjPutCLbyZR
	EOIOGWTkd+j3WM5f8pUfpmOCirTkRQ7C4H/qJQmVxWCiD7fU0cvvcHhn9fDN1ZfSgaNwPz
	zvl4bXvIOM/F+m4kq/UBmMKwt8Uao/A=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: "chenxiang (M)" <chenxiang66@hisilicon.com>
Cc: Marc Zyngier <maz@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>,
	kvmarm@lists.linux.dev, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>, stable@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: vgic-v4: Consistently request doorbell irq
 for blocking vCPU
Message-ID: <ZK+TQ7qRK51N1n7g@thinky-boi>
References: <20230710175553.1477762-1-oliver.upton@linux.dev>
 <86jzv6x66q.wl-maz@kernel.org>
 <ZK0EPhvLzhaFepGk@linux.dev>
 <14acf0fd-e5eb-8a14-986a-b8fe4a44cec9@huawei.com>
 <86zg41utno.wl-maz@kernel.org>
 <092f42c5-02d1-6f05-ea92-0eae3a55341e@hisilicon.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <092f42c5-02d1-6f05-ea92-0eae3a55341e@hisilicon.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Jul 13, 2023 at 01:57:46PM +0800, chenxiang (M) wrote:
> > Of course, it is totally untested... ;-) But I like that the doorbell
> > request is solely driven by the WFI state, and we avoid leaking the
> > knowledge outside of the vgic code.
> 
> I have tested this approach and it also solves the issue. Please feel free
> to add:
> Tested-by: Xiang Chen <chenxiang66@hisilicon.com>

Excellent, thanks for testing a couple of iterations for us here. Marc,
do you want to add a changelog to this?

--
Thanks,
Oliver
