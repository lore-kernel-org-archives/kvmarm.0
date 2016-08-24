From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] arm64: KVM: Enable support for Cortex-A72
Date: Wed, 24 Aug 2016 10:23:00 +0100
Message-ID: <20160824102300.2b7f34e3@arm.com>
References: <1472023297-2756-1-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B21D412ED
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Aug 2016 05:15:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1IemWB4ZOql7 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 24 Aug 2016 05:15:21 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 720A340FA7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Aug 2016 05:15:20 -0400 (EDT)
In-Reply-To: <1472023297-2756-1-git-send-email-zhaoshenglong@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Shannon Zhao <zhaoshenglong@huawei.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, shannon.zhao@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, 24 Aug 2016 15:21:37 +0800
Shannon Zhao <zhaoshenglong@huawei.com> wrote:

Hi Shannon,

> In order to allow KVM to run on Cortex-A72 physical cpus, enable KVM
> support for Cortex-A72.
> 
> Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>

Why do we need any of this?

Since bca556ac468a ("arm64/kvm: Add generic v8 KVM target"), we support
any CPU that can run KVM without any change to the kernel, and I've
been running KVM on A72 for quite some time now (Juno r2, Armada 7040).

Am I missing something obvious?

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny.
