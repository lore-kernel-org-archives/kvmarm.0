From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 0/8] arm/arm64: KVM: limit icache invalidation to
 prefetch aborts
Date: Sun, 22 Oct 2017 10:20:52 +0100
Message-ID: <86o9ozh72j.fsf@arm.com>
References: <20171020154904.31427-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2055A49D23
 for <kvmarm@lists.cs.columbia.edu>; Sun, 22 Oct 2017 05:19:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Ly45UCU9CgGV for <kvmarm@lists.cs.columbia.edu>;
 Sun, 22 Oct 2017 05:19:45 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C3CBB406BB
 for <kvmarm@lists.cs.columbia.edu>; Sun, 22 Oct 2017 05:19:45 -0400 (EDT)
In-Reply-To: <20171020154904.31427-1-marc.zyngier@arm.com> (Marc Zyngier's
 message of "Fri, 20 Oct 2017 16:48:56 +0100")
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Oct 20 2017 at  4:48:56 pm BST, Marc Zyngier <marc.zyngier@arm.com> wrote:

[...]

> * From v1:
[...]

>   - Dropped patch #10 which was both useless and broken, and patch #9
>     that thus became useless

Tuuut!!!!! patch #9[1] is not useless at all, as it allows patch #2 to
compile. I failed to notice it because I still had #9 in my tree as I
pushed things out. Duh.

I've pushed out a branch[2] with that patch as a prerequisite. Let me
know if I should repost the whole thing.

Sorry for the fsckup,

	M.

[1] https://patchwork.kernel.org/patch/9993695/
[2] https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=kvm-arm64/icache
-- 
Jazz is not dead. It just smells funny.
