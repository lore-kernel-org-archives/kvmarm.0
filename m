From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v4 2/4] arm64: Work around Falkor erratum 1003
Date: Wed, 1 Feb 2017 16:33:58 +0000
Message-ID: <20170201163358.GG8177@arm.com>
References: <20170125155232.10277-1-cov@codeaurora.org>
 <20170125155232.10277-2-cov@codeaurora.org>
 <20170131123735.GD11191@leverpostej>
 <36478002-4cd8-7f1c-1a25-8bfe35022a47@codeaurora.org>
 <3cab36fb-984a-beae-64db-6ce830ba94f6@arm.com>
 <b4cf83d2-ae05-3362-bc23-2341d00516dc@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3391140296
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Feb 2017 11:33:39 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ega49aPWVjc2 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  1 Feb 2017 11:33:38 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2DDED40284
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Feb 2017 11:33:37 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <b4cf83d2-ae05-3362-bc23-2341d00516dc@codeaurora.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christopher Covington <cov@codeaurora.org>
Cc: Mark Langsdorf <mlangsdo@redhat.com>, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, timur@codeaurora.org, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Neil Leeder <nleeder@codeaurora.org>, Jon Masters <jcm@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Feb 01, 2017 at 11:29:22AM -0500, Christopher Covington wrote:
> On 01/31/2017 12:56 PM, Marc Zyngier wrote:
> > Given that all ARMv8 CPUs can support SW_PAN, it is more likely to be
> > enabled than the ARMv8.1 PAN. I'd vote for supporting the workaround in
> > that case too, and hope that people do enable the HW version.
> 
> Okay, I'll do my best to add support for the SW PAN case. I rebased and
> submitted v6 of the E1009 patch [1] so that it no longer depends on this
> patch landing first, if you all are inclined to pick it up while work on
> this E1003 patch continues.

The alternative is not enabling SW_PAN (at runtime) if this errata is
present, along with a warning stating that hardware-PAN should be
enabled in kconfig instead. Not sure what distributions will make of that
though.

> 1. https://patchwork.kernel.org/patch/9547923/

Yup, I queued that one locally and I'll push to -next tomorrow.

Thanks,

Will
