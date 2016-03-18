From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v3 5/9] irqchip/gic-v3: Gather all ACPI specific data in
 a single structure
Date: Fri, 18 Mar 2016 10:42:06 +0100
Message-ID: <20160318094206.GD10806@cbox>
References: <1457436573-6180-1-git-send-email-julien.grall@arm.com>
 <1457436573-6180-6-git-send-email-julien.grall@arm.com>
 <20160309053930.GH26583@lvm>
 <56E7FF75.7060701@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <56E7FF75.7060701@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Julien Grall <julien.grall@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, fu.wei@linaro.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, wei@redhat.com, al.stone@linaro.org, Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Mar 15, 2016 at 12:26:29PM +0000, Julien Grall wrote:
> Hi Christoffer,
> 
> On 09/03/16 05:39, Christoffer Dall wrote:
> >On Tue, Mar 08, 2016 at 11:29:29AM +0000, Julien Grall wrote:
> >>Even though all the variables aren't marked with __initdata, they are
> >>only used during initialization. So the structure is marked with
> >>__initdata.
> >
> >Not sure I understand this commit message.
> >
> >As I see it, this commit includes two changes:
> >
> >1. Mark the variables only used during init with __initdata
> >
> >2. Move the variables into a structure
> >
> >If I get that right, can you argue for both changes?
> 
> What about:
> 
> "The ACPI code requires to use global variables in order to collect
> information from the tables.
> 
> To make clear those variables are ACPI specific, gather all of them
> in a single structure.
> 
> Furthermore, even if some of the variables are not marked with
> __initdata, they are all only used during the initialization.
> Therefore, the new variable, which hold the structure, can be marked
> __initdata."
> 
Looks ok (the part about some of the variables not marked with
__initdata is confusing but I think I understand what you mean).

Thanks,
-Christoffer
