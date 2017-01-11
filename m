From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v3 2/5] arm64: Work around Falkor erratum 1003
Date: Wed, 11 Jan 2017 18:37:39 +0000
Message-ID: <20170111183738.GD29247@leverpostej>
References: <20170111144118.17062-1-cov@codeaurora.org>
 <20170111144118.17062-2-cov@codeaurora.org>
 <20170111180627.GG20288@e104818-lin.cambridge.arm.com>
 <20170111183339.GC29247@leverpostej>
 <5da456f8-fcc5-b6e2-d58b-01a671da595b@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5da456f8-fcc5-b6e2-d58b-01a671da595b@codeaurora.org>
Sender: linux-doc-owner@vger.kernel.org
To: Timur Tabi <timur@codeaurora.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Christopher Covington <cov@codeaurora.org>, Mark Langsdorf <mlangsdo@redhat.com>, linux-doc@vger.kernel.org, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Jon Masters <jcm@redhat.com>, Jonathan Corbet <corbet@lwn.net>, Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Jan 11, 2017 at 12:35:55PM -0600, Timur Tabi wrote:
> On 01/11/2017 12:33 PM, Mark Rutland wrote:
> >It'll need to affect all lines since the kconfig column needs to expand
> >by at least one character to fit QCOM_FALKOR_ERRATUM_1003.
> 
> Or we can make the macro shorter.

The name, as it is, is perfectly descriptive.

Let's not sacrifice legibility over a non-issue.

Thanks,
Mark.
