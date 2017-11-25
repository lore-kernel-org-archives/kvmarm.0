From: Andrew Jones <drjones@redhat.com>
Subject: Re: [RFC] KVM API extensions for SVE
Date: Sat, 25 Nov 2017 18:40:18 +0100
Message-ID: <20171125174018.vzu2qsiql2einnpu@kamzik.brq.redhat.com>
References: <20171121134913.GI22781@e103592.cambridge.arm.com>
 <20171122195230.GT28855@cbox>
 <20171123184050.GM22781@e103592.cambridge.arm.com>
 <20171124144538.GG28855@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 01E1A49D6D
 for <kvmarm@lists.cs.columbia.edu>; Sat, 25 Nov 2017 12:37:41 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QFoeB+RRd+ut for <kvmarm@lists.cs.columbia.edu>;
 Sat, 25 Nov 2017 12:37:40 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1FD7149D6B
 for <kvmarm@lists.cs.columbia.edu>; Sat, 25 Nov 2017 12:37:38 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20171124144538.GG28855@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <cdall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Dave Martin <Dave.Martin@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Nov 24, 2017 at 03:45:38PM +0100, Christoffer Dall wrote:
> On Thu, Nov 23, 2017 at 06:40:50PM +0000, Dave Martin wrote:
> > 
> > I don't think it's all that bad, but there doesn't seem to be any
> > example of an optional architecture feature for a guest today --
> > so I wanted to check before setting a precedent here.
> 
> We don't enable the GIC unless userspace asks for it, same with the
> PMU...
>

And this reminds me that we need to apply the new ID register
trapping support Dave added to hiding the PMU when userspace
doesn't enable it. Patch coming in a couple seconds...

drew
