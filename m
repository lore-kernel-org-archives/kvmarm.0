From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH 05/37] KVM: Record the executing ioctl number on the vcpu struct
Date: Fri, 13 Oct 2017 20:51:21 +0200
Message-ID: <CAMJs5B92f9dxZDwuLz_GCgSCmeCRdG=oZzwnfSwKxikYQyncvw@mail.gmail.com>
References: <20171012104141.26902-1-christoffer.dall@linaro.org>
 <20171012104141.26902-6-christoffer.dall@linaro.org> <20171013171307.GA16116@flask>
 <20171013173151.GA17578@cbox> <20171013183812.GA26563@flask>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20171013183812.GA26563@flask>
Sender: kvm-owner@vger.kernel.org
To: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, Paolo Bonzini <pbonzini@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Oct 13, 2017 at 8:38 PM, Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@redha=
t.com> wrote:
> 2017-10-13 19:31+0200, Christoffer Dall:
>> On Fri, Oct 13, 2017 at 07:13:07PM +0200, Radim Kr=C4=8Dm=C3=A1=C5=99 wr=
ote:
>> > I think that other (special) callsites of vcpu_load()/vcpu_put() have =
a
>> > well defined IOCTL that can be used instead of vcpu->ioctl, so we coul=
d
>> > just pass the ioctl value all the way to arch code and never save it
>> > anywhere,
>>
>> I don't think that works; what would you do with preempt notifier calls?
>
> Right, BUG :), I didn't consider them before and they need to know.
>
>> One solution is to add a parameter to vcpu_put, lie for vcpu_load, which
>> also sets the ioctl, and other callers than the final vcpu_put in
>> kvm_vcpu_ioctl() just pass the existing value, where the kvm_vcpu_ioctl
>> call can pass 0 which gets set before releasing the mutex.
>>
>> Can you think of a more elegant solution?
>
> Not really, only thought of touching preempt notifiers and it seems to
> be more complicated.
>
> I think we shouldn't restore ioctl on vcpu_put() at all -- the value
> isn't well defined outside of the mutex, so there is no point in looking
> and we can just zero the ioctl.

I agree, that fits with the semantics of vcpu_put() quit nicely actually.

>
> Actually, I wouldn't rely on the existing value at all because that.
> The need for load/put depends on the current code path, not on the one
> we race with.
>
> x86 seems to be the only user of vcpu_load() outside of kvm_vcpu_ioctl()
> and the callers are either under a VM ioctl or under a VM destruction
> paths (invalid IOCTL) and we can just hardcode that.

Yes, we should.  I honestly just wanted feedback on this before
tracing through all call paths to the vcpu_load() calls on the x86
side.

>
> Passing 0 to all other vcpu_load()s and unconditionally zeroing ioctl
> before mutex_unlock() should work.


Agreed.  I'll do that for the next version.

Thanks for having a look!

-Christoffer
