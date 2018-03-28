From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v2 08/11] firmware: arm_sdei: Add ACPI GHES registration
 helper
Date: Wed, 28 Mar 2018 17:33:30 +0100
Message-ID: <590e2665-4471-8795-675e-28d103e1a103@arm.com>
References: <20180322181445.23298-9-james.morse@arm.com>
 <201803250913.XCBc2k7m%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <201803250913.XCBc2k7m%fengguang.wu@intel.com>
Content-Language: en-US
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: linux-acpi@vger.kernel.org
Cc: Rafael Wysocki <rjw@rjwysocki.net>, Tony Luck <tony.luck@intel.com>, Christoffer Dall <cdall@kernel.org>, Punit Agrawal <punit.agrawal@arm.com>, Xie XiuQi <xiexiuqi@huawei.com>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Tyler Baicar <tbaicar@codeaurora.org>, Will Deacon <will.deacon@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, linux-mm@kvack.org, Borislav Petkov <bp@alien8.de>, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Len Brown <lenb@kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi kbuild test robot,

On 25/03/18 02:41, kbuild test robot wrote:
> I love your patch! Yet something to improve:
> 
> [auto build test ERROR on pm/linux-next]
> [also build test ERROR on v4.16-rc6]
> [cannot apply to arm64/for-next/core next-20180323]

This is the potential conflict I referred to in v1's cover letter...


> All errors (new ones prefixed by >>):
> 
>    drivers//firmware/arm_sdei.c: In function 'sdei_register_ghes':
>>> drivers//firmware/arm_sdei.c:921:26: error: 'FIX_APEI_GHES_SDEI_CRITICAL' undeclared (first use in this function)
>       ghes->nmi_fixmap_idx = FIX_APEI_GHES_SDEI_CRITICAL;

Looks like I forgot to include asm/fixmap.h! I hate header-soup.


Thanks,

James
