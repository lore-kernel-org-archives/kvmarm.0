From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: Re: [PATCH v10 0/8] arm/arm64: vgic: Implement API for vGICv3 live
 migration
Date: Thu, 19 Jan 2017 10:13:38 +0800
Message-ID: <588020D2.4020108@huawei.com>
References: <1480576187-5012-1-git-send-email-vijay.kilari@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1480576187-5012-1-git-send-email-vijay.kilari@gmail.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: vijay.kilari@gmail.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, peter.maydell@linaro.org
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Vijaya Kumar K <Vijaya.Kumar@cavium.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Vijaya,

On 2016/12/1 15:09, vijay.kilari@gmail.com wrote:
> From: Vijaya Kumar K <Vijaya.Kumar@cavium.com>
> 
> This patchset adds API for saving and restoring
> of VGICv3 registers to support live migration with new vgic feature.
> This API definition is as per version of VGICv3 specification
> Documentation/virtual/kvm/devices/arm-vgic-v3.txt
> 
> The patch 3 & 4 are picked from the Pavel's previous implementation.
> http://www.spinics.net/lists/kvm/msg122040.html
> 
> NOTE: Only compilation tested for AArch32. No hardware to test.
> 
Where can I fetch the latest corresponding QEMU patches? I didn't find
them in qemu-devel/qemu-arm mail list.

Thanks,
-- 
Shannon
