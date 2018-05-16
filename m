From: Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 08/14] ARM: spectre-v2: harden user aborts in kernel space
Date: Wed, 16 May 2018 09:35:07 -0700
Message-ID: <cdcde1ef-afa0-cf7c-b680-829b54b03042@gmail.com>
References: <20180516105949.GJ16141@n2100.armlinux.org.uk>
 <E1fIuBK-0003q7-9n@rmk-PC.armlinux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <E1fIuBK-0003q7-9n@rmk-PC.armlinux.org.uk>
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

On 05/16/2018 04:01 AM, Russell King wrote:
> In order to prevent aliasing attacks on the branch predictor,
> invalidate the BTB or instruction cache on CPUs that are known to be
> affected when taking an abort on a address that is outside of a user
> task limit:
> 
> Cortex A8, A9, A12, A17, A73, A75: flush BTB.
> Cortex A15, Brahma B15: invalidate icache.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
