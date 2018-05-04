From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2] arm64: vgic-v2: Fix proxying of cpuif access
Date: Fri, 4 May 2018 16:43:27 +0100
Message-ID: <f8392800-2fe5-910c-bc27-a2478f0c5c42@arm.com>
References: <20180504151924.13696-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180504151924.13696-1-james.morse@arm.com>
Content-Language: en-GB
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: James Morse <james.morse@arm.com>, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Christoffer Dall <christoffer.dall@arm.com>, linux-arm-kernel@lists.infradead.org, Suzuki K Poulose <suzuki.poulose@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 04/05/18 16:19, James Morse wrote:
> Proxying the cpuif accesses at EL2 makes use of vcpu_data_guest_to_host
> and co, which check the endianness, which call into vcpu_read_sys_reg...
> which isn't mapped at EL2 (it was inlined before, and got moved OoL
> with the VHE optimizations).
> 
> The result is of course a nice panic. Let's add some specialized
> cruft to keep the broken platforms that require this hack alive.
> 
> But, this code used vcpu_data_guest_to_host(), which expected us to
> write the value to host memory, instead we have trapped the guest's
> read or write to an mmio-device, and are about to replay it using the
> host's readl()/writel() which also perform swabbing based on the host
> endianness. This goes wrong when both host and guest are big-endian,
> as readl()/writel() will undo the guest's swabbing, causing the
> big-endian value to be written to device-memory.
> 
> What needs doing?
> A big-endian guest will have pre-swabbed data before storing, undo this.
> If its necessary for the host, writel() will re-swab it.
> 
> For a read a big-endian guest expects to swab the data after the load.
> The hosts's readl() will correct for host endianness, giving us the
> device-memory's value in the register. For a big-endian guest, swab it
> as if we'd only done the load.
> 
> For a little-endian guest, nothing needs doing as readl()/writel() leave
> the correct device-memory value in registers.
> 
> Tested on Juno with that rarest of things: a big-endian 64K host.

<song>
The Thing That Should Not Be
</song>

> Based on a patch from Marc Zyngier.
> 
> Reported-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Fixes: bf8feb39642b ("arm64: KVM: vgic-v2: Add GICV access from HYP")
> CC: Marc Zyngier <marc.zyngier@arm.com>
> Signed-off-by: James Morse <james.morse@arm.com>

Awesome, thanks a lot for picking this up and fixing it the right way!

I'll queue it right away.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
