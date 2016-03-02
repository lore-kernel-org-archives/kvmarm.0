From: "Jaggi, Manish" <Manish.Jaggi@caviumnetworks.com>
Subject: Re: [RFC v5 00/17] KVM PCIe/MSI passthrough on ARM/ARM64
Date: Wed, 2 Mar 2016 08:11:31 +0000
Message-ID: <BY1PR0701MB1594168E79366B507B7C8A16E1BC0@BY1PR0701MB1594.namprd07.prod.outlook.com>
References: <1456856877-4817-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1456856877-4817-1-git-send-email-eric.auger@linaro.org>
Content-Language: en-US
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Eric Auger <eric.auger@linaro.org>, "eric.auger@st.com" <eric.auger@st.com>, "robin.murphy@arm.com" <robin.murphy@arm.com>, "alex.williamson@redhat.com" <alex.williamson@redhat.com>, "will.deacon@arm.com" <will.deacon@arm.com>, "joro@8bytes.org" <joro@8bytes.org>, "tglx@linutronix.de" <tglx@linutronix.de>, "jason@lakedaemon.net" <jason@lakedaemon.net>, "marc.zyngier@arm.com" <marc.zyngier@arm.com>, "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc: "patches@linaro.org" <patches@linaro.org>, "p.fedin@samsung.com" <p.fedin@samsung.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Bharat.Bhushan@freescale.com" <Bharat.Bhushan@freescale.com>, "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>, "pranav.sawargaonkar@gmail.com" <pranav.sawargaonkar@gmail.com>, "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>
List-Id: kvmarm@lists.cs.columbia.edu



>>From: Eric Auger <eric.auger@linaro.org>
>>Sent: Tuesday, March 1, 2016 11:57 PM
>>To: eric.auger@st.com; eric.auger@linaro.org; robin.murphy@arm.com; alex.williamson@redhat.com; will.deacon@arm.com; joro@8bytes.org; tglx@linutronix.de; >>jason@lakedaemon.net; marc.zyngier@arm.com; christoffer.dall@linaro.org; linux-arm-kernel@lists.infradead.org; kvmarm@lists.cs.columbia.edu; kvm@vger.kernel.org
>>Cc: suravee.suthikulpanit@amd.com; patches@linaro.org; linux-kernel@vger.kernel.org; Jaggi, Manish; Bharat.Bhushan@freescale.com; >>pranav.sawargaonkar@gmail.com; p.fedin@samsung.com; iommu@lists.linux-foundation.org
>>Subject: [RFC v5 00/17] KVM PCIe/MSI passthrough on ARM/ARM64

>>This series addresses KVM PCIe passthrough with MSI enabled on ARM/ARM64.
>>It pursues the efforts done on [1], [2], [3]. It also aims at covering the
>>same need on PowerPC platforms although the same kind of integration
>>.should be carried out.
>>
[snip]
>>- Not tested: ARM GICv3 ITS

[snip]
>>QEMU Integration:
>>[RFC v2 0/8] KVM PCI/MSI passthrough with mach-virt
>>(http://lists.gnu.org/archive/html/qemu-arm/2016-01/msg00444.html)
>>https://git.linaro.org/people/eric.auger/qemu.git/shortlog/refs/heads/v2.5.0-pci-passthrough-rfc-v2

For gicv3 its, I believe, the below series for qemu and kernel is required for gicv3-its

[RFC PATCH v3 0/5] vITS support
https://lists.gnu.org/archive/html/qemu-devel/2015-11/msg05197.html

and in kernel CONFIG_HAVE_KVM_MSI must be enabled so that qemu sees MSI capability KVM_CAP_SIGNAL_MSI

This has a dependency on gsi routing support
KVM: arm/arm64: gsi routing support
https://lkml.org/lkml/2015/6/29/290

I had both the above series in 4.2 in my local 4.2 tree. 

BR
-Manish
