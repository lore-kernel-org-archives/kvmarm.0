From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v3 07/12] ACPI / APEI: Make the nmi_fixmap_idx per-ghes
 to allow multiple in_nmi() users
Date: Thu, 17 May 2018 15:39:24 +0200
Message-ID: <20180517133924.GB27738@pd.tnic>
References: <20180427153510.5799-1-james.morse@arm.com>
 <20180427153510.5799-8-james.morse@arm.com>
 <20180505122719.GE3708@pd.tnic>
 <1511cfcc-dcd1-b3c5-01c7-6b6b8fb65b05@arm.com>
 <20180516110348.GA17092@pd.tnic>
 <39bde8c5-4dfb-c1b9-02a4-ba467539ea24@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <39bde8c5-4dfb-c1b9-02a4-ba467539ea24@codeaurora.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Tyler Baicar <tbaicar@codeaurora.org>
Cc: jonathan.zhang@cavium.com, Rafael Wysocki <rjw@rjwysocki.net>, Tony Luck <tony.luck@intel.com>, Thomas Gleixner <tglx@linutronix.de>, Christoffer Dall <cdall@kernel.org>, Punit Agrawal <punit.agrawal@arm.com>, linux-mm@kvack.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Xie XiuQi <xiexiuqi@huawei.com>, Will Deacon <will.deacon@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, linux-acpi@vger.kernel.org, James Morse <james.morse@arm.com>, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Len Brown <lenb@kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, May 16, 2018 at 11:38:16AM -0400, Tyler Baicar wrote:
> I haven't seen a deadlock from that, but it looks possible. What if
> the ghes_proc() call in ghes_probe() is moved before the second switch
> statement? That way it is before the NMI/IRQ/poll is setup. At quick
> glance I think that should avoid the deadlock and still provide the
> functionality that call was added for. I can test that out if you all
> agree.

Makes sense but please audit it properly before doing the change. That
code is full of landmines and could use a proper scrubbing first.

Thx.

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
