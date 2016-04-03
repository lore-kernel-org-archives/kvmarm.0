From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v4 02/12] KVM: arm/arm64: extend arch CAP checks to allow
 per-VM capabilities
Date: Sun, 3 Apr 2016 12:08:33 +0200
Message-ID: <20160403100833.GC5261@cbox>
References: <1458958450-19662-1-git-send-email-andre.przywara@arm.com>
 <1458958450-19662-3-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A870B40B40
 for <kvmarm@lists.cs.columbia.edu>; Sun,  3 Apr 2016 06:07:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JZCtv2yJaxIE for <kvmarm@lists.cs.columbia.edu>;
 Sun,  3 Apr 2016 06:07:15 -0400 (EDT)
Received: from mail-lb0-f175.google.com (mail-lb0-f175.google.com
 [209.85.217.175])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9633A400E9
 for <kvmarm@lists.cs.columbia.edu>; Sun,  3 Apr 2016 06:07:15 -0400 (EDT)
Received: by mail-lb0-f175.google.com with SMTP id u8so119881726lbk.0
 for <kvmarm@lists.cs.columbia.edu>; Sun, 03 Apr 2016 03:08:28 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1458958450-19662-3-git-send-email-andre.przywara@arm.com>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Sat, Mar 26, 2016 at 02:14:00AM +0000, Andre Przywara wrote:
> KVM capabilities can be a per-VM property, though ARM/ARM64 currently
> does not pass on the VM pointer to the architecture specific
> capability handlers.
> Add a "struct kvm*" parameter to those function to later allow proper
> per-VM capability reporting.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
