From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [Qemu-devel] [kvm-unit-tests PATCH v13 4/4] arm: pmu: Add CPI
 checking
Date: Thu, 1 Dec 2016 10:19:13 +0000
Message-ID: <369fa1e8-952c-911a-d9f8-ea199405f32f@arm.com>
References: <1480569402-8848-1-git-send-email-wei@redhat.com>
 <1480569402-8848-5-git-send-email-wei@redhat.com>
 <20161201092620.hvyndkroiauscxaa@kamzik.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20161201092620.hvyndkroiauscxaa@kamzik.brq.redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Andrew Jones <drjones@redhat.com>, Wei Huang <wei@redhat.com>
Cc: cov@codeaurora.org, alindsay@codeaurora.org, kvm@vger.kernel.org, croberts@codeaurora.org, qemu-devel@nongnu.org, alistair.francis@xilinx.com, shannon.zhao@linaro.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi Drew,

actually unrelated to this actual patch, but since you mentioned it:

> As we work out how best to handle tcg-only tests in order to get Alex
> Bennee's MTTCG tests merged, we'll probably revisit this file,

So when I was experimenting with kvmtool, I realized that some tests
would need to be QEMU only. Also I was tempted to try some tests either
on bare metal machines or in a Fast Model.
So I wonder if we should have some constraints or tags on the tests, so
that a certain backend can filter on this and skip if it's not capable?

Just wanted to mention this so that we can use this refactoring
opportunity to come up with something more generic than just a boolean
TGC vs. KVM.
Maybe we should introduce the notion of a "test backend"? That could be
QEMU/KVM and TCG for now, but later extended to cover kvmtool and
probably other hypervisors like Xen as well.

Cheers,
Andre.
