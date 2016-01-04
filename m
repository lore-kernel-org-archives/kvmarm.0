From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 1/2] arm: multi_v7_defconfig: Add virtio drivers
Date: Mon, 04 Jan 2016 16:11:12 +0100
Message-ID: <2934460.yQH6ldG89f@wuerfel>
References: <1451919034-12846-1-git-send-email-andre.przywara@arm.com>
 <1451919034-12846-2-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 29993497F8
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Jan 2016 10:07:54 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qbCZb6eL9Nrm for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Jan 2016 10:07:52 -0500 (EST)
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.134])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B3C34497BD
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Jan 2016 10:07:51 -0500 (EST)
In-Reply-To: <1451919034-12846-2-git-send-email-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org
Cc: Russell King <linux@arm.linux.org.uk>, alison.wang@freescale.com, marc.zyngier@arm.com, Andre Przywara <andre.przywara@arm.com>, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Monday 04 January 2016 14:50:33 Andre Przywara wrote:
> To make multi_v7_defconfig really "multi", let's add virtio drivers
> to allow booting a default kernel as a KVM/QEMU guest.
> MACH_VIRT is already defined, so we just add VIRTIO_BLK, VIRTIO_NET
> and VIRTIO_CONSOLE to actually make this kernel useful in a guest.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> 

This one looks good.

	Arnd
