From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v10 0/8] arm/arm64: vgic: Implement API for vGICv3 live
 migration
Date: Fri, 20 Jan 2017 14:51:42 +0100
Message-ID: <20170120135142.GA13531@cbox>
References: <1480576187-5012-1-git-send-email-vijay.kilari@gmail.com>
 <588020D2.4020108@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <588020D2.4020108@huawei.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Shannon Zhao <zhaoshenglong@huawei.com>
Cc: peter.maydell@linaro.org, vijay.kilari@gmail.com, marc.zyngier@arm.com, Vijaya Kumar K <Vijaya.Kumar@cavium.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Shannon,

On Thu, Jan 19, 2017 at 10:13:38AM +0800, Shannon Zhao wrote:
> Hi Vijaya,
> 
> On 2016/12/1 15:09, vijay.kilari@gmail.com wrote:
> > From: Vijaya Kumar K <Vijaya.Kumar@cavium.com>
> > 
> > This patchset adds API for saving and restoring
> > of VGICv3 registers to support live migration with new vgic feature.
> > This API definition is as per version of VGICv3 specification
> > Documentation/virtual/kvm/devices/arm-vgic-v3.txt
> > 
> > The patch 3 & 4 are picked from the Pavel's previous implementation.
> > http://www.spinics.net/lists/kvm/msg122040.html
> > 
> > NOTE: Only compilation tested for AArch32. No hardware to test.
> > 
> Where can I fetch the latest corresponding QEMU patches? I didn't find
> them in qemu-devel/qemu-arm mail list.
> 

Vijaya must have gotten something wrong in sending to the lists, because
I couldn't find them in the archive either, and Eric also couldn't find
them.  But I was cc'ed, so I've bounced them your way.

-Christoffer
