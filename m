Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5552A35F8B7
	for <kvmarm@lists.linux.dev>; Fri, 24 Apr 2026 10:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777025316; cv=none; b=ERcKUblPsT47tA43zkJiBUewSeEogC8HTJGnr43MDcM5c5TZluDLhD3dCeTAUc4RUmzMLcrsFcKqg6Vx0elqO9G3cSl5HV6jh4a/1BuMAQupAcVODmvfUTetp8GCllXaXI97BJ7V6dk4xpA625TDJRPIC+ICct4uM8OoFv57k0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777025316; c=relaxed/simple;
	bh=x20Ic161sKUwYRA6ryFZm4hIWfUOKk542S8QeGSaRlw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=YHWPhVB+S+M7gBmPYbvhPgb9syotMYmqCzup/JNqqqNW/gsog2UoPJRHtorU2yQFMMRsh6oLnNWdauNLXqDKRcfA+XZqzfSIyp5YStoVPgmJ6061ZMGUklIYOWc4ychgqitEP4yzhiNB9b0AuKvxmOTcXbTUVeZxJEr+up/bw28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=RO/fAHz4; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="RO/fAHz4"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 343E71BC0;
	Fri, 24 Apr 2026 03:08:28 -0700 (PDT)
Received: from devkitleo.cambridge.arm.com (devkitleo.cambridge.arm.com [10.1.196.90])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 358933F641;
	Fri, 24 Apr 2026 03:08:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777025313; bh=x20Ic161sKUwYRA6ryFZm4hIWfUOKk542S8QeGSaRlw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RO/fAHz4w6tvV0tSr5IiP9uY7Vpvlt8ixeEw8Een+yh4bUys4r8C/Y9PL6dsRTgnI
	 At4+HDGbiLUoAT3XFkrO0n7AEEritCUqh/AVLOwsAswJ9HEztUYiEhAtWKQpnMwLky
	 g411WdNzZ6wH5t9Q5l/U80d9VZdfG9tUyFijm8jE=
From: Leonardo Bras <leo.bras@arm.com>
To: Tian Zheng <zhengtian10@huawei.com>
Cc: Leonardo Bras <leo.bras@arm.com>,
	maz@kernel.org,
	oupton@kernel.org,
	catalin.marinas@arm.com,
	corbet@lwn.net,
	pbonzini@redhat.com,
	will@kernel.org,
	yuzenghui@huawei.com,
	wangzhou1@hisilicon.com,
	liuyonglong@huawei.com,
	Jonathan.Cameron@huawei.com,
	yezhenyu2@huawei.com,
	linuxarm@huawei.com,
	joey.gouly@arm.com,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	skhan@linuxfoundation.org,
	suzuki.poulose@arm.com
Subject: Re: [PATCH v3 4/5] KVM: arm64: Enable HDBSS support and handle HDBSSF events
Date: Fri, 24 Apr 2026 11:08:25 +0100
Message-ID: <aetBGXkIbHaHm0L6@devkitleo>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <0403d30d-e75e-4922-b8c1-8cae349f3dc2@huawei.com>
References: <20260225040421.2683931-1-zhengtian10@huawei.com> <20260225040421.2683931-5-zhengtian10@huawei.com> <acQj5grOdZT8LUGp@devkitleo> <e3253959-0340-4c13-a980-a599e090a6de@huawei.com> <acabezCO4B5BE40Q@devkitleo> <4e800c1e-25db-4aa2-b100-63434973de93@huawei.com> <acpfD3YjMpEdL5KZ@devkitleo> <aeeHNMqDx5Yipt_K@devkitleo> <0403d30d-e75e-4922-b8c1-8cae349f3dc2@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Fri, Apr 24, 2026 at 02:48:26PM +0800, Tian Zheng wrote:
> 
> On 4/21/2026 10:18 PM, Leonardo Bras wrote:
> > On Mon, Mar 30, 2026 at 12:31:28PM +0100, Leonardo Bras wrote:
> > > On Sat, Mar 28, 2026 at 02:05:25PM +0800, Tian Zheng wrote:
> > > > On 3/27/2026 11:00 PM, Leonardo Bras wrote:
> > > > > On Fri, Mar 27, 2026 at 03:35:29PM +0800, Tian Zheng wrote:
> > > > > > On 3/26/2026 2:05 AM, Leonardo Bras wrote:
> > > > > > > Hello Tian,
> > > > > > > 
> > > > > > > I am currently working on HACDBS enablement(which will be rebased on top of
> > > > > > > this patchset) and due to the fact HACDBS and HDBSS are kind of
> > > > > > > complementary I will sometimes come with some questions for issues I have
> > > > > > > faced myself on that part. :)
> > > > > > > 
> > > > > > > (see below)
> > > > > > Of course! Happy to exchange ideas and learn together.
> > > > > :)
> > Hello Tian,
> > 
> > On the above, HACDBS depends on HACDBSIRQ which can be announced by either
> > device-tree or ACPI.
> > 
> > Do you think it's ok for it to be ACPI only, for now?
> > 
> > Thanks!
> > Leo
> 
> Hi Leo,
> 
> No problem with ACPI-only for HACDBSIRQ for now.

Awesome!
I got it all working on my side, so I will try to send a freestanding patch 
with the required needs from HDBSS :)

> 
> Feel free to let me know if you have any questions while working
> on HACDBS on top of HDBSS.
> 

Will do:)

Thanks!
Leo


> Tian
> 
