From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v8 00/20] KVM: ARM64: Add guest PMU support
Date: Thu, 7 Jan 2016 14:12:27 +0000
Message-ID: <20160107141227.GE23028@arm.com>
References: <1450771695-11948-1-git-send-email-zhaoshenglong@huawei.com>
 <568E71DE.9030905@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <568E71DE.9030905@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Shannon Zhao <zhaoshenglong@huawei.com>, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, wei@redhat.com, cov@codeaurora.org, shannon.zhao@linaro.org, peter.huangpeng@huawei.com, hangaohuai@huawei.com, Peter Maydell <peter.maydell@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Jan 07, 2016 at 02:10:38PM +0000, Marc Zyngier wrote:
> On 22/12/15 08:07, Shannon Zhao wrote:
> > From: Shannon Zhao <shannon.zhao@linaro.org>
> > 
> > This patchset adds guest PMU support for KVM on ARM64. It takes
> > trap-and-emulate approach. When guest wants to monitor one event, it
> > will be trapped by KVM and KVM will call perf_event API to create a perf
> > event and call relevant perf_event APIs to get the count value of event.
> > 
> > Use perf to test this patchset in guest. When using "perf list", it
> > shows the list of the hardware events and hardware cache events perf
> > supports. Then use "perf stat -e EVENT" to monitor some event. For
> > example, use "perf stat -e cycles" to count cpu cycles and
> > "perf stat -e cache-misses" to count cache misses.
> 
> I finally feel like we're pretty close to something we could merge. My
> current concerns are:

The merge window opens on Monday and I'm not prepared to take further
PMU changes at this point (unless they're bug fixes, of course).

This needs to wait until 4.6.

Will
