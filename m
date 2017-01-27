From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v4 3/4] arm64: Use __tlbi() macros in KVM code
Date: Fri, 27 Jan 2017 13:53:07 +0000
Message-ID: <20170127135306.GK21144@arm.com>
References: <20170125155232.10277-1-cov@codeaurora.org>
 <20170125155232.10277-3-cov@codeaurora.org>
 <20170125193943.GW15850@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C32F740064
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Jan 2017 08:52:57 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pWu4xOQYBXBc for <kvmarm@lists.cs.columbia.edu>;
 Fri, 27 Jan 2017 08:52:54 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 48C8E40019
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Jan 2017 08:52:53 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20170125193943.GW15850@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Mark Langsdorf <mlangsdo@redhat.com>, Jon Masters <jcm@redhat.com>, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, timur@codeaurora.org, linux-kernel@vger.kernel.org, Neil Leeder <nleeder@codeaurora.org>, Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Jan 25, 2017 at 08:39:43PM +0100, Christoffer Dall wrote:
> On Wed, Jan 25, 2017 at 10:52:31AM -0500, Christopher Covington wrote:
> > Refactor the KVM code to use the __tlbi macros, which will allow an errata
> > workaround that repeats tlbi dsb sequences to only change one location.
> > This is not intended to change the generated assembly and comparing before
> > and after vmlinux objdump shows no functional changes.
> > 
> > Signed-off-by: Christopher Covington <cov@codeaurora.org>
> 
> Acked-by: Christoffer Dall <christoffer.dall@linaro.org>

Thanks, I'll queue this one via arm64.

Will
