From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: Status of live migration on ARMv7
Date: Tue, 14 Jun 2016 20:20:25 +0100
Message-ID: <20160614202025.226dd45d@arm.com>
References: <trinity-d5cbcace-be15-4c67-b55c-1a70d1fb7c21-1465735240100@3capp-gmx-bs77>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 37E88499A1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Jun 2016 15:16:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6+aEMsQgGL3G for <kvmarm@lists.cs.columbia.edu>;
 Tue, 14 Jun 2016 15:16:00 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EA0FE4998D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Jun 2016 15:15:59 -0400 (EDT)
In-Reply-To: <trinity-d5cbcace-be15-4c67-b55c-1a70d1fb7c21-1465735240100@3capp-gmx-bs77>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: ib10evp0@gmx.org
Cc: kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Sun, 12 Jun 2016 14:40:40 +0200
ib10evp0@gmx.org wrote:

> Hi,
> 
> I was wondering what the status of live migration for ARMv7 with
> Virtualization Extensions is. I saw somebody was able to live migrate
> on ARM [1] but the repository he linked [2] has not been updated for
> 2 years. I'd like to know if live migration support for ARM is
> already in the mainstream kernel or if there are any custom patches
> required and if so if there is any newer code than [2].

Everything that's needed for a typical ARMv7 is already in mainline,
both for the kernel and qemu. And since the code is almost entirely
shared with ARMv8, it is probably in the same state. If it not working,
then it is a bug that should be addressed.

> BTW: The Migration page [3] claims the migration feature is hardware
> independent but it remains unclear if this expands to CPU
> architectures and if this applies to live migration or only offline
> migration. Some clarification in this regard would be nice to have.

We do have support for live migration (migrating the VM whilst it is
still running, tracking memory that gets dirtied).

	M.
-- 
Jazz is not dead. It just smells funny.
