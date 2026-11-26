Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795709338;
	b=5eESC/GLso4ckKZ9rExk3QofaGCltFL4zp8k+SXU5UkERd0wVO/UZPulWxpi0vZM5e8a
	 hBhu4j5QxPrwq835YYgwv14LP0LFaf//iShdt8fi+uLQcUigvq7tBF9GCPtlrQiMpjtk6
	 AJpKUBkFs3pweB4/RPXf2mxOvxJs+WWL0wfIM7MRSVLrZPbG23kvNXALSsy2ucZcDBhz7
	 8VoSfjChT73UR5chNxRnUtT8UxLFx3YsPq6LAOqjfSOxhxa/2GWWUPognC1O26G+TBu/U
	 8SsDDxdIv5gGBbFBUbRWug1XOc01MPjsfTGwUGLGJTevGdmKwG2StFhOKS9hnVSIdlw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795709338;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=DLjUQ0HLK8s6BPwACEgbTcL7p51N6h9aXcgetQhJ5wE=;
	b=fysOSYWUPwqhDiRBLoeeL3zmuEX1zYwooqSW+ruFwz89vskfD09K7ILpH9fKmN9YSw7v
	 PeV5SYDwyhQ/x9zx2dL0rl85RL2wEyfoLpnh942E7Axq+strGamYsJmQS/LJZ5sgCyEiA
	 XiItFtaBfh9tWxhNOExQFb9HnpST73X6Yn+8NNbpV96ht9VuMLO78hlbjf0esoFP0o/pv
	 tKea11GaSbqKWnJ+xpMN2lBQy80m3tFMpa7AVlDJVjIZWliBiVuuyTqiKpDTG5eepJS7I
	 Npgtv3lWWUJp0rKlrnKeRx7xJPywww/UpWpmbcbA48GjgZNtRg7FuHgD6/vTnbTDAFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YUMaSnJF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18FFD606A31E;
	Thu, 26 Nov 2026 16:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YUMaSnJF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E32C91F000D0;
	Thu, 26 Nov 2026 16:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795709338;
	bh=DLjUQ0HLK8s6BPwACEgbTcL7p51N6h9aXcgetQhJ5wE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YUMaSnJFy3upxu2uKVvNyvyEmBNmdKR2s8a9SQfDsb/I6ad8vW98yuZSb/L9He+QC
	 q0Loz9PWiYD2hI1+rgV/ar5z7B9qIXdayGw4WcvRijzEawQP6rhFdG7t1zDGsF7xGH
	 A3HpC8dsS41P/xO5oVu3gHyQr7zh0HQz1LIoQCJuJbA6WK65rd06yGyxYtGigTmi5u
	 RE6EcV3fmlScBlZCQkuWohiOQ5VC/Sxhf9rx7PdfVhDYSyh/TyigKOgtklp0s6yJuK
	 OAmBU+1xn0FLaY+xIDsBbqYSj/S6sBAnjKeu3TjGmHjWjQIhjZj7FNh+mAmH66Kkjm
	 ysTZImXrwDk7g==
Date: Thu, 26 Nov 2026 16:08:51 +0000
From: Will Deacon <will@kernel.org>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: julien.thierry.kdev@gmail.com, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	maz@kernel.org, oliver.upton@linux.dev, suzuki.poulose@arm.com,
	alexandru.elisei@arm.com, andre.przywara@arm.com
Subject: Re: [PATCH kvmtool] arm64: THPs for systems with pages bigger than 4K
Message-ID: <awhZk3NrkqeGvQxC@willie-the-truck>
References: <20261019145949.1922019-1-vdonnefort@google.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261019145949.1922019-1-vdonnefort@google.com>

On Mon, Oct 19, 2026 at 03:59:49PM +0100, Vincent Donnefort wrote:
> The THP support imposes an alignment of the memslot userspace address to
> the size of a THP (PMD_SIZE). To do so, kvmtool overallocates the RAM
> size and aligns it. However it assumes PMD_SIZE is 2MiB, which is only
> true on 4KiB page systems.
> 
> Use a huge-page size, based on the system page size. This value can be
> massive for a 64KiB page system, so skip the alignment if we couldn't
> even install one THP.
> 
> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
> 
> diff --git a/arm64/kvm.c b/arm64/kvm.c
> index 36b3284e4a92..2c01dc32fa9a 100644
> --- a/arm64/kvm.c
> +++ b/arm64/kvm.c
> @@ -18,6 +18,8 @@
>  
>  #include <asm/image.h>
>  
> +#define HUGEPAGE_SIZE (PAGE_SIZE * (PAGE_SIZE / 8UL))

Does this invoke sysconf() twice per invocation?

Will
