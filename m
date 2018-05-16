From: Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 04/14] ARM: bugs: add support for per-processor bug
 checking
Date: Wed, 16 May 2018 09:23:45 -0700
Message-ID: <5f5ae660-ab61-603f-1dfe-7a0434b4da47@gmail.com>
References: <20180516105949.GJ16141@n2100.armlinux.org.uk>
 <E1fIuAz-0003k5-OP@rmk-PC.armlinux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <E1fIuAz-0003k5-OP@rmk-PC.armlinux.org.uk>
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
To: Russell King <rmk+kernel@armlinux.org.uk>, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 05/16/2018 04:00 AM, Russell King wrote:
> Add support for per-processor bug checking - each processor function
> descriptor gains a function pointer for this check, which must not be
> an __init function.  If non-NULL, this will be called whenever a CPU
> enters the kernel via which ever path (boot CPU, secondary CPU startup,
> CPU resuming, etc.)
> 
> This allows processor specific bug checks to validate that workaround
> bits are properly enabled by firmware via all entry paths to the kernel.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
