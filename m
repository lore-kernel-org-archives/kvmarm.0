From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v9 20/21] KVM: ARM: Introduce per-vcpu kvm device controls
Date: Fri, 15 Jan 2016 12:16:03 +0100
Message-ID: <20160115111603.GF3915@hawk.localdomain>
References: <1452839275-19368-1-git-send-email-zhaoshenglong@huawei.com>
 <1452839275-19368-21-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2CD0149A0A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jan 2016 06:11:57 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Q6bKQxVw0yow for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Jan 2016 06:11:56 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1AEAE49444
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jan 2016 06:11:55 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <1452839275-19368-21-git-send-email-zhaoshenglong@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Shannon Zhao <zhaoshenglong@huawei.com>
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, shannon.zhao@linaro.org, will.deacon@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Jan 15, 2016 at 02:27:54PM +0800, Shannon Zhao wrote:
> From: Shannon Zhao <shannon.zhao@linaro.org>
> 
> In some cases it needs to get/set attributes specific to a vcpu and so
> needs something else than ONE_REG.
> 
> Let's copy the KVM_DEVICE approach, and define the respective ioctls
> for the vcpu file descriptor.
> 
> Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
> ---
> CC: Peter Maydell <peter.maydell@linaro.org>
> ---

Reviewed-by: Andrew Jones <drjones@redhat.com>
