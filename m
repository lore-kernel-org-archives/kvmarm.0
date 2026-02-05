Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E02C543901F
	for <kvmarm@lists.linux.dev>; Thu,  5 Feb 2026 16:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770310596; cv=none; b=igbkeoGJe2PakvWN8j67Szux6U2Jx6S3OHu/ukwWVyqEfw+o/TKle9REz58r+UmWEJho1CmcuOhVRPuJKMgaJ2mqmW9mZws6qfbyk6RjDpm9k9sCcXYuyH6w4L3c4pbE/Ve4qiWOOeZRL2YId0knyoCU6WIGk1UE1Mr+BTl9rJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770310596; c=relaxed/simple;
	bh=/sCHwL9XTF+gHOTzvS+yQiQkchwlVUaEljSKNMP+aIs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fCSZkE8JEa+Scqs+STQoTU6wZ5dPFKypSOmgrL4F+YTXybrLJ/vPJsIA/OwSjCzhHIYmZgtulgFjscR9onY4E/E8qcNHZAL09uAdb0IT/gwaHk0OpoOxpu72yU6HoYj3wQmOnwuJYpq6zihoy2io6EmWlzdbtq7epEFOusasWyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 07B8A339;
	Thu,  5 Feb 2026 08:56:29 -0800 (PST)
Received: from arm.com (arrakis.cambridge.arm.com [10.1.197.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 913573F778;
	Thu,  5 Feb 2026 08:56:29 -0800 (PST)
Date: Thu, 5 Feb 2026 16:56:26 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Ben Horgan <ben.horgan@arm.com>
Cc: amitsinght@marvell.com, baisheng.gao@unisoc.com,
	baolin.wang@linux.alibaba.com, carl@os.amperecomputing.com,
	dave.martin@arm.com, david@kernel.org, dfustini@baylibre.com,
	fenghuay@nvidia.com, gshan@redhat.com, james.morse@arm.com,
	jonathan.cameron@huawei.com, kobak@nvidia.com, lcherian@marvell.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	peternewman@google.com, punit.agrawal@oss.qualcomm.com,
	quic_jiles@quicinc.com, reinette.chatre@intel.com,
	rohit.mathew@arm.com, scott@os.amperecomputing.com,
	sdonthineni@nvidia.com, tan.shaopeng@fujitsu.com,
	xhao@linux.alibaba.com, will@kernel.org, corbet@lwn.net,
	maz@kernel.org, oupton@kernel.org, joey.gouly@arm.com,
	suzuki.poulose@arm.com, kvmarm@lists.linux.dev,
	zengheng4@huawei.com, linux-doc@vger.kernel.org,
	Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
Subject: Re: [PATCH v4 10/41] arm64: mpam: Add helpers to change a task or
 cpu's MPAM PARTID/PMG values
Message-ID: <aYTLumWRtV9wnO-D@arm.com>
References: <20260203214342.584712-1-ben.horgan@arm.com>
 <20260203214342.584712-11-ben.horgan@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260203214342.584712-11-ben.horgan@arm.com>

On Tue, Feb 03, 2026 at 09:43:11PM +0000, Ben Horgan wrote:
> From: James Morse <james.morse@arm.com>
> 
> Care must be taken when modifying the PARTID and PMG of a task in any
> per-task structure as writing these values may race with the task being
> scheduled in, and reading the modified values.
> 
> Add helpers to set the task properties, and the CPU default value.  These
> use WRITE_ONCE() that pairs with the READ_ONCE() in mpam_get_regval() to
> avoid causing torn values.
> 
> Tested-by: Gavin Shan <gshan@redhat.com>
> Tested-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
> Tested-by: Peter Newman <peternewman@google.com>
> CC: Dave Martin <Dave.Martin@arm.com>
> Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
> Signed-off-by: James Morse <james.morse@arm.com>
> Signed-off-by: Ben Horgan <ben.horgan@arm.com>

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
