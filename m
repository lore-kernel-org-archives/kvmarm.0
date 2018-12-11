From: Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [PATCH v7 2/5] arm64: KVM: encapsulate kvm_cpu_context in
 kvm_host_data
Date: Tue, 11 Dec 2018 14:40:07 +0100
Message-ID: <20181211134007.GZ30263@e113682-lin.lund.arm.com>
References: <1544530420-1477-1-git-send-email-andrew.murray@arm.com>
 <1544530420-1477-3-git-send-email-andrew.murray@arm.com>
 <20181211122951.GY30263@e113682-lin.lund.arm.com>
 <20181211131127.GE13393@e119886-lin.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0B0BF4A1DF
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Dec 2018 08:40:11 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mEqOGIRR0jYB for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 Dec 2018 08:40:09 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B6CFB4A1DD
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Dec 2018 08:40:09 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20181211131127.GE13393@e119886-lin.cambridge.arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Murray <andrew.murray@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Dec 11, 2018 at 01:11:33PM +0000, Andrew Murray wrote:
> On Tue, Dec 11, 2018 at 01:29:51PM +0100, Christoffer Dall wrote:
> > On Tue, Dec 11, 2018 at 12:13:37PM +0000, Andrew Murray wrote:
> > > The virt/arm core allocates a percpu structure as per the kvm_cpu_context_t
> > > type, at present this is typedef'd to kvm_cpu_context and used to store
> > > host cpu context. The kvm_cpu_context structure is also used elsewhere to
> > > hold vcpu context. In order to use the percpu to hold additional future
> > > host information we encapsulate kvm_cpu_context in a new structure.
> > > 
> > > Signed-off-by: Andrew Murray <andrew.murray@arm.com>
> > > ---
> > >  arch/arm64/include/asm/kvm_host.h | 8 ++++++--
> > >  arch/arm64/kernel/asm-offsets.c   | 3 ++-
> > >  virt/kvm/arm/arm.c                | 4 +++-
> > >  3 files changed, 11 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > > index 1550192..bcf9d60 100644
> > > --- a/arch/arm64/include/asm/kvm_host.h
> > > +++ b/arch/arm64/include/asm/kvm_host.h
> > > @@ -205,7 +205,11 @@ struct kvm_cpu_context {
> > >  	struct kvm_vcpu *__hyp_running_vcpu;
> > >  };
> > >  
> > > -typedef struct kvm_cpu_context kvm_cpu_context_t;
> > > +struct kvm_host_data {
> > > +	struct kvm_cpu_context __kvm_cpu_state;
> > > +};
> > > +
> > > +typedef struct kvm_host_data kvm_cpu_context_t;
> > 
> > Now I'm confused based on the conversation on the last version.
> > 
> > I think it's bizarre to use the typedef to rename things in this way.
> > 
> > Can you please make this:
> > 
> >    struct kvm_cpu_context;
> >    typedef struct kvm_cpu_context kvm_cpu_context_t;
> > 
> >    struct kvm_host_data;
> >    typedef struct kvm_host_data kvm_host_data_t;
> > 
> > And change the code with the fallout from that.
> 
> I guess I was trying to avoid similar naming issues on arm32. If we
> make the above changes (and thus the DEFINE_PER_CPU in virt/kvm/arm/arm.c)
> then we need to change arm (arch/arm/include/asm/kvm_host.h) such that:
> 
> typedef struct kvm_cpu_context kvm_cpu_context_t;
> 
> becomes:
> 
> typedef struct kvm_cpu_context kvm_host_data_t;
> 
> though I guess this may be acceptable?

I'd prefer it if you just introduce a struct kvm_host_data on the 32-bit
side only containing a struct kvm_cpu_context (if you wanted to support
perf on the 32-bit side you would also add additional fields to it,
similar to arm64).  That avoids the confusing typedef and you get the
symmmetry on both architectures allowing you to use shared code, which
is what we want at the end of the day.

So, on the 32-bit side, change this to:

struct kvm_host_data {
	struct kvm_cpu_context *host_ctxt;
};
typedef struct kvm_host_data kvm_host_data_t;


And use the same naming on both 32-bit and 64-bit arm, consistently.


Thanks,

    Christoffer
