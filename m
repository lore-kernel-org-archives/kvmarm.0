From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 2/2] arm: configs: add kvm_defconfig
Date: Mon, 04 Jan 2016 16:15:32 +0100
Message-ID: <4522790.HLBFMYIalT@wuerfel>
References: <1451919034-12846-1-git-send-email-andre.przywara@arm.com>
 <1451919034-12846-3-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8304F497F8
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Jan 2016 10:12:20 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SDlM2VUaN9RU for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Jan 2016 10:12:19 -0500 (EST)
Received: from mout.kundenserver.de (mout.kundenserver.de [217.72.192.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8CDD0497BD
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Jan 2016 10:12:19 -0500 (EST)
In-Reply-To: <1451919034-12846-3-git-send-email-andre.przywara@arm.com>
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

On Monday 04 January 2016 14:50:34 Andre Przywara wrote:
> This new config enables KVM (and thus LPAE) on top of
> multi_v7_defconfig. This creates a kernel that can _host_ KVM guests,
> for guests a multi_v7_defconfig with virtio drivers is sufficient.
> Since LPAE kernels are not compatible with non-LPAE capable hardware,
> this has to be separate from the existing multi_v7_defconfig.
> 
> The purpose of this new defconfig is both to simplify creation of KVM
> host kernels as well as to give the LPAE option some better testing
> coverage, as the enlarged dma_addr_t and phys_addr_t types create some
> headache to some drivers.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> 

I agree about the purpose, but I want something better here:

* Use config fragments to just set the few extra options that
  we can't enable otherwise, and have a shared config file
  with the normal multi_v7. There is still an ongoing question
  about big-endian defconfig, which has exactly the same problem,
  and we should have a common approach for all combinations.

  We might also want to do this in a way that lets us build
  v6/v6k/v7/v7ve/v8 kernels in big-endian and little-endian
  all from the same defconfig file, with the set of platforms
  getting smaller as we go to higher arch levels.

* I really want to see the ARMv7VE dependencies sorted out.

	Arnd
