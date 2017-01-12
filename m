From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v3 2/5] arm64: Work around Falkor erratum 1003
Date: Thu, 12 Jan 2017 16:12:14 +0000
Message-ID: <20170112161214.GB12583@leverpostej>
References: <20170111144118.17062-1-cov@codeaurora.org>
 <20170111144118.17062-2-cov@codeaurora.org>
 <20170111180627.GG20288@e104818-lin.cambridge.arm.com>
 <278a45c0-bd49-b8a2-63ae-80ad851bab9b@arm.com>
 <20170111184052.GE29247@leverpostej>
 <20170112154548.twj2ktbfzbsarzbc@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B3EC440284
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Jan 2017 11:11:29 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rQ4Bvo-GtrRo for <kvmarm@lists.cs.columbia.edu>;
 Thu, 12 Jan 2017 11:11:28 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7F6714025C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Jan 2017 11:11:28 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20170112154548.twj2ktbfzbsarzbc@localhost>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Mark Langsdorf <mlangsdo@redhat.com>, kvm@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <marc.zyngier@arm.com>, Jon Masters <jcm@redhat.com>, timur@codeaurora.org, linux-doc@vger.kernel.org, Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Jan 12, 2017 at 03:45:48PM +0000, Catalin Marinas wrote:
> On Wed, Jan 11, 2017 at 06:40:52PM +0000, Mark Rutland wrote:

> > Likewise, I beleive we may need to modify cpu_set_reserved_ttbr0().
> 
> This may be fine if my assumptions about this erratum are correct. In
> the cpu_set_reserved_ttbr0() case we set TTBR0_EL1 to a table without
> any entries, so no new entries could be tagged with the old ASID.

For some reason, I was under the impression that the issue was old table
entries being allocated to the new ASID. Looking over the series again,
it's not clear to me precisely which cases can occur.

It would be good to see that clarified.

Thanks,
Mark.
