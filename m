Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1768B52B1EC;
	Thu, 15 Oct 2026 16:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792081085; cv=none; b=VIvo0e1+mNdNJCPkXyezHN41F2fDqNb93lOBMXTbS99AudA7YO5D00gU8NxscD0Bc3YxAr6OEIFLRlXZoN37qgDhtAkUJYIjQMhKP+h+Lbyd0ZwgFrH13bcpFNjU797VbnWK6LkIkJZJmMSvMUMACIw1F9rZGyWkU0UbjlQ/VNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792081085; c=relaxed/simple;
	bh=CcTsQvG5H264PXNNnbzWGFQnXy4xmeYHvfS34lkt86Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YkE/myxWfUMWGlZlRdncV3ZkZGcoxVhCJ2xTg/eIzpmMgC7WYIXb49d28YwAKotLrU17mbsCjrXckFXK1D/fbUfCkFkIR5E4Q/qFJmku91Xqo0DeRTBMKJUgXfUqXd382DzkUaCMMq7NnvyPq9OtXVZQppJJl5D13mCmcs3qqGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YRFhddnO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YRFhddnO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95EFC1F000C4;
	Thu, 15 Oct 2026 16:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792081068;
	bh=c+imwRzy+TFjWbQ+yNo83g0lH0n4xVBCsI1vuUaGOns=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YRFhddnOwD67BDUZz8e+5AHZfAUyqZTD22qHQFLAaw0mX2G1Td8dj64kQAcpTaBmB
	 an3MHuPXbXjRjAAWTHrEfeCBQ23VfxijrwFYdpjokFn7IMZaO0aDLYDSllOGxzPnca
	 j4f4TyUtOAEnSWlIctPI1smEokMCFZ50ju4VKrdM=
Date: Thu, 15 Oct 2026 18:17:52 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ryan Roberts <ryan.roberts@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Alex Williamson <alex@shazbot.org>,
	Jason Gunthorpe <jgg@nvidia.com>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	Oded Gabbay <ogabbay@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	devicetree@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-doc@vger.kernel.org
Subject: Re: [RFC PATCH v2 02/15] misc/arm-cla: Add launch operation helpers
Message-ID: <2026101542-briskness-most-a8ca@gregkh>
References: <20261015142552.4128028-1-ryan.roberts@arm.com>
 <20261015142552.4128028-3-ryan.roberts@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261015142552.4128028-3-ryan.roberts@arm.com>

On Thu, Oct 15, 2026 at 03:25:36PM +0100, Ryan Roberts wrote:
> From: Jean-Philippe Brucker <jpb@kernel.org>
> 
> CLA commands are issued by writing optional payload registers,
> programming the LAUNCH register and polling LRESP until the hardware
> accepts or rejects the operation.
> 
> Add a common launch helper that performs this sequence on the CLA's
> local CPU, waits for LRESP completion and translates launch response
> codes into Linux errors.
> 
> Build accelerator reset and register read and write support on top of
> it. The register read and write helpers split larger accesses into
> multiple launch operations when an access crosses an eight-register
> window.
> 
> Signed-off-by: Jean-Philippe Brucker <jpb@kernel.org>

You forgot to sign off on patches from others :(

