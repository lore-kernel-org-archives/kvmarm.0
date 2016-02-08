From: Edward Cragg <edward.cragg@codethink.co.uk>
Subject: Re: PCIe passthrough support on ARM
Date: Mon, 8 Feb 2016 17:01:58 +0000
Message-ID: <20160208170158.GD31029@codethink.co.uk>
References: <20160204165355.GA10442@codethink.co.uk>
 <56B38ABA.3090403@linaro.org>
 <20160208111354.GB31029@codethink.co.uk>
 <56B89082.5010804@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7292A4998E
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Feb 2016 11:56:21 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BgAiW1wi0HsT for <kvmarm@lists.cs.columbia.edu>;
 Mon,  8 Feb 2016 11:56:20 -0500 (EST)
Received: from ducie-dc1.codethink.co.uk (ducie-dc1.codethink.co.uk
 [185.25.241.215])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6162D4995C
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Feb 2016 11:56:19 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <56B89082.5010804@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Eric Auger <eric.auger@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Feb 08, 2016 at 01:56:34PM +0100, Eric Auger wrote:
> > Do you mean the GIC itself? From registers, it appears to be a standard ARM
> > GIC, though i'm not sure exactly which one yet. However, it's stated in the
> > processor's datasheet that legacy interrupts aren't supported. It's one of the
> > newer Samsung Exynos processors.
> I meant GICv2m (featuring single or multiple MSI frames) or GICv3 ITS or
> any other proprietary interrupt controller IP supporting MSIs.

>From the manual, it seems from the reset values for the identification
registers that it is most likely a GICv2.

If we continue with this project, and once we get access to hardware, we'd be
very interested in helping you with testing this.

Thanks,

Ed
