From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v3 2/5] arm64: Work around Falkor erratum 1003
Date: Wed, 11 Jan 2017 18:33:40 +0000
Message-ID: <20170111183339.GC29247@leverpostej>
References: <20170111144118.17062-1-cov@codeaurora.org>
 <20170111144118.17062-2-cov@codeaurora.org>
 <20170111180627.GG20288@e104818-lin.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170111180627.GG20288@e104818-lin.cambridge.arm.com>
Sender: linux-doc-owner@vger.kernel.org
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christopher Covington <cov@codeaurora.org>, Mark Langsdorf <mlangsdo@redhat.com>, linux-doc@vger.kernel.org, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Jon Masters <jcm@redhat.com>, timur@codeaurora.org, Jonathan Corbet <corbet@lwn.net>, Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Jan 11, 2017 at 06:06:27PM +0000, Catalin Marinas wrote:
> On Wed, Jan 11, 2017 at 09:41:15AM -0500, Christopher Covington wrote:

> > -| Implementor    | Component       | Erratum ID      | Kconfig                 |

> > +| Implementor   | Component       | Erratum ID      | Kconfig                  |

> > +| Qualcomm      | Falkor v1       | E1003           | QCOM_FALKOR_ERRATUM_1003 |
> 
> Please don't change the "Implementor" column width, there is no point
> and it makes the patch harder to read (i.e. this hunk should only have
> one line).

It'll need to affect all lines since the kconfig column needs to expand
by at least one character to fit QCOM_FALKOR_ERRATUM_1003.

I beleive the intent here was to keep the table fitting into a width of
80 characters.

IMO we should allow the table to expand past 80 chars (everyone reading
this file should be able to resize tehir terminal), and only expand the
kconfig column.

Thanks,
Mark.
