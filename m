From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 2/9] KVM: Add documentation for VCPU requests
Date: Tue, 4 Apr 2017 19:36:06 +0200
Message-ID: <0ec579cc-edf8-b479-ec18-1a181fcb9294@redhat.com>
References: <20170331160658.4331-1-drjones@redhat.com>
 <20170331160658.4331-3-drjones@redhat.com> <20170404152403.GK11752@cbox>
 <20170404170600.w6snnecqoi4aqv4d@kamzik.brq.redhat.com>
 <20170404172340.GQ11752@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170404172340.GQ11752@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <cdall@linaro.org>, Andrew Jones <drjones@redhat.com>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, marc.zyngier@arm.com, rkrcmar@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu



On 04/04/2017 19:23, Christoffer Dall wrote:
>> I think all !IN_GUEST_MODE should behave the same, so I was avoiding
>> the use of EXITING_GUEST_MODE and OUTSIDE_GUEST_MODE, which wouldn't be
>> hard to address, but then I'd also have to address
>> READING_SHADOW_PAGE_TABLES, which may complicate the document more than
>> necessary.  I'm not sure we need to address a VCPU exiting guest mode,
>> other than making sure it's clear that a VCPU that exits must check
>> requests before it enters again.
> 
> But the problem is that kvm_make_all_cpus_request() only sends IPIs to
> CPUs where the mode was different from OUTSIDE_GUEST_MODE, so there it's
> about !OUTSIDE_GUEST_MODE rather than !IN_GUEST_MODE, so there's some
> subtlety here which I feel like it's dangerous to paper over.

Don't bother documenting READING_SHADOW_PAGE_TABLES---but
EXITING_GUEST_MODE should be used in ARM and documented, because it's
the key in making kvm_vcpu_kick not racy.

Paolo
