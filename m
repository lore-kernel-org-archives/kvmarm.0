From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v5 06/26] arm64/sve: Check SVE virtualisability
Date: Tue, 26 Feb 2019 12:06:47 +0000
Message-ID: <20190226120647.GI3567@e103592.cambridge.arm.com>
References: <1550519559-15915-1-git-send-email-Dave.Martin@arm.com>
 <1550519559-15915-7-git-send-email-Dave.Martin@arm.com>
 <ea9a0255-5829-883c-d28c-0c34716bbbdb@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 418E04A36C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Feb 2019 07:06:53 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CKak5Mz1rkrT for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Feb 2019 07:06:52 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 39F7A4A1DF
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Feb 2019 07:06:52 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <ea9a0255-5829-883c-d28c-0c34716bbbdb@arm.com>
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

On Thu, Feb 21, 2019 at 01:36:26PM +0000, Julien Grall wrote:
> Hi Dave,
> 
> On 18/02/2019 19:52, Dave Martin wrote:
> >+	/*
> >+	 * Mismatches above sve_max_virtualisable_vl are fine, since
> >+	 * no guest is allowed to configure ZCR_EL2.LEN to exceed this:
> >+	 */
> >+	if (sve_vl_from_vq(bit_to_vq(b)) <= sve_max_virtualisable_vl) {
> >+		pr_warn("SVE: cpu%d: Unsupported vector length(s) present\n",
> >+			smp_processor_id());
> 
> Would it be worth to print the unsupported vector length?

Possibly not, but admittedly the intent is a bit unclear in this patch.

See my reply to Julien Thierry (and respond on that subthread if you
have comments, so that we don't end up with two subthreads discussing
the same thing...)

Thanks
---Dave
