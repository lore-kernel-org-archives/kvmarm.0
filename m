From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v3 1/3] arm64: kvm: support kvmtool to detect RAS extension
 feature
Date: Thu, 04 May 2017 16:49:07 +0100
Message-ID: <590B4D73.60000@arm.com>
References: <1493530677-4919-1-git-send-email-gengdongjiu@huawei.com>
 <5908A5BC.1060202@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1DBF240992
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 May 2017 11:46:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id auCWhHbfcEnS for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 May 2017 11:46:37 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0C12040296
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 May 2017 11:46:36 -0400 (EDT)
In-Reply-To: <5908A5BC.1060202@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Dongjiu Geng <gengdongjiu@huawei.com>
Cc: mtsirkin@redhat.com, kvm@vger.kernel.org, tbaicar@codeaurora.org, qemu-devel@nongnu.org, wangxiongfeng2@huawei.com, ben@skyportsystems.com, linux@armlinux.org.uk, kvmarm@lists.cs.columbia.edu, huangshaoyu@huawei.com, lersek@redhat.com, songwenjun@huawei.com, wuquanming@huawei.com, marc.zyngier@arm.com, qemu-arm@nongnu.org, imammedo@redhat.com, linux-arm-kernel@lists.infradead.org, ard.biesheuvel@linaro.org, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Dongjiu Geng,

On 02/05/17 16:29, James Morse wrote:
> I think we need a new API for injecting SError for SEI from Qemu/kvmtool, but it
> shouldn't be related to the RAS extensions. All v8.0 CPUs have HCR_EL2.VSE, so
> we need to know KVM supports this API.

Thinking about this some more, it is slightly more nuanced, KVM can always
provide an API to inject SError, but it can only set the VSESR if the CPU has
the RAS Extensions.

Only offering the inject-SError API call if we can also set the VSESR looks a
bit funny, but no-one has needed the no-ESR version so far.

I still don't think we should let user-space make the 'RAS Extensions means
VSESR' logical step.

So my comments on this patch become:
Don't read id registers directly, use cpus_have_cap() which handles features
that differ across CPUs or were turned off at compile time.

Please don't call this 'KVM_CAP_ARM_RAS_EXTENSION', if we are building an API to
inject SError, call it that instead.


Thanks,

James
