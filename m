From: Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [PATCH 0/4] KVM: arm/arm64: Fix locking issues
Date: Tue, 15 May 2018 12:26:59 +0200
Message-ID: <20180515102659.GA38551@C02W217FHV2R.local>
References: <20180511142015.21953-1-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20180511142015.21953-1-andre.przywara@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Andre Przywara <andre.przywara@arm.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Eric Auger <eric.auger@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, May 11, 2018 at 03:20:11PM +0100, Andre Przywara wrote:
> Jan recently reported lockdep complaints regarding various locks in our
> VGIC emulation [1][2].
> This boiled down to two separate issues:
> - When promoting the vgic_irq->irq_lock to require IRQs being disabled,
>   we forgot to amend some instances of this lock on the way. Also this
>   needs to be applied to dependent locks as well. The first two patches
>   fix that. The patch split is designed to simplify backporting.
>   Those patches have been posted before, I am resending them as part
>   of this series.
> - Calling kvm_read_guest() requires us to be inside an SRCU critical
>   section. On some architectures we are always in it when handling VCPU
>   exits, but on ARM we need to lock it individually. Patches 3 and 4
>   fix that, the split is again made to ease backporting.
>   Each of the hunks fix an indiviual commit, but I refrained from
>   splitting this down into eight patches just to put proper Fixes: tags
>   on it. Eventually those commits are part of one out of two series, I put
>   the respective kernel release version as a tag to the Cc: stable line.
> 
> I couldn't reproduce the full lockdep splat on my setup, but at least
> could show one instance and prove that these patches fixes that.
> 
> 
For the series:

Acked-by: Christoffer Dall <christoffer.dall@arm.com>


Thanks for fixing this,
-Christoffer
