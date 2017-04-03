From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 0/9] KVM: arm/arm64: race fixes and vcpu requests
Date: Mon, 3 Apr 2017 19:11:29 +0200
Message-ID: <b389ef89-478e-4eb8-cc69-1a05bfbe7909@redhat.com>
References: <20170331160658.4331-1-drjones@redhat.com>
 <20170403152845.GB11752@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170403152845.GB11752@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <cdall@linaro.org>, Andrew Jones <drjones@redhat.com>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, marc.zyngier@arm.com, rkrcmar@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu



On 03/04/2017 17:28, Christoffer Dall wrote:
>>   - No longer based on Radim's vcpu request API rework[1], except for
>>     including "add kvm_request_pending" as patch 1/9 [drew]
> 
> I lost track here; did those patches get merged or dropped and why are
> we not basing this work on them anymore, and should patch 1/9 be applied
> here or is it expected to land in the KVM tree via some other path?

Feel free to apply it, since any conflicts from those patches would not
reach Linus.

Paolo
