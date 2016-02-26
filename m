From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC v4 07/14] msi: Add a new MSI_FLAG_IRQ_REMAPPING flag
Date: Fri, 26 Feb 2016 19:06:08 +0100 (CET)
Message-ID: <alpine.DEB.2.11.1602261904500.3638@nanos>
References: <1456508154-2253-1-git-send-email-eric.auger@linaro.org>
 <1456508154-2253-8-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 66419411AA
 for <kvmarm@lists.cs.columbia.edu>; Fri, 26 Feb 2016 13:00:48 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8h3Z5P3Yb5FO for <kvmarm@lists.cs.columbia.edu>;
 Fri, 26 Feb 2016 13:00:47 -0500 (EST)
Received: from Galois.linutronix.de (www.linutronix.de [62.245.132.108])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 193C0410D7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 26 Feb 2016 13:00:46 -0500 (EST)
In-Reply-To: <1456508154-2253-8-git-send-email-eric.auger@linaro.org>
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
Cc: eric.auger@st.com, jason@lakedaemon.net, kvm@vger.kernel.org, patches@linaro.org, marc.zyngier@arm.com, joro@8bytes.org, will.deacon@arm.com, linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org, Manish.Jaggi@caviumnetworks.com, alex.williamson@redhat.com, linux-arm-kernel@lists.infradead.org, robin.murphy@arm.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, 26 Feb 2016, Eric Auger wrote:

> Let's introduce a new msi_domain_info flag value, MSI_FLAG_IRQ_REMAPPING
> meant to tell the domain supports IRQ REMAPPING, also known as Interrupt
> Translation Service. On Intel HW this capability is abstracted on IOMMU
> side while on ARM it is abstracted on MSI controller side.
> 
> GICv3 ITS HW is the first HW advertising that feature.

No. We add the flag, epxlain what it does and then in a second step add the
user _after_ all other preliminaries are implemented.
 
Thanks,

	tglx
