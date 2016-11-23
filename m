From: Andrew Jones <drjones@redhat.com>
Subject: Re: [Qemu-devel] [kvm-unit-tests PATCH v11 3/3] arm: pmu: Add CPI
 checking
Date: Wed, 23 Nov 2016 18:16:14 +0100
Message-ID: <20161123171614.ghpjhdy5f2uccxkb@kamzik.brq.redhat.com>
References: <1479839354-22061-1-git-send-email-wei@redhat.com>
 <1479839354-22061-4-git-send-email-wei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 64FE940C9A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Nov 2016 12:15:39 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id v2tYx7Fq06Fk for <kvmarm@lists.cs.columbia.edu>;
 Wed, 23 Nov 2016 12:15:38 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BB27040C8B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Nov 2016 12:15:38 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <1479839354-22061-4-git-send-email-wei@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Wei Huang <wei@redhat.com>
Cc: alindsay@codeaurora.org, kvm@vger.kernel.org, croberts@codeaurora.org, qemu-devel@nongnu.org, alistair.francis@xilinx.com, kvmarm@lists.cs.columbia.edu, shannon.zhao@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Nov 22, 2016 at 12:29:14PM -0600, Wei Huang wrote:
> From: Christopher Covington <cov@codeaurora.org>
> 
> Calculate the numbers of cycles per instruction (CPI) implied by ARM
> PMU cycle counter values. The code includes a strict checking facility
> intended for the -icount option in TCG mode in the configuration file.
> 
> Signed-off-by: Christopher Covington <cov@codeaurora.org>
> Signed-off-by: Wei Huang <wei@redhat.com>
> ---
>  arm/pmu.c         | 123 +++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  arm/unittests.cfg |  14 +++++++
>  2 files changed, 136 insertions(+), 1 deletion(-)


Reviewed-by: Andrew Jones <drjones@redhat.com>
