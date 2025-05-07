Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8992228AB19
	for <kvmarm@lists.linux.dev>; Wed,  7 May 2025 15:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746632428; cv=none; b=caagQrAwzRxB3UTPMj81WFLB50Mi12S3jYineEB6U0CsU/fAXOIDWHjuvfaOoQS/vWbKFzonl1Zn2dqn/nYLENHMeWALycFOiu3OWLE34RuzGKQQY3oc2FszQJLdMz4VwnzGOVg5D7/pvBUo/IDQ4OeOyW6dEnbBFdaLEZvi5No=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746632428; c=relaxed/simple;
	bh=t/JwkNQ7md1Wfy7HPN0sqPY3HEUCdJMfUrUXjvRg/w4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WPXAIFyKct9pUhLroCuyRo/yAsQtJcH2PRVnT63OC9xfgZ2rpdwrLVXYttnHxBv0lso0AoszOXPBANyKXvgw82Hsb9OhMPisTdVToa0ImvDC/a2B6Ugq1Z+tYcirWAMG7ZAFunRnpvwUvCtnBxixD6AgY1IKM9ymS5WNIE4X+Rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=m+ZnvXRq; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="m+ZnvXRq"
Date: Wed, 7 May 2025 17:40:15 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1746632421;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=co1RakSltze73RhSdPe5+tIxebPBqHB81ZkmAHOcpdM=;
	b=m+ZnvXRqSSY+K2f52Ea3a1FVRh25m7NSG5ScE7WOkOyjZiNL+rdunFIZHB6LKaYcrDNdR+
	YkWRy/GrECWURW27zLbn9OGhYuj5Dlku3tkYdTOBfmQBW4ZUZl2gZ1MRtzhPQB4bTsAPmP
	bMppl4LQ7OBTi5T6yUWL3oN+mgEz6DI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: eric.auger@redhat.com, lvivier@redhat.com, thuth@redhat.com, 
	frankja@linux.ibm.com, imbrenda@linux.ibm.com, nrb@linux.ibm.com, david@redhat.com, 
	pbonzini@redhat.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	will@kernel.org, julien.thierry.kdev@gmail.com, maz@kernel.org, 
	oliver.upton@linux.dev, suzuki.poulose@arm.com, yuzenghui@huawei.com, joey.gouly@arm.com, 
	andre.przywara@arm.com
Subject: Re: [kvm-unit-tests PATCH v3 01/16] scripts: unittests.cfg: Rename
 'extra_params' to 'qemu_params'
Message-ID: <20250507-97151633d3faefe9bd41b7f0@orel>
References: <20250507151256.167769-1-alexandru.elisei@arm.com>
 <20250507151256.167769-2-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250507151256.167769-2-alexandru.elisei@arm.com>
X-Migadu-Flow: FLOW_OUT

On Wed, May 07, 2025 at 04:12:41PM +0100, Alexandru Elisei wrote:
> The arm and arm64 architectures can also be run with kvmtool, and work is
> under way to have it supported by the run_tests.sh test runner. Not
> suprisingly, kvmtool's syntax for running a virtual machine is different to
> qemu's.
> 
> Add a new unittest parameter, 'qemu_params', with the goal to add a similar
> parameter for kvmtool, when that's supported.
> 
> 'extra_params' has been kept in the scripts as an alias for 'qemu_params'
> to preserve compatibility with custom test definition, but it is expected
> that going forward new tests will use 'qemu_params'.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  arm/unittests.cfg     |  76 +++++++++++------------
>  docs/unittests.txt    |  15 +++--
>  powerpc/unittests.cfg |  18 +++---
>  riscv/unittests.cfg   |   2 +-
>  s390x/unittests.cfg   |  50 +++++++--------
>  scripts/common.bash   |   8 +--
>  scripts/runtime.bash  |   6 +-
>  x86/unittests.cfg     | 140 +++++++++++++++++++++---------------------
>  8 files changed, 160 insertions(+), 155 deletions(-)
>

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
