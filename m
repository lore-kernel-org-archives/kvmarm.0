From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v6 0/6] Add ARMv8.3 pointer authentication for kvm guest
Date: Tue, 26 Feb 2019 18:03:56 +0000
Message-ID: <7dac868e-c0dc-ce20-a183-b42f694ffb12@arm.com>
References: <1550568271-5319-1-git-send-email-amit.kachhap@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1550568271-5319-1-git-send-email-amit.kachhap@arm.com>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Amit Daniel Kachhap <amit.kachhap@arm.com>, linux-arm-kernel@lists.infradead.org
Cc: Christoffer Dall <christoffer.dall@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andrew Jones <drjones@redhat.com>, Dave Martin <Dave.Martin@arm.com>, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, kvmarm@lists.cs.columbia.edu, Kristina Martsenko <kristina.martsenko@arm.com>, linux-kernel@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>, Julien Thierry <julien.thierry@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Amit,

On 19/02/2019 09:24, Amit Daniel Kachhap wrote:
> This patch series adds pointer authentication support for KVM guest and
> is based on top of Linux 5.0-rc6. The basic patches in this series was
> originally posted by Mark Rutland earlier[1,2] and contains some history
> of this work.
> 
> Extension Overview:
> =============================================
> 
> The ARMv8.3 pointer authentication extension adds functionality to detect
> modification of pointer values, mitigating certain classes of attack such as
> stack smashing, and making return oriented programming attacks harder.
> 
> The extension introduces the concept of a pointer authentication code (PAC),
> which is stored in some upper bits of pointers. Each PAC is derived from the
> original pointer, another 64-bit value (e.g. the stack pointer), and a secret
> 128-bit key.
> 
> New instructions are added which can be used to:
> 
> * Insert a PAC into a pointer
> * Strip a PAC from a pointer
> * Authenticate and strip a PAC from a pointer
> 
> The detailed description of ARMv8.3 pointer authentication support in
> userspace/kernel and can be found in Kristina's generic pointer authentication
> patch series[3].


> This patch series is based on just a single patch from Dave Martin [8] which add
> control checks for accessing sys registers. 

Ooeer, If you miss this patch, (like I did) the series still applies to rc6, it just
doesn't build. If you depend on extra patches like this, please re-post them as part of
the series. (you need to add your Signed-off-by if picked the patch up from the list).

This lets people apply the series from the list (everyone has a script to to do this),
without having to go and find the dependencies.


> [8]: https://lore.kernel.org/linux-arm-kernel/1547757219-19439-13-git-send-email-Dave.Martin@arm.com/

This is v4 of Dave's patch. He changed the subject and posted a v5 here:
https://lore.kernel.org/linux-arm-kernel/1550519559-15915-13-git-send-email-Dave.Martin@arm.com/

Re-posting the patch you tested with would avoid someone accidentally pickup v5, then
trying to work out how its supposed to work with your series. (check_present() was
replaced by a restrictions() bitmask).


As we can't have both, and v5 of that patch has been reviewed, could you rebase onto it?
You'll need to pick up any tags and make any changes reviewers asked for. If you could
note 'this v7 patch is Dave's v5 with $changes', then it makes it clear what is going on.



Thanks,

James
