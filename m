From: Andrew Jones <drjones@redhat.com>
Subject: Re: [Qemu-devel] [kvm-unit-tests PATCH v8 1/3] arm: Add PMU test
Date: Fri, 11 Nov 2016 08:37:37 +0100
Message-ID: <20161111073737.ccnra2fbjytfz7io@hawk.localdomain>
References: <1478629035-12938-1-git-send-email-wei@redhat.com>
 <1478629035-12938-2-git-send-email-wei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1478629035-12938-2-git-send-email-wei@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Wei Huang <wei@redhat.com>
Cc: cov@codeaurora.org, alindsay@codeaurora.org, kvm@vger.kernel.org, croberts@codeaurora.org, qemu-devel@nongnu.org, alistair.francis@xilinx.com, shannon.zhao@linaro.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Nov 08, 2016 at 12:17:13PM -0600, Wei Huang wrote:
> From: Christopher Covington <cov@codeaurora.org>
> 
> Beginning with a simple sanity check of the control register, add
> a unit test for the ARM Performance Monitors Unit (PMU).
> 
> Signed-off-by: Christopher Covington <cov@codeaurora.org>
> Signed-off-by: Wei Huang <wei@redhat.com>
> ---
>  arm/Makefile.common |  3 ++-
>  arm/pmu.c           | 73 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  arm/unittests.cfg   |  5 ++++
>  3 files changed, 80 insertions(+), 1 deletion(-)
>  create mode 100644 arm/pmu.c

Reviewed-by: Andrew Jones <drjones@redhat.com>
