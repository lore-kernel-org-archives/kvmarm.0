From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH V3 3/4] KVM: arm/arm64: Remove KVM_PRIVATE_MEM_SLOTS
 definition that are unused
Date: Tue, 07 Mar 2017 14:58:54 +0000
Message-ID: <87efy9yvyp.fsf@on-the-bus.cambridge.arm.com>
References: <1488865964-17346-1-git-send-email-linucherian@gmail.com>
 <1488865964-17346-4-git-send-email-linucherian@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EE1DF40BE4
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Mar 2017 09:57:39 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sI3Ey6dmplUz for <kvmarm@lists.cs.columbia.edu>;
 Tue,  7 Mar 2017 09:57:39 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1839B40A6A
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Mar 2017 09:57:38 -0500 (EST)
In-Reply-To: <1488865964-17346-4-git-send-email-linucherian@gmail.com>
 (linucherian@gmail.com's message of "Tue, 7 Mar 2017 11:22:43 +0530")
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linucherian@gmail.com
Cc: Linu Cherian <linu.cherian@cavium.com>, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Mar 07 2017 at  5:52:43 am GMT, linucherian@gmail.com wrote:
> From: Linu Cherian <linu.cherian@cavium.com>
>
> Signed-off-by: Linu Cherian <linu.cherian@cavium.com>

Please add a decent commit message. Even if this is an obvious patch,
explain the rational behind it. Patch 1 has the same problem.

Thanks,

	M.
-- 
Jazz is not dead, it just smell funny.
