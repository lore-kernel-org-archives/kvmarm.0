From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v3 07/11] KVM: arm/arm64: implement kvm_io_bus MMIO
 handling for the VGIC
Date: Fri, 27 Mar 2015 17:00:54 +0100
Message-ID: <20150327160054.GC5121@cbox>
References: <1427380778-942-1-git-send-email-andre.przywara@arm.com>
 <1427380778-942-8-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 53B394A163
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Mar 2015 11:53:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uCAadujZuDXi for <kvmarm@lists.cs.columbia.edu>;
 Fri, 27 Mar 2015 11:53:10 -0400 (EDT)
Received: from mail-la0-f41.google.com (mail-la0-f41.google.com
 [209.85.215.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3B33C4A0FF
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Mar 2015 11:53:10 -0400 (EDT)
Received: by lagg8 with SMTP id g8so73872513lag.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Mar 2015 09:00:12 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1427380778-942-8-git-send-email-andre.przywara@arm.com>
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
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, Marcelo Tosatti <mtosatti@redhat.com>, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Mar 26, 2015 at 02:39:34PM +0000, Andre Przywara wrote:
> Currently we use a lot of VGIC specific code to do the MMIO
> dispatching.
> Use the previous reworks to add kvm_io_bus style MMIO handlers.
> 
> Those are not yet called by the MMIO abort handler, also the actual
> VGIC emulator function do not make use of it yet, but will be enabled
> with the following patches.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
