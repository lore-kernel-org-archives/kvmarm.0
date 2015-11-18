From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH 0/7] kvmtool: Cleanup kernel loading
Date: Wed, 18 Nov 2015 17:08:04 +0000
Message-ID: <20151118170804.GJ1588@arm.com>
References: <1446229620-28088-1-git-send-email-andre.przywara@arm.com>
 <20151102145846.GH29657@arm.com>
 <564C530A.3010604@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <564C530A.3010604@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm-ppc@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Nov 18, 2015 at 10:29:30AM +0000, Andre Przywara wrote:
> On 02/11/15 14:58, Will Deacon wrote:
> > On Fri, Oct 30, 2015 at 06:26:53PM +0000, Andre Przywara wrote:
> >> this series cleans up kvmtool's kernel loading functionality a bit.
> >> It has been broken out of a previous series I sent [1] and contains
> >> just the cleanup and bug fix parts, which should be less controversial
> >> and thus easier to merge ;-)
> >> I will resend the pipe loading part later on as a separate series.
> >>
> >> The first patch properly abstracts kernel loading to move
> >> responsibility into each architecture's code. It removes quite some
> >> ugly code from the generic kvm.c file.
> >> The later patches address the naive usage of read(2) to, well, read
> >> data from files. Doing this without coping with the subtleties of
> >> the UNIX read semantics (returning with less or none data read is not
> >> an error) can provoke hard to debug failures.
> >> So these patches make use of the existing and one new wrapper function
> >> to make sure we read everything we actually wanted to.
> >> The last patch moves the ARM kernel loading code into the proper
> >> location to be in line with the other architectures.
> >>
> >> Please have a look and give some comments!
> > 
> > Looks good to me, but I'd like to see some comments from some mips/ppc/x86
> > people on the changes you're making over there.
> 
> Sounds reasonable, but no answers yet.
> 
> Can you take at least patch 1 and 2 meanwhile, preferably 6 and 7 (the
> ARM parts) also if you are OK with it?
> I have other patches that depend on 1/7 and 2/7, so having them upstream
> would help me and reduce further dependency churn.
> I am happy to resend the remaining patches for further discussion later.

We let them sit on the list for a while with no comments, so I just pushed
out your series. If a bug report shows up, then we can always revert the
offending patch if there's no quick fix.

Will
