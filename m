From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v3 10/11] KVM: arm/arm64: prepare GICv3 emulation to use
 kvm_io_bus MMIO handling
Date: Fri, 27 Mar 2015 17:01:17 +0100
Message-ID: <20150327160117.GF5121@cbox>
References: <1427380778-942-1-git-send-email-andre.przywara@arm.com>
 <1427380778-942-11-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 71C0B4A187
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Mar 2015 11:53:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0slXotookG5K for <kvmarm@lists.cs.columbia.edu>;
 Fri, 27 Mar 2015 11:53:33 -0400 (EDT)
Received: from mail-la0-f42.google.com (mail-la0-f42.google.com
 [209.85.215.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9694B4A190
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Mar 2015 11:53:33 -0400 (EDT)
Received: by lahp7 with SMTP id p7so54938697lah.2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Mar 2015 09:00:35 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1427380778-942-11-git-send-email-andre.przywara@arm.com>
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

On Thu, Mar 26, 2015 at 02:39:37PM +0000, Andre Przywara wrote:
> Using the framework provided by the recent vgic.c changes, we
> register a kvm_io_bus device on mapping the virtual GICv3 resources.
> The distributor mapping is pretty straight forward, but the
> redistributors need some more love, since they need to be tagged with
> the respective redistributor (read: VCPU) they are connected with.
> We use the kvm_io_bus framework to register one devices per VCPU.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
