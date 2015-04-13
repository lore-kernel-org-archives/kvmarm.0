From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2] KVM: arm/arm64: avoid using kvm_run for in-kernel
 emulation
Date: Mon, 13 Apr 2015 11:57:34 +0200
Message-ID: <20150413095734.GH6186@cbox>
References: <1428677987-15494-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 683CE4C1D8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Apr 2015 05:49:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BjIuMzXzViEW for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Apr 2015 05:49:43 -0400 (EDT)
Received: from mail-lb0-f175.google.com (mail-lb0-f175.google.com
 [209.85.217.175])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2C0644C0F4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Apr 2015 05:49:42 -0400 (EDT)
Received: by lbbzk7 with SMTP id zk7so54509340lbb.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Apr 2015 02:57:28 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1428677987-15494-1-git-send-email-andre.przywara@arm.com>
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
Cc: marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Apr 10, 2015 at 03:59:47PM +0100, Andre Przywara wrote:
> Our in-kernel VGIC emulation still uses struct kvm_run briefly before
> writing back the emulation result into the guest register.
> Although this particular case looks safe from an exploitation
> perspective, we can save some unneeded copying at the end of the VGIC
> emulation code.
> Replace the usage of struct kvm_run in favour of passing separate
> parameters in io_mem_abort(). Since the write back is now handled
> for all kvm_io_bus users, we can get rid of it in the VGIC.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
