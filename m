From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH] arm64: KVM: set right LR register value for 32 bit guest
 when inject abort
Date: Mon, 16 Oct 2017 21:59:01 +0200
Message-ID: <20171016195901.GA5753@lvm>
References: <0184EA26B2509940AA629AE1405DD7F201699F61@DGGEMA503-MBX.china.huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <0184EA26B2509940AA629AE1405DD7F201699F61@DGGEMA503-MBX.china.huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: gengdongjiu <gengdongjiu@huawei.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, "will.deacon@arm.com" <will.deacon@arm.com>, "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>, "rkrcmar@redhat.com" <rkrcmar@redhat.com>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Oct 16, 2017 at 04:10:01PM +0000, gengdongjiu wrote:
> Hi Marc,
> 
> > 
> > Please also update the 32bit code accordingly, as it looks broken too.
> 
> I have updated the 32 bit code according, in my hand, there is no arm32 host environment,
> So there is no method to verify it in the arm32 host, only verify the patch in the arm64 host.
> 
> Anyway I firstly send the patch out for review. Thanks.
> 
In this case, if you just clearly specify in the patches you send out
that the 32-bit one is untested, you can ask someone to test it for you.

Thanks,
-Christoffer
