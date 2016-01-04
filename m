From: Andrew Jones <drjones@redhat.com>
Subject: Re: kvmarm tags kvm-arm-for-4.2, 4.3, and v4.4-rc6 does not boot on
 Mustang
Date: Mon, 4 Jan 2016 15:31:56 +0100
Message-ID: <20160104143156.GB6731@hawk.localdomain>
References: <567918E6.8020001@riken.jp> <20151222144135.GB5631@cbox>
 <567D1F65.5040008@riken.jp> <20151227143303.GA8044@cbox>
 <5680671D.5070408@riken.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1A837497F4
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Jan 2016 09:28:31 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wIOPPrVfSN4p for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Jan 2016 09:28:29 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 821E2497BD
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Jan 2016 09:28:29 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <5680671D.5070408@riken.jp>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Itaru Kitayama <itaru.kitayama@riken.jp>
Cc: kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Dec 28, 2015 at 07:33:01AM +0900, Itaru Kitayama wrote:
> Does your Mustang boot via UEFI? Mine does. Mainline v4.4-rc6ish
> seems to have an issue with libstub.

FWIW, 4.4.0-0.rc6.git1.1.fc24.aarch64 boots fine for me (with f23 userspace)
My firmware is a pretty old build though

TianoCore 1.1.0 UEFI 2.4.0 Apr 22 2015 11:30:25
CPU: APM ARM 64-bit Potenza Rev A3 2400MHz PCP 2400MHz
     32 KB ICACHE, 32 KB DCACHE
     SOC 2000MHz IOBAXI 400MHz AXI 250MHz AHB 200MHz GFC 125MHz
Board: X-Gene Mustang Board
Slimpro FW:
        Ver: 2.1

Thanks,
drew

> 
> On 12/27/15 11:33 PM, Christoffer Dall wrote:
> >On Fri, Dec 25, 2015 at 07:50:13PM +0900, Itaru Kitayama wrote:
> >>Hi Christoffer,
> >>After some investigations, it seems newer kernels does not boot on the
> >>Mustang board which I have access (in the Linaro Server Lab).
> >>
> >>I am using the Fedora 23 userland, 4.2.x Fedora kernels do boot, but
> >>4.4.x Fedora kernels do not (they are downloaded from the Koji site or
> >>own-built ones using fedpkg). I am not sure at this moment, the F/W
> >>is too old or not.
> >>
> >I don't know anything about distro kernels, I only follow mainline and
> >just booted mainline just fine on my mustang.
> >
> >-Christoffer
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
