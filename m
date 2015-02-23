From: Pekka Enberg <penberg@iki.fi>
Subject: Re: stand-alone kvmtool
Date: Mon, 23 Feb 2015 19:23:58 +0200
Message-ID: <54EB622E.3020700@iki.fi>
References: <54DDD465.3050300@arm.com> <20150218155042.GF22017@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2366A465CE
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Feb 2015 12:18:25 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qESpI8eehzbU for <kvmarm@lists.cs.columbia.edu>;
 Mon, 23 Feb 2015 12:18:22 -0500 (EST)
Received: from out4-smtp.messagingengine.com (out4-smtp.messagingengine.com
 [66.111.4.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6B67B4656E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Feb 2015 12:18:21 -0500 (EST)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
 by mailout.nyi.internal (Postfix) with ESMTP id C1B662035A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Feb 2015 12:24:00 -0500 (EST)
In-Reply-To: <20150218155042.GF22017@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Will Deacon <will.deacon@arm.com>, Andre Przywara <andre.przywara@arm.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Marc Zyngier <Marc.Zyngier@arm.com>, Asias He <asias.hejun@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Pekka Enberg <penberg@kernel.org>, Ronald Minnich <rminnich@google.com>, Sasha Levin <sasha.levin@oracle.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 2/18/15 5:50 PM, Will Deacon wrote:
> Thanks for doing this. Since it looks unlikely that kvmtool will ever be
> merged back into the kernel tree, it makes sense to cut the dependency
> in my opinion.

I am certainly OK with a standalone repository which preserves the 
history. Will, would you like to take over the proposed new repository 
and put it somewhere on git.kernel.org, perhaps?

- Pekka
