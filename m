From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v3 08/11] KVM: arm/arm64: prepare GICv2 emulation to be
 handled by kvm_io_bus
Date: Thu, 26 Mar 2015 21:46:20 +0000
Message-ID: <20150326214620.35406305@arm.com>
References: <1427380778-942-1-git-send-email-andre.przywara@arm.com>
 <1427380778-942-9-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8C8AF49C1B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Mar 2015 17:39:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JzXibndxVoBK for <kvmarm@lists.cs.columbia.edu>;
 Thu, 26 Mar 2015 17:39:28 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7470249C19
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Mar 2015 17:39:27 -0400 (EDT)
In-Reply-To: <1427380778-942-9-git-send-email-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andre Przywara <andre.przywara@arm.com>
Cc: kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, 26 Mar 2015 14:39:35 +0000
Andre Przywara <andre.przywara@arm.com> wrote:

> Using the framework provided by the recent vgic.c changes we register
> a kvm_io_bus device when initializing the virtual GICv2.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny.
