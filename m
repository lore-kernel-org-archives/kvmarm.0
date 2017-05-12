From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v3 2/3] arm64: kvm: inject SError with virtual syndrome
Date: Fri, 12 May 2017 18:24:30 +0100
Message-ID: <5915EFCE.7070202@arm.com>
References: <1493530677-4919-1-git-send-email-gengdongjiu@huawei.com>
 <1493530677-4919-2-git-send-email-gengdongjiu@huawei.com>
 <5908A7CE.7030008@arm.com> <bbceff7a-1ebf-e6de-abc6-e35b71c939f1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 183A640187
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 May 2017 13:21:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3+xxBDWabMMD for <kvmarm@lists.cs.columbia.edu>;
 Fri, 12 May 2017 13:21:47 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CAE8840296
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 May 2017 13:21:47 -0400 (EDT)
In-Reply-To: <bbceff7a-1ebf-e6de-abc6-e35b71c939f1@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: gengdongjiu <gengdongjiu@huawei.com>
Cc: mtsirkin@redhat.com, kvm@vger.kernel.org, tbaicar@codeaurora.org, qemu-devel@nongnu.org, wangxiongfeng2@huawei.com, ben@skyportsystems.com, linux@armlinux.org.uk, kvmarm@lists.cs.columbia.edu, huangshaoyu@huawei.com, lersek@redhat.com, songwenjun@huawei.com, wuquanming@huawei.com, marc.zyngier@arm.com, qemu-arm@nongnu.org, imammedo@redhat.com, linux-arm-kernel@lists.infradead.org, ard.biesheuvel@linaro.org, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi gengdongjiu,

On 05/05/17 14:19, gengdongjiu wrote:
> On 2017/5/2 23:37, James Morse wrote:
> > ... I think you expect an SError to arrive at EL2 and have its ESR recorded in
> > vcpu->arch.fault.vsesr_el2. Some time later KVM decides to inject an SError into
> > the guest, and this ESR is reused...
> > 
> > We shouldn't do this. Qemu/kvmtool may want to inject a virtual-SError that
> > never started as a physical-SError. Qemu/kvmtool may choose to notify the guest
> > of RAS events via another mechanism, or not at all.
> > 
> > KVM should not give the guest an ESR value of its choice. For SError the ESR
> > describes whether the error is corrected, correctable or fatal. Qemu/kvmtool
> > must choose this.

> Below is my previous solution:
> For the SError, CPU will firstly trap to EL3 firmware and records the syndrome to ESR_EL3.
> Before jumping to El2 hypervisors, it will copy the esr_el3 to esr_el2.

(Copying the ESR value won't always be the right thing to do.)


> so in order to pass this syndrome to vsesr_el2, using the esr_el2 value to assign it.

> If Qemu/kvmtool chooses the ESR value and ESR only describes whether the error is corrected/correctable/fatal,
> whether the information is not enough for the guest?

So the API should specify which of these three severities to use? I think this
is too specific. The API should be useful for anything the VSE/VSESR hardware
can do.

VSESR_EL2 is described in the RAS spec: 4.4.12 [0], its a 64 bit register. I
think we should let Qemu/kvmtool specify any 64bit value here, but KVM should
reject values that try to set bits described as RES0.

This would let Qemu/kvmtool specify any SError ISS, either setting ESR_ELx.IDS
and some virtual-machine specific value, or encoding any severity in AET and
choosing the DFSC/EA bits appropriately.


>> > I think we need an API that allows Qemu/kvmtool to inject SError into a guest,
>> > but that isn't quite what you have here.

> KVM provides APIs to inject the SError, Qemu/kvmtool call the API though IOCTL, may be OK?

(just the one API call), yes.


Thanks,

James

[0]
https://static.docs.arm.com/ddi0587/a/RAS%20Extension-release%20candidate_march_29.pdf
