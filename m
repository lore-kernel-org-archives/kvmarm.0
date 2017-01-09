From: Russell King - ARM Linux <linux@armlinux.org.uk>
Subject: Re: [PATCH 1/2] ARM: hyp-stub: improve ABI
Date: Mon, 9 Jan 2017 14:10:59 +0000
Message-ID: <20170109141059.GB14217@n2100.armlinux.org.uk>
References: <72f93940-cf87-fd91-90f2-760b7ff050fb@arm.com>
 <20161215113539.GK14217@n2100.armlinux.org.uk>
 <06fca797-da5d-f7f2-eecb-9b1b33b7e83f@arm.com>
 <20161215151548.GL14217@n2100.armlinux.org.uk>
 <c21d6514-44a2-ba88-0fe5-d14d5897cc48@arm.com>
 <20161215185717.GM14217@n2100.armlinux.org.uk>
 <20170103095149.GA14242@cbox>
 <20170109122639.GX14217@n2100.armlinux.org.uk>
 <20170109132636.GH4348@cbox>
 <20170109140500.GA14217@n2100.armlinux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F0BB402AF
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 09:09:30 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hKkRAtI6-tCR for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Jan 2017 09:09:29 -0500 (EST)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [78.32.30.218])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 068EA40284
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 09:09:28 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20170109140500.GA14217@n2100.armlinux.org.uk>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, dave.martin@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Jan 09, 2017 at 02:05:00PM +0000, Russell King - ARM Linux wrote:
> So, although Marc produced a patch which updates the KVM hypervisor for
> the GET_VECTORS change, through reading the code today, it's become clear
> that much more is needed, so I'm yet again banging on about documentation.
> It's only become clear to me today that the KVM stub calling convention
> for the host kernel is:
> 
> entry:
> 	r0 = function pointer
> 	r1 = 32-bit function argument 0
> 	r2 = 32-bit function argument 1
> 	r3 = 32-bit function argument 2
> 	no further arguments are supported
> 	--- or ---
> 	r0 = -1 (or 0 post Marc's patch) for get_vectors
> exit:
> 	r0 = vectors (if get_vectors call was made)
> 	otherwise, who knows...
> 
> I specify "32-bit" there because they're shifted by one register, which,
> if a 64-bit argument is passed with EABI, the arguments will no longer be
> appropriately aligned... so it's an important detail to be aware of with
> the current KVM hypervisor interface.
> 
> What I want to do here is to fix this kexec issue completely, not in a
> piecemeal fashion - I'm not interested in fixing one small problem, then
> coming back to it in a few months time to fix another problem.  That's a
> waste of time (well, unless you're into job creation.)  I've always been
> for "if you're going to do the job, damn well do the job properly".  So
> I'm not going to accept anything short of fixing _both_ kexec and kdump
> together.
> 
> So, given that the hyp-stub has this ABI after my patches:
> 
> entry:
> 	r0 = argument (0 = get vectors, 1 = set vectors, 2 = call function)
> 	r1 = vectors for r0 = 1
> 	r3 = function pointer (with bit 0 already set for thumb functions)
> 	     for r0 = 2
> exit:
> 	r0 = -1 for invalid calls
> 	r0 = current vectors address (for r0 = 0 on entry)
> 	is not expected to return for r0 = 2 on entry
> 	otherwise registers preserved preserved
> 
> which is clearly incompatible with the current KVM stub, can we come up
> with a common ABI that is satisfactory to both.
> 
> The above are probably the very first time anyone has written out the
> ABI of these things, and as can be seen, it's still something of a mess.

For completeness, this is the existing hyp-stub ABI:

entry:
	r0 = -1 => get_vectors
	r0 != -1 => set_vectors (to the value in r0)
exit:
	r0 = current vector address

And that's it.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
