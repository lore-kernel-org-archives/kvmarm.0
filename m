From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 0/4] KVM: arm/arm64: Fix locking issues
Date: Tue, 15 May 2018 12:54:54 +0100
Message-ID: <b8aae9d6-1413-157d-52c2-e06511975e11@arm.com>
References: <20180511142015.21953-1-andre.przywara@arm.com>
 <20180515102659.GA38551@C02W217FHV2R.local>
 <da25660f-7d57-34be-fe99-f42c10d81845@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <da25660f-7d57-34be-fe99-f42c10d81845@redhat.com>
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
To: Paolo Bonzini <pbonzini@redhat.com>, Christoffer Dall <christoffer.dall@arm.com>, Andre Przywara <andre.przywara@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, Eric Auger <eric.auger@redhat.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 15/05/18 12:35, Paolo Bonzini wrote:
> On 15/05/2018 12:26, Christoffer Dall wrote:
>> On Fri, May 11, 2018 at 03:20:11PM +0100, Andre Przywara wrote:
>>> Jan recently reported lockdep complaints regarding various locks in our
>>> VGIC emulation [1][2].
>>> This boiled down to two separate issues:
>>> - When promoting the vgic_irq->irq_lock to require IRQs being disabled,
>>>   we forgot to amend some instances of this lock on the way. Also this
>>>   needs to be applied to dependent locks as well. The first two patches
>>>   fix that. The patch split is designed to simplify backporting.
>>>   Those patches have been posted before, I am resending them as part
>>>   of this series.
>>> - Calling kvm_read_guest() requires us to be inside an SRCU critical
>>>   section. On some architectures we are always in it when handling VCPU
>>>   exits, but on ARM we need to lock it individually. Patches 3 and 4
>>>   fix that, the split is again made to ease backporting.
>>>   Each of the hunks fix an indiviual commit, but I refrained from
>>>   splitting this down into eight patches just to put proper Fixes: tags
>>>   on it. Eventually those commits are part of one out of two series, I put
>>>   the respective kernel release version as a tag to the Cc: stable line.
>>>
>>> I couldn't reproduce the full lockdep splat on my setup, but at least
>>> could show one instance and prove that these patches fixes that.
>>>
>>>
>> For the series:
>>
>> Acked-by: Christoffer Dall <christoffer.dall@arm.com>
> 
> Shall I put the patches on their route to Linus?
If you're about to send something, yes please (saves me having to send
you a pull request). In that case, please add my

Acked-by: Marc Zyngier <marc.zyngier@arm.com>

to the whole series.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
