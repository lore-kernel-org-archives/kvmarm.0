Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F94E17836B;
	Thu, 19 Dec 2024 16:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734626169; cv=none; b=INDRwrECEat/ON3IjDH41nj8EA4WbTzBKUixMAiB7FTSuG2yIslaAwnHf0/zpbk59ZbPc2I3iiZjK3XFEmYnpGjkOe/zsLgQCITr9J8UBRIoWzy6nyzkmY+1tpFDmT2nFnimY3JPSVv/Dlecm68n9kda1vvaHzPmPVUQdTe0oWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734626169; c=relaxed/simple;
	bh=i7qwNCit3QKYSAzYX+8Ze4W++VaLCtBrN0dc166zRl8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CwQgZmaP4QBlFS1n4YDE+w9t/jutvARAZ4++HXgyTZpYgk45jovVlsZpyQ5DV4wA9QJtzoOVGoGlhcrqYU7tNOGyPdyiZGhQ77UfgWMYQMehRjb2CaWlPXxtx/gRargmFRw7F8cR6GQ7PUI5MC5KihrUmEM/ZPe3w/Hi9cXWD34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IIeHtq8w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IIeHtq8w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A2E3C4CECE;
	Thu, 19 Dec 2024 16:36:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734626168;
	bh=i7qwNCit3QKYSAzYX+8Ze4W++VaLCtBrN0dc166zRl8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IIeHtq8wqTqb+0McM63yuiluXBY0IBrVdmvc+j3yxug65zbxXPiYlDAr4dZxnqT6O
	 RIeNGIkE68syYx4zs9a3SIUBZO87trPB69r46G6BacTzyFc5hJDxrFh8PtHHZtKrX9
	 DdHS4oKqNDbY0nED02LOy+xZ0h+2xhyvtSUwfbyQBQKEVMSxBm60ZrQRiu+fWhdGJu
	 9CfvRlG7fimxYUNVg5mm06bs4n9pVqc7Mi4QO/n/Ci8B84SWaNInTmUmbWpQS0b/oP
	 q9ostGD3Itsp5JgfnCxL1qIH7n4g3ysno1yM73C58AIquUFkx21Zt6aiEoX8w3R+QJ
	 tr08Zipuv4mFA==
Date: Thu, 19 Dec 2024 16:36:02 +0000
From: Will Deacon <will@kernel.org>
To: =?utf-8?Q?Miko=C5=82aj?= Lenczewski <miko.lenczewski@arm.com>
Cc: ryan.roberts@arm.com, catalin.marinas@arm.com, corbet@lwn.net,
	maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev
Subject: Re: [RESEND RFC PATCH v1 4/5] arm64/mm: Delay tlbi in
 contpte_convert() under BBML2
Message-ID: <20241219163602.GF24724@willie-the-truck>
References: <20241211160218.41404-1-miko.lenczewski@arm.com>
 <20241211160218.41404-5-miko.lenczewski@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20241211160218.41404-5-miko.lenczewski@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Wed, Dec 11, 2024 at 04:01:40PM +0000, Mikołaj Lenczewski wrote:
> When converting a region via contpte_convert() to use mTHP, we have two
> different goals. We have to mark each entry as contiguous, and we would
> like to smear the dirty and young (access) bits across all entries in
> the contiguous block. Currently, we do this by first accumulating the
> dirty and young bits in the block, using an atomic
> __ptep_get_and_clear() and the relevant pte_{dirty,young}() calls,
> performing a tlbi, and finally smearing the correct bits across the
> block using __set_ptes().
> 
> This approach works fine for BBM level 0, but with support for BBM level
> 2 we are allowed to reorder the tlbi to after setting the pagetable
> entries. This reordering means that other threads will not see an
> invalid pagetable entry, instead operating on stale data, until we have
> performed our smearing and issued the invalidation. Avoiding this
> invalid entry reduces faults in other threads, and thus improves
> performance marginally (more so when there are more threads).

Please provide the performance data.

Will
