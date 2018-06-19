From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v6 kvmtool 00/13] Add vfio-pci support
Date: Tue, 19 Jun 2018 13:19:21 +0100
Message-ID: <20180619121920.GG13984@arm.com>
References: <20180618184211.43904-1-jean-philippe.brucker@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6035940458
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Jun 2018 08:07:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fAhx9kG9ze0T for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 Jun 2018 08:06:57 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 48245402AA
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Jun 2018 08:06:57 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20180618184211.43904-1-jean-philippe.brucker@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Cc: lorenzo.pieralisi@arm.com, kvm@vger.kernel.org, marc.zyngier@arm.com, punit.agrawal@arm.com, alex.williamson@redhat.com, robin.murphy@arm.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Jun 18, 2018 at 07:41:58PM +0100, Jean-Philippe Brucker wrote:
> This is version six of the VFIO support in kvmtool. It addresses
> Will's comments for v5.
> 
> Implement vfio-pci support in kvmtool. Devices are assigned to the guest
> by passing "--vfio-pci [domain:]bus:dev.fn" to lkvm run, after having
> bound the device to the VFIO driver (see Documentation/vfio.txt)
> 
> This time around I also tested assignment of the x540 NIC on my old x86
> desktop as well (previously only on AMD Seattle, an arm64 host). It
> worked smoothly.

Thanks. Applied and pushed out.

Will
