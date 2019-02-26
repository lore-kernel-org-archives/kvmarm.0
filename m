From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v5 01/26] KVM: Documentation: Document arm64 core
 registers in detail
Date: Tue, 26 Feb 2019 12:05:46 +0000
Message-ID: <20190226120545.GE3567@e103592.cambridge.arm.com>
References: <1550519559-15915-1-git-send-email-Dave.Martin@arm.com>
 <1550519559-15915-2-git-send-email-Dave.Martin@arm.com>
 <4086adbf-0a3f-bb44-5ec4-d6f92ed66a42@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8A08E4A3B4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Feb 2019 07:05:52 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TmVV+OYxyO8l for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Feb 2019 07:05:51 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 426044A1DF
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Feb 2019 07:05:51 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <4086adbf-0a3f-bb44-5ec4-d6f92ed66a42@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Julien Grall <julien.grall@arm.com>
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Feb 21, 2019 at 11:48:30AM +0000, Julien Grall wrote:
> Hi Dave,
> 
> On 18/02/2019 19:52, Dave Martin wrote:
> >Since the the sizes of individual members of the core arm64
> >registers vary, the list of register encodings that make sense is
> >not a simple linear sequence.
> >
> >To clarify which encodings to use, this patch adds a brief list
> >to the documentation.
> >
> >Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> 
> Reviewed-by: Julien Grall <julien.grall@arm.com>

Thanks
---Dave
