From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v2 0/4] Various convenience fixes
Date: Fri, 8 Feb 2019 16:16:34 +0000
Message-ID: <20190208161633.GA12481@brain-police>
References: <20190201123716.92901-1-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 27EE84A3FC
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Feb 2019 11:16:42 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eVo1mUjkwbhA for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Feb 2019 11:16:41 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 022734A3C4
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Feb 2019 11:16:40 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20190201123716.92901-1-andre.przywara@arm.com>
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
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Feb 01, 2019 at 12:37:12PM +0000, Andre Przywara wrote:
> As I found myself using kvmtool more often in the last weeks, I got more
> and more annoyed by some smaller "ticks" that kvmtool shows.
> 
> So this is an attempt to post various smaller fixes I gathered up over
> the years, but never found worth enough to send out.
> Version 2 drops the two patches that have been merged already, and
> amends the remaining ones.
> 
> The patches address:
> - add /chosen/stdout-path node in .dtb
> - honour make -s switch
> - remove pointless kvmtool version number
> - introduce autodetection of supported GIC type
> 
> Changelog v1..v2:
> - stdout-path: Let hw/serial.c set the node path and use an alias
> - make -s: adapt to newest version from the Linux kernel
> - kvmtool "version" number: unchanged, but verified to be compatible
>   with the Debian package
> - GIC autodetection: ignore --force-pci, always try to have an MSI
>   controller
> 
> Please have a look!
> 
> Cheers,
> Andre.
> 
> Andre Przywara (4):
>   arm: fdt: add stdout-path to /chosen node
>   Makefile: support -s switch
>   Makefile: Remove echoing of kvmtools version file

I've applied these three, and left a comment on the other one.

Will
