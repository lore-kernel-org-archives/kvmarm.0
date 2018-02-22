From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v4 30/40] KVM: arm64: Defer saving/restoring 32-bit
 sysregs to vcpu load/put
Date: Thu, 22 Feb 2018 19:15:20 +0100
Message-ID: <20180222181520.GU29376@cbox>
References: <20180215210332.8648-1-christoffer.dall@linaro.org>
 <20180215210332.8648-31-christoffer.dall@linaro.org>
 <861shel34i.wl-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <861shel34i.wl-marc.zyngier@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org, Tomasz Nowicki <tn@semihalf.com>, kvmarm@lists.cs.columbia.edu, Julien Grall <julien.grall@arm.com>, Yury Norov <ynorov@caviumnetworks.com>, linux-arm-kernel@lists.infradead.org, Dave Martin <Dave.Martin@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Feb 21, 2018 at 04:27:25PM +0000, Marc Zyngier wrote:
> On Thu, 15 Feb 2018 21:03:22 +0000,
> Christoffer Dall wrote:
> > 
> > When running a 32-bit VM (EL1 in AArch32), the AArch32 system registers
> > can be deferred to vcpu load/put on VHE systems because neither
> > the host kernel nor host userspace uses these registers.
> > 
> > Note that we can not defer saving DBGVCR32_EL2 conditionally based
> > on the state of the debug dirty flag on VHE, but since we do the
> > load/put pretty rarely, this comes out as a win anyway.
> 
> I'm not sure I understand that comment. We don't have any deferring
> for this register, so the load/put reference seems out of place.
> 

Yeah, this is a patch description editing snafu.  I'll fix it.

Thanks,
-Christoffer
