From: Shanker Donthineni <shankerd@codeaurora.org>
Subject: Re: [PATCH v6 08/10] KVM: arm/arm64: arch_timer: Rely on the arch
 timer to parse the firmware tables
Date: Sat, 23 Apr 2016 22:06:44 -0500
Message-ID: <571C3844.7090103@codeaurora.org>
References: <1460388780-914-1-git-send-email-julien.grall@arm.com>
 <1460388780-914-9-git-send-email-julien.grall@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 80F8749B51
 for <kvmarm@lists.cs.columbia.edu>; Sat, 23 Apr 2016 23:04:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tGPPKT-f1v-R for <kvmarm@lists.cs.columbia.edu>;
 Sat, 23 Apr 2016 23:04:38 -0400 (EDT)
Received: from smtp.codeaurora.org (smtp.codeaurora.org [198.145.29.96])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D8DCD49B4C
 for <kvmarm@lists.cs.columbia.edu>; Sat, 23 Apr 2016 23:04:38 -0400 (EDT)
In-Reply-To: <1460388780-914-9-git-send-email-julien.grall@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Julien Grall <julien.grall@arm.com>, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, al.stone@linaro.org, marc.zyngier@arm.com, linux-kernel@vger.kernel.org, gg@slimlogic.co.uk, Gleb Natapov <gleb@kernel.org>, hanjun.guo@linaro.org, fu.wei@linaro.org, Paolo Bonzini <pbonzini@redhat.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu



On 04/11/2016 10:32 AM, Julien Grall wrote:
> The firmware table is currently parsed by the virtual timer code in
> order to retrieve the virtual timer interrupt. However, this is already
> done by the arch timer driver.
>
> To avoid code duplication, use the newly function
> arch_timer_get_kvm_info()
> which return all the information required by the virtual timer code.
>
> Signed-off-by: Julien Grall <julien.grall@arm.com>
> Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
>
Tested-by: Shanker Donthineni <shankerd@codeaurora.org>

Using the Qualcomm Technologies QDF2XXX server platform.

-- 
Shanker Donthineni
Qualcomm Technologies, Inc. on behalf of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project
