From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH kvmtool 0/6] Various convenience fixes
Date: Wed, 30 Jan 2019 18:20:54 +0000
Message-ID: <20190130182054.GJ18558@fuggles.cambridge.arm.com>
References: <20190125180801.209910-1-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A4F34A3C0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Jan 2019 13:20:59 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sTGkgJOKUT7v for <kvmarm@lists.cs.columbia.edu>;
 Wed, 30 Jan 2019 13:20:58 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2809E4A394
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Jan 2019 13:20:58 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20190125180801.209910-1-andre.przywara@arm.com>
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

On Fri, Jan 25, 2019 at 06:07:55PM +0000, Andre Przywara wrote:
> As I found myself using kvmtool more often in the last weeks, I got more
> and more annoyed by some smaller "ticks" that kvmtool shows.
> 
> So this is an attempt to post various smaller fixes I gathered up over
> the years, but never found worth enough to send out:
> 
> - drop unnecessarily detailed debug output
> - add /chosen/stdout-path node in .dtb
> - honour make -s switch
> - remove pointless kvmtool version number
> - improve meaningless PMU error message
> - introduce autodetection of supported GIC type

I've applied (1) and (5), leaving comments on the others.

Cheers,

Will
