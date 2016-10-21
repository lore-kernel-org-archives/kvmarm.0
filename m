From: Auger Eric <eric.auger@redhat.com>
Subject: v4.9-rc1 fails booting as a guest on ARM64 Cavium ThunderX
Date: Fri, 21 Oct 2016 09:01:37 +0200
Message-ID: <924fd627-329a-54e0-694c-a9bdf979f696@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Marc Zyngier <Marc.Zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: Andrew Jones <drjones@redhat.com>, daniel.thompson@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

I am not able to boot 4.9-rc1 as a guest on Cavium ThunderX (dt and acpi
mode). Bisecting the guest shows that the problem shows up at

91ef84428a86b75a52e15c6fe4f56b446ba75f93
irqchip/gic-v3: Reset BPR during initialization

If I remove the write to the ICC_BPR1_EL1 register on guest, the VM boots.

Investigating KVM code ...

Thanks

Eric
