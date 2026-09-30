Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1AE78450412;
	Wed, 30 Sep 2026 11:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790766667; cv=none; b=eSU42VtJfQDb4SDtTkm7+6CEPUJQzBigY9a3Dc79akOBFXjfoRFRZegqq53Jie5QKaZclRU2EGESsPgaSeFboM/DMyGmdpVdgq8IVoCKMubtKspZwrNgbXTffw+uUe2ZB8baQMJm3lZDjDcLw93aCzSgfF7LI36LBymfrWm+mgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790766667; c=relaxed/simple;
	bh=09jEaArNS417em6ToBSG7qdKHqccds8/fy4zdxtvQ3c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QZeDhWVMF0QxLh+CO3AcPOfKxrdGQNDBzIOLwJW88ooBakmzNSQxSg0nsH6Pxq4A+m388fAYlXpxAxG1QHS/f05wjbO9x1A8yIDAa+NSkx6p8pr5VG4nz1JTHnRBPpb26JtcVNY1rkaX6HYCab3M0ULHG0tQcMn3dBIS0kJBq0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=hMLeo9c8; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="hMLeo9c8"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D00E8497;
	Wed, 30 Sep 2026 04:11:01 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 758023F86F;
	Wed, 30 Sep 2026 04:11:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790766665; bh=09jEaArNS417em6ToBSG7qdKHqccds8/fy4zdxtvQ3c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hMLeo9c82Gy/Wy2abm9knjbpZVruD+1wc6Ju/TC06SrUV3zQ98jhitLXZDTDvGcac
	 EE7y27oqCNqxVVzA+ROY4AN/V1t2c2Loi/j9tft1p/a1u1uN7sSenO1pHVWXx9svge
	 PndYOaEjhnAao/piuhts7nsxFTeV7QEAR4LEVfW0=
Date: Wed, 30 Sep 2026 12:10:51 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, maz@kernel.org,
	will@kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, steven.price@arm.com,
	aneesh.kumar@kernel.org, oupton@kernel.org, gshan@redhat.com,
	joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
	linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
	sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
	WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com,
	sudeep.holla@arm.com, jonathan.cameron@oss.qualcomm.com
Subject: Re: [PATCH v20 3/9] firmware: arm_rmm: Configure the RMM with the
 host's page size
Message-ID: <arzuKMam8IJkjB7T@arm.com>
References: <20260929221623.1342076-1-suzuki.poulose@arm.com>
 <20260929221623.1342076-4-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260929221623.1342076-4-suzuki.poulose@arm.com>

On Tue, Sep 29, 2026 at 11:16:17PM +0100, Suzuki K Poulose wrote:
> From: Steven Price <steven.price@arm.com>
> 
> RMM v2.0 brings the ability to set the RMM's granule size. Check the
> feature registers and configure the RMM so that it matches the host's
> page size. This means that operations can be done with a granularity
> equal to PAGE_SIZE.
> 
> Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> Tested-by: Gavin Shan <gshan@redhat.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> Co-developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
