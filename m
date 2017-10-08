From: Shanker Donthineni <shankerd@codeaurora.org>
Subject: Re: [PATCH v4 00/26] KVM/ARM: Add support for GICv4
Date: Sun, 8 Oct 2017 11:45:11 -0500
Message-ID: <0134a6cd-dfbc-6fe5-63a6-958b61d92f36@codeaurora.org>
References: <20171006153401.5481-1-marc.zyngier@arm.com>
Reply-To: shankerd@codeaurora.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20171006153401.5481-1-marc.zyngier@arm.com>
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Mark Rutland <mark.rutland@arm.com>, Andre Przywara <Andre.Przywara@arm.com>, Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>, Eric Auger <eric.auger@redhat.com>, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,

I've tested this patch series on QDF2400 server platform using NVME card, the basic
functionality works fine and the below log messages shows around 70 interrupts
are delivered to vCPU directly.


Tested-by: Shanker Donthineni <shankerd@codeaurora.org>


>From guest kernel:
 /mnt # cat /proc/interrupts | grep ITS
 51:         83   ITS-MSI 32768 Edge      nvme0q0, nvme0q1
 52:          0   ITS-MSI 16384 Edge      virtio0-config
 53:          0   ITS-MSI 16385 Edge      virtio0-input.0
 54:          0   ITS-MSI 16386 Edge      virtio0-output.0
 
>From host kernel:
 /mnt # cat /proc/interrupts | grep GICv4
 388:          9  GICv4-vpe   0 Edge      vcpu

-- 
Shanker Donthineni
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project.
