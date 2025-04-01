Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A14121C160
	for <kvmarm@lists.linux.dev>; Tue,  1 Apr 2025 16:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743524136; cv=none; b=pfV7pq2pXRIpJdr1cfOWgYL9MYOiiY4AFJPRQq1C6+x7wPoWbFF9cYNp5k3U9Pc39vsgxKg5fcr7oKgiX9jjB8cVhWwUhk3u+3/nh5RXcSZH7xW0aHTK5NjDm4hlsw7XNM8QC4xGWbKA5b8k8LCxmo1iYSm5uKACCdfOJXeFBtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743524136; c=relaxed/simple;
	bh=CjsYqDTL3Qfv7/24claUN0TyqFxxHkmk7j1EDV4/lAM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kWLXWEdhl9gA2mo2X3acK9SpoS18h+nYl2klPaHqDRIGnV9sNDkLOZfUKsJqnsyp6eV999jrIbfupr9eHbIUwFZo7LnMzT9B6e/gweKSZMLgcLcE/5okMKS5DNMDBc7Ld7RNB4aWX/1k5jXYMIZ4RkGByn+RDmV3amLwKe7tn+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=VhHBMTqE; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="VhHBMTqE"
Date: Tue, 1 Apr 2025 09:15:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1743524131;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9DhpDvkNUPpfOH8u7g4NeRGrOLZYObi0VJk2tn4IER4=;
	b=VhHBMTqEvRt/W7d00gi4rZv5Vt1sCkI5ZjgFbjtPoY1C7HnULbeBlTPvlVAnbDMIyfrbQP
	cPq04Z8ih+Jha0ocloWyHnjO/ac7jH0NfHR2hGoGdLvpq3KA7IhBDbHJV/+up6tiMhH4/V
	QWd3mUEd3ZzAc8n9rErmjeYPnH73pfk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Yicong Yang <yangyicong@huawei.com>
Cc: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
	corbet@lwn.net, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, linux-kselftest@vger.kernel.org,
	linux-doc@vger.kernel.org, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com, shuah@kernel.org,
	jonathan.cameron@huawei.com, shameerali.kolothum.thodi@huawei.com,
	linuxarm@huawei.com, prime.zeng@hisilicon.com, xuwei5@huawei.com,
	yangyicong@hisilicon.com, tangchengchang@huawei.com
Subject: Re: [PATCH v2 5/6] arm64: Add ESR.DFSC definition of unsupported
 exclusive or atomic access
Message-ID: <Z-wRGyMrz0Tqh0CO@linux.dev>
References: <20250331094320.35226-1-yangyicong@huawei.com>
 <20250331094320.35226-6-yangyicong@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250331094320.35226-6-yangyicong@huawei.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Mar 31, 2025 at 05:43:19PM +0800, Yicong Yang wrote:
> From: Yicong Yang <yangyicong@hisilicon.com>
> 
> 0x35 indicates IMPLEMENTATION DEFINED fault for Unsupported Exclusive or
> Atomic access. Add ESR_ELx_FSC definition and corresponding wrapper.
> 
> Signed-off-by: Yicong Yang <yangyicong@hisilicon.com>

Just squash this into the next patch. Adding a helper w/o any user
usually isn't a good idea.

Thanks,
Oliver
