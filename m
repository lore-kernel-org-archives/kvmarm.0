From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [RFC v3 10/10] KVM: arm/arm64: Emulate the EL1 phys timer
 registers
Date: Thu, 2 Feb 2017 11:31:08 +0100
Message-ID: <20170202103108.GI27852@cbox>
References: <1485970990-13775-1-git-send-email-jintack@cs.columbia.edu>
 <1485970990-13775-11-git-send-email-jintack@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 27B5940A4E
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Feb 2017 05:30:51 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id F5xohErP8Tyo for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Feb 2017 05:30:50 -0500 (EST)
Received: from mail-lf0-f41.google.com (mail-lf0-f41.google.com
 [209.85.215.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4C68040A3D
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Feb 2017 05:30:50 -0500 (EST)
Received: by mail-lf0-f41.google.com with SMTP id z134so6066908lff.3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 02 Feb 2017 02:31:13 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1485970990-13775-11-git-send-email-jintack@cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Jintack Lim <jintack@cs.columbia.edu>
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, linux@armlinux.org.uk, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, andre.przywara@arm.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Feb 01, 2017 at 12:43:10PM -0500, Jintack Lim wrote:
> Emulate read and write operations to CNTP_TVAL, CNTP_CVAL and CNTP_CTL.
> Now VMs are able to use the EL1 physical timer.
> 
> Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
