From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] KVM: arm/arm64: VGIC MMIO: add missing irq_lock
Date: Wed, 7 Mar 2018 13:09:16 +0000
Message-ID: <20a9983c-6e66-1fc6-6901-1748fcc3226e@arm.com>
References: <20180306092106.13044-1-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180306092106.13044-1-andre.przywara@arm.com>
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
To: Andre Przywara <andre.przywara@arm.com>, Christoffer Dall <cdall@kernel.org>
Cc: Eric Auger <eric.auger@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 06/03/18 09:21, Andre Przywara wrote:
> Our irq_is_pending() helper function accesses multiple members of the
> vgic_irq struct, so we need to hold the lock when calling it.
> Add that requirement as a comment to the definition and take the lock
> around the call in vgic_mmio_read_pending(), where we were missing it
> before.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>

Queued for 4.16-rc5.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
