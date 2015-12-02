From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] KVM: arm/arm64: vgic: make vgic_io_ops static
Date: Wed, 2 Dec 2015 19:04:46 +0100
Message-ID: <20151202180446.GP18376@cbox>
References: <1447329554-1500-1-git-send-email-jszhang@marvell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 43B7A4979C
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Dec 2015 13:02:46 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VkyEbg4Jo0S8 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Dec 2015 13:02:45 -0500 (EST)
Received: from mail-wm0-f52.google.com (mail-wm0-f52.google.com [74.125.82.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4AFD249630
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Dec 2015 13:02:45 -0500 (EST)
Received: by wmuu63 with SMTP id u63so225971199wmu.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 02 Dec 2015 10:04:13 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1447329554-1500-1-git-send-email-jszhang@marvell.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Jisheng Zhang <jszhang@marvell.com>
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, linux-kernel@vger.kernel.org, gleb@kernel.org, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Nov 12, 2015 at 07:59:14PM +0800, Jisheng Zhang wrote:
> vgic_io_ops is only referenced within vgic.c, so it can be declared
> static.
> 
> Signed-off-by: Jisheng Zhang <jszhang@marvell.com>

Applied to queue,
-Christoffer
