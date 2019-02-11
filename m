From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH v2 1/5] KVM: arm/arm64: rename
 kvm_pmu_{enable/disable}_counter functions
Date: Mon, 11 Feb 2019 17:23:20 +0000
Message-ID: <8de04bc8-4a1c-6430-f05f-10b2a55f16aa@arm.com>
References: <1549299218-44714-1-git-send-email-andrew.murray@arm.com>
 <1549299218-44714-2-git-send-email-andrew.murray@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2B5914A321
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Feb 2019 12:23:26 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RO50alHA56f3 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 11 Feb 2019 12:23:24 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DC8734A0CC
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Feb 2019 12:23:24 -0500 (EST)
In-Reply-To: <1549299218-44714-2-git-send-email-andrew.murray@arm.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: andrew.murray@arm.com, christoffer.dall@arm.com, marc.zyngier@arm.com
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu



On 04/02/2019 16:53, Andrew Murray wrote:
> The kvm_pmu_{enable/disable}_counter functions can enabled/disable
> multiple counters at once as they operate on a bitmask. Let's
> make this clearer by renaming the function.
> 
> Signed-off-by: Andrew Murray <andrew.murray@arm.com>

Suggested-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
