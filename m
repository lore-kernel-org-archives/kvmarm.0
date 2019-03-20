From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v5 00/26] KVM: arm64: SVE guest support
Date: Wed, 20 Mar 2019 12:30:39 +0000
Message-ID: <20190320123038.GP3567@e103592.cambridge.arm.com>
References: <1553017938-710-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <1553017938-710-1-git-send-email-Dave.Martin@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: kvmarm@lists.cs.columbia.edu
Cc: Peter Maydell <peter.maydell@linaro.org>, Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>, Julien Grall <julien.grall@arm.com>, Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Mar 19, 2019 at 05:51:51PM +0000, Dave Martin wrote:

[...]

> Known issues:
> 
>  * This update requires modifications to kvmtool that are not published
>    yet.  I will reply to this cover letter with a link when those are
>    available (hopefully within 24 hours of this posting).
> 
>    The kvmtool branch referenced by the v5 cover letter **will not
>    work** with v6...  Please be patient :)

I've now posted the updated kvmtool series [1].

I've also pushed the series to git for convenience [2].

Testing/comments welcome, as always.


[1] [PATCH kvmtool v2 0/3] arm64: Basic SVE guest support
https://lists.cs.columbia.edu/pipermail/kvmarm/2019-March/035198.html

[2]
git://linux-arm.org/kvmtool-dm.git sve-linuxv6/v2/head
http://linux-arm.org/git?p=kvmtool-dm.git;a=shortlog;h=refs/heads/sve-linuxv6/v2/head

Cheers
---Dave
