Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33A67344056
	for <kvmarm@lists.linux.dev>; Mon, 23 Feb 2026 10:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771841155; cv=none; b=uVXuonZleHKsCMOUmYOt90HrVFLL/RzNdmRTIbBHvcwgDAwLcFCF4u6QRJZ6nj4TqiSSvVYWuus4FKlY1yktD3WJh4zDjPv1y1yWzt71NZAKL7i6whQbaYgZL65KhNdGwy5Ac5eAzwQCdjtZn5rRxAMYrMJeFGRnve+/WYfSUhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771841155; c=relaxed/simple;
	bh=hKfrqNACZeW/Mgnr8i4VzDxrr7Z9plrfq6D7ZJM9yLw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K3wXFmaKxREJrU0YI8Hl05M+XVnv3ec4CeVcHjO5Hlla8awmLMbu8Kjl2stlVS/XJY0Xf4GlGVARA+Uta/zRfnPT7Hympb+HR5u9sSKFtTdZzt5ax6F2aKVnTnf2oQ3j0mewM4Pu0j2ty+tnIUsTdKlZIYvNzdLoNNy0c04s9rE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 56CE3497;
	Mon, 23 Feb 2026 02:05:47 -0800 (PST)
Received: from J2N7QTR9R3 (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E7AF23F59E;
	Mon, 23 Feb 2026 02:05:51 -0800 (PST)
Date: Mon, 23 Feb 2026 10:05:46 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Mark Brown <broonie@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Fuad Tabba <tabba@google.com>,
	Oliver Upton <oupton@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Joey Gouly <joey.gouly@arm.com>, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Subject: Re: pKVM breakage in mainline on n1sdp
Message-ID: <aZwmevKcvW2HxdJ5@J2N7QTR9R3>
References: <60916cb6-f460-4751-b910-f63c58700ad0@sirena.org.uk>
 <87bjhie67o.wl-maz@kernel.org>
 <87a4x2e60i.wl-maz@kernel.org>
 <aZm2XCZLYxgxL99d@sirena.co.uk>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZm2XCZLYxgxL99d@sirena.co.uk>

On Sat, Feb 21, 2026 at 01:42:52PM +0000, Mark Brown wrote:
> On Sat, Feb 21, 2026 at 10:38:05AM +0000, Marc Zyngier wrote:
> 
> > If that's vanilla 6.19, then there is post Feb 8th. Sorry for the
> > unwarranted rant.
> 
> It won't be vanilla v6.19, that specific log will be tip of Linus' tree
> from yesterday morning UK time which should be 8bf22c33e7a1 ("Merge tag
> 'net-7.0-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net"),
> there were a few results for commits over the day prior to that showing
> the same behaviour.

Are you sure? That log says:

  CPU: 1 UID: 0 PID: 1955 Comm: qemu-system-aar Not tainted 6.19.0 #1 PREEMPT   

... where "6.19.0" means that's the 6.19 tag, and "#1" means that's the
first build against that.

Is the build system overriding things such that this is misleading?

Is there potentially a problem with the build system?

Mark.
