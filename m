Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C523520E030;
	Fri, 10 Jan 2025 13:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736514951; cv=none; b=P3nwEfQXdT4VTUXbWF5xqzs7iYmk1NAsXxY1SfCi0yhi9QYgX6xoiF+CP9gUtzHqrgZS+OoDJ+ycetY6UoMoqfswcCvizfxM8HddelZSGxt6l+fWA/BGmvydFsfiztp1Ky0XcGZZraIU1JsGgYfAHYFJq+JGZNOrXiQvpn3XBoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736514951; c=relaxed/simple;
	bh=dQCOdZRGnjBtaZDEqHo5YmfoSv+DEbTUQJY9M9fyED4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NbhLYxTIOMG493SNcBeztSob+6U3w+qSTwkCr/4Npv2eM36J7THRyaq66N3CDcj3D4VbbLS71HyMFiz4PHo8FUpPR5aMv3YtWxQbe+KmKBZYpO/2K6quKmZo5/fGgKZZgaE+A2z6IOU1yGtwaT9THp4vi4GkSEXPAxBZxP9xyhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FEFEC4CED6;
	Fri, 10 Jan 2025 13:15:48 +0000 (UTC)
Date: Fri, 10 Jan 2025 13:15:46 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Steven Price <steven.price@arm.com>, Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>, Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v2 3/7] arm64: cpufeature: add Allocation Tag Access
 Permission (MTE_PERM) feature
Message-ID: <Z4Edgo6dvU3KBCLQ@arm.com>
References: <20250110110023.2963795-1-aneesh.kumar@kernel.org>
 <20250110110023.2963795-4-aneesh.kumar@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250110110023.2963795-4-aneesh.kumar@kernel.org>

On Fri, Jan 10, 2025 at 04:30:19PM +0530, Aneesh Kumar K.V (Arm) wrote:
> This indicates if the system supports MTE_PERM. This will be used by KVM
> for stage 2 mapping. This is a CPUCAP_SYSTEM feature because if we enable
> the feature all cpus must have it.
> 
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
