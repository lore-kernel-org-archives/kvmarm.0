From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v4 00/28] arm/arm64: KVM: Rework the hyp-stub API
Date: Wed, 22 Mar 2017 16:20:29 +0000
Message-ID: <20170322162028.GD25645@e104818-lin.cambridge.arm.com>
References: <20170321192058.9300-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 833D740992
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Mar 2017 12:18:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UidNAv7ESoYm for <kvmarm@lists.cs.columbia.edu>;
 Wed, 22 Mar 2017 12:18:45 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B09A9408EB
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Mar 2017 12:18:45 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20170321192058.9300-1-marc.zyngier@arm.com>
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
Cc: Russell King <linux@arm.linux.org.uk>, kvm@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Keerthy <j-keerthy@ti.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Mar 21, 2017 at 07:20:30PM +0000, Marc Zyngier wrote:
> * From v3:
>   - Reworked the way we save/restore lr on arm64, making it EL2's job
>   in a consistent way (these are the three initial patches)

Thanks for fixing up the lr use. Feel free to upstream it via the kvm
tree. For the whole series:

Acked-by: Catalin Marinas <catalin.marinas@arm.com>

-- 
Catalin
