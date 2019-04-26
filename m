From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH kvmtool 00/16] Support PCI BAR configuration
Date: Fri, 26 Apr 2019 15:09:31 +0100
Message-ID: <20190426140931.GC32062@fuggles.cambridge.arm.com>
References: <1551947777-13044-1-git-send-email-julien.thierry@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2ED534A332
 for <kvmarm@lists.cs.columbia.edu>; Fri, 26 Apr 2019 10:09:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id L8hAxIUI9V82 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 26 Apr 2019 10:09:36 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 002894A32E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 26 Apr 2019 10:09:35 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <1551947777-13044-1-git-send-email-julien.thierry@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Julien Thierry <julien.thierry@arm.com>
Cc: Andre.Przywara@arm.com, Sami.Mujawar@arm.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Mar 07, 2019 at 08:36:01AM +0000, Julien Thierry wrote:
> This series add support for guests writting to PCI BARs. Edk2 does this
> and is not aware of the "linux,pci-probe-only" property in the chosen node.
> 
> - Patches 1 to 3 do miscelaneous fixes

I've picked up these three fixes, but it looks like there are some
outstanding comments from Andre on some of the later patches.

Will
