From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v4 3/4] irqchip: GIC: Convert to EOImode == 1
Date: Thu, 10 Sep 2015 17:30:09 +0100
Message-ID: <55F1B011.6090204@arm.com>
References: <1440604845-28229-1-git-send-email-marc.zyngier@arm.com> <1440604845-28229-4-git-send-email-marc.zyngier@arm.com> <55F08731.3050402@citrix.com> <55F15353.2000800@arm.com> <55F1AE75.6000405@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <55F1AE75.6000405@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Julien Grall <julien.grall@citrix.com>, Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>, Pranavkumar Sawargaonkar <pranavkumar@linaro.org>
Cc: kvm@vger.kernel.org, Eric Auger <eric.auger@linaro.org>, linux-kernel@vger.kernel.org, Jiang Liu <jiang.liu@linux.intel.com>, Christoffer Dall <christoffer.dall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Stefano Stabellini <stefano.stabellini@eu.citrix.com>, Ian Campbell <ian.campbell@citrix.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 10/09/15 17:23, Julien Grall wrote:
> On 10/09/15 10:54, Marc Zyngier wrote:

[...]

>> In the meantime, can you give the following patch a shot? My Mustang is 
>> wired to a 4kB CPU interface, so I'll need your help to test it.
> 
> I applied the two patches on top of linus/master and I'm able to boot
> correctly on X-gene. Thank you!

Thanks for testing. Can I put your Tested-by tag on the patch when I
send it to Thomas?

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
