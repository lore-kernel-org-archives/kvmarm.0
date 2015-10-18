From: Andrew Jones <drjones@redhat.com>
Subject: Re: [Qemu-devel] [kvm-unit-tests PATCHv4] ARM PMU tests
Date: Sun, 18 Oct 2015 20:29:40 +0200
Message-ID: <20151018182940.GD12158@hawk.localdomain>
References: <5612EDA5.9010506@redhat.com>
 <1444662470-13045-1-git-send-email-cov@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B236B40FF5
 for <kvmarm@lists.cs.columbia.edu>; Sun, 18 Oct 2015 14:27:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Uc+NSCSm3YvS for <kvmarm@lists.cs.columbia.edu>;
 Sun, 18 Oct 2015 14:27:18 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0996040FA6
 for <kvmarm@lists.cs.columbia.edu>; Sun, 18 Oct 2015 14:27:18 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <1444662470-13045-1-git-send-email-cov@codeaurora.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christopher Covington <cov@codeaurora.org>
Cc: alindsay@codeaurora.org, kvm@vger.kernel.org, croberts@codeaurora.org, qemu-devel@nongnu.org, alistair.francis@xilinx.com, shannon.zhao@linaro.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Oct 12, 2015 at 11:07:47AM -0400, Christopher Covington wrote:
> Changes from v3 in response to Drew's suggestions:
> 
> * Improved pmu_data / PMCR fields and usage
> * Straightened out awkward conditionals
> * Added 32-bit support
> * Styling enhancements
> * Deferred -icount testing to later patch
> 
>

Sorry I was slow to review this version. Also, just FYI, I'll be on
vacation for a week, so I'll probably be slow to review the next
version too :-) Anyway, thanks for the patches, and thanks for your
patience.

drew 
