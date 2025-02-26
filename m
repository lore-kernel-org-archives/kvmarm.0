Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3876321D3FD
	for <kvmarm@lists.linux.dev>; Wed, 26 Feb 2025 19:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740598758; cv=none; b=EXAfFf6a3AaZoLkGGAgLAzMpdmE+r+AIZX0Mefk8QBUhyHwzAwnvEhPe3MzqeXg+Uj8Gpg0XxQOizpqW2BrG3uqPYw0LiNvhMvalEmdsCHxe6qAaBZGhKo6fgIUTG+xBvzMrKkliegqArplDjBo0O9Ba9ktM4XIrrYM9pPZpGNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740598758; c=relaxed/simple;
	bh=9l/QlZCsopZ2u9ju3q9wzm++5HbP7Wt1xKxJx5oZmAI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IE/PAz8TF6nKj83Xu74vvOlTlUW6SNybaphe2ARBT3ceKJ9PcL4BJTr/y8E6Z4EYT6qst782+/2wA1twH/DzfuGE+TLLCyMr7S/sobYJidzeQsHqnaFnPB+TCrsVtUT+QVFROUJ7VOgC7VZQU92yScNLwIy3iGD7yfw9nsAsync=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01BE8C4CEE7;
	Wed, 26 Feb 2025 19:39:14 +0000 (UTC)
Date: Wed, 26 Feb 2025 19:39:12 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Cc: kvmarm@lists.linux.dev, maz@kernel.org, oliver.upton@linux.dev,
	will@kernel.org, mark.rutland@arm.com, cohuck@redhat.com,
	eric.auger@redhat.com, sebott@redhat.com, yuzenghui@huawei.com,
	wangzhou1@hisilicon.com, jiangkunkun@huawei.com,
	jonathan.cameron@huawei.com, anthony.jebson@huawei.com,
	linux-arm-kernel@lists.infradead.org, linuxarm@huawei.com
Subject: Re: [PATCH v8 1/6] arm64: Modify _midr_range() functions to read
 MIDR/REVIDR internally
Message-ID: <Z79t4EEC4I5CKHAX@arm.com>
References: <20250221140229.12588-1-shameerali.kolothum.thodi@huawei.com>
 <20250221140229.12588-2-shameerali.kolothum.thodi@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250221140229.12588-2-shameerali.kolothum.thodi@huawei.com>

On Fri, Feb 21, 2025 at 02:02:24PM +0000, Shameer Kolothum wrote:
> These changes lay the groundwork for adding support for guest kernels,
> allowing them to leverage target CPU implementations provided by the
> VMM.
> 
> No functional changes intended.
> 
> Suggested-by: Oliver Upton <oliver.upton@linux.dev>
> Reviewed-by: Sebastian Ott <sebott@redhat.com>
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
