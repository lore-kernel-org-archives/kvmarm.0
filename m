From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [RFC PATCH] KVM: arm/arm64: Don't let userspace update CNTVOFF
 once guest is running
Date: Thu, 9 Jul 2015 14:24:06 +0200
Message-ID: <20150709122406.GN13530@cbox>
References: <55917E5B.3030401@huawei.com>
 <CAFEAcA-vS8B8pJUSseFw0OaKJFPe-0rMT-XHxjNbSvyxaZ+9Tg@mail.gmail.com>
 <559D483A.40507@arm.com>
 <CAFEAcA-U1mEGy87ax4Cb1MLFcEP+sqc9BL_Q0hO6qg1J3FCMew@mail.gmail.com>
 <559D51C5.3070600@arm.com>
 <CAFEAcA-rWf5UkiP+5UbtjYihfhDOVaY4hVpXNRGMnYEhNWqwSQ@mail.gmail.com>
 <20150709102201.GH13530@cbox>
 <CAFEAcA-4rMB6i2=UBXjxTAHQWn5xMiCSiaYbknuXOuHmf4XY_A@mail.gmail.com>
 <20150709120531.GL13530@cbox>
 <CAFEAcA94qRKs7TV4MmrhD4O0+cE4SYPb4iKydQQbSzdrzKMC+w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAFEAcA94qRKs7TV4MmrhD4O0+cE4SYPb4iKydQQbSzdrzKMC+w@mail.gmail.com>
Sender: kvm-owner@vger.kernel.org
To: Peter Maydell <peter.maydell@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Claudio Fontana <claudio.fontana@huawei.com>, Jan Kiszka <jan.kiszka@web.de>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, arm-mail-list <linux-arm-kernel@lists.infradead.org>, kvm-devel <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Jul 09, 2015 at 01:07:24PM +0100, Peter Maydell wrote:
> On 9 July 2015 at 13:05, Christoffer Dall <christoffer.dall@linaro.org> wrote:
> > As I understand it, the problem is that if we ever run a VCPU after
> > reading the value, and write back the value afterwards, you potentially
> > make time go backwards and get inconsistent views of time from different
> > VCPUs because they may have read the time before/after updating the
> > CNTVOFF.
> 
> Right, but I think if QEMU does that it's a bug (and more to
> the point I don't entirely understand why we would do that
> yet, even given that we don't have a distinction between
> "registers to sync always" and "registers to sync only on
> reset"...)
> 
I think we have evidence that it does that, but we don't know why/how.

-Christoffer
