From: Christopher Covington <cov@codeaurora.org>
Subject: Re: [PATCH v4 05/21] KVM: ARM64: Add reset and access
 handlers for PMSELR register
Date: Mon, 02 Nov 2015 15:06:24 -0500
Message-ID: <5637C240.8090803@codeaurora.org>
References: <1446186123-11548-1-git-send-email-zhaoshenglong@huawei.com>
 <1446186123-11548-6-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2841349080
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Nov 2015 15:03:23 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WedURn9KGjdZ for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 Nov 2015 15:03:21 -0500 (EST)
Received: from smtp.codeaurora.org (smtp.codeaurora.org [198.145.29.96])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BDC8249078
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Nov 2015 15:03:21 -0500 (EST)
In-Reply-To: <1446186123-11548-6-git-send-email-zhaoshenglong@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Shannon Zhao <zhaoshenglong@huawei.com>, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, will.deacon@arm.com, linux-arm-kernel@lists.infradead.org, shannon.zhao@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

On 10/30/2015 02:21 AM, Shannon Zhao wrote:
> From: Shannon Zhao <shannon.zhao@linaro.org>
> 
> Since the reset value of PMSELR_EL0 is UNKNOWN, use reset_unknown for
> its reset handler. As it doesn't need to deal with the acsessing action

Nit: accessing

> specially, it uses default case to emulate writing and reading PMSELR
> register.
> 
> Add a helper for CP15 registers reset to UNKNOWN.
> 
> Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>

-- 
Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
