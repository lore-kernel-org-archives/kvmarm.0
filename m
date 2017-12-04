From: Christoffer Dall <cdall@kernel.org>
Subject: Re: [PATCH] KVM: arm: Use PTR_ERR_OR_ZERO()
Date: Mon, 4 Dec 2017 20:40:49 +0100
Message-ID: <20171204194049.GH32397@cbox>
References: <1511909297-8585-1-git-send-email-gomonovych@gmail.com>
 <20171201080049.GB4218@cbox>
 <CAHYXAnL3DVkDMF03QRV62RCFzmViDGYR2rQHBS44jyCo2FRgqw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAHYXAnL3DVkDMF03QRV62RCFzmViDGYR2rQHBS44jyCo2FRgqw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Gomonovych, Vasyl" <gomonovych@gmail.com>
Cc: Christoffer Dall <cdall@linaro.org>, Christoffer Dall <christoffer.dall@linaro.org>, marc.zyngier@arm.com, eric.auger@redhat.com, andre.przywara@arm.com, wanghaibin.wang@huawei.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Dec 04, 2017 at 12:11:22PM +0100, Gomonovych, Vasyl wrote:
> Hi Christoffer
> 
> It is just syntax sugar of course
> and in mentioned function context it looks harmonically because it is
> in the end of function return statement.
> But in context of around source files it is looks not so harmonically because
> existing code uses old approach.
> And this old approach is only in one place here.
> So it is just a try to fix the warning and may be force to use it in a
> future changes.

ok, thanks.
-Christoffer
