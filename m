From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 2/9] KVM: Add documentation for VCPU requests
Date: Fri, 7 Apr 2017 19:44:36 +0800
Message-ID: <20616e52-f6e2-fdf0-7e1b-e1e83d724abc@redhat.com>
References: <20170331160658.4331-1-drjones@redhat.com>
 <20170331160658.4331-3-drjones@redhat.com> <20170404152403.GK11752@cbox>
 <20170404170600.w6snnecqoi4aqv4d@kamzik.brq.redhat.com>
 <20170404172340.GQ11752@cbox> <20170405141139.GA13944@potion>
 <20170405174538.GB27123@cbox>
 <45234347-1773-3359-81e3-e1ffe2ae560b@redhat.com>
 <20170405204606.GH6369@potion> <20170406142946.GF27123@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170406142946.GF27123@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <cdall@linaro.org>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc: marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu



On 06/04/2017 22:29, Christoffer Dall wrote:
> We could encode the lazy/non-lazy thing in a bit in the request number
> that gets masked off before clearing/checking the request bit, but
> perhaps there are nicer solutions.

Actually this is the first "nice" solution that it's been proposed.

Thanks,

Paolo
