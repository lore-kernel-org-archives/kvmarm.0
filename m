From: Sudeep Holla <sudeep.holla@arm.com>
Subject: Re: [PATCH v2 3/3] arm64: kvm: add support for the extended 64bit
 ccsidr
Date: Fri, 3 Feb 2017 10:44:38 +0000
Message-ID: <d9b2a308-c207-5f92-d855-33339bd28990@arm.com>
References: <1485793527-18028-1-git-send-email-sudeep.holla@arm.com>
 <1485793527-18028-3-git-send-email-sudeep.holla@arm.com>
 <85bd7758-e0a3-f274-ba7a-db080e66d97c@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1C87B40969
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Feb 2017 05:44:19 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7H7c95V-+y14 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  3 Feb 2017 05:44:18 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E39E64092C
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Feb 2017 05:44:17 -0500 (EST)
In-Reply-To: <85bd7758-e0a3-f274-ba7a-db080e66d97c@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Christoffer Dall <christoffer.dall@linaro.org>
Cc: Sudeep Holla <sudeep.holla@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,

On 01/02/17 16:02, Marc Zyngier wrote:
[...]

> 
> I'm a bit worried about this patch. If we snapshot a VM on a 32bit
> CCSIDR system, and restore it on a 64bit CSSIDR system (or the reverse),
> what happens? My hunch is that we cannot restore the VM properly.
>

I agree. I had a look at QEMU as you suggested offline. Looks like QEMU
emulate these registers with predefined values for each core type. Also
it looks like it's not using the existing DEMUX_ID_CCSIDR

> Now, I'm questioning the need for having those altogether, as we do a
> lot of work to prevent the guest from actually using that geometry (and
> on a big-little system, this hardly works).
> 

If we can conclude there are no users for DEMUX_ID_CCSIDR, we can remove
it all together instead of introducing new one for 64bit.

Are there any other users of these interface provided by KVM after from
kvmtool and qemu ?

-- 
Regards,
Sudeep
