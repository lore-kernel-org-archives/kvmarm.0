Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3FD21C84A2;
	Wed, 30 Sep 2026 15:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783532; cv=none; b=GbU4tGfB2sKkMxyq/PigPVxkYFfY2YBinMVnN/2gwffhhOMMh3llzYWm+qDa30GbcvMqzNyH4K56NaUNrm6NC5YkNu0BqrWtoE0NgvEwcte0jW6ok6vdmTDWZQdXVq5tlVVWgxmQM8shFh+wBNs64PegMJHTbMIgsBQ/2WKbxII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783532; c=relaxed/simple;
	bh=extdkEulctGCgO2FHv6ak30k/drcOE/SZVDLQoZy8hI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D6TYYv3AzMNWTmxMgNFXAQwlJaFLuD+jGIub7vSX5KEcwJULqRg3mQ6hC4xkcmHijXj1R8WC4qT/FwtDDWKobM58khVe4S3Jd72SqCZLEokfbkcs5neKfrTQEc4YpG7WlTxn+aEVjwIdS6j0SpxQCgVXbH3/yITxS6xHcO21kaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=IEvD+ATK; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="IEvD+ATK"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 96D6F497;
	Wed, 30 Sep 2026 08:52:02 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 381783F86F;
	Wed, 30 Sep 2026 08:52:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790783526; bh=extdkEulctGCgO2FHv6ak30k/drcOE/SZVDLQoZy8hI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IEvD+ATKXF9d0sdMTwmIQ3m3lKlBJW7Iol3YRJYx4IFZW298KVvqcvV/+g9cEv7zm
	 yk3KvnDWzo7Sw8uYR7yfKzY51SINwDJW1hlhnOV5dscxRtw8KJ7Hm3dS4UYth7rGyf
	 wYB8VggKOOJZazD+/Qh8R9gYXUSG6q91BUHifJVI=
Date: Wed, 30 Sep 2026 16:51:57 +0100
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
Subject: Re: [PATCH v20 8/9] firmware: arm_rmm: Add wrappers for Realm
 related RMI commands
Message-ID: <ar0v1lOT7OW1KkGo@arm.com>
References: <20260929221623.1342076-1-suzuki.poulose@arm.com>
 <20260929221623.1342076-9-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260929221623.1342076-9-suzuki.poulose@arm.com>

On Tue, Sep 29, 2026 at 11:16:22PM +0100, Suzuki K Poulose wrote:
> From: Steven Price <steven.price@arm.com>
> 
> Introduce wrappers for the RMI functions needed for creating and
> managing realm guests. This will be used by the KVM to manage the
> Realms
> 
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> Co-developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
