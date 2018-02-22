From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v4 17/40] KVM: arm64: Move userspace system registers
 into separate function
Date: Thu, 22 Feb 2018 10:18:09 +0100
Message-ID: <20180222091809.GG29376@cbox>
References: <20180215210332.8648-1-christoffer.dall@linaro.org>
 <20180215210332.8648-18-christoffer.dall@linaro.org>
 <411af987-97f8-03a4-60ce-6f271e042983@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <411af987-97f8-03a4-60ce-6f271e042983@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Julien Grall <julien.grall@arm.com>
Cc: Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Tomasz Nowicki <tn@semihalf.com>, Dave Martin <Dave.Martin@arm.com>, Yury Norov <ynorov@caviumnetworks.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, Shih-Wei Li <shihwei@cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Feb 19, 2018 at 05:21:17PM +0000, Julien Grall wrote:
> Hi Christoffer,
> 
> On 15/02/18 21:03, Christoffer Dall wrote:
> >There's a semantic difference between the EL1 registers that control
> >operation of a kernel running in EL1 and EL1 registers that only control
> >userspace execution in EL0.  Since we can defer saving/restoring the
> >latter, move them into their own function.
> >
> >ACTLR_EL1 is not used by a VHE host, so we can move this register into
> >the EL1 state which is not saved/restored for a VHE host.
> 
> Looking at D10.2.1 (ARM DDI 0487C.a), the statement regarding the use of
> ACTLR_EL1 seems to be less strong than what you state here. It looks like it
> would be possible to have hardware where ACTLR_EL1 would still have an
> effect on host EL0. I also read the comments on the version 2 of this patch
> but I wasn't able to find what I missing.
> 
As Marc points out, I'll add a reference to the spec that says that Arm
recommends ACTLR_EL1 not having an effect on VHE host EL0.  While
potentially possible, it's unlikely, and we can fix that later if anyone
builds a platform with VHE that we care about that uses ACTLR_EL1 for
VHE host EL0.

Thanks,
-Christoffer
