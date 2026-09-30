Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C3C94E0216;
	Wed, 30 Sep 2026 13:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790774472; cv=none; b=Zu/hETBV8PQsiY/DkY8hN7ffL+tO0zqESVKrTv70GeJyVwegprhlO7R47YxPNuFrkaTK/NG69J4eGcsFhpWSFesANz8CTMPa6s5TI4DDhx67tRExaIasr0c0vrh/+RzWVgyaVL5MjEPCDqBhahjwAAglQltpgqOrS0/c9sCbf1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790774472; c=relaxed/simple;
	bh=4wZDewP2RGse7Zw+zuVaU/BLnn4YFJizDqyyPy85DiI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XMp8fidqmubCuS8VGOxPauxinUIyGcxHra+YDZbbwgOk813xqMEO+m1Lc2lGrqcGx6T6qrwmVhSDfn4u9vzW+9L8SFTjOVA3xy3gI1j4qfriJETtMs1mUE014TdrJd6ihvAqwwWk+YR9lFF1lIJRtwRw/1YVJNFv5HsREL9xFp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=JPKUrK15; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="JPKUrK15"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C3B53497;
	Wed, 30 Sep 2026 06:20:50 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CE9443FA32;
	Wed, 30 Sep 2026 06:20:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790774454; bh=4wZDewP2RGse7Zw+zuVaU/BLnn4YFJizDqyyPy85DiI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JPKUrK15ML6CxeOQsAX17ABpRH/LJLKiH+0JPCvYi5MtaqlQKPWp/G5ufXIUI2gR1
	 xWv0ze54e5JV/G9+LO7+q6FRbJV3wNiVjUO19JzT06CYuJW9uih0QZ7RDNc3j+MThv
	 ZpnudoLQRY0AQVbuMtfzQTUpPrG8zL/VPdf9YgO0=
Date: Wed, 30 Sep 2026 14:20:47 +0100
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
Subject: Re: [PATCH v20 5/9] firmware: arm_rmm: Activate the RMM
Message-ID: <ar0Lksky-b81Eizj@arm.com>
References: <20260929221623.1342076-1-suzuki.poulose@arm.com>
 <20260929221623.1342076-6-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260929221623.1342076-6-suzuki.poulose@arm.com>

On Tue, Sep 29, 2026 at 11:16:19PM +0100, Suzuki K Poulose wrote:
> From: Steven Price <steven.price@arm.com>
> 
> Activate the RMM after the basic configuration. This is a memory
> transferring stateful operation.
> 
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
> Tested-by: Gavin Shan <gshan@redhat.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> Co-developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
