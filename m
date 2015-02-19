From: Sasha Levin <sasha.levin@oracle.com>
Subject: Re: stand-alone kvmtool
Date: Thu, 19 Feb 2015 05:56:45 -0500
Message-ID: <54E5C16D.3060109@oracle.com>
References: <54DDD465.3050300@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CE53745FE8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Feb 2015 05:51:41 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mI6SpWoyN9Yg for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 Feb 2015 05:51:40 -0500 (EST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C7FDB45FBB
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Feb 2015 05:51:40 -0500 (EST)
In-Reply-To: <54DDD465.3050300@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andre Przywara <andre.przywara@arm.com>, Pekka Enberg <penberg@kernel.org>, Cyrill Gorcunov <gorcunov@gmail.com>, Asias He <asias.hejun@gmail.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Marc Zyngier <Marc.Zyngier@arm.com>, Will Deacon <will.deacon@arm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Ronald Minnich <rminnich@google.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 02/13/2015 05:39 AM, Andre Przywara wrote:
> Hi,
> 
> as I found it increasingly inconvenient to use kvmtool[1] as part of a
> Linux repository, I decided to give it a go and make it a stand-alone
> project. So I filtered all the respective commits, adjusted the paths in
> there (while keeping authorship and commit date, of course) and then
> added the missing bits to let it compile without a kernel tree nearby.
> The result is now available on:
> 
> git://linux-arm.org/kvmtool.git
> http://linux-arm.org/kvmtool.git

Hi Andre,

What inconvenience is caused by having it sit inside the kernel tree
beyond an increased requirement in disk space?

Moving it out will make us lose all the new features and bug fixes we
gain from using the kernel code directly rather than copying it once
in a while.

With your suggestion we'll end up needing something that copies stuff
from the kernel into that standalone tree, just like what qemu does.


Thanks,
Sasha
