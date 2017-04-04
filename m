From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v2 1/9] KVM: add kvm_request_pending
Date: Tue, 4 Apr 2017 18:41:20 +0200
Message-ID: <20170404164120.xvlvyebvcqoci5cu@kamzik.brq.redhat.com>
References: <20170331160658.4331-1-drjones@redhat.com>
 <20170331160658.4331-2-drjones@redhat.com>
 <20170404153014.GL11752@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170404153014.GL11752@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <cdall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, marc.zyngier@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Apr 04, 2017 at 05:30:14PM +0200, Christoffer Dall wrote:
> On Fri, Mar 31, 2017 at 06:06:50PM +0200, Andrew Jones wrote:
> > From: Radim Krčmář <rkrcmar@redhat.com>
> > 
> > A first step in vcpu->requests encapsulation.
> 
> Could we have a note here on why we need to access vcpu->requests using
> READ_ONCE now?

Sure, maybe we should put the note as a comment above the read in
kvm_request_pending().  Something like

 /*
  * vcpu->requests reads may appear in sequences that have strict
  * data or control dependencies.  Use READ_ONCE() to ensure the
  * compiler does not do anything that breaks the required ordering.
  */

Radim?

Thanks,
drew
