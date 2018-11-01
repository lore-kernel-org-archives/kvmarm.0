From: Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [PATCH 00/13] kvm: selftests: add aarch64 framework and dirty
Date: Thu, 1 Nov 2018 10:08:25 +0100
Message-ID: <20181101090825.GI12057@e113682-lin.lund.arm.com>
References: <20180918175436.19742-1-drjones@redhat.com>
 <20181029174002.GB12057@e113682-lin.lund.arm.com>
 <20181030173820.3v2czxqkeaicfqtn@kamzik.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6657A4A2E8
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Nov 2018 05:08:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id C6nVNA+U9A+P for <kvmarm@lists.cs.columbia.edu>;
 Thu,  1 Nov 2018 05:08:29 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D42204A2E5
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Nov 2018 05:08:28 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20181030173820.3v2czxqkeaicfqtn@kamzik.brq.redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Jones <drjones@redhat.com>
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Oct 30, 2018 at 06:38:20PM +0100, Andrew Jones wrote:
> 
> Hi Christoffer,
> 
> Thanks for your interest in these tests. There isn't any documentation
> that I know of, but it's a good idea to have some. I'll write something
> up soon. I'll also try to answer your questions now.
> 

That sounds great, thanks!

> On Mon, Oct 29, 2018 at 06:40:02PM +0100, Christoffer Dall wrote:
> > Hi Drew,
> > 
> > On Tue, Sep 18, 2018 at 07:54:23PM +0200, Andrew Jones wrote:
> > > This series provides KVM selftests that test dirty log tracking on
> > > AArch64 for both 4K and 64K guest page sizes. Additionally the
> > > framework provides an easy way to test dirty log tracking with the
> > > recently posted dynamic IPA and 52bit IPA series[1].
> > 
> > I was trying to parse the commit text of patch 2, and I realized that I
> > don't understand the 'hypercall to userspace' thing at all, which
> > probably means I have no idea how the selftests work overall.
> 
> There are three parts to a kvm selftest: 1) the test code which runs in
> host userspace and _is_ the kvm userspace used with kvm, 2) the vcpu
> thread code which executes KVM_RUN for the guest code and possibly also
> some host userspace test code, and 3) the guest code, which is naturally
> run in the vcpu thread, but in guest mode.
> 
> The need for a "ucall" arises for 2's "possibly also some host userspace
> test code". In that case the guest code needs to invoke an exit from guest
> mode, not just to kvm, but all the way to kvm userspace. For AArch64, as
> you know, this can be done with an MMIO access. The reason patch 2
> generalizes the concept is because for x86 this can and is done with a
> PIO access.
> 

So in the world of normal KVM userspace, (2) would be a thread in the
same process as (1), sharing its mm.  Is this a different setup somehow,
why?

> > 
> > I then spent a while reading various bits of documentation in the kernel
> > tree, LWN, etc., only to realize that I don't understand how this test
> > framework actually works.
> > 
> > Are the selftests modules, userspace programs, or code that is compiled
> > with the kernel, and (somehow?) run from userspace.  I thought the
> > latter, partially based on your explanation at ELC, but then I don't
> > understand how the "compile and run" make target works.
> 
> The tests are standalone userspace programs which are compiled separately,
> but have dependencies on kernel headers. As stated above, for kvm, each
> selftest is a kvm userspace (including its vcpu thread code) and guest
> code combined. While there's a lot of complexity in the framework,
> particularly for memory management, and a bit for vcpu setup, most of that
> can be shared among tests using the kvm_util.h and test_util.h APIs,
> allowing a given test to only have a relatively simple main(), vcpu thread
> "vcpu_worker()" function, and "guest_code()" function. Guest mode code can
> easily share code with the kvm userspace test code (assuming the guest
> page tables are set up in the default way) and even data can be shared as
> long the accesses are done with the appropriate mappings (gva vs. hva).
> There's a small API to help with that as well.
> 

Sounds cool.  Beware of the attributes of the mappings such that both
the guest and host have mapped the memory cacheable etc., but I'm sure
you've thought of that already.

> > 
> > Can you help me paint the overall picture, or point me to the piece of
> > documentation/presentation that explains the high-level picture, which I
> > must have obviously missed somehow?
> 
> We definitely need the documentation and, in hindsight, it looks like it
> would have been a good BoF topic last week too.

An overview of the different testing approaches would be a good KVM
Forum talk for next year, IMHO.  When should you use kvm-unit-tests, and
when should you use kselftests, some examples, etc.  Just saying ;)

> 
> I think this framework has a lot of potential for KVM API testing and
> even for quick & dirty guest code instruction sequence tests (although
> instruction sequences would also fit kvm-unit-tests). I hope I can help
> get you and anyone else interested started.
> 

I'll have a look at this series and glance at the code some more, it
would be interesting to consider if using some of this for nested virt
tests makes sense.


Thanks,

    Christoffer
