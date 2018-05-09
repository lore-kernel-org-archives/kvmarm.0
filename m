From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v6 01/15] thread_info: Add update_thread_flag() helpers
Date: Wed, 9 May 2018 10:07:51 +0100
Message-ID: <86456061-b9cc-2941-23de-e41f05b05580@arm.com>
References: <1525797900-5548-1-git-send-email-Dave.Martin@arm.com>
 <1525797900-5548-2-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1525797900-5548-2-git-send-email-Dave.Martin@arm.com>
Content-Language: en-GB
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Dave Martin <Dave.Martin@arm.com>, kvmarm@lists.cs.columbia.edu
Cc: Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Peter Zijlstra <peterz@infradead.org>, Catalin Marinas <catalin.marinas@arm.com>, Oleg Nesterov <oleg@redhat.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 08/05/18 17:44, Dave Martin wrote:
> There are a number of bits of code sprinkled around the kernel to
> set a thread flag if a certain condition is true, and clear it
> otherwise.
> 
> To help make those call sites terser and less cumbersome, this
> patch adds a new family of thread flag manipulators
> 
> 	update*_thread_flag([...,] flag, cond)
> 
> which do the equivalent of:
> 
> 	if (cond)
> 		set*_thread_flag([...,] flag);
> 	else
> 		clear*_thread_flag([...,] flag);
> 
> Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Oleg Nesterov <oleg@redhat.com>
Acked-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...
