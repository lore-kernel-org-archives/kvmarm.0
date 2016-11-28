From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v9 0/11] arm/arm64: vgic: Implement API for vGICv3 live
 migration
Date: Mon, 28 Nov 2016 20:51:36 +0100
Message-ID: <20161128195136.GI18170@cbox>
References: <1479906118-15832-1-git-send-email-vijay.kilari@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4548B40664
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Nov 2016 14:50:54 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4txRCplQbjWt for <kvmarm@lists.cs.columbia.edu>;
 Mon, 28 Nov 2016 14:50:53 -0500 (EST)
Received: from mail-lf0-f45.google.com (mail-lf0-f45.google.com
 [209.85.215.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1119F405C4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Nov 2016 14:50:52 -0500 (EST)
Received: by mail-lf0-f45.google.com with SMTP id b14so104885923lfg.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Nov 2016 11:51:40 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1479906118-15832-1-git-send-email-vijay.kilari@gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: vijay.kilari@gmail.com
Cc: marc.zyngier@arm.com, Vijaya Kumar K <Vijaya.Kumar@cavium.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Vijaya,

On Wed, Nov 23, 2016 at 06:31:47PM +0530, vijay.kilari@gmail.com wrote:
> From: Vijaya Kumar K <Vijaya.Kumar@cavium.com>
> 
> This patchset adds API for saving and restoring
> of VGICv3 registers to support live migration with new vgic feature.
> This API definition is as per version of VGICv3 specification
> Documentation/virtual/kvm/devices/arm-vgic-v3.txt
> 
> The patch 3 & 4 are picked from the Pavel's previous implementation.
> http://www.spinics.net/lists/kvm/msg122040.html
> 
> NOTE: Only compilation tested for AArch32. No hardware to test.

I did not review the 32-bit part, because if you cannot test it, I don't
think we should merge it.

I just want clarity on what happens if someone tries to use this on
32-bit, and I want to make sure it fails gracefully.

Thanks,
-Christoffer
