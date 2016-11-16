From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2] arm/arm64: KVM: VGIC: limit ITARGETSR bits to number
 of VCPUs
Date: Wed, 16 Nov 2016 20:54:10 +0100
Message-ID: <20161116195410.GH3811@cbox>
References: <20161116175716.31578-1-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 949DD401E8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Nov 2016 14:53:45 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GE2OTlo+Hnrr for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 Nov 2016 14:53:44 -0500 (EST)
Received: from mail-wm0-f51.google.com (mail-wm0-f51.google.com [74.125.82.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E4F69401E7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Nov 2016 14:53:43 -0500 (EST)
Received: by mail-wm0-f51.google.com with SMTP id g23so262796794wme.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Nov 2016 11:54:15 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20161116175716.31578-1-andre.przywara@arm.com>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Nov 16, 2016 at 05:57:16PM +0000, Andre Przywara wrote:
> The GICv2 spec says in section 4.3.12 that a "CPU targets field bit that
> corresponds to an unimplemented CPU interface is RAZ/WI."
> Currently we allow the guest to write any value in there and it can
> read that back.
> Mask the written value with the proper CPU mask to be spec compliant.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
