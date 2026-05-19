Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 601A124679C
	for <kvmarm@lists.linux.dev>; Tue, 19 May 2026 15:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779204961; cv=none; b=Va+DQCwAm7r7/64xSZ/s6ZbxwF9RL/yTdXX0ktbrHiOFIJUZUd3HwfvPifKLLoe4brsTB/uXVFIITSk6VCyrkBhEf9cBOoCK1ZDPnP3EdHe67mNQvoywsFCxOMBtOo8XamoRh/5FsleNV6dRoFvGzn+z3D6tOu9TnYxpLjVv+bI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779204961; c=relaxed/simple;
	bh=ZkRz0E7rghIRIQ6Vas5WZriK1yQc+rUOKfruBiITXEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=F6Pin+4BeKLGQncWgzZqx9tNKLw29gv/WZkRAzXBCZsde8wyXuVipKI1xpNTjm8erkvuaGbetMJIFvEfpOzxFAHj3hWuEuj2ZIkrjaRDD/I5Rpowysn0mLPPFejS23hcK9hRtKrC/FbjFQKT/OWRA2PVCsIclgGz+HhAFnixKj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Tr5Iy+eF; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Tr5Iy+eF"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 46E243528;
	Tue, 19 May 2026 08:35:52 -0700 (PDT)
Received: from devkitleo.cambridge.arm.com (devkitleo.cambridge.arm.com [10.1.196.90])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 06D2F3F632;
	Tue, 19 May 2026 08:35:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779204957; bh=ZkRz0E7rghIRIQ6Vas5WZriK1yQc+rUOKfruBiITXEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tr5Iy+eFwtAYt3ObIw+VJv4hqD8NnNXrVImS/KaM3B7UPx2teDebcJMl0o/sqAvrd
	 eVGCpt/7KscfUVWRWqRTlVXYKxM8aygDha8hQMG0DXl0eAjjoV6H0iM0KGW2GzQFrT
	 S5BU9CCBk23N6+39Bw8htB9d60IxSCooMRuRfvlI=
From: Leonardo Bras <leo.bras@arm.com>
To: Will Deacon <will@kernel.org>
Cc: Leonardo Bras <leo.bras@arm.com>,
	maz@kernel.org,
	oupton@kernel.org,
	catalin.marinas@arm.com,
	corbet@lwn.net,
	pbonzini@redhat.com,
	Tian Zheng <zhengtian10@huawei.com>,
	kernel-team@android.com,
	yuzenghui@huawei.com,
	wangzhou1@hisilicon.com,
	liuyonglong@huawei.com,
	yezhenyu2@huawei.com,
	linuxarm@huawei.com,
	joey.gouly@arm.com,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	skhan@linuxfoundation.org,
	suzuki.poulose@arm.com,
	Jonathan Cameron <jic23@kernel.org>
Subject: Re: [PATCH v3 0/5] Support the FEAT_HDBSS introduced in Armv9.5
Date: Tue, 19 May 2026 16:35:47 +0100
Message-ID: <agyDU3ujE-OJWTiC@devkitleo>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <177918656142.736362.17906576792384645789.b4-ty@kernel.org>
References: <20260225040421.2683931-1-zhengtian10@huawei.com> <177918656142.736362.17906576792384645789.b4-ty@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Tue, May 19, 2026 at 04:23:12PM +0100, Will Deacon wrote:
> On Wed, 25 Feb 2026 12:04:16 +0800, Tian Zheng wrote:
> > This series of patches add support to the Hardware Dirty state tracking
> > Structure(HDBSS) feature, which is introduced by the ARM architecture
> > in the DDI0601(ID121123) version.
> > 
> > The HDBSS feature is an extension to the architecture that enhances
> > tracking translation table descriptors' dirty state, identified as
> > FEAT_HDBSS. This feature utilizes hardware assistance to achieve dirty
> > page tracking, aiming to significantly reduce the overhead of scanning
> > for dirty pages.
> > 
> > [...]
> 
> Applied sysreg definitions to arm64 (for-next/sysregs), thanks!
> 
> [1/5] arm64/sysreg: Add HDBSS related register information
>       https://git.kernel.org/arm64/c/72f7be0c2e30
> 

Thanks!
Leo

> Cheers,
> -- 
> Will
> 
> https://fixes.arm64.dev
> https://next.arm64.dev
> https://will.arm64.dev
