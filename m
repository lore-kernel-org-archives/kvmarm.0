From: Andrew Jones <drjones@redhat.com>
Subject: Re: [kvm-unit-tests PATCH] Support micro operation measurement on
 arm64
Date: Thu, 21 Dec 2017 15:32:18 +0100
Message-ID: <20171221143218.rxuhe34xewzl3yaq@hawk.localdomain>
References: <1513372539-10180-1-git-send-email-shihwei@cs.columbia.edu>
 <20171218181440.yggldvw6lry6wsza@hawk.localdomain>
 <CAO+sbHGU6EUUHQynAaA33T-ThUwA=5f9yq_Uq2mLtXRcHN02Ew@mail.gmail.com>
 <20171219090620.GA31048@cbox>
 <20171219121109.hxqbqjkdgt7k5jo6@hawk.localdomain>
 <20171219130706.GD31048@cbox>
 <20171220162254.dp5vok6lgbxyo5od@hawk.localdomain>
 <20171221113150.GC29301@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171221113150.GC29301@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Shih-Wei Li <shihwei@cs.columbia.edu>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, Marc Zyngier <marc.zyngier@arm.com>, Paolo Bonzini <pbonzini@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Dec 21, 2017 at 12:31:50PM +0100, Christoffer Dall wrote:
> Perhaps we should just have an initial assert of "is this thing on"
> which does something that should register a moving count on even a slow
> clocked arch counter, and then only check for overflow in the general
> case?

Yeah, that sounds good to me.

Thanks,
drew
