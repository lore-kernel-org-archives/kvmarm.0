From: Jan Glauber <jan.glauber@caviumnetworks.com>
Subject: Potential deadlock in vgic
Date: Fri, 4 May 2018 13:03:44 +0200
Message-ID: <20180504110343.GA10968@hc>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: kvmarm@lists.cs.columbia.edu
Cc: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi all,

enabling lockdep I see the following reported in the host when I start a kvm guest:

[12399.954245]        CPU0                    CPU1
[12399.958762]        ----                    ----
[12399.963279]   lock(&(&dist->lpi_list_lock)->rlock);
[12399.968146]                                local_irq_disable();
[12399.974052]                                lock(&(&vgic_cpu->ap_list_lock)->rlock);
[12399.981696]                                lock(&(&dist->lpi_list_lock)->rlock);
[12399.989081]   <Interrupt>
[12399.991688]     lock(&(&vgic_cpu->ap_list_lock)->rlock);
[12399.996989]
                *** DEADLOCK ***

[12400.002897] 2 locks held by qemu-system-aar/5597:
[12400.007587]  #0: 0000000042beb9dc (&vcpu->mutex){+.+.}, at: kvm_vcpu_ioctl+0x7c/0xa68
[12400.015411]  #1: 00000000c45d644a (&(&vgic_cpu->ap_list_lock)->rlock){-.-.}, at: kvm_vgic_sync_hwstate+0x8c/0x328


There is nothing unusual in my config or qemu parameters, I can upload these
if needed. I see this on ThunderX and ThunderX2 and also with older kernels
(4.13+ distribution kernel).

I tried making the lpi_list_lock irq safe but that just leads to different
warnings. The locking here seems to be quite sophisticated and I'm not familiar
with it.

Full dmesg: https://paste.ubuntu.com/p/BZ5QTg62Ym/

--Jan
