Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63C8A17F373
	for <kvmarm@lists.linux.dev>; Wed, 12 Jun 2024 14:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718203600; cv=none; b=A7jUWooaaZB4se+0boStmjQLFA/pzKZiC2glcLbLFxLSZ4VUagCQBbRG2Sx6XDkAoirgOYcol+oePkbdwZn0eHZiJN9n2yjp5I32dRvCNMqaAAT7UQaWtebbt+INCCvTy8bL6cjJDxQohxZOEO62XCYuLzGW3G29Vp/gjMUoXnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718203600; c=relaxed/simple;
	bh=lgC8evedla9FMeoKu/uGDl0J2zplQ2DT07c/F9bQUi8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dDUh3EQYFuKpPzwuJJc0RDtad3hKWdiIaqvi5tBuNAthYTK3WhEeUQDztiuhlmf7AKAHwmX/ITAI4ypUweKxBPFAPnO34LSTx8nRsMmt3hx7YRzSIV5yghP6VuWhYknmL7RjewYMJxHR/tH7CkQdNQNH2InBi0onsp432mqy04s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 684BE1042;
	Wed, 12 Jun 2024 07:47:03 -0700 (PDT)
Received: from bogus (e103737-lin.cambridge.arm.com [10.1.197.49])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B9F593F64C;
	Wed, 12 Jun 2024 07:46:36 -0700 (PDT)
Date: Wed, 12 Jun 2024 15:46:34 +0100
From: Sudeep Holla <sudeep.holla@arm.com>
To: Sebastian Ene <sebastianene@google.com>
Cc: catalin.marinas@arm.com, james.morse@arm.com, jean-philippe@linaro.org,
	Sudeep Holla <sudeep.holla@arm.com>, maz@kernel.org,
	oliver.upton@linux.dev, qperret@google.com, qwandor@google.com,
	suzuki.poulose@arm.com, tabba@google.com, will@kernel.org,
	yuzenghui@huawei.com, lpieralisi@kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kernel-team@android.com
Subject: Re: [PATCH v2 0/4] KVM: arm64: pKVM host proxy FF-A fixes
Message-ID: <Zmm0yp-YCiehCvNC@bogus>
References: <20240515172258.1680881-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240515172258.1680881-1-sebastianene@google.com>

On Wed, May 15, 2024 at 05:22:54PM +0000, Sebastian Ene wrote:
> Hello,
> 
> 
> This series contains some small fixes for the host pKVM proxy code. I included
> some of the patches that I already sent on the list as part of this series
> to make it easier to keep track of them.
> 
> I verified the functionality with OPTEE as a TEE-OS.
>

For the series,

Tested-by: Sudeep Holla <sudeep.holla@arm.com>

I have been using this series along with couple of patches I posted to
workaround v1.0 and FF-A bus handling[1].

-- 
Regards,
Sudeep

[1] https://lore.kernel.org/all/20240515094028.1947976-1-sudeep.holla@arm.com/
