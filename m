From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v3 2/5] arm64: Work around Falkor erratum 1003
Date: Thu, 12 Jan 2017 09:59:32 +0000
Message-ID: <20170112095932.q54jyb33gxyp2ccu@localhost>
References: <20170111144118.17062-1-cov@codeaurora.org>
 <20170111144118.17062-2-cov@codeaurora.org>
 <20170111180627.GG20288@e104818-lin.cambridge.arm.com>
 <20170111183339.GC29247@leverpostej>
 <5da456f8-fcc5-b6e2-d58b-01a671da595b@codeaurora.org>
 <20170111183738.GD29247@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AD195402A3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Jan 2017 04:57:51 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZlWwlAQZxHqI for <kvmarm@lists.cs.columbia.edu>;
 Thu, 12 Jan 2017 04:57:50 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A234940296
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Jan 2017 04:57:50 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20170111183738.GD29247@leverpostej>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Mark Rutland <mark.rutland@arm.com>
Cc: Mark Langsdorf <mlangsdo@redhat.com>, kvm@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <marc.zyngier@arm.com>, Jon Masters <jcm@redhat.com>, Timur Tabi <timur@codeaurora.org>, linux-doc@vger.kernel.org, Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Jan 11, 2017 at 06:37:39PM +0000, Mark Rutland wrote:
> On Wed, Jan 11, 2017 at 12:35:55PM -0600, Timur Tabi wrote:
> > On 01/11/2017 12:33 PM, Mark Rutland wrote:
> > >It'll need to affect all lines since the kconfig column needs to expand
> > >by at least one character to fit QCOM_FALKOR_ERRATUM_1003.
> > 
> > Or we can make the macro shorter.
> 
> The name, as it is, is perfectly descriptive.
> 
> Let's not sacrifice legibility over a non-issue.

I agree, I didn't realise that the we expand the last column already.
It's a non-issue indeed.

-- 
Catalin
