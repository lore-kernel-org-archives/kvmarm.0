Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FA9521D3FD
	for <kvmarm@lists.linux.dev>; Wed, 26 Feb 2025 19:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740598831; cv=none; b=KWNsh0huriTGu31I7Qm7FUAlZD9cc3KlqFcnZQD3AMp5e8mh9ms/O+/bY0wNmQUuN/8OSbJAs69CD84xja4ZJQT9tV5QWCy19+JQQ3YCh3KJ1TY0QjiGYHAJIkGDMA+ETtmp+NvFhT8BxKtC8G9O9HmKe8OduaZhWIUfheso6zY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740598831; c=relaxed/simple;
	bh=HlxDFmG7BCqGetOcb47cjU7jF3OZwSOwFkajg1XisaU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Cpqaq2HXkY9QhPOyOCoAzXTlGt4WMdzg4CZR23frziL3ua8jT8S69bDvKvTRDZqGDHZYL1rvRzvBpT8oeqSr3dSl+EynB0h/neMhPT+izYffwW27i2hi8mq3ymsVa1o7prK5G5BIlP3Iq1lDjpv0HKD7RjQmgKYUpug7Pmlcd0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CAB5C4CED6;
	Wed, 26 Feb 2025 19:40:28 +0000 (UTC)
Date: Wed, 26 Feb 2025 19:40:26 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Cc: kvmarm@lists.linux.dev, maz@kernel.org, oliver.upton@linux.dev,
	will@kernel.org, mark.rutland@arm.com, cohuck@redhat.com,
	eric.auger@redhat.com, sebott@redhat.com, yuzenghui@huawei.com,
	wangzhou1@hisilicon.com, jiangkunkun@huawei.com,
	jonathan.cameron@huawei.com, anthony.jebson@huawei.com,
	linux-arm-kernel@lists.infradead.org, linuxarm@huawei.com
Subject: Re: [PATCH v8 4/6] arm64: =?iso-8859-1?Q?M?=
 =?iso-8859-1?B?YWtlIKBfbWlkcl9pbl9yYW5nZV9saXN0KCk=?= an exported function
Message-ID: <Z79uKuwJM1iLnaoH@arm.com>
References: <20250221140229.12588-1-shameerali.kolothum.thodi@huawei.com>
 <20250221140229.12588-5-shameerali.kolothum.thodi@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250221140229.12588-5-shameerali.kolothum.thodi@huawei.com>

On Fri, Feb 21, 2025 at 02:02:27PM +0000, Shameer Kolothum wrote:
> Subsequent patch will add target implementation CPU support and that
> will require _midr_in_range_list() to access new data. To avoid
> exporting the data make _midr_in_range_list() a normal function and
> export it.
> 
> No functional changes intended.
> 
> Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
