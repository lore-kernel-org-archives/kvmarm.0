From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v4 35/40] KVM: arm/arm64: Get rid of vgic_elrsr
Date: Fri, 23 Feb 2018 18:50:16 +0100
Message-ID: <20180223175016.GD7396@cbox>
References: <20180215210332.8648-1-christoffer.dall@linaro.org>
 <20180215210332.8648-36-christoffer.dall@linaro.org>
 <b15dda97-a860-0ed5-79d0-4c011f7e3b84@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <b15dda97-a860-0ed5-79d0-4c011f7e3b84@arm.com>
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

On Fri, Feb 23, 2018 at 02:44:30PM +0000, Julien Grall wrote:
> Hi Christoffer,
> 
> On 15/02/18 21:03, Christoffer Dall wrote:
> >There is really no need to store the vgic_elrsr on the VGIC data
> >structures as the only need we have for the elrsr is to figure out if an
> >LR is inactive when we save the VGIC state upon returning from the
> >guest.  We can might as well store this in a temporary local variable.
> >
> >This also gets rid of the endianness conversion in the VGIC save
> >function, which is completely unnecessary and would actually result in
> >incorrect functionality on big-endian systems, because we are only using
> >typed values here and not converting pointers and reading different
> >types here.
> 
> I can't find any endianness code removed in this code. What did I miss?
> 

Ah, good find, we ended up fixing this in a separate commit:

fc396e066318, "KVM: arm/arm64: Fix broken GICH_ELRSR big endian conversion", 2017-12-03

I'll adjust the commit message.

Thanks,
-Christoffer
