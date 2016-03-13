From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v3 3/9] irqchip/gic-v2: Gather ACPI specific data in a
 single structure
Date: Sun, 13 Mar 2016 19:19:54 +0100
Message-ID: <20160313181954.GC15988@cbox>
References: <1457436573-6180-1-git-send-email-julien.grall@arm.com>
 <1457436573-6180-4-git-send-email-julien.grall@arm.com>
 <20160309054710.GI26583@lvm> <56DFC026.5020909@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 82C0C412D0
 for <kvmarm@lists.cs.columbia.edu>; Sun, 13 Mar 2016 14:19:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id O-IvrN5pr4UC for <kvmarm@lists.cs.columbia.edu>;
 Sun, 13 Mar 2016 14:19:24 -0400 (EDT)
Received: from mail-wm0-f45.google.com (mail-wm0-f45.google.com [74.125.82.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 60CE140FA7
 for <kvmarm@lists.cs.columbia.edu>; Sun, 13 Mar 2016 14:19:24 -0400 (EDT)
Received: by mail-wm0-f45.google.com with SMTP id p65so75917251wmp.1
 for <kvmarm@lists.cs.columbia.edu>; Sun, 13 Mar 2016 11:19:40 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <56DFC026.5020909@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Julien Grall <julien.grall@arm.com>
Cc: al.stone@linaro.org, kvm@vger.kernel.org, marc.zyngier@arm.com, linux-kernel@vger.kernel.org, fu.wei@linaro.org, Thomas Gleixner <tglx@linutronix.de>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Jason Cooper <jason@lakedaemon.net>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Mar 09, 2016 at 01:18:14PM +0700, Julien Grall wrote:
> Hi Christoffer,
> 
> On 09/03/2016 12:47, Christoffer Dall wrote:
> >On Tue, Mar 08, 2016 at 11:29:27AM +0000, Julien Grall wrote:
> >>For now, there is only one member. More member will be added later.
> >
> >questionable commit message
> 
> What about:
> 
> "The ACPI code requires to use global variables in order to collect
> information from the tables.
> 
> For now only a single global variable is used, but more will be
> added in a subsequent patch. To make clear they are ACPI specific,
> gather all the information in a single structure."
> 

that's better.

> [...]
> 
> >>@@ -1316,7 +1319,7 @@ static int __init gic_v2_acpi_init(struct acpi_subtable_header *header,
> >>  		return -EINVAL;
> >>  	}
> >>
> >>-	cpu_base = ioremap(cpu_phy_base, ACPI_GIC_CPU_IF_MEM_SIZE);
> >>+	cpu_base = ioremap(acpi_data.cpu_phy_base, ACPI_GIC_CPU_IF_MEM_SIZE);
> >>  	if (!cpu_base) {
> >>  		pr_err("Unable to map GICC registers\n");
> >>  		return -ENOMEM;
> >>--
> >>1.9.1
> >>
> >super nit: I would use cpu_phys_base instead of cpu_phy_base, but I'll
> >leave it up to you.
> 
> I will update the commit message, so I will rename the variable too.
> 

Thanks,
-Christoffer
