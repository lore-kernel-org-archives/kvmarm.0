From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v6] KVM: arm/arm64: Add VGICv3 save/restore API
 documentation
Date: Wed, 27 Jul 2016 07:33:31 +0100
Message-ID: <20160727073331.4d0e1018@why.wild-wind.fr.eu.org>
References: <20160726112103.27799-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1E07649B93
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Jul 2016 02:27:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mCh9pHy4fuEd for <kvmarm@lists.cs.columbia.edu>;
 Wed, 27 Jul 2016 02:27:07 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CF45F49B8C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Jul 2016 02:27:07 -0400 (EDT)
In-Reply-To: <20160726112103.27799-1-christoffer.dall@linaro.org>
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
Cc: kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, 26 Jul 2016 13:21:03 +0200
Christoffer Dall <christoffer.dall@linaro.org> wrote:

> Factor out the GICv3 and ITS-specific documentation into a separate
> documentation file.  Add description for how to access distributor,
> redistributor, and CPU interface registers for GICv3 in this new file,
> and add a group for accessing level triggered IRQ information for GICv3
> as well.
> 
> Reviewed-by: Peter Maydell <peter.maydell@linaro.org>
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Without deviation from the norm, progress is not possible.
