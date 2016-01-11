From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v8 20/20] KVM: ARM64: Add a new kvm ARM PMU device
Date: Mon, 11 Jan 2016 17:21:59 +0100
Message-ID: <20160111162159.GG3924@hawk.localdomain>
References: <1450771695-11948-21-git-send-email-zhaoshenglong@huawei.com>
 <CAFEAcA_MDiOphseZ7RGNE3G=4ZDF5SFV5krOjanPbVuhgg9gnQ@mail.gmail.com>
 <568E7AF1.9040103@huawei.com>
 <CAFEAcA-Qcda7TSFLSeykLHqZYdP6tYdEjPe2uHN6f_+omqWFZg@mail.gmail.com>
 <20160107203647.GJ6199@hawk.localdomain>
 <20160109122956.GA30867@cbox>
 <20160109150339.10576e81@arm.com>
 <20160111140717.GD3924@hawk.localdomain>
 <20160111150929.GB15554@cbox>
 <20160111160927.GF3924@hawk.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160111160927.GF3924@hawk.localdomain>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Peter Maydell <peter.maydell@linaro.org>, Shannon Zhao <zhaoshenglong@huawei.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, kvm-devel <kvm@vger.kernel.org>, Will Deacon <will.deacon@arm.com>, Shannon Zhao <shannon.zhao@linaro.org>, arm-mail-list <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Jan 11, 2016 at 05:09:27PM +0100, Andrew Jones wrote:
> On Mon, Jan 11, 2016 at 04:09:29PM +0100, Christoffer Dall wrote:
> > Are vcpu ids already exposed to userspace (beyond the stupid
> > KVM_IRQ_LINE) ioctl and as such we're bound to whatever upper limit and
> > format they have?
> 
> The only other place I found is KVM_CREATE_VCPU. I suppose we could move
> to MPIDR for that, and it would be a nice way to handle the "userspace
> determines MPIDR" work that I plan to do. Both KVM and its userspaces
> would still use some counter-based vcpu identifiers internally, to avoid
> large, sparse structures, but I guess the advantage is that they don't
> have to agree on how they do that. The 'vcpu id' used by KVM_CREATE_VCPU
> is already 32-bits, and is supposed to be an arbitrary identifier. That
> all looks good for converting to MPIDR.
>

Correction. I understand that vcpu-id is "supposed" to be an arbitrary
identifier now, but it doesn't appear that all the assumptions that it's
a counter are gone yet... virt/kvm/kvm_main.c has

static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
...
        if (id >= KVM_MAX_VCPUS)
                return -EINVAL;



More to do there I guess...

drew 
