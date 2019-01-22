From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH 1/4] KVM: arm/arm64: extract duplicated code to own
 function
Date: Tue, 22 Jan 2019 14:20:19 +0000
Message-ID: <7206aebe-0c12-70a5-4a83-0fa0c0b3fcd7@arm.com>
References: <1548154197-5470-1-git-send-email-andrew.murray@arm.com>
 <1548154197-5470-2-git-send-email-andrew.murray@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7E1004A3BE
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Jan 2019 09:18:32 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id U85Se1m656hT for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Jan 2019 09:18:31 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3F6384A382
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Jan 2019 09:18:31 -0500 (EST)
In-Reply-To: <1548154197-5470-2-git-send-email-andrew.murray@arm.com>
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

On 01/22/2019 10:49 AM, Andrew Murray wrote:
> Let's reduce code duplication by extracting common code to its own
> function.
> 
> Signed-off-by: Andrew Murray <andrew.murray@arm.com>
> ---

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
