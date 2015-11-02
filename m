From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH 0/7] kvmtool: Cleanup kernel loading
Date: Mon, 2 Nov 2015 14:58:47 +0000
Message-ID: <20151102145846.GH29657@arm.com>
References: <1446229620-28088-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1446229620-28088-1-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm-ppc@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Oct 30, 2015 at 06:26:53PM +0000, Andre Przywara wrote:
> Hi,

Hello Andre,

> this series cleans up kvmtool's kernel loading functionality a bit.
> It has been broken out of a previous series I sent [1] and contains
> just the cleanup and bug fix parts, which should be less controversial
> and thus easier to merge ;-)
> I will resend the pipe loading part later on as a separate series.
> 
> The first patch properly abstracts kernel loading to move
> responsibility into each architecture's code. It removes quite some
> ugly code from the generic kvm.c file.
> The later patches address the naive usage of read(2) to, well, read
> data from files. Doing this without coping with the subtleties of
> the UNIX read semantics (returning with less or none data read is not
> an error) can provoke hard to debug failures.
> So these patches make use of the existing and one new wrapper function
> to make sure we read everything we actually wanted to.
> The last patch moves the ARM kernel loading code into the proper
> location to be in line with the other architectures.
> 
> Please have a look and give some comments!

Looks good to me, but I'd like to see some comments from some mips/ppc/x86
people on the changes you're making over there.

Will
