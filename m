From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH 04/12] arm64: Initialise high_memory global variable
 earlier
Date: Mon, 11 Dec 2017 12:00:22 +0000
Message-ID: <20171211120022.ujdc37dp3iawzrem@armageddon.cambridge.arm.com>
References: <20171204141313.31604-1-steve.capper@arm.com>
 <20171204141313.31604-5-steve.capper@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A2F5E49D69
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Dec 2017 06:57:06 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id T1qsIaxgN-TB for <kvmarm@lists.cs.columbia.edu>;
 Mon, 11 Dec 2017 06:57:00 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AC1F249D1F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Dec 2017 06:57:00 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20171204141313.31604-5-steve.capper@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Steve Capper <steve.capper@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, ard.biesheuvel@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Dec 04, 2017 at 02:13:05PM +0000, Steve Capper wrote:
> The high_memory global variable is used by
> cma_declare_contiguous(.) before it is defined.
> 
> We don't notice this as we compute __pa(high_memory - 1), and it looks
> like we're processing a VA from the direct linear map.
> 
> This problem becomes apparent when we flip the kernel virtual address
> space and the linear map is moved to the bottom of the kernel VA space.
> 
> This patch moves the initialisation of high_memory before it used.
> 
> Signed-off-by: Steve Capper <steve.capper@arm.com>

It looks like we've had this bug since 3.18 (f7426b983a6a, "mm: cma:
adjust address limit to avoid hitting low/high memory boundary"). It may
be worth adding a cc stable on this patch.

-- 
Catalin
