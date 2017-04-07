From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v3 8/8] arm64: exception: check shared writable page in
 SEI handler
Date: Fri, 07 Apr 2017 16:56:45 +0100
Message-ID: <58E7B6BD.3000401@arm.com>
References: <1490869877-118713-1-git-send-email-xiexiuqi@huawei.com>
 <1490869877-118713-9-git-send-email-xiexiuqi@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CE77C40C54
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Apr 2017 11:54:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id K5leUeBcyDr3 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  7 Apr 2017 11:54:53 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9952F40C2F
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Apr 2017 11:54:53 -0400 (EDT)
In-Reply-To: <1490869877-118713-9-git-send-email-xiexiuqi@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Xie XiuQi <xiexiuqi@huawei.com>
Cc: linux-arm-kernel@lists.infradead.org, wuquanming@huawei.com, kvm@vger.kernel.org, marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, rostedt@goodmis.org, gengdongjiu@huawei.com, wangxiongfeng2@huawei.com, linux-acpi@vger.kernel.org, Wang Xiongfeng <wangxiongfengi2@huawei.com>, shiju.jose@huawei.com, zhengqiang10@huawei.com, kvmarm@lists.cs.columbia.edu, fu.wei@linaro.org, hanjun.guo@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Xie XiuQi,

On 30/03/17 11:31, Xie XiuQi wrote:
> From: Wang Xiongfeng <wangxiongfeng2@huawei.com>
> 
> Since SEI is asynchronous, the error data has been consumed. So we must
> suppose that all the memory data current process can write are
> contaminated. If the process doesn't have shared writable pages, the
> process will be killed, and the system will continue running normally.
> Otherwise, the system must be terminated, because the error has been
> propagated to other processes running on other cores, and recursively
> the error may be propagated to several another processes.

This is pretty complicated. We can't guarantee that another CPU hasn't modified
the page tables while we do this, (so its racy). We can't guarantee that the
corrupt data hasn't been sent over the network or written to disk in the mean
time (so its not enough).

The scenario you have is a write of corrupt data to memory where another CPU
reading it doesn't know the value is corrupt.

The hardware gives us quite a lot of help containing errors. The RAS
specification (DDI 0587A) describes your scenario as error propagation in '2.1.2
Architectural error propagation', and then classifies it in '2.1.3
Architecturally infected, containable and uncontainable' as uncontained because
the value is no longer in the general-purpose registers. For uncontained errors
we should panic().

We shouldn't need to try to track errors after we get a notification as the
hardware has done this for us.


Firmware-first does complicate this if events like this are not delivered using
a synchronous external abort, as Linux may have PSTATE.A masked preventing
SError Interrupts from being taken. It looks like PSTATE.A is masked much more
often than is necessary. I will look into cleaning this up.


Thanks,

James
