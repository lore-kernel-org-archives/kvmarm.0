From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH 06/12] kvm__set_dir(): avoid variable arguments call
Date: Fri, 17 Jul 2015 17:49:39 +0100
Message-ID: <20150717164939.GD8055@arm.com>
References: <1437148938-5394-1-git-send-email-andre.przywara@arm.com>
 <1437148938-5394-7-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1437148938-5394-7-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Szabolcs Nagy <Szabolcs.Nagy@arm.com>, Marc Zyngier <Marc.Zyngier@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Jul 17, 2015 at 05:02:12PM +0100, Andre Przywara wrote:
> The clang compiler by default dislikes non-literal format strings
> in *printf functions, so it complains about kvm__set_dir() in kvm.c.
> Instead of suppressing this warning, lets change the code to avoid
> that unneeded var_args detour and use a literal format string.

Why does clang moan about this? The current code looks perfectly alright
to me.

Will
