From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v7 14/24] KVM: arm64: vgic-v3:
 vgic_v3_lpi_sync_pending_status
Date: Sun, 07 May 2017 13:13:37 +0100
Message-ID: <87wp9skgpa.fsf@on-the-bus.cambridge.arm.com>
References: <1494084283-12723-1-git-send-email-eric.auger@redhat.com>
 <1494084283-12723-15-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 78E2C40BBB
 for <kvmarm@lists.cs.columbia.edu>; Sun,  7 May 2017 08:10:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id M+WpQaiDeALH for <kvmarm@lists.cs.columbia.edu>;
 Sun,  7 May 2017 08:10:35 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 92175405DA
 for <kvmarm@lists.cs.columbia.edu>; Sun,  7 May 2017 08:10:35 -0400 (EDT)
In-Reply-To: <1494084283-12723-15-git-send-email-eric.auger@redhat.com> (Eric
 Auger's message of "Sat, 6 May 2017 17:24:33 +0200")
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Eric Auger <eric.auger@redhat.com>
Cc: kvm@vger.kernel.org, Prasun.Kapoor@cavium.com, vijayak@caviumnetworks.com, andre.przywara@arm.com, quintela@redhat.com, dgilbert@redhat.com, bjsprakash.linux@gmail.com, Vijaya.Kumar@cavium.com, linux-arm-kernel@lists.infradead.org, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, eric.auger.pro@gmail.com
List-Id: kvmarm@lists.cs.columbia.edu

On Sat, May 06 2017 at  4:24:33 pm BST, Eric Auger <eric.auger@redhat.com> wrote:
> this new helper synchronizes the irq pending_latch
> with the LPI pending bit status found in rdist pending table.
> As the status is consumed, we reset the bit in pending table.
>
> As we need the PENDBASER_ADDRESS() in vgic-v3, let's move its
> definition in the irqchip header. We restore the full length
> of the field, ie [51:16]. Same for PROPBASER_ADDRESS with full
> field length of [51:12].
>
> Signed-off-by: Eric Auger <eric.auger@redhat.com>

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead, it just smell funny.
