From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: Re: [Query] Does Linux & Qemu support KVM for ARM32
 guest on ARM64 host
Date: Thu, 28 Apr 2016 10:33:50 +0800
Message-ID: <5721768E.407@huawei.com>
References: <BE.E9.04928.D4C61275@epcpsbgx1.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org>
In-Reply-To: <BE.E9.04928.D4C61275@epcpsbgx1.samsung.com>
List-Unsubscribe: <https://lists.nongnu.org/mailman/options/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=unsubscribe>
List-Archive: <http://lists.nongnu.org/archive/html/qemu-devel/>
List-Post: <mailto:qemu-devel@nongnu.org>
List-Help: <mailto:qemu-devel-request@nongnu.org?subject=help>
List-Subscribe: <https://lists.nongnu.org/mailman/listinfo/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=subscribe>
Errors-To: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
Sender: "Qemu-devel" <qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org>
To: r.sande@samsung.com, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, qemu-arm@nongnu.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, qemu-devel@nongnu.org, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu



On 2016/4/28 9:50, RAVINDRA KUMAR SANDE wrote:
> 
> What I did  :
> 1) Just for investigation, I took a ARMv8 ( OdroidC2 ) board
> 2)  I compiled Linux 3.14 with KVM support for this ARMv8 ( OdroidC2 )
> board, with modification replacing meson_timer by arm timer in its dts
> file.
> Why Linux 3.14 : I took Linux 3.14 because display drivers for this
> board are officially for this version; and I am interested in seeing
> some Linux guest booting with display on.
> 3)  I see from boot log of  that KVM is initialized successfully, and I
> can see /dev/kvm node.
> 4) I built latest Qemu with --enable-kvm on this board natively.
> 
> What I find :
> 1) running "qemu-system-arm  -enable-kvm   -machine vexpress-a9 ...."
> gives error :  no accelerator found
> 2) running "qemu-system-aarch64 -enable-kvm  -machine vexpress-a9 ...."
> gives error : kmv_init_vcpu (IOCtl on /dev/kvm) failed, guest not supported
> ( I experimented some modifications as well to overcome above error,
> such as replacing value assigned to cpu->kvm_target etc, but IOCtl call
> is failing)
> 
> Query:
> 1) Does Arm64 Linux not enable KVM support for Arm32 guest ?
> 2) Can qemu-system-arm not use the KVM feature on Arm64 host ?
> 3) Can qemu-system-aarch64 not use KVM feature for Arm32 guest ?
> 
You can use below command to boot a ARM32 guest on ARM64：

qemu-system-aarch64 -enable-kvm -machine virt,kernel_irqchip=on -cpu
host,aarch64=off ....

-- 
Shannon
