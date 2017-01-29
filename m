From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [RFC v2 01/10] KVM: arm/arm64: Abstract virtual timer context
 into separate structure
Date: Sun, 29 Jan 2017 11:44:12 +0000
Message-ID: <86bmuq9jlf.fsf@arm.com>
References: <1485479100-4966-1-git-send-email-jintack@cs.columbia.edu>
 <1485479100-4966-2-git-send-email-jintack@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E6A3F40194
 for <kvmarm@lists.cs.columbia.edu>; Sun, 29 Jan 2017 06:44:08 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1hlGD1OQtP61 for <kvmarm@lists.cs.columbia.edu>;
 Sun, 29 Jan 2017 06:44:07 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9CEE440187
 for <kvmarm@lists.cs.columbia.edu>; Sun, 29 Jan 2017 06:44:07 -0500 (EST)
In-Reply-To: <1485479100-4966-2-git-send-email-jintack@cs.columbia.edu>
 (Jintack Lim's message of "Thu, 26 Jan 2017 20:04:51 -0500")
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Jintack Lim <jintack@cs.columbia.edu>
Cc: kvm@vger.kernel.org, catalin.marinas@arm.com, will.deacon@arm.com, linux@armlinux.org.uk, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, andre.przywara@arm.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Jan 27 2017 at 01:04:51 AM, Jintack Lim <jintack@cs.columbia.edu> wrote:
> Abstract virtual timer context into a separate structure and change all
> callers referring to timer registers, irq state and so on. No change in
> functionality.
>
> This is about to become very handy when adding the EL1 physical timer.
>
> Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
> Acked-by: Christoffer Dall <christoffer.dall@linaro.org>

Acked-by: Marc Zyngier <marc.zyngier@arm.com>

          M.
-- 
Jazz is not dead. It just smells funny.
