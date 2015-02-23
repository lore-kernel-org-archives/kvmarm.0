From: Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: stand-alone kvmtool
Date: Mon, 23 Feb 2015 12:14:37 +0000
Message-ID: <20150223121437.GO8656@n2100.arm.linux.org.uk>
References: <54DDD465.3050300@arm.com>
 <54E5C16D.3060109@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BE7E746481
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Feb 2015 07:09:16 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BtSLvrpQ2Egc for <kvmarm@lists.cs.columbia.edu>;
 Mon, 23 Feb 2015 07:09:15 -0500 (EST)
Received: from pandora.arm.linux.org.uk (pandora.arm.linux.org.uk
 [78.32.30.218])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 51BE24644B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Feb 2015 07:09:14 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <54E5C16D.3060109@oracle.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Marc Zyngier <Marc.Zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, Ronald Minnich <rminnich@google.com>, Will Deacon <will.deacon@arm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Pekka Enberg <penberg@kernel.org>, Asias He <asias.hejun@gmail.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Feb 19, 2015 at 05:56:45AM -0500, Sasha Levin wrote:
> What inconvenience is caused by having it sit inside the kernel tree
> beyond an increased requirement in disk space?

I've come across this problem with the perf tools - luckily, the perf
tools allow the source to be exported from the kernel tree, but it is
far from a good solution.

The problem is when you're primarily cross-building the kernel on a
system where you don't have the target libraries (because, eg, you're
running in a build environment for multiple different target systems.)
Having to build userspace tools in that scenario is a _major_ pita.

Yes, of course it's possible to pull the 1GB of kernel GIT respository
down onto the target just to build some silly userspace tool, but when
your rootfs lives on an 8GB SD card or a USB memory stick (as is the
case with the ARM Juno 64-bit platform), and when the userspace tool
somehow depends on the kernel source tree being configured, it really
starts getting painful.

TBH, I don't much care provided there is a way to export a source
tarball for the tool from the kernel (like perf does) which can then
be transferred to the target and built there.

-- 
FTTC broadband for 0.8mile line: currently at 10.5Mbps down 400kbps up
according to speedtest.net.
