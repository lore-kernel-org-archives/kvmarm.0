From: "Tangnianyao (ICT)" <tangnianyao@huawei.com>
Subject: [RFC] Question about enable doorbell irq and halt_poll process
Date: Tue, 19 Mar 2019 21:25:47 +0800
Message-ID: <0fb3c9ba-8428-ea6c-2973-952624f601cc@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, Linuxarm <linuxarm@huawei.com>
Cc: guoheyi@huawei.com, wanghaibin.wang@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi, all

Using gicv4, when guest is waiting for irq, it sends wfi and traps to kvm.
When vlpi is forwarded to PE after its_vpe_deschedule, before halt_poll in
kvm_vcpu_block, halt_poll may increase latency for this vlpi getting to guest.
In halt_poll process, it checks if there's pending irq for vcpu using pending_last.
However, doorbell is not enable at this moment and vlpi or doorbell can not set
pending_last true, to stop halt_poll. It will run until halt_poll time ends, if
there's no other physical irq coming in the meantime. And then vcpu is scheduled out.
This pending vlpi has to wait for vcpu getting schedule in next time.

Should we enable doorbell before halt_poll process ?
