From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v5 00/11] KVM: arm/arm64: race fixes and vcpu requests
Date: Sun, 4 Jun 2017 16:56:06 +0200
Message-ID: <20170604145606.GF9464@cbox>
References: <20170604124401.24902-1-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170604124401.24902-1-drjones@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Andrew Jones <drjones@redhat.com>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, marc.zyngier@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Drew,

On Sun, Jun 04, 2017 at 02:43:50PM +0200, Andrew Jones wrote:
> This series fixes some hard to produce races by introducing the use of
> vcpu requests. I've tested the series on a Mustang and ThunderX and
> compile-tested the ARM bits.
> 
> Patch 3/11 adds documentation, as, at least for me, understanding vcpu
> request interplay with vcpu kicks and vcpu mode and the memory barriers
> that interplay implies, is exhausting.

I have applied these to kvmarm/queue.

Will give them a bit of testing over the next week (and hope others do
as well), and will then otherwise apply them to next.

Thanks for all the hard work!
-Christoffer
