Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BC56381EA6
	for <kvmarm@lists.linux.dev>; Thu,  2 Jul 2026 16:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010192; cv=none; b=NOzCmzFoIDnYh4o5UOUxMbZYrqTpD5Hx8lfsVrDRJ7x5+EA6G7k3yFUj5VpE/JkkN4mj94gupJMksuAB+YMmtdHH83gKYMj7my1hQnc48S0h4B8tMpaKanMuTKZDDJtEhmoq/usD6IPvrubKEtTsrXEwiZH/kq48mlbF6h9TXTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010192; c=relaxed/simple;
	bh=78NieMts7dNfZ0Fpn7sdTLpybzQQCzx3zTLO2Xi93mQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UGMBYH6UJiFhYBvnvg+Nh2H9leLEe4x+tx/wp1/oDFljfp3gVN6MHar0FHtxe1TP+qag8GSzzPY9svCqKaSTjH5dCiBrn3Bmdmp1D7R4avTjTT6yGhZU0m0LKl0Hts8aKV5Ao53NxuyLdSBI/yHZxJUCjNSAmkDco1GoGxAmRUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=GsG4M3zR; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="GsG4M3zR"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A4384359D;
	Thu,  2 Jul 2026 09:36:25 -0700 (PDT)
Received: from e140010.arm.com (e140010.arm.com [10.2.213.25])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 22C503F673;
	Thu,  2 Jul 2026 09:36:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783010190; bh=78NieMts7dNfZ0Fpn7sdTLpybzQQCzx3zTLO2Xi93mQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GsG4M3zRo/pRDPVrznxhOeGH7mnfay08nXoqAV9EAACSLkAt/mwAdMCg/XxSWuyKO
	 Mvwkp4z0ddTz9gfGJ9Fx2/4Q3hbumtjlKl0epHHgpJ8Mju/rbIFQrxrt32nRVuun/P
	 FWRkY9Z1PxE/DYSLdZ3rJNyzxeTBrXK2TF4YUKTg=
Date: Thu, 2 Jul 2026 17:36:24 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Jack Thomson <jackabt.amazon@gmail.com>
Cc: maz@kernel.org, oupton@kernel.org, pbonzini@redhat.com,
	joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org,
	shuah@kernel.org, corbet@lwn.net, vladimir.murzin@arm.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
	isaku.yamahata@intel.com, Jack Thomson <jackabt@amazon.com>
Subject: Re: [PATCH v5 0/5] KVM: arm64: Add KVM_PRE_FAULT_MEMORY support
Message-ID: <akaTiGMBM2Ega_Sm@e140010.arm.com>
References: <20260612162354.73378-1-jackabt.amazon@gmail.com_quarantine>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260612162354.73378-1-jackabt.amazon@gmail.com_quarantine>

Hi,

On Fri, Jun 12, 2026 at 05:23:48PM +0100, Jack Thomson wrote:
> From: Jack Thomson <jackabt@amazon.com>
> 
> Hi,
> 
> This series adds arm64 support for KVM_PRE_FAULT_MEMORY, which was added
> for x86 in [1]. The ioctl allows userspace to populate stage-2 mappings
> before running a vCPU, reducing the number of stage-2 faults taken in
> the run path. This is useful for post-copy migration, where stage-2
> fault latency shows up directly in memory-intensive workloads.
>
> ..
> 
> base-commit: 98f826f3c500fda08d51fca434b7aefa6a2f7076

I want to review and test the series, but I cannot seem to find the base
commit in the master branch:

$ git show --oneline
87320be9f0d2 (HEAD -> master, origin/master, origin/HEAD) Merge tag 'net-7.2-rc2' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net

$ git show 98f826f3c500fda08d51fca434b7aefa6a2
fatal: ambiguous argument '98f826f3c500fda08d51fca434b7aefa6a2': unknown revision or path not in the working tree.

Thanks,
Alex
