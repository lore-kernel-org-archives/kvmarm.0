From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC v2 3/6] irq: bypass: Extend skeleton for ARM forwarding
 control
Date: Mon, 6 Jul 2015 19:41:25 +0200
Message-ID: <559ABDC5.3060200@redhat.com>
References: <1436184692-20927-1-git-send-email-eric.auger@linaro.org>
 <1436184692-20927-4-git-send-email-eric.auger@linaro.org>
 <559A7425.4050506@redhat.com> <559AA02A.6060703@linaro.org>
 <559AA552.3010400@redhat.com> <559AB62C.9000503@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <559AB62C.9000503@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Eric Auger <eric.auger@linaro.org>, eric.auger@st.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, christoffer.dall@linaro.org, marc.zyngier@arm.com, alex.williamson@redhat.com, avi.kivity@gmail.com, mtosatti@redhat.com, feng.wu@intel.com, joro@8bytes.org, b.reynal@virtualopensystems.com
Cc: linux-kernel@vger.kernel.org, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu



On 06/07/2015 19:09, Eric Auger wrote:
>> > The good thing is that this helps a bit forming a lock hierarchy across
>> > the subsystems, for example irq bypass mutex outside vfio_platform_irq
>> > spinlock, because you cannot have a spinlock inside the mutex.  I think
>> > that all of your six callbacks are fine.
> arghh, no that's wrong then. I have plenty of them in the KVM/arm vgic
> part :-(

I checked and it's right...

/me rereads

AAAARGH.  You cannot have a mutex inside a spinlock.  What you're doing
is fine.

Paolo
