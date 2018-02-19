From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH] arm64: Add support for new control bits CTR_EL0.IDC and
 CTR_EL0.IDC
Date: Mon, 19 Feb 2018 17:18:52 +0000
Message-ID: <20180219171852.jsbzawbsyv7v5yi7@armageddon.cambridge.arm.com>
References: <1518829066-3558-1-git-send-email-shankerd@codeaurora.org>
 <20180219143820.5oxc2kendvq4bbtt@armageddon.cambridge.arm.com>
 <92836754-2ab3-d5db-f0be-7ee3e10f368f@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <92836754-2ab3-d5db-f0be-7ee3e10f368f@codeaurora.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Shanker Donthineni <shankerd@codeaurora.org>
Cc: Philip Elcan <pelcan@codeaurora.org>, Vikram Sethi <vikrams@codeaurora.org>, Marc Zyngier <marc.zyngier@arm.com>, Will Deacon <will.deacon@arm.com>, linux-kernel <linux-kernel@vger.kernel.org>, kvmarm <kvmarm@lists.cs.columbia.edu>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Feb 19, 2018 at 10:35:30AM -0600, Shanker Donthineni wrote:
> On 02/19/2018 08:38 AM, Catalin Marinas wrote:
> > On the patch, I'd rather have an alternative framework entry for no VAU
> > cache maint required and some ret instruction at the beginning of the
> > cache maint function rather than jumping out of the loop somewhere
> > inside the cache maintenance code, penalising the CPUs that do require
> > it.
> 
> Alternative framework might break things in case of CPU hotplug. I need one
> more confirmation from you on incorporating alternative framework.     

CPU hotplug can be an issue but it should be handled like other similar
cases: if a CPU comes online late and its features are incompatible, it
should not be brought online. The cpufeature code handles this.

With Will's patch for CTR_EL0, we handle different CPU features during
boot, defaulting to the lowest value for the IDC/DIC bits.

I suggest you add new ARM64_HAS_* feature bits and enable them based on
CTR_EL0.IDC and DIC. You could check for both being 1 with a single
feature bit but I guess an implementation is allowed to have these
different (e.g. DIC == 0 and IDC == 1).

-- 
Catalin
