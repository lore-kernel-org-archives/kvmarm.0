From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 2/3] arm64: kvm: reuse existing cache type/info related
 macros
Date: Wed, 1 Feb 2017 15:44:30 +0000
Message-ID: <d5d85965-8bee-3ba0-7a0c-a4727f5fe9f8@arm.com>
References: <1485793527-18028-1-git-send-email-sudeep.holla@arm.com>
 <1485793527-18028-2-git-send-email-sudeep.holla@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B8AD405DA
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Feb 2017 10:44:14 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5o6KPz88meWQ for <kvmarm@lists.cs.columbia.edu>;
 Wed,  1 Feb 2017 10:44:13 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3B49B40064
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Feb 2017 10:44:12 -0500 (EST)
In-Reply-To: <1485793527-18028-2-git-send-email-sudeep.holla@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Sudeep Holla <sudeep.holla@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 30/01/17 16:25, Sudeep Holla wrote:
> We already have various macros related to cache type and bitfields in
> CLIDR system register. We can replace some of the hardcoded values
> here using those existing macros.
> 
> This patch reuses those existing cache type/info related macros and
> replaces the hardcorded values. It also removes some of the comments
> that become trivial with the macro names.
> 
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: Christoffer Dall <christoffer.dall@linaro.org>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>

Acked-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...
