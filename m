From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: Re: [PATCH v4 05/21] KVM: ARM64: Add reset and access handlers for
 PMSELR register
Date: Tue, 1 Dec 2015 09:51:43 +0800
Message-ID: <565CFD2F.8010902@huawei.com>
References: <1446186123-11548-1-git-send-email-zhaoshenglong@huawei.com>	<1446186123-11548-6-git-send-email-zhaoshenglong@huawei.com>
 <20151130175600.0ce835cd@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4F56F497BE
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Nov 2015 20:54:55 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NpBBlXObveD5 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 30 Nov 2015 20:54:53 -0500 (EST)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [58.251.152.64])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 52199497BD
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Nov 2015 20:54:52 -0500 (EST)
In-Reply-To: <20151130175600.0ce835cd@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvm@vger.kernel.org, shannon.zhao@linaro.org, will.deacon@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,

On 2015/12/1 1:56, Marc Zyngier wrote:
> Same remark here as the one I made earlier. I'm pretty sure we don't
> call any CP15 reset because they are all shared with their 64bit
> counterparts. The same thing goes for the whole series.
Ok, I see. But within the 64bit reset function, it needs to update the
32bit register value, right? Since when accessing these 32bit registers,
it uses the offset c9_PMXXXX.

Thanks,
-- 
Shannon
