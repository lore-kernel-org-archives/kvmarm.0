From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v4 35/56] KVM: arm/arm64: vgic-new: Add GICv3
 redistributor IIDR and TYPER handler
Date: Wed, 18 May 2016 16:15:59 +0200
Message-ID: <20160518141559.GH6666@cbox>
References: <1463392481-26583-1-git-send-email-andre.przywara@arm.com>
 <1463392481-26583-36-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7226C4998D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 May 2016 10:11:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 849szM2tBvdb for <kvmarm@lists.cs.columbia.edu>;
 Wed, 18 May 2016 10:11:56 -0400 (EDT)
Received: from mail-wm0-f52.google.com (mail-wm0-f52.google.com [74.125.82.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9322449AFA
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 May 2016 10:11:56 -0400 (EDT)
Received: by mail-wm0-f52.google.com with SMTP id r12so37000811wme.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 May 2016 07:15:13 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1463392481-26583-36-git-send-email-andre.przywara@arm.com>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, May 16, 2016 at 10:53:23AM +0100, Andre Przywara wrote:
> The redistributor TYPER tells the OS about the associated MPIDR,
> also the LAST bit is crucial to determine the number of redistributors.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
