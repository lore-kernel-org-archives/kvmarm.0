From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH v8 20/20] KVM: ARM64: Add a new kvm ARM PMU device
Date: Mon, 11 Jan 2016 16:13:12 +0000
Message-ID: <CAFEAcA8ayUEoH7zX+cGrOcT7kCWnLzMfgo2NFTbPt3aSPwt-+Q@mail.gmail.com>
References: <1450771695-11948-1-git-send-email-zhaoshenglong@huawei.com>
 <1450771695-11948-21-git-send-email-zhaoshenglong@huawei.com>
 <CAFEAcA_MDiOphseZ7RGNE3G=4ZDF5SFV5krOjanPbVuhgg9gnQ@mail.gmail.com>
 <568E7AF1.9040103@huawei.com> <CAFEAcA-Qcda7TSFLSeykLHqZYdP6tYdEjPe2uHN6f_+omqWFZg@mail.gmail.com>
 <20160107203647.GJ6199@hawk.localdomain> <20160109122956.GA30867@cbox>
 <20160109150339.10576e81@arm.com> <20160111140717.GD3924@hawk.localdomain>
 <20160111150929.GB15554@cbox> <20160111160927.GF3924@hawk.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20160111160927.GF3924@hawk.localdomain>
Sender: kvm-owner@vger.kernel.org
To: Andrew Jones <drjones@redhat.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Shannon Zhao <zhaoshenglong@huawei.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, kvm-devel <kvm@vger.kernel.org>, Will Deacon <will.deacon@arm.com>, Shannon Zhao <shannon.zhao@linaro.org>, arm-mail-list <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 11 January 2016 at 16:09, Andrew Jones <drjones@redhat.com> wrote:
> I think the save/restore case is where I always flip to seeing it as a
> bunch of separate per cpu devices. It would feel better to me to
> save/restore the cpu-gic registers the same way we do all other cpu
> registers.

>From QEMU's point of view this would be extremely awkward, which
is one reason I'm happy with the GICv3 API we came up with
and reviewed last year...

thanks
-- PMM
