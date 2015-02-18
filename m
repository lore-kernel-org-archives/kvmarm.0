From: Will Deacon <will.deacon@arm.com>
Subject: Re: stand-alone kvmtool
Date: Wed, 18 Feb 2015 15:50:42 +0000
Message-ID: <20150218155042.GF22017@arm.com>
References: <54DDD465.3050300@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <54DDD465.3050300@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>
Cc: Pekka Enberg <penberg@kernel.org>, Sasha Levin <sasha.levin@oracle.com>, Cyrill Gorcunov <gorcunov@gmail.com>, Asias He <asias.hejun@gmail.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Marc Zyngier <Marc.Zyngier@arm.com>, Ronald Minnich <rminnich@google.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Andre,

Thanks for doing this. Since it looks unlikely that kvmtool will ever be
merged back into the kernel tree, it makes sense to cut the dependency
in my opinion.

On Fri, Feb 13, 2015 at 10:39:33AM +0000, Andre Przywara wrote:
> as I found it increasingly inconvenient to use kvmtool[1] as part of a
> Linux repository, I decided to give it a go and make it a stand-alone
> project. So I filtered all the respective commits, adjusted the paths in
> there (while keeping authorship and commit date, of course) and then
> added the missing bits to let it compile without a kernel tree nearby.
> The result is now available on:
> 
> git://linux-arm.org/kvmtool.git
> http://linux-arm.org/kvmtool.git
> 
> You can simply check it out, type make and use "./lkvm run" for a quick
> test. So far I briefly tested x86-64, arm and arm64, the later two were
> also cross-compiled. For sure there are rough edges in there (for
> instance copying a few non-uapi header files into), but I deem it worthy
> enough to get some public comments.
> For me that also fixed some nasty warnings about libfdt, which now are
> gone due it using your system library version of it.
> I also managed to get rid of the libc-i386-dev dependency when compiling
> for x86-64, but that still needs to be cleaned up and thus is not in the
> current HEAD.
> I haven't got around to compile-test the other supported architectures,
> but supporting them should be as easy as copying over the uapi kvm.h
> header file (see the respective ARM commit). Contributions (and tests!)
> are welcome.
> 
> Please give it a go and tell me what you think. I don't want to fork the
> project, so I am happy if someone "official" picks it up.

In which case, it's probably best to post the patches for review rather
than just point me at your git repo!

Will
