From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v6 10/15] KVM: arm64: connect LPIs to the VGIC emulation
Date: Wed, 22 Jun 2016 18:02:55 +0100
Message-ID: <576AC4BF.2070900@arm.com>
References: <1466165327-32060-1-git-send-email-andre.przywara@arm.com>
 <1466165327-32060-11-git-send-email-andre.przywara@arm.com>
 <576ABC50.6000201@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <576ABC50.6000201@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Andre Przywara <andre.przywara@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Eric Auger <eric.auger@redhat.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 22/06/16 17:26, Marc Zyngier wrote:
> On 17/06/16 13:08, Andre Przywara wrote:
>> LPIs are dynamically created (mapped) at guest runtime and their
>> actual number can be quite high, but is mostly assigned using a very
>> sparse allocation scheme. So arrays are not an ideal data structure
>> to hold the information.
>> We use an RCU protected list to hold all mapped LPIs. vgic_its_get_lpi()
>> iterates the list using RCU list primitives, so it's safe to be called
>> from an non-preemptible context like the KVM exit/entry path.
>> Also we store a pointer to that struct vgic_irq in our struct its_itte,
>> so we can easily access it.
>> Eventually we call our new vgic_its_get_lpi() from vgic_get_irq(), so
>> the VGIC code gets transparently access to LPIs.
>>
>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> 
> I'm skipping the review of this particular patch until you've switched
> to the kref API.

As an added comment, and having gone through this and the following
patches, I cannot see what having an RCU list brings us if we're also
using refcounting. Taking a spinlock on the read side feels very dodgy
(what guarantees that we can make forward progress without messing with
the grace period?), and I feel that we need to keep things relatively
simple. Not simplistic, but slightly simpler.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
