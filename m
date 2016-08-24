From: Suzuki K Poulose <Suzuki.Poulose@arm.com>
Subject: Re: [PATCH] arm64: KVM: Enable support for Cortex-A72
Date: Wed, 24 Aug 2016 09:57:58 +0100
Message-ID: <ffda6889-5c31-1b56-942c-de65bbb1c16f@arm.com>
References: <1472023297-2756-1-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 186B1412ED
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Aug 2016 04:50:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LxgpsN45TDuu for <kvmarm@lists.cs.columbia.edu>;
 Wed, 24 Aug 2016 04:50:15 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0013C40FA7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Aug 2016 04:50:14 -0400 (EDT)
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
To: Shannon Zhao <zhaoshenglong@huawei.com>, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, christoffer.dall@linaro.org
Cc: shannon.zhao@linaro.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 24/08/16 08:21, Shannon Zhao wrote:
> In order to allow KVM to run on Cortex-A72 physical cpus, enable KVM
> support for Cortex-A72.

Do we really need this change ? Given that A72 is using the generic_v8 table,
it will automatically be supported via the GENERIC_V8 target. That was added
just for this purpose. The pre-existing targets were preserved so that
we don't break the ABI for older user space.

Suzuki
