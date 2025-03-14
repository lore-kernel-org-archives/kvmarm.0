Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3A7A1F4169
	for <kvmarm@lists.linux.dev>; Fri, 14 Mar 2025 11:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741950904; cv=none; b=FAVRnjLJmuqdkA2OqmQtL7IuzufEUoHkYYgPtKL9vluM0BvxF1x3QHu+oYbxZTFA9/nlBtuzaO5AFaCPPXzlFpXy4MiF/3Jx2HR1JYMOlxfpbhFftQ3MwIifEF6ldJ7g+Jrtgb6tciM53u0JOzdwdfna0NwGMqOQjMBXXVwnGfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741950904; c=relaxed/simple;
	bh=VVaB597JRQGCm3zlkTNd3pHposxN/EcIibtdcYxFwCs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tKFigqdk84YfP6vjuMp2irWzaAo7ZhYDOqijZgXM0K/6kPXZkRSb3lXso/wPevsvQcpS+BBI7qztkS5Z8m0LP0BHbAvxRtg11Nf4SR1I1Yy+6P+kWG1Suw6ho15iaImS0+RnwA3KW3CPoXpIhc20Jx5R0Wx6UXiyWHpwzsK1cyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Jyg+GrkY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Jyg+GrkY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC1ABC4CEE9;
	Fri, 14 Mar 2025 11:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741950904;
	bh=VVaB597JRQGCm3zlkTNd3pHposxN/EcIibtdcYxFwCs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Jyg+GrkYkCQK0wf5/evfw05HX1ibkvofK77t8BjiKaPMEsgn0/OY1Slx45CMn9AS5
	 sa6TYTjbm6z60I9iANwvpshas8WpnlilxkF3rUf++RJrEy/q5qQdnRDwTs2p+aaSTs
	 6ML2dyzvLZqD4N19jDbk62dpfb/8ARBWqXUw95hk/FV5rt+QWQDviHkyLNHElSPLih
	 jsmrJ803mbznBOpJT49bOXk8UVmeNrJ0wrBS6LRgF1bdUjnOY+lIFKtaULoXXi+nGV
	 7Ep+VPJOk/B2dxIa2jcwdT4JdP7/2Cj7brqQPtVDQhu6GHr9wlnb1KdcPR0VK6DrN7
	 g22xYEBJje3cQ==
Date: Fri, 14 Mar 2025 11:14:58 +0000
From: Will Deacon <will@kernel.org>
To: Fuad Tabba <tabba@google.com>
Cc: Quentin Perret <qperret@google.com>, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, maz@kernel.org,
	oliver.upton@linux.dev, mark.rutland@arm.com, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, broonie@kernel.org, vdonnefort@google.com
Subject: Re: [PATCH v2 3/4] KVM: arm64: Factor out pKVM hyp vcpu creation to
 separate function
Message-ID: <20250314111457.GA8834@willie-the-truck>
References: <20250226215520.1759218-1-tabba@google.com>
 <20250226215520.1759218-4-tabba@google.com>
 <Z8ISLxQRcsx2uuHw@google.com>
 <CA+EHjTympdi0wei2Qx=hF2cYvHpzE0sWto2ypcJB3ddmonTROg@mail.gmail.com>
 <20250303191811.GA30361@willie-the-truck>
 <CA+EHjTySqDHDpOy=Vix5ZaNKWg61coySvV3Yk=+i0p8vg3mXTQ@mail.gmail.com>
 <20250303214947.GA30619@willie-the-truck>
 <CA+EHjTzZQ6UnOdaqpZ86JNiY=Gr_UoBAjZxk4CS3Q6nMJYdV2w@mail.gmail.com>
 <20250312152903.GA6488@willie-the-truck>
 <CA+EHjTwHb9mDj20WxeqKky6oAfRDV2R7iiQpwmuBmdZ4aWuS4A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTwHb9mDj20WxeqKky6oAfRDV2R7iiQpwmuBmdZ4aWuS4A@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Wed, Mar 12, 2025 at 03:31:17PM +0000, Fuad Tabba wrote:
> On Wed, 12 Mar 2025 at 15:29, Will Deacon <will@kernel.org> wrote:
> > On Tue, Mar 04, 2025 at 12:33:27PM +0000, Fuad Tabba wrote:
> > > If you agree, I could whip up something and send it soon.
> >
> > Yeah, I think we should fix this as a separate series and drop the
> > WRITE_ONCE() from this patch.
> 
> I'll send a fix soon.
> 
> Oliver, would you like me to respin this series, or can you drop the
> WRITE_ONCE()?

With the WRITE_ONCE() dropped:

Acked-by: Will Deacon <will@kernel.org>

Cheers,

Will
