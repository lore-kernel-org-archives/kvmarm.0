From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH v4 00/26] KVM/ARM: Add support for GICv4
Date: Mon, 9 Oct 2017 13:52:39 -0400
Message-ID: <20171009175239.GE23730@char.us.oracle.com>
References: <20171006153401.5481-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BE73E49D19
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Oct 2017 13:52:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vXQcIvcVYaGp for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Oct 2017 13:52:19 -0400 (EDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D9EAF49C24
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Oct 2017 13:52:18 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20171006153401.5481-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Andre Przywara <Andre.Przywara@arm.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Oct 06, 2017 at 04:33:35PM +0100, Marc Zyngier wrote:
> This series implements full support for GICv4 in KVM, bringing direct
> injection of MSIs to arm and arm64, assuming you have the right
> hardware (which is quite unlikely).
> 
> To get an idea of the design, I'd recommend you start with commit
> 7954907bedaf as well as patch #26, which try to shed some light on the
> approach that I've taken. And before that, please digest some of the
> GICv3/GICv4 architecture documentation[1] (less than 800 pages!). Once
> you feel reasonably insane, you'll be in the right mood to read the

You may want to update the link:

s/pfd/pdf/

(Does that mean you typed this by hand, my gosh, you really are breathing
this everyday) :-)

> code (no, I didn't bother changing the above, I already hit LWN/QotW
> once).
