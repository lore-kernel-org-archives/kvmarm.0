From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH 01/11] ACPI / APEI: Move the estatus queue code up, and
 under its own ifdef
Date: Fri, 23 Feb 2018 19:07:54 +0100
Message-ID: <20180223180754.GI4981@pd.tnic>
References: <20180215185606.26736-1-james.morse@arm.com>
 <20180215185606.26736-2-james.morse@arm.com>
 <20180220192852.GB24320@pd.tnic> <5A90572D.9010704@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <5A90572D.9010704@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: James Morse <james.morse@arm.com>
Cc: Rafael Wysocki <rjw@rjwysocki.net>, Tony Luck <tony.luck@intel.com>, Xie XiuQi <xiexiuqi@huawei.com>, linux-mm@kvack.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Tyler Baicar <tbaicar@codeaurora.org>, Will Deacon <will.deacon@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, linux-acpi@vger.kernel.org, Punit Agrawal <punit.agrawal@arm.com>, linux-arm-kernel@lists.infradead.org, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, kvmarm@lists.cs.columbia.edu, Christoffer Dall <christoffer.dall@linaro.org>, Len Brown <lenb@kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Feb 23, 2018 at 06:02:21PM +0000, James Morse wrote:
> Sure. I reckon your English grammar is better than mine, is this better?:

Bah, you must be joking :-)

> | In any NMI-like handler, memory from ghes_estatus_pool is used to save
> | estatus, and added to the ghes_estatus_llist. irq_work_queue() causes
> | ghes_proc_in_irq() to run in IRQ context where each estatus in
> | ghes_estatus_llist are processed. Each NMI-like error source must grow

s/are/is/ reads better to me, for some reason :)

> | the ghes_estatus_pool to ensure memory is available.

Other than that, yap, much better!

Thx.

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
